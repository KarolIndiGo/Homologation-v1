-- Workspace: HOMI
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: ca48608f-987a-48d9-8238-40a4987d89e5
-- Schema: Report
-- Object: VW_REPORTEDEBAJAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [Report].[VW_REPORTEDEBAJAS] AS
 SELECT 
	CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
	AO.Code AS 'CODIGO',
    AO.DocumentDate AS 'FECHA DOCUMENTO',
    CASE AO.Status 
			WHEN 1 THEN 'Registrado' 
			WHEN 2 THEN 'Confirmado' 
			WHEN 3 THEN 'Anulado'
			END AS 'ESTADO',
    TAF.Plate AS 'PLACA',
    P.Code AS 'CODIGO ARTICULO',
    P.Description AS 'NOMBRE_ACTIVO',
    CAT.Code + ' - ' + CAT.Description AS 'CATALOGO ARTICULO',
    TAF.OutputDate AS 'FECHA_BAJA',
    CASE BJ.LowType 
        WHEN 0 THEN 'No Aplica'
        WHEN 1 THEN 'Perdida'
        WHEN 2 THEN 'Siniestro' 
        WHEN 3 THEN 'Perdida Reposición' 
        WHEN 4 THEN 'Bienes Inservibles' 
        WHEN 5 THEN 'Obsolescencia'
    END AS 'DESCRIPCION',
    CASE BJ.OutputType 
        WHEN 1 THEN 'Baja'
        WHEN 2 THEN 'Venta'
    END AS 'TIPO_BAJA',
     TAF.AdquisitionDate as 'FECHA_COMPRA',
    UI.Code AS 'COD_UBICACION',
	UI.Name AS 'UBICACION',
    -- Libro 1 (as DBK)
    DBK.HistoricalValue AS 'COSTO_HISTORICO_CONT_NIIF',
    DBK.ResidualValue AS 'DEPR_ACUM_NIIF',
    DBK.DepreciatedValue AS 'VR_LIBRO_NIIF',

    -- Libro 2 (como nuevo alias DBK2)
    DBK2.HistoricalValue AS 'COSTO_HISTORICO_CONT_FISCAL',
    DBK2.ResidualValue AS 'DEPR_ACUM_FISCAL',
    DBK2.DepreciatedValue AS 'VR_LIBRO_FISCAL',
	TP.Name AS  'SOLICITANTE_BAJA',
	--'' AS 'EMISOR_BAJA',
	AO.Observation AS 'OBSERVACION',
	CAST(AO.DocumentDate AS DATE) as 'FECHA BUSQUEDA',
	CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL

FROM  [INDIGO036].[FixedAsset].[FixedAssetActiveOutputDetail] AS BJ 
INNER JOIN [INDIGO036].[FixedAsset].[FixedAssetActiveOutput] AS AO 
	ON BJ.FixedAssetActiveOutputId = AO.Id
LEFT JOIN [INDIGO036].[FixedAsset].[FixedAssetPhysicalAsset] AS TAF  
	ON TAF.Id = BJ.PhysicalAssetId
INNER JOIN [INDIGO036].[FixedAsset].[FixedAssetItem] AS P 
	 ON P.Id = TAF.ItemId
INNER JOIN [INDIGO036].[FixedAsset].[FixedAssetPhysicalAssetDetailBook] AS DBK 
    ON BJ.PhysicalAssetId = DBK.PhysicalAssetId AND DBK.LegalBookId = 1
LEFT JOIN [INDIGO036].[FixedAsset].[FixedAssetPhysicalAssetDetailBook] AS DBK2 
    ON BJ.PhysicalAssetId = DBK2.PhysicalAssetId AND DBK2.LegalBookId = 2
INNER JOIN [INDIGO036].[FixedAsset].[FixedAssetResponsible] AS REF 
	ON  TAF.ResponsibleId=REF.Id
INNER JOIN [INDIGO036].[Common].[ThirdParty] AS TP 
	ON REF.Code=TP.Nit
INNER JOIN	[INDIGO036].[FixedAsset].[FixedAssetLocation] AS UI 
	 ON UI.Id = TAF.LocationId
INNER JOIN [INDIGO036].[FixedAsset].[FixedAssetItemCatalog] AS CAT
	ON P.ItemCatalogId=CAT.Id
 --WHERE P.Code='BA-INV-100102-9' 
 --ORDER BY AO.Code 
