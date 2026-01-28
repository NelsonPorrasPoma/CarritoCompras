<%-- 
    Document   : contacto
    Created on : 18 sept. 2024, 17:22:50
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
        <title>Contacto | XCEL_SERVER</title>
        <link rel="stylesheet" href="css/estilosGenerales.css">
        <link rel="stylesheet" href="css/estilosContacto.css">
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

        <!-- Sección de contacto -->
        <section id="contacto">
            <h2>Contáctanos</h2>
            <form action="enviarMensaje.jsp" method="post" class="form-contacto"> 
                <input type="text" id="nombre" name="nombre" required placeholder="Escribe tu nombre">
                 
                <input type="email" id="email" name="email" required placeholder="Escribe tu correo electrónico">
                 
                <input type="text" id="asunto" name="asunto" required placeholder="Indícanos el asunto">
                 
                <textarea id="mensaje" name="mensaje" rows="5" required placeholder="Déjanos tu mensaje"></textarea>
                
                <button type="submit" class="btn-enviar">Enviar</button>
            </form>
        </section>  
        <footer>
            <p>&copy; 2024 XCEL_SERVER. Todos los derechos reservados.</p>           
        </footer> 
    </body>
</html>
