-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_DWH_HC_DIAGNOSTICOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_DWH_HC_DIAGNOSTICOS 
AS
SELECT 
    t2.NUMEFOLIO, 
    t2.NUMINGRES, 
    t2.IPCODPACI,

    -- Concatenación de códigos de diagnóstico
    (
        SELECT STRING_AGG(t1.CODDIAGNO, ', ')
        FROM [INDIGO031].[dbo].[INDIAGNOP] t1
        WHERE t1.NUMINGRES = t2.NUMINGRES
    ) AS DIAGNOSTICOS,

    -- Concatenación de nombres de diagnóstico
    (
        SELECT STRING_AGG(LTRIM(RTRIM(b.NOMDIAGNO)), ', ')
        FROM [INDIGO031].[dbo].[INDIAGNOP] t1
        INNER JOIN [INDIGO031].[dbo].[INDIAGNOS] b ON b.CODDIAGNO = t1.CODDIAGNO
        WHERE t1.NUMINGRES = t2.NUMINGRES
    ) AS NOMBRE_DIAGNOSTICOS

FROM [INDIGO031].[dbo].[INDIAGNOP] t2
WHERE t2.FECDIAGNO >= DATEADD(MONTH, -6, GETDATE())
GROUP BY 
    t2.NUMEFOLIO, 
    t2.NUMINGRES, 
    t2.IPCODPACI;
