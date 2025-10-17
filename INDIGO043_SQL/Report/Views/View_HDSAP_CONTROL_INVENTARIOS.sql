-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_CONTROL_INVENTARIOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0






/*******************************************************************************************************************
Nombre: InventarioConsumoPromedio
Tipo:Vista
Observacion: Control Inventario
Profesional: Miguel Angel Ruiz Vega
Fecha:17-02-2025

Modificación _ Motivo = Cantidades disponibles
Profesional: Milton Urbano Bolañoz
Fecha:20-08-2025

-----------------------------------------------------------------*/




CREATE VIEW [Report].[View_HDSAP_CONTROL_INVENTARIOS]
AS



WITH DispensacionesMensuales AS
(
    SELECT 
        pro.Code AS [COD PRODUCTO],
        pro.Name AS [NOMBRE PRODUCTO],
        CASE 
            WHEN pro.ProductTypeId = '1' THEN 'Medicamento'
            WHEN pro.ProductTypeId = '2' THEN 'DispositivoMedico'
            WHEN pro.ProductTypeId = '3' THEN 'Elemento Consumo'
            WHEN pro.ProductTypeId = '4' THEN 'Nutricion Especial'
            WHEN pro.ProductTypeId = '5' THEN 'Equipo Biomedico'
            WHEN pro.ProductTypeId = '6' THEN 'Insumo Laboratorio'
            WHEN pro.ProductTypeId = '7' THEN 'Med VitalNO Disponible'
        END AS [TIPO DE PRODUCTO],
        w.Name AS [ALMACENES DE FARMACIA],
        pro.MinimumStock  AS [STOCK MINIMO],
        pro.MaximumStock  AS [STOCK MAXIMO],
        MONTH(p.DocumentDate) AS [Mes],
        SUM(pd.Quantity) AS [CantidadTotal]
    FROM Inventory.PharmaceuticalDispensing p
         INNER JOIN Inventory.PharmaceuticalDispensingDetail pd ON pd.PharmaceuticalDispensingId = p.Id
         INNER JOIN Inventory.InventoryProduct pro ON pro.Id = pd.ProductId
         INNER JOIN Inventory.Warehouse w ON w.Id = pd.WarehouseId
    WHERE YEAR(p.DocumentDate) = 2025 
      AND w.Code IN ('02','03','04','035','05')
      ---AND pro.Code = 'DM-00337'
    GROUP BY 
        pro.Code, pro.Name, pro.ProductTypeId, w.Name, pro.MinimumStock, pro.MaximumStock, 
        MONTH(p.DocumentDate)
),
InventarioActual AS
(
    SELECT 
        pro.Code AS [COD PRODUCTO],
        w.Name AS [ALMACENES DE FARMACIA],
        SUM(pi.Quantity) AS [CANTIDAD DISPONIBLE]  -- 🔹 suma todos los lotes
    FROM Inventory.PhysicalInventory pi
         INNER JOIN Inventory.InventoryProduct pro ON pro.Id = pi.ProductId
         INNER JOIN Inventory.Warehouse w ON w.Id = pi.WarehouseId
    WHERE w.Code IN ('02','03','04','035','05')
      ---AND pro.Code = 'DM-00337'
    GROUP BY pro.Code, w.Name
)
SELECT 
    pvt.[COD PRODUCTO],
    pvt.[NOMBRE PRODUCTO],
    pvt.[TIPO DE PRODUCTO],
    pvt.[ALMACENES DE FARMACIA],
    pvt.[STOCK MINIMO],
    pvt.[STOCK MAXIMO],
    ia.[CANTIDAD DISPONIBLE],  -- 🔹 cantidad total sumada
    ISNULL([1], 0)  AS [Enero],
    ISNULL([2], 0)  AS [Febrero],
    ISNULL([3], 0)  AS [Marzo],
    ISNULL([4], 0)  AS [Abril],
    ISNULL([5], 0)  AS [Mayo],
    ISNULL([6], 0)  AS [Junio],
    ISNULL([7], 0)  AS [Julio],
    ISNULL([8], 0)  AS [Agosto],
    ISNULL([9], 0)  AS [Septiembre],
    ISNULL([10], 0) AS [Octubre],
    ISNULL([11], 0) AS [Noviembre],
    ISNULL([12], 0) AS [Diciembre],
    ROUND(
        (ISNULL([1], 0) + ISNULL([2], 0) + ISNULL([3], 0) + ISNULL([4], 0) +
         ISNULL([5], 0) + ISNULL([6], 0) + ISNULL([7], 0) + ISNULL([8], 0) +
         ISNULL([9], 0) + ISNULL([10], 0) + ISNULL([11], 0) + ISNULL([12], 0)) / 12.0,
        2
    ) AS Promedio
FROM DispensacionesMensuales
PIVOT
(
    SUM([CantidadTotal]) 
    FOR [Mes] IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) AS pvt
LEFT JOIN InventarioActual ia
    ON pvt.[COD PRODUCTO] = ia.[COD PRODUCTO]
   AND pvt.[ALMACENES DE FARMACIA] = ia.[ALMACENES DE FARMACIA];


