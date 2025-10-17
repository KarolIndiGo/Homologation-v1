-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: UploadVieClinicalConventionalImaging
-- Extracted by Fabric SQL Extractor SPN v3.9.0


    /*******************************************************************************************************************
Nombre: [Report].[Report].[UploadVieClinicalConventionalImaging]
Tipo:Vista
Observacion:Ordenamientos de imagenes con estado para realizar integración con datos de indira
Profesional:Andres Cabrera
Fecha:09-08-2024
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:
Fecha:
Ovservaciones:
--------------------------------------
Version 3
Persona que modifico:
Observacion:
Fecha:
--***********************************************************************************************************************************/
CREATE VIEW [Report].[UploadVieClinicalConventionalImaging] as

WITH CTE_CUPS
AS
(
   SELECT 
   CUPS.Id,CUPS.Code, CUPS.Description, 
   CASE CUPS.ServiceType WHEN 1 then 'LABORATORIOS' WHEN 2 then 'PATOLOGIAS' WHEN 3 then 'IMAGENES DIAGNOSTICAS' WHEN 4 then 'PROCEDIMIENTOS NO QX'
   WHEN 5 then 'PROCEDIMIENTOS QX' WHEN 6 then 'INTERCONSULTAS'WHEN 7 then 'NINGUNO'WHEN 8 then 'CONSULTA EXTERNA' ELSE 'OTROS' END AS 'TIPO SERVICIO',
   BG.CODE 'CODIGO FACTURACION', BG.NAME 'GRUPO FACTURACION',BC.CODE 'CODIGO CONCEPTO',BC.NAME 'CONCEPTO FACTURACION',   CGC.Code 'CODIGO GRUPO',CGC.Name 'GRUPO CUPS',
   CSG.CODE 'CODIGO SUBGRUPO',CSG.Name  'SUBGRUPO CUPS',
   CASE ObtainCostCenter WHEN 1 THEN 'Unidad Funcional del Paciente' WHEN 2 THEN 'Centro de Costo Específico' WHEN 3 THEN 'Centro de Costo por Sucursal y Unidad Funcional'
   ELSE 'N/A' END 'OBTENER CC'
   FROM Contract.CUPSEntity AS CUPS
   INNER JOIN Billing.BillingGroup as BG WITH (NOLOCK) ON BG.Id=CUPS.BillingGroupId
   INNER JOIN Billing.BillingConcept as BC WITH (NOLOCK) ON BC.Id=CUPS.BillingConceptId
   INNER JOIN Contract.CupsSubgroup AS CSG WITH (NOLOCK) ON CSG.Id =CUPS.CUPSSubGroupId
   INNER JOIN Contract.CupsGroup AS CGC WITH (NOLOCK) ON CGC.Id =CSG.CupsGroupId
),

CTE_IMAGENES
AS
(
SELECT  
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
'HOSPITALARIO' 'AMBITO',A.AUTO,A.IPCODPACI 'IDENTIFICACION',A.NUMINGRES 'INGRESO',A.CODPROSAL 'PROFESIONAL ORDENO',CAST(A.FECORDMED AS DATE) 'FECHA ORDEN',A.CODSERIPS 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
A.CANSERIPS 'CANTIDAD',CUPS.[TIPO SERVICIO],CUPS.[GRUPO CUPS],CUPS.[SUBGRUPO CUPS],IM.Type 'TIPO',
CASE A.ESTSERIPS WHEN 1 THEN 'Solicitado' WHEN 2 THEN 'Estudio Realizado' WHEN 3 THEN 'Imagen Procesada' WHEN 4 THEN 'Estudio Interpretado' WHEN 5 THEN 'Remitido'
WHEN 6 THEN 'Anulado' WHEN 7 THEN 'Extramural' ELSE 'OTRO' END 'ESTADO',
LECTURA,MEDREALEC 'PROFESIONAL LECTURA',CAST(FECHLECT AS DATE) 'FECHA LECTURA',CAST(A.FECRECEXA AS DATE) 'FECHA CREACION',A.NOMARCIMG 'ADJUNTO',A.USURECEXA 'CODIGO USUARIO',
CODPROINT 'PROFESIONAL INTERPRETO',A.CODDIAGNO 'CIE10',GENSERVICEORDER 'ID ORDEN FACTURACION',NULL GENINVOICE, NULL GENINVOICEID,
CAST(A.FECORDMED AS DATE) AS [FECHA BUSQUEDA],
YEAR(A.FECORDMED) AS [AÑO BUSQUEDA],
MONTH(A.FECORDMED) AS [MES BUSQUEDA],
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM dbo.HCORDIMAG A 
INNER JOIN CTE_CUPS AS CUPS ON CUPS.Code=A.CODSERIPS
LEFT JOIN REPORT.TableSocieties as IM on IM.Code=A.CODSERIPS
----------------------------------------------------------------------------------------------------------------------------------
UNION ALL
SELECT  
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
'AMBULATORIO' 'AMBITO',A.AUTO,A.IPCODPACI 'IDENTIFICACION',A.NUMINGRES 'INGRESO',A.CODPROSAL 'PROFESIONAL ORDENO',CAST(A.FECORDMED AS DATE) 'FECHA ORDEN',A.CODSERIPS 'CUPS',CUPS.Description 'DESCRIPCION CUPS',
A.CANSERIPS 'CANTIDAD',CUPS.[TIPO SERVICIO],CUPS.[GRUPO CUPS],CUPS.[SUBGRUPO CUPS],IM.Type 'TIPO',
CASE A.ESTSERIPS WHEN 1 THEN 'Solicitado' WHEN 2 THEN 'Estudio Realizado' WHEN 3 THEN 'Imagen Procesada' WHEN 4 THEN 'Estudio Interpretado' WHEN 5 THEN 'Remitido'
WHEN 6 THEN 'Anulado' WHEN 7 THEN 'Extramural' ELSE 'OTRO' END 'ESTADO',
LECTURA,MEDREALEC 'PROFESIONAL LECTURA',CAST(FECHLECT AS DATE) 'FECHA LECTURA',CAST(A.FECRECEXA AS DATE) 'FECHA CREACION',A.NOMARCIMG 'ADJUNTO',A.USURECEXA 'CODIGO USUARIO',
CODPROINT 'PROFESIONAL INTERPRETO','Z000' 'CIE10',GENSERVICEORDER 'ID ORDEN FACTURACION',GENINVOICE,GENINVOICEID,
CAST(A.FECORDMED AS DATE) AS [FECHA BUSQUEDA],
YEAR(A.FECORDMED) AS [AÑO BUSQUEDA],
MONTH(A.FECORDMED) AS [MES BUSQUEDA],
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM dbo.AMBORDIMA A 
INNER JOIN CTE_CUPS AS CUPS ON CUPS.Code=A.CODSERIPS
LEFT JOIN REPORT.TableSocieties as IM on IM.Code=A.CODSERIPS
)

SELECT * FROM CTE_IMAGENES






