-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: dbo
-- Object: Statistic_GeneralGlosa
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [dbo].[Statistic_GeneralGlosa]
AS
SELECT        T.Nit, T.Name AS Entidad, RC.RadicatedConsecutive AS NroRadicadoGlosa, RC.RadicatedDate AS FechaRadicadoGlosas, 
                         RC.ConfirmDate AS FechaConfirmacionRadicadoGlosas, 
                         CASE WHEN RC.State = 1 THEN 'Sin Confirmar' WHEN RC.State = 2 THEN 'ConfirmadoRadicado' WHEN RC.State = 3 THEN 'OficioConRespuesta' WHEN RC.State = 4
                          THEN 'Anulada' END AS EstadoRadicadoGlosa, CG.InvoiceNumber AS Factura, CG.InvoiceDate AS FechaFactura, CG.InvoiceValueEntity AS ValorEntidad, 
                         CG.BalanceInvoice AS ValorFactura, CG.ValueGlosado AS ValorGlosado, CG.ValueAcceptedFirstInstance AS ValorAceptadoPrimeraInstancia, 
                         CG.ValueReiterated AS ValorReiterado, CG.ValueReiterationBalance AS ValorAceptadoEAPBReiteracion, 
                         CG.ValueAcceptedSecondInstance AS ValorAceptadoSegundaInstancia, CG.ValueAcceptedIPSconciliation AS ValorAceptadoIPSConciliacion, 
                         CG.ValueAcceptedEAPBconciliation AS ValorAceptadoEAPBConciliacion, CG.BalanceGlosa AS SaldoPendienteConciliar, CG.RadicatedNumber AS NroRadicadoERP, 
                         CG.RadicatedDate AS FechaRadicadoERP, CG.AccountantAccountCustomers AS Cuenta
FROM            Glosas.GlosaPortfolioGlosada AS CG INNER JOIN
                         Glosas.GlosaObjectionsReceptionD AS RD ON RD.InvoiceNumber = CG.InvoiceNumber AND RD.DocumentType = '1' INNER JOIN
                         Glosas.GlosaObjectionsReceptionC AS RC ON RC.Id = RD.GlosaObjectionsReceptionCId INNER JOIN
                         Common.Customer AS T ON RC.CustomerId = T.Id



