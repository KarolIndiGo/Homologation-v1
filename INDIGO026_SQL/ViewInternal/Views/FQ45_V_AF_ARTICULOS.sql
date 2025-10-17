-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_AF_ARTICULOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_AF_ARTICULOS]
AS
SELECT fi.code
          AS Codigo,
       fi.[Description]
          AS Nombre,
       fit.Code + '-' + fit.[Name]
          AS [Tipo Equipo],
       CASE fi.DepreciateByTimeUse WHEN 1 THEN 'SI' ELSE 'NO' END
          AS [Deprecia por tiempo de uso],
       fi.Observations
          AS Observaciones,
       fic.Code + '-' + fic.[Description]
          AS [Catalogo de Equipos],
       fi.LastCostItem
          AS [Ultimo Costo],
       fi.FairValue
          AS [Valor Razonable],
       CASE fi.AllowDepreciate WHEN 1 THEN 'SI' ELSE 'NO' END
          AS [Permite Depreciar],
       gl.Code + '-' + gl.[Name]
          AS [Libro Oficial],
       fid.LifeTime
          AS [Vida Util],
       CASE fid.UnitLifeTime
          WHEN 1 THEN 'Año'
          WHEN 2 THEN 'Mes'
          WHEN 3 THEN 'Dia'
       END
          AS [Unidad de Vida Util],
       CASE fid.DepreciationType
          WHEN 1 THEN 'Linea Recta'
          WHEN 2 THEN 'Suma de Digitos'
          WHEN 3 THEN 'Reduccion de Saldos'
          WHEN 4 THEN 'Unidades de Produccion'
       END
          AS [Tipo de Depreciacion]
FROM FixedAsset.FixedAssetItem fi
     INNER JOIN FixedAsset.FixedAssetItemType fit ON fi.ItemTypeId = fit.Id
     INNER JOIN FixedAsset.FixedAssetItemCatalog fic
        ON fi.ItemCatalogId = fic.Id
     LEFT JOIN FixedAsset.FixedAssetItemDetail fid
        ON fi.id = fid.FixedAssetItemId
     LEFT JOIN GeneralLedger.LegalBook gl ON gl.id = fid.LegalBookId
