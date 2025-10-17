-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewSeguimientoCUPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW Report.[ViewSeguimientoCUPS] as
SELECT 
'OTROS PROCEDIMIENTOS' 'HISTORICO', ESP.DESESPECI 'ESPECIALIDAD',P.CODSERIPS 'CUPS',IPS.DESSERIPS 'DESCRIPCION CUPS',
CASE IPS.TIPSERIPS WHEN 1 THEN 'Laboratorios' WHEN 2 THEN 'Patologias' WHEN 3 THEN 'Imagenes Diagnosticas' WHEN 4 THEN 'Procedimeintos no Qx' WHEN 
5 THEN 'Procedimientos Qx' WHEN 6 THEN 'Interconsultas' WHEN 7 THEN 'Ninguno' WHEN 8 THEN 'Consulta Externa' WHEN 9 THEN 'Hemocomponentes' END 'TIPO SERVICIO',
CASE ShowDashboardOfAmbulatory 
WHEN 1 THEN 'Laboratorios' 
WHEN 2 THEN 'Patologias'
WHEN 3 THEN 'Imagenes'
WHEN 4 THEN 'Consulta Externa'
WHEN 5 THEN 'Quimioterapias'
WHEN 6 THEN 'Radioterapias'
WHEN 7 THEN 'Dialisis'
WHEN 8 THEN 'Ninguno'
WHEN 9 THEN 'Procedimientos No QX - Procedimientos Invasivos'
WHEN 10 THEN 'Procedimientos Qx - Procedimientos Invasivos'
WHEN 11 THEN 'Interconsultas'
WHEN 12 THEN 'Procedimientos Invasivos u Otros Procedimientos'
WHEN 13 THEN 'Braquiterapias' end 'MOSTRAR AMBULATORIO',-- ShowDashboardOfAmbulatory,
CASE ShowDashboardOf
WHEN 1 THEN 'Laboratorios' 
WHEN 2 THEN 'Patologias'
WHEN 3 THEN 'Imagenes'
WHEN 4 THEN 'Consulta Externa'
WHEN 5 THEN 'Quimioterapias'
WHEN 6 THEN 'Radioterapias'
WHEN 7 THEN 'Dialisis'
WHEN 8 THEN 'Ninguno'
WHEN 9 THEN 'Procedimientos No QX - Procedimientos Invasivos'
WHEN 10 THEN 'Procedimientos Qx - Procedimientos Invasivos'
WHEN 11 THEN 'Interconsultas'
WHEN 12 THEN 'Procedimientos Invasivos u Otros Procedimientos'
WHEN 13 THEN 'Braquiterapias' end 'MOSTRAR HOSPITALARIO'--,ShowDashboardOf
--, 'MOSTRAR HOSPITALARIO'
 
 
FROM DBO.HCPLAOTRPROC AS O   ---- DONDE GUARDO LA CABECERA DE LA HISTORIA CLINICA DE OTROS PROCEDIMIENTOS
INNER JOIN HCPLAOTRPROCUPS AS P ON O.ID=P.IDHCPLAOTRPROC   --- DONDE RELACIONO LOS CUPS QUE EL MEDICO CARGA CUANDO HACE LA HC DE OTROS PROCEDIMIENTOS
INNER JOIN DBO.HCHISPACA H ON H.ID=O.IDHCHISPACA --- DONDE SE GUARDA LA HC CLINICA DE OTROS PROCEDIMIENTO A NIVEL GENERAL
INNER JOIN DBO.INCUPSIPS AS IPS ON IPS.CODSERIPS=P.CODSERIPS ---- DONDE GUARDO LA CONFIGURACION DE LOS CUPS EN EL AMBITO EHR
INNER JOIN contract.CUPSentity AS CUPS ON CUPS.CODE=IPS.CODSERIPS --- DONDE GUARDO LA CONFIGURACION DE LOS CUPS EN EL AMBITO ERP
INNER JOIN DBO.INESPECIA AS ESP ON H.CODESPTRA=ESP.CODESPECI  --- DONDE GUARDO LA ESPECIALIDADES
--where code='231200'     
GROUP BY P.CODSERIPS,IPS.DESSERIPS,ESP.DESESPECI,IPS.TIPSERIPS,ShowDashboardOfAmbulatory,ShowDashboardOf