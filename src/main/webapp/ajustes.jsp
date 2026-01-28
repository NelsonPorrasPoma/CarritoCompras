<%-- 
    Document   : ajustes
    Created on : 18 sept. 2024, 17:22:21
    Author     : UsuarioTK
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ajustes | XCEL_SERVER</title>
        <link rel="stylesheet" href="css/estilosGenerales.css">
        <link rel="stylesheet" href="css/estilosAjustes.css">
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

        <!-- Sección de ajustes -->
    <section id="ajustes">
        <h2>Cambiar Contraseña</h2>
        <form action="AjustesServlet" method="post" class="form-ajustes">
    <label for="contraseña">Contraseña actual:</label>
    <input type="password" id="contraseña" name="contraseña" required placeholder="Tu contraseña actual">

    <label for="nueva-contraseña">Nueva contraseña:</label>
    <input type="password" id="nueva-contraseña" name="nueva-contraseña" required placeholder="Nueva contraseña">

    <label for="confirmar-contraseña">Confirmar nueva contraseña:</label>
    <input type="password" id="confirmar-contraseña" name="confirmar-contraseña" required placeholder="Confirmar nueva contraseña">

    <button type="submit" class="btn-enviar">Guardar cambios</button>
</form>

    </section>
    <!-- Botón flotante de ayuda -->
    <button onclick="window.location.href='contacto.jsp'" class="btn-ayuda">¿Necesitas ayuda?</button>
 
    <footer>
        <p>&copy; 2024 XCEL_SERVER. Todos los derechos reservados.</p>
    </footer>
    <!-- JavaScript para validar las contraseñas -->
    <script>
        document.querySelector('.form-ajustes').addEventListener('submit', function(event) {
            var nuevaContraseña = document.getElementById('nueva-contraseña').value;
            var confirmarContraseña = document.getElementById('confirmar-contraseña').value;
            
            if (nuevaContraseña && nuevaContraseña !== confirmarContraseña) {
                alert('Las contraseñas nuevas no coinciden.');
                event.preventDefault();  
            
            }
        });
        </script>
    </body>
</html>
