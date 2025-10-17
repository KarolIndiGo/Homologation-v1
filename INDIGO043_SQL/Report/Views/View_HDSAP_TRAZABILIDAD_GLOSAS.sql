-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_TRAZABILIDAD_GLOSAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0






-- =============================================
-- Author:      Miguel Angle Ruiz Vega
-- Create date: 2025-01-31 10:51:38
-- Database:    INDIGO043
-- Description: Reporte Cuentas Medicas Trazabilidad
-- =============================================



CREATE VIEW [Report].[View_HDSAP_TRAZABILIDAD_GLOSAS]
AS
SELECT 
    i.InvoiceDate FECHA,
	HL.Name ENTIDAD,
	T.NIT,
    d.InvoiceNumber  AS [NUMERO DE FACTURA],
    FORMAT(ADI.IFECHAING, 'dd/MM/yyyy') AS [FECHA DE PRESTACION DEL SERVICIO],

    FORMAT(
        (SELECT MIN(c2.RadicatedDate)
         FROM Portfolio.RadicateInvoiceC c2
         JOIN Portfolio.RadicateInvoiceD d2 ON c2.Id = d2.RadicateInvoiceCId
         WHERE d2.InvoiceNumber = d.InvoiceNumber
        ),
    'dd/MM/yyyy') AS [FECHA RADICACION DE LA FACTURA ANTE EL RESPONSABLE DEL PAGO],
    FORMAT(
        MIN(
            CASE 
                WHEN grc.[State] = 2 THEN grc.RadicatedDate
                WHEN grc.[State] = 4 THEN gc.RadicatedDate
            END
        ), 'dd/MM/yyyy'
    ) AS [FECHA DE RADICACION DE LA GLOSA O DEVOLUCIÓN ANTE EL PRESTADOR DEL SERVICIO DE SALUD],
	 FORMAT(MIN(grc.DocumentDate), 'dd/MM/yyyy') AS [FECHA DE RADICACION RESPUESTA A GLOSA O DEVOLUCIÓN ANTE EL RESPONSABLE DEL PAGO ],
	 FORMAT(
        MIN(
            CASE 
                WHEN grD.DocumentType = 2 THEN grc.RadicatedDate
            END
        ), 'dd/MM/yyyy'
    ) AS [FECHA DE RADICACIÓN  DE LA RATIFICACIÓN  DE LA GLOSA O DEVOLUCIÓN ANTE EL PRESTADOR DEL SERVICIO DE SALUD],
	 GM.CodeGlosa AS [CODIGO ESPECÍFICO DE LA GLOSA],
	 UPPER(COALESCE(GM.RationaleGlosa, GDD.Comment)) AS [MOTIVO DE GLOSA O DEVOLUCIÓN],
	 UPPER(GM.JustificationGlosaText )[RESPUESTA A GLOSA O DEVOLUCIÓN POR PARTE DEL PRESTADOR DEL SERVICIO DE SALUD POR ÍTEM],
	 FORMAT(I.TotalInvoice, 'C', 'es-CO')  [VALOR DE LA FACTURA SOLICITADO POR EL DEMANDANTE],
	 GM.ValueGlosado [VALOR GLOSADO POR ÍTEM POR PARTE DEL RESPONSABLE DEL PAGO],
	 FORMAT(gp.ValueGlosado, 'C', 'es-CO') [TOTAL VALOR GLOSADO POR PARTE DEL POR PARTE DEL RESPONSABLE DEL PAGO],
	 gp.ValueAcceptedFirstInstance [VALOR POR ÍTEM ACEPTADO POR EL  PRESTADOR DEL SERVICIO DE SALUD EN RESPUESTA A GLOSA O DEVOLUCIÓN],
	 gp.ValueReiterated [VALOR POR ÍTEM GLOSADO  REITERADO POR EL RESPONSABLE DEL PAGO]

FROM Portfolio.RadicateInvoiceD d
JOIN Portfolio.RadicateInvoiceC c ON c.Id = d.RadicateInvoiceCId
LEFT JOIN Glosas.GlosaDevolutionsReceptionD gd ON gd.InvoiceNumber = d.InvoiceNumber
LEFT JOIN Glosas.GlosaDevolutionsReceptionC gc ON gc.Id = gd.GlosaDevolutionsReceptionCId
LEFT JOIN Glosas.GlosaObjectionsReceptionD grd ON grd.InvoiceNumber = d.InvoiceNumber
LEFT JOIN Glosas.GlosaObjectionsReceptionC grc ON grc.Id = grd.GlosaObjectionsReceptionCId
LEFT JOIN Billing.Invoice i ON i.InvoiceNumber = d.InvoiceNumber
LEFT JOIN Glosas.GlosaMovementDevolutions GDD ON GDD.IdDevolutionsReceptionD = GD.ID
LEFT JOIN Common.ConceptGlosas AS CG WITH (nolock) ON CG.Id = GDD.IdConceptGlosa 
LEFT JOIN Glosas.GlosaMovementGlosa GM ON GM.InvoiceNumber = GRD.InvoiceNumber
LEFT JOIN Common.ConceptGlosas AS CG1 WITH (nolock) ON CG1.Id = GM.CodeGlosaId
LEFT JOIN glosas.GlosaPortfolioGlosada gp on gp.InvoiceNumber = gm.InvoiceNumber
LEFT JOIN Contract.HealthAdministrator HL ON HL.Id = I.HealthAdministratorId
LEFT JOIN Common.ThirdParty T ON T.ID = HL.ThirdPartyId
LEFT JOIN ADINGRESO ADI ON ADI.NUMINGRES = I.AdmissionNumber

--WHERE d.InvoiceNumber = 'HSPE696219'
GROUP BY
    d.InvoiceNumber, 
    i.OutputDate,
	CG.Code,
	grd.Comment, 
	GDD.Comment,
	i.InvoiceDate,
	GM.JustificationGlosaText,	
	GM.ValueGlosado,
	gp.ValueGlosado,
	gp.ValueAcceptedFirstInstance,
	gp.ValueReiterated,
	HL.Name,
	T.NIT,
	ADI.IFECHAING,
	GM.CodeGlosa,
	GM.RationaleGlosa,
	I.TotalInvoice;



