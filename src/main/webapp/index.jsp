<%-- 
    Document   : productos
    Created on : 18 sept. 2024, 17:23:39
    Author     : UsuarioTK
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Categoria"%>
<%@page import="modelo.Producto"%>
<%@page import="DAO.CategoriaDAO"%>
<%@page import="DAO.ProductoDAO"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");

    // Obtener categorías y productos
    CategoriaDAO categoriaDAO = new CategoriaDAO();
    ProductoDAO productoDAO = new ProductoDAO();
    List<Categoria> categorias = categoriaDAO.obtenerCategorias();
    List<Producto> productos = (List<Producto>) request.getAttribute("productos");
    if (productos == null) {
        productos = productoDAO.obtenerTodosProductos();
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Productos | XCEL_SERVER</title>
        <link rel="stylesheet" href="css/estilosGenerales.css">
        <link rel="stylesheet" href="css/estilosProductos.css"> 

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
        <!-- Sección de productos y búsqueda -->
        <section id="productos-busqueda">
            <!-- Formulario de búsqueda -->
            <div id="buscar-productos">
                <h2>BUSCAR PRODUCTO</h2>
                <form action="ProductosServlet" method="get" class="form-busqueda">
                    <input type="hidden" name="action" value="buscarProductos">

                    <div class="form-group">
                        <label for="nombre">Nombre:</label>
                        <input type="text" id="nombre" name="buscarNombre" placeholder="Buscar por nombre" />
                    </div>

                    <div class="form-group">
                        <label for="categoria">Categoría:</label>
                        <select id="categoria" name="buscarCategoria">
                            <option value="">Todas</option>
                            <% for (Categoria categoria : categorias) { %>
                            <option value="<%= categoria.getId() %>"><%= categoria.getNombre() %></option>
                            <% } %>
                        </select>
                    </div>

                    <button type="submit" class="btn-agregar">Buscar</button>
                </form>

            </div>

            <!-- Sección de productos -->
            <div id="buscar-productos">
                <h2>PRODUCTOS</h2>
                <div class="productos-grid">
                    <% for (Producto producto : productos) { %>
                    <div class="producto-item">
                        <img src="<%= producto.getImagen() %>" alt="<%= producto.getNombre() %>">
                        <p><%= producto.getNombre() %></p>
                        <p>Precio: S/ <%= producto.getPrecio() %></p>
                        <div class="cantidad">
                            <button type="button" class="btn-decrementar">-</button>
                            <input type="number" value="1" min="1" class="cantidad-input" name="cantidadInput">
                            <button type="button" class="btn-incrementar">+</button>
                        </div>
                        <form action="CarritoServlet" method="post">
                            <input type="hidden" name="action" value="agregar">
                            <input type="hidden" name="id" value="<%= producto.getId() %>">
                            <input type="hidden" name="nombre" value="<%= producto.getNombre() %>">
                            <input type="hidden" name="precio" value="<%= producto.getPrecio() %>">
                            <input type="hidden" name="imagen" value="<%= producto.getImagen() %>">
                            <input type="hidden" name="cantidad" class="cantidad-hidden" value="1">
                            <button type="submit" class="btn-agregar">Agregar al carrito</button>
                        </form>
                    </div>
                    <% } %>
                </div>
            </div>

        </section>

        <button onclick="window.location.href='contacto.jsp'" class="btn-ayuda">¿Necesitas ayuda?</button>

        <footer>
            <p>&copy; 2024 XCEL_SERVER. Todos los derechos reservados.</p>
        </footer>

        <!-- JavaScript para controlar la cantidad de productos -->

        <script>
        document.querySelectorAll('.btn-incrementar').forEach(button => {
                button.addEventListener('click', function () {
                    let input = this.previousElementSibling;
                    input.value = parseInt(input.value) + 1;
                    let hiddenInput = this.closest('.producto-item').querySelector('.cantidad-hidden');
                    hiddenInput.value = input.value;
                });
            });

            document.querySelectorAll('.btn-decrementar').forEach(button => {
                button.addEventListener('click', function () {
                    let input = this.nextElementSibling;
                    if (parseInt(input.value) > 1) {
                        input.value = parseInt(input.value) - 1;
                        let hiddenInput = this.closest('.producto-item').querySelector('.cantidad-hidden');
                        hiddenInput.value = input.value;
                    }
                });
            });
        </script>

    </body>
</html>
