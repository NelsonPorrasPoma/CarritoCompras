package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException; 
import java.util.List;
import modelo.DetallePedido;
import modelo.Pedido; 
import conexion.conexion;
import DAO.PedidoDAO;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.Image;
import com.lowagie.text.Element;
import com.lowagie.text.FontFactory; 
import com.lowagie.text.pdf.PdfPTable;

public class GenerarBoletaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String usuario = (String) session.getAttribute("usuario");
        int pedidoId = Integer.parseInt(request.getParameter("pedidoId"));
        
        PedidoDAO pedidoDAO = new PedidoDAO();
        int clienteId = pedidoDAO.getClientIdByUsuario(usuario);

        if (clienteId > 0) {
            try (Connection conn = conexion.conectar()) {

                // Obtener los datos del pedido
                Pedido pedido = pedidoDAO.obtenerPedidoPorId(pedidoId);
                List<DetallePedido> detalles = pedidoDAO.obtenerDetallesPorPedidoId(pedidoId);

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
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment; filename=boleta_" + pedidoId + ".pdf");
                Document document = new Document();
                PdfWriter.getInstance(document, response.getOutputStream());
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
                clienteTable.addCell(pedido.getFecha().toString());
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

                for (DetallePedido detalle : detalles) {
                    String nombreProducto = pedidoDAO.obtenerNombreProductoPorId(detalle.getProductoId());
                    detalleTable.addCell(nombreProducto);
                    detalleTable.addCell(String.valueOf(detalle.getCantidad()));
                    detalleTable.addCell("s/ " + detalle.getPrecioUnitario());
                }
                document.add(detalleTable);

                document.add(new Paragraph("\n"));

                // Total
                Paragraph total = new Paragraph("Total: s/ " + pedido.getTotal(),
                        FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12));
                total.setAlignment(Element.ALIGN_RIGHT);
                document.add(total);

                document.close();

            } catch (SQLException | DocumentException e) {
                throw new ServletException("Error al generar la boleta", e);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Cliente no identificado.");
        }
    }
}
