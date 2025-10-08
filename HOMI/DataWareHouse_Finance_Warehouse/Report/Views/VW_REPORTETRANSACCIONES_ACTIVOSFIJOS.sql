-- Workspace: HOMI
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: ca48608f-987a-48d9-8238-40a4987d89e5
-- Schema: Report
-- Object: VW_REPORTETRANSACCIONES_ACTIVOSFIJOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [Report].[VW_REPORTETRANSACCIONES_ACTIVOSFIJOS] AS
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
			I.Code AS 'CODIGO_ARTICULO',
			I.[Description] AS 'DESCRIPCION',
			TSD.Detail AS [OBSERVACION],
			EID.HistoricalValue AS [COSTO_HISTORICO NIIF],
			CAST(TRS.DocumentDate  AS DATE) as 'FECHA BUSQUEDA',
			CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
						
FROM [INDIGO036].[FixedAsset].[FixedAssetTransaction] AS TRS
	LEFT JOIN [INDIGO036].[FixedAsset].[FixedAssetTransactionDetail] AS TSD
		ON TRS.Id=TSD.FixedAssetTransactionId
    INNER JOIN [INDIGO036].[FixedAsset].[FixedAssetPhysicalAsset] AS EID --PLACA
		ON TSD.PhysicalAssetId = EID.Id
	INNER JOIN  [INDIGO036].[FixedAsset].[FixedAssetLocation] AS l 
		ON l.Id = EID.LocationId
	LEFT JOIN [INDIGO036].[FixedAsset].[FixedAssetTransactionDetailBook] AS EDB 
		ON EDB.FixedAssetTransactionDetailId=TSD.Id AND EDB.LegalBookId = 1
	LEFT JOIN [INDIGO036].[FixedAsset].[FixedAssetTransactionDetailBook] AS EDB2 
		ON EDB2.FixedAssetTransactionDetailId=TSD.Id AND EDB2.LegalBookId = 2
	LEFT JOIN [INDIGO036].[FixedAsset].[FixedAssetItem] AS I ON I.Id = EID.ItemId 