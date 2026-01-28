<%-- 
    Document   : login
    Created on : 18 sept. 2024, 17:23:13
    Author     : UsuarioTK
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("user");
 
    if (usuario != null) {
        response.sendRedirect("index.jsp"); 
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Iniciar Sesión | XCEL_SERVER</title>
        <link rel="stylesheet" href="css/estilosGenerales.css">
        <link rel="stylesheet" href="css/estilosLogin.css">
    </head>
    <body>
        <header>
            <nav>
            <ul class="nav-left"> 
                <li>XCEL SERVER</li> 
            </ul>
                <ul class="nav-center"> 
                    <li><a href="productos.jsp">PRODUCTOS</a></li>
                    <li><a href="nosotros.jsp">NOSOTROS</a></li>
                    <li><a href="carrito.jsp">CARRITO</a></li>
                    <li><a href="contacto.jsp">CONTACTO</a></li>
                </ul>
            </nav>
        </header>
        <main>
            <div id="login">
                <img src="images/logo.png" alt="LOGO" class="login-image">
                              <p class="enlace">¡Bienvenido a XCEL SERVER.com!</p> 
                              <p class="enlace">¡Ingresa tu usuario y contraseña para iniciar sesión!</p> 
                              <p class="enlace">   </p> 
                <form action="LoginServlet" method="post" class="form-login"> 
                   
                    <input type="text" id="username" name="username" placeholder="Ingresa tu usuario" required>
                     <input type="password" id="password" name="password" placeholder="Ingresa tu contraseña" required> 

                    <button type="submit">Iniciar Sesión</button>
                </form>

                <% if (request.getAttribute("error") != null) { %>
                    <p class="error-message"><%= request.getAttribute("error") %></p>
                <% } %>

                <p class="enlace">¿No tienes una cuenta? <a href="registro.jsp">Regístrate aquí</a></p>
                 <p class="enlace"><a href="contraseña.jsp">Recuperar contraseña</a></p>
            </div>
        </main>
                <button onclick="window.location.href='contacto.jsp'" class="btn-ayuda">¿Necesitas ayuda?</button>
        <footer>
            <p>&copy; 2024 XCEL_SERVER. Todos los derechos reservados.</p>
        </footer>
    </body>
</html>
