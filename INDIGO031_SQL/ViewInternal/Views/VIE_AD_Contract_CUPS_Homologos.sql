-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Contract_CUPS_Homologos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Contract_CUPS_Homologos]
AS
SELECT CUPS.Code AS CUPS, CUPS.Description AS Descripción, SIPS.Code AS CodServicioIPS, 
SIPS.Name AS DescripciónServicio, CUPS.Status, 
CASE sips.servicemanual WHEN 1 THEN 'ISS 2001' WHEN 2 THEN 'ISS 2004' WHEN 3 THEN 'SOAT' END AS [Tipo Manual], 
bc.Code + '-' + bc.Name AS [Concepto Facturación],
SIPS.uvrnumber as UVR
FROM   Contract.CUPSEntity AS CUPS LEFT OUTER JOIN
       Contract.CupsHomologation AS H ON H.CupsEntityId = CUPS.Id LEFT OUTER JOIN
       Contract.IPSService AS SIPS ON SIPS.Id = H.IPSServiceId LEFT OUTER JOIN
       Billing.BillingConcept AS bc ON bc.Id = CUPS.BillingConceptId

