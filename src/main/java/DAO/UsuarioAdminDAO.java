/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import conexion.conexion;
import java.sql.Connection; 
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import modelo.Usuario;
import utils.PasswordUtils;

public class UsuarioAdminDAO {

        public int registrarUsuario(Usuario usuario) throws SQLException {
        int usuarioId = 0;
        String query = "INSERT INTO usuarios (USUARIO, CONTRASEÑA, ROL_ID) VALUES (?, ?, ?)";
        Connection con = conexion.conectar();
        try (PreparedStatement ps = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, usuario.getUsuario());
          
            // Encripta la contraseña antes de guardarla
            String hashedPassword = PasswordUtils.hashPassword(usuario.getContrasena());
            ps.setString(2, hashedPassword);
            
            ps.setInt(3, Integer.parseInt(usuario.getRol()));
            ps.executeUpdate();
            
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                usuarioId = rs.getInt(1);
            }
        }
        return usuarioId;
    }

    public List<Usuario> listarUsuarios() throws SQLException {
        List<Usuario> usuarios = new ArrayList<>();
        String query = "SELECT * FROM usuarios";
        Connection con = conexion.conectar();
        try (PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setId(rs.getInt("ID"));
                usuario.setUsuario(rs.getString("USUARIO"));
                usuario.setContrasena(rs.getString("CONTRASEÑA"));
                usuario.setRol(String.valueOf(rs.getInt("ROL_ID")));
                usuarios.add(usuario);
            }
        }
        return usuarios;
    }

    public void actualizarUsuario(Usuario usuario) throws SQLException {
        String query = "UPDATE usuarios SET USUARIO = ?, CONTRASEÑA = ?, ROL_ID = ? WHERE ID = ?";
        Connection con = conexion.conectar();
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, usuario.getUsuario());
             
        if (usuario.getContrasena() != null && !usuario.getContrasena().isEmpty()) {
            String hashedPassword = PasswordUtils.hashPassword(usuario.getContrasena());
            ps.setString(2, hashedPassword);
        } else { 
            ps.setString(2, usuario.getContrasena());
        }
            ps.setInt(3, Integer.parseInt(usuario.getRol()));
            ps.setInt(4, usuario.getId());
            ps.executeUpdate();
        }
    }

    public void eliminarUsuario(int id) throws SQLException {
        String query = "DELETE FROM usuarios WHERE ID = ?";
        Connection con = conexion.conectar();
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public Usuario obtenerUsuarioPorId(int id) throws SQLException {
        Usuario usuario = null;
        String query = "SELECT * FROM usuarios WHERE ID = ?";
        Connection con = conexion.conectar();
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setId(rs.getInt("ID"));
                    usuario.setUsuario(rs.getString("USUARIO"));
                    usuario.setContrasena(rs.getString("CONTRASEÑA"));
                    usuario.setRol(String.valueOf(rs.getInt("ROL_ID")));
                }
            }
        }
        return usuario;
    }
    

    public List<Usuario> buscarUsuariosPorNombre(String nombre) throws SQLException {
        List<Usuario> usuarios = new ArrayList<>();
        String query = "SELECT * FROM usuarios WHERE USUARIO LIKE ?";
        Connection con = conexion.conectar();
        try (PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, "%" + nombre + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setId(rs.getInt("ID"));
                    usuario.setUsuario(rs.getString("USUARIO"));
                    usuario.setContrasena(rs.getString("CONTRASEÑA"));
                    usuario.setRol(String.valueOf(rs.getInt("ROL_ID")));
                    usuarios.add(usuario);
                }
            }
        }
        return usuarios;
        
    }
}
