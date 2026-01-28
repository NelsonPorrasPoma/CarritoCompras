<%-- 
    Document   : almacen
    Created on : 18 sept. 2024, 17:22:29
    Author     : UsuarioTK
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Producto"%>
<%@page import="modelo.Categoria"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Almacen | XCEL_SERVER</title>
        <link rel="stylesheet" href="css/estilosGenerales.css">
        <link rel="stylesheet" href="css/estilosAlmacen.css">
    </head>
    <body>
        <header>
            <nav> 
                <ul class="nav-center">
                    <% if (usuario == null) { %> 
                    <li><a href="productos.jsp">PRODUCTOS</a></li>
                    <li><a href="nosotros.jsp">NOSOTROS</a></li>
                    <li><a href="carrito.jsp">CARRITO</a></li>
                    <li><a href="contacto.jsp">CONTACTO</a></li>
                        <% } else { %>
                        <% if ("CLIENTE".equals(rol)) { %> 
                    <li><a href="productos.jsp">PRODUCTOS</a></li>
                    <li><a href="nosotros.jsp">NOSOTROS</a></li>
                    <li><a href="carrito.jsp">CARRITO</a></li>                           
                <li><a href="mispedidos.jsp">MIS PEDIDOS</a></li>
                    <li><a href="contacto.jsp">CONTACTO</a></li>
                        <% } else if ("EMPLEADO".equals(rol)) { %>
                    <li><a href="nosotros.jsp">NOSOTROS</a></li>
                    <li><a href="pedidos.jsp">PEDIDOS</a></li>
                    <li><a href="reporte.jsp">REPORTE</a></li>
                        <% } else if ("ADMINISTRADOR".equals(rol)) { %>
                    <li><a href="nosotros.jsp">NOSOTROS</a></li>
                    <li><a href="pedidos.jsp">PEDIDOS</a></li>
                    <li><a href="reporte.jsp">REPORTE</a></li>
                    <li><a href="usuarios.jsp">USUARIOS</a></li>
                    <li><a href="almacen.jsp">ALMACÉN</a></li>
                        <% } %>
                    <li><a href="ajustes.jsp">AJUSTES</a></li>
                        <% } %>
                </ul>

                <ul class="nav-right">
                    <% if (usuario == null) { %>
                    <li><a href="login.jsp">INICIAR SESIÓN</a></li>
                        <% } else { %>
                    <li><a href="LogoutServlet">CERRAR SESIÓN</a></li>
                        <% } %>
                </ul>
            </nav>
        </header>

        <div class="contenedor-principal">
            <!-- Cuadro 1: Buscar productos -->
            <div class="cuadro" id="buscar-productos">
                <h2>Buscar Productos</h2>
                <form action="ProductosServlet" method="get">
                    <input type="hidden" name="action" value="buscarAlmacen">

                    <label for="buscarNombre">Nombre:</label>
                    <input type="text" id="buscarNombre" name="buscarNombre">
                    <button type="submit">Buscar</button>
                </form>
            </div>
            <!-- Cuadro 3: Resultados de la búsqueda -->
            <div class="cuadro" id="resultados-busqueda">
                <h2>Resultados de Búsqueda</h2>
                <div class="productos-grid">
                    <c:forEach var="producto" items="${productos}">
                        <div class="producto-item">
                            <img src="${producto.imagen}" alt="${producto.nombre}">
                            <h3>${producto.nombre}</h3>
                            <p>${producto.descripcion}</p>
                            <p>Stock: ${producto.stock}</p>
                            <p>Precio: S/${producto.precio}</p>
                            <form action="ProductosServlet" method="post">
                                <input type="hidden" name="id" value="${producto.id}">
                                <button type="submit" name="action" value="cargar">Seleccionar</button>
                                <button type="submit" name="action" value="eliminar">Eliminar</button>
                            </form>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <!-- Cuadro 2: Agregar/Editar productos -->
            <div class="cuadro" id="agregar-editar-producto">
                <h2>Agregar/Editar Producto</h2>
                <form action="ProductosServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="id" value="${producto.id}">
                    <label for="nombre">Nombre:</label>
                    <input type="text" id="nombre" name="nombre" value="${producto.nombre}" required>
                    <label for="descripcion">Descripción:</label>
                    <input type="text" id="descripcion" name="descripcion" value="${producto.descripcion}" required>
                    <label for="stock">Stock:</label>
                    <input type="number" id="stock" name="stock" value="${producto.stock}" required>
                    <label for="categoria">Categoría:</label>
                    <select id="categoria" name="categoria" required>
                        <option value="">Seleccionar</option>
                        <c:forEach var="categoria" items="${categorias}">
                            <option value="${categoria.id}" ${producto.categoria == categoria.id ? 'selected' : ''}>${categoria.nombre}</option>
                        </c:forEach>
                    </select>
                    <label for="imagen">Imagen del Producto:</label>
                    <input type="file" id="imagen" name="imagen">
                    <label for="precio">Precio:</label>
                    <input type="number" step="0.01" id="precio" name="precio" value="${producto.precio}" required>
                    <button type="submit" name="action" value="guardar">Guardar</button>
                    <button type="submit" name="action" value="editar">Editar</button>
                </form> 
            </div>
        </div> 
        <footer>
            <p>&copy; 2024 XCEL_SERVER. Todos los derechos reservados.</p>
        </footer>
    </body>
</html>
