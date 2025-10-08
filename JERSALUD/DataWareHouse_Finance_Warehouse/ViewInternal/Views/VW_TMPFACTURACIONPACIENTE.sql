-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_TMPFACTURACIONPACIENTE
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VW_TMPFACTURACIONPACIENTE]
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
     FROM INDIGO031.Inventory.MedicalFormulaPharmaceuticalDispensing DIF
          JOIN INDIGO031.Inventory.PharmaceuticalDispensing DIS  ON DIF.PharmaceuticalDispensingId = DIS.Id
          JOIN INDIGO031.Inventory.PharmaceuticalDispensingDetail DDIS  ON DDIS.PharmaceuticalDispensingId = DIS.Id
          JOIN INDIGO031.Billing.ServiceOrder O  ON DDIS.PharmaceuticalDispensingId = O.EntityId
                                                                        AND O.Status = 1
          JOIN INDIGO031.Billing.ServiceOrderDetail DO  ON DO.ServiceOrderId = O.Id
                                                                               AND DDIS.ProductId = DO.ProductId
          JOIN INDIGO031.Billing.InvoiceDetail DFA  ON DFA.ServiceOrderDetailId = DO.Id
          JOIN INDIGO031.Billing.Invoice FA  ON DFA.InvoiceId = FA.Id
                                                                    AND FA.Status = 1
          JOIN INDIGO031.Inventory.InventoryProduct P  ON DO.ProductId = P.Id
          JOIN INDIGO031.Inventory.ATC M  ON P.ATCId = M.Id
          JOIN INDIGO031.Inventory.Warehouse AL  ON DDIS.WarehouseId = AL.Id
          JOIN INDIGO031.[Security].[UserInt] U ON O.CreationUser = U.UserCode
          JOIN INDIGO031.[Security].PersonInt Per ON U.IdPerson = Per.Id
          LEFT JOIN INDIGO031.Inventory.PhysicalInventory AS inv  ON inv.ProductId = P.Id
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
