/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/*  package test;

import modelo.Producto;
import DAO.ProductoDAO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class ProductoDAOTest {

    private ProductoDAO productoDAO;

    @BeforeEach
    public void setUp() {
        productoDAO = new ProductoDAO();
    }

    @Test
    public void testGuardarProducto() {
        Producto producto = new Producto("Producto Test", "Descripción del producto", 10, 1, "imagen.png", 99.99);
        boolean resultado = productoDAO.guardarProducto(producto);
        assertTrue(resultado, "El producto debería guardarse correctamente.");
 
        assertNotEquals(0, producto.getId(), "El ID generado debería ser mayor que 0.");
    }

    @Test
    public void testBuscarProductoPorId() { 
        Producto productoGuardado = new Producto("Producto Test", "Descripción del producto", 10, 1, "imagen.png", 99.99);
        productoDAO.guardarProducto(productoGuardado);
        
        Producto productoBuscado = productoDAO.buscarProductoPorId(productoGuardado.getId());
        assertNotNull(productoBuscado, "El producto con ID " + productoGuardado.getId() + " debería existir.");
        assertEquals(productoGuardado.getNombre(), productoBuscado.getNombre(), "Los nombres deberían coincidir.");
    }

    @Test
    public void testActualizarProducto() { 
        Producto productoGuardado = new Producto("Producto Test", "Descripción del producto", 10, 1, "imagen.png", 99.99);
        productoDAO.guardarProducto(productoGuardado);

        // Actualizar el producto
        productoGuardado.setNombre("Producto Actualizado");
        boolean resultado = productoDAO.actualizarProducto(productoGuardado);
        assertTrue(resultado, "El producto debería actualizarse correctamente.");

        // Verificar que el producto ha sido actualizado
        Producto productoActualizado = productoDAO.buscarProductoPorId(productoGuardado.getId());
        assertNotNull(productoActualizado, "El producto con ID " + productoGuardado.getId() + " debería existir.");
        assertEquals("Producto Actualizado", productoActualizado.getNombre(), "El nombre del producto debería actualizarse.");
    }

    @Test
    public void testEliminarProducto() {
        // Guardar un producto primero
        Producto productoGuardado = new Producto("Producto Test", "Descripción del producto", 10, 1, "imagen.png", 99.99);
        productoDAO.guardarProducto(productoGuardado);

        boolean resultado = productoDAO.eliminarProducto(productoGuardado.getId());
        assertTrue(resultado, "El producto debería eliminarse correctamente.");

        // Verificar que el producto ya no existe
        Producto productoBuscado = productoDAO.buscarProductoPorId(productoGuardado.getId());
        assertNull(productoBuscado, "El producto con ID " + productoGuardado.getId() + " no debería existir.");
    }
}
 */