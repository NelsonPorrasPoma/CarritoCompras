<%-- 
    Document   : pedidos
    Created on : 18 sept. 2024, 17:23:32
    Author     : UsuarioTK
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, DAO.PedidoDAO, modelo.Pedido, modelo.DetallePedido"%>
<%@ page import="java.util.List"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pedidos | XCEL_SERVER</title>
    <link rel="stylesheet" href="css/estilosGenerales.css">
    <link rel="stylesheet" href="css/estilosPedidos.css">
    <script>
        function mostrarDetalles(pedidoId) {
            const detallesDiv = document.getElementById('detalles-' + pedidoId);
            detallesDiv.style.display = detallesDiv.style.display === 'none' ? 'block' : 'none';
        }
    </script>
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
    
    <main>
        <div class="contenido-pedidos">
            <section id="pedidos" class="seccion-pedidos">
                <h2>Lista de Pedidos</h2>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Pedido</th>
                            <th>Cliente</th>
                            <th>Total</th>
                            <th>Estado</th>
                            <th>Detalles</th>
                            <th>Boleta</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            PedidoDAO pedidoDAO = new PedidoDAO();
                            List<Pedido> pedidos = pedidoDAO.obtenerTodosLosPedidos();
                            
                            for (Pedido pedido : pedidos) {
                        %>
                        <tr>
                            <td>Pedido: <%= pedido.getId() %></td>
                            <td><%= pedido.getClienteId() %></td>
                            <td>S/ <%= pedido.getTotal() %></td>
                            <td><%= pedido.getEstado() %></td>
                            <td><a href="javascript:void(0);" onclick="mostrarDetalles(<%= pedido.getId() %>);">Detalles</a></td>
                            <td><a href="<%= request.getContextPath() + "/GenerarBoletaServlet?pedidoId=" + pedido.getId() %>" target="_blank">Descargar Boleta</a></td>

                            <td>
                                <% if (!"Enviado".equals(pedido.getEstado())) { %>
                                    <form action="ActualizarEstadoServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="pedidoId" value="<%= pedido.getId() %>">
                                        <input type="submit" value="ENVIAR" class="btn-actualizar">
                                    </form>
                                <% } %>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="7">
                                <div class="detalles" id="detalles-<%= pedido.getId() %>" style="display: none;"> 
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Producto</th>
                                                <th>Cantidad</th>
                                                <th>Precio Unitario</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                List<DetallePedido> detalles = pedidoDAO.obtenerDetallesPorPedidoId(pedido.getId());
                                                for (DetallePedido detalle : detalles) {
                                                    String nombreProducto = pedidoDAO.obtenerNombreProductoPorId(detalle.getProductoId());
                                            %>
                                            <tr>
                                                <td><%= nombreProducto %></td>
                                                <td><%= detalle.getCantidad() %></td>
                                                <td>S/ <%= detalle.getPrecioUnitario() %></td>
                                            </tr>
                                            <%
                                                }  
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <%
                            } 
                        %>
                    </tbody>
                </table>
            </section>
        </div> 
    </main>

    <footer>
        <p>&copy; 2024 XCEL_SERVER. Todos los derechos reservados.</p>
    </footer>
</body>
</html>
