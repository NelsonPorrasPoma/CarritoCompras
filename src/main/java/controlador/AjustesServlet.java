/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import DAO.UsuarioDAO;

public class AjustesServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String usuario = (String) session.getAttribute("usuario");
        String rol = (String) session.getAttribute("rol");
        String contraseñaActual = request.getParameter("contraseña");
        String nuevaContraseña = request.getParameter("nueva-contraseña");

        if (usuario != null && rol != null) {
            UsuarioDAO usuarioDAO = new UsuarioDAO();
            try {
                if (usuarioDAO.validarContraseña(usuario, contraseñaActual)) {
                    usuarioDAO.actualizarContraseña(usuario, nuevaContraseña);
                    response.sendRedirect("ajustes.jsp?mensaje=Contraseña actualizada");
                } else {
                    response.sendRedirect("ajustes.jsp?mensaje=Contraseña actual incorrecta");
                }
            } catch (SQLException e) {
                e.printStackTrace(); // Para depuración
                response.sendRedirect("ajustes.jsp?mensaje=Error al actualizar la contraseña");
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}
