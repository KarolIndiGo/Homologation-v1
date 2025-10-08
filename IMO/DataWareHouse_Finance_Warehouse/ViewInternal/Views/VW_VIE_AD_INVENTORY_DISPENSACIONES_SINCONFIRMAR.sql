-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_DISPENSACIONES_SINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Inventory_Dispensaciones_SinConfirmar]
AS

SELECT 
    u.UnitName AS Sucursal,
    i.Code AS Codigo,
    i.AdmissionNumber AS Ingreso,
    i.DocumentDate AS [Fecha Documento],
    CASE AffectInventory WHEN 1 THEN 'Si' WHEN 0 THEN 'No' END AS [Afecta Inventario],
    CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado,
    i.CreationUser AS [Codigo Usuario],
    p.Fullname AS [Usuario Crea],
    w.Code + '-' + w.Name AS Almacen
FROM [INDIGO035].[Inventory].[PharmaceuticalDispensing] AS i
INNER JOIN (
    SELECT 
        PharmaceuticalDispensingId, 
        MAX(WarehouseId) AS WarehouseId
    FROM [INDIGO035].[Inventory].[PharmaceuticalDispensingDetail]
    GROUP BY PharmaceuticalDispensingId
) AS d 
    ON d.PharmaceuticalDispensingId = i.Id
INNER JOIN [INDIGO035].[Inventory].[Warehouse] AS w
    ON w.Id = d.WarehouseId
INNER JOIN [INDIGO035].[Common].[OperatingUnit] AS u
    ON u.Id = i.OperatingUnitId
INNER JOIN [INDIGO035].[Security].[UserInt] AS us
    ON us.UserCode = i.CreationUser
INNER JOIN [INDIGO035].[Security].[PersonInt] AS p
    ON p.Id = us.IdPerson
WHERE i.Status = 1;