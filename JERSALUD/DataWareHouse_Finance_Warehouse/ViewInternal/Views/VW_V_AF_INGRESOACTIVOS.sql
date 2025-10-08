-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_AF_INGRESOACTIVOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VW_V_AF_INGRESOACTIVOS]
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
     FROM INDIGO031.FixedAsset.FixedAssetEntryItemDetail AS id
          INNER JOIN INDIGO031.FixedAsset.FixedAssetLocation AS flo ON flo.Id = id.LocationId
          INNER JOIN INDIGO031.FixedAsset.FixedAssetEntryItem AS ei ON ei.Id = id.FixedAssetEntryItemId
          INNER JOIN INDIGO031.FixedAsset.FixedAssetItem AS ai ON ai.Id = ei.ItemId
          INNER JOIN INDIGO031.FixedAsset.FixedAssetEntry AS fe ON fe.Id = ei.FixedAssetEntryId
          INNER JOIN INDIGO031.Common.Supplier AS cs ON cs.Id = fe.SupplierId
          INNER JOIN INDIGO031.Common.City AS cc ON cc.Id = cs.IdCity
          INNER JOIN INDIGO031.Common.ThirdParty AS ct ON ct.Id = cs.IdThirdParty
          INNER JOIN INDIGO031.Common.Person AS cp ON cp.Id = ct.PersonId
          LEFT JOIN INDIGO031.Payments.AccountPayable AS ap ON ap.BillNumber = fe.InvoiceNumber
                                                                       AND ap.IdSupplier = fe.SupplierId
          LEFT JOIN INDIGO031.FixedAsset.FixedAssetResponsible AS fr ON fr.Id = fe.ResponsibleId
          LEFT JOIN INDIGO031.Common.ThirdParty AS fct ON fct.Id = fr.ThirdPartyId
          LEFT JOIN INDIGO031.FixedAsset.FixedAssetLocation AS lo ON lo.Id = fe.LocationId
          LEFT JOIN INDIGO031.FixedAsset.FixedAssetEntryItemDetailPart AS idp ON idp.FixedAssetEntryItemDetailId = id.Id
          LEFT JOIN INDIGO031.FixedAsset.FixedAssetPartsAccesoriesConsumables AS pac ON pac.Id = idp.PartAccesoriesConsumiblesId
          LEFT JOIN INDIGO031.[Security].[UserInt] AS su ON su.UserCode = fe.CreationUser
          LEFT JOIN INDIGO031.[Security].PersonInt AS sp ON sp.Id = su.IdPerson;
