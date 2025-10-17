-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_IndicadoresGralxProfesional_Medicamentos_Tarifa_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0



create VIEW [ViewInternal].[IND_IndicadoresGralxProfesional_Medicamentos_Tarifa_PB] as

select e.*, tt.CodAgrupador, tt.Agrupador, e.CANPEDPRO*TT.VrProducto AS Total
from [ViewInternal].[IND_IndicadoresGralxProfesional_Medicamentos_Tarifa] as e with (nolock)
left outer join ViewInternal.VIE_AD_Inventory_TarifaProducto_PB as tt with (nolock) on tt.CodAgrupador=e.Producto
