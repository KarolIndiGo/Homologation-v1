-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_Productos_EPP
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view [ViewInternal].[FQ45_V_INN_Productos_EPP]
AS
SELECT pr.Code
          AS Còdigo,
       pr.Name
          AS Nombre,
       tpr.Name
          AS [Tipo producto],
       gp.Code
          AS [Codigo Grupo],
       gp.Name
          AS Grupo,
       sg.Code
          AS [Código Subgrupo],
       sg.Name
          AS [Nombre subgrupo],
       cuenta.Number
          AS Cuenta,
       cuenta.Name
          AS CuentaIngreso,
       ATC.Code
          AS CodATC,
       ATC.Name
          AS ATC,
       catc.Code
          AS [Cod Medicamento],
       catc.Name
          AS [Nombre Medicamento],
       pr.CodeCUM
          AS [Código CUM],
       pr.CodeAlternative
          AS [Código Alterno],
       pr.CodeAlternativeTwo
          AS [Código alterno 2],
       pr.Description
          AS Descripción,
       dci.Code
          AS [Codigo DCI],
       dci.Name
          AS DCI,
       ue.Name
          AS [Unidad de empaque],
       f.Name
          AS Fabricante,
       pr.Presentation
          AS [Forma Farmaceutica],
       ar.[Name]
          AS [Via de ADministracion],
       pg.[Name]
          AS [Grupo Farmacologico],
       pr.ExpirationDate
          AS [Fecha vencimiento],
       pr.HealthRegistration
          AS RegistroSanitario,
       gf.Name
          AS [Grupo facturación],
       CASE pr.ProductControl WHEN '0' THEN 'No' WHEN '1' THEN 'Control' END
          AS [Producto Control],
       CASE pr.ProductWithPriceControl
          WHEN '0' THEN 'No'
          WHEN '1' THEN 'Control precios'
       END
          AS [Maneja control precios],
       CASE pr.POSProduct WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END
          AS POS,
       CASE pr.ControlOrderQuantity WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END
          AS [Control cantidad X orden],
       pr.ProductOrderAmount
          AS [Cantidad producto x Orden],
       pr.LastPurchase
          AS [Ultima compra],
       pr.LastSale
          AS [Ultima Venta],
       CASE pr.ProductOrigin
          WHEN '1' THEN 'Nacional'
          WHEN '2' THEN 'Importado'
       END
          AS [Origen producto],
       pr.MinimumStock
          AS [Stock minimo],
       pr.MaximumStock
          AS [stock máximo],
       pr.ControlCostPercentage
          AS [% Vr Costo],
       pr.ProductCost
          AS [Costo promedio],
       pr.FinalProductCost
          AS [Ultimo costo],
       pr.SellingPrice
          AS [Precio Venta],
       CASE pr.AllPOSPathologies WHEN '1' THEN 'Si' WHEN '0' THEN 'No' END
          AS [Aplica todas patologías],
       CASE pr.Status WHEN '0' THEN 'Inactivo' WHEN '1' THEN 'Activo' END
          AS Estado,
       IVA.Name
          AS IVA
FROM Inventory.InventoryProduct AS pr 
     INNER JOIN Inventory.ProductType AS tpr 
        ON tpr.Id = pr.ProductTypeId
     INNER JOIN Inventory.ProductGroup AS gp 
        ON gp.Id = pr.ProductGroupId
     INNER JOIN Inventory.ProductSubGroup AS sg 
        ON sg.Id = pr.ProductSubGroupId
     INNER JOIN GeneralLedger.MainAccounts AS cuenta 
        ON cuenta.Id = gp.IncomeAccountId
     INNER JOIN Inventory.PackagingUnit AS ue 
        ON ue.Id = pr.PackagingUnitId
     INNER JOIN Inventory.Manufacturer AS f 
        ON f.Id = pr.ManufacturerId
     LEFT OUTER JOIN Billing.BillingGroup AS gf 
        ON gf.Id = pr.BillingGroupId
     LEFT OUTER JOIN Security.[User] AS s 
        ON s.UserCode = pr.CreationUser
     LEFT OUTER JOIN Security.Person AS sp 
        ON sp.Id = s.IdPerson
     LEFT OUTER JOIN GeneralLedger.GeneralLedgerIVA AS IVA
        ON IVA.Id = pr.IVAId
     LEFT OUTER JOIN Inventory.ATC AS catc 
        ON catc.Id = pr.ATCId AND catc.Status = 1
     LEFT OUTER JOIN Inventory.AdministrationRoute AS ar
        ON catc.AdministrationRouteId = ar.Id
     LEFT OUTER JOIN Inventory.PharmacologicalGroup AS pg
        ON catc.PharmacologicalGroupId = pg.Id
     LEFT OUTER JOIN Inventory.DCI AS dci 
        ON catc.DCIId = dci.Id AND dci.Status = 1
     LEFT OUTER JOIN Inventory.ATCEntity AS ATC
        ON catc.ATCEntityId = ATC.Id
WHERE sg.Id = 68 or pr.id in(7282,20661)
