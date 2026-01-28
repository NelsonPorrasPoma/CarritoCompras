<%-- 
    Document   : pagar.jsp
    Created on : 23 sept. 2024, 16:50:55
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
        <title>Pagar | XCEL_SERVER</title>
        <link rel="stylesheet" href="css/estilosGenerales.css">
        <link rel="stylesheet" href="css/estilosPago.css">
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

        <!-- Sección de pago -->
        <section id="pago">
            <div class="pago-contenedor">
                <h2>Proceder al Pago</h2>
                <form action="ProcesarPagoServlet" method="post" class="form-pago" onsubmit="mostrarModal(event)">
                    <div class="form-group"> 
                        <input type="text" id="nombre" name="nombre" placeholder="Titular de la tarjeta" required>
                    </div>
                    <div class="form-group"> 
                        <input type="text" id="numero" name="numero" placeholder="Número de tarjeta" required pattern="\d{16}" title="Debe contener 16 dígitos">
                    </div>
                    <div class="form-group"> 
                        <input type="text" id="expiracion" name="expiracion" placeholder="Fecha de expiración (MM/AA)" required pattern="\d{2}/\d{2}" title="Formato MM/AA">
                    </div>
                    <div class="form-group"> 
                        <input type="text" id="cvv" name="cvv" placeholder="CVV" required pattern="\d{3}" title="Debe contener 3 dígitos">
                    </div>
                    <button type="submit" class="btn-pagar">Pagar</button>
                </form>
            </div>
        </section>

        <!-- Modal de éxito -->
        <div id="modalPagoExitoso" class="modal" style="display:none;">
            <div class="modal-content">
                <h3>Pago procesado correctamente</h3>
                <a href="#" class="btn-regresar" onclick="redirectToIndex()">Conforme</a>
                <!-- Botón de descarga -->
                <a id="btnDescargarBoleta" href="#" class="btn-regresar" style="display:none;" target="_blank">Descargar Boleta</a>
            </div>
        </div>



        <!-- Modal de error -->
        <div id="modalPagoError" class="modal" style="display:none;">
            <div class="modal-content">
                <h3>Error al procesar el pago</h3>
                <p id="mensajeError"></p>
                <a href="productos.jsp" class="btn-regresar">REGRESAR</a>
            </div>
        </div>

        <script>
            function mostrarModal(event) {
                event.preventDefault();

                const formData = new FormData(event.target);
                const xhr = new XMLHttpRequest();

                xhr.open("POST", event.target.action, true);
                xhr.onload = function () {
                    if (xhr.status === 200) {
                        // Mostrar el modal de éxito
                        const modal = document.getElementById("modalPagoExitoso");
                        modal.style.display = "block";

                        // Configurar el enlace de descarga
                        const btnDescargar = document.getElementById("btnDescargarBoleta");
                        btnDescargar.style.display = "inline-block";
                        btnDescargar.href = xhr.responseText;  
                    } else {
                        // Mostrar el modal de error
                        const modalError = document.getElementById("modalPagoError");
                        const mensajeError = document.getElementById("mensajeError");
                        mensajeError.innerText = xhr.responseText;
                        modalError.style.display = "block";
                    }
                };

                xhr.send(formData);
            }
            function redirectToIndex() {
                window.location.href = "index.jsp";
            }
        </script>

        <footer>
            <p>&copy; 2024 XCEL_SERVER. Todos los derechos reservados.</p>
        </footer>
    </body>
</html>