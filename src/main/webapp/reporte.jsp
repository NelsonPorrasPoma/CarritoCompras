<%-- 
    Document   : reporte
    Created on : 18 sept. 2024, 17:23:57
    Author     : UsuarioTK
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
    String usuario = (String) session.getAttribute("usuario");
    String rol = (String) session.getAttribute("rol");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reporte de Pedidos | XCEL_SERVER</title>
    <link rel="stylesheet" href="css/estilosGenerales.css">
    <link rel="stylesheet" href="css/estilosReporte.css">
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
            <h2>Reporte de Pedidos</h2>
            <form action="ReporteServlet" method="get">
                <label for="fechaInicio">Fecha Inicio:</label>
                <input type="date" name="fechaInicio" id="fechaInicio" required>
                <label for="fechaFin">Fecha Fin:</label>
                <input type="date" name="fechaFin" id="fechaFin" required>
                <button type="submit" name="accion" value="mostrar">Mostrar Reporte</button>
                <button type="submit" name="accion" value="exportarPDF">Exportar a PDF</button>
                <button type="submit" name="accion" value="exportarExcel">Exportar a Excel</button>
            </form>

        <c:if test="${not empty totalVentas}">
            <h3>Total de Ventas: ${totalVentas}</h3>
            <h3>Cantidad de Productos Vendidos: ${cantidadProductosVendidos}</h3>
        </c:if>
        <c:if test="${not empty pedidos}">
            <table class="reporte-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Cliente ID</th>
                        <th>Fecha</th>
                        <th>Total</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="pedido" items="${pedidos}">
                        <tr>
                            <td>${pedido.id}</td>
                            <td>${pedido.clienteId}</td>
                            <td>${pedido.fecha}</td>
                            <td>${pedido.total}</td>
                            <td>${pedido.estado}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
    </main>
</body>
</html>
