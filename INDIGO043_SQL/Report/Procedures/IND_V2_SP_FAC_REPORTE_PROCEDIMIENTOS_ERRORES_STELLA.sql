-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_V2_SP_FAC_REPORTE_PROCEDIMIENTOS_ERRORES_STELLA
-- Extracted by Fabric SQL Extractor SPN v3.9.0


/*******************************************************************************************************************
Nombre: [Report].[View_FAC_REPORTE_IMAGENES_POR_RECONOCER_HOS]
Tipo:Vista
Observacion:Informe sobre errores de STELLA, que se obtuvieron al querer reconocer servicios en el control de cuentas
Profesional: 
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:31-01-2024
Ovservaciones:Se agrega los siguentes campos al reporte: JUSTIFICADO y JUSTIFICACIÓN, esto solicitado por el hospital de San Jose.
--------------------------------------
Version 3
Persona que modifico:
Fecha:
Observaciones:
***********************************************************************************************************************************/


CREATE PROCEDURE [Report].[IND_V2_SP_FAC_REPORTE_PROCEDIMIENTOS_ERRORES_STELLA]
AS

WITH CTE_LABORATORIOS
AS
(
  SELECT CASE BSPL.DataSourceType WHEN 1 THEN 'LABORATORIOS' WHEN 2 THEN 'IMAGENES' WHEN 3 THEN 'PATOLOGIA' WHEN 4 THEN 'PROCEDIMIENTOS NO QX' WHEN 12 THEN 'ESTANCIAS' 
  WHEN 6 THEN 'TERAPIAS'  END TIPO,
  lab.ipcodpaci as 'IDENTIFICACION',PAC.IPNOMCOMP 'PACIENTE',
  BSPL.Row,lab.CODSERIPS as 'CUPS',CUPS.DESSERIPS 'DESCRIPCION CUPS',LAB.NUMINGRES 'INGRESO',
  (SELECT top 1 AdmissionNumber FROM OPENJSON(BSPL.Data, N'$')WITH (AdmissionNumber VARCHAR(200) N'$.AdmissionNumber')) as IngresoJSON,
  --(SELECT top 1 CareGroupId FROM OPENJSON(BSPL.Data, N'$')WITH (CareGroupId VARCHAR(200) N'$.CareGroupId')) nn,
  CG.code 'CODIGO GRUPO ATENCION', CG.NAME 'GRUPO ATENCION',
  BSPL.CreationDate 'FECHA STELLA ORDEN',BSPL.Message 'MENSAJE DE ERROR',
  /*IN V2*/IIF(JUS.ID IS NULL,'NO','SI') AS JUSTIFICADO,
  JCON.Description AS JUSTIFICACIÓN/*FN V2*/
  FROM 
  Billing.BotServicesProceduresLog BSPL
  INNER JOIN DBO.HCORDLABO LAB ON cast(LAB.AUTO as nvarchar(max)) =BSPL.Row and lab.GENSERVICEORDER is null
  INNER JOIN DBO.INPACIENT AS PAC ON PAC.IPCODPACI=LAB.IPCODPACI
  INNER JOIN DBO.INCUPSIPS AS CUPS ON CUPS.CODSERIPS=LAB.CODSERIPS
  INNER JOIN DBO.ADINGRESO AS ING ON ING.NUMINGRES=(SELECT top 1 AdmissionNumber FROM OPENJSON(BSPL.Data, N'$')WITH (AdmissionNumber VARCHAR(200) N'$.AdmissionNumber')) 
  INNER JOIN CONTRACT.CareGroup as CG on CG.id=(SELECT top 1 CareGroupId FROM OPENJSON(BSPL.Data, N'$')WITH (CareGroupId VARCHAR(200) N'$.CareGroupId'))
  /*IN V2*/LEFT JOIN Billing.AccountControlJustification JUS ON LAB.[AUTO]=JUS.EntityId AND JUS.EntityName='HCORDLABO'
  LEFT JOIN Billing.BillingJustificationControl JCON ON JUS.JustificationId=JCON.Id/*FN V2*/
  where 
  BSPL.State =0 AND BSPL.DataSourceType=1 and BSPL.CreationDate>='2023-11-01 00:00:00' and BSPL.Message<>'El registro se envió. Esperando respuesta...'
  AND ING.IESTADOIN IN ('','P')
),

CTE_IMAGENES
AS
(
  SELECT CASE BSPL.DataSourceType WHEN 1 THEN 'LABORATORIOS' WHEN 2 THEN 'IMAGENES' WHEN 3 THEN 'PATOLOGIA' WHEN 4 THEN 'PROCEDIMIENTOS NO QX' WHEN 12 THEN 'ESTANCIAS' 
  WHEN 6 THEN 'TERAPIAS' END TIPO,
  IMG.ipcodpaci as 'IDENTIFICACION',PAC.IPNOMCOMP 'PACIENTE',
  BSPL.Row,IMG.CODSERIPS as 'CUPS',CUPS.DESSERIPS 'DESCRIPCION CUPS',IMG.NUMINGRES 'INGRESO',
  (SELECT top 1 AdmissionNumber FROM OPENJSON(BSPL.Data, N'$')WITH (AdmissionNumber VARCHAR(200) N'$.AdmissionNumber')) as IngresoJSON,
  --(SELECT top 1 CareGroupId FROM OPENJSON(BSPL.Data, N'$')WITH (CareGroupId VARCHAR(200) N'$.CareGroupId')) nn,
  CG.code 'CODIGO GRUPO ATENCION', CG.NAME 'GRUPO ATENCION',
  BSPL.CreationDate 'FECHA STELLA ORDEN',BSPL.Message AS 'MENSAJE DE ERROR',
  /*IN V2*/IIF(JUS.ID IS NULL,'NO','SI') AS JUSTIFICADO,
  JCON.Description AS JUSTIFICACIÓN/*FN V2*/
  FROM 
  Billing.BotServicesProceduresLog  BSPL
  INNER JOIN DBO.HCORDIMAG IMG ON cast(IMG.AUTO as nvarchar(max))=BSPL.Row and IMG.GENSERVICEORDER is null
  INNER JOIN DBO.INPACIENT AS PAC ON PAC.IPCODPACI=IMG.IPCODPACI
  INNER JOIN DBO.INCUPSIPS AS CUPS ON CUPS.CODSERIPS=IMG.CODSERIPS
  INNER JOIN DBO.ADINGRESO AS ING ON ING.NUMINGRES=(SELECT top 1 AdmissionNumber FROM OPENJSON(BSPL.Data, N'$')WITH (AdmissionNumber VARCHAR(200) N'$.AdmissionNumber')) 
  INNER JOIN CONTRACT.CareGroup as CG on CG.id=(SELECT top 1 CareGroupId FROM OPENJSON(BSPL.Data, N'$')WITH (CareGroupId VARCHAR(200) N'$.CareGroupId'))
  /*IN V2*/LEFT JOIN Billing.AccountControlJustification JUS ON IMG.[AUTO]=JUS.EntityId AND JUS.EntityName='HCORDIMAG'
  LEFT JOIN Billing.BillingJustificationControl JCON ON JUS.JustificationId=JCON.Id/*FN V2*/
  where 
  BSPL.State =0 AND BSPL.DataSourceType=2 and BSPL.CreationDate>='2023-11-01 00:00:00' and BSPL.Message<>'El registro se envió. Esperando respuesta...'
  AND ING.IESTADOIN IN ('','P')
),

CTE_PATOLOGIAS
AS
(
  SELECT CASE BSPL.DataSourceType WHEN 1 THEN 'LABORATORIOS' WHEN 2 THEN 'IMAGENES' WHEN 3 THEN 'PATOLOGIA' WHEN 4 THEN 'PROCEDIMIENTOS NO QX' WHEN 12 THEN 'ESTANCIAS' 
  WHEN 6 THEN 'TERAPIAS' END TIPO,
  PAT.ipcodpaci as 'IDENTIFICACION',PAC.IPNOMCOMP 'PACIENTE',
  BSPL.Row,PAT.CODSERIPS as 'CUPS',CUPS.DESSERIPS 'DESCRIPCION CUPS',PAT.NUMINGRES 'INGRESO',
  (SELECT top 1 AdmissionNumber FROM OPENJSON(BSPL.Data, N'$')WITH (AdmissionNumber VARCHAR(200) N'$.AdmissionNumber')) as IngresoJSON,
  --(SELECT top 1 CareGroupId FROM OPENJSON(BSPL.Data, N'$')WITH (CareGroupId VARCHAR(200) N'$.CareGroupId')) nn,
  CG.code 'CODIGO GRUPO ATENCION', CG.NAME 'GRUPO ATENCION',
  BSPL.CreationDate 'FECHA STELLA ORDEN',BSPL.Message 'MENSAJE DE ERROR',
  /*IN V2*/IIF(JUS.ID IS NULL,'NO','SI') AS JUSTIFICADO,
  JCON.Description AS JUSTIFICACIÓN/*FN V2*/
  FROM 
  Billing .BotServicesProceduresLog  BSPL
  INNER JOIN DBO.HCORDPATO PAT ON cast(PAT.AUTO as nvarchar(max)) =BSPL.Row and PAT.GENSERVICEORDER is null
  INNER JOIN DBO.INPACIENT AS PAC ON PAC.IPCODPACI=PAT.IPCODPACI
  INNER JOIN DBO.INCUPSIPS AS CUPS ON CUPS.CODSERIPS=PAT.CODSERIPS  and CUPS.TIPSERIPS='2'
  INNER JOIN DBO.ADINGRESO AS ING ON ING.NUMINGRES=(SELECT top 1 AdmissionNumber FROM OPENJSON(BSPL.Data, N'$')WITH (AdmissionNumber VARCHAR(200) N'$.AdmissionNumber')) 
  INNER JOIN CONTRACT.CareGroup as CG on CG.id=(SELECT top 1 CareGroupId FROM OPENJSON(BSPL.Data, N'$')WITH (CareGroupId VARCHAR(200) N'$.CareGroupId'))
  /*IN V2*/LEFT JOIN Billing.AccountControlJustification JUS ON PAT.[AUTO]=JUS.EntityId AND JUS.EntityName='HCORDPATO'
  LEFT JOIN Billing.BillingJustificationControl JCON ON JUS.JustificationId=JCON.Id/*FN V2*/
  where 
  BSPL.State =0 AND BSPL.DataSourceType=3 and BSPL.CreationDate>='2023-11-01 00:00:00' and BSPL.Message<>'El registro se envió. Esperando respuesta...'
  AND ING.IESTADOIN IN ('','P')
),

CTE_PROCEDIMIENTOS_NO_QX
AS
(
  SELECT CASE BSPL.DataSourceType WHEN 1 THEN 'LABORATORIOS' WHEN 2 THEN 'IMAGENES' WHEN 3 THEN 'PATOLOGIA' WHEN 4 THEN 'PROCEDIMIENTOS NO QX' WHEN 12 THEN 'ESTANCIAS' 
  WHEN 6 THEN 'TERAPIAS' END TIPO,
  NOQX.ipcodpaci as 'IDENTIFICACION',PAC.IPNOMCOMP 'PACIENTE',
  BSPL.Row,NOQX.CODSERIPS as 'CUPS',CUPS.DESSERIPS 'DESCRIPCION CUPS',NOQX.NUMINGRES 'INGRESO',
  (SELECT top 1 AdmissionNumber FROM OPENJSON(BSPL.Data, N'$')WITH (AdmissionNumber VARCHAR(200) N'$.AdmissionNumber')) as IngresoJSON,
  --(SELECT top 1 CareGroupId FROM OPENJSON(BSPL.Data, N'$')WITH (CareGroupId VARCHAR(200) N'$.CareGroupId')) nn,
  CG.code 'CODIGO GRUPO ATENCION', CG.NAME 'GRUPO ATENCION',
  BSPL.CreationDate 'FECHA STELLA ORDEN',BSPL.Message 'MENSAJE DE ERROR',
  /*IN V2*/IIF(JUS.ID IS NULL,'NO','SI') AS JUSTIFICADO,
  JCON.Description AS JUSTIFICACIÓN/*FN V2*/
  FROM 
  Billing .BotServicesProceduresLog  BSPL
  INNER JOIN DBO.HCORDPRON NOQX ON cast(NOQX.AUTO as nvarchar(max)) =BSPL.Row and NOQX.GENSERVICEORDER is null
  INNER JOIN DBO.INPACIENT AS PAC ON PAC.IPCODPACI=NOQX.IPCODPACI
  INNER JOIN DBO.INCUPSIPS AS CUPS ON CUPS.CODSERIPS=NOQX.CODSERIPS -- and CUPS.TIPSERIPS='2'
  INNER JOIN DBO.ADINGRESO AS ING ON ING.NUMINGRES=(SELECT top 1 AdmissionNumber FROM OPENJSON(BSPL.Data, N'$')WITH (AdmissionNumber VARCHAR(200) N'$.AdmissionNumber')) 
  INNER JOIN CONTRACT.CareGroup as CG on CG.id=(SELECT top 1 CareGroupId FROM OPENJSON(BSPL.Data, N'$')WITH (CareGroupId VARCHAR(200) N'$.CareGroupId'))
  /*IN V2*/LEFT JOIN Billing.AccountControlJustification JUS ON NOQX.[AUTO]=JUS.EntityId AND JUS.EntityName='HCORDPRON'
  LEFT JOIN Billing.BillingJustificationControl JCON ON JUS.JustificationId=JCON.Id/*FN V2*/
  where 
  BSPL.State =0 AND BSPL.DataSourceType=4 and BSPL.CreationDate>='2023-11-01 00:00:00' and BSPL.Message<>'El registro se envió. Esperando respuesta...'
  AND ING.IESTADOIN IN ('','P')
),

CTE_TERAPIAS
AS
(
  SELECT CASE BSPL.DataSourceType WHEN 1 THEN 'LABORATORIOS' WHEN 2 THEN 'IMAGENES' WHEN 3 THEN 'PATOLOGIA' WHEN 4 THEN 'PROCEDIMIENTOS NO QX' WHEN 12 THEN 'ESTANCIAS' 
  WHEN 6 THEN 'TERAPIAS' END TIPO,
  TER.ipcodpaci as 'IDENTIFICACION',PAC.IPNOMCOMP 'PACIENTE',
  BSPL.Row,TER.CODSERIPS as 'CUPS',CUPS.DESSERIPS 'DESCRIPCION CUPS',TER.NUMINGRES 'INGRESO',
  (SELECT top 1 AdmissionNumber FROM OPENJSON(BSPL.Data, N'$')WITH (AdmissionNumber VARCHAR(200) N'$.AdmissionNumber')) as IngresoJSON,
  --(SELECT top 1 CareGroupId FROM OPENJSON(BSPL.Data, N'$')WITH (CareGroupId VARCHAR(200) N'$.CareGroupId')) nn,
  CG.code 'CODIGO GRUPO ATENCION', CG.NAME 'GRUPO ATENCION',
  BSPL.CreationDate 'FECHA STELLA ORDEN',BSPL.Message 'MENSAJE DE ERROR',
  /*IN V2*/IIF(JUS.ID IS NULL,'NO','SI') AS JUSTIFICADO,
  JCON.Description AS JUSTIFICACIÓN/*FN V2*/
  FROM 
  Billing .BotServicesProceduresLog  BSPL
  INNER JOIN DBO.HCPROCTER TER ON cast(TER.CODCONSEC as nvarchar(max)) =BSPL.Row and TER.GENSERVICEORDER is null
  INNER JOIN DBO.INPACIENT AS PAC ON PAC.IPCODPACI=TER.IPCODPACI
  INNER JOIN DBO.INCUPSIPS AS CUPS ON CUPS.CODSERIPS=TER.CODSERIPS -- and CUPS.TIPSERIPS='2'
  INNER JOIN DBO.ADINGRESO AS ING ON ING.NUMINGRES=(SELECT top 1 AdmissionNumber FROM OPENJSON(BSPL.Data, N'$')WITH (AdmissionNumber VARCHAR(200) N'$.AdmissionNumber')) 
  INNER JOIN CONTRACT.CareGroup as CG on CG.id=(SELECT top 1 CareGroupId FROM OPENJSON(BSPL.Data, N'$')WITH (CareGroupId VARCHAR(200) N'$.CareGroupId'))
  /*IN V2*/LEFT JOIN Billing.AccountControlJustification JUS ON TER.CODCONSEC=JUS.EntityId AND JUS.EntityName='HCPROCTER'
  LEFT JOIN Billing.BillingJustificationControl JCON ON JUS.JustificationId=JCON.Id/*FN V2*/
  where 
  BSPL.State =0 AND BSPL.DataSourceType=6 and BSPL.CreationDate>='2023-11-01 00:00:00' and BSPL.Message<>'El registro se envió. Esperando respuesta...'
  AND ING.IESTADOIN IN ('','P')
),

CTE_OXIGENO
AS
(
  SELECT CASE BSPL.DataSourceType WHEN 1 THEN 'LABORATORIOS' WHEN 2 THEN 'IMAGENES' WHEN 3 THEN 'PATOLOGIA' WHEN 4 THEN 'PROCEDIMIENTOS NO QX' WHEN 12 THEN 'ESTANCIAS' 
  WHEN 6 THEN 'TERAPIAS' WHEN 8 THEN 'OXIGENO' END TIPO,
  OXI.ipcodpaci as 'IDENTIFICACION',PAC.IPNOMCOMP 'PACIENTE',
  BSPL.Row,E.CODSERIPS as 'CUPS',CUPS.DESSERIPS 'DESCRIPCION CUPS',OXI.NUMINGRES 'INGRESO',
  (SELECT top 1 AdmissionNumber FROM OPENJSON(BSPL.Data, N'$')WITH (AdmissionNumber VARCHAR(200) N'$.AdmissionNumber')) as IngresoJSON,
  --(SELECT top 1 CareGroupId FROM OPENJSON(BSPL.Data, N'$')WITH (CareGroupId VARCHAR(200) N'$.CareGroupId')) nn,
  CG.code 'CODIGO GRUPO ATENCION', CG.NAME 'GRUPO ATENCION',
  BSPL.CreationDate 'FECHA STELLA ORDEN',BSPL.Message 'MENSAJE DE ERROR',
  /*IN V2*/IIF(JUS.ID IS NULL,'NO','SI') AS JUSTIFICADO,
  JCON.Description AS JUSTIFICACIÓN/*FN V2*/
  FROM 
  Billing .BotServicesProceduresLog  BSPL
  INNER JOIN DBO.HCCONOXIG OXI ON cast(OXI.IDCONOXIG as nvarchar(max)) =BSPL.Row and OXI.GENSERVICEORDER is null
  INNER JOIN dbo.HCPARCONO E ON E.CODVIAADM=OXI.CODVIAADM
  INNER JOIN DBO.INPACIENT AS PAC ON PAC.IPCODPACI=OXI.IPCODPACI
  INNER JOIN DBO.INCUPSIPS AS CUPS ON CUPS.CODSERIPS=E.CODSERIPS -- and CUPS.TIPSERIPS='2'
  INNER JOIN DBO.ADINGRESO AS ING ON ING.NUMINGRES=(SELECT top 1 AdmissionNumber FROM OPENJSON(BSPL.Data, N'$')WITH (AdmissionNumber VARCHAR(200) N'$.AdmissionNumber')) 
  INNER JOIN CONTRACT.CareGroup as CG on CG.id=(SELECT top 1 CareGroupId FROM OPENJSON(BSPL.Data, N'$')WITH (CareGroupId VARCHAR(200) N'$.CareGroupId'))
  /*IN V2*/LEFT JOIN Billing.AccountControlJustification JUS ON OXI.IDCONOXIG=JUS.EntityId AND JUS.EntityName='HCCONOXIG'
  LEFT JOIN Billing.BillingJustificationControl JCON ON JUS.JustificationId=JCON.Id/*FN V2*/
  where 
  BSPL.State =0 AND BSPL.DataSourceType=8 and BSPL.CreationDate>='2023-11-01 00:00:00' and BSPL.Message<>'El registro se envió. Esperando respuesta...'
  AND ING.IESTADOIN IN ('','P')
)

--select * from dbo.incupsips where codserips='901210              '

SELECT * FROM CTE_LABORATORIOS 
UNION ALL
SELECT * FROM CTE_IMAGENES 
UNION ALL
SELECT * FROM CTE_PATOLOGIAS
UNION ALL
SELECT * FROM CTE_PROCEDIMIENTOS_NO_QX
UNION ALL
SELECT * FROM CTE_TERAPIAS
UNION ALL
SELECT * FROM CTE_OXIGENO


--SELECT DISTINCT DataSourceType FROM Billing .BotServicesProceduresLog BSPL WHERE STATE=0


--select * from Billing .BotServicesProceduresLog BSPL where DataSourceType=8 AND STATE=0



--SELECT * FROM DBO.HCORDPRON WHERE AUTO=17004


--select * from dbo.HCPROCTER

--select * from dbo.HCCONOXIG
