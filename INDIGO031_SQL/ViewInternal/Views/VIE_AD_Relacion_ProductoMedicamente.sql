-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Relacion_ProductoMedicamente
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Relacion_ProductoMedicamente]
AS
     SELECT a.code AS CodMedicamento, 
            a.name AS Medicamento, 
            p.code AS CodProducto, 
            p.name AS Producto
     FROM Inventory.InventoryProduct AS P
          INNER JOIN Inventory.ATC AS a ON a.id = p.atcid
     WHERE p.STATUS = '1';
