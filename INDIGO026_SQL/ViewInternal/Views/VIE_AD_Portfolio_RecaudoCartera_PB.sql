-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Portfolio_RecaudoCartera_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE view [ViewInternal].[VIE_AD_Portfolio_RecaudoCartera_PB] AS
SELECT   PA.Code AS Anticipo, 

CASE when T.PersonType=1 then '999' else T .Nit end as Nit , 
case when T.PersonType=1 then 'PARTICULARES' else T .Name end AS Cliente, 
b.name AS Banco, eba.number AS CuentaBancaria, cr.Code AS Recibo,
 CASE WHEN cr.DocumentDate IS NOT NULL THEN cr.DocumentDate ELSE PA.ConfirmationDate END AS [Fecha Recibo/Anticipo], 
 cr.Detail AS [Detalle Recibo], PA.Value AS Valor, PA.TransferValue AS VrTrasladado, 
          
PA.Balance AS Saldo, 
             CASE PA.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS EstadoAnticipo 			
FROM     Portfolio.PortfolioAdvance AS PA  INNER JOIN
             Common.ThirdParty AS T  ON T .Id = PA.ThirdPartyId INNER JOIN
             GeneralLedger.MainAccounts AS C  ON C.Id = PA.MainAccountId AND C.LegalBookId = '1' LEFT OUTER JOIN
             Treasury.CashReceipts AS cr  ON cr.Id = PA.CashReceiptId AND cr.CollectType <> '1' AND cr.Status <> '3' AND cr.Status <> '4' AND cr.Code = PA.Code AND PA.Status <> '3' LEFT OUTER JOIN
             Payroll.CostCenter AS ccos  ON ccos.Id = PA.CostCenterId LEFT OUTER JOIN
             Treasury.EntityBankAccounts AS eba  ON eba.Id = cr.IdBankAccount LEFT OUTER JOIN
             Payroll.Bank AS b  ON eba.IdBank = b.Id --LEFT OUTER JOIN
            -- ReportesMedi.dbo.SucursalRecaudo AS rs  ON rs.nit = t .nit LEFT OUTER JOIN
                --(SELECT   Anticipo, COALESCE (Neiva, 0) AS Neiva, COALESCE (Florencia, 0) AS Florencia, COALESCE (Tunja, 0) AS Tunja, COALESCE (Pitalito, 0) AS Pitalito
                --                                                                                                                  FROM      (SELECT   Anticipo, Sucursal, (VrCruce) AS ValorCruce
                --                                                                                                                                FROM      ReportesMedi.[dbo].[VIE_AD_Portfolio_CruceAnticiposVsCartera] ) Source PIVOT (SUM(SOURCE.ValorCruce) FOR Source.Sucursal IN (Neiva, Florencia, Tunja, 
                --                                                                                                                                Pitalito)) AS PIVOTABLE) AS Cruce ON Cruce.Anticipo = pa.code
WHERE   (PA.Status <> '3') AND (C.Number NOT IN ('2120120601', '4101080602', '4101080603', '4101080611', '4101080612', '2501010601')) AND PA.OpeningBalance = '0' AND 
cr.Code not in ('000009436','000009439')

--union all

--SELECT   PA.Code AS Anticipo, 

--CASE when T.PersonType=1 then '999' else T .Nit end as Nit , 
--case when T.PersonType=1 then 'PARTICULARES' else T .Name end AS Cliente, 
--b.name AS Banco, eba.number AS CuentaBancaria, cr.Code AS Recibo,
-- CASE WHEN cr.DocumentDate IS NOT NULL THEN cr.DocumentDate ELSE PA.ConfirmationDate END AS [Fecha Recibo/Anticipo], 
-- cr.Detail AS [Detalle Recibo], PA.Value AS Valor, PA.TransferValue AS VrTrasladado, 
          
--PA.Balance AS Saldo, 
--             CASE PA.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS EstadoAnticipo 			
--FROM     Portfolio.PortfolioAdvance AS PA  INNER JOIN
--             Common.ThirdParty AS T  ON T .Id = PA.ThirdPartyId INNER JOIN
--             GeneralLedger.MainAccounts AS C  ON C.Id = PA.MainAccountId AND C.LegalBookId = '1' LEFT OUTER JOIN
--             Treasury.CashReceipts AS cr  ON cr.Id = PA.CashReceiptId AND cr.CollectType <> '1' AND cr.Status <> '3' AND cr.Status <> '4' AND cr.Code = PA.Code AND PA.Status <> '3' LEFT OUTER JOIN
--             Payroll.CostCenter AS ccos  ON ccos.Id = PA.CostCenterId LEFT OUTER JOIN
--             Treasury.EntityBankAccounts AS eba  ON eba.Id = cr.IdBankAccount LEFT OUTER JOIN
--             Payroll.Bank AS b  ON eba.IdBank = b.Id --LEFT OUTER JOIN
--            -- ReportesMedi.dbo.SucursalRecaudo AS rs  ON rs.nit = t .nit LEFT OUTER JOIN
--                --(SELECT   Anticipo, COALESCE (Neiva, 0) AS Neiva, COALESCE (Florencia, 0) AS Florencia, COALESCE (Tunja, 0) AS Tunja, COALESCE (Pitalito, 0) AS Pitalito
--                --                                                                                                                  FROM      (SELECT   Anticipo, Sucursal, (VrCruce) AS ValorCruce
--                --                                                                                                                                FROM      ReportesMedi.[dbo].[VIE_AD_Portfolio_CruceAnticiposVsCartera] ) Source PIVOT (SUM(SOURCE.ValorCruce) FOR Source.Sucursal IN (Neiva, Florencia, Tunja, 
--                --                                                                                                                                Pitalito)) AS PIVOTABLE) AS Cruce ON Cruce.Anticipo = pa.code
--WHERE   (PA.Status <> '3') AND (C.Number NOT IN ('2120120601', '4101080602', '4101080603', '4101080611', '4101080612', '2501010601')) AND PA.OpeningBalance = '0' AND 
--cr.Code not in ('000009436','000009439')

--SELECT *
--FROM Common.ThirdParty
--where nit='900136603'
