/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Producto;

public class CarritoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<Producto> carrito = (List<Producto>) session.getAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
        }
        String action = request.getParameter("action");
        if ("agregar".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String nombre = request.getParameter("nombre");
            double precio = Double.parseDouble(request.getParameter("precio"));
            String imagen = request.getParameter("imagen");
            int cantidad = Integer.parseInt(request.getParameter("cantidad"));
            Producto producto = new Producto(id, nombre, "", cantidad, 0, imagen, precio);
            carrito.add(producto);
            session.setAttribute("carrito", carrito);
            response.sendRedirect("productos.jsp");
        } else if ("actualizar".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            int cantidad = Integer.parseInt(request.getParameter("cantidad"));
            for (Producto producto : carrito) {
                if (producto.getId() == id) {
                    producto.setStock(cantidad);
                    break;
                }
            }
            session.setAttribute("carrito", carrito);
            response.sendRedirect("carrito.jsp");
        } else if ("eliminar".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            carrito.removeIf(producto -> producto.getId() == id);
            session.setAttribute("carrito", carrito);
            response.sendRedirect("carrito.jsp");
        }
        
        // Calcular el total
        double total = 0;
        for (Producto producto : carrito) {
            total += producto.getPrecio() * producto.getStock();
        }
        session.setAttribute("total", total);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
