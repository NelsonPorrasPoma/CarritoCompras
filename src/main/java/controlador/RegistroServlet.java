/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import DAO.UsuarioDAO;
import DAO.DatosPersonalesDAO;
import modelo.Usuario;
import modelo.DatosPersonales;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.PasswordUtils;

public class RegistroServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String docIdentidad = request.getParameter("docIdentidad");
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
        String correo = request.getParameter("correo");
        String usuarioNombre = request.getParameter("usuario");
        String contrasena = request.getParameter("contrasena");
        
        // Crear el objeto Usuario y encriptar la contraseña
        Usuario usuario = new Usuario();
        usuario.setUsuario(usuarioNombre);
        usuario.setContrasena(PasswordUtils.hashPassword(contrasena)); // Encriptar contraseña
        usuario.setRol("Cliente");
        
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        
        // Crear objeto DatosPersonales
        DatosPersonales datosPersonales = new DatosPersonales(nombre, apellidos, docIdentidad, direccion, telefono, correo);
        
        try {
                        // Registrar usuario y obtener su ID generado
            int usuarioId = usuarioDAO.registrarUsuario(usuario); 
            if (usuarioId > 0) {
                                // Asociar el ID del usuario con los datos personales y guardarlos
                datosPersonales.setUsuarioId(usuarioId);
                DatosPersonalesDAO datosDAO = new DatosPersonalesDAO();
                datosDAO.registrarDatosPersonales(datosPersonales);  
            }
                        // Redirigir al usuario al login con éxito
            response.sendRedirect("login.jsp?registroExitoso=true");
        } catch (Exception e) {
            e.printStackTrace();
                        // Redirigir a la página de registro con error
            response.sendRedirect("login.jsp?error=true");
        }
    }
}
