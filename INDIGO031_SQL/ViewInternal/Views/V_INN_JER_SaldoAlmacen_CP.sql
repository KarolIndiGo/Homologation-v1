-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_INN_JER_SaldoAlmacen_CP
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[V_INN_JER_SaldoAlmacen_CP]
AS
     SELECT pr.Code AS Codigo, 
            pr.Name AS Producto,
            CASE pr.ProductTypeId
                WHEN '1'
                THEN 'MEDICAMENTO'
                WHEN '2'
                THEN 'DISPOSITIVO MÉDICO'
                WHEN '3'
                THEN 'ELEMENTOS DE CONSUMO'
                WHEN '4'
                THEN 'NUTRICION ESPECIAL'
                WHEN '5'
                THEN 'EQUIPOBIOMEDICO'
                WHEN '6'
                THEN 'INSUMO LABORATORIO'
                WHEN '7'
                THEN 'MEDICAMENTO VITAL NO DISPONIBLE'
            END AS [Tipo Producto], 
            Med.Code + ' -' + Med.Name AS Medicamento, 
            ATC.Code AS CodATC, 
            ATC.Name AS ATC, 
            pr.CodeCUM AS [C.U.M], 
            pr.CodeAlternativeTwo AS [Codigo Alterno 2], 
            sg.Name AS SubGrupo, 
            ue.Abbreviation AS Unidad, 
            gf.Name AS [Grupo Facturacion],
            CASE pr.ProductControl
                WHEN '0'
                THEN 'No'
                WHEN '1'
                THEN 'Si'
            END AS [Producto Control], 
            pr.ProductCost AS CostoPromedio, 
            pr.FinalProductCost AS Ultimocosto,
            CASE pr.STATUS
                WHEN '1'
                THEN 'Activo'
                WHEN '0'
                THEN 'Inactivo'
            END AS Estado, 
            inf.Quantity AS Cantidad, 
            inf.Quantity * pr.ProductCost AS VrTotal, 
            al.Id AS IdAlm, 
            al.Code AS CodigoAlmacen, 
            al.Name AS Almacen, 
            al.Prefix, 
            al.Name AS Sede,
            CASE ProductWithPriceControl
                WHEN 0
                THEN ''
                WHEN 1
                THEN 'Regulado'
            END AS Precio
     FROM Inventory.InventoryProduct AS pr 
          LEFT OUTER JOIN Inventory.PhysicalInventory AS inf  ON inf.ProductId = pr.Id
          LEFT OUTER JOIN Inventory.Warehouse AS al ON al.Id = inf.WarehouseId
          LEFT OUTER JOIN Inventory.ATC AS Med  ON Med.Id = pr.ATCId
          LEFT OUTER JOIN Inventory.ProductSubGroup AS sg ON sg.Id = pr.ProductSubGroupId
          LEFT OUTER JOIN Inventory.PackagingUnit AS ue ON ue.Id = pr.PackagingUnitId
          LEFT OUTER JOIN Billing.BillingGroup AS gf ON gf.Id = pr.BillingGroupId
          LEFT OUTER JOIN Inventory.ATCEntity AS ATC ON Med.ATCEntityId = ATC.Id
     WHERE(inf.Quantity <> '0');
