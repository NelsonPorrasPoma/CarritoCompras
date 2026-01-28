/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import java.io.IOException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Usuario;
import DAO.UsuarioDAO;
import jakarta.servlet.ServletException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
 
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        Usuario usuario = null;
        try {
            usuario = usuarioDAO.validarUsuario(username, password);
        } catch (SQLException ex) {
            Logger.getLogger(LoginServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (usuario != null) {
            // Guardar el usuario en la sesión
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario.getUsuario()); 
            session.setAttribute("rol", usuario.getRol());

            // Redirigir según el rol del usuario
            String rol = usuario.getRol();
            switch (rol) {
                case "ADMINISTRADOR": // Administrador
                    response.sendRedirect("nosotros.jsp");
                    break;
                case "EMPLEADO": // Empleado
                    response.sendRedirect("nosotros.jsp");
                    break;
                case "CLIENTE": // Cliente
                    response.sendRedirect("carrito.jsp");
                    break;
                default:
                    response.sendRedirect("index.jsp");
                    break;
            }
        } else {
            // Si las credenciales son incorrectas
            request.setAttribute("error", "Usuario o contraseña incorrectos");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
