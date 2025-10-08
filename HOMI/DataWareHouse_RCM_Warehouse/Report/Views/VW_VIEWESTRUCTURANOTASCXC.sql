-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: VW_VIEWESTRUCTURANOTASCXC
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [Report].[VW_VIEWESTRUCTURANOTASCXC] as

WITH 
CTE_MEDICAMENTOS AS
(
select PA.Id,SUM(FACD.TotalSalesPrice) AS VALOR
FROM
INDIGO036.Portfolio.AccountReceivable PA INNER JOIN
INDIGO036.Billing.Invoice FAC ON PA.InvoiceId=FAC.Id INNER JOIN
INDIGO036.Billing.InvoiceDetail FACD ON FAC.Id=FACD.InvoiceId INNER JOIN
INDIGO036.Billing.ServiceOrderDetail SOD ON FACD.ServiceOrderDetailId=SOD.Id INNER JOIN
INDIGO036.Contract.CUPSEntity CUPS ON SOD.CUPSEntityId=CUPS.Id AND RIPSConcept in ('9','12','13')
GROUP BY PA.Id
),
CTE_PRESTACIONES AS
(
select PA.Id,SUM(FACD.TotalSalesPrice) AS VALOR
FROM
INDIGO036.Portfolio.AccountReceivable PA INNER JOIN
INDIGO036.Billing.Invoice FAC ON PA.InvoiceId=FAC.Id INNER JOIN
INDIGO036.Billing.InvoiceDetail FACD ON FAC.Id=FACD.InvoiceId INNER JOIN
INDIGO036.Billing.ServiceOrderDetail SOD ON FACD.ServiceOrderDetailId=SOD.Id INNER JOIN
INDIGO036.Contract.CUPSEntity CUPS ON SOD.CUPSEntityId=CUPS.Id AND RIPSConcept NOT in ('9','12','13')
GROUP BY PA.Id
),
CTE_IVA AS (
select PND.PortfolioNoteId, SUM(PND.Value)AS IVA,PNC.Code
from 
INDIGO036.Portfolio.PortfolioNoteDetail PND INNER JOIN
INDIGO036.Portfolio.PortfolioNoteConcept PNC ON PND.PortfolioNoteConceptId=PNC.Id AND Name LIKE '%IVA GENERA%'
GROUP BY PortfolioNoteId,PNC.Code
),
CTE_ICA AS (
select PND.PortfolioNoteId, SUM(PND.Value)AS ICA,PNC.Code
from 
INDIGO036.Portfolio.PortfolioNoteDetail PND INNER JOIN
INDIGO036.Portfolio.PortfolioNoteConcept PNC ON PND.PortfolioNoteConceptId=PNC.Id AND Name LIKE '%ICA%'
GROUP BY PortfolioNoteId,PNC.Code
),
CTE_RETE_IVA AS (
select PND.PortfolioNoteId, SUM(PND.Value)AS IVA,PNC.Code
from 
INDIGO036.Portfolio.PortfolioNoteDetail PND INNER JOIN
INDIGO036.Portfolio.PortfolioNoteConcept PNC ON PND.PortfolioNoteConceptId=PNC.Id AND Name LIKE '%RETENCION DE IVA%'
GROUP BY PortfolioNoteId,PNC.Code
),
CTE_TOTAL AS
(
select PortfolioNoteId, sum(Value)as TOTAL from INDIGO036.Portfolio.PortfolioNoteDetail 
group by PortfolioNoteId
)
select 
N.Code as [NUM],
CASE N.Nature WHEN 1 THEN 'CC'
			  WHEN 2 THEN 'DC' END as [TIP],
'899999123-7' AS EPM,
NC.Code AS CODCON,
CLI.Nit AS IDEPER,
CLI.EPSCode AS MINCOD,
ND.Value AS VAL,
CLI.Name AS NOMCLI,
N.ConfirmationDate AS FECNOT,
N.Status AS EST,
CEC.Code AS CENCOS,
AR.InvoiceNumber AS REFCON,
CASE N.NoteType WHEN 1 THEN 'Factura Total'
				WHEN 2 THEN 'Factura Cuota'
				WHEN 3 THEN 'Anticipo'
				WHEN 4 THEN 'Distribucion de Anticipo'END AS DETCON,
N.Observations AS OBS,
USUC.NOMUSUARI AS USUCRE,
N.CreationDate AS FECCRE,
USUM.NOMUSUARI AS USUMOD,
N.ModificationDate AS FECMOD,
MED.VALOR AS VALMAT,
PRE.VALOR AS VALDES,
IVA.IVA AS VALIVA,
'' AS VALRET,
IVA.Code AS CODIVA,
'' AS CODRETFUE,
ICA.ICA AS VALRETICA,
ICA.Code AS CODRETICA,
RIVA.Code AS CODRETIVA,
RIVA.IVA AS VALRETIVA,
ANT.Value AS VALANT,
CASE N.NoteType WHEN 1 THEN 'Factura Total'
				WHEN 2 THEN 'Factura Cuota'
				WHEN 3 THEN 'Anticipo'
				WHEN 4 THEN 'Distribucion de Anticipo'END AS DESREF1,
TOT.TOTAL AS VALABO
from 
INDIGO036.Portfolio.PortfolioNote N INNER JOIN
INDIGO036.Portfolio.PortfolioNoteDetail ND ON N.Id=ND.PortfolioNoteId AND ND.RetentionConceptId IS NULL INNER JOIN
INDIGO036.Portfolio.PortfolioNoteAccountReceivableAdvance PNARA ON N.Id=PNARA.PortfolioNoteId INNER JOIN
CTE_TOTAL TOT ON N.Id=TOT.PortfolioNoteId INNER JOIN
INDIGO036.Portfolio.AccountReceivable AR ON PNARA.AccountReceivableId=AR.Id LEFT JOIN
CTE_MEDICAMENTOS MED ON AR.Id=MED.Id LEFT JOIN
CTE_PRESTACIONES PRE ON AR.Id=PRE.Id LEFT JOIN
INDIGO036.Portfolio.PortfolioNoteConcept NC ON ND.PortfolioNoteConceptId=NC.Id LEFT JOIN
CTE_IVA IVA ON N.Id=IVA.PortfolioNoteId LEFT JOIN
CTE_ICA ICA ON N.Id=ICA.PortfolioNoteId LEFT JOIN 
CTE_RETE_IVA RIVA ON N.Id=RIVA.PortfolioNoteId LEFT JOIN
INDIGO036.Common.Customer CLI ON N.CustomerId=CLI.Id LEFT JOIN
INDIGO036.Payroll.CostCenter CEC ON ND.CostCenterId=CEC.Id LEFT JOIN
INDIGO036.dbo.SEGusuaru USUC ON N.CreationUser=USUC.CODUSUARI LEFT JOIN
INDIGO036.dbo.SEGusuaru USUM ON N.ModificationUser=USUM.CODUSUARI LEFT JOIN
INDIGO036.Portfolio.PortfolioAdvance ANT ON N.PortfolioAdvanceId=ANT.Id


