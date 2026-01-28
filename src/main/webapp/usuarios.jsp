<%-- 
    Document   : clientes
    Created on : 18 sept. 2024, 17:22:44
    Author     : UsuarioTK
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.DatosPersonales"%>
<%@page import="modelo.Rol"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% 
String usuario = (String) session.getAttribute("usuario");
String rol = (String) session.getAttribute("rol");

List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
DatosPersonales datosPersonales = (DatosPersonales) request.getAttribute("datosPersonales");
Usuario usuarioSeleccionado = (Usuario) request.getAttribute("usuarioSeleccionado");
List<Rol> roles = (List<Rol>) request.getAttribute("roles");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Usuarios | XCEL_SERVER</title>
    <link rel="stylesheet" href="css/estilosGenerales.css">
    <link rel="stylesheet" href="css/estilosUsuarios.css">
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
   </header>
</header>
    <main>
        <div class="contenedor-principal">
            <!-- Cuadro 1: Buscar usuarios -->
            <div class="cuadro" id="buscar-usuarios">
                <h2>Buscar Usuarios</h2>
                <form action="UsuarioServlet" method="get">
                    <input type="hidden" name="action" value="buscarUsuario">
                    <label for="buscarUsuarioNombre">Nombre de usuario:</label>
                    <input type="text" id="buscarUsuarioNombre" name="buscarUsuarioNombre">
                    <button type="submit">Buscar</button>
                </form>
            </div>
            <!-- Cuadro 3: Resultados de la búsqueda -->
            <div class="cuadro" id="resultados-busqueda">
                <h2>Resultados de Búsqueda</h2>
                <div class="usuarios-grid">
                    <c:forEach var="usuario" items="${usuarios}">
                        <div class="usuario-item">
                            <h3>${usuario.usuario}</h3>
                            <p>Rol: ${usuario.rol}</p>
                            <form action="UsuarioServlet" method="post">
                                <input type="hidden" name="id" value="${usuario.id}">
                                <button type="submit" name="action" value="cargar">Seleccionar</button>                                
                                <button type="submit" name="action" value="eliminar">Eliminar</button>
                            </form>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <!-- Cuadro 2: Agregar/Editar usuarios -->
            <div class="cuadro" id="registro"> 
                <h2>Registro de Usuario</h2>
                <form action="UsuarioServlet" method="post" class="form-registro">
                    <input type="hidden" name="id" value="${usuarioSeleccionado.id}"> 
                    <input type="text" id="nombre" name="nombre" value="${datosPersonales.nombre}" required placeholder="Nombre"> 
                    <input type="text" id="apellidos" name="apellidos" value="${datosPersonales.apellidos}" required placeholder="Apellidos"> 
                    <input type="text" id="docIdentidad" name="docIdentidad" value="${datosPersonales.docIdentidad}" required placeholder="Documento de Identidad">                 
                    <input type="text" id="direccion" name="direccion" value="${datosPersonales.direccion}" required placeholder="Dirección"> 
                    <input type="text" id="telefono" name="telefono" value="${datosPersonales.telefono}" required placeholder="Teléfono"> 
                    <input type="email" id="correo" name="correo" value="${datosPersonales.correo}" required placeholder="Correo Electrónico" > 
                    <input type="text" id="usuario" name="usuario" value="${usuarioSeleccionado.usuario}" required placeholder="Usuario"> 
                    <input type="password" id="contrasena" name="contrasena" value="${usuarioSeleccionado.contrasena}" required placeholder="Contraseña">
                    <label for="rol">Rol:</label>
                    <select id="rol" name="rol" required>
                        <option value="">Seleccionar</option>
                        <c:forEach var="rol" items="${roles}">
                            <option value="${rol.id}" ${usuarioSeleccionado.rol == rol.id ? 'selected' : ''}>${rol.rolNombre}</option>
                        </c:forEach>
                    </select>
                    <button type="submit" name="action" value="guardar">Guardar</button>
                    <button type="submit" name="action" value="editar">Editar</button>
                </form>
                <% if (request.getAttribute("error") != null) { %>
                    <p class="error-message"><%= request.getAttribute("error") %></p>
                <% } %>
            </div>
        </div>
        </main> 
    <footer>
        <p>&copy; 2024 XCEL_SERVER. Todos los derechos reservados.</p>
    </footer>
</body>
</html>
