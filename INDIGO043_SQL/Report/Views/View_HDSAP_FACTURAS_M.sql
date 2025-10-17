-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_FACTURAS_M
-- Extracted by Fabric SQL Extractor SPN v3.9.0







CREATE VIEW [Report].[View_HDSAP_FACTURAS_M]
AS

SELECT invoicedate Fecha,
       numingres Ingreso,
       InvoiceNumber NumeroFactura,
       PatientCode DocumentoPaciente,
	   cg.name GrupoAtención,
	   i.InvoicedUser UsuarioCrea,
	   su.NOMUSUARI Usuario,
	   c.name Categoria

FROM BILLING.Invoice i
join adingreso ad on ad.numingres = i.AdmissionNumber
join Security.[user] u on u.usercode = i.InvoicedUser
join INPACIENT pac on pac.IPCODPACI = i.PatientCode
join Contract.CareGroup cg on cg.id = i.CareGroupId
join Billing.InvoiceCategories  c on c.id = i.InvoiceCategoryId
LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = i.InvoicedUser
where i.Status=1 --and i.PatientCode = '1006519007' and i.invoicedate >= '2024-11-20'
