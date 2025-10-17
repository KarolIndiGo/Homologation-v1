-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Inventory_Dispensaciones_SinConfirmar
-- Extracted by Fabric SQL Extractor SPN v3.9.0


create VIEW [ViewInternal].[VIE_AD_Inventory_Dispensaciones_SinConfirmar]
AS
SELECT u.UnitName AS Sucursal, i.Code AS Codigo, i.AdmissionNumber AS Ingreso, i.DocumentDate AS [Fecha Documento], CASE AffectInventory WHEN 1 THEN 'Si' WHEN 0 THEN 'No' END AS [Afecta Inventario], CASE i.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS Estado, 
           i.CreationUser AS [Codigo Usuario], p.Fullname AS [Usuario Crea], w.code+'-'+w.name as Almacen
FROM    Inventory.PharmaceuticalDispensing AS i INNER JOIN
		( select PharmaceuticalDispensingid, max(warehouseid) as warehouseid
			from  Inventory.PharmaceuticalDispensingDetail
			group by PharmaceuticalDispensingid) as d on d.PharmaceuticalDispensingid=i.id inner join
			 Inventory.Warehouse as w   on w.id=d.warehouseid inner join
            Common.OperatingUnit AS u   ON u.Id = i.OperatingUnitId INNER JOIN
           Security.[User] AS us   ON us.UserCode = i.CreationUser INNER JOIN
           Security.Person AS p   ON p.Id = us.IdPerson
WHERE (i.Status = 1)
