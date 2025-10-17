-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: MM_V_INN_OrdenesTraslado
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view [ViewInternal].[MM_V_INN_OrdenesTraslado]
AS
--select * from GENESISSECURITY.Security.Person
SELECT REPLACE('BOGOTA', ORD.OperatingUnitId, '') AS [Unidad Operativa], ORD.Code AS [Orden de Traslado], ORD.DocumentDate AS Fecha, UFU.Name AS [Unidad Funcional], CON.Code + ' - ' + CON.Name AS Concepto, ALM.Code AS Codigo, ALM.Name AS [Almacen de Despacho], 
             PRO.Code AS [Codigo de Producto], PRO.Name AS Producto, CASE PRO.POSProduct WHEN 0 THEN 'NO POS' WHEN 1 THEN 'POS' END AS [Tipo de Producto], DET.Quantity AS Cantidad, DET.Value AS [Costo Promedio], 
             CASE ORD.OrderType WHEN 1 THEN 'TRASLADO' WHEN 2 THEN 'CONSUMO' END AS Tipo, ALM2.Code AS [Codigo ALM Dest], ALM2.Name AS [Almacen de Destino], ORD.Description AS Descripcion,
			 --USU.Identification + ' - ' + USU.Fullname AS [Usuario Creacion], 
             ORD.CreationDate AS [Fecha de Cracion]
FROM   INDIGO022.Inventory.TransferOrder AS ORD LEFT OUTER JOIN
             INDIGO022.Payroll.FunctionalUnit AS UFU ON UFU.Id = ORD.TargetFunctionalUnitId LEFT OUTER JOIN
             INDIGO022.Inventory.AdjustmentConcept AS CON ON ORD.AdjustmentConceptId = CON.Id LEFT OUTER JOIN
             INDIGO022.Inventory.Warehouse AS ALM ON ORD.SourceWarehouseId = ALM.Id LEFT OUTER JOIN
             INDIGO022.Inventory.Warehouse AS ALM2 ON ORD.TargetWarehouseId = ALM2.Id LEFT OUTER JOIN
             INDIGO022.Inventory.TransferOrderDetail AS DET ON DET.TransferOrderId = ORD.Id LEFT OUTER JOIN
             INDIGO022.Inventory.InventoryProduct AS PRO ON DET.ProductId = PRO.Id 
             --LEFT OUTER JOIN GENESISSECURITY.Security.Person AS USU ON ORD.CreationUser = USU.Identification
WHERE (ORD.Status <> 3) AND (ORD.DocumentDate >= DATEADD(month, - 2, GETDATE()))