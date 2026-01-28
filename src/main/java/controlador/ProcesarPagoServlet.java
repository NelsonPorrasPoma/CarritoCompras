/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import modelo.Producto;
import conexion.conexion;
import DAO.PedidoDAO;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfWriter;
import java.sql.ResultSet;
import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

public class ProcesarPagoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<Producto> carrito = (List<Producto>) session.getAttribute("carrito");
        String usuario = (String) session.getAttribute("usuario");

        PedidoDAO pedidoDAO = new PedidoDAO();
        int clienteId = pedidoDAO.getClientIdByUsuario(usuario);

        if (carrito != null && !carrito.isEmpty() && clienteId > 0) {
            try (Connection conn = conexion.conectar()) {
                // Insertar pedido
                String sqlPedido = "INSERT INTO pedidos (CLIENTE_ID, FECHA, TOTAL, ESTADO) VALUES (?, ?, ?, ?)";
                int pedidoId;

                try (PreparedStatement psPedido = conn.prepareStatement(sqlPedido, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    psPedido.setInt(1, clienteId);
                    psPedido.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
                    psPedido.setDouble(3, (double) session.getAttribute("total"));
                    psPedido.setString(4, "Pendiente");
                    psPedido.executeUpdate();

                    try (var rs = psPedido.getGeneratedKeys()) {
                        if (rs.next()) {
                            pedidoId = rs.getInt(1);
                        } else {
                            throw new SQLException("Error al obtener el ID del pedido.");
                        }
                    }
                }

// Inserta los detalles del pedido
                String sqlDetallePedido = "INSERT INTO detalle_pedido (PEDIDO_ID, PRODUCTO_ID, CANTIDAD, PRECIO_UNITARIO) VALUES (?, ?, ?, ?)";
                try (PreparedStatement psDetallePedido = conn.prepareStatement(sqlDetallePedido)) {
                    for (Producto producto : carrito) {
                        psDetallePedido.setInt(1, pedidoId);
                        psDetallePedido.setInt(2, producto.getId());
                        psDetallePedido.setInt(3, producto.getStock());
                        psDetallePedido.setDouble(4, producto.getPrecio());
                        psDetallePedido.addBatch();
                    }
                    psDetallePedido.executeBatch();
                } 
            
                // Obtener los datos del cliente
                String sqlCliente = "SELECT dp.NOMBRE, dp.APELLIDOS, dp.DIRECCION "
                        + "FROM datos_personales dp "
                        + "JOIN usuarios u ON dp.USUARIO_ID = u.ID "
                        + "WHERE u.usuario = ?";

                String nombreCliente = "", apellidosCliente = "", direccionCliente = "";
                try (PreparedStatement psCliente = conn.prepareStatement(sqlCliente)) {
                    psCliente.setString(1, usuario);
                    ResultSet rsCliente = psCliente.executeQuery();
                    if (rsCliente.next()) {
                        nombreCliente = rsCliente.getString("NOMBRE");
                        apellidosCliente = rsCliente.getString("APELLIDOS");
                        direccionCliente = rsCliente.getString("DIRECCION");
                    }
                }

                // Crear PDF  
                String filePath = getServletContext().getRealPath("/") + "boletas/";
                String fileName = "boleta_" + pedidoId + ".pdf";
                java.io.File fileDir = new java.io.File(filePath);
                if (!fileDir.exists()) {
                    fileDir.mkdirs();
                }
                String fullPath = filePath + fileName;

                Document document = new Document();
                try (var fos = new java.io.FileOutputStream(fullPath)) {
                    PdfWriter.getInstance(document, fos);
                    document.open();

                    // Agregar imagen de cabecera
                    String headerImagePath = getServletContext().getRealPath("/images/logo.png"); 
                    Image headerImage = Image.getInstance(headerImagePath);
                    headerImage.scaleToFit(100, 100);  
                    headerImage.setAlignment(Element.ALIGN_CENTER);
                    document.add(headerImage);
 
                    Paragraph titulo = new Paragraph("BOLETA DE VENTA", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14));
                    titulo.setAlignment(Element.ALIGN_CENTER);
                    document.add(titulo);

                    document.add(new Paragraph("\n"));

                    // Información del cliente en tabla
                    PdfPTable clienteTable = new PdfPTable(2);
                    clienteTable.setWidthPercentage(100);
                    clienteTable.addCell("Cliente:");
                    clienteTable.addCell(nombreCliente + " " + apellidosCliente);
                    clienteTable.addCell("Dirección:");
                    clienteTable.addCell(direccionCliente);
                    clienteTable.addCell("Fecha:");
                    clienteTable.addCell(new Timestamp(System.currentTimeMillis()).toString());
                    clienteTable.addCell("Boleta N°:");
                    clienteTable.addCell(String.valueOf(pedidoId));
                    document.add(clienteTable);

                    document.add(new Paragraph("\n"));

                    // Detalle del pedido en tabla
                    PdfPTable detalleTable = new PdfPTable(3);
                    detalleTable.setWidthPercentage(100);
                    detalleTable.addCell("Descripción");
                    detalleTable.addCell("Cantidad");
                    detalleTable.addCell("Precio");

                    for (Producto producto : carrito) {
                        detalleTable.addCell(producto.getNombre());
                        detalleTable.addCell(String.valueOf(producto.getStock()));
                        detalleTable.addCell("s/ " + producto.getPrecio());
                    }
                    document.add(detalleTable);

                    document.add(new Paragraph("\n"));

                    // Total
                    Paragraph total = new Paragraph("Total: s/ " + session.getAttribute("total"),
                            FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12));
                    total.setAlignment(Element.ALIGN_RIGHT);
                    document.add(total);

                    document.close();
                }

                // Limpiar sesión
                session.removeAttribute("carrito");
                session.removeAttribute("total");
 
                String fileUrl = request.getContextPath() + "/boletas/" + fileName;
                response.setContentType("text/plain");
                response.getWriter().write(fileUrl);

            } catch (SQLException | DocumentException e) {
                throw new ServletException("Error al procesar el pago o generar la boleta", e);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Carrito vacío o cliente no identificado.");
        }
    }
}
