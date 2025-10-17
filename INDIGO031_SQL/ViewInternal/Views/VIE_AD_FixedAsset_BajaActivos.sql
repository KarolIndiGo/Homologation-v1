-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_FixedAsset_BajaActivos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_FixedAsset_BajaActivos]
AS
SELECT 
--CASE WHEN l.Code LIKE 'C%' THEN 'Faca' WHEN l.Code LIKE 'B%' THEN 'Bogota' 
--WHEN l.Code LIKE 'F%' THEN 'Florencia' WHEN l.Code LIKE 'n%' THEN 'Neiva' WHEN l.Code LIKE 'T%' THEN 'Tunja' WHEN l.Code LIKE 'P%' THEN 'Pitalito' END AS
                  case when ra.CodUF like 'E%' then 'Abner' else ra.Sucursal end as
				  Sede, CB.Code AS Documento, CB.DocumentDate AS FechaDocumento, CB.ConfirmationDate AS FechaConfirmacion, CASE CB.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, 
                  RTRIM(art.Code) + ' - ' + RTRIM(art.Description) AS Articulo, pa.Plate AS Placa, pa.HistoricalValue AS VrHistorico, RA.SaldoNeto AS VrRetiro, 
                  CASE CB.Status WHEN '1' THEN 'Activo' WHEN '2' THEN 'Baja' WHEN '3' THEN 'Anulado' END AS EstadoActivo, DB.Id AS IdDetalleBaja, DB.FixedAssetActiveOutputId AS IdCabeceraBaja, 
                  CASE DB.ActiveType WHEN '1' THEN 'Activo' WHEN '2' THEN 'Parte' END AS Tipo, DB.PhysicalAssetId AS IdActivo, DB.PhysicalAssetPartsId AS IdParteActivo, RTRIM(cue.Number) + ' - ' + RTRIM(cue.Name) AS CuentaContableActivo, 
                  CASE DB.LowType WHEN '0' THEN 'NoAplica' WHEN '1' THEN 'Perdida' WHEN '2' THEN 'Siniestro' WHEN '3' THEN 'Perdida_Reposicion' WHEN '4' THEN 'Bienes_Inservibles' END AS TipoBaja, RTRIM(l.Code) + ' - ' + RTRIM(l.Name) 
                  AS Localizacion, CB.Observation AS Observaciones
FROM    FixedAsset.FixedAssetActiveOutputDetail AS DB  INNER JOIN
                 FixedAsset.FixedAssetActiveOutput AS CB  ON CB.Id = DB.FixedAssetActiveOutputId INNER JOIN
                 FixedAsset.FixedAssetPhysicalAsset AS pa  ON pa.Id = DB.PhysicalAssetId INNER JOIN
                 FixedAsset.FixedAssetItem AS art  ON art.Id = pa.ItemId INNER JOIN
                 GeneralLedger.MainAccounts AS cue  ON cue.Id = DB.MainAccountId INNER JOIN
                 FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId LEFT OUTER JOIN
                  ViewInternal.VIE_AD_Fixed_RelaciónActivos_Vie AS RA  ON RA.Placa = pa.Plate
WHERE  (DB.OutputType = '1')
