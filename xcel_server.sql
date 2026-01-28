-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 10-07-2025 a las 03:17:36
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `xcel_server`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `ID` int(11) NOT NULL,
  `CATEGORIA` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`ID`, `CATEGORIA`) VALUES
(1, 'MONITOR'),
(2, 'LAPTOP'),
(3, 'MOUSE'),
(4, 'TECLADOS'),
(5, 'AUDIO'),
(6, 'PARLANTES'),
(7, 'CABLES'),
(8, 'IMPRESORAS'),
(9, 'TINTAS'),
(10, 'ALMACENAMIENTO'),
(11, 'PARLANTES'),
(13, 'IMPRESORAS'),
(16, 'CARGADOR');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `datos_personales`
--

CREATE TABLE `datos_personales` (
  `ID` int(11) NOT NULL,
  `NOMBRE` varchar(100) NOT NULL,
  `APELLIDOS` varchar(100) NOT NULL,
  `DOC_IDENTIDAD` varchar(20) NOT NULL,
  `DIRECCION` varchar(255) DEFAULT NULL,
  `TELEFONO` varchar(15) DEFAULT NULL,
  `CORREO` varchar(100) DEFAULT NULL,
  `USUARIO_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `datos_personales`
--

INSERT INTO `datos_personales` (`ID`, `NOMBRE`, `APELLIDOS`, `DOC_IDENTIDAD`, `DIRECCION`, `TELEFONO`, `CORREO`, `USUARIO_ID`) VALUES
(1, 'Yower', 'Asmat', '12345678', 'Tarma', '123456789', 'yAsmats@gmail.com', 1),
(2, 'Dafne', 'Incio', '87654321', 'Tarma', '987654321', 'dIncio@gmail.com', 2),
(3, 'Nelson', 'Porras', '11223344', 'Tarma', '456789123', 'nporras@gmail.com', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_pedido`
--

CREATE TABLE `detalle_pedido` (
  `ID` int(11) NOT NULL,
  `PEDIDO_ID` int(11) DEFAULT NULL,
  `PRODUCTO_ID` int(11) DEFAULT NULL,
  `CANTIDAD` int(11) NOT NULL,
  `PRECIO_UNITARIO` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_pedido`
--

INSERT INTO `detalle_pedido` (`ID`, `PEDIDO_ID`, `PRODUCTO_ID`, `CANTIDAD`, `PRECIO_UNITARIO`) VALUES
(1, 1, 3, 2, 25.00),
(2, 1, 7, 2, 28.00),
(3, 2, 7, 2, 28.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `ID` int(11) NOT NULL,
  `CLIENTE_ID` int(11) DEFAULT NULL,
  `EMPLEADO_ID` int(11) DEFAULT NULL,
  `FECHA` timestamp NOT NULL DEFAULT current_timestamp(),
  `TOTAL` decimal(10,2) NOT NULL,
  `ESTADO` enum('Pendiente','Pagado','Enviado','Recibido') NOT NULL DEFAULT 'Pendiente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`ID`, `CLIENTE_ID`, `EMPLEADO_ID`, `FECHA`, `TOTAL`, `ESTADO`) VALUES
(1, 2, NULL, '2025-07-08 01:32:06', 106.00, 'Enviado'),
(2, 2, NULL, '2025-07-09 06:30:19', 56.00, 'Pendiente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `ID` int(11) NOT NULL,
  `NOMBRE` varchar(100) NOT NULL,
  `DESCRIPCION` text DEFAULT NULL,
  `STOCK` int(11) NOT NULL,
  `IMAGEN` varchar(150) DEFAULT NULL,
  `PRECIO` decimal(10,2) NOT NULL,
  `CATEGORIA_ID` int(11) DEFAULT NULL,
  `FECHA_CREACION` timestamp NOT NULL DEFAULT current_timestamp(),
  `FECHA_ACTUALIZACION` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`ID`, `NOMBRE`, `DESCRIPCION`, `STOCK`, `IMAGEN`, `PRECIO`, `CATEGORIA_ID`, `FECHA_CREACION`, `FECHA_ACTUALIZACION`) VALUES
(3, 'Mouse', 'Mouse1', 12, 'images/productos/mouse1.jpeg', 25.00, 3, '2025-05-05 23:56:31', '2025-05-05 23:56:31'),
(7, 'Teclado', 'Teclado', 5, 'images/productos/teclado.jpg', 28.00, 4, '2025-06-03 01:22:12', '2025-06-03 01:22:12'),
(21, 'Cargador Iphone', 'Cargador Iphone', 3, 'images/productos/AdaptadorIphone20w.jpg', 50.00, 16, '2025-07-09 01:14:50', '2025-07-09 01:14:50'),
(23, 'Parlante', 'Parlante', 9, 'images/productos/OIP.webp', 85.00, 11, '2025-07-09 06:33:29', '2025-07-09 06:33:29'),
(24, 'Disco duro', '500GB', 3, 'images/productos/disco duro.jpg', 120.00, 10, '2025-07-09 21:59:24', '2025-07-09 21:59:24'),
(27, 'Monitor', 'Monitor 27', 6, 'images/productos/monitor.jpg', 99.99, 1, '2025-07-09 22:44:28', '2025-07-09 23:45:48'),
(28, 'Monitor 2', 'Monitor 32', 9, 'images/productos/MONITOR2.png', 105.00, 1, '2025-07-09 22:58:44', '2025-07-09 23:45:57');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reporte`
--

CREATE TABLE `reporte` (
  `ID` int(11) NOT NULL,
  `FECHA_GENERACION` timestamp NOT NULL DEFAULT current_timestamp(),
  `TOTAL_VENTAS` decimal(10,2) DEFAULT NULL,
  `CANTIDAD_PRODUCTOS_VENDIDOS` int(11) DEFAULT NULL,
  `EMPLEADO_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `ID` int(11) NOT NULL,
  `TIPO_ROL` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`ID`, `TIPO_ROL`) VALUES
(1, 'EMPLEADO'),
(2, 'CLIENTE'),
(3, 'ADMINISTRADOR');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `ID` int(11) NOT NULL,
  `USUARIO` varchar(50) NOT NULL,
  `CONTRASEÑA` varchar(255) NOT NULL,
  `ROL_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`ID`, `USUARIO`, `CONTRASEÑA`, `ROL_ID`) VALUES
(1, 'empleado', '0baff97ff722b0be472c1ff5a1edabf7cefb089d0575794975c3007989327efa', 1),
(2, 'cliente', 'a60b85d409a01d46023f90741e01b79543a3cb1ba048eaefbe5d7a63638043bf', 2),
(3, 'admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 3);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `datos_personales`
--
ALTER TABLE `datos_personales`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `DOC_IDENTIDAD` (`DOC_IDENTIDAD`),
  ADD UNIQUE KEY `CORREO` (`CORREO`),
  ADD KEY `datos_personales_ibfk_1` (`USUARIO_ID`);

--
-- Indices de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `PEDIDO_ID` (`PEDIDO_ID`),
  ADD KEY `PRODUCTO_ID` (`PRODUCTO_ID`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `CLIENTE_ID` (`CLIENTE_ID`),
  ADD KEY `EMPLEADO_ID` (`EMPLEADO_ID`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `CATEGORIA_ID` (`CATEGORIA_ID`);

--
-- Indices de la tabla `reporte`
--
ALTER TABLE `reporte`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `EMPLEADO_ID` (`EMPLEADO_ID`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `USUARIO` (`USUARIO`),
  ADD KEY `ROL_ID` (`ROL_ID`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `datos_personales`
--
ALTER TABLE `datos_personales`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT de la tabla `reporte`
--
ALTER TABLE `reporte`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `datos_personales`
--
ALTER TABLE `datos_personales`
  ADD CONSTRAINT `datos_personales_ibfk_1` FOREIGN KEY (`USUARIO_ID`) REFERENCES `usuarios` (`ID`) ON DELETE CASCADE;

--
-- Filtros para la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD CONSTRAINT `detalle_pedido_ibfk_1` FOREIGN KEY (`PEDIDO_ID`) REFERENCES `pedidos` (`ID`) ON DELETE CASCADE,
  ADD CONSTRAINT `detalle_pedido_ibfk_2` FOREIGN KEY (`PRODUCTO_ID`) REFERENCES `productos` (`ID`);

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`CLIENTE_ID`) REFERENCES `usuarios` (`ID`),
  ADD CONSTRAINT `pedidos_ibfk_2` FOREIGN KEY (`EMPLEADO_ID`) REFERENCES `usuarios` (`ID`);

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`CATEGORIA_ID`) REFERENCES `categoria` (`ID`);

--
-- Filtros para la tabla `reporte`
--
ALTER TABLE `reporte`
  ADD CONSTRAINT `reporte_ibfk_1` FOREIGN KEY (`EMPLEADO_ID`) REFERENCES `usuarios` (`ID`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`ROL_ID`) REFERENCES `rol` (`ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
