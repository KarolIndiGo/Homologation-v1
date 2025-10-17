-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewClosedMonth
-- Extracted by Fabric SQL Extractor SPN v3.9.0




/*******************************************************************************************************************
Nombre: [Report].[ViewClosedMonth]
Tipo:Vista
Observacion:Cierre mensual de inventario
Profesional: Monica Elizabeth Valderrama Ochoa
Fecha:16-08-2024
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 1
Persona que modifico: 
Fecha:03-01-2024
Ovservaciones: 
--------------------------------------
Version 2
Persona que modifico: Monica Elizabeth Valderrama Ochoa 
Fecha:03-02-2025
Ovservaciones: Por cambio del proceso de cierre de inventario las tablas no estan diligenciando toda la información 
--------------------------------------
Version 3
Persona que modifico:
Fecha:
Ovservaciones:
***********************************************************************************************************************************/
CREATE VIEW [Report].[ViewClosedMonth] AS

SELECT 
CONCAT(w.Code,' - ',w.Name) ALMACEN,
CASE W.WareHouseType WHEN 0 THEN 'Ninguna'
					 WHEN 1 THEN 'Almacén Virtual'
					 WHEN 2 THEN 'Almacén de Consignación'
					 WHEN 3 THEN 'Almacén de Custodia'
					 WHEN 4 THEN 'Almacén de Transito'
					 WHEN 5 THEN 'Almacén de Control'
					 WHEN 6 THEN 'Almacén de Remanentes' END AS [TIPO ALMACEN],
concat(pg.Code,' - ',pg.Name) AS GRUPO,
Concat(psg.Code,' - ',psg.Name) AS SUBGRUPO,
ma.Number "CUENTA CONTABLE",
ma.Name "NOMBRE CUENTA CONTABLE",
--CONCAT(ma.Number, ' - ',ma.Name) AS CUENTA,---se inactiva V2
ip.Code AS [CODIGO PRODUCTO],
ip.Name AS [NOMBRE PRODUCTO],
--bs.BatchCode AS LOTE, ---se inactiva V2
cmi.Quantity CANTIDAD,  ---Se modificó la tabla de donde trae el almacen V2 estaba (cmid.Quantity CANTIDAD,)
cmi.FinalProductCost "ULTIMO COSTO", ---se Ingreso campo V2
cmi.ProductCost "COSTO PROMEDIO",
cmi.Quantity * cmi.ProductCost AS "TOTAL COSTO PROMEDIO", ---Se modificó la tabla de donde trae el almacen V2 estaba (cmid.Quantity * cmi.ProductCost AS TOTAL)
CM.[YEAR] AS [AÑO BUSQUEDA],
CM.[MONTH] AS [MES BUSQUEDA]
FROM 
Inventory.ClosedMonthInventory CMI WITH(NOLOCK)
INNER JOIN Inventory.ClosedMonth CM ON CMI.ClosedMonthId=CM.Id
--INNER JOIN Inventory.ClosedMonthInventoryDetail CMID WITH(NOLOCK) on cmi.Id = cmid.ClosedMonthInventoryId  ---se inactiva V2
INNER JOIN Inventory.Warehouse w WITH(NOLOCK) on W.Id = cmi.WarehouseId   ---Se modificó la tabla de donde trae el almacen V2 estaba (W.Id = cmid.WarehouseId)
INNER JOIN Inventory.InventoryProduct [IP] WITH(NOLOCK) on ip.Id = cmi.ProductId
INNER JOIN Inventory.ProductGroup PG WITH(NOLOCK) on pg.Id = ip.ProductGroupId
INNER JOIN Inventory.ProductSubGroup psg WITH(NOLOCK)  on ip.ProductSubGroupId = psg.Id
INNER JOIN Payments.AccountPayableConcepts apc WITH(NOLOCK) on pg.InventoryAccountPayableConceptId = apc.Id
INNER JOIN GeneralLedger.MainAccounts ma WITH(NOLOCK) on ma.Id = apc.IdAccount
--INNER JOIN Inventory.BatchSerial bs WITH(NOLOCK) on bs.Id = cmid.BatchSerialId ---se inactiva V2
--where  CMI.ClosedMonthId = 19
--396.042
--where W.WareHouseType  = 2



