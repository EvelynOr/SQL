Proyecto: Ventas Minoristas


-- A. ANALISIS DE LA DATA

--VER tablas originales
select * from [dbo].[Store1$]			
select * from [dbo].[Sales2$]
select * from [dbo].[Item3$]
select * from [dbo].[Time4$]
select * from [dbo].[District5$]

--Relacion de las tablas por columna
[Store1$] y [Sales2$] = ID ubicacion
[Store1$] y [District5$] = Administrador 1/
[Store1$] y [District5$] = ID Distrito
[Sales2$] y [Item3$]     = ID Producto
[Sales2$] y [Time4$]     = ID Periodo de Reporte

1/ Cambio nombre de columna 'Vendedor' de Tabla [District5$] por Administrador de Tabla [Store1$]
EXEC sp_rename '[District5$].Vendedor', 'Administrador', 'COLUMN';
select * from [dbo].[District5$]

--Variables requeridas de cada tabla
[Store1$]:ID ubicacion, Tamaño Tienda, Numero de Tienda, Ciudad, Tipo de Cadena, Administrador, ID Distrito, Año Apertura, Tipo Tienda, Nombre Mes de Apertura 
[Sales2$]:ID Producto, Ingreso Margen  Bruto, Ventas Regulares, Rebajas sobre Ventas, Unidades Vendidas
[Item3$]: Categoria, Comprador, Clasificador por Grupo
[Time4$]: Periodo, Año Fiscal, Nombre Mes Fiscal
[District5$]: Administrador




--B. UNION DE LAS TABLAS (clave: [Store1$] S1 ;	[Sales2$] S2 ;	[Item3$] I ; [Time4$] T	; [District5$] D5)
Se crea la tabla VentasMinoristasPBI
SELECT
	S1.[ID ubicacion], 
	S1.[Tamaño Tienda], 
	S1.[Numero de Tienda], 
	S1.Ciudad, 
	S1.[Tipo de Cadena], 
	S1.Administrador, 
	S1.[ID Distrito], 
	S1.[Año Apertura], 
	S1.[Tipo Tienda], 
	S1.[Nombre Mes de Apertura], 
	S2.[ID Producto],
	S2.[Ingreso Margen  Bruto],
	S2.[Ventas Regulares], 
	S2.[Rebajas sobre Ventas], 
	S2.[Unidades Vendidas],
	I.Categoria, 
	I.Comprador, 
	I.[Clasificador por Grupo],
	T.Periodo, 
	T.[Año Fiscal], 
	T.[Nombre Mes Fiscal]
INTO VentasMinoristasPBI
	FROM [Store1$] S1
		INNER JOIN [Sales2$] S2 ON S1.[ID ubicacion] = S2.[ID ubicacion]
		INNER JOIN [Item3$] I ON S2.[ID Producto] = I.[ID Producto]
		INNER JOIN [Time4$] T ON S2.[ID Periodo de Reporte] = T.[ID Periodo de Reporte]
		INNER JOIN [District5$] D5 ON S1.Administrador = D5.Administrador AND S1.[ID Distrito] = D5.[ID Distrito];


--Obtener una muestra de la tabla para pruebas en PBI = 1,855 rows
SELECT *
	FROM VentasMinoristasPBI TABLESAMPLE (0.01 PERCENT);

--Crear una tabla temporal con la estructura de VentasMinoristasPBI, rows = 1487
SELECT TOP 0 *
	INTO #MuestraTemporal
		FROM VentasMinoristasPBI;

--Insertar una muestra del 0.01% en la tabla temporal
INSERT INTO #MuestraTemporal
	SELECT *
		FROM VentasMinoristasPBI TABLESAMPLE (0.01 PERCENT);

-- Crear la tabla Muestra_VentasMinoristas basada en la tabla temporal
SELECT *
	INTO Muestra_VentasMinoristas
		FROM #MuestraTemporal;

--Eliminar la tabla temporal (esta no se aplico)
DROP TABLE #MuestraTemporal;

--Bajar data
SELECT * 
	FROM [dbo].[Muestra_VentasMinoristas]
Exporta los resultados a un archivo CSV:
--Clic derecho sobre los resultados de la consulta.
--Selecciona "Copiar con encabezados".
--Pega los resultados en un archivo CSV utilizando un editor de texto o una hoja de cálculo como Microsoft Excel.

-- Consulta para obtener los nombres de las columnas de la tabla VentasMinoristasPBI
SELECT COLUMN_NAME
	FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'VentasMinoristasPBI';




--C. El proyecto se hace con la Tabla Muestra_VentasMinoristas

--1. Entender-revisar la data 
SELECT * 
	FROM Muestra_VentasMinoristas;                 


--2. Total de columnas y total de filas en la tabla
-- Total de columnas = 21
SELECT COUNT(*) AS TotalColumnas
	FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'Muestra_VentasMinoristas';

-- Total de filas = 1,187
SELECT COUNT(*) AS TotalFilas
	FROM Muestra_VentasMinoristas;


--3. Verificar nulos en la tabla = 0
DECLARE @SQL NVARCHAR(MAX);

-- Crear una tabla temporal para almacenar los nombres de columna
CREATE TABLE #ColumnNames (ColumnName NVARCHAR(MAX));

-- Insertar los nombres de columna en la tabla temporal
INSERT INTO #ColumnNames (ColumnName)
	SELECT COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME = 'Muestra_VentasMinoristas'
			AND COLUMN_NAME IS NOT NULL
			AND COLUMN_NAME <> '';

-- Construir la consulta dinámica
SELECT @SQL = 
    'SELECT * FROM Muestra_VentasMinoristas WHERE ' +
    STUFF(
        (
            SELECT ' OR ' + QUOTENAME(ColumnName) + ' IS NULL'
            FROM #ColumnNames
            FOR XML PATH('')
        ), 1, 4, ''
    );

-- Ejecutar la consulta dinámica
EXEC sp_executesql @SQL;

-- Eliminar la tabla temporal (no se aplico)
DROP TABLE #ColumnNames;


--Ver el esquema de la bases de datos, el predeterminado es "dbo" (Database Owner)
SELECT TABLE_SCHEMA
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'Muestra_VentasMinoristas';




--D. ANALISIS AREA NOMINAL (ingresos o ventas)

--4. Total de ventas = 59,945
SELECT 
	FORMAT(SUM([Ventas Regulares]), '#,##0.') AS TotalVentasRegulares
	FROM 
		[dbo].[Muestra_VentasMinoristas]


--5. Total de Rebajas sobre Ventas = 8,721
SELECT 
	FORMAT(SUM([Rebajas sobre Ventas]), '#,##0.') AS RebajasSobreVentas
	FROM 
		[dbo].[Muestra_VentasMinoristas]


--6. Ventas Netas = 51,224
SELECT 
    FORMAT(SUM([Ventas Regulares] - [Rebajas sobre Ventas]), '#,##0.') AS VentasNetas
		FROM Muestra_VentasMinoristas;


--7. Venta promedio = 6.90 
SELECT 
    AVG(
        CASE 
            WHEN [Unidades Vendidas] <> 0 THEN CAST([Ventas Regulares] AS DECIMAL) / [Unidades Vendidas]
            ELSE NULL  -- Otra opción podría ser usar 0 en lugar de NULL dependiendo de tu preferencia
        END
    ) AS VentasPromedioPorUnidad
FROM Muestra_VentasMinoristas;


--8. Ventas por category = 59,945O.2
SELECT 
    ISNULL(Categoria, 'Total') AS Categoria, 
    FORMAT(SUM([Ventas Regulares]), '#,##O.0') AS TotalVentasCategoria  
FROM Muestra_VentasMinoristas
	GROUP BY ROLLUP(Categoria)
		ORDER BY CASE WHEN Categoria IS NULL THEN 1 ELSE 0 END, 
TotalVentasCategoria ASC


--9. Margen bruto por categoria
SELECT 
    Categoria, 
    SUM([Ingreso Margen  Bruto]) AS TotalMargenBruto
FROM Muestra_VentasMinoristas
	GROUP BY Categoria
		ORDER BY TotalMargenBruto DESC


--10. Precio promedio por categoria con Ventas Regulares
SELECT 
    Categoria, 
    FORMAT(AVG([Ventas Regulares]), '#,##O.0') AS PrecioPromedio
FROM Muestra_VentasMinoristas
	GROUP BY Categoria
		ORDER BY PrecioPromedio DESC


--11. Precio maximo por categoria 
SELECT 
	Categoria, 
	MAX ([Ventas Regulares]) AS PrecioMaximo_Categoria
FROM  Muestra_VentasMinoristas
	GROUP BY Categoria
		ORDER BY PrecioMaximo_Categoria DESC


--12. Precio minimo por categoria 
SELECT 
	Categoria, 
	MIN ([Ventas Regulares]) AS PrecioMaximo_Categoria
FROM  Muestra_VentasMinoristas
	GROUP BY Categoria
		ORDER BY PrecioMaximo_Categoria DESC




--D. ANALISIS AREA REAL (producto) 


--13. Unidades vendidas = 10,522
SELECT 
	FORMAT(SUM([Unidades Vendidas]), '#,##0.') AS TotalUnidades_Vendidas
	FROM Muestra_VentasMinoristas


--14. Unidades vendidas por categoria ordenadas ascendente = 10,522
SELECT 
    ISNULL(Categoria, 'Total') AS Categoria, 
    FORMAT(SUM([Unidades Vendidas]), '#,##0.') AS TotalUnidades_Vendidas
FROM Muestra_VentasMinoristas
	GROUP BY ROLLUP(Categoria)
		ORDER BY CASE WHEN Categoria IS NULL THEN 1 ELSE 0 END, TotalUnidades_Vendidas DESC


--15. Unidades vendidas por mes = 10,522
SELECT 
    ISNULL([Nombre Mes Fiscal], 'Total') AS Mes, 
    FORMAT(SUM([Unidades Vendidas]), '#,##0.') AS TotalUnidadesVendidas
FROM Muestra_VentasMinoristas
	GROUP BY ROLLUP([Nombre Mes Fiscal])
		ORDER BY CASE WHEN [Nombre Mes Fiscal] IS NULL THEN 1 ELSE 0 END, TotalUnidadesVendidas DESC


--16. Unidades vendidas por Tipo de Cadena
SELECT 
    ISNULL([Tipo de Cadena], 'Total') AS TipoCadena, 
    FORMAT(SUM([Unidades Vendidas]), '#,##0.') AS TotalUnidadesVendidas
FROM Muestra_VentasMinoristas
	GROUP BY ROLLUP([Tipo de Cadena])
		ORDER BY CASE WHEN [Tipo de Cadena] IS NULL THEN 1 ELSE 0 END, TotalUnidadesVendidas DESC


--17. Unidades vendidas por Administrador
SELECT 
    ISNULL([Administrador], 'Total') AS Administrador, 
    FORMAT(SUM([Unidades Vendidas]), '#,##0.') AS TotalUnidadesVendidas
FROM Muestra_VentasMinoristas
	GROUP BY ROLLUP([Administrador])
		ORDER BY CASE WHEN [Administrador] IS NULL THEN 1 ELSE 0 END, TotalUnidadesVendidas DESC


--18. Unidades vendidas por Tipo Tienda
SELECT 
    ISNULL([Tipo Tienda], 'Total') AS TipoTienda, 
    FORMAT(SUM([Unidades Vendidas]), '#,##0.') AS TotalUnidadesVendidas
FROM Muestra_VentasMinoristas
	GROUP BY ROLLUP([Tipo Tienda])
		ORDER BY CASE WHEN [Tipo Tienda] IS NULL THEN 1 ELSE 0 END, TotalUnidadesVendidas DESC


--19. Unidades vendidas por Ciudad
SELECT 
    ISNULL(Ciudad, 'Total') AS Ciudad, 
    FORMAT(SUM([Unidades Vendidas]), '#,##0.') AS UnidadesVendidas
FROM Muestra_VentasMinoristas
GROUP BY ROLLUP(Ciudad)
ORDER BY CASE WHEN Ciudad IS NULL THEN 1 ELSE 0 END, SUM([Unidades Vendidas]) DESC;


--20. Top 5 Categoria vendidas
SELECT TOP 5 
    Categoria, 
    SUM([Unidades Vendidas]) AS TotalUnidadesVendidas
FROM Muestra_VentasMinoristas
	GROUP BY Categoria
		ORDER BY TotalUnidadesVendidas DESC


--21. Las 5 Categoria menos vendidas 
SELECT TOP 5 
    Categoria, 
    SUM([Unidades Vendidas]) AS TotalUnidadesVendidas
FROM Muestra_VentasMinoristas
	GROUP BY Categoria
		ORDER BY TotalUnidadesVendidas ASC




--E. ANALISIS POR TIENDA 


--21. Total de Tiendas = 65
SELECT 
	COUNT (DISTINCT [Numero de Tienda]) AS TotalTiendas
		FROM Muestra_VentasMinoristas
	

--22. Tipo de Tienda = 2
SELECT 
	COUNT (DISTINCT [Tipo Tienda]) AS TipoTienda
		FROM Muestra_VentasMinoristas


--23. Total de tiendas por Tipo de Tienda (new & same) 
SELECT 
    [Tipo Tienda] AS TipoTienda,
    COUNT(DISTINCT [Numero de Tienda]) AS TotalTiendas
		FROM Muestra_VentasMinoristas
			GROUP BY [Tipo Tienda];


--24. Ventas por Tipo de Tienda
SELECT 
    [Tipo Tienda],
    FORMAT(SUM([Ventas Regulares]), '#,##0.') AS VentasTotales
	FROM 
		Muestra_VentasMinoristas
		GROUP BY 
			[Tipo Tienda];


--25. Total de rebajas y % ofrecidas por Tipo de Tienda
SELECT 
    [Tipo Tienda],
    FORMAT(SUM([Rebajas sobre Ventas]), '#,##0.') AS TotalRebajas,
    SUM([Rebajas sobre Ventas]) / NULLIF(SUM([Ventas Regulares] + [Rebajas sobre Ventas]), 0) * 100 AS PorcentajeRebajas
		FROM 
		Muestra_VentasMinoristas
			GROUP BY 
			 [Tipo Tienda];


--26. Tiendas ubicadas por Ciudad 
SELECT 
    Ciudad,
    COUNT(DISTINCT [Numero de Tienda]) AS TiendasUbicadas
		FROM 
			Muestra_VentasMinoristas
				GROUP BY 
					Ciudad
						ORDER BY 
							TiendasUbicadas DESC;
	



--F. ANALISIS DEL RECURSO HUMANO - POR ADMINISTRADOR 


--27. Tiendas Asignadas por Administrador	
SELECT 
    Administrador,
    COUNT(DISTINCT [Numero de Tienda]) AS TiendasAsignadas
FROM 
    Muestra_VentasMinoristas
	GROUP BY 
		Administrador
			ORDER BY 
				TiendasAsignadas DESC;


--28. Ventas Regulares por Administrador
SELECT 
    Administrador,
    FORMAT(SUM([Ventas Regulares]), '#,##0.') AS VentasRegulares
FROM 
    Muestra_VentasMinoristas
		GROUP BY 
			 Administrador
				ORDER BY 
					SUM([Ventas Regulares]) DESC;


--29. Rebajas sobre Ventas Ofrecidos por Administrador 
SELECT 
    Administrador,
     FORMAT(SUM([Rebajas sobre Ventas]), '#,##0.') AS RebajasOfrecidas
FROM 
    Muestra_VentasMinoristas
		GROUP BY 
			Administrador;


--30. Unidades Vendidas y Ventas Regulares por Administrador
SELECT 
    Administrador,
    SUM([Unidades Vendidas]) AS UnidadesVendidas,
    FORMAT(SUM([Ventas Regulares]), '#,##0.') AS VentasRegulares
FROM 
    Muestra_VentasMinoristas
		GROUP BY 
			Administrador;


