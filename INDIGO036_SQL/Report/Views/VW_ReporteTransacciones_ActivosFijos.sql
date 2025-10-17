-- Workspace: SQLServer
-- Item: INDIGO036 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: VW_ReporteTransacciones_ActivosFijos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [Report].[VW_ReporteTransacciones_ActivosFijos] AS
SELECT
			CASE TSD.TransactionType WHEN 1 THEN 'Valorización' 
									 WHEN 2 THEN 'Desvalorización' 
									 END AS [TIPO_TRANSACCION],
			CASE TSD.ValorizationType WHEN 0 THEN 'No aplica'
									  WHEN 1 THEN 'Adición' 
									  WHEN 2 THEN 'Mantenimiento' 
									  WHEN 3 THEN 'Mejora' 
									  WHEN 4 THEN 'Reparación'
									  END AS [TIPO_VALORIZACIÓN],
			CASE TRS.Status WHEN 1 THEN 'Registrado'
							WHEN 2 THEN 'Confirmado'
							WHEN 3 THEN 'Anulado'
			                END AS 'ESTADO',
			CASE TSD.AffectDepreciation WHEN 0 THEN 'No'
										WHEN 1 THEN 'Si'
										END AS [AFECTA_DEPRECIACIÓN],
			TRS.Code AS 'Documento',
			EID.Plate AS 'PLACA',
			--eid.Serie AS 'SERIE',
			l.Code AS 'COD_UBIC',
			l.Name AS 'UBICACION',--'Destino',
			EID.AdquisitionDate AS 'FECHA_COMPRA',
			TRS.DocumentDate AS 'FECHA_ADICION',
			ISNULL(EDB2.LifeTime,0) AS [Adicion Vida Util Fiscal],
			IIF(TSD.TransactionType =1,(ISNULL(EDB2.Value,TSD.TotalValue)),(-ISNULL(EDB2.Value,TSD.TotalValue))) AS [Transacción Vlr Fiscal],
			ISNULL(EDB.LifeTime,0) AS [Adicion Vida Util NIIF],
			IIF(TSD.TransactionType =1,(ISNULL(EDB.Value,TSD.TotalValue)),(-ISNULL(EDB.Value,TSD.TotalValue))) AS [Transacción Vlr NIIF],
			i.Code AS 'CODIGO_ARTICULO',
			i.[Description] AS 'DESCRIPCION',
			TSD.Detail AS [OBSERVACION],
			EID.HistoricalValue AS [COSTO_HISTORICO NIIF],
			CAST(TRS.DocumentDate  AS DATE) as 'FECHA BUSQUEDA',
			CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
						
FROM FixedAsset.FixedAssetTransaction AS TRS
	LEFT JOIN FixedAsset.FixedAssetTransactionDetail AS TSD
		ON TRS.Id=TSD.FixedAssetTransactionId
    INNER JOIN FixedAsset.FixedAssetPhysicalAsset AS EID --PLACA
		ON TSD.PhysicalAssetId = eid.Id
	INNER JOIN  FixedAsset.FixedAssetLocation AS l 
		ON l.Id = eid.LocationId
	LEFT JOIN FixedAsset.FixedAssetTransactionDetailBook AS EDB 
		ON EDB.FixedAssetTransactionDetailId=TSD.Id AND EDB.LegalBookId = 1
	LEFT JOIN FixedAsset.FixedAssetTransactionDetailBook AS EDB2 
		ON EDB2.FixedAssetTransactionDetailId=TSD.Id AND EDB2.LegalBookId = 2
	left JOIN FixedAsset.FixedAssetItem AS i ON i.Id = eid.ItemId 
	

--SELECT TOP (2) *FROM FixedAsset.FixedAssetTransaction --AS TRS
--SELECT  *FROM FixedAsset.FixedAssetTransactionDetail --AS TSD
----SELECT *FROM FixedAsset.FixedAssetTransactionDetailBook-- AS EDB AS EDB2
--SELECT  *FROM FixedAsset.FixedAssetPhysicalAsset WHERE PLATE='H00034684'
------SELECT * FROM FixedAsset.FixedAssetLocation--AS i 
----SELECT  * FROM FixedAsset.FixedAssetItem
