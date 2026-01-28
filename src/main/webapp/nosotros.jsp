<%-- 
    Document   : nosotros
    Created on : 18 sept. 2024, 17:23:21
    Author     : UsuarioTK
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nosotros | XCEL_SERVER</title>
        <link rel="stylesheet" href="css/estilosGenerales.css">
        <link rel="stylesheet" href="css/estilosNosotros.css">
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
 
        <div class="contenido-nosotros"> 
            <section id="nuestra-mision" class="seccion-nosotros">
                <h2>NUESTRA MISIÓN</h2>
                <p>Brindar productos y servicios informáticos de alta calidad que satisfagan las
necesidades de nuestros clientes, a través de un servicio al cliente excepcional y
una atención personalizada, contribuyendo al desarrollo tecnológico de nuestra
comunidad.</p>
            </section>
 
            <section id="nuestra-vision" class="seccion-nosotros">
                <h2>NUESTRA VISIÓN</h2>
                <p>Convertirnos en un referente en el mercado de productos y servicios informáticos
en Perú, mediante la innovación y la mejora continua de nuestros procesos,
expandiendo nuestra presencia digital para alcanzar un mercado más amplio y
ofrecer una experiencia de compra eficiente y satisfactoria.</p>
            </section>
 
            <section id="nuestra-historia" class="seccion-nosotros">
                <h2>NUESTRA HISTORIA</h2>
                <p>Xcel Server es un negocio fundada en 2008 en la ciudad de Tarma, Perú, dedicada
a la venta y distribución de productos informáticos como laptops, impresoras,
teclados, y audífonos, además de ofrecer servicios técnicos para computadoras e
impresoras. A lo largo de los años, Xcel Server ha crecido gracias a su
compromiso con la calidad de sus productos y servicios, así como a su excelente
atención al cliente.</p>
            </section> 
            <section id="conoce-al-equipo" class="seccion-nosotros">
                <h2>CONOCE AL EQUIPO</h2>
                <div class="equipo-grid">
                    <div class="miembro-equipo">
                        <img src="images/1.png" alt="CEO - XCEL SERVER">
                        <p>Juan Danilo Porras</p>
                        <p>Fundado de Xcel Server.</p>
                    </div>
                    <div class="miembro-equipo">
                        <img src="images/2.png" alt="TRABAJADOR 1">
                        <p>Nelson Porras</p>
                        <p>Forma parte de nuestro equipo desde 2016.</p>
                    </div>
                    <div class="miembro-equipo">
                        <img src="images/3.png" alt="RABAJADOR 2">
                        <p>Carlos Perez</p>
                        <p>Forma parte de nuestro equipo desde 2016.</p>
                    </div>
                </div>
            </section>
        </div>
<main> 
        <button onclick="window.location.href='contacto.jsp'" class="btn-ayuda">¿Necesitas ayuda?</button>
    </main>
        <footer>
            <p>&copy; 2024 XCEL_SERVER. Todos los derechos reservados.</p>
        </footer>
    </body>
</html>
