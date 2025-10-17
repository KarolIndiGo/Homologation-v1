-- Workspace: SQLServer
-- Item: INDIGO036 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: VW_ReportedeBajas
-- Extracted by Fabric SQL Extractor SPN v3.9.0




/************REPORTE BAJAS********************/
CREATE VIEW [Report].[VW_ReportedeBajas] AS
 SELECT 
	CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
	AO.Code AS 'CODIGO',
	AO.DocumentDate AS 'FECHA DOCUMENTO',
    TAF.Plate AS 'PLACA',
    P.Description AS 'NOMBRE_ACTIVO',
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
 
FROM FixedAsset.FixedAssetActiveOutputDetail AS BJ 
INNER JOIN FixedAsset.FixedAssetActiveOutput AS AO 
	ON BJ.FixedAssetActiveOutputId = AO.Id
LEFT JOIN FixedAsset.FixedAssetPhysicalAsset AS TAF  
	ON TAF.Id = BJ.PhysicalAssetId
INNER JOIN FixedAsset.FixedAssetItem AS P 
	 ON P.Id = taf.ItemId
INNER JOIN FixedAsset.FixedAssetPhysicalAssetDetailBook AS DBK 
    ON BJ.PhysicalAssetId = DBK.PhysicalAssetId AND DBK.LegalBookId = 1
LEFT JOIN FixedAsset.FixedAssetPhysicalAssetDetailBook AS DBK2 
    ON BJ.PhysicalAssetId = DBK2.PhysicalAssetId AND DBK2.LegalBookId = 2
INNER JOIN FixedAsset.FixedAssetResponsible AS REF 
	ON  TAF.ResponsibleId=REF.Id
INNER JOIN Common.ThirdParty AS TP 
	ON REF.Code=TP.Nit
INNER JOIN	FixedAsset.FixedAssetLocation AS UI 
	 ON UI.Id = TAF.LocationId
 --WHERE P.Code='BA-INV-100102-9' 
 --ORDER BY AO.Code 
