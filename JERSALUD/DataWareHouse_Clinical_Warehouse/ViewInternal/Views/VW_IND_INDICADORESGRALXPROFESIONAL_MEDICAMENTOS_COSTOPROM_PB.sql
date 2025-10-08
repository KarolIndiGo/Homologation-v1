-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_INDICADORESGRALXPROFESIONAL_MEDICAMENTOS_COSTOPROM_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_INDICADORESGRALXPROFESIONAL_MEDICAMENTOS_COSTOPROM_PB 
AS

select  e.*
        , tt.Code
        , tt.Name
        , e.CANPEDPRO*tt.total AS vrTotal
from [DataWareHouse_Clinical].[ViewInternal].[VW_IND_INDICADORESGRALXPROFESIONAL_MEDICAMENTOS_COSTOPROM] as e 
left outer join [DataWareHouse_Finance].[ViewInternal].[VW_VIE_AD_INVENTORY_COSTOPROMEDIOPRODUCTO] as tt  on tt.Code=e.Producto
