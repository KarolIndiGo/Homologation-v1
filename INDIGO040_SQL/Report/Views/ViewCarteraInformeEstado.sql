-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewCarteraInformeEstado
-- Extracted by Fabric SQL Extractor SPN v3.9.0


    /*******************************************************************************************************************
Nombre: [Report].[ViewCarteraInformeEstado]
Tipo:Vista
Observacion: Cartera
Profesional: Andres Cabrera
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:
Fecha:
Observaciones:
-------------------------------------------------------------------------------------------------------------------------------------
Version 3
Persona que modifico:
Fecha:
Observaciones:
***********************************************************************************************************************************/


CREATE VIEW [Report].[ViewCarteraInformeEstado] AS
WITH CTE_CUENTA
AS
(
  SELECT  ACS.AccountWithoutRadicateId ,ACS.AccountRadicateId ,ACS.AccountObjectionRemediedId ,
  ACS.AccountConciliationId ,ACS.AccountHardCollectionId ,ACS.AccountLegalCollectionId ,MA.Number 
  FROM Contract .ContractAccountingStructure ACS
  INNER JOIN GeneralLedger.MainAccounts AS MA ON MA.Id =ACS.AccountLegalCollectionId

),

CTE_CARTERA
AS
(
SELECT 
AR.Id ,TP.Nit ,
TP.Name 'CLIENTE',
AR.InvoiceNumber 'NUMERO FACTURA',
CASE AR.PortfolioStatus  WHEN 1 THEN 'Sin Radicar' 
						 WHEN 2 THEN 'Radicada sin Confirmar'
						 WHEN 3 THEN 'Radicada Entidad' 
						 WHEN 4 THEN 'Objetada o Glosada' 
						 WHEN 7 THEN 'Certificada Parcial' 
						 WHEN 8 THEN 'Certificada Total' 
						 WHEN 14 THEN 'Devolución Factura'
						 WHEN 15 THEN 'Cuenta de Dificil Recaudo' 
						 WHEN 16 THEN 'Cobro Jurídico' END 'ESTADO CARTERA', 
CASE AR.OpeningBalance  WHEN 1 THEN 'SI' ELSE 'NO' END 'SALDO INICIAL',
AR.Value,
ma.Number,
ma.Name,
ara.Value 'VALOR EN CUENTA' ,
ara.Balance  'SALDO'
from Portfolio .AccountReceivable as AR
INNER JOIN Portfolio .AccountReceivableAccounting AS ARA ON ARA.AccountReceivableId =AR.Id 
inner join GeneralLedger .MainAccounts as ma on ma.Id =ara.MainAccountId 
INNER JOIN Common .ThirdParty AS TP ON TP.Id =AR.ThirdPartyId 
where ar.Balance <>0 --and ar.InvoiceNumber ='HFE156012'
AND AR.AccountReceivableType =2
)

SELECT DISTINCT
CAR.*,EST.DESCRI 
FROM CTE_CARTERA CAR
INNER JOIN [Report].[TempCartera] EST ON CAR.Number =EST.CUENTA
