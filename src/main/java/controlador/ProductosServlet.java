/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;
 
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import DAO.CategoriaDAO;
import DAO.ProductoDAO;
import java.io.InputStream;
import modelo.Categoria;
import modelo.Producto;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
 
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  
    maxFileSize = 1024 * 1024 * 10,  
    maxRequestSize = 1024 * 1024 * 50  
)
public class ProductosServlet extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();
    CategoriaDAO categoriaDAO = new CategoriaDAO();

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String action = request.getParameter("action");
    String buscarNombre = request.getParameter("buscarNombre");
    String buscarCategoria = request.getParameter("buscarCategoria");
    List<Producto> productos;

    if ("buscarProductos".equals(action)) {
        if ((buscarNombre != null && !buscarNombre.isEmpty()) || (buscarCategoria != null && !buscarCategoria.isEmpty())) {
            productos = productoDAO.buscarProductos(buscarNombre, buscarCategoria);
        } else {
            productos = productoDAO.obtenerTodosProductos();
        }

        List<Categoria> categorias = categoriaDAO.obtenerCategorias();
        request.setAttribute("productos", productos);
        request.setAttribute("categorias", categorias);
        request.getRequestDispatcher("index.jsp").forward(request, response);  // Redirigir a index.jsp
    } else if ("buscarAlmacen".equals(action)) {
        if ((buscarNombre != null && !buscarNombre.isEmpty()) || (buscarCategoria != null && !buscarCategoria.isEmpty())) {
            productos = productoDAO.buscarProductos(buscarNombre, buscarCategoria);
        } else {
            productos = productoDAO.obtenerTodosProductos();
        }

        List<Categoria> categorias = categoriaDAO.obtenerCategorias();
        request.setAttribute("productos", productos);
        request.setAttribute("categorias", categorias);
        request.getRequestDispatcher("almacen.jsp").forward(request, response);  // Redirigir a almacen.jsp
    }
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("guardar".equals(action)) {
            guardarProducto(request, response);
        } else if ("editar".equals(action)) {
            editarProducto(request, response);
        } else if ("eliminar".equals(action)) {
            eliminarProducto(request, response);
        } else if ("cargar".equals(action)) {
            cargarProducto(request, response);
        }
    }

    private void guardarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        int stock = Integer.parseInt(request.getParameter("stock"));
        String categoriaStr = request.getParameter("categoria");
        double precio = Double.parseDouble(request.getParameter("precio"));

        Part imagenPart = request.getPart("imagen");
        String nombreArchivo = guardarArchivoImagen(imagenPart);

        int categoriaId;
        try {
            categoriaId = Integer.parseInt(categoriaStr);
        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "Error: La categoría no es válida.");
            request.getRequestDispatcher("almacen.jsp").forward(request, response);
            return;
        }

        Producto nuevoProducto = new Producto(nombre, descripcion, stock, categoriaId, nombreArchivo, precio);

        boolean guardado = productoDAO.guardarProducto(nuevoProducto);
        request.setAttribute("mensaje", guardado ? "Producto guardado exitosamente" : "Error al guardar el producto");

        redirigirAlmacen(request, response);
    }

    private void editarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        int stock = Integer.parseInt(request.getParameter("stock"));
        String categoriaStr = request.getParameter("categoria");
        double precio = Double.parseDouble(request.getParameter("precio"));

        Part imagenPart = request.getPart("imagen");
        String nombreArchivo = guardarArchivoImagen(imagenPart);

        int categoriaId;
        try {
            categoriaId = Integer.parseInt(categoriaStr);
        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "Error: La categoría no es válida.");
            request.getRequestDispatcher("almacen.jsp").forward(request, response);
            return;
        }

        Producto productoEditado = new Producto(id, nombre, descripcion, stock, categoriaId, nombreArchivo, precio);

        boolean actualizado = productoDAO.actualizarProducto(productoEditado);
        request.setAttribute("mensaje", actualizado ? "Producto actualizado exitosamente" : "Error al actualizar el producto");

        redirigirAlmacen(request, response);
    }

    private void eliminarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean eliminado = productoDAO.eliminarProducto(id);
        request.setAttribute("mensaje", eliminado ? "Producto eliminado exitosamente" : "Error al eliminar el producto");

        redirigirAlmacen(request, response);
    }

    private void cargarProducto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Producto producto = productoDAO.buscarProductoPorId(id);

        request.setAttribute("producto", producto);
        List<Categoria> categorias = categoriaDAO.obtenerCategorias();
        request.setAttribute("categorias", categorias);

        request.getRequestDispatcher("almacen.jsp").forward(request, response);
    } 

    private String guardarArchivoImagen(Part imagenPart) throws IOException {
        if (imagenPart == null || imagenPart.getSize() <= 0) {
            return null; // No se ha enviado imagen, retornamos null.
        }

        // Obtener el nombre del archivo
        String nombreArchivo = Paths.get(imagenPart.getSubmittedFileName()).getFileName().toString();
 
        Path rutaReal = Paths.get("C:\\Users\\PorrasPoma\\Desktop\\MARZO 2025\\DESARROLLO WEB INTEGRADO\\PROYECTO\\XcelServer\\XcelServer\\src\\main\\webapp\\images\\productos");
 
        if (!Files.exists(rutaReal)) {
            Files.createDirectories(rutaReal); // Crear el directorio si no existe.
        }

        // Definir la ruta completa del archivo
        Path rutaArchivo = rutaReal.resolve(nombreArchivo);

        // Escribir el archivo en la ubicación especificada
        try (InputStream input = imagenPart.getInputStream()) {
            Files.copy(input, rutaArchivo, StandardCopyOption.REPLACE_EXISTING);
        }

        // Retornar la ruta relativa del archivo
        return "images/productos/" + nombreArchivo;
    }

    // Método para redirigir a la vista de almacen
    private void redirigirAlmacen(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Producto> productos = productoDAO.obtenerTodosProductos();
        List<Categoria> categorias = categoriaDAO.obtenerCategorias();
        request.setAttribute("productos", productos);
        request.setAttribute("categorias", categorias);
        request.getRequestDispatcher("almacen.jsp").forward(request, response);
    }
}
