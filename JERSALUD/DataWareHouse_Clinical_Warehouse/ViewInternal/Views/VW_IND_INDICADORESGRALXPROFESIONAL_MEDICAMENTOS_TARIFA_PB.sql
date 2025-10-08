-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_INDICADORESGRALXPROFESIONAL_MEDICAMENTOS_TARIFA_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_INDICADORESGRALXPROFESIONAL_MEDICAMENTOS_TARIFA_PB 
AS
select e.*, tt.CodAgrupador, tt.Agrupador, e.CANPEDPRO*tt.VrProducto AS Total
from [DataWareHouse_Clinical].[ViewInternal].[VW_IND_INDICADORESGRALXPROFESIONAL_MEDICAMENTOS_TARIFA] as e 
left outer join [DataWareHouse_Finance].[ViewInternal].[VW_VIE_AD_INVENTORY_TARIFAPRODUCTO_PB] as tt  on tt.CodAgrupador=e.Producto
