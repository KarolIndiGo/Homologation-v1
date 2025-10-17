-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_PRESTAMOMERCANCIA
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[View_HDSAP_PRESTAMOMERCANCIA]
AS
SELECT LM.Code Documento, 
       LM.DocumentDate Fecha,
       CASE LM.LoanType
           WHEN 1
           THEN 'Entrada'
           WHEN 2
           THEN 'Salida'
       END TipoPrestamo, 
       ALM.Code + ' - ' + ALM.Name Almacen, 
       TP.Nit + ' - ' + TP.Name Tercero, 
       LM.Observation Observacion,
       CASE LM.STATUS
           WHEN 1
           THEN 'Registrado'
           WHEN 2
           THEN 'Confirmado'
           WHEN 3
           THEN 'Anulado'
       END Estado, 
       PRO.Code + ' - ' + PRO.Name Producto, 
       LMD.Quantity Cantidad, 
       LMD.OutstandingQuantity Saldo, 
       LMD.UnitValue CostoUnitario
FROM Inventory.LoanMerchandise AS LM
     INNER JOIN Inventory.LoanMerchandiseDetail AS LMD ON LM.Id = LMD.LoanMerchandiseId
     INNER JOIN Inventory.Warehouse AS ALM ON LM.WarehouseId = ALM.Id
     INNER JOIN Common.ThirdParty AS TP ON LM.ThirdPartyId = TP.Id
     INNER JOIN Inventory.InventoryProduct AS PRO ON LMD.ProductId = PRO.Id

