-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_GeneralLedger_MovimientosContables
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VIE_AD_GeneralLedger_MovimientosContables AS
SELECT
TABLA3.Code AS Tipo_Comprobante, 
TABLA1.Consecutive AS Consecutivo,
CASE TABLA1.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado,  
TABLA4.Number AS Auxiliar, 
TABLA4.Name AS [Nombre Auxiliar],
TABLA1.VoucherDate AS Fecha_comprobante, 
MONTH(TABLA1.VoucherDate) AS Mes, 
TABLA6.Nit, 
TABLA6.Name AS Tercero, 
CASE TABLA6.PersonType WHEN '1' THEN 'Natural' WHEN '2' THEN 'Jurídico' END AS Tipo_Persona,
TABLA2.DebitValue AS Débito, 
TABLA2.CreditValue AS Crédito, 
TABLA2.DebitValue-TABLA2.CreditValue AS NETO,
TABLA1.Detail AS Detalle_Observaciones, 
TABLA5.Code + '-' + TABLA5.Name AS Código_Retención, 
TABLA2.RetentionRate AS PorcRetención, 
TABLA2.BaseValue AS Base, 
TABLA2.BillingValue AS Valor_facturado, 
CASE TABLA6.RetentionType WHEN '0' THEN 'Ninguna' WHEN '1' THEN 'ExentoDeRetencion' WHEN '2' THEN 'Hace_Retencion' WHEN '3' THEN 'Autoretenedor' END AS Tipo_Retención, 
CASE TABLA6.ContributionType WHEN '0' THEN 'Simplificado' WHEN '1' THEN 'Común' WHEN '2' THEN 'EmpresaEstatal' WHEN '3' THEN 'Gran_Contribuyente' END AS Tipo_Contribuyente, 
TABLA8.Fullname AS Usuario,
TABLA1.EntityCode AS Doc_Origen,
TABLA2.Detail AS DETALLE,
LEFT(TABLA4.Number, 2) AS Grupo, (SELECT Name FROM   GeneralLedger.MainAccounts WHERE (Number = LEFT(TABLA4.Number, 2)) AND (LegalBookId = '2')) AS [Nombre Grupo],
LEFT(TABLA4.Number, 4) AS Cuenta, (SELECT Name FROM  GeneralLedger.MainAccounts WHERE (Number = LEFT(TABLA4.Number, 4)) AND (LegalBookId = '2')) AS [Nombre Cuenta], 
LEFT(TABLA4.Number, 6) AS SubCuenta, (SELECT Name FROM GeneralLedger.MainAccounts WHERE (Number = LEFT(TABLA4.Number, 6)) AND (LegalBookId = '2')) AS [Nombre SubCuenta]


FROM GeneralLedger.JournalVouchers AS TABLA1  INNER JOIN GeneralLedger.JournalVoucherDetails AS TABLA2 WITH (NOLOCK) ON TABLA1.Id = TABLA2.IdAccounting
                                                                                         INNER JOIN GeneralLedger.JournalVoucherTypes AS TABLA3 WITH (NOLOCK) ON TABLA1.IdJournalVoucher = TABLA3.Id
                                                                                         INNER JOIN GeneralLedger.MainAccounts AS TABLA4 WITH (NOLOCK) ON TABLA4.Id = TABLA2.IdMainAccount
                                                                               LEFT OUTER JOIN GeneralLedger.RetentionConcepts AS TABLA5 WITH (NOLOCK) ON TABLA5.Id = TABLA2.IdRetention 
                                                                               LEFT OUTER JOIN Common.ThirdParty AS TABLA6 WITH (NOLOCK) ON TABLA6.Id = TABLA2.IdThirdParty 
                                                                                         LEFT OUTER JOIN Security.[User] AS TABLA7  ON TABLA7.UserCode = TABLA1.CreationUser 
                                                                                         LEFT OUTER JOIN Security.Person AS TABLA8  ON TABLA8.Id = TABLA7.IdPerson

WHERE
(TABLA1.LegalBookId = '2') 
AND TABLA1.VoucherDate >={ts '2023-01-01 00:00:00'}
AND TABLA1.Status ='2'	