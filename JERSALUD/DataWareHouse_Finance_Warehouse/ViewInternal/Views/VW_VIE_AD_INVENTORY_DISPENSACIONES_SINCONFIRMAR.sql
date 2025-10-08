-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_DISPENSACIONES_SINCONFIRMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_INVENTORY_DISPENSACIONES_SINCONFIRMAR
AS
SELECT u.UnitName AS Sucursal, i.Code AS Codigo, i.AdmissionNumber AS Ingreso, i.DocumentDate AS [Fecha Documento], CASE AffectInventory WHEN 1 THEN 'Si' WHEN 0 THEN 'No' END AS [Afecta Inventario], CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado, 
           i.CreationUser AS [Codigo Usuario], p.Fullname AS [Usuario Crea], w.Code+'-'+w.Name as Almacen
FROM    INDIGO031.Inventory.PharmaceuticalDispensing AS i INNER JOIN
		( select PharmaceuticalDispensingId, max(WarehouseId) as WarehouseId
			from  INDIGO031.Inventory.PharmaceuticalDispensingDetail
			group by PharmaceuticalDispensingId) as d on d.PharmaceuticalDispensingId=i.Id inner join
			 INDIGO031.Inventory.Warehouse as w   on w.Id=d.WarehouseId inner join
            INDIGO031.Common.OperatingUnit AS u   ON u.Id = i.OperatingUnitId INNER JOIN
           INDIGO031.Security.[UserInt] AS us   ON us.UserCode = i.CreationUser INNER JOIN
           INDIGO031.Security.PersonInt AS p   ON p.Id = us.IdPerson
WHERE (i.Status = 1)