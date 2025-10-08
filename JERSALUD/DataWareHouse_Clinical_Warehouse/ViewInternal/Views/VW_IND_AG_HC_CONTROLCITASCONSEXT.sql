-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_AG_HC_CONTROLCITASCONSEXT
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_AG_HC_CONTROLCITASCONSEXT 
AS

SELECT 
    CASE 
    WHEN HIS.UFUCODIGO like 'MET%' THEN 'Meta' 
    WHEN HIS.UFUCODIGO  in ('CAS100','CAS001','CAS002','CAS003','CAS004','YOP001','YOP002','MYO001') THEN 'CASanare' 
    WHEN HIS.UFUCODIGO like 'BOY%' THEN 'Boyaca' 
    WHEN HIS.UFUCODIGO like 'B0%' THEN 'Boyaca'  
    WHEN HIS.UFUCODIGO  in ('MTU001','MTU101') THEN 'Boyaca'
    WHEN HIS.UFUCODIGO  in ('MVI001') THEN 'Meta' 
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
    datediff(minute,C.FECHORAIN,HU.FECHINIHI)	AS [Dif Fecha Inicial Cita - Fecha Inicial Atencion (min)],
    datediff(minute,HU.FECHINIHI,HIS.FECHISPAC) AS [Fecha Inicial Atencion - Fecha Final Atencion (min)],
    F.IPCODPACI		AS Identificacion,
    PA.IPNOMCOMP	AS Paciente,
    ING.NUMINGRES	AS Ingreso,
    CASE WHEN PA.IPSEXOPAC = '1' THEN 'Masculino' WHEN PA.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo,
    G.CODUSUARI		AS CODUSUASIgna,
    ltrim(rtrim(G.NOMUSUARI)) AS UsuarioAsigna,
    CASE
    WHEN RIAS.NOMBRE IS NULL THEN 'No aplica RIAS'
    ELSE RIAS.NOMBRE 
    END				AS RIAS,
    CASE
    WHEN MP.[PROGRAMA CRONICOS] IS NULL THEN 'MORBILIDAD'
    ELSE MP.[PROGRAMA CRONICOS] END AS ProgramaCronico

from [INDIGO031].[dbo].[AGASICITA] C  
INNER JOIN (SELECT MIN(CODCONCEC) AS CODCONCEC, NUMCONCIT
            FROM [INDIGO031].[dbo].[ADCONCOEX]
            GROUP BY NUMCONCIT) AS FF ON C.CODAUTONU = FF.NUMCONCIT
INNER JOIN [INDIGO031].[dbo].[ADCONCOEX] AS F ON FF.CODCONCEC = F.CODCONCEC	
INNER JOIN [INDIGO031].[dbo].[AGACTIMED] AS ACT	ON C.CODACTMED =  ACT.CODACTMED 
INNER JOIN [INDIGO031].[dbo].[HCHISPACA] AS HIS	ON HIS.ID = F.IDHCHISPACA		
INNER JOIN [INDIGO031].[dbo].[HCURGING1] AS HU	ON HIS.IPCODPACI = HU.IPCODPACI and HIS.NUMINGRES = HU.NUMINGRES and HIS.NUMEFOLIO = HU.NUMEFOLIO and HIS.IDETIPHIS = HU.IDETIPHIS 
LEFT OUTER JOIN [INDIGO031].[dbo].[INPACIENT] AS PA	ON PA.IPCODPACI = HIS.IPCODPACI	 
INNER JOIN [INDIGO031].[dbo].[ADINGRESO] AS ING	ON HIS.NUMINGRES = ING.NUMINGRES 
INNER JOIN [INDIGO031].[dbo].[INESPECIA] AS ESP	ON ESP.CODESPECI = HIS.CODESPTRA 
INNER JOIN [INDIGO031].[dbo].[INPROFSAL] AS PRO	ON PRO.CODPROSAL=C.CODPROSAL 
INNER JOIN [INDIGO031].[dbo].[ADCENATEN] AS CEN	ON CEN.CODCENATE=C.CODCENATE 
LEFT OUTER JOIN [INDIGO031].[dbo].[SEGusuaru] AS G	ON G.CODUSUARI = C.CODUSUASI 
LEFT OUTER JOIN [INDIGO031].[dbo].[RIASCUPS]  AS RC	ON RC.ID = C.IDRIASCUPS		
LEFT OUTER JOIN [INDIGO031].[dbo].[RIAS]	  AS RIAS ON RIAS.ID = RC.IDRIAS		 
LEFT OUTER JOIN [INDIGO031].[ViewInternal].[MedicosProgramas] AS MP ON MP.[CODIGO PROFESIONAL] = C.CODPROSAL

where HIS.ESTAFOLIO = 1 AND HIS.GENCONEXT =1 AND YEAR(HIS.FECHISPAC) >='2025'
