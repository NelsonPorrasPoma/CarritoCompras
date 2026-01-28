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
import conexion.conexion;
import modelo.Rol;

public class RolDAO {

    public List<Rol> listarRoles() throws SQLException {
        List<Rol> roles = new ArrayList<>();
        String query = "SELECT * FROM rol";
        Connection con = conexion.conectar();
        try (PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Rol rol = new Rol();
                rol.setId(rs.getInt("ID"));
                rol.setRolNombre(rs.getString("TIPO_ROL"));
                roles.add(rol);
            }
        }
        return roles;
    }
}
