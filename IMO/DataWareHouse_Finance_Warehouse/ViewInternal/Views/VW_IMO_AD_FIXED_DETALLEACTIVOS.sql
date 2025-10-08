-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_AD_FIXED_DETALLEACTIVOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   VIEW [ViewInternal].[VW_IMO_AD_FIXED_DETALLEACTIVOS]
AS

SELECT CONVERT(datetime, RA.FAdquisición, 121) AS FAdquisición, RA.id_activo, 
--case when RA.CodUF like 'E%' then 'Abner' else RA.Sucursal end as Sucursal, 
RA.Ingreso, RA.Estado, RA.Fecha, RA.[Tipo Adquisición], RA.Placa, RA.[CodArticulo],RA.[Artículo], RA.TipoInventario, RA.Marca, RA.Modelo, RA.Serie, CASE BA.EstadoActivo WHEN 'Baja' THEN 'Baja' ELSE 'Activo' END AS EstadoActivo, 
           BA.Estado AS EstadoBaja, BA.FechaConfirmacion, RA.Responsable, RA.Localizacion, 
		   RA.CodUF,RA.UnidadFuncional, RA.CentroCosto, RA.FechaFactura, RA.Factura, RA.Proveedor, RA.VrHistorico, RA.VrTransacciones, RA.VrDepreciado, RA.Desvalorizacion, RA.Valorizacion,RA.SaldoNeto, RA.Origen, RA.Catálogo, c.CuentaContable, RA.Poliza, RA.Descripción, RA.[Fecha vencimiento garantia], 
           RA.VidaUtil, RA.DiasPendDepreciar, RA.DiasDepreciados, RA.[Tiempo Uso], RA.[Deprecia Tiempo Uso], RA.IvaItem, RA.[Contrato Leasing], RA.[Fecha Inicial Leasing], RA.[Fecha Final Leasing]
FROM   [DataWareHouse_Finance].[ViewInternal].[VW_IMO_AD_FIXED_RELACIONACTIVOS_VIE] AS RA  INNER JOIN
           [DataWareHouse_Finance].[ViewInternal].[VW_IMO_AD_FIXED_CUENTASACTIVOS] AS c ON c.Plate = RA.Placa AND RA.Placa <> 'F004045' LEFT OUTER JOIN
           [DataWareHouse_Finance].[ViewInternal].[VW_IMO_AD_FIXEDASSET_BAJAACTIVOS] AS BA  ON RA.Placa = BA.Placa AND BA.Estado = 'Confirmado'
WHERE (RA.Placa NOT IN
              -- (SELECT FixedAssetEntryId
              --FROM   FixedAsset.FixedAssetEntryDevolution AS d
              --WHERE (Status <> '3')))  --and RA.Placa ='TRG0415'
			  (select Plate
from [INDIGO035].[FixedAsset].[FixedAssetEntryDevolution] AS D
INNER JOIN [INDIGO035].[FixedAsset].[FixedAssetEntryDevolutionDetail] AS DD ON D.Id = DD.FixedAssetEntryDevolutionId
INNER JOIN [INDIGO035].[FixedAsset].[FixedAssetEntryItemDetail] AS ED ON DD.FixedAssetEntryItemDetailId = ED.Id))  --se ajusta por placa, se evidencia por caso 185612