-- Workspace: SQLServer
-- Item: INDIGO036 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_PARAMETROS_CONCEPTOS_FACTURACION
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE [Report].[IND_SP_V2_ERP_PARAMETROS_CONCEPTOS_FACTURACION] 

AS

SELECT *
FROM
(
  SELECT BC.Id ID_CON ,BC.Code 'CODIGO' ,BC.Name 'NOMBRE CONCEPTO',CASE BC.ConceptType WHEN 1 THEN 'Facturación Básica' when 2 then 'Facturacion Salud' END 'TIPO CONCEPTO',
  CASE BC.ObtainCostCenter WHEN 1 THEN  'Unidad Funcional del Paciente' WHEN 2 THEN 'Centro de Costo Específico' WHEN 3 THEN 'Centro de Costo por Sucursal y Unidad Funcional'
  ELSE '' END 'OBTENER CENTRO COSTO',IIF(BC.ObtainCostCenter=2,CC.Code,'') 'CODIGO CC' ,IIF(BC.ObtainCostCenter=2,CC.Name,'')  'CENTRO COSTO',
  CASE BC.AccountingType WHEN 1 THEN 'Cuenta Unica de Ingreso' WHEN 2 THEN 'Cuenta por Tipo de Unidad' ELSE '' END 'TIPO CONTABILIZACION',
  IIF(BC.AccountingType=1,MA.Number,IIF(BC.ConceptType=1,MA.Number,''))'CUENTA ENTIDAD',IIF(BC.AccountingType=1,MA.Name,IIF(BC.ConceptType=1,MA.Name,''))'CUENTA INGRESO ENTIDAD',
  IIF(BC.AccountingType=1,MA2.Number,IIF(BC.ConceptType=1,MA2.Number,''))'CUENTA PARTICULAR',IIF(BC.AccountingType=1,MA2.Name,IIF(BC.ConceptType=1,MA2.Name,''))'CUENTA INGRESO PARTICULAR',
  IIF(BC.AccountingType=1,MA3.Number,IIF(BC.ConceptType=1,MA3.Number,''))'CUENTA RECONOCIMIENTO',IIF(BC.AccountingType=1,MA3.Name,IIF(BC.ConceptType=1,MA3.Name,''))'CUENTA INGRESO RECONOCIMIENTO',
  IIF(BC.AccountingType=1,MA4.Number,IIF(BC.ConceptType=1,MA4.Number,''))'CUENTA HONORARIOS',IIF(BC.AccountingType=1,MA4.Name,IIF(BC.ConceptType=1,MA4.Name,''))'CUENTA GASTO HONORARIO',
  IIF(BC.AccountingType=1,MA9.Number,IIF(BC.ConceptType=1,MA9.Number,''))'CUENTA DESCUENTO',IIF(BC.AccountingType=1,MA9.Name,IIF(BC.ConceptType=1,MA9.Name,''))'CUENTA PARA DESCUENTO',
  CASE BCA.UnitType WHEN 1 THEN 'URGENCIAS' WHEN 2 THEN 'HOSPITALIZACION' WHEN 3 THEN 'QUIROFANO' WHEN 4 THEN 'CONSULTA EXTERNA' END 'TIPO UNIDAD' ,
  --CASE BCA.UnitType WHEN 1 THEN 'URGENCIAS2' WHEN 2 THEN 'HOSPITALIZACION2' WHEN 3 THEN 'QUIROFANO2' WHEN 4 THEN 'CONSULTA EXTERNA2' END 'TIPO UNIDAD2' ,
  MA5.NUMBER + '-' + 'IE' + '/' + MA6.NUMBER + '-' + 'IP' +'/' + MA8.NUMBER + '-'  +'GH' + '/' + MA7.NUMBER + '-' + 'RI' 'CUENTA INGRESO UF '--,MA6.NUMBER + '-' + MA6.NAME 'CUENTA PARTICULAR UF'--,MA7.NUMBER + '-' + MA7.NAME 'CUENTA RECONOCIMIENTO UF',
  --MA8.NUMBER + '-' + MA8.NAME 'CUENTA HONORARIO UF'
  FROM Billing.BillingConcept BC
  LEFT JOIN Payroll .CostCenter AS CC ON CC.Id =BC.ObtainCostCenter 
  LEFT JOIN GeneralLedger .MainAccounts MA ON MA.ID=BC.EntityIncomeAccountId 
  LEFT JOIN GeneralLedger .MainAccounts MA2 ON MA2.ID=BC.IndividualIncomeAccountId 
  LEFT JOIN GeneralLedger .MainAccounts MA3 ON MA3.ID=BC.IncomeRecognitionPendingBillingMainAccountId 
  LEFT JOIN GeneralLedger .MainAccounts MA4 ON MA4.ID=BC.FeesExpensesAccountId 
  LEFT JOIN GeneralLedger .MainAccounts MA9 ON MA9.ID=BC.DiscountAccountId  
  LEFT JOIN Billing.BillingConceptAccount AS BCA ON BCA.BillingConceptId =BC.ID
  --
  LEFT JOIN GeneralLedger .MainAccounts MA5 ON MA5.ID=BCA.EntityIncomeAccountId 
  LEFT JOIN GeneralLedger .MainAccounts MA6 ON MA6.ID=BCA.IndividualIncomeAccountId
  LEFT JOIN GeneralLedger .MainAccounts MA7 ON MA7.ID=BCA.IncomeRecognitionMainAccountId
  LEFT JOIN GeneralLedger .MainAccounts MA8 ON MA8.ID=BCA.FeesExpensesAccountId 
  

 -- WHERE BC.ID=4
 -- ORDER BY BC.ConceptType DESC, BC.CODE
) AS SourceTable

PIVOT  
(MAX([CUENTA INGRESO UF])
    FOR [TIPO UNIDAD] In([URGENCIAS],[HOSPITALIZACION],[QUIROFANO],[CONSULTA EXTERNA])
) AS PVTTABLE

--PIVOT  
--(MAX([CUENTA PARTICULAR UF])
--    FOR [TIPO UNIDAD2] In([URGENCIAS2],[HOSPITALIZACION2],[QUIROFANO2],[CONSULTA EXTERNA2])
--) AS PVTTABLE2

ORDER BY [TIPO CONCEPTO] DESC, CODIGO
