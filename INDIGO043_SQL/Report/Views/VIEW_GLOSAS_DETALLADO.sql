-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: VIEW_GLOSAS_DETALLADO
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [Report].[VIEW_GLOSAS_DETALLADO]  
AS  
  
SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
       CAST(G.RadicatedDate as date) RadicatedDate,   
       Co.Code AS 'Codigo Concepto General',   
       CO.NameGeneral AS 'Concepto General',   
       CO.NameSpecific AS 'Concepto Especifico',   
       DG.RationaleGlosa AS Comentario,   
       DG.InvoiceNumber AS 'N° Factura',   
       G.PatientCode AS 'Identificacion',   
       G.IngressNumber AS 'Ingreso',   
       G.IngressDate AS 'Fecha Ingreso',   
       G.InvoiceDate AS 'Fecha Factura',   
       C.Nit,   
       C.Name AS Entidad,   
       RTRIM(DE.CostCenterCode) + ' - ' + RTRIM(DE.CostCenterName) AS CC,   
       DG.ValueGlosado AS 'Valor Glosado',   
       COALESCE(ISNULL(DG.ValueAcceptedFirstInstance, 0), 0) AS 'Valor Aceptado 1a Instancia',   
       COALESCE(ISNULL(DG.ValueReiterated, 0), 0) AS 'Valor Reiterado',   
       COALESCE(ISNULL(DG.ValueReiterationBalance, 0), 0) AS 'Valor Aceptado EAPB Reiteracion',   
       COALESCE(ISNULL(DG.ValueAcceptedSecondInstance, 0), 0) AS 'Valor Aceptado 2a Instancia',   
       COALESCE(ISNULL(DG.ValueAcceptedIPSconciliation, 0), 0) AS 'Valor Aceptado IPS Conciliacion',   
       COALESCE(ISNULL(DG.ValueAcceptedEAPBconciliation, 0), 0) AS 'Valor Aceptado EAPB Conciliacion',   
       COALESCE(ISNULL(DG.ValuePendingConciliation, 0), 0) AS 'Valor Pendiente',   
       G.InvoiceValueEntity AS 'Valor Factura',   
       RTRIM(DE.ServiceCode) + ' - ' + RTRIM(DE.ServiceName) AS Servicio,   
       RTRIM(DE.MedicalCode) + ' - ' + RTRIM(DE.MedicalName) AS Medico,   
    INE.DESESPECI AS Especialidad,  
       G.RadicatedNumber AS 'Radicado ERP',   
       G.RadicatedDate AS 'F. Radicado ERP',   
       GC.RadicatedConsecutive AS 'Numero radicado',   
       gc.documentdate AS 'F. Oficio Glosa',   
       GC.RadicatedDate AS 'F_Recepcion_Objecion',   
       gc.ConfirmDate AS 'F. Confirmacion Recepcion',   
       gc.DateResponsePostDocument AS 'F. Envio Respuesta',   
       gc.DateRadicatedDocumentReply AS F_Radicacion_Respuesta,  
  
       /**.........**/  
  
       ccg.ConciliationConsecutive AS 'Numero Conciliacion',   
       dg.RationaleDateConciliation AS 'F. Conciliacion',   
       ccg.ConfirmDate AS FechaConfirmacionConciliacion,  
       --RTRIM(DE.BillerCode) + ' - ' + RTRIM(DE.BillerName) AS Facturador,  
       (CASE  
            WHEN usr.UserCode IS NULL  
            THEN RTRIM(DE.BillerCode) + ' - ' + RTRIM(DE.BillerName)  
            ELSE RTRIM(usr.UserCode) + ' - ' + RTRIM(prs.Fullname)  
        END) AS 'FACTURADOR',  
       --RTRIM( usr.UserCode)+ ' - ' + RTRIM(prs.Fullname) AS Facturador,  
       --RTRIM(DE.BillerCode) + ' - ' + RTRIM(DE.BillerName) AS Facturador2,  
       /**********************/  
  
       CASE  
           WHEN DE.TypeServiceProduct = 1  
           THEN 'Servicio'  
           WHEN DE.TypeServiceProduct = 2  
           THEN 'Medicamento o Insumo'  
       END AS 'Tipo Servicio',  
       CASE  
           WHEN DE.TypeProcedure = 1  
           THEN 'No quirurgico'  
           WHEN DE.TypeProcedure = 2  
           THEN 'Quirurgico'  
           WHEN DE.TypeProcedure = 3  
           THEN 'Paquete'  
           WHEN DE.TypeProcedure = 4  
           THEN 'NoAplica'  
       END AS 'Tipo Procedimiento',   
       DG.JustificationGlosaText AS Respuesta,   
       G.ContractCode AS Contrato,  
       CASE ham.EntityType  
           WHEN 1  
           THEN 'EPS Contributivo'  
           WHEN 2  
           THEN 'EPS Subsidiado'  
           WHEN 3  
           THEN 'ET Vinculados Municipios'  
           WHEN 4  
           THEN 'ET Vinculados Departamentos'  
           WHEN 5  
           THEN 'ARL Riesgos Laborales'  
           WHEN 6  
           THEN 'MP Medicina Prepagada'  
           WHEN 7  
           THEN 'IPS Privada'  
           WHEN 8  
           THEN 'IPS Publica'  
           WHEN 9  
           THEN 'Regimen Especial'  
           WHEN 10  
           THEN 'Accidentes de transito'  
           WHEN 11  
           THEN 'Fosyga'  
           WHEN 12  
           THEN 'Otros'  
       END AS 'Tipo de entidad',   
       --acr.Balance AS SaldoCartera,   
       BVR.InvoiceCategory AS 'CATEGORIA CONTRATO',  
    g.EvaluationDateGlosa as FechaEvaluacionGlosa,  
    G.EvaluationDateReiteration as FechaEvaluacionReiteracion,  
	1 as 'CANTIDAD',
  CAST(gc.DateRadicatedDocumentReply AS date) AS 'FECHA BUSQUEDA',
  YEAR(gc.DateRadicatedDocumentReply) AS 'AÑO BUSQUEDA',
  MONTH(gc.DateRadicatedDocumentReply) AS 'MES BUSQUEDA',
  CONCAT(FORMAT(MONTH(gc.DateRadicatedDocumentReply), '00') ,' - ', 
	   CASE MONTH(gc.DateRadicatedDocumentReply) 
	    WHEN 1 THEN 'ENERO'
   	    WHEN 2 THEN 'FEBRERO'
	    WHEN 3 THEN 'MARZO'
	    WHEN 4 THEN 'ABRIL'
	    WHEN 5 THEN 'MAYO'
	    WHEN 6 THEN 'JUNIO'
	    WHEN 7 THEN 'JULIO'
	    WHEN 8 THEN 'AGOSTO'
	    WHEN 9 THEN 'SEPTIEMBRE'
	    WHEN 10 THEN 'OCTUBRE'
	    WHEN 11 THEN 'NOVIEMBRE'
	    WHEN 12 THEN 'DICIEMBRE' END) 'MES NOMBRE BUSQUEDA',
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL

FROM Glosas.GlosaMovementGlosa AS DG  
     INNER JOIN Glosas.GlosaPortfolioGlosada AS G ON DG.InvoiceNumber = G.InvoiceNumber  
     INNER JOIN Glosas.GlosaObjectionsReceptionD AS RG ON G.Id = RG.PortfolioGlosaId  
                                                                AND RG.DocumentType = '1'  
     INNER JOIN Glosas.GlosaObjectionsReceptionC AS GC ON RG.GlosaObjectionsReceptionCId = GC.Id  
     INNER JOIN Common.Customer AS C ON GC.CustomerId = C.Id  
     INNER JOIN Common.ConceptGlosas AS CO ON DG.CodeGlosaId = CO.Id  
     INNER JOIN Glosas.GlosaInvoiceDetail AS DE ON DG.InvoiceDetailId = DE.Id  
     LEFT OUTER JOIN GLOSAS.ConciliationD AS CDG ON g.InvoiceNumber = cdg.InvoiceNumber  
     LEFT OUTER JOIN glosas.ConciliationC AS CCG ON ccg.id = cdg.ConciliationCId  
     LEFT OUTER JOIN Billing.Invoice AS inv ON inv.InvoiceNumber = DG.InvoiceNumber  
     LEFT OUTER JOIN Security.[User] AS usr ON usr.UserCode = inv.InvoicedUser  
  LEFT JOIN DBO.INPROFSAL AS INP ON INP.CODPROSAL = DE.MedicalCode  
  LEFT join DBO.INESPECIA AS INE ON INE.CODESPECI = INP.CODESPEC1  
     LEFT OUTER JOIN Security.Person AS prs ON usr.IdPerson = prs.Id  
     LEFT JOIN Contract.HealthAdministrator AS ham ON ham.Id = inv.HealthAdministratorId  
     LEFT JOIN Billing.VReportInvoice AS BVR ON DG.InvoiceNumber = BVR.InvoiceNumber  

