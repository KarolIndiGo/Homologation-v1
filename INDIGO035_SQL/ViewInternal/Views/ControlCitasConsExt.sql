-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: ControlCitasConsExt
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[ControlCitasConsExt] AS
SELECT
CASE WHEN c.codcenate IN ( '001') THEN 'Sucursal Neiva'  WHEN c.codcenate IN ( '002') THEN 'Sucursal Pitalito' 
 END AS SEDE,  c.CODCENATE,
act.DESACTMED as Actividad,
ESP.DESESPECI as Especialidad,
pro.NOMMEDICO as Profesional,
case  c.CODTIPCIT when 0 then 'Primera Vez'  when 1 then 'Control' when 2 then 'Pos Operatorio' when 3 then 'Cita Web' end as TipoCita,
c.FECHORAIN as FechaInicial_Cita,
c.FECHORAFI as FechaFinal_Cita,
ing.IFECHAING as FechaIngresO,
case  f.CONESTADO when 1 then 'Sin Atender' when 2 then 'Ausente/Anulada' when 3 then 'Atendido' when 4 then 'En Sala' when 5 then 'En Consultorio' end as Estado,
f.FECENCONSULTORIO as FechaEnConsultorio
,f.FECCITACUMPLIDA as FechaCumplidaCita,
CASE WHEN datediff(minute, ing.IFECHAING,c.FECHORAIN) <0 THEN '0'
Else datediff(minute, ing.IFECHAING,c.FECHORAIN) end as [Dif Fecha Ingreso - Fecha Inicial Cita (min)],
CASE WHEN datediff(minute,c.FECHORAIN,f.FECENCONSULTORIO) <0 THEN '0'
Else datediff(minute,c.FECHORAIN,f.FECENCONSULTORIO) end as [Dif Fecha Inicial Cita - Fecha Consultorio (min)],
CASE WHEN datediff(minute,f.FECENCONSULTORIO,f.FECCITACUMPLIDA) <0 THEN '0'
Else datediff(minute,f.FECENCONSULTORIO,f.FECCITACUMPLIDA) end as [Dif Fecha Consultorio - Fecha Cita Cumplida (min)], f.IPCODPACI as Identificacion, Ing.NUMINGRES AS Ingreso,
	g.CODUSUARI as				 CodUsuAsigna,
	ltrim(rtrim(G.NOMUSUARI)) AS Usuario_Asigna

from INDIGO035.DBO.AGASICITA c with (nolock) inner join 
INDIGO035.DBO.ADCONCOEX f with (nolock) on c.CODAUTONU = f.NUMCONCIT inner join 
INDIGO035.DBO.AGACTIMED act with (nolock) on c.CODACTMED =  act.CODACTMED inner join
INDIGO035.DBO.HCHISPACA his with (nolock) on his.ID = f.IDHCHISPACA  inner join 
INDIGO035.DBO.ADINGRESO Ing with (nolock) on His.NUMINGRES = Ing.NUMINGRES inner join
INDIGO035.DBO.INESPECIA ESP with (nolock) on Esp.CODESPECI = his.CODESPTRA  inner join 
INDIGO035.DBO.INPROFSAL PRO with (nolock) ON PRO.CODPROSAL=C.CODPROSAL inner join 
INDIGO035.DBO.ADCENATEN CEN with (nolock) ON CEN.CODCENATE=C.CODCENATE 	LEFT OUTER JOIN 
INDIGO035.dbo.SEGusuaru AS G  WITH (NOLOCK) ON G.CODUSUARI = C.CODUSUASI 

where 
 c.CODESTCIT = 1 and His.ESTAFOLIO = 1 and His.GENCONEXT =1 and year(His.FECHISPAC) >='2024' 
