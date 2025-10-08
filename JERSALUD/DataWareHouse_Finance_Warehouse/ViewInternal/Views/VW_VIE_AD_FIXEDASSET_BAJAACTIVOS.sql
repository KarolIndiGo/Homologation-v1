-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_FIXEDASSET_BAJAACTIVOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_FIXEDASSET_BAJAACTIVOS AS 

SELECT
    CASE WHEN RA.CodUF LIKE 'E%' THEN 'Abner' ELSE RA.Sucursal END AS Sede,
    CB.Code AS Documento,
    CB.DocumentDate AS FechaDocumento,
    CB.ConfirmationDate AS FechaConfirmacion,
    CASE CB.Status
        WHEN '1' THEN 'Registrado'
        WHEN '2' THEN 'Confirmado'
        WHEN '3' THEN 'Anulado'
    END AS Estado,
    RTRIM(art.Code) + ' - ' + RTRIM(art.Description) AS Articulo,
    pa.Plate AS Placa,
    pa.HistoricalValue AS VrHistorico,
    RA.SaldoNeto AS VrRetiro,
    CASE CB.Status
        WHEN '1' THEN 'Activo'
        WHEN '2' THEN 'Baja'
        WHEN '3' THEN 'Anulado'
    END AS EstadoActivo,
    DB.Id AS IdDetalleBaja,
    DB.FixedAssetActiveOutputId AS IdCabeceraBaja,
    CASE DB.ActiveType
        WHEN '1' THEN 'Activo'
        WHEN '2' THEN 'Parte'
    END AS Tipo,
    DB.PhysicalAssetId AS IdActivo,
    DB.PhysicalAssetPartsId AS IdParteActivo,
    RTRIM(cue.Number) + ' - ' + RTRIM(cue.Name) AS CuentaContableActivo,
    CASE DB.LowType
        WHEN '0' THEN 'NoAplica'
        WHEN '1' THEN 'Perdida'
        WHEN '2' THEN 'Siniestro'
        WHEN '3' THEN 'Perdida_Reposicion'
        WHEN '4' THEN 'Bienes_Inservibles'
    END AS TipoBaja,
    RTRIM(l.Code) + ' - ' + RTRIM(l.Name) AS Localizacion,
    CB.Observation AS Observaciones
FROM INDIGO031.FixedAsset.FixedAssetActiveOutputDetail AS DB
INNER JOIN INDIGO031.FixedAsset.FixedAssetActiveOutput AS CB ON CB.Id = DB.FixedAssetActiveOutputId
INNER JOIN INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa ON pa.Id = DB.PhysicalAssetId
INNER JOIN INDIGO031.FixedAsset.FixedAssetItem AS art ON art.Id = pa.ItemId
INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS cue ON cue.Id = DB.MainAccountId
INNER JOIN INDIGO031.FixedAsset.FixedAssetLocation AS l ON l.Id = pa.LocationId
LEFT OUTER JOIN ViewInternal.VW_VIE_AD_FIXED_RELACIONACTIVOS_VIE AS RA ON RA.Placa = pa.Plate
WHERE DB.OutputType = '1'