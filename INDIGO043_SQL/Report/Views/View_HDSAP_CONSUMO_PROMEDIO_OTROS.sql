-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_CONSUMO_PROMEDIO_OTROS
-- Extracted by Fabric SQL Extractor SPN v3.9.0





/*******************************************************************************************************************
Nombre: InventarioConsumoPromedio
Tipo:Vista
Observacion:consumo por mes y promedio anual
Profesional: Miguel Angel Ruiz Vega
Fecha:28-08-2024
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Versión 1
Persona que modifico: 
Fecha: 
Ovservaciones: 
--------------------------------------
Versión 1
Persona que modifico:
Fecha:
***********************************************************************************************************************************/

CREATE VIEW [Report].[View_HDSAP_CONSUMO_PROMEDIO_OTROS]
AS




WITH ConsumosMensuales AS (
    SELECT 
        pro.code AS CodigoProducto,
        pro.name AS NombreProducto,
        --CONCAT(atc.code, '-', atc.Name) AS Medicamento,
        --pro.CodeCUM AS CodigoCum,
		--concat(w.code,'-',w.Name) Almacen,
        CASE 
            WHEN pro.ProductTypeId = '1' THEN 'Medicamento'
            WHEN pro.ProductTypeId = '2' THEN 'DispositivoMedico'
            WHEN pro.ProductTypeId = '3' THEN 'Elemento Consumo'
            WHEN pro.ProductTypeId = '4' THEN 'Nutricion Especial'
            WHEN pro.ProductTypeId = '5' THEN 'Equipo Biomedico'
            WHEN pro.ProductTypeId = '6' THEN 'Insumo Laboratorio'
            WHEN pro.ProductTypeId = '7' THEN 'Med VitalNO Disponible'
        END AS TipoProducto,
        MONTH(k.DocumentDate) AS Mes,
        SUM(k.Quantity) AS CantidadMensual
    FROM Inventory.Kardex k
	JOIN Inventory.InventoryProduct pro ON pro.id = k.ProductId
	JOIN inventory.Warehouse w on w.id = k.WarehouseId
    left JOIN Inventory.atc atc ON atc.id = pro.ATCId
    WHERE YEAR(k.DocumentDate) in( '2025') and k.MovementType = 2     and w.code in( '02','035','03','04','05') --and pro.code = 'DM-00226'
    GROUP BY 
        pro.code, pro.name, atc.code, atc.Name, pro.CodeCUM, pro.ProductTypeId, MONTH(k.DocumentDate),w.code,w.Name
)
SELECT 
    CodigoProducto,
    NombreProducto,
    --Medicamento,
    --CodigoCum,
    TipoProducto,
	--Almacen,
    ISNULL([1], 0) AS Enero,
    ISNULL([2], 0) AS Febrero,
    ISNULL([3], 0) AS Marzo,
    ISNULL([4], 0) AS Abril,
    ISNULL([5], 0) AS Mayo,
    ISNULL([6], 0) AS Junio,
    ISNULL([7], 0) AS Julio,
    ISNULL([8], 0) AS Agosto,
    ISNULL([9], 0) AS Septiembre,
    ISNULL([10], 0) AS Octubre,
    ISNULL([11], 0) AS Noviembre,
    ISNULL([12], 0) AS Diciembre,
    ROUND(
    (ISNULL([1], 0) + ISNULL([2], 0) + ISNULL([3], 0) + ISNULL([4], 0) +
     ISNULL([5], 0) + ISNULL([6], 0) + ISNULL([7], 0) + ISNULL([8], 0) +
     ISNULL([9], 0) + ISNULL([10], 0) + ISNULL([11], 0) + ISNULL([12], 0)) / 12.0,
    2
) AS PromedioAnual
FROM 
    ConsumosMensuales
PIVOT 
(
    SUM(CantidadMensual) 
    FOR Mes IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) AS pvt
  
  

