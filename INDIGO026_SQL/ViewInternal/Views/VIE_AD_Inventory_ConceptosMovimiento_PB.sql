-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Inventory_ConceptosMovimiento_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view [ViewInternal].[VIE_AD_Inventory_ConceptosMovimiento_PB] as

SELECT con.id as ID,con.Code AS Codigo, con.Name AS Nombre, 
CASE MovementClass WHEN '1' THEN 'AjusteInventario' WHEN '2' THEN 'TrasladoConsumo' END AS ClaseMovimiento, 
CASE ConceptType WHEN '1' THEN 'Entrada' WHEN '2' THEN 'Salida' END AS Tipo, cuenta.Number AS Cuenta, cuenta.Name AS CuentaContable, centro.Code, 
           centro.Name AS CentroCosto, case con.status when 1 then 'Activo' when 0 then 'Inactivo' end as Estado, 
		   case affectsaveragecost when 1 then 'Si' when 0 then 'No' end as [Afecta Costo Prom]
FROM   Inventory.AdjustmentConcept AS con LEFT OUTER JOIN
           GeneralLedger.MainAccounts AS cuenta  ON cuenta.Id = con.AdjustmentAccountId LEFT OUTER JOIN
           Payroll.CostCenter AS centro  ON centro.Id = con.CostCenterId 