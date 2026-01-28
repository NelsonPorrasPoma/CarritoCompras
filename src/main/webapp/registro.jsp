<%-- 
    Document   : registro
    Created on : 18 sept. 2024, 17:23:49
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
        <title>Registro de Usuario | XCEL_SERVER</title>
        <link rel="stylesheet" href="css/estilosGenerales.css">
        <link rel="stylesheet" href="css/estilosRegistro.css">
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
            <div id="registro">
                <img src="images/logo.png" alt="LOGO" class="registro-image">
                <h2>Registro de Usuario</h2>
                  <p class="enlace">¿Eres nuevo en XCEL SERVER.com?</p> 
                              <p class="enlace">Regístrate para una compra más facil.</p> 
                              <p class="enlace">   </p> 
                <form action="RegistroServlet" method="post" class="form-registro"> 
                    <input type="text" id="nombre" name="nombre" placeholder="Ingresa tu nombre" required>
 
                    <input type="text" id="apellidos" name="apellidos" placeholder="Ingresa tus apellidos" required>
 
                    <input type="text" id="docIdentidad" name="docIdentidad" placeholder="Ingresa tu Documento de identidad" required>
 
                    <input type="text" id="direccion" name="direccion" placeholder="Ingresa tu dirección" required>
 
                    <input type="text" id="telefono" name="telefono" placeholder="Ingresa tu teléfono" required>
 
                    <input type="email" id="correo" name="correo" required placeholder="Ingresa tu e-mail">
 
                    <input type="text" id="usuario" name="usuario" placeholder="Crea un usuario" required>
 
                    <input type="password" id="contrasena" name="contrasena" placeholder="Crea un contraseña" required>

                    <button type="submit">Registrar</button>
                </form>

                <% if (request.getAttribute("error") != null) { %>
                    <p class="error-message"><%= request.getAttribute("error") %></p>
                <% } %>
 
                <p class="enlace">¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión aquí</a></p>
                <p class="enlace"><a href="index.jsp">Cancelar</a></p>
            </div>
        </main>
                <button onclick="window.location.href='contacto.jsp'" class="btn-ayuda">¿Necesitas ayuda?</button>
        <footer>
            <p>&copy; 2024 XCEL_SERVER. Todos los derechos reservados.</p>
        </footer>
    </body>
</html>
