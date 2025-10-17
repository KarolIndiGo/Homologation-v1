-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: DWH_HC_Diagnosticos
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[DWH_HC_Diagnosticos]
AS
    
	
	SELECT t2.NUMEFOLIO, 
            t2.NUMINGRES, 
            t2.IPCODPACI, 
            DIAGNOSTICOS = STUFF(
     (
         SELECT '', '' + CODDIAGNO
         FROM dbo.INDIAGNOP t1 
         WHERE t1.NUMINGRES = t2.NUMINGRES FOR XML PATH('')
     ), 1, 1, ''''), 
            NOMBRE_DIAGNOSTICOS = STUFF(
     (
         SELECT '', '' + LTRIM(RTRIM(NOMDIAGNO))
         FROM dbo.INDIAGNOP AS T1 
              INNER JOIN dbo.INDIAGNOS AS B  ON B.CODDIAGNO = T1.CODDIAGNO
         WHERE t1.NUMINGRES = t2.NUMINGRES FOR XML PATH('')
     ), 1, 1, '''')
     FROM dbo.INDIAGNOP t2 
     WHERE t2.FECDIAGNO >= DATEADD(MONTH, -6, GETDATE())
     GROUP BY t2.NUMEFOLIO, 
              t2.NUMINGRES, 
              t2.IPCODPACI
