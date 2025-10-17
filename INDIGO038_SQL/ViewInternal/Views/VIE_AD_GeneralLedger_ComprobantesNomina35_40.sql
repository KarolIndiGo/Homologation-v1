-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_GeneralLedger_ComprobantesNomina35_40
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [ViewInternal].[VIE_AD_GeneralLedger_ComprobantesNomina35_40]
AS
SELECT tcoco.Code AS [Tipo Comprobante], coco.Consecutive AS Consecutivo, cuenta.Number AS cuenta, cuenta.Name AS Descripción, ccosto.Code AS CC, ccosto.Name AS [Centro costo], coco.VoucherDate AS [Fecha comprobante], 
MONTH(coco.VoucherDate) AS Mes, YEAR(coco.VoucherDate) AS Año,dcoco.DebitValue AS Débito, dcoco.CreditValue AS Crédito, 
           coco.Detail AS [Detalle-Observaciones], dcoco.RetentionRate AS [% retención], T.Nit, T.Name AS Tercero, CASE coco.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, CASE T .PersonType WHEN '1' THEN 'Natural' WHEN '2' THEN 'Jurídico' END AS [Tipo Persona], 
           CASE T .ContributionType WHEN '0' THEN 'Simplificado' WHEN '1' THEN 'Común' WHEN '2' THEN 'EmpresaEstatal' WHEN '3' THEN 'Gran_Contribuyente' END AS [Tipo Contribuyente], per.Fullname AS Usuario
FROM   GeneralLedger.JournalVouchers AS coco  INNER JOIN
           GeneralLedger.JournalVoucherDetails AS dcoco  ON coco.Id = dcoco.IdAccounting  INNER JOIN
           GeneralLedger.JournalVoucherTypes AS tcoco  ON coco.IdJournalVoucher = tcoco.Id INNER JOIN
           GeneralLedger.MainAccounts AS cuenta  ON cuenta.Id = dcoco.IdMainAccount INNER JOIN
           Common.ThirdParty AS T  ON T.Id = dcoco.IdThirdParty INNER JOIN
           Security.[User] AS u  ON u.UserCode = coco.CreationUser INNER JOIN
           Security.Person AS per  ON per.Id = u.IdPerson LEFT OUTER JOIN
           Payroll.CostCenter AS ccosto ON ccosto.Id = dcoco.IdCostCenter
WHERE (cuenta.LegalBookId = '2')  AND (coco.LegalBookId = '2') 
AND (tcoco.Code IN ('35', '40', '07', '06', '09', '18', '19', '20',  '99',  '38', '44', '45','05','24','22','34','21'))
