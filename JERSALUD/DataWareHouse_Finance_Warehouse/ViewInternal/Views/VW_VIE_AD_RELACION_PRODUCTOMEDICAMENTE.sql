-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_RELACION_PRODUCTOMEDICAMENTE
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_RELACION_PRODUCTOMEDICAMENTE
AS
     SELECT a.Code AS CodMedicamento, 
            a.Name AS Medicamento, 
            P.Code AS CodProducto, 
            P.Name AS Producto
     FROM INDIGO031.Inventory.InventoryProduct AS P
          INNER JOIN INDIGO031.Inventory.ATC AS a ON a.Id = P.ATCId
     WHERE P.Status = '1';