-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_AD_HC_TotalHistorias_Jersalud
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [ViewInternal].[IND_AD_HC_TotalHistorias_Jersalud] as 
SELECT H.IPCODPACI as Documento, P.IPNOMCOMP AS Paciente , COUNT(numefolio) as TotalFolios
FROM INDIGO031.dbo.HCHISPACA AS H 
JOIN INDIGO031.dbo.INPACIENT AS P ON P.IPCODPACI=H.IPCODPACI
JOIN INDIGO031.dbo.ADCENATEN AS CD ON CD.CODCENATE=H.CODCENATE
where h.IPCODPACI not in ('1234567','9999999') and h.FECHISPAC<='04-30-2024 23:59:59' 
group by H.IPCODPACI,  P.IPNOMCOMP
