-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_VERIFICAR_SALDO_RUBROS
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_VERIFICAR_SALDO_RUBROS]
AS

SELECT b.InitialValue ValorInicial,
       SUM(b.ExecutedValue) AS ValorEjecutadoRubro,
       SUM(bad.ExecutedValue) AS ValorDisponiblidad,
	   b.balance DisponibleRubro,
       bc.code AS CodigoRubro,
       bc.name AS NombreRubro,
	   ba.code Disponibilidad,
	   ISNULL(cast(bam.code as varchar),'Sin Modificacion') CodigoModificacionDisponibilidad,
	   ISNULL(cast(bamd.Value as varchar), 'Sin Modificacion') Valor,
	   case bamd.nature
	   when 0
	   then 'Debito'
	   when 2
	   then 'Credito'
	   else '0'
	   end Naturaleza,
	   cpc.code CodigoCpc,
	   cpc.name NombreCpc

FROM Budget.Availability BA
JOIN Budget.AvailabilityDetail BAD ON BAD.availabilityid = BA.id
JOIN Budget.Budget B ON B.id = BAD.budgetid
JOIN Budget.Category BC ON BC.id = B.categoryid
JOIN Budget.CPCCatalog cpc on cpc.id = bad.CPCCodeId
LEFT JOIN Budget.AvailabilityModification bam on bam.AvailabilityId = ba.id
LEFT JOIN Budget.AvailabilityModificationDetail bamd on bamd.AvailabilityDetailId = bad.id
WHERE BA.BudgetaryValidityId = 11 
GROUP BY bc.code, bc.name, BA.BudgetaryValidityId, b.id , cpc.code ,cpc.name,ba.code,b.balance,bam.code,bamd.Value,bamd.nature,b.InitialValue ;

  

