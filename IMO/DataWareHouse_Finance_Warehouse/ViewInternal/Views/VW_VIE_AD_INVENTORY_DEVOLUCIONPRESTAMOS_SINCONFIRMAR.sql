-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_DEVOLUCIONPRESTAMOS_SINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Inventory_DevolucionPrestamos_SinConfirmar]
AS

SELECT 
    u.UnitName AS Sucursal,
    i.Code AS Codigo,
    i.DocumentDate AS [Fecha Documento],
    o.Name AS Almacen,
    i.Observation AS Observacion,
    CASE i.Status 
        WHEN 1 THEN 'Registrado' 
        WHEN 2 THEN 'Confirmado' 
        WHEN 3 THEN 'Anulado' 
    END AS Estado
FROM [INDIGO035].[Inventory].[LoanMerchandiseDevolution] AS i
INNER JOIN [INDIGO035].[Inventory].[Warehouse] AS o
    ON o.Id = i.WarehouseId
INNER JOIN [INDIGO035].[Common].[OperatingUnit] AS u
    ON u.Id = i.OperatingUnitId
WHERE i.Status = 1;