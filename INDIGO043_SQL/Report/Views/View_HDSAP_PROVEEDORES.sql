-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_PROVEEDORES
-- Extracted by Fabric SQL Extractor SPN v3.9.0






CREATE VIEW [Report].[View_HDSAP_PROVEEDORES]
AS
SELECT distinct
       T.NIT,
       T.Name Proveedor,
	   cd.Code CodigoLineaDistribucion,
	   cd.Name NombreLineaDistribucion,
	   pac.Code CodigoConcepto,
	   pac.Name NombreConcepto,
	   gr.Name ConceptoRetencion,
	   gr.Rate Porcentaje


FROM Common.Supplier CS
JOIN Common.SuppliersDistributionLines SD ON SD.IdSupplier = CS.ID
join Payments.AccountPayable pa on pa.IdSupplier = cs.id
join Common.SupplierType st on st.id = pa.SupplierTypeId
join Common.DistributionLines cd on cd.id = sd.IdDistributionLine
join Common.DistributionLinesDetail dld on dld.DistributionLineId = cd.id
join Payments.AccountPayableConcepts  pac on pac.id = dld.AccountPayableConceptId
join GeneralLedger.RetentionConcepts gr on gr.id = pac.RetentionConceptId
JOIN Common.ThirdParty T ON T.ID = CS.IdThirdParty


