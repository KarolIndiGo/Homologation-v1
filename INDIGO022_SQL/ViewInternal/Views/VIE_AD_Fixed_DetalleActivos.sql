-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Fixed_DetalleActivos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Fixed_DetalleActivos]
AS
SELECT CONVERT(datetime, RA.FAdquisición, 121) AS FAdquisición, RA.id_activo, 
RA.Ingreso, 
RA.Estado, 
RA.Fecha, 
RA.[Tipo Adquisición], 
RA.Placa, 
ra.[CodArticulo],
RA.[Artículo], 
RA.TipoInventario,
RA.Marca, 
RA.Modelo, 
RA.Serie, 
RA.EstadoActivo, --CASE BA.EstadoActivo WHEN 'Baja' THEN 'Baja' ELSE 'Activo' END AS EstadoActivo, CASO 227165 se ajusta el estado por la vista de RelacionActivos
BA.Estado AS EstadoBaja, 
BA.FechaConfirmacion, 
RA.Responsable, 
RA.Localizacion, 
RA.CodUF,
RA.UnidadFuncional,
RA.CentroCosto, 
RA.FechaFactura,
RA.Factura, 
RA.Proveedor, 
RA.VrHistorico, 
RA.VrTransacciones,
RA.VrDepreciado, 
RA.Desvalorizacion, 
RA.Valorizacion,
RA.SaldoNeto, 
RA.Origen, 
RA.Catálogo, 
C.CuentaContable, 
RA.Poliza, 
RA.Descripción, 
RA.[Fecha vencimiento garantia], 
RA.VidaUtil, RA.DiasPendDepreciar, RA.DiasDepreciados, RA.[Tiempo Uso], RA.[Deprecia Tiempo Uso], RA.IvaItem, RA.[Contrato Leasing], RA.[Fecha Inicial Leasing], RA.[Fecha Final Leasing]
FROM   ViewInternal.VIE_AD_Fixed_RelaciónActivos_Vie AS RA  INNER JOIN
ViewInternal.VIE_AD_Fixed_CuentasActivos AS c ON c.Plate = RA.Placa  LEFT OUTER JOIN
ViewInternal.VIE_AD_FixedAsset_BajaActivos AS BA  ON RA.Placa = BA.Placa AND BA.Estado = 'Confirmado'
WHERE (RA.IdIngreso NOT IN
               (SELECT FixedAssetEntryId
              FROM   FixedAsset.FixedAssetEntryDevolution AS d
              WHERE (Status <> '3')))  --and RA.Placa ='MBY0023'
