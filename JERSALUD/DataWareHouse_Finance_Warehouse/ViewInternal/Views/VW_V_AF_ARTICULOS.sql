-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_AF_ARTICULOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VW_V_AF_ARTICULOS]
AS
     SELECT Uo.UnitName AS UnidadOperativa, 
            Ar.Code, 
            Ar.EntryDate AS FechaEntrada, 
            Ar.EntryNumber AS Documento,
            CASE Ar.AdquisitionType
                WHEN 1
                THEN 'Compra Directa'
                WHEN 3
                THEN 'Comodato'
                WHEN 4
                THEN 'Donación'
                WHEN 5
                THEN 'Traspaso de Bienes'
            END AS Adquisicion, 
            Te.Name AS Proveedor, 
            Li.Name AS LineaDistribucion, 
            Ar.Description AS Descripción, 
            Ar.DayPeriod AS [Dias de Plazo],
            CASE Ar.Status
                WHEN 1
                THEN 'Registrado'
                WHEN 2
                THEN 'Confirmado'
                WHEN 3
                THEN 'Anulado'
            END AS Estado, 
            Ar.Value AS [Sumatoria del Subtotal]
     FROM INDIGO031.FixedAsset.FixedAssetEntry AS Ar
          INNER JOIN INDIGO031.Common.OperatingUnit AS Uo ON Ar.OperatingUnitId = Uo.Id
          INNER JOIN INDIGO031.Common.Supplier AS Te ON Ar.SupplierId = Te.Id
          LEFT JOIN INDIGO031.Common.DistributionLines AS Li ON Ar.SupplierDistributionLineId = Li.Id;
