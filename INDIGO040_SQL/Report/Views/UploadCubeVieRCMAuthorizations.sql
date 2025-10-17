-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: UploadCubeVieRCMAuthorizations
-- Extracted by Fabric SQL Extractor SPN v3.9.0


/*******************************************************************************************************************
Nombre:[Report].UploadCubeVieRCMAuthorizations
Tipo:View
Observacion: Cubo de autorizaciones
Profesional: Nilsson Galindo
Fecha:15-08-2024
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:
Fecha:
Observaciones:
-------------------------------------------------------------------------------------------------------------------------------------
Version 3
Persona que modifico:
Fecha:
Observaciones:
***********************************************************************************************************************************/
CREATE VIEW [Report].[UploadCubeVieRCMAuthorizations] AS


WITH 
CTE_MANUAL_TARIFAS AS
(
-----------------------------------------------solicitud de autorizaciones intrahospitalarias------------------------------------------------------------------------------------
SELECT DISTINCT
GDR.CareGroupId,
DRD.CUPSEntityId,
DRD.CUPSSubgroupId,
DRD.CUPSGroupId,
GDR.InitialDate,
GDR.EndDate
FROM
Contract.CareGroupDefinitionRate GDR
INNER JOIN Contract.DefinitionRate DR ON GDR.DefinitionRateId=DR.Id
INNER JOIN Contract.DefinitionRateDetail DRD ON DR.Id=DRD.DefinitionRateId
),


CTE_AUTORIZACIONES AS
(
--------------------------------------SOLICITUDES HOSPITALARIAS----------------------------
SELECT
A.CODCONCEC,A.CODSERIPS,A.CANSERIPS,A.CANSERAUT,A.IPCODPACI,A.NUMEFOLIO,A.NUMINGRES,A.CODCENATE,A.UFUCODIGO,A.JUSCLISER,A.MEDIOSERV,
A.JUSANULA,A.SERSUSCEP,A.CODUSUANU,A.SOLEXTRAM,A.FECREGIST,A.IDCareGroup,
CASE A.PROESTADO WHEN 1 THEN 'Pendiente Solicitud'
				 WHEN 2 THEN 'Solicitado'
				 WHEN 3 THEN 'Autorizado'
				 WHEN 4 THEN 'Anulado' 
				 WHEN 5 THEN 'No Autorizado' END AS [ESTADO AUTORIZACION],
HA.HealthEntityCode AS [CODIGO EPS/ENTIDAD TERRITORIAL],
RTRIM(HA.Name) AS [ENTIDAD PACIENTE],
HA.EntityType, NULL AS CODPROSAL, A.IDDESCRIPCIONRELACIONADA,NULL AS CreationDate,NULL AS AuthorizationExpiredDate,AUV.NUMVALDER AS AuthorizationNumber
,AUV.FECREGEVE AS FECHAUTO,AUV.CODUSUARI,AUD.CHREGESTAID,AUC.NUMCAMHOS,
CASE AUC.CODPRIATE WHEN 1 THEN 'Prioritaria'
				   WHEN 2 THEN 'No Prioritaria' END AS PRIORIDAD,AUC.UBICAPACI,AUV.COMGENREG AS Observations,NULL AS RadicateNumber--,
--CASE WHEN FAC.Code IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM
dbo.ADAUTOSER A
INNER JOIN [Contract].HealthAdministrator HA ON A.CODENTIDA=HA.Code AND (A.SOLEXTRAM!='1' OR A.SOLEXTRAM IS NULL)
LEFT JOIN dbo.HCHISPACA HC ON A.NUMINGRES=HC.NUMINGRES AND A.NUMEFOLIO=HC.NUMEFOLIO
LEFT JOIN dbo.ADAUTSERD AUD ON A.NUMINGRES=AUD.NUMINGRES AND AUD.CODSERIPS=A.CODSERIPS AND (A.NUMEFOLIO=AUD.NUMEFOLIO OR (A.NUMEFOLIO IS NULL AND AUD.NUMEFOLIO=''))
LEFT JOIN dbo.ADAUTSERC AUC ON AUD.CODCONCEC=AUC.CODCONCEC AND AUD.NUMINGRES=AUC.NUMINGRES
LEFT JOIN dbo.ADAUTEVEN AUV ON AUV.CODREGUNI=(SELECT MAX(B.CODREGUNI) FROM dbo.ADAUTEVEN B WHERE AUD.CODCONCEC=B.ADAUTSERID AND AUD.NUMINGRES=B.NUMINGRES)


UNION ALL
-----------------------------------------------------imagenes------------------------------------------------------------------------------------------------
SELECT
A.[AUTO] AS CODCONCEC,CODSERIPS,CANSERIPS,TPE.AuthorizedQuantity AS CANSERAUT,A.IPCODPACI,NUMEFOLIO,A.NUMINGRES,A.CODCENATE,A.UFUCODIGO,
A.OBSSERIPS AS JUSCLISER,1 AS MEDIOSERV,TP.CancellationReasonsObservations AS JUSANULA, 1 AS SERSUSCEP,TP.CancellationUserCode AS CODUSUANU,1 AS SOLEXTRAM,A.FECORDMED AS FECREGIST,GENCAREGROUP AS IDCareGroup,
CASE TP.[Status] WHEN 1 THEN 'Solicitado'
				 WHEN 2 THEN 'Pendiente Autorización'
				 WHEN 3 THEN 'Pendiente Autorización'
				 WHEN 4 THEN 'Radicado No Autorizado'
				 WHEN 5 THEN 'Autorizado'
				 WHEN 6 THEN 'Radicado Programación'
				 WHEN 7 THEN 'Radicado Programación'
				 WHEN 8 THEN 'Radicado Programación'
				 WHEN 9 THEN 'Realizado'
				 WHEN 10 THEN 'Realizado'
				 WHEN 11 THEN 'Anulado'
				 WHEN 12 THEN 'Pendiente Autorización' 
				 WHEN 13 THEN 'Pendiente Autorización'
				 WHEN 14 THEN 'Autorizado'
				 WHEN 15 THEN 'Autorizado'
				 WHEN 16 THEN 'Postergado' ELSE 'Solicitado' END AS [ESTADO AUTORIZACION],
HA.HealthEntityCode AS [CODIGO EPS/ENTIDAD TERRITORIAL],
RTRIM(HA.Name) AS [ENTIDAD PACIENTE],
HA.EntityType,A.CODPROSAL,A.IDDESCRIPCIONRELACIONADA,TPE.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber,
TPE.CreationDate AS FECHAUTO,TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber
FROM
dbo.HCORDIMAG A 
INNER JOIN dbo.ADINGRESO ING ON A.NUMINGRES=ING.NUMINGRES
LEFT JOIN [Contract].HealthAdministrator HA ON ING.CODENTIDA=HA.Code
LEFT JOIN [Authorization].TraceabilityPaperwork TP ON A.[AUTO]=TP.EntityId AND TP.EntityName='HCORDIMAG'
 OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPE
        WHERE TPE.TraceabilityPaperworkId = TP.Id
        ORDER BY TPE.Id DESC
    ) TPE
    OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPEM
        WHERE TPEM.TraceabilityPaperworkId = TP.Id
        ORDER BY TPEM.Id ASC
    ) TPEM
WHERE A.MANEXTPRO=1
UNION ALL
----------------------------------------------------------laboratorios-------------------------------------------------------------------------------------------
SELECT
A.[AUTO] AS CODCONCEC,CODSERIPS,CANSERIPS,TPE.AuthorizedQuantity AS CANSERAUT,A.IPCODPACI,NUMEFOLIO,A.NUMINGRES,A.CODCENATE,A.UFUCODIGO,
A.OBSSERIPS AS JUSCLISER,1 AS MEDIOSERV,TP.CancellationReasonsObservations AS JUSANULA, 1 AS SERSUSCEP,TP.CancellationUserCode AS CODUSUANU,
1 AS SOLEXTRAM,A.FECORDMED AS FECREGIST,GENCAREGROUP AS IDCareGroup,
CASE TP.[Status] WHEN 1 THEN 'Solicitado'
				 WHEN 2 THEN 'Pendiente Autorización'
				 WHEN 3 THEN 'Pendiente Autorización'
				 WHEN 4 THEN 'Radicado No Autorizado'
				 WHEN 5 THEN 'Autorizado'
				 WHEN 6 THEN 'Radicado Programación'
				 WHEN 7 THEN 'Radicado Programación'
				 WHEN 8 THEN 'Radicado Programación'
				 WHEN 9 THEN 'Realizado'
				 WHEN 10 THEN 'Realizado'
				 WHEN 11 THEN 'Anulado'
				 WHEN 12 THEN 'Pendiente Autorización' 
				 WHEN 13 THEN 'Pendiente Autorización'
				 WHEN 14 THEN 'Autorizado'
				 WHEN 15 THEN 'Autorizado'
				 WHEN 16 THEN 'Postergado' ELSE 'Solicitado' END AS [ESTADO AUTORIZACION],
HA.HealthEntityCode AS [CODIGO EPS/ENTIDAD TERRITORIAL],
RTRIM(HA.Name) AS [ENTIDAD PACIENTE],
HA.EntityType, A.CODPROSAL,A.IDDESCRIPCIONRELACIONADA,TPE.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber,
TPE.CreationDate AS FECHAUTO,TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM
dbo.HCORDLABO A 
INNER JOIN dbo.ADINGRESO ING ON A.NUMINGRES=ING.NUMINGRES
LEFT JOIN [Contract].HealthAdministrator HA ON ING.CODENTIDA=HA.Code
LEFT JOIN [Authorization].TraceabilityPaperwork TP ON A.[AUTO]=TP.EntityId AND TP.EntityName='HCORDLABO'
 OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPE
        WHERE TPE.TraceabilityPaperworkId = TP.Id
        ORDER BY TPE.Id DESC
    ) TPE
    OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPEM
        WHERE TPEM.TraceabilityPaperworkId = TP.Id
        ORDER BY TPEM.Id ASC
    ) TPEM
WHERE A.MANEXTPRO=1
UNION ALL ----------------------------------------------------------PATOLOGIAS-------------------------------------------------------------------------------------------
SELECT
A.[AUTO] AS CODCONCEC,CODSERIPS,CANSERIPS,TPE.AuthorizedQuantity AS CANSERAUT,A.IPCODPACI,NUMEFOLIO,A.NUMINGRES,A.CODCENATE,A.UFUCODIGO,
A.OBSSERIPS AS JUSCLISER,1 AS MEDIOSERV,TP.CancellationReasonsObservations AS JUSANULA, 1 AS SERSUSCEP,TP.CancellationUserCode AS CODUSUANU,1 AS SOLEXTRAM,A.FECORDMED AS FECREGIST,GENCAREGROUP AS IDCareGroup,
CASE TP.[Status] WHEN 1 THEN 'Solicitado'
				 WHEN 2 THEN 'Pendiente Autorización'
				 WHEN 3 THEN 'Pendiente Autorización'
				 WHEN 4 THEN 'Radicado No Autorizado'
				 WHEN 5 THEN 'Autorizado'
				 WHEN 6 THEN 'Radicado Programación'
				 WHEN 7 THEN 'Radicado Programación'
				 WHEN 8 THEN 'Radicado Programación'
				 WHEN 9 THEN 'Realizado'
				 WHEN 10 THEN 'Realizado'
				 WHEN 11 THEN 'Anulado'
				 WHEN 12 THEN 'Pendiente Autorización' 
				 WHEN 13 THEN 'Pendiente Autorización'
				 WHEN 14 THEN 'Autorizado'
				 WHEN 15 THEN 'Autorizado'
				 WHEN 16 THEN 'Postergado' ELSE 'Solicitado' END AS [ESTADO AUTORIZACION],
HA.HealthEntityCode AS [CODIGO EPS/ENTIDAD TERRITORIAL],
RTRIM(HA.Name) AS [ENTIDAD PACIENTE],
HA.EntityType, A.CODPROSAL,A.IDDESCRIPCIONRELACIONADA,TPE.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber,
TPE.CreationDate AS FECHAUTO, TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM
dbo.HCORDPATO A 
INNER JOIN dbo.ADINGRESO ING ON A.NUMINGRES=ING.NUMINGRES
LEFT JOIN [Contract].HealthAdministrator HA ON ING.CODENTIDA=HA.Code
LEFT JOIN [Authorization].TraceabilityPaperwork TP ON A.[AUTO]=TP.EntityId AND TP.EntityName='HCORDPATO'
 OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPE
        WHERE TPE.TraceabilityPaperworkId = TP.Id
        ORDER BY TPE.Id DESC
    ) TPE
    OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPEM
        WHERE TPEM.TraceabilityPaperworkId = TP.Id
        ORDER BY TPEM.Id ASC
    ) TPEM
WHERE A.MANEXTPRO=1
UNION ALL ----------------------------------------------------------INTERCONSULTAS-------------------------------------------------------------------------------------------
SELECT
A.[AUTO] AS CODCONCEC,CODSERIPS,CANSERIPS,TPE.AuthorizedQuantity AS CANSERAUT,A.IPCODPACI,NUMEFOLIO,A.NUMINGRES,A.CODCENATE,A.UFUCODIGO,
A.OBSSERIPS AS JUSCLISER,1 AS MEDIOSERV,TP.CancellationReasonsObservations AS JUSANULA, 1 AS SERSUSCEP,TP.CancellationUserCode AS CODUSUANU,1 AS SOLEXTRAM,A.FECORDMED AS FECREGIST,GENCAREGROUP AS IDCareGroup,
CASE TP.[Status] WHEN 1 THEN 'Solicitado'
				 WHEN 2 THEN 'Pendiente Autorización'
				 WHEN 3 THEN 'Pendiente Autorización'
				 WHEN 4 THEN 'Radicado No Autorizado'
				 WHEN 5 THEN 'Autorizado'
				 WHEN 6 THEN 'Radicado Programación'
				 WHEN 7 THEN 'Radicado Programación'
				 WHEN 8 THEN 'Radicado Programación'
				 WHEN 9 THEN 'Realizado'
				 WHEN 10 THEN 'Realizado'
				 WHEN 11 THEN 'Anulado'
				 WHEN 12 THEN 'Pendiente Autorización' 
				 WHEN 13 THEN 'Pendiente Autorización'
				 WHEN 14 THEN 'Autorizado'
				 WHEN 15 THEN 'Autorizado'
				 WHEN 16 THEN 'Postergado' ELSE 'Solicitado' END AS [ESTADO AUTORIZACION],
HA.HealthEntityCode AS [CODIGO EPS/ENTIDAD TERRITORIAL],
RTRIM(HA.Name) AS [ENTIDAD PACIENTE],
HA.EntityType, A.CODPROSAL,A.IDDESCRIPCIONRELACIONADA,TPE.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber,
TPE.CreationDate AS FECHAUTO, TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM
dbo.HCORDINTE A 
INNER JOIN dbo.ADINGRESO ING ON A.NUMINGRES=ING.NUMINGRES 
LEFT JOIN [Contract].HealthAdministrator HA ON ING.CODENTIDA=HA.Code
LEFT JOIN [Authorization].TraceabilityPaperwork TP ON A.[AUTO]=TP.EntityId AND TP.EntityName='HCORDINTE'
 OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPE
        WHERE TPE.TraceabilityPaperworkId = TP.Id
        ORDER BY TPE.Id DESC
    ) TPE
    OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPEM
        WHERE TPEM.TraceabilityPaperworkId = TP.Id
        ORDER BY TPEM.Id ASC
    ) TPEM
WHERE A.MANEXTPRO=1
UNION ALL ----------------------------------------------------------PROCEDIMIENTOS NO QX-------------------------------------------------------------------------------------------
SELECT
A.[AUTO] AS CODCONCEC,CODSERIPS,CANSERIPS,TPE.AuthorizedQuantity AS CANSERAUT,A.IPCODPACI,NUMEFOLIO,A.NUMINGRES,A.CODCENATE,A.UFUCODIGO,
A.OBSSERIPS AS JUSCLISER,1 AS MEDIOSERV,TP.CancellationReasonsObservations AS JUSANULA, 1 AS SERSUSCEP,TP.CancellationUserCode AS CODUSUANU,
1 AS SOLEXTRAM,A.FECORDMED AS FECREGIST,GENCAREGROUP AS IDCareGroup,
CASE TP.[Status] WHEN 1 THEN 'Solicitado'
				 WHEN 2 THEN 'Pendiente Autorización'
				 WHEN 3 THEN 'Pendiente Autorización'
				 WHEN 4 THEN 'Radicado No Autorizado'
				 WHEN 5 THEN 'Autorizado'
				 WHEN 6 THEN 'Radicado Programación'
				 WHEN 7 THEN 'Radicado Programación'
				 WHEN 8 THEN 'Radicado Programación'
				 WHEN 9 THEN 'Realizado'
				 WHEN 10 THEN 'Realizado'
				 WHEN 11 THEN 'Anulado'
				 WHEN 12 THEN 'Pendiente Autorización' 
				 WHEN 13 THEN 'Pendiente Autorización'
				 WHEN 14 THEN 'Autorizado'
				 WHEN 15 THEN 'Autorizado'
				 WHEN 16 THEN 'Postergado' ELSE 'Solicitado' END AS [ESTADO AUTORIZACION],
HA.HealthEntityCode AS [CODIGO EPS/ENTIDAD TERRITORIAL],
RTRIM(HA.Name) AS [ENTIDAD PACIENTE],
HA.EntityType, A.CODPROSAL,A.IDDESCRIPCIONRELACIONADA,TPE.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber,
TPE.CreationDate AS FECHAUTO,TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM
dbo.HCORDPRON A 
INNER JOIN dbo.ADINGRESO ING ON A.NUMINGRES=ING.NUMINGRES
LEFT JOIN [Contract].HealthAdministrator HA ON ING.CODENTIDA=HA.Code
LEFT JOIN [Authorization].TraceabilityPaperwork TP ON A.[AUTO]=TP.EntityId AND TP.EntityName='HCORDPRON'
 OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPE
        WHERE TPE.TraceabilityPaperworkId = TP.Id
        ORDER BY TPE.Id DESC
    ) TPE
    OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPEM
        WHERE TPEM.TraceabilityPaperworkId = TP.Id
        ORDER BY TPEM.Id ASC
    ) TPEM
WHERE A.MANEXTPRO=1
UNION ALL ----------------------------------------------------------PROCEDIMIENTOS QX-------------------------------------------------------------------------------------------
SELECT
A.[AUTO] AS CODCONCEC,CODSERIPS,CANSERIPS,TPE.AuthorizedQuantity AS CANSERAUT,A.IPCODPACI,NUMEFOLIO,A.NUMINGRES,A.CODCENATE,A.UFUCODIGO,
A.OBSSERIPS AS JUSCLISER,1 AS MEDIOSERV,TP.CancellationReasonsObservations AS JUSANULA, 1 AS SERSUSCEP,TP.CancellationUserCode AS CODUSUANU,1 AS SOLEXTRAM,A.FECORDMED AS FECREGIST,GENCAREGROUP AS IDCareGroup,
CASE TP.[Status] WHEN 1 THEN 'Solicitado'
				 WHEN 2 THEN 'Pendiente Autorización'
				 WHEN 3 THEN 'Pendiente Autorización'
				 WHEN 4 THEN 'Radicado No Autorizado'
				 WHEN 5 THEN 'Autorizado'
				 WHEN 6 THEN 'Radicado Programación'
				 WHEN 7 THEN 'Radicado Programación'
				 WHEN 8 THEN 'Radicado Programación'
				 WHEN 9 THEN 'Realizado'
				 WHEN 10 THEN 'Realizado'
				 WHEN 11 THEN 'Anulado'
				 WHEN 12 THEN 'Pendiente Autorización' 
				 WHEN 13 THEN 'Pendiente Autorización'
				 WHEN 14 THEN 'Autorizado'
				 WHEN 15 THEN 'Autorizado'
				 WHEN 16 THEN 'Postergado' ELSE 'Solicitado' END AS [ESTADO AUTORIZACION],
HA.HealthEntityCode AS [CODIGO EPS/ENTIDAD TERRITORIAL],
RTRIM(HA.Name) AS [ENTIDAD PACIENTE],
HA.EntityType, A.CODPROSAL,A.IDDESCRIPCIONRELACIONADA,TPE.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber,
TPE.CreationDate AS FECHAUTO,TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM
dbo.HCORDPROQ A 
INNER JOIN dbo.ADINGRESO ING ON A.NUMINGRES=ING.NUMINGRES
LEFT JOIN [Contract].HealthAdministrator HA ON ING.CODENTIDA=HA.Code
LEFT JOIN [Authorization].TraceabilityPaperwork TP ON A.[AUTO]=TP.EntityId AND TP.EntityName='HCORDPROQ'
 OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPE
        WHERE TPE.TraceabilityPaperworkId = TP.Id
        ORDER BY TPE.Id DESC
    ) TPE
    OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPEM
        WHERE TPEM.TraceabilityPaperworkId = TP.Id
        ORDER BY TPEM.Id ASC
    ) TPEM
WHERE A.MANEXTPRO=1
UNION ALL ------------------------------------------HEMOCOMPONENTE-------------------------------------------------------------------------------------------
SELECT
A.ID AS CODCONCEC,B.CODSERIPS,1 AS CANSERIPS,
TPE.AuthorizedQuantity AS CANSERAUT,
A.IPCODPACI,NUMEFOLIO,A.NUMINGRES,A.CODCENATE,
ISNULL(C.UFUSOLRES,C.UFUSOLTRA) AS UFUCODIGO,
A.OBSERVACI AS JUSCLISER,1 AS MEDIOSERV,
TP.CancellationReasonsObservations AS JUSANULA, 1 AS SERSUSCEP,
TP.CancellationUserCode AS CODUSUANU,
1 AS SOLEXTRAM,A.FECORDMED AS FECREGIST,GENCAREGROUP AS IDCareGroup,
CASE TP.[Status] WHEN 1 THEN 'Solicitado'
				 WHEN 2 THEN 'Pendiente Autorización'
				 WHEN 3 THEN 'Pendiente Autorización'
				 WHEN 4 THEN 'Radicado No Autorizado'
				 WHEN 5 THEN 'Autorizado'
				 WHEN 6 THEN 'Radicado Programación'
				 WHEN 7 THEN 'Radicado Programación'
				 WHEN 8 THEN 'Radicado Programación'
				 WHEN 9 THEN 'Realizado'
				 WHEN 10 THEN 'Realizado'
				 WHEN 11 THEN 'Anulado'
				 WHEN 12 THEN 'Pendiente Autorización' 
				 WHEN 13 THEN 'Pendiente Autorización'
				 WHEN 14 THEN 'Autorizado'
				 WHEN 15 THEN 'Autorizado'
				 WHEN 16 THEN 'Postergado' ELSE 'Solicitado' END AS [ESTADO AUTORIZACION],
HA.HealthEntityCode AS [CODIGO EPS/ENTIDAD TERRITORIAL],
RTRIM(HA.Name) AS [ENTIDAD PACIENTE],
HA.EntityType, 
ISNULL(C.PROFSOLTRA,C.PROFSOLRES) AS CODPROSAL, 
NULL AS IDDESCRIPCIONRELACIONADA,
TPE.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber
,TPE.CreationDate AS FECHAUTO,TPE.CreationUser AS CODUSUARI,
NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM
dbo.HCORHEMCO A 
INNER JOIN dbo.HCORHEMSER B ON A.ID=B.HCORHEMCOID
INNER JOIN dbo.ADINGRESO ING ON A.NUMINGRES=ING.NUMINGRES
LEFT JOIN dbo.HCORHEMBOL C ON B.HCORHEMBOLID=C.ID
LEFT JOIN [Contract].HealthAdministrator HA ON ING.CODENTIDA=HA.Code
LEFT JOIN [Authorization].TraceabilityPaperwork TP ON A.ID=TP.EntityId AND TP.EntityName='HCORHEMCO'
 OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPE
        WHERE TPE.TraceabilityPaperworkId = TP.Id
        ORDER BY TPE.Id DESC
    ) TPE
    OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPEM
        WHERE TPEM.TraceabilityPaperworkId = TP.Id
        ORDER BY TPEM.Id ASC
    ) TPEM
WHERE A.MANEXTPRO=1 --AND CAST(A.FECORDMED AS DATE) BETWEEN '2024-11-10' AND '2024-11-18' AND A.NUMINGRES='4C05632946' --AND B.CODSERIPS='911003'
UNION ALL ------------------------------------------------------MEDICAMENTOS DE LA QUIMIOTERAPIA-------------------------------------------------------------------------------------------
SELECT
A.ID AS CODCONCEC,A.CODPRODUC AS CODSERIPS,C.CANPEDPRO AS CANSERIPS,TPE.AuthorizedQuantity AS CANSERAUT,B.IPCODPACI,B.NUMEFOLIO,B.NUMINGRES,C.CODCENATE,B.UFUCODIGO,
A.JUSTIFICACIONPBS AS JUSCLISER,2 AS MEDIOSERV,TP.CancellationReasonsObservations AS JUSANULA, 1 AS SERSUSCEP,TP.CancellationUserCode AS CODUSUANU,1 AS SOLEXTRAM,B.FECHAREGISTRO AS FECREGIST,GENCAREGROUP AS IDCareGroup,
CASE TP.[Status] WHEN 1 THEN 'Solicitado'
				 WHEN 2 THEN 'Pendiente Autorización'
				 WHEN 3 THEN 'Pendiente Autorización'
				 WHEN 4 THEN 'Radicado No Autorizado'
				 WHEN 5 THEN 'Autorizado'
				 WHEN 6 THEN 'Radicado Programación'
				 WHEN 7 THEN 'Radicado Programación'
				 WHEN 8 THEN 'Radicado Programación'
				 WHEN 9 THEN 'Realizado'
				 WHEN 10 THEN 'Realizado'
				 WHEN 11 THEN 'Anulado'
				 WHEN 12 THEN 'Pendiente Autorización' 
				 WHEN 13 THEN 'Pendiente Autorización'
				 WHEN 14 THEN 'Autorizado'
				 WHEN 15 THEN 'Autorizado'
				 WHEN 16 THEN 'Postergado' ELSE 'Solicitado' END AS [ESTADO AUTORIZACION],
HA.HealthEntityCode AS [CODIGO EPS/ENTIDAD TERRITORIAL],
RTRIM(HA.Name) AS [ENTIDAD PACIENTE],
HA.EntityType, B.CODPROSAL, NULL AS IDDESCRIPCIONRELACIONADA,TPE.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber,
TPE.CreationDate AS FECHAUTO, TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM
EHR.HCORMEDICAMESQUEMA A 
INNER JOIN EHR.HCORDQUIMIO B ON A.IDHCORDQUIMIO=B.ID
INNER JOIN dbo.HCPRESCRA C ON A.IDHCORDQUIMIO=C.IDHCORDQUIMIO
INNER JOIN dbo.ADINGRESO ING ON B.NUMINGRES=ING.NUMINGRES
LEFT JOIN [Contract].HealthAdministrator HA ON ING.CODENTIDA=HA.Code
LEFT JOIN [Authorization].TraceabilityPaperwork TP ON A.ID=TP.EntityId AND TP.EntityName='HCORMEDICAMESQUEMA'
 OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPE
        WHERE TPE.TraceabilityPaperworkId = TP.Id
        ORDER BY TPE.Id DESC
    ) TPE
    OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPEM
        WHERE TPEM.TraceabilityPaperworkId = TP.Id
        ORDER BY TPEM.Id ASC
    ) TPEM
WHERE MANEJOEXTERNO=1
UNION ALL ----------------------------------------------------------PROCEDIMIENTOS QX-------------------------------------------------------------------------------------------
SELECT
A.[AUTO] AS CODCONCEC,CODSERIPS,1 AS CANSERIPS,TPE.AuthorizedQuantity AS CANSERAUT,A.IPCODPACI,A.NUMEFOLIO,A.NUMINGRES,A.CODCENATE,A.UFUCODIGO,
NULL AS JUSCLISER,1 AS MEDIOSERV,TP.CancellationReasonsObservations AS JUSANULA, 1 AS SERSUSCEP,TP.CancellationUserCode AS CODUSUANU,1 AS SOLEXTRAM,B.FECHISPAC AS FECREGIST,GENCAREGROUP AS IDCareGroup,
CASE TP.[Status] WHEN 1 THEN 'Solicitado'
				 WHEN 2 THEN 'Pendiente Autorización'
				 WHEN 3 THEN 'Pendiente Autorización'
				 WHEN 4 THEN 'Radicado No Autorizado'
				 WHEN 5 THEN 'Autorizado'
				 WHEN 6 THEN 'Radicado Programación'
				 WHEN 7 THEN 'Radicado Programación'
				 WHEN 8 THEN 'Radicado Programación'
				 WHEN 9 THEN 'Realizado'
				 WHEN 10 THEN 'Realizado'
				 WHEN 11 THEN 'Anulado'
				 WHEN 12 THEN 'Pendiente Autorización' 
				 WHEN 13 THEN 'Pendiente Autorización'
				 WHEN 14 THEN 'Autorizado'
				 WHEN 15 THEN 'Autorizado'
				 WHEN 16 THEN 'Postergado' ELSE 'Solicitado' END AS [ESTADO AUTORIZACION],
HA.HealthEntityCode AS [CODIGO EPS/ENTIDAD TERRITORIAL],
RTRIM(HA.Name) AS [ENTIDAD PACIENTE],
HA.EntityType, B.CODPROSAL, A.IDDESCRIPCIONRELACIONADA,TPE.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber,
TPE.CreationDate AS FECHAUTO,TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM
dbo.HCDESCOEX A 
INNER JOIN dbo.ADINGRESO ING ON A.NUMINGRES=ING.NUMINGRES
INNER JOIN dbo.HCHISPACA B ON A.NUMINGRES=B.NUMINGRES AND A.NUMEFOLIO=B.NUMEFOLIO
LEFT JOIN [Contract].HealthAdministrator HA ON ING.CODENTIDA=HA.Code
LEFT JOIN [Authorization].TraceabilityPaperwork TP ON A.[AUTO]=TP.EntityId AND TP.EntityName='HCDESCOEX'
 OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPE
        WHERE TPE.TraceabilityPaperworkId = TP.Id
        ORDER BY TPE.Id DESC
    ) TPE
    OUTER APPLY (
        SELECT TOP 1 * 
        FROM [Authorization].TraceabilityPaperworkEvents TPEM
        WHERE TPEM.TraceabilityPaperworkId = TP.Id
        ORDER BY TPEM.Id ASC
    ) TPEM
WHERE ING.IINGREPOR=2
UNION ALL ----------------------------------------------------------MEDICAMENTOS-------------------------------------------------------------------------------------------
SELECT 
A.ID AS CODCONCEC,A.CODPRODUC AS CODSERIPS,A.CANPEDPRO AS CANSERIPS,TPE.AuthorizedQuantity AS CANSERAUT,A.IPCODPACI,NUMEFOLIO,
A.NUMINGRES,A.CODCENATE,A.UFUCODIGO,
NULL AS JUSCLISER,2 AS MEDIOSERV,TP.CancellationReasonsObservations AS JUSANULA, 1 AS SERSUSCEP,TP.CancellationUserCode AS CODUSUANU,1 AS SOLEXTRAM,A.FECINIDOS AS FECREGIST,GENCAREGROUP AS IDCareGroup,
CASE TP.[Status] WHEN 1 THEN 'Solicitado'
				 WHEN 2 THEN 'Pendiente Autorización'
				 WHEN 3 THEN 'Pendiente Autorización'
				 WHEN 4 THEN 'Radicado No Autorizado'
				 WHEN 5 THEN 'Autorizado'
				 WHEN 6 THEN 'Radicado Programación'
				 WHEN 7 THEN 'Radicado Programación'
				 WHEN 8 THEN 'Radicado Programación'
				 WHEN 9 THEN 'Realizado'
				 WHEN 10 THEN 'Realizado'
				 WHEN 11 THEN 'Anulado'
				 WHEN 12 THEN 'Pendiente Autorización' 
				 WHEN 13 THEN 'Pendiente Autorización'
				 WHEN 14 THEN 'Autorizado'
				 WHEN 15 THEN 'Autorizado'
				 WHEN 16 THEN 'Postergado' ELSE 'Solicitado' END AS [ESTADO AUTORIZACION],
HA.HealthEntityCode AS [CODIGO EPS/ENTIDAD TERRITORIAL],
RTRIM(HA.Name) AS [ENTIDAD PACIENTE],
HA.EntityType, A.CODPROSAL,NULL AS IDDESCRIPCIONRELACIONADA,TPE.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber
,TPE.CreationDate AS FECHAUTO,TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM
dbo.HCPRESCRA A 
INNER JOIN dbo.ADINGRESO ING ON A.NUMINGRES=ING.NUMINGRES
LEFT JOIN [Contract].HealthAdministrator HA ON ING.CODENTIDA=HA.Code
LEFT JOIN [Authorization].TraceabilityPaperwork TP ON A.ID=TP.EntityId AND TP.EntityName='HCPRESCRA'
OUTER APPLY (SELECT TOP 1 * FROM [Authorization].TraceabilityPaperworkEvents TPE WHERE TPE.TraceabilityPaperworkId = TP.Id ORDER BY TPE.Id DESC) TPE
OUTER APPLY (SELECT TOP 1 * FROM [Authorization].TraceabilityPaperworkEvents TPEM
        WHERE TPEM.TraceabilityPaperworkId = TP.Id
        ORDER BY TPEM.Id ASC
    ) TPEM
WHERE A.MANEXTPRO=1 AND A.IDHCORDQUIMIO IS NULL
),
---------------------En este CTE trae el ultimo analista de autorizaciones que se asigna por ingreso-------------------------------------
CTE_ALISTA_ASIGNADO AS
(
SELECT
MIAU.AdmissionNumber,
CAST(MIAU.UserId AS VARCHAR(6))+'-'+MIPER.Fullname AS [ANALISTA ASIGNADO]
FROM [Authorization].MyAdmissionsByUsers MIAU 
INNER JOIN [Security].[UserInt] MIUSA ON MIAU.UserId=MIUSA.Id 
INNER JOIN [Security].PersonInt MIPER ON MIUSA.IdPerson=MIPER.Id
WHERE MIAU.Id=(SELECT MAX(A.Id) FROM [Authorization].MyAdmissionsByUsers A WHERE MIAU.AdmissionNumber=A.AdmissionNumber) 
)

--4.758
/**************************************************************************************************************************************
---------------------------------------------CONSULTA PRINCIPAL----------------------------------------------------------------------
****************************************************************************************************************************************/

SELECT
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
CEN.NOMCENATE AS [CENTRO DE ATENCION],
TD.SIGLA AS [TIPO IDENTIFICACION],
PAC.IPCODPACI AS [IDENTIFICACIÓN PACIENTE],
PAC.IPPRIAPEL AS [PRIMER APELLIDO PACIENTE],
PAC.IPSEGNOMB AS [SEGUNDO APELLIDO PACIENTE],
PAC.IPPRINOMB AS [PRIMER NOMBRE PACIENTE],
PAC.IPSEGNOMB AS [SEGUNDO NOMBRE PACIENTE],
PAC.IPNOMCOMP AS [NOMBRE PACIENTE],
CONCAT(DATEDIFF(YEAR, PAC.IPFECNACI, ING.IFECHAING) - CASE WHEN MONTH(PAC.IPFECNACI) > MONTH(ING.IFECHAING) OR (MONTH(PAC.IPFECNACI) = MONTH(ING.IFECHAING) AND DAY(PAC.IPFECNACI) > DAY(ING.IFECHAING)) THEN 1 ELSE 0 END, ' Años, ', DATEDIFF(MONTH, PAC.IPFECNACI, ING.IFECHAING) % 12 - 
													  CASE WHEN DAY(PAC.IPFECNACI) > DAY(ING.IFECHAING) THEN 1 ELSE 0 END, ' Meses, ', DAY(ING.IFECHAING) - DAY(PAC.IPFECNACI) + 
													  CASE WHEN DAY(ING.IFECHAING) < DAY(PAC.IPFECNACI) THEN DAY(EOMONTH(PAC.IPFECNACI, 0)) ELSE 0 END, ' Dias') AS [EDAD PACIENTE],
CASE WHEN PAC.IPSEXOPAC = '1' THEN 'Hombre' WHEN PAC.IPSEXOPAC = '2' THEN 'Mujer' END AS [SEXO BIOLOGICO], 
GEN.Name AS [IDENTIDAD DE GENERO],
PAC.IPTELEFON AS [TELEFONO PACIENTE],
PAC.IPTELMOVI AS [MOVIL PACIENTE],
AU.[CODIGO EPS/ENTIDAD TERRITORIAL],
AU.[ENTIDAD PACIENTE],
RTRIM(E.Code) AS [CODIGO GRUPO ATENCION],
RTRIM(E.Name) AS [GRUPO ATENCION],
CASE AU.EntityType  WHEN '1'  THEN 'EPS Contributivo'
					WHEN '2'  THEN 'EPS Subsidiado'
					WHEN '3'  THEN 'ET Vinculados Municipios'
					WHEN '4'  THEN 'ET Vinculados Departamentos'
					WHEN '5'  THEN 'ARL Riesgos Laborales'
					WHEN '6'  THEN 'MP Medicina Prepagada'
					WHEN '7'  THEN 'IPS Privada'
					WHEN '8'  THEN 'IPS Publica'
					WHEN '9'  THEN 'Regimen Especial'
					WHEN '10' THEN 'Accidentes de transito'
					WHEN '11' THEN 'Fosyga'
					WHEN '12' THEN 'Otros' 
					WHEN '13' THEN 'Aseguradoras' END AS REGIMEN,
ING.IFECHAING AS [FECHA DE INGRESO],
UF.Name AS [UNIDAD FUNCIONAL],
ISNULL(AU.NUMCAMHOS,HCR.CODICAMAS) AS CAMA,
ISNULL(AU.FECREGIST,HIS.FECHISPAC) AS [FECHA SOLICITUD],
RTRIM(PROF.CODUSUARI)+' - '+PROF.NOMMEDICO AS [PROFESIONAL ORDEN],
ESP.DESESPECI AS [ESPECIALIDAD ORDEN],
AU.JUSCLISER AS [JUSTIFICACION CLINICA],
ISNULL(AU.NUMEFOLIO,HIS.NUMEFOLIO) AS [NUMERO FOLIO],
AU.NUMINGRES AS [NUMERO INGRESO],
DIAS.CODDIAGNO+' - ' +DIAS.NOMDIAGNO AS [DIAGNOSTICO PRINCIPAL],
AU.CODCONCEC AS [CONSECUTIVO AUTORIZACION],
AU.[ESTADO AUTORIZACION],
AU.PRIORIDAD,
CASE AU.SERSUSCEP WHEN 1 THEN 'SI' WHEN 0 THEN 'NO' END AS [SUSCEPTIBLES AUTORIZACION],
IIF(MT.CUPSEntityId IS NULL,'No','Si') AS [SERVICIO CONTRATADO],
ISNULL(CASE AU.UBICAPACI WHEN 1 THEN 'Consulta Externa'
						  WHEN 2 THEN 'Urgencias'
						  WHEN 3 THEN 'Hospitalizacion' END,CASE ING.IINGREPOR WHEN 1 THEN 'Urgencias'
																			   WHEN 2 THEN 'Consulta Externa'
																			   WHEN 3 THEN 'Nacido Hospital' 
																			   WHEN 4 THEN 'Remitido'
																			   WHEN 5 THEN 'Hospitalizacion' END) AS AMBITO,
CASE AU.SOLEXTRAM WHEN 1 THEN 'Si' ELSE 'No' END AS [SERVICIO SOLICITADO EXTRAMURAL],
CASE AU.MEDIOSERV WHEN 1 THEN 'Servicio'
				  WHEN 2 THEN 'Medicamento' END AS [TIPO AUTORIZACION],
AU.AuthorizationNumber AS [NUMERO AUTORIZACION],
BGRU.Name AS [TIPO SERVICIO],
CUPS.Code AS [CODIGO CUPS],
CUPS.[Description] AS [DESCRIPCION CUPS],
DR.Name AS [DESCRIPCION RELACIONADA],
AU.CANSERIPS AS [CANTIDAD SOLICITADO],
ISNULL(AU.CANSERAUT,0) AS [CANTIDAD AUTORIZADO],
CASE PRO.POSProduct WHEN 1 THEN 'SI'
					WHEN 0 THEN 'NO' END AS PBS,
PRO.Code AS [CODIGO MEDICAMENTO],
PRO.Name AS [MEDICAMENTO],
AU.Observations AS [OBSERVACION ANALISTA],
AU.CreationDate AS [FECHA RADICACION],
AU.RadicateNumber AS [NUMERO RADICACION],
AU.FECHAUTO AS [FECHA AUTORIZACION],
AU.AuthorizationExpiredDate AS [FECHA VENCIMIENTO AUTORIZACION],
PER.Identification AS [IDENTIFICACION AUTORIZADOR],
PER.Fullname AS [NOMBRE AUTORIZADOR],
AA.[ANALISTA ASIGNADO],
AU.JUSANULA AS [JUSTIFICACION ANULACION],
PERA.Identification AS [IDENTIFICACION ANULACION],
PERA.Fullname AS [NOMBRE ANULACION],
ING.FECHEGRESO AS [FECHA EGRESO],
CASE WHEN HCE.NUMINGRES IS NULL THEN '3- Pacientes en la unidad' ELSE '2- Pacientes alta medica' END AS [ESTADO PACIENTE], 
--IIF(AU.[ESTADO AUTORIZACION]='Solicitado','No',AU.FACTURADO) AS FACTURADO,
1 AS CANTIDAD,
CAST (ISNULL(AU.FECREGIST,HIS.FECHISPAC) AS DATE) [FECHA BUSQUEDA],
YEAR(ISNULL(AU.FECREGIST,HIS.FECHISPAC)) AS [AÑO BUSQUEDA],
MONTH(ISNULL(AU.FECREGIST,HIS.FECHISPAC)) AS [MES BUSQUEDA],
CONCAT(FORMAT(MONTH(ISNULL(AU.FECREGIST,HIS.FECHISPAC)), '00') ,' - ', 
	   CASE MONTH(ISNULL(AU.FECREGIST,HIS.FECHISPAC)) 
	        WHEN 1 THEN 'ENERO'
			WHEN 2 THEN 'FEBRERO'
			WHEN 3 THEN 'MARZO'
			WHEN 4 THEN 'ABRIL'
			WHEN 5 THEN 'MAYO'
			WHEN 6 THEN 'JUNIO'
			WHEN 7 THEN 'JULIO'
			WHEN 8 THEN 'AGOSTO'
			WHEN 9 THEN 'SEPTIEMBRE'
			WHEN 10 THEN 'OCTUBRE'
			WHEN 11 THEN 'NOVIEMBRE'
			WHEN 12 THEN 'DICIEMBRE'
		END) AS [MES NOMBRE BUSQUEDA],
DAY(ISNULL(AU.FECREGIST,HIS.FECHISPAC)) AS [DIA BUSQUEDA],
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM 
CTE_AUTORIZACIONES AU
INNER JOIN dbo.ADCENATEN CEN ON AU.CODCENATE=CEN.CODCENATE
INNER JOIN dbo.INPACIENT PAC ON AU.IPCODPACI=PAC.IPCODPACI
INNER JOIN dbo.ADTIPOIDENTIFICA TD ON PAC.IPTIPODOC=TD.CODIGO
INNER JOIN dbo.ADINGRESO ING ON AU.NUMINGRES=ING.NUMINGRES
INNER JOIN Payroll.FunctionalUnit AS UF ON AU.UFUCODIGO=UF.Code 
LEFT JOIN dbo.HCHISPACA HIS ON HIS.ID=(SELECT MIN(A.ID) FROM dbo.HCHISPACA A WHERE AU.NUMINGRES=A.NUMINGRES)--CUANDO SE REALIZA LA PRIMERA ATENCION LA TABLA dbo.ADAUTOSER NO OBTIENE TODA LA INFORMACIÓN
LEFT JOIN dbo.INPROFSAL PROF ON AU.CODPROSAL=PROF.CODPROSAL
LEFT JOIN dbo.INESPECIA ESP ON PROF.CODESPEC1=ESP.CODESPECI
LEFT JOIN dbo.INDIAGNOP DIAP ON AU.NUMINGRES=DIAP.NUMINGRES AND AU.NUMEFOLIO=DIAP.NUMEFOLIO AND DIAP.CODDIAPRI=1
LEFT JOIN dbo.INDIAGNOS DIAS ON ISNULL(DIAP.CODDIAGNO,ING.CODDIAING)=DIAS.CODDIAGNO
LEFT JOIN [Contract].CareGroup E ON ISNULL(AU.IDCareGroup,ING.GENCAREGROUP)=E.Id
LEFT JOIN [Security].[UserInt] US ON AU.CODUSUARI=US.UserCode
LEFT JOIN [Security].PersonInt PER ON US.IdPerson=PER.Id
LEFT JOIN [Security].[UserInt] USA ON AU.CODUSUANU=USA.UserCode
LEFT JOIN [Security].PersonInt PERA ON USA.IdPerson=PERA.Id
LEFT JOIN Admissions.GenderTypes GEN ON PAC.IdGenderIdentity=GEN.Id 
LEFT JOIN [Contract].CUPSEntity CUPS ON AU.CODSERIPS = CUPS.Code
LEFT JOIN Contract.ContractDescriptions DR ON AU.IDDESCRIPCIONRELACIONADA=DR.Id
LEFT JOIN Inventory.InventoryProduct PRO ON AU.CODSERIPS=PRO.Code
LEFT JOIN CTE_MANUAL_TARIFAS MT ON AU.IDCareGroup=MT.CareGroupId AND CUPS.Id=MT.CUPSEntityId AND CAST(AU.FECREGIST AS DATE) BETWEEN CAST(MT.InitialDate AS DATE) AND CAST(MT.EndDate AS DATE)
LEFT JOIN dbo.HCREGEGRE HCE ON AU.NUMINGRES=HCE.NUMINGRES
LEFT JOIN dbo.CHREGESTA HCR ON AU.CHREGESTAID=HCR.ID
LEFT JOIN Billing.BillingGroup BGRU ON CUPS.BillingGroupId=BGRU.Id
LEFT JOIN CTE_ALISTA_ASIGNADO AA ON AU.NUMINGRES=AA.AdmissionNumber
--where isnull(AU.FECREGIST,HIS.FECHISPAC) between '2025-01-01' and '2025-02-14'-- and 
--where AU.IPCODPACI='1074531869'-- AND CUPS.Code='911105'
