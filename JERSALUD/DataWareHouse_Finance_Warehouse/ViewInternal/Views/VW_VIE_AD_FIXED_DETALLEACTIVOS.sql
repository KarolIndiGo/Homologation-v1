-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_FIXED_DETALLEACTIVOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_FIXED_DETALLEACTIVOS AS

SELECT 
    CONVERT(datetime, RA.FAdquisición, 121) AS FAdquisición,
    RA.id_activo,
    CASE WHEN RA.CodUF LIKE 'E%' THEN 'Abner' ELSE RA.Sucursal END AS Sucursal,
    RA.Ingreso,
    RA.Estado,
    RA.Fecha,
    RA.[Tipo Adquisición],
    RA.Placa,
    RA.[CodArticulo],
    RA.[Artículo],
    RA.TipoInventario,
    RA.Marca,
    RA.Modelo,
    RA.Serie,
    RA.EstadoActivo,
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
    c.CuentaContable,
    RA.Poliza,
    RA.Descripción,
    RA.[Fecha vencimiento garantia],
    RA.VidaUtil,
    RA.DiasPendDepreciar,
    RA.DiasDepreciados,
    RA.[Tiempo Uso],
    RA.[Deprecia Tiempo Uso],
    RA.IvaItem,
    RA.[Contrato Leasing],
    RA.[Fecha Inicial Leasing],
    RA.[Fecha Final Leasing]
FROM   ViewInternal.VW_VIE_AD_FIXED_RELACIONACTIVOS_VIE AS RA
       INNER JOIN ViewInternal.VW_VIE_AD_FIXED_CUENTASACTIVOS AS c
           ON c.Plate = RA.Placa AND RA.Placa <> 'F004045'
       LEFT OUTER JOIN ViewInternal.VW_VIE_AD_FIXEDASSET_BAJAACTIVOS AS BA
           ON RA.Placa = BA.Placa AND BA.Estado = 'Confirmado'
WHERE (RA.IdIngreso NOT IN
           (SELECT FixedAssetEntryId
            FROM   INDIGO031.FixedAsset.FixedAssetEntryDevolution AS d
            WHERE (Status <> '3')))