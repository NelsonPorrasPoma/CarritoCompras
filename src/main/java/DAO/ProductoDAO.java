/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import conexion.conexion;
import java.sql.SQLException;
import modelo.Producto;

public class ProductoDAO {

    // Obtener productos para mostrar 
    public List<Producto> obtenerTodosProductos() {
    List<Producto> productos = new ArrayList<>();
    String sql = "SELECT * FROM productos";
    try (Connection con = conexion.conectar();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Producto producto = new Producto(
                rs.getString("NOMBRE"),
                rs.getString("DESCRIPCION"),
                rs.getInt("STOCK"),
                rs.getInt("CATEGORIA_ID"),
                rs.getString("IMAGEN"),
                rs.getDouble("PRECIO")
            );
            producto.setId(rs.getInt("ID"));
            productos.add(producto);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return productos;
}

    
    // Buscar productos por nombre
    public List<Producto> buscarProductosPorNombre(String nombre) {
        List<Producto> productos = new ArrayList<>();
        String sql = "SELECT * FROM productos WHERE NOMBRE LIKE ?";

        try (Connection con = conexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + nombre + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Producto producto = new Producto(
                        rs.getString("NOMBRE"),
                        rs.getString("DESCRIPCION"),
                        rs.getInt("STOCK"),
                        rs.getInt("CATEGORIA_ID"),
                        rs.getString("IMAGEN"),
                        rs.getDouble("PRECIO")
                    );
                    producto.setId(rs.getInt("ID"));
                    productos.add(producto);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return productos;
    }

    // Buscar productos por nombre o categoría
    public List<Producto> buscarProductos(String nombre, String categoriaId) {
        List<Producto> productos = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM productos WHERE 1=1");

        if (nombre != null && !nombre.isEmpty()) {
            sql.append(" AND NOMBRE LIKE ?");
        }
        if (categoriaId != null && !categoriaId.isEmpty()) {
            sql.append(" AND CATEGORIA_ID = ?");
        }

        try (Connection con = conexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (nombre != null && !nombre.isEmpty()) {
                ps.setString(paramIndex++, "%" + nombre + "%");
            }
            if (categoriaId != null && !categoriaId.isEmpty()) {
                ps.setInt(paramIndex, Integer.parseInt(categoriaId));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Producto producto = new Producto(
                        rs.getString("NOMBRE"),
                        rs.getString("DESCRIPCION"),
                        rs.getInt("STOCK"),
                        rs.getInt("CATEGORIA_ID"),
                        rs.getString("IMAGEN"),
                        rs.getDouble("PRECIO")
                    );
                    producto.setId(rs.getInt("ID"));
                    productos.add(producto);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return productos;
    }
    
    // Guardar producto
    public boolean guardarProducto(Producto producto) {
    String sql = "INSERT INTO productos (NOMBRE, DESCRIPCION, STOCK, CATEGORIA_ID, IMAGEN, PRECIO) VALUES (?, ?, ?, ?, ?, ?)";
    try (Connection conn = conexion.conectar();
         PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) { 
 
        stmt.setString(1, producto.getNombre());
        stmt.setString(2, producto.getDescripcion());
        stmt.setInt(3, producto.getStock());
        stmt.setInt(4, producto.getCategoria());
        stmt.setString(5, producto.getImagen());
        stmt.setDouble(6, producto.getPrecio());
 
        int affectedRows = stmt.executeUpdate();

        if (affectedRows > 0) {
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {  
                if (generatedKeys.next()) {
                    producto.setId(generatedKeys.getInt(1));  
                }
            }
            return true;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

    // Actualizar producto
    public boolean actualizarProducto(Producto producto) {
        String sql = "UPDATE productos SET NOMBRE=?, DESCRIPCION=?, STOCK=?, CATEGORIA_ID=?, IMAGEN=?, PRECIO=?, FECHA_ACTUALIZACION=CURRENT_TIMESTAMP() WHERE ID=?";
        try (Connection con = conexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, producto.getNombre());
            ps.setString(2, producto.getDescripcion());
            ps.setInt(3, producto.getStock());
            ps.setInt(4, producto.getCategoria());
            ps.setString(5, producto.getImagen());
            ps.setDouble(6, producto.getPrecio());
            ps.setInt(7, producto.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
     // Buscar producto por ID
    public Producto buscarProductoPorId(int id) {
        Producto producto = null;
        String sql = "SELECT * FROM productos WHERE ID=?";
        try (Connection con = conexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    producto = new Producto(
                        rs.getString("NOMBRE"),
                        rs.getString("DESCRIPCION"),
                        rs.getInt("STOCK"),
                        rs.getInt("CATEGORIA_ID"),
                        rs.getString("IMAGEN"),
                        rs.getDouble("PRECIO")
                    );
                    producto.setId(rs.getInt("ID"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return producto;
    }

    // Eliminar producto
    public boolean eliminarProducto(int id) {
        String sql = "DELETE FROM productos WHERE ID=?";
        try (Connection con = conexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
}
