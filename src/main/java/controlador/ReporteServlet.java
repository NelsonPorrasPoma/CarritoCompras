/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Pedido;
import DAO.PedidoDAO;
import java.io.IOException;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import java.util.List;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.io.FileInputStream;
import java.io.InputStream;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.util.IOUtils;

public class ReporteServlet extends HttpServlet {

    private PedidoDAO pedidoDAO = new PedidoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if ("mostrar".equals(accion)) {
            // Obtener fechas del formulario
            String fechaInicio = request.getParameter("fechaInicio");
            String fechaFin = request.getParameter("fechaFin");
            List<Pedido> pedidos = pedidoDAO.buscarPedidosPorFecha(fechaInicio, fechaFin);

            // Guardar la lista de pedidos en sesión
            request.getSession().setAttribute("pedidosMostrados", pedidos);

            // Enviar los datos al JSP
            request.setAttribute("pedidos", pedidos);
            request.setAttribute("fechaInicio", fechaInicio);
            request.setAttribute("fechaFin", fechaFin);
            request.getRequestDispatcher("reporte.jsp").forward(request, response);

        } else if ("exportarPDF".equals(accion)) {
            // Generar PDF
            exportarPDF(request, response);
        } else if ("exportarExcel".equals(accion)) {
            // Generar Excel
            exportarExcel(request, response);
        }
    }

    private void exportarPDF(HttpServletRequest request, HttpServletResponse response) throws IOException {
        @SuppressWarnings("unchecked")
        List<Pedido> pedidos = (List<Pedido>) request.getSession().getAttribute("pedidosMostrados");

        if (pedidos == null || pedidos.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No hay datos para exportar. Genera un reporte primero.");
            return;
        }

        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss");
        String timestamp = now.format(formatter);
        String filename = "REPORTE_XCEL_SERVER_" + timestamp;

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=" + filename + ".pdf");

        try (PdfWriter writer = new PdfWriter(response.getOutputStream())) {
            com.itextpdf.kernel.pdf.PdfDocument pdfDocument = new com.itextpdf.kernel.pdf.PdfDocument(writer);
            Document document = new Document(pdfDocument);

            String logoPath = request.getServletContext().getRealPath("/images/logo.png");
            com.itextpdf.layout.element.Image logo = new com.itextpdf.layout.element.Image(
                    com.itextpdf.io.image.ImageDataFactory.create(logoPath));
            logo.setWidth(100);
            logo.setHorizontalAlignment(com.itextpdf.layout.property.HorizontalAlignment.CENTER);
            document.add(logo);

            document.add(new Paragraph("Reporte de Pedidos")
                    .setBold().setFontSize(16).setTextAlignment(com.itextpdf.layout.property.TextAlignment.CENTER));
            document.add(new Paragraph("Generado el: " + now.format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss")))
                    .setTextAlignment(com.itextpdf.layout.property.TextAlignment.CENTER));
            document.add(new Paragraph("\n"));

            // Tabla 
            Table table = new Table(new float[]{2, 3, 3, 2, 2}).useAllAvailableWidth();
            table.addHeaderCell("ID").setBold();
            table.addHeaderCell("Cliente ID").setBold();
            table.addHeaderCell("Fecha").setBold();
            table.addHeaderCell("Total").setBold();
            table.addHeaderCell("Estado").setBold();

            for (Pedido pedido : pedidos) {
                table.addCell(String.valueOf(pedido.getId()));
                table.addCell(String.valueOf(pedido.getClienteId()));
                table.addCell(pedido.getFecha());
                table.addCell(String.format("%.2f", pedido.getTotal()));
                table.addCell(pedido.getEstado());
            }

            document.add(table);
            document.close();
        }
    }

    private void exportarExcel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        @SuppressWarnings("unchecked")
        List<Pedido> pedidos = (List<Pedido>) request.getSession().getAttribute("pedidosMostrados");

        if (pedidos == null || pedidos.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No hay datos para exportar. Genera un reporte primero.");
            return;
        }

        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss");
        String timestamp = now.format(formatter);
        String filename = "REPORTE_XCEL_SERVER_" + timestamp;

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=" + filename + ".xlsx");

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Reporte de Pedidos");

            String logoPath = request.getServletContext().getRealPath("/images/logo.png");
            try (InputStream is = new FileInputStream(logoPath)) {
                byte[] bytes = IOUtils.toByteArray(is);
                int pictureIdx = workbook.addPicture(bytes, Workbook.PICTURE_TYPE_PNG);
                CreationHelper helper = workbook.getCreationHelper();
                Drawing<?> drawing = sheet.createDrawingPatriarch();

                ClientAnchor anchor = helper.createClientAnchor();
                anchor.setCol1(0);
                anchor.setRow1(0);
                anchor.setCol2(4);
                anchor.setRow2(4);

                drawing.createPicture(anchor, pictureIdx);
            }

            Row infoRow = sheet.createRow(5);
            infoRow.createCell(0).setCellValue("Reporte de Pedidos - Generado el: " + now.format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss")));

            Row headerRow = sheet.createRow(7);
            String[] headers = {"ID", "Cliente ID", "Fecha", "Total", "Estado"};
            org.apache.poi.ss.usermodel.CellStyle headerStyle = workbook.createCellStyle();
            org.apache.poi.ss.usermodel.Font font = workbook.createFont();
            font.setBold(true);
            headerStyle.setFont(font);

            for (int i = 0; i < headers.length; i++) {
                org.apache.poi.ss.usermodel.Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // Rellenar datos
            int rowNum = 8;
            for (Pedido pedido : pedidos) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(pedido.getId());
                row.createCell(1).setCellValue(pedido.getClienteId());
                row.createCell(2).setCellValue(pedido.getFecha());
                row.createCell(3).setCellValue(pedido.getTotal());
                row.createCell(4).setCellValue(pedido.getEstado());
            }

            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            workbook.write(response.getOutputStream());
        }
    }
}
