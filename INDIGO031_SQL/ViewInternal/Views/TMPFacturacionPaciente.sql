-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: TMPFacturacionPaciente
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[TMPFacturacionPaciente]
AS
     SELECT DISTINCT 
            M.Code AS ATC, 
            P.Code AS CUM, 
            P.Name AS Producto, 
            FA.InvoiceNumber AS Factura, 
            FA.AdmissionNumber AS Ingreso, 
            FA.InvoiceDate AS FechaFactura, 
            DFA.InvoicedQuantity CantidadFactura, 
            AL.Name AS Almacen, 
            SUM(inv.Quantity) AS STOCK
     FROM Inventory.MedicalFormulaPharmaceuticalDispensing DIF
          JOIN Inventory.PharmaceuticalDispensing DIS  ON DIF.PharmaceuticalDispensingId = DIS.Id
          JOIN Inventory.PharmaceuticalDispensingDetail DDIS  ON DDIS.PharmaceuticalDispensingId = DIS.Id
          JOIN Billing.ServiceOrder O  ON DDIS.PharmaceuticalDispensingId = O.EntityId
                                                                        AND o.STATUS = 1
          JOIN Billing.ServiceOrderDetail DO  ON DO.ServiceOrderId = O.Id
                                                                               AND DDIS.ProductId = DO.ProductId
          JOIN Billing.InvoiceDetail DFA  ON DFA.ServiceOrderDetailId = DO.Id
          JOIN Billing.Invoice FA  ON DFA.InvoiceId = FA.Id
                                                                    AND FA.STATUS = 1
          JOIN Inventory.InventoryProduct P  ON DO.ProductId = P.Id
          JOIN Inventory.ATC M  ON P.ATCId = M.Id
          JOIN Inventory.Warehouse AL  ON DDIS.WarehouseId = AL.Id
          JOIN [Security].[USER] U ON O.CreationUser = U.UserCode
          JOIN [Security].Person Per ON U.IdPerson = Per.Id
          LEFT JOIN Inventory.PhysicalInventory AS inv  ON inv.ProductId = P.Id
                                                                                         AND inv.WarehouseId = AL.Id
     WHERE FA.InvoiceDate >= '2020-10-01' --AND P.Code='19977867-02'
     GROUP BY M.Code, 
              P.Code, 
              P.Name, 
              FA.InvoiceDate, 
              DFA.InvoicedQuantity, 
              AL.Name, 
              FA.AdmissionNumber, 
              FA.InvoiceNumber;
--SELECT * FROM Inventory.PhysicalInventory
