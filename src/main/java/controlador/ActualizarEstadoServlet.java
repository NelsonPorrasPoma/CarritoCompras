/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import DAO.PedidoDAO;

public class ActualizarEstadoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int pedidoId = Integer.parseInt(request.getParameter("pedidoId"));
        PedidoDAO pedidoDAO = new PedidoDAO();
        pedidoDAO.actualizarEstadoPedido(pedidoId, "Enviado");
        response.sendRedirect("pedidos.jsp");
    }
}
