-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: dbo
-- Object: Statistic_DetailGlosaXConcept
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [dbo].[Statistic_DetailGlosaXConcept]
AS
SELECT     CO.Code AS CodigoConceptoGeneral, CO.NameGeneral AS DescripcionConceptoGeneral, CO.NameSpecific AS DescripcionConceptoEspecifico, 
                      DG.RationaleGlosa AS Comentario, DG.InvoiceNumber AS NroFactura, G.InvoiceDate AS FechaFactura, C.Nit, C.Name AS Entidad, DE.CostCenterCode AS CC, 
                      DE.CostCenterName AS NombreCentro, DG.ValueGlosado AS ValorGlosado, COALESCE (ISNULL(DG.ValueAcceptedFirstInstance, 0), 0) AS ValorAceptadoGlosaInicial, 
                      COALESCE (ISNULL(DG.ValueReiterated, 0), 0) AS ValorReiterado, COALESCE (ISNULL(DG.ValueReiterationBalance, 0), 0) AS ValorAceptadoEAPBReiteracion, 
                      COALESCE (ISNULL(DG.ValueAcceptedSecondInstance, 0), 0) AS ValorAceptadoReiteracion, COALESCE (ISNULL(DG.ValueAcceptedIPSconciliation, 0), 0) 
                      AS ValorAceptadoIPSConciliacion, COALESCE (ISNULL(DG.ValueAcceptedEAPBconciliation, 0), 0) AS ValorAceptadoEAPBConciliacion, 
                      COALESCE (ISNULL(DG.ValuePendingConciliation, 0), 0) AS ValorPendienteConciliar, G.InvoiceValueEntity AS ValorFactura, RTRIM(DE.ServiceCode) 
                      + RTRIM(DE.ServiceName) AS Servicio, DE.MedicalCode AS CodMedico, DE.MedicalName AS Medico, G.RadicatedNumber AS RadicadoERP, 
                      G.RadicatedDate AS FechaRadicadoERP, GC.RadicatedDate AS FechaRecepcionObjecion, DE.BillerCode AS Codfacturador, DE.BillerName AS Facturador, 
                      CASE WHEN DE.TypeServiceProduct = 1 THEN 'Servicio' WHEN DE.TypeServiceProduct = 2 THEN 'Medicamento o Insumo' END AS TipoServicio, 
                      CASE WHEN DE.TypeProcedure = 1 THEN 'No quirurgico' WHEN DE.TypeProcedure = 2 THEN 'Quirurgico' WHEN DE.TypeProcedure = 3 THEN 'Paquete' WHEN DE.TypeProcedure
                       = 4 THEN 'NoAplica' END AS TipoProcedimiento, DG.JustificationGlosaText AS Respuesta
FROM         Glosas.GlosaMovementGlosa AS DG INNER JOIN
                      Glosas.GlosaPortfolioGlosada AS G ON DG.InvoiceNumber = G.InvoiceNumber INNER JOIN
                      Glosas.GlosaObjectionsReceptionD AS RG ON G.Id = RG.PortfolioGlosaId AND RG.DocumentType = '1' INNER JOIN
                      Glosas.GlosaObjectionsReceptionC AS GC ON RG.GlosaObjectionsReceptionCId = GC.Id INNER JOIN
                      Common.Customer AS C ON GC.CustomerId = C.Id INNER JOIN
                      Common.ConceptGlosas AS CO ON DG.CodeGlosaId = CO.Id INNER JOIN
                      Glosas.GlosaInvoiceDetail AS DE ON DG.InvoiceDetailId = DE.Id
WHERE     (DG.MainGlosa = 1)



