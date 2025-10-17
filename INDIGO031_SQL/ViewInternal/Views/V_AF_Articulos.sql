-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_AF_Articulos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[V_AF_Articulos]
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
            CASE Ar.STATUS
                WHEN 1
                THEN 'Registrado'
                WHEN 2
                THEN 'Confirmado'
                WHEN 3
                THEN 'Anulado'
            END AS Estado, 
            Ar.Value AS [Sumatoria del Subtotal]
     FROM FixedAsset.FixedAssetEntry AS Ar
          INNER JOIN Common.OperatingUnit AS Uo ON Ar.OperatingUnitId = Uo.Id
          INNER JOIN Common.Supplier AS Te ON Ar.SupplierId = Te.Id
          LEFT JOIN Common.DistributionLines AS Li ON ar.SupplierDistributionLineId = li.Id;
