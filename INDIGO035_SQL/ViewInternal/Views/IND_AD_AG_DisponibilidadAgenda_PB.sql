-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_AD_AG_DisponibilidadAgenda_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

create VIEW [ViewInternal].[IND_AD_AG_DisponibilidadAgenda_PB] as

SELECT SUBSTRING (SEDE,10,15) as Sede , CodEsp, Especialidad, FechaAgenda, GETDATE() as Actual, DATEDIFF(day, CONVERT(DATE,GETDATE()), 
CONVERT(DATE,FechaAgenda)) as DiasTotal, Regional  , ViewInternal.[CalcularFechaConDiasFestivosYDomingosPB](CONVERT(DATE,GETDATE()), CONVERT(DATE,FechaAgenda)) AS Oportunidad
FROM (
SELECT min(FechaIni_Agenda) as FechaAgenda, Sede,  CodEsp, Especialidad, Regional
FROM ViewInternal.IND_AD_AG_OportunidadAgenda_PB 
where   CONVERT(DATE,FechaIni_Agenda)>=CONVERT(DATE,GETDATE()) and Estado_Agenda='Activa'-- and especialidad='NUTRICION CLINICA' AND SEDE='JERSALUD DUITAMA'
GROUP BY SEDE, ESPECIALIDAD,CodEsp, Regional) AS A 
