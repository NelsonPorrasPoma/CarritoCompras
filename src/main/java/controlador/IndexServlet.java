/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Producto;
import DAO.ProductoDAO;
import java.io.IOException;
import java.util.List;

public class IndexServlet extends HttpServlet {
    private final ProductoDAO productoDAO = new ProductoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtener todos los productos
        List<Producto> productos = productoDAO.obtenerTodosProductos();

        // Pasar la información al JSP
        request.setAttribute("productos", productos);

        // Redirigir a index.jsp
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
 }