-- ==========================================
-- CONSULTAS SOBRE LA TABLA PRODUCTOS
-- ==========================================

-- 1. Mostrar todos los productos
SELECT *
FROM productos;

-- 2. Mostrar los productos ordenados por nombre
SELECT *
FROM productos
ORDER BY Nombre;

-- 3. Mostrar los productos del más caro al más barato
SELECT *
FROM productos
ORDER BY Precio DESC;

-- 4. Mostrar los productos cuyo precio sea mayor a 1000
SELECT *
FROM productos
WHERE Precio > 1000;

-- 5. Mostrar los productos con precio entre 500 y 2000
SELECT *
FROM productos
WHERE Precio BETWEEN 500 AND 2000;

-- 6. Contar la cantidad de productos
SELECT COUNT(*) AS TotalProductos
FROM productos;

-- 7. Obtener el precio promedio de los productos
SELECT AVG(Precio) AS PrecioPromedio
FROM productos;

-- 8. Mostrar el producto más caro
SELECT *
FROM productos
ORDER BY Precio DESC
LIMIT 1;

-- 9. Mostrar el producto más barato
SELECT *
FROM productos
ORDER BY Precio ASC
LIMIT 1;

-- 10. Mostrar los productos de una categoría específica
SELECT *
FROM productos
WHERE categoria = 'Bebidas';


-- ==========================================
-- CONSULTAS SOBRE LA TABLA CLIENTES
-- ==========================================

-- 11. Mostrar todos los clientes
SELECT *
FROM clientes;

-- 12. Mostrar los clientes ordenados por apellido
SELECT *
FROM clientes
ORDER BY Apellido;

-- 13. Mostrar los clientes ordenados por nombre
SELECT *
FROM clientes
ORDER BY Nombre;

-- 14. Buscar un cliente por apellido
SELECT *
FROM clientes
WHERE Apellido = 'Gomez';

-- 15. Buscar clientes cuyo nombre comience con la letra A
SELECT *
FROM clientes
WHERE Nombre LIKE 'A%';

-- 16. Buscar clientes cuyo apellido termine con la letra z
SELECT *
FROM clientes
WHERE Apellido LIKE '%z';

-- 17. Contar la cantidad de clientes registrados
SELECT COUNT(*) AS TotalClientes
FROM clientes;

-- 18. Mostrar los correos electrónicos registrados
SELECT Nombre, Apellido, Email
FROM clientes;

-- 19. Mostrar los clientes cuyo teléfono sea mayor a 5000000
SELECT *
FROM clientes
WHERE telefono > 5000000;

-- 20. Mostrar el listado de clientes ordenado por apellido y nombre
SELECT *
FROM clientes
ORDER BY Apellido, Nombre;


-- ==========================================
-- CONSULTAS SOBRE LA TABLA DET_COMPRA
-- ==========================================

-- 21. Mostrar todos los detalles de compra
SELECT *
FROM det_compra;

-- 22. Mostrar la cantidad total de registros
SELECT COUNT(*) AS TotalDetalles
FROM det_compra;

-- 23. Mostrar los productos con una cantidad mayor a 5
SELECT *
FROM det_compra
WHERE Cantidad > 5;

-- 24. Mostrar los detalles ordenados por cantidad
SELECT *
FROM det_compra
ORDER BY Cantidad DESC;

-- 25. Calcular el valor total por cada registro de compra
SELECT
    idCompra,
    idProductos,
    Cantidad,
    Valor_unitario,
    (Cantidad * Valor_unitario) AS Total
FROM det_compra;


-- ==========================================
-- CONSULTAS CON INNER JOIN
-- ==========================================

-- 26. Mostrar todas las compras junto con el nombre del cliente
SELECT
    c.idCompra,
    cl.Nombre,
    cl.Apellido,
    c.Fecha,
    c.Valor_Total
FROM compra c
INNER JOIN clientes cl
    ON c.idClientes = cl.idClientes;

-- 27. Mostrar los productos incluidos en cada compra
SELECT
    dc.idCompra,
    p.Nombre AS Producto,
    dc.Cantidad,
    dc.Valor_unitario
FROM det_compra dc
INNER JOIN productos p
    ON dc.idProductos = p.idProductos;

-- 28. Mostrar el detalle completo de cada compra
SELECT
    c.idCompra,
    cl.Nombre,
    cl.Apellido,
    p.Nombre AS Producto,
    dc.Cantidad,
    dc.Valor_unitario,
    (dc.Cantidad * dc.Valor_unitario) AS Total
FROM compra c
INNER JOIN clientes cl
    ON c.idClientes = cl.idClientes
INNER JOIN det_compra dc
    ON c.idCompra = dc.idCompra
INNER JOIN productos p
    ON dc.idProductos = p.idProductos;

-- 29. Cantidad total vendida por producto
SELECT
    p.Nombre,
    SUM(dc.Cantidad) AS TotalVendido
FROM productos p
INNER JOIN det_compra dc
    ON p.idProductos = dc.idProductos
GROUP BY p.Nombre
ORDER BY TotalVendido DESC;

-- 30. Total vendido por cliente
SELECT
    cl.Nombre,
    cl.Apellido,
    SUM(dc.Cantidad * dc.Valor_unitario) AS TotalGastado
FROM clientes cl
INNER JOIN compra c
    ON cl.idClientes = c.idClientes
INNER JOIN det_compra dc
    ON c.idCompra = dc.idCompra
GROUP BY cl.idClientes, cl.Nombre, cl.Apellido
ORDER BY TotalGastado DESC;


-- ==========================================
-- CONSULTAS AVANZADAS
-- ==========================================

-- 31. Mostrar los 5 productos más caros
SELECT Nombre, Precio
FROM productos
ORDER BY Precio DESC
LIMIT 5;

-- 32. Mostrar el precio promedio por categoría
SELECT categoria,
       AVG(Precio) AS PrecioPromedio
FROM productos
GROUP BY categoria;

-- 33. Mostrar las categorías con un precio promedio mayor a 1000
SELECT categoria,
       AVG(Precio) AS PrecioPromedio
FROM productos
GROUP BY categoria
HAVING AVG(Precio) > 1000;

-- 34. Mostrar cuántos productos tiene cada categoría
SELECT categoria,
       COUNT(*) AS CantidadProductos
FROM productos
GROUP BY categoria;

-- 35. Mostrar el cliente que realizó más compras
SELECT
    cl.Nombre,
    cl.Apellido,
    COUNT(c.idCompra) AS CantidadCompras
FROM clientes cl
INNER JOIN compra c
ON cl.idClientes = c.idClientes
GROUP BY cl.idClientes, cl.Nombre, cl.Apellido
ORDER BY CantidadCompras DESC;

-- 36. Mostrar el total de dinero vendido por producto
SELECT
    p.Nombre,
    SUM(dc.Cantidad * dc.Valor_unitario) AS TotalVendido
FROM productos p
INNER JOIN det_compra dc
ON p.idProductos = dc.idProductos
GROUP BY p.idProductos, p.Nombre
ORDER BY TotalVendido DESC;

-- 37. Mostrar el total de unidades vendidas por producto
SELECT
    p.Nombre,
    SUM(dc.Cantidad) AS UnidadesVendidas
FROM productos p
INNER JOIN det_compra dc
ON p.idProductos = dc.idProductos
GROUP BY p.idProductos, p.Nombre
ORDER BY UnidadesVendidas DESC;

-- 38. Mostrar los clientes que realizaron más de una compra
SELECT
    cl.Nombre,
    cl.Apellido,
    COUNT(c.idCompra) AS Compras
FROM clientes cl
INNER JOIN compra c
ON cl.idClientes = c.idClientes
GROUP BY cl.idClientes, cl.Nombre, cl.Apellido
HAVING COUNT(c.idCompra) > 1;

-- 39. Mostrar el precio máximo, mínimo y promedio de los productos
SELECT
    MAX(Precio) AS PrecioMaximo,
    MIN(Precio) AS PrecioMinimo,
    AVG(Precio) AS PrecioPromedio
FROM productos;

-- 40. Mostrar la cantidad total de ventas registradas
SELECT COUNT(*) AS TotalVentas
FROM compra;




