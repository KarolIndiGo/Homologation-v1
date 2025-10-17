-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_IndicadoresGralxProfesional_Medicamentos_CostoProm_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_IndicadoresGralxProfesional_Medicamentos_CostoProm_PB] as

select e.*, tt.code, tt.name, e.CANPEDPRO*TT.total AS vrTotal
from ViewInternal.[IND_IndicadoresGralxProfesional_Medicamentos_CostoProm] as e WITH (NOLOCK)
left outer join ViewInternal.VIE_AD_Inventory_CostoPromedioProducto as tt WITH (NOLOCK) on tt.code=e.Producto
