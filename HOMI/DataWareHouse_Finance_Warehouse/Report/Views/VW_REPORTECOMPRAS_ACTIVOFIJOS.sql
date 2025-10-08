-- Workspace: HOMI
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: ca48608f-987a-48d9-8238-40a4987d89e5
-- Schema: Report
-- Object: VW_REPORTECOMPRAS_ACTIVOFIJOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [Report].[VW_REPORTECOMPRAS_ACTIVOFIJOS] AS

SELECT	 
			CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
			E.Code AS 'DOCUMENTO',
			EID.Plate AS 'PLACA',
			E.InvoiceNumber AS 'FACTURA',
			I.Code AS [CODIGO_ARTICULO],
			I.Description AS 'DESCRIPCION',
			EID.Serie AS 'SERIE',
			l.Code AS 'COD_UBIC',
			l.Name AS 'UBICACION',--'Destino'
			E.EntryDate AS 'FECHA_COMPRA', --fingreso
			 ---Libro 1 (as DBK)
			 EDB.LifeTime AS V_UTIL_NIFF,
			 EDB.HistoricalValue AS VR_COSTO_H_NIIF,
			 IIF (EDB.DepreciationType=3, EDB.HistoricalValue *EDB.PercentageRescue,0) AS [VR_RESIDUAL_NIIF],
			 EDB2.LifeTime AS V_UTIL_FISCAL,
			 EDB2.DaysPendingDepreciate AS 'TIEMPO_DEPR_FISCAL',
			 EDB.DaysPendingDepreciate AS 'TIEMPO_DEPR_NIIF',
			 EDB2.HistoricalValue AS 'VR_COMPRA_FISCAL',
			 IIF (EDB2.DepreciationType=3, EDB2.HistoricalValue *EDB2.PercentageRescue,0) AS [VR_RESIDUAL_FISCAL],
			 EI.[Observation] AS 'OBSERVACION',
			 S.Code AS 'NIT',
			 S.Name AS 'RAZON_SOCIAL',
			 CAST(E.EntryDate AS DATE) as 'FECHA BUSQUEDA',
			 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL

FROM [INDIGO036].[FixedAsset].[FixedAssetEntryItemDetail] AS EID --
	LEFT JOIN [INDIGO036].[FixedAsset].[FixedAssetEntryItem] AS EI ON EI.Id = EID.FixedAssetEntryItemId
	INNER JOIN [INDIGO036].[FixedAsset].[FixedAssetEntry] AS E ON E.Id = EI.FixedAssetEntryId---
	INNER JOIN [INDIGO036].[Common].[SuppliersDistributionLines] AS SDL ON SDL.Id = E.SupplierDistributionLineId
	INNER JOIN [INDIGO036].[Common].[Supplier]AS S ON S.Id = SDL.IdSupplier
	left JOIN [INDIGO036].[FixedAsset].[FixedAssetLocation] AS l ON l.Id = EID.LocationId---
	INNER JOIN [INDIGO036].[FixedAsset].[FixedAssetItem] AS I ON I.Id = EI.ItemId --
	left JOIN [INDIGO036].[FixedAsset].[FixedAssetEntryItemDetailBook] AS EDB 
		ON EDB.FixedAssetEntryItemDetailId=EID.Id AND EDB.LegalBookId = 1
	left JOIN [INDIGO036].[FixedAsset].[FixedAssetEntryItemDetailBook] AS EDB2 
		ON EDB2.FixedAssetEntryItemDetailId=EID.Id AND EDB2.LegalBookId = 2
		--WHERE E.Code ='0000000004'
