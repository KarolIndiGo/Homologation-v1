-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_PRESTAMOSSINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Inventory_PrestamosSinConfirmar]
AS

SELECT 
    u.UnitName AS Sucursal,
    i.Code AS Codigo,
    i.DocumentDate AS [Fecha Documento],
    CASE i.LoanType WHEN 1 THEN 'Entrada' WHEN 2 THEN 'Salida' END AS TipoPrestamo,
    o.Name AS Almacen,
    t.Name AS Tercero,
    i.Observation AS Observacion,
    CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado
FROM [INDIGO035].[Inventory].[LoanMerchandise] AS i
INNER JOIN [INDIGO035].[Inventory].[Warehouse] AS o
    ON o.Id = i.WarehouseId
INNER JOIN [INDIGO035].[Common].[OperatingUnit] AS u
    ON u.Id = i.OperatingUnitId
INNER JOIN [INDIGO035].[Common].[ThirdParty] AS t
    ON t.Id = i.ThirdPartyId
WHERE i.Status = 1;