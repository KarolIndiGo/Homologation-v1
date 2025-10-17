-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_AF_IngresoActivos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[V_AF_IngresoActivos]
AS
     SELECT fe.Code AS NumeroIngreso, 
            fe.EntryDate AS fechaIngreso, 
            cs.Name AS NombreProveedor, 
            cs.Code AS NitProveedor, 
            IIF(fe.[Status] = 1, 'Registrado', IIF(fe.[Status] = 2, 'Confirmado', 'Anulado')) AS [Status], 
            ap.Code AS CodigoCxP, 
            fe.InvoiceNumber AS NumeroFactura, 
            cc.Name AS Ciudad, 
            fr.Code AS CodigoResponsable, 
            fct.Name AS NombreResponsable, 
            lo.Code AS CodigoLocalización, 
            lo.Name AS NombreLocalización, 
            ai.Code AS CodigoItem, 
            ai.[Description] AS Descripcion, 
            id.Plate AS Placa, 
            ei.IvaPercentage AS PorcentajeIva, 
            ei.UnitValue AS ValorUnitario, 
            fe.Value AS Valor, 
            fe.ValueDiscount AS ValorDescuento, 
            (fe.FreightIVAValue + fe.ValueTax) AS Iva, 
            fe.WithholdingICA AS ICA, 
            fe.RetentionSource AS BaseRetención, 
            (fe.TotalValue - fe.WithholdingTax - fe.WithholdingICA - fe.RetentionSource) AS Total
     FROM FixedAsset.FixedAssetEntryItemDetail AS id
          INNER JOIN FixedAsset.FixedAssetLocation AS flo ON flo.Id = id.LocationId
          INNER JOIN FixedAsset.FixedAssetEntryItem AS ei ON ei.Id = id.FixedAssetEntryItemId
          INNER JOIN FixedAsset.FixedAssetItem AS ai ON ai.Id = ei.ItemId
          INNER JOIN FixedAsset.FixedAssetEntry AS fe ON fe.Id = ei.FixedAssetEntryId
          INNER JOIN Common.Supplier AS cs ON cs.Id = fe.SupplierId
          INNER JOIN Common.City AS cc ON cc.Id = cs.IdCity
          INNER JOIN Common.ThirdParty AS ct ON ct.Id = cs.IdThirdParty
          INNER JOIN Common.Person AS cp ON cp.Id = ct.PersonId
          LEFT JOIN Payments.AccountPayable AS ap ON ap.BillNumber = fe.InvoiceNumber
                                                                       AND ap.IdSupplier = fe.SupplierId
          LEFT JOIN FixedAsset.FixedAssetResponsible AS fr ON fr.Id = fe.ResponsibleId
          LEFT JOIN Common.ThirdParty AS fct ON fct.Id = fr.ThirdPartyId
          LEFT JOIN FixedAsset.FixedAssetLocation AS lo ON lo.id = fe.LocationId
          LEFT JOIN FixedAsset.FixedAssetEntryItemDetailPart AS idp ON idp.FixedAssetEntryItemDetailId = id.Id
          LEFT JOIN FixedAsset.FixedAssetPartsAccesoriesConsumables AS pac ON pac.Id = idp.PartAccesoriesConsumiblesId
          LEFT JOIN [Security].[User] AS su ON su.UserCode = fe.CreationUser
          LEFT JOIN [Security].Person AS sp ON sp.Id = su.IdPerson;
