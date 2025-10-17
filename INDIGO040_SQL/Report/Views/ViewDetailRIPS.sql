-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewDetailRIPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE View Report.ViewDetailRIPS
as

--with cte_subquery as (
select 
'HOSPITAL SAN JOSE' as EMPRESA, 
ripd.MessageCode AS [CODIGO MENSAJE],
ripd.TypeMessage AS [TIPO MENSAJE], 
CASE ep.EntityName WHEN 'Invoice' THEN 'Factura'
				   WHEN 'BillingNote' THEN 'Notas' else 'Desconocido' END [TIPO DOCUMENTO],
case ep.StatusRIPS WHEN 1 then 'Registrado'
				   WHEN 2 then 'Validado'
				   WHEN 3 then 'Erroneo' END [ESTADO RIPS],
rip.Id [Id Rips],
ripd.CreationDate,
1 as CANTIDAD
from Billing.ElectronicsProperties ep
join Billing.ElectronicsRIPS rip on ep.Id = rip.ElectronicsPropertiesId
join Billing.ElectronicsRIPSDetail ripd on rip.Id = ripd.ElectronicsRIPSId
--where ep.StatusRIPS <> 2 and ripd.TypeMessage='RECHAZADO'
--),
--CTE_CALCULO AS
--(
--SELECT DISTINCT
--[Id Rips],
--[ESTADO RIPS],
--[TIPO DOCUMENTO],
--CANTIDAD
--FROM  cte_subquery cte
--GROUP BY [Id Rips],[ESTADO RIPS],[TIPO DOCUMENTO],CANTIDAD)

--SELECT
--SUM(CANTIDAD) AS CANTIDAD,
--[ESTADO RIPS],
--[TIPO DOCUMENTO]
--FROM CTE_CALCULO
--GROUP BY [ESTADO RIPS],[TIPO DOCUMENTO]


