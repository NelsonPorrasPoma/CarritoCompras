package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import modelo.DatosPersonales;
import conexion.conexion;
import java.sql.ResultSet;

public class DatosPersonalesDAO {

    public void registrarDatosPersonales(DatosPersonales datos) throws SQLException {
        String query = "INSERT INTO datos_personales (NOMBRE, APELLIDOS, DOC_IDENTIDAD, DIRECCION, TELEFONO, CORREO, USUARIO_ID) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection con = conexion.conectar();
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, datos.getNombre());
            ps.setString(2, datos.getApellidos());
            ps.setString(3, datos.getDocIdentidad());
            ps.setString(4, datos.getDireccion());
            ps.setString(5, datos.getTelefono());
            ps.setString(6, datos.getCorreo());
            ps.setInt(7, datos.getUsuarioId());
            ps.executeUpdate();
        }
    }
 
 public void actualizarDatosPersonales(DatosPersonales datos) throws SQLException {
        String query = "UPDATE datos_personales SET NOMBRE = ?, APELLIDOS = ?, DOC_IDENTIDAD = ?, DIRECCION = ?, TELEFONO = ?, CORREO = ? WHERE USUARIO_ID = ?";
        Connection con = conexion.conectar();
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, datos.getNombre());
            ps.setString(2, datos.getApellidos());
            ps.setString(3, datos.getDocIdentidad());
            ps.setString(4, datos.getDireccion());
            ps.setString(5, datos.getTelefono());
            ps.setString(6, datos.getCorreo());
            ps.setInt(7, datos.getUsuarioId());
            ps.executeUpdate();
        }
    }

    public void eliminarDatosPersonales(int usuarioId) throws SQLException {
        String query = "DELETE FROM datos_personales WHERE USUARIO_ID = ?";
        Connection con = conexion.conectar();
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, usuarioId);
            ps.executeUpdate();
        }
    }

    public DatosPersonales obtenerDatosPersonalesPorUsuarioId(int usuarioId) throws SQLException {
        DatosPersonales datos = null;
        String query = "SELECT * FROM datos_personales WHERE USUARIO_ID = ?";
        Connection con = conexion.conectar();
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    datos = new DatosPersonales();
                    datos.setId(rs.getInt("ID"));
                    datos.setNombre(rs.getString("NOMBRE"));
                    datos.setApellidos(rs.getString("APELLIDOS"));
                    datos.setDocIdentidad(rs.getString("DOC_IDENTIDAD"));
                    datos.setDireccion(rs.getString("DIRECCION"));
                    datos.setTelefono(rs.getString("TELEFONO"));
                    datos.setCorreo(rs.getString("CORREO"));
                    datos.setUsuarioId(rs.getInt("USUARIO_ID"));
                }
            }
        }
        return datos;
    }
}