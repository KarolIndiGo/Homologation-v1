-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_CONTRACT_CUPS_HOMOLOGOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_CONTRACT_CUPS_HOMOLOGOS AS

SELECT 
    CUPS.Code AS CUPS, 
    CUPS.Description AS Descripción, 
    SIPS.Code AS CodServicioIPS, 
    SIPS.Name AS DescripciónServicio, 
    CUPS.Status, 
    CASE SIPS.ServiceManual 
        WHEN 1 THEN 'ISS 2001' 
        WHEN 2 THEN 'ISS 2004' 
        WHEN 3 THEN 'SOAT' 
    END AS [Tipo Manual], 
    bc.Code + '-' + bc.Name AS [Concepto Facturación],
    SIPS.UVRNumber AS UVR
FROM INDIGO031.Contract.CUPSEntity AS CUPS
    LEFT OUTER JOIN INDIGO031.Contract.CupsHomologation AS H ON H.CupsEntityId = CUPS.Id
    LEFT OUTER JOIN INDIGO031.Contract.IPSService AS SIPS ON SIPS.Id = H.IPSServiceId
    LEFT OUTER JOIN INDIGO031.Billing.BillingConcept AS bc ON bc.Id = CUPS.BillingConceptId