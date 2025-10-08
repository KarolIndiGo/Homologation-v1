-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_AD_AG_DISPONIBILIDADAGENDA_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_AD_AG_DISPONIBILIDADAGENDA_PB 
as

SELECT SUBSTRING (Sede,10,20) as Sede 
    , CodEsp
    , Especialidad
    , FechaAgenda
    , GETDATE() as Actual
    , DATEDIFF(day, CONVERT(DATE,GETDATE())
    , CONVERT(DATE,FechaAgenda)) as DiasTotal
    , Regional  
    , INDIGO031.ViewInternal.CalcularFechaConDiasFestivosYDomingosPB(CONVERT(DATE,GETDATE()), CONVERT(DATE,FechaAgenda)) AS Oportunidad
FROM (
    SELECT min(FechaIni_Agenda) as FechaAgenda
    , Sede
    , CodEsp
    , Especialidad
    , Regional
FROM [DataWareHouse_Clinical].[ViewInternal].[VW_IND_AD_AG_OPORTUNIDADAGENDA_PB]  
where   CONVERT(DATE,FechaIni_Agenda)>=CONVERT(DATE,GETDATE()) and Estado_Agenda='Activa'-- and especialidad='NUTRICION CLINICA' AND SEDE='JERSALUD DUITAMA'
GROUP BY Sede, Especialidad,CodEsp, Regional) AS A  
