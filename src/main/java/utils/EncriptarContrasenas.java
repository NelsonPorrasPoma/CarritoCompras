/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import conexion.conexion;
import utils.PasswordUtils;

public class EncriptarContrasenas {

    public static void main(String[] args) throws SQLException {
        Connection con = conexion.conectar();
        String querySelect = "SELECT ID, CONTRASEÑA FROM USUARIOS";
        String queryUpdate = "UPDATE USUARIOS SET CONTRASEÑA = ? WHERE ID = ?";

        try (PreparedStatement psSelect = con.prepareStatement(querySelect);
             ResultSet rs = psSelect.executeQuery()) {

            while (rs.next()) {
                int userId = rs.getInt("ID");
                String password = rs.getString("CONTRASEÑA");

                // Encriptar la contraseña existente
                String hashedPassword = PasswordUtils.hashPassword(password);

                // Actualizar la contraseña encriptada en la base de datos
                try (PreparedStatement psUpdate = con.prepareStatement(queryUpdate)) {
                    psUpdate.setString(1, hashedPassword);
                    psUpdate.setInt(2, userId);
                    psUpdate.executeUpdate();
                }
            }

            System.out.println("Todas las contraseñas han sido encriptadas correctamente.");
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error al encriptar contraseñas.");
        }
    }
}
