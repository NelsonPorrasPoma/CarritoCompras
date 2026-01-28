<%-- 
    Document   : carrito
    Created on : 18 sept. 2024, 17:22:37
    Author     : UsuarioTK
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    <title>Carrito | XCEL_SERVER</title>
    <link rel="stylesheet" href="css/estilosGenerales.css">
    <link rel="stylesheet" href="css/estilosCarrito.css">
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

   <!-- Sección del carrito -->
    <section id="carrito">
        <h2>TU CARRITO XCEL SERVER</h2>
        <c:if test="${not empty carrito}">
            <table class="tabla-carrito">
                <thead>
                    <tr>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th>Precio</th>
                        <th>Total</th>
                        <th>Quitar</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${carrito}">
                        <tr>
                           
                            <td>${item.nombre}</td>
                            <td>
                                <form action="CarritoServlet" method="post" class="form-cantidad">
                                    <input type="hidden" name="action" value="actualizar">
                                    <input type="hidden" name="id" value="${item.id}">
                                    <button type="button" class="btn-decrementar">-</button>
                                    <input type="number" name="cantidad" value="${item.stock}" min="1" class="cantidad-input">
                                    <button type="button" class="btn-incrementar">+</button>
                                    <button type="submit" class="btn-actualizar">Actualizar</button>
                                </form>
                            </td>
                            <td>S/ ${item.precio}</td>
                            <td>S/ ${item.precio * item.stock}</td>
                            <td>
                                <form action="CarritoServlet" method="post" class="form-eliminar">
                                    <input type="hidden" name="action" value="eliminar">
                                    <input type="hidden" name="id" value="${item.id}">
                                    <button type="submit" class="btn-eliminar">Eliminar</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
<div class="resumen-carrito">
    <h3>Total: <c:out value="S/ ${total}"/></h3>
    <form id="form-pagar" action="pagar.jsp" method="post">
        <button type="button" class="btn-pagar" onclick="validarPago()">Proceder al Pago</button>
    </form>
</div>

<script>
    function validarPago() { 
        var usuario = '<%= usuario %>';
        var rol = '<%= rol %>';

        if (usuario && rol === 'CLIENTE') {
            // Si hay un usuario logueado y es cliente, envía el formulario para proceder al pago
            document.getElementById('form-pagar').submit();
        } else {
            // Si no hay usuario logueado, redirige a la página de login
            alert('Debes iniciar sesión para proceder con el pago.');
            window.location.href = 'login.jsp';
        }
    }
</script>

        </c:if>
        <c:if test="${empty carrito}">
            <p>Tu carrito está vacío.</p>
        </c:if>
    </section> 
        <button onclick="window.location.href='contacto.jsp'" class="btn-ayuda">¿Necesitas ayuda?</button>
 
    <footer>
        <p>&copy; 2024 XCEL_SERVER. Todos los derechos reservados.</p>
    </footer>

    <!-- JavaScript para controlar la cantidad de productos -->
    <script>
        document.querySelectorAll('.btn-incrementar').forEach(button => {
                        button.addEventListener('click', function() {
                let input = this.previousElementSibling;
                input.value = parseInt(input.value) + 1;
            });
        });

        document.querySelectorAll('.btn-decrementar').forEach(button => {
            button.addEventListener('click', function() {
                let input = this.nextElementSibling;
                if (parseInt(input.value) > 1) {
                    input.value = parseInt(input.value) - 1;
                }
            });
        });
    </script>
</body>
</html>

