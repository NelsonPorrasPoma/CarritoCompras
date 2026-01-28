/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelo.DetallePedido;
import modelo.Pedido;

public class PedidoDAO {

    private Connection obtenerConexion() throws SQLException {
        return conexion.conexion.conectar();
    }

    // Método para obtener todos los pedidos
    public List<Pedido> obtenerTodosLosPedidos() {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT * FROM pedidos";
        try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Pedido pedido = new Pedido();
                pedido.setId(rs.getInt("ID"));
                pedido.setClienteId(rs.getInt("CLIENTE_ID"));
                pedido.setTotal(rs.getDouble("TOTAL"));
                pedido.setEstado(rs.getString("ESTADO"));
                pedidos.add(pedido);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pedidos;
    }

    // Método para obtener detalles del pedido
    public List<DetallePedido> obtenerDetallesPorPedidoId(int pedidoId) {
        List<DetallePedido> detalles = new ArrayList<>();
        String sql = "SELECT * FROM detalle_pedido WHERE PEDIDO_ID = ?";
        try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pedidoId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DetallePedido detalle = new DetallePedido();
                    detalle.setId(rs.getInt("ID"));
                    detalle.setPedidoId(rs.getInt("PEDIDO_ID"));
                    detalle.setProductoId(rs.getInt("PRODUCTO_ID"));
                    detalle.setCantidad(rs.getInt("CANTIDAD"));
                    detalle.setPrecioUnitario(rs.getDouble("PRECIO_UNITARIO"));
                    detalles.add(detalle);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return detalles;
    }

    // Método para obtener nombre de producto por ID
    public String obtenerNombreProductoPorId(int productoId) {
        String nombreProducto = "";
        String sql = "SELECT NOMBRE FROM productos WHERE ID = ?";
        try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    nombreProducto = rs.getString("NOMBRE");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nombreProducto;
    }

    // Método para actualizar el estado del pedido
    public void actualizarEstadoPedido(int pedidoId, String nuevoEstado) {
        String sql = "UPDATE pedidos SET ESTADO = ? WHERE ID = ?";
        try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, pedidoId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Método para buscar pedidos por nombre de cliente
    public List<Pedido> buscarPedidosPorCliente(String nombreCliente) {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT p.* FROM pedidos p JOIN clientes c ON p.CLIENTE_ID = c.ID WHERE c.NOMBRE LIKE ?";
        try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + nombreCliente + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Pedido pedido = new Pedido();
                    pedido.setId(rs.getInt("ID"));
                    pedido.setClienteId(rs.getInt("CLIENTE_ID"));
                    pedido.setTotal(rs.getDouble("TOTAL"));
                    pedido.setEstado(rs.getString("ESTADO"));
                    pedidos.add(pedido);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pedidos;
    }

// Método para obtener el total de ventas
    public double obtenerTotalVentas() {
        double total = 0.0;
        String sql = "SELECT SUM(TOTAL) AS total FROM pedidos";
        try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getDouble("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

// Método para obtener la cantidad de productos vendidos
    public int obtenerCantidadProductosVendidos() {
        int cantidad = 0;
        String sql = "SELECT SUM(CANTIDAD) AS cantidad FROM detalle_pedido";
        try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                cantidad = rs.getInt("cantidad");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cantidad;
    }

// Método para buscar pedidos por fecha
    public List<Pedido> buscarPedidosPorFecha(String fechaInicio, String fechaFin) {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT * FROM pedidos WHERE FECHA BETWEEN ? AND ?";
        try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fechaInicio);
            ps.setString(2, fechaFin);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Pedido pedido = new Pedido();
                    pedido.setId(rs.getInt("ID"));
                    pedido.setClienteId(rs.getInt("CLIENTE_ID"));
                    pedido.setTotal(rs.getDouble("TOTAL"));
                    pedido.setFecha(rs.getString("FECHA"));
                    pedido.setEstado(rs.getString("ESTADO"));
                    pedidos.add(pedido);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pedidos;
    }

// Método para guardar el reporte en la base de datos
    public void guardarReporte(double totalVentas, int cantidadProductosVendidos, int empleadoId) {
        String sql = "INSERT INTO reporte (TOTAL_VENTAS, CANTIDAD_PRODUCTOS_VENDIDOS, EMPLEADO_ID) VALUES (?, ?, ?)";
        try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, totalVentas);
            ps.setInt(2, cantidadProductosVendidos);
            ps.setInt(3, empleadoId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

// Método para obtener pedidos por ID de cliente
    public List<Pedido> obtenerPedidosPorClienteId(int clienteId) {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT * FROM pedidos WHERE CLIENTE_ID = ?";
        try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clienteId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Pedido pedido = new Pedido();
                    pedido.setId(rs.getInt("ID"));
                    pedido.setClienteId(rs.getInt("CLIENTE_ID"));
                    pedido.setTotal(rs.getDouble("TOTAL"));
                    pedido.setFecha(rs.getString("FECHA"));
                    pedido.setEstado(rs.getString("ESTADO"));
                    pedidos.add(pedido);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pedidos;
    }

    public int getClientIdByUsuario(String usuario) {
        int clienteId = -1;
        String sql = "SELECT ID FROM usuarios WHERE USUARIO = ?";
        try (Connection conn = conexion.conexion.conectar(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, usuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    clienteId = rs.getInt("ID");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return clienteId;
    }

    // Método para obtener un pedido por su ID
    public Pedido obtenerPedidoPorId(int pedidoId) {
        Pedido pedido = null;
        String sql = "SELECT * FROM pedidos WHERE ID = ?";
        try (Connection conn = obtenerConexion(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, pedidoId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    pedido = new Pedido();
                    pedido.setId(rs.getInt("ID"));
                    pedido.setClienteId(rs.getInt("CLIENTE_ID"));
                    pedido.setTotal(rs.getDouble("TOTAL"));
                    pedido.setFecha(rs.getString("FECHA"));
                    pedido.setEstado(rs.getString("ESTADO"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pedido;
    }

}
