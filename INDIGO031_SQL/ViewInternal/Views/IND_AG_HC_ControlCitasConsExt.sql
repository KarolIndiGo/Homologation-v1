-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_AG_HC_ControlCitasConsExt
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_AG_HC_ControlCitasConsExt] AS
SELECT 
CASE 
WHEN HIS.ufucodigo like 'MET%' THEN 'Meta' 
WHEN HIS.ufucodigo  in ('CAS100','CAS001','CAS002','CAS003','CAS004','YOP001','YOP002','MYO001') THEN 'CASanare' 
WHEN HIS.ufucodigo like 'BOY%' THEN 'Boyaca' 
WHEN HIS.ufucodigo like 'B0%' THEN 'Boyaca'  
WHEN HIS.ufucodigo  in ('MTU001','MTU101') THEN 'Boyaca'
WHEN HIS.ufucodigo  in ('MVI001') THEN 'Meta' 
end AS Regional, 
CASE
WHEN C.CODCENATE = '001' THEN 'BOGOTA'                                                                                     
WHEN C.CODCENATE = '002' THEN 'TUNJA'                                                                                      
WHEN C.CODCENATE = '003' THEN 'DUITAMA'                                                                                    
WHEN C.CODCENATE = '004' THEN 'SOGAMOSO'                                                                                   
WHEN C.CODCENATE = '005' THEN 'CHIQUINQUIRA'                                                                               
WHEN C.CODCENATE = '006' THEN 'GARAGOA'                                                                                    
WHEN C.CODCENATE = '007' THEN 'GUATEQUE'                                                                                   
WHEN C.CODCENATE = '008' THEN 'SOATA'                                                                                      
WHEN C.CODCENATE = '009' THEN 'MONIQUIRA'                                                                                  
WHEN C.CODCENATE = '010' THEN 'VILLAVICENCIO'                                                                              
WHEN C.CODCENATE = '011' THEN 'ACACIAS'                                                                                    
WHEN C.CODCENATE = '012' THEN 'GRANADA'                                                                                    
WHEN C.CODCENATE = '013' THEN 'PUERTO LOPEZ'                                                                               
WHEN C.CODCENATE = '014' THEN 'PUERTO GAITAN'                                                                              
WHEN C.CODCENATE = '015' THEN 'YOPAL'                                                                                      
WHEN C.CODCENATE = '016' THEN 'VILLANUEVA'                                                                                 
WHEN C.CODCENATE = '017' THEN 'PUERTO BOYACA'                                                                              
WHEN C.CODCENATE = '999' THEN 'NUEVO CENTRO'
END AS Sede,   C.CODCENATE,
ACT.DESACTMED AS Actividad,
ESP.DESESPECI AS Especialidad,
C.CODPROSAL	  AS CodProfesional,
LTRIM(RTRIM(PRO.MEDPRINOM)) +' '+ LTRIM(RTRIM(PRO.MEDPRIAPEL)) AS Profesional,
cASe  C.CODTIPCIT WHEN 0 THEN 'Primera Vez'  WHEN 1 THEN 'Control' WHEN 2 THEN 'Pos Operatorio' WHEN 3 THEN 'Cita Web' END AS TipoCita,
cASe  F.CONESTADO WHEN 1 THEN 'Sin Atender' WHEN 2 THEN 'Ausente/Anulada' WHEN 3 THEN 'Atendido' WHEN 4 THEN 'En Sala' WHEN 5 THEN 'En Consultorio' END AS Estado,
ING.IFECHAING	AS FechaIngreso,
C.FECHORAIN		AS FechaInicial_Cita,
C.FECHORAFI		AS FechaFinal_Cita,
HU.FECHINIHI	AS FechaInicialAtencion,
HIS.FECHISPAC	AS FechaFinalAtencion,
F.FECCITACUMPLIDA AS FechaCumplidaCita,
datediff(minute,c.FECHORAIN,hu.FECHINIHI)	AS [Dif Fecha Inicial Cita - Fecha Inicial Atencion (min)],
datediff(minute,hu.FECHINIHI,HIS.FECHISPAC) AS [Fecha Inicial Atencion - Fecha Final Atencion (min)],
F.IPCODPACI		AS Identificacion,
PA.IPNOMCOMP	AS Paciente,
ING.NUMINGRES	AS Ingreso,
CASE WHEN PA.IPSEXOPAC = '1' THEN 'Masculino' WHEN PA.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo,
G.CODUSUARI		AS CodUsuASigna,
ltrim(rtrim(G.NOMUSUARI)) AS UsuarioAsigna,
CASE
WHEN RIAS.NOMBRE IS NULL THEN 'No aplica RIAS'
ELSE RIAS.NOMBRE 
END				AS RIAS,
CASE
WHEN MP.[PROGRAMA CRONICOS] IS NULL THEN 'MORBILIDAD'
ELSE MP.[PROGRAMA CRONICOS] END AS ProgramaCronico
--, f.CONESTADO

from DBO.AGASICITA C  INNER JOIN 
(SELECT MIN(CODCONCEC) AS CODCONCEC, NUMCONCIT
FROM DBO.ADCONCOEX
--WHERE NUMINGRES='41B7FAED81'
--WHERE NUMINGRES='26A686AA5F'
GROUP BY NUMCONCIT) AS FF ON C.CODAUTONU = FF.NUMCONCIT INNER JOIN

DBO.ADCONCOEX AS F		ON FF.CODCONCEC = F.CODCONCEC	INNER JOIN 
DBO.AGACTIMED AS ACT	ON C.CODACTMED =  ACT.CODACTMED INNER JOIN
DBO.HCHISPACA AS HIS	ON HIS.ID = F.IDHCHISPACA		INNER JOIN .
DBO.HCURGING1 AS HU		ON HIS.IPCODPACI = HU.IPCODPACI and HIS.NUMINGRES = HU.NUMINGRES and HIS.NUMEFOLIO = HU.NUMEFOLIO and HIS.IDETIPHIS = HU.IDETIPHIS LEFT OUTER JOIN  
DBO.INPACIENT AS PA		ON PA.IPCODPACI = HIS.IPCODPACI	 INNER JOIN
DBO.ADINGRESO AS ING	ON HIS.NUMINGRES = ING.NUMINGRES INNER JOIN
DBO.INESPECIA AS ESP	ON ESP.CODESPECI = HIS.CODESPTRA INNER JOIN 
DBO.INPROFSAL AS PRO	ON PRO.CODPROSAL=C.CODPROSAL INNER JOIN 
DBO.ADCENATEN AS CEN	ON CEN.CODCENATE=C.CODCENATE LEFT OUTER JOIN 
dbo.SEGusuaru AS G		ON G.CODUSUARI = C.CODUSUASI LEFT OUTER JOIN 
DBO.RIASCUPS  AS RC		ON RC.ID = C.IDRIASCUPS		 LEFT OUTER JOIN 
DBO.RIAS	  AS RIAS	ON RIAS.ID = RC.IDRIAS		 LEFT OUTER JOIN 
ViewInternal.MedicosProgramas AS MP ON MP.[CODIGO PROFESIONAL] = C.CODPROSAL

where 
 HIS.ESTAFOLIO = 1 AND HIS.GENCONEXT =1 AND YEAR(HIS.FECHISPAC) >='2025'
--and ing.NUMINGRES <> '26A686AA5F'
--and ing.NUMINGRES = '26A686AA5F'

--select * from DBO.ADCONCOEX
--where NUMINGRES='FF3B015D6A'

--Column 'Ingreso' in Table 'IND_AG_HC_ControlCitasConsExt (2)' contains a duplicate value '26A686AA5F' and this is not allowed for columns on the one side of a many-to-one relationship or for columns that are used as the primary key of a table.