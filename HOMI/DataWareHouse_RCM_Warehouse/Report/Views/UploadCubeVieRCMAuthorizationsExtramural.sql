-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: UploadCubeVieRCMAuthorizationsExtramural
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [Report].[UploadCubeVieRCMAuthorizationsExtramural] AS

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
[INDIGO036].[Contract].[CareGroupDefinitionRate] AS GDR
INNER JOIN [INDIGO036].[Contract].[DefinitionRate] AS DR 
    ON GDR.DefinitionRateId=DR.Id
INNER JOIN [INDIGO036].[Contract].[DefinitionRateDetail] AS DRD 
    ON DR.Id=DRD.DefinitionRateId
),


CTE_TraceabilityPaperworkEvents_Max AS(
SELECT
A.Id,
A.AuthorizedQuantity,
A.CreationDate,
A.AuthorizationExpiredDate,
A.AuthorizationNumber,
A.CreationUser,
A.Observations,
A.RadicateNumber,
A.TraceabilityPaperworkId
FROM [INDIGO036].[Authorization].[TraceabilityPaperworkEvents] AS A
INNER JOIN (
            SELECT MAX(B.Id) AS ID
                ,B.TraceabilityPaperworkId 
            FROM [INDIGO036].[Authorization].[TraceabilityPaperworkEvents] AS B 
            GROUP BY B.TraceabilityPaperworkId) C ON A.Id=C.ID
--WHERE CAST(CreationDate AS DATE) BETWEEN @FECHAINICIAL AND @FECHAFINAL
),

CTE_TraceabilityPaperworkEvents_Min as
(
SELECT
MIN(A.Id) AS Id,
MIN(A.CreationDate) AS CreationDate,
A.TraceabilityPaperworkId
FROM [INDIGO036].[Authorization].[TraceabilityPaperworkEvents] AS A
--WHERE CAST(CreationDate AS DATE) BETWEEN @FECHAINICIAL AND @FECHAFINAL
GROUP BY A.TraceabilityPaperworkId
),

CTE_AUTORIZACIONES AS
(
-----------------------------------------------------imagenes------------------------------------------------------------------------------------------------
SELECT
    A.[AUTO] AS CODCONCEC
    ,CODSERIPS
    ,CANSERIPS
    ,TPE.AuthorizedQuantity AS CANSERAUT
    ,A.IPCODPACI
    ,NUMEFOLIO
    ,A.NUMINGRES
    ,A.CODCENATE
    ,A.UFUCODIGO
    ,A.OBSSERIPS AS JUSCLISER
    ,1 AS MEDIOSERV
    ,TP.CancellationReasonsObservations AS JUSANULA
    , 1 AS SERSUSCEP
    ,TP.CancellationUserCode AS CODUSUANU
    ,1 AS SOLEXTRAM
    ,A.FECORDMED AS FECREGIST
    ,GENCAREGROUP AS IDCareGroup,
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
				 WHEN 16 THEN 'Postergado' ELSE 'Solicitado' 
                 END AS [ESTADO AUTORIZACION],
    HA.HealthEntityCode AS [CODIGO EPS/ENTIDAD TERRITORIAL],
    RTRIM(HA.Name) AS [ENTIDAD PACIENTE],
    HA.EntityType,A.CODPROSAL,A.IDDESCRIPCIONRELACIONADA,TPEM.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber,
    TPE.CreationDate AS FECHAUTO,TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
    TPE.Observations,TPE.RadicateNumber
FROM [INDIGO036].[dbo].[HCORDIMAG] AS A 
    INNER JOIN [INDIGO036].[dbo].[ADINGRESO] AS ING 
        ON A.NUMINGRES=ING.NUMINGRES
    LEFT JOIN [INDIGO036].[Contract].[HealthAdministrator] AS HA 
        ON ING.CODENTIDA=HA.Code
    LEFT JOIN [INDIGO036].[Authorization].[TraceabilityPaperwork] AS TP 
        ON A.[AUTO]=TP.EntityId 
        AND TP.EntityName='HCORDIMAG'
    LEFT JOIN CTE_TraceabilityPaperworkEvents_Max AS TPE 
        ON TP.Id=TPE.TraceabilityPaperworkId
    LEFT JOIN CTE_TraceabilityPaperworkEvents_Min AS TPEM 
        ON TP.Id=TPEM.TraceabilityPaperworkId
WHERE A.MANEXTPRO=1 --AND CAST(A.FECORDMED AS DATE) BETWEEN @FECHAINICIAL AND @FECHAFINAL
UNION ALL
----------------------------------------------------------laboratorios-------------------------------------------------------------------------------------------
SELECT
    A.[AUTO] AS CODCONCEC
    ,CODSERIPS
    ,CANSERIPS
    ,TPE.AuthorizedQuantity AS CANSERAUT
    ,A.IPCODPACI
    ,NUMEFOLIO
    ,A.NUMINGRES
    ,A.CODCENATE
    ,A.UFUCODIGO
    ,A.OBSSERIPS AS JUSCLISER
    ,1 AS MEDIOSERV
    ,TP.CancellationReasonsObservations AS JUSANULA
    , 1 AS SERSUSCEP
    ,TP.CancellationUserCode AS CODUSUANU,
    1 AS SOLEXTRAM
    ,A.FECORDMED AS FECREGIST
    ,GENCAREGROUP AS IDCareGroup,
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
				 WHEN 16 THEN 'Postergado' ELSE 'Solicitado' 
                END AS [ESTADO AUTORIZACION],
    HA.HealthEntityCode AS [CODIGO EPS/ENTIDAD TERRITORIAL],
    RTRIM(HA.Name) AS [ENTIDAD PACIENTE],
    HA.EntityType
    , A.CODPROSAL
    ,A.IDDESCRIPCIONRELACIONADA
    ,TPEM.CreationDate
    ,TPE.AuthorizationExpiredDate
    ,TPE.AuthorizationNumber
    ,TPE.CreationDate AS FECHAUTO
    ,TPE.CreationUser AS CODUSUARI
    ,NULL AS CHREGESTAID
    ,NULL AS NUMCAMHOS
    ,NULL AS PRIORIDAD
    ,NULL AS UBICAPACI
    ,TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM [INDIGO036].[dbo].[HCORDLABO] AS A 
    INNER JOIN [INDIGO036].[dbo].[ADINGRESO] AS ING 
        ON A.NUMINGRES=ING.NUMINGRES
    LEFT JOIN [INDIGO036].[Contract].[HealthAdministrator] AS HA 
        ON ING.CODENTIDA=HA.Code
    LEFT JOIN [INDIGO036].[Authorization].[TraceabilityPaperwork] AS TP 
        ON A.[AUTO]=TP.EntityId 
        AND TP.EntityName='HCORDLABO'
    LEFT JOIN CTE_TraceabilityPaperworkEvents_Max AS TPE 
        ON TP.Id=TPE.TraceabilityPaperworkId
    LEFT JOIN CTE_TraceabilityPaperworkEvents_Min AS TPEM 
        ON TP.Id=TPEM.TraceabilityPaperworkId
WHERE A.MANEXTPRO=1 --AND CAST(A.FECORDMED AS DATE) BETWEEN @FECHAINICIAL AND @FECHAFINAL
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
HA.EntityType, A.CODPROSAL,A.IDDESCRIPCIONRELACIONADA,TPEM.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber,
TPE.CreationDate AS FECHAUTO, TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM [INDIGO036].[dbo].[HCORDPATO] AS A 
INNER JOIN [INDIGO036].[dbo].[ADINGRESO] AS ING 
    ON A.NUMINGRES=ING.NUMINGRES
LEFT JOIN [INDIGO036].[Contract].[HealthAdministrator] AS HA 
    ON ING.CODENTIDA=HA.Code
LEFT JOIN [INDIGO036].[Authorization].[TraceabilityPaperwork] AS TP 
    ON A.[AUTO]=TP.EntityId 
    AND TP.EntityName='HCORDPATO'
LEFT JOIN CTE_TraceabilityPaperworkEvents_Max AS TPE 
    ON TP.Id=TPE.TraceabilityPaperworkId
LEFT JOIN CTE_TraceabilityPaperworkEvents_Min AS TPEM 
    ON TP.Id=TPEM.TraceabilityPaperworkId
WHERE A.MANEXTPRO=1 --AND CAST(A.FECORDMED AS DATE) BETWEEN @FECHAINICIAL AND @FECHAFINAL
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
HA.EntityType, A.CODPROSAL,A.IDDESCRIPCIONRELACIONADA,TPEM.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber,
TPE.CreationDate AS FECHAUTO, TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM [INDIGO036].[dbo].[HCORDINTE] AS A 
INNER JOIN [INDIGO036].[dbo].[ADINGRESO] AS ING 
    ON A.NUMINGRES=ING.NUMINGRES 
LEFT JOIN [INDIGO036].[Contract].[HealthAdministrator] AS HA 
    ON ING.CODENTIDA=HA.Code
LEFT JOIN [INDIGO036].[Authorization].[TraceabilityPaperwork] AS TP 
    ON A.[AUTO]=TP.EntityId 
    AND TP.EntityName='HCORDINTE'
LEFT JOIN CTE_TraceabilityPaperworkEvents_Max AS TPE 
    ON TP.Id=TPE.TraceabilityPaperworkId
LEFT JOIN CTE_TraceabilityPaperworkEvents_Min AS TPEM 
    ON TP.Id=TPEM.TraceabilityPaperworkId
WHERE A.MANEXTPRO=1 --AND CAST(A.FECORDMED AS DATE) BETWEEN @FECHAINICIAL AND @FECHAFINAL
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
HA.EntityType, A.CODPROSAL,A.IDDESCRIPCIONRELACIONADA,TPEM.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber,
TPE.CreationDate AS FECHAUTO,TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM [INDIGO036].[dbo].[HCORDPRON] AS A 
    INNER JOIN [INDIGO036].[dbo].[ADINGRESO] AS ING 
        ON A.NUMINGRES=ING.NUMINGRES
    LEFT JOIN [INDIGO036].[Contract].[HealthAdministrator] AS HA 
        ON ING.CODENTIDA=HA.Code
    LEFT JOIN [INDIGO036].[Authorization].[TraceabilityPaperwork] AS TP 
        ON A.[AUTO]=TP.EntityId 
        AND TP.EntityName='HCORDPRON'
    LEFT JOIN CTE_TraceabilityPaperworkEvents_Max AS TPE 
        ON TP.Id=TPE.TraceabilityPaperworkId
    LEFT JOIN CTE_TraceabilityPaperworkEvents_Min AS TPEM 
        ON TP.Id=TPEM.TraceabilityPaperworkId
WHERE A.MANEXTPRO=1 --AND CAST(A.FECORDMED AS DATE) BETWEEN @FECHAINICIAL AND @FECHAFINAL
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
HA.EntityType, A.CODPROSAL,A.IDDESCRIPCIONRELACIONADA,TPEM.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber,
TPE.CreationDate AS FECHAUTO,TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM [INDIGO036].[dbo].[HCORDPROQ] AS A 
    INNER JOIN [INDIGO036].[dbo].[ADINGRESO] AS ING 
        ON A.NUMINGRES=ING.NUMINGRES
    LEFT JOIN [INDIGO036].[Contract].[HealthAdministrator] AS HA 
        ON ING.CODENTIDA=HA.Code
    LEFT JOIN [INDIGO036].[Authorization].[TraceabilityPaperwork] AS TP 
        ON A.[AUTO]=TP.EntityId 
        AND TP.EntityName='HCORDPROQ'
    LEFT JOIN CTE_TraceabilityPaperworkEvents_Max AS TPE 
        ON TP.Id=TPE.TraceabilityPaperworkId
    LEFT JOIN CTE_TraceabilityPaperworkEvents_Min AS TPEM 
        ON TP.Id=TPEM.TraceabilityPaperworkId
--WHERE A.MANEXTPRO=1 AND CAST(A.FECORDMED AS DATE) BETWEEN @FECHAINICIAL AND @FECHAFINAL
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
TPEM.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber
,TPE.CreationDate AS FECHAUTO,TPE.CreationUser AS CODUSUARI,
NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM [INDIGO036].[dbo].[HCORHEMCO] AS  A 
    INNER JOIN [INDIGO036].[dbo].[HCORHEMSER] AS B 
        ON A.ID=B.HCORHEMCOID
    INNER JOIN [INDIGO036].[dbo].[ADINGRESO] AS ING 
        ON A.NUMINGRES=ING.NUMINGRES
    LEFT JOIN [INDIGO036].[dbo].[HCORHEMBOL] AS C 
        ON B.HCORHEMBOLID=C.ID
    LEFT JOIN [INDIGO036].[Contract].[HealthAdministrator] AS HA 
        ON ING.CODENTIDA=HA.Code
    LEFT JOIN [INDIGO036].[Authorization].[TraceabilityPaperwork] AS TP 
        ON A.ID=TP.EntityId 
        AND TP.EntityName='HCORHEMCO'
    LEFT JOIN CTE_TraceabilityPaperworkEvents_Max AS TPE 
        ON TP.Id=TPE.TraceabilityPaperworkId
    LEFT JOIN CTE_TraceabilityPaperworkEvents_Min AS TPEM 
        ON TP.Id=TPEM.TraceabilityPaperworkId
WHERE A.MANEXTPRO=1 --AND CAST(A.FECORDMED AS DATE) BETWEEN @FECHAINICIAL AND @FECHAFINAL
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
HA.EntityType, B.CODPROSAL, NULL AS IDDESCRIPCIONRELACIONADA,TPEM.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber,
TPE.CreationDate AS FECHAUTO, TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM [INDIGO036].[EHR].[HCORMEDICAMESQUEMA] AS A 
    INNER JOIN  [INDIGO036].[EHR].[HCORDQUIMIO] AS B 
        ON A.IDHCORDQUIMIO=B.ID
    INNER JOIN [INDIGO036].[dbo].[HCPRESCRA] AS C 
        ON A.IDHCORDQUIMIO=C.IDHCORDQUIMIO
    INNER JOIN [INDIGO036].[dbo].[ADINGRESO] AS ING 
        ON B.NUMINGRES=ING.NUMINGRES
    LEFT JOIN [INDIGO036].[Contract].[HealthAdministrator] AS HA 
        ON ING.CODENTIDA=HA.Code
    LEFT JOIN [INDIGO036].[Authorization].[TraceabilityPaperwork] AS TP 
        ON A.ID=TP.EntityId 
        AND TP.EntityName='HCORMEDICAMESQUEMA'
    LEFT JOIN CTE_TraceabilityPaperworkEvents_Max AS TPE 
        ON TP.Id=TPE.TraceabilityPaperworkId
    LEFT JOIN CTE_TraceabilityPaperworkEvents_Min AS TPEM 
        ON TP.Id=TPEM.TraceabilityPaperworkId
WHERE B.MANEJOEXTERNO=1 --AND CAST(C.FECINIDOS AS DATE) BETWEEN @FECHAINICIAL AND @FECHAFINAL
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
HA.EntityType, B.CODPROSAL, A.IDDESCRIPCIONRELACIONADA,TPEM.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber,
TPE.CreationDate AS FECHAUTO,TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM [INDIGO036].[dbo].[HCDESCOEX] AS A 
    INNER JOIN [INDIGO036].[dbo].[ADINGRESO] AS ING 
        ON A.NUMINGRES=ING.NUMINGRES
    INNER JOIN [INDIGO036].[dbo].[HCHISPACA] AS B 
        ON A.NUMINGRES=B.NUMINGRES 
        AND A.NUMEFOLIO=B.NUMEFOLIO
    LEFT JOIN [INDIGO036].[Contract].[HealthAdministrator] AS HA 
        ON ING.CODENTIDA=HA.Code
    LEFT JOIN [INDIGO036].[Authorization].[TraceabilityPaperwork] AS TP 
        ON A.[AUTO]=TP.EntityId 
        AND TP.EntityName='HCDESCOEX'
    LEFT JOIN CTE_TraceabilityPaperworkEvents_Max AS TPE 
        ON TP.Id=TPE.TraceabilityPaperworkId
    LEFT JOIN CTE_TraceabilityPaperworkEvents_Min AS TPEM 
        ON TP.Id=TPEM.TraceabilityPaperworkId
WHERE ING.IINGREPOR=2 --AND CAST(B.FECHISPAC AS DATE) BETWEEN @FECHAINICIAL AND @FECHAFINAL
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
HA.EntityType, A.CODPROSAL,NULL AS IDDESCRIPCIONRELACIONADA,TPEM.CreationDate,TPE.AuthorizationExpiredDate,TPE.AuthorizationNumber
,TPE.CreationDate AS FECHAUTO,TPE.CreationUser AS CODUSUARI,NULL AS CHREGESTAID,NULL AS NUMCAMHOS,NULL AS PRIORIDAD,NULL AS UBICAPACI,
TPE.Observations,TPE.RadicateNumber--,
--CASE WHEN FAC.Id IS NULL THEN 'NO' ELSE 'SI' END AS FACTURADO
FROM [INDIGO036].[dbo].[HCPRESCRA] AS A 
    INNER JOIN [INDIGO036].[dbo].[ADINGRESO] AS ING 
        ON A.NUMINGRES=ING.NUMINGRES
    LEFT JOIN [INDIGO036].[Contract].[HealthAdministrator] AS HA 
        ON ING.CODENTIDA=HA.Code
    LEFT JOIN [INDIGO036].[Authorization].[TraceabilityPaperwork] AS TP 
        ON A.ID=TP.EntityId 
        AND TP.EntityName='HCPRESCRA'
    LEFT JOIN CTE_TraceabilityPaperworkEvents_Max AS TPE 
        ON TP.Id=TPE.TraceabilityPaperworkId
    LEFT JOIN CTE_TraceabilityPaperworkEvents_Min AS TPEM 
        ON TP.Id=TPEM.TraceabilityPaperworkId
WHERE A.MANEXTPRO=1 --AND CAST(A.FECINIDOS AS DATE) BETWEEN @FECHAINICIAL AND @FECHAFINAL
),
---------------------En este CTE trae el ultimo analista de autorizaciones que se asigna por ingreso-------------------------------------
CTE_ALISTA_ASIGNADO AS
(
SELECT 
MIAU.AdmissionNumber,
CAST(MIAU.UserId AS VARCHAR(6))+'-'+MIPER.Fullname AS [ANALISTA ASIGNADO]
FROM [INDIGO036].[Authorization].[MyAdmissionsByUsers] AS MIAU 
    INNER JOIN [INDIGO036].[Security].[UserInt] AS MIUSA 
        ON MIAU.UserId=MIUSA.Id 
    INNER JOIN [INDIGO036].[Security].[PersonInt] AS MIPER 
        ON MIUSA.IdPerson=MIPER.Id
WHERE MIAU.Id=(
                SELECT MAX(A.Id) 
                FROM [INDIGO036].[Authorization].[MyAdmissionsByUsers] AS A 
                WHERE MIAU.AdmissionNumber=A.AdmissionNumber
               ) 
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
AU.FECREGIST AS [FECHA SOLICITUD],
RTRIM(PROF.CODUSUARI)+' - '+PROF.NOMMEDICO AS [PROFESIONAL ORDEN],
ESP.DESESPECI AS [ESPECIALIDAD ORDEN],
AU.JUSCLISER AS [JUSTIFICACION CLINICA],
AU.NUMEFOLIO AS [NUMERO FOLIO],
AU.NUMINGRES AS [NUMERO INGRESO],
DIAS.CODDIAGNO+' - ' +DIAS.NOMDIAGNO AS [DIAGNOSTICO PRINCIPAL],
CAST(AU.CODCONCEC AS NUMERIC(18,0)) AS [CONSECUTIVO AUTORIZACION],
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
CAST(AU.CreationDate AS DATETIME) AS [FECHA RADICACION],
AU.RadicateNumber AS [NUMERO RADICACION],
AU.FECHAUTO AS [FECHA AUTORIZACION],
CAST(AU.AuthorizationExpiredDate AS DATETIME) AS [FECHA VENCIMIENTO AUTORIZACION],
PER.Identification AS [IDENTIFICACION AUTORIZADOR],
PER.Fullname AS [NOMBRE AUTORIZADOR],
AA.[ANALISTA ASIGNADO],
AU.JUSANULA AS [JUSTIFICACION ANULACION],
PERA.Identification AS [IDENTIFICACION ANULACION],
PERA.Fullname AS [NOMBRE ANULACION],
ING.FECHEGRESO AS [FECHA EGRESO],
CASE WHEN HCE.NUMINGRES IS NULL THEN '3- Pacientes en la unidad' ELSE '2- Pacientes alta medica' END AS [ESTADO PACIENTE], 
1 AS CANTIDAD,
CAST (AU.FECREGIST AS DATE) [FECHA BUSQUEDA],
YEAR(AU.FECREGIST) AS [AÑO BUSQUEDA],
MONTH(AU.FECREGIST) AS [MES BUSQUEDA],
CONCAT(FORMAT(MONTH(AU.FECREGIST), '00') ,' - ', 
	   CASE MONTH(AU.FECREGIST) 
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
    DAY(AU.FECREGIST) AS [DIA BUSQUEDA],
    CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM CTE_AUTORIZACIONES AS AU
    INNER JOIN [INDIGO036].[dbo].[ADCENATEN] AS CEN 
        ON AU.CODCENATE=CEN.CODCENATE
    INNER JOIN [INDIGO036].[dbo].[INPACIENT] AS PAC 
        ON AU.IPCODPACI=PAC.IPCODPACI
    INNER JOIN [INDIGO036].[dbo].[ADTIPOIDENTIFICA] AS TD 
        ON PAC.IPTIPODOC=TD.CODIGO
    INNER JOIN [INDIGO036].[dbo].[ADINGRESO] AS ING 
        ON AU.NUMINGRES=ING.NUMINGRES
    INNER JOIN [INDIGO036].[Payroll].[FunctionalUnit] AS UF 
        ON AU.UFUCODIGO=UF.Code 
    LEFT JOIN [INDIGO036].[dbo].[INPROFSAL] AS PROF 
        ON AU.CODPROSAL=PROF.CODPROSAL
    LEFT JOIN [INDIGO036].[dbo].[INESPECIA] AS ESP 
        ON PROF.CODESPEC1=ESP.CODESPECI
    LEFT JOIN [INDIGO036].[dbo].[INDIAGNOP] AS DIAP 
        ON AU.NUMINGRES=DIAP.NUMINGRES 
        AND AU.NUMEFOLIO=DIAP.NUMEFOLIO 
        AND DIAP.CODDIAPRI=1
    LEFT JOIN [INDIGO036].[dbo].[INDIAGNOS] AS DIAS 
        ON ISNULL(DIAP.CODDIAGNO,ING.CODDIAING)=DIAS.CODDIAGNO
    LEFT JOIN [INDIGO036].[Contract].[CareGroup] AS E 
        ON ISNULL(AU.IDCareGroup,ING.GENCAREGROUP)=E.Id
    LEFT JOIN [INDIGO036].[Security].[UserInt] AS US 
        ON AU.CODUSUARI=US.UserCode
    LEFT JOIN [INDIGO036].[Security].[PersonInt] AS PER 
        ON US.IdPerson=PER.Id
    LEFT JOIN [INDIGO036].[Security].[UserInt]  AS USA 
        ON AU.CODUSUANU=USA.UserCode
    LEFT JOIN [INDIGO036].[Security].[PersonInt] AS PERA 
        ON USA.IdPerson=PERA.Id
    LEFT JOIN [INDIGO036].[Admissions].[GenderTypes] AS GEN 
        ON PAC.IdGenderIdentity=GEN.Id 
    LEFT JOIN [INDIGO036].[Contract].[CUPSEntity] AS CUPS 
        ON AU.CODSERIPS = CUPS.Code
    LEFT JOIN [INDIGO036].[Contract].[ContractDescriptions] AS DR 
        ON AU.IDDESCRIPCIONRELACIONADA=DR.Id
    LEFT JOIN [INDIGO036].[Inventory].[InventoryProduct] AS PRO 
        ON AU.CODSERIPS=PRO.Code
    LEFT JOIN CTE_MANUAL_TARIFAS AS MT 
        ON AU.IDCareGroup=MT.CareGroupId 
        AND CUPS.Id=MT.CUPSEntityId 
        AND CAST(AU.FECREGIST AS DATE) BETWEEN CAST(MT.InitialDate AS DATE) 
        AND CAST(MT.EndDate AS DATE)
    LEFT JOIN [INDIGO036].[dbo].[HCREGEGRE] AS HCE 
        ON AU.NUMINGRES=HCE.NUMINGRES
    LEFT JOIN [INDIGO036].[dbo].[CHREGESTA] AS HCR 
        ON AU.CHREGESTAID=HCR.ID
    LEFT JOIN [INDIGO036].[Billing].[BillingGroup] AS BGRU 
        ON CUPS.BillingGroupId=BGRU.Id
    LEFT JOIN CTE_ALISTA_ASIGNADO AS AA 
        ON AU.NUMINGRES=AA.AdmissionNumber
