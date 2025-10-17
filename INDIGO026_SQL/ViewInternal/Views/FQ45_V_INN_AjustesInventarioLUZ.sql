-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_AjustesInventarioLUZ
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_INN_AjustesInventarioLUZ]
AS
SELECT CASE A.OperatingUnitId WHEN 3 THEN 'Bogota' END
          AS Sede,
       A.DocumentDate
          AS Fecha,
       A.Code
          AS Documento,
       (SELECT nit + '-' + [Name]
        FROM Common.ThirdParty
        WHERE id = A.ThirdPartyId)
          AS Tercero,
       CASE A.AdjustmentType WHEN 1 THEN 'Entrada' WHEN 2 THEN 'Salida' END
          AS Tipo,
       B.Code
          AS CodAlm,
       B.Name
          AS Almacen,
       C.Code
          AS CodCon,
       C.Name
          AS Concepto,
       (SELECT number
        FROM GeneralLedger.MainAccounts
        WHERE id = C.AdjustmentAccountId)
          AS [# Cuenta Contable],
       (SELECT name
        FROM GeneralLedger.MainAccounts
        WHERE id = C.AdjustmentAccountId)
          AS [Nombre Cuenta Contable],
       P.Code
          AS CodProducto,
       P.Name
          AS Producto,
       DA.Quantity
          AS Cant,
       DA.UnitValue
          AS ValorUnitario,
       DA.Quantity * DA.UnitValue
          AS VlrTotal,
       P.ProductCost
          AS CostoProm,
       (SELECT code
        FROM Inventory.ProductGroup
        WHERE id = P.ProductGroupId)
          AS [Codigo Grupo],
       (SELECT name
        FROM Inventory.ProductGroup
        WHERE id = P.ProductGroupId)
          AS [Nombre Grupo],
       A.Description
          AS Detalle,
       s1.UserCode + ' - ' + sp1.Fullname
          AS [Usuario Creacion],
       s2.UserCode + ' - ' + sp2.Fullname
          AS [Usuario Confirma]
FROM Inventory.InventoryAdjustment AS A
     INNER JOIN Inventory.InventoryAdjustmentDetail AS DA
        ON DA.InventoryAdjustmentId = A.Id AND A.Status = 2
     INNER JOIN Inventory.Warehouse AS B ON A.WarehouseId = B.Id
     INNER JOIN Inventory.AdjustmentConcept AS C
        ON A.AdjustmentConceptId = C.Id
     INNER JOIN Inventory.InventoryProduct AS P ON DA.ProductId = P.Id
     LEFT OUTER JOIN Security.[User] AS s1 
        ON s1.UserCode = A.CreationUser
     LEFT OUTER JOIN Security.Person AS sp1 
        ON sp1.Id = s1.IdPerson
     LEFT OUTER JOIN Security.[User] AS s2 
        ON s2.UserCode = A.ConfirmationUser
     LEFT OUTER JOIN Security.Person AS sp2 
        ON sp2.Id = s2.IdPerson
WHERE     (CONVERT (NVARCHAR (10), A.DocumentDate, 20) >
           CONVERT (NVARCHAR (10), GETDATE () - 180, 20))
