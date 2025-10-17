-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_Costos
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[View_HDSAP_Costos]
AS

SELECT         DC.Year AS Año, 
                         CASE WHEN dc.month = '1' THEN 'Enero' WHEN dc.month = '2' THEN 'Febrero' WHEN dc.month = '3' THEN 'Marzo' WHEN dc.month = '4' THEN 'Abril' WHEN dc.month = '5' THEN 'Mayo' WHEN dc.month = '6' THEN
                          'Junio' WHEN dc.month = '7' THEN 'Julio' WHEN dc.month = '8' THEN 'Agosto' WHEN dc.month = '9' THEN 'Septiembre' WHEN dc.month = '10' THEN 'Octubre' WHEN dc.month = '11' THEN 'Noviembre' WHEN dc.month
                          = '12' THEN 'Diciembre' END AS Mes, DC.Code AS Codigo, GE.Code + '-' + GE.Name AS [Elemento del Costo], t.Nit, t.Name AS Tercero, c.Code + '-' + c.Name AS [Centro de Costo], 
                         ma.Number + ' - ' + ma.Name AS [Cuenta Contable], DC.Value AS Valor, DC.BillNumber AS [No Factura], pc.Code + '-' + pc.Name AS [Centro de Producción], 
                         CASE DB.DistributionType WHEN '1' THEN 'Directa' WHEN '2' THEN 'Calculada' WHEN '3' THEN 'Buscada' END AS [Tipo Distribución], MU.Name AS [UM Directa], 
                         CASE db.MeasurementUnit WHEN '1' THEN 'Ninguna' WHEN '2' THEN 'Proporción' WHEN '3' THEN 'Valor' END AS [UM Calculada], CAST(CC.Percentage AS int) AS [% Distribuido], CC.Count AS Cantidad, 
                         CC.CostValue AS [Valor Costo], CC.Value AS [Total CP], CASE dc.status WHEN '1' THEN 'Sin Confirmar' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, DC.Observation AS Observación, 
                         CASE GE.ElementCostType WHEN 1 THEN 'Mano de obra Directa' WHEN 2 THEN 'Mano de obra Indirecta' WHEN 3 THEN 'Materiales Directos' WHEN 4 THEN 'Materiales Indirectos' WHEN 5 THEN 'Otros Gastos'
                          END AS [Tipo de Costo], CE.Code + '-' + CE.Name AS Categoria
FROM            Cost.CostDistributionDirectCost AS DC INNER JOIN
                         Cost.CostDistributionDirectCostDetail AS CC WITH (NOLOCK) ON CC.DistributionDirectCostId = DC.Id INNER JOIN
                         Common.ThirdParty AS t WITH (nolock) ON t.Id = DC.ThirdPartyId INNER JOIN
                         Payroll.CostCenter AS c WITH (nolock) ON c.Id = CC.CostCenterId INNER JOIN
                         GeneralLedger.MainAccounts AS ma WITH (nolock) ON ma.Id = CC.MainAccountId INNER JOIN
                         Cost.CostProductionCenter AS pc WITH (nolock) ON pc.Id = CC.ProductionCenterId INNER JOIN
                         Cost.CostGeneralExpense AS GE WITH (NOLOCK) ON GE.Id = DC.GeneralExpenseId INNER JOIN
                         Cost.CostDistributionBase AS DB WITH (NOLOCK) ON DB.GeneralExpenseId = GE.Id LEFT OUTER JOIN
                         Inventory.InventoryMeasurementUnit AS MU WITH (NOLOCK) ON MU.Id = CC.MeasurementUnitId LEFT OUTER JOIN
                         Cost.CostGeneralExpenseCategory AS CE WITH (NOLOCK) ON CE.Id = GE.CostGeneralExpenseCategoryId
  

