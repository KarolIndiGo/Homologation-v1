-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_RUTA_MATERNOPERINATAL_DEN_EMB14
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   VIEW [ViewInternal].[VW_RUTA_MATERNOPERINATAL_DEN_EMB14] AS

SELECT DISTINCT
       CASE
           WHEN CA.CODCENATE IN (002, 003, 004, 005, 006, 007, 008, 009, 017, 021) THEN 'BOYACA'
           WHEN CA.CODCENATE IN (010, 011, 012, 013, 014, 018) THEN 'META'
           WHEN CA.CODCENATE IN (015, 016, 019, 020) THEN 'CASANARE'
       END AS Regional,
       ING.IFECHAING AS FECHA_INGRESO,
       ING.NUMINGRES AS INGRESO,
       LTRIM(RTRIM(CA.NOMCENATE)) AS CENTRO_ATENCION,
       U.UFUDESCRI AS UNIDAD_FUNCIONAL,
       ING.IPCODPACI AS IDENTIFICACION_PACIENTE,
       P.IPNOMCOMP AS NOMBRE_PACIENTE,
       CUPS.Code AS CUPS,
       CUPS.Description AS CUPS_DESCRIPCION,
       F.InvoiceNumber AS FACTURA,
       CASE F.Status WHEN 1 THEN 'Facturado' WHEN 2 THEN 'Anulado' END AS Estado_Factura,
       FD.InvoicedQuantity AS CANTIDAD,
       FD.TotalSalesPrice AS VALOR_UNITARIO,
       F.TotalInvoice AS TOTAL_FACTURA,
       F.InvoiceDate AS FECHA_CIERRE,
       CA.NOMCENATE AS Sede,
       GA.Code AS Cod_Grupo_Atencion,
       GA.Name AS Grupo_Atencion,
       /*ING.CODPROING AS [Codigo Profesional Ingreso], (SELECT NOMMEDICO FROM dbo.INPROFSAL WHERE CODPROSAL=ING.CODPROING) AS Profesional_Ingreso,*/

       (SELECT NOMMEDICO FROM INDIGO031.dbo.INPROFSAL WHERE CODPROSAL = SOD.PerformsHealthProfessionalCode) AS Profesional_Factura,

       --CU.Number AS Cuenta, CU.Name AS CuentaContable,--,concepto facturacion
       P.IPFECNACI AS FechaNacimiento_Paciente,
       (CAST(DATEDIFF(dd, P.IPFECNACI, GETDATE()) / 365.25 AS INT)) AS Edad,
       (SELECT TOP 1 DIAG.CODDIAGNO FROM INDIGO031.dbo.INDIAGNOP AS DIAG WHERE DIAG.NUMINGRES = ING.NUMINGRES AND DIAG.CODDIAPRI = 1) AS DX_Principal_HC,
       F.OutputDiagnosis AS DX_Cierre_Ing,
       --CASE CUPS.RIPSConcept 
       --	WHEN 01 THEN 'Consultas (AC)'
       --	WHEN 02 THEN 'Procedimientos de diagnósticos (AP)'
       --	WHEN 03 THEN 'Procedimientos terapéuticos no quirúrgicos (AP)'
       --	WHEN 04 THEN 'Procedimientos terapéuticos quirúrgicos (AP)'
       --	WHEN 05 THEN 'Procedimientos de promoción y prevención (AP)'
       --	WHEN 06 THEN 'Estancias (AT)'
       --	WHEN 07 THEN 'Honorarios (AT)'
       --	WHEN 08 THEN 'Derechos de sala (AT)'
       --	WHEN 09 THEN 'Materiales e insumos (AT)'
       --	WHEN 10 THEN 'Banco de sangre (AP)' 
       --	WHEN 11 THEN 'Prótesis y órtesis (AT)' 
       --	WHEN 12 THEN 'Medicamentos POS (AM)' 
       --	WHEN 13 THEN 'Medicamentos no POS (AM)' 
       --	WHEN 14 THEN 'Traslado de pacientes (AT)' 
       --END AS Concepto_RIPS,
       DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) AS EdadEnAtencion,
       DATEDIFF(day, P.IPFECNACI, ING.IFECHAING) AS EdadDiasEnAtencion,
       RTRIM(LTRIM(ViewInternal.Edad(P.IPFECNACI, ING.IFECHAING))) AS EdadDetalle,
       CASE
           WHEN CAST(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) AS INT) BETWEEN '0' AND '5' THEN 'Primera Infancia'
           WHEN CAST(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) AS INT) BETWEEN '6' AND '11' THEN 'Infancia'
           WHEN CAST(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) AS INT) BETWEEN '12' AND '17' THEN 'Adolecencia'
           WHEN CAST(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) AS INT) BETWEEN '18' AND '28' THEN 'Juventud'
           WHEN CAST(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) AS INT) BETWEEN '29' AND '59' THEN 'Adultez'
           WHEN CAST(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) AS INT) >= '60' THEN 'Vejez'
       END AS Ciclo_Vida,
       SOD.ServiceDate AS FechaPrestacionServicio,
       CASE WHEN IPSEXOPAC = '1' THEN 'M' WHEN IPSEXOPAC = '2' THEN 'F' END AS [Género (F/M)],
       CASE
           WHEN F.OutputDiagnosis IN ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') AND CUPS.Code IN ('890250','890201') THEN 'Prenatal_1vez'
           WHEN F.OutputDiagnosis IN ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') AND CUPS.Code IN ('890363','890350','890301') THEN 'Prenatal_Control'
           WHEN F.OutputDiagnosis IN ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') AND CUPS.Code IN ('890205','890305') THEN 'Prenatal_Enfermeria'
           WHEN F.OutputDiagnosis IN ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') AND CUPS.Code IN ('902207','902208','902209','902210') THEN 'Hemograma'
           WHEN F.OutputDiagnosis IN ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') AND CUPS.Code IN ('911015','911017','911018','911016') THEN 'Hemoclasificacion'
           WHEN F.OutputDiagnosis IN ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') AND CUPS.Code IN ('901235','901236','901237') THEN 'Urocultivo'
           WHEN F.OutputDiagnosis IN ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') AND CUPS.Code IN ('903841','903843','903844') THEN 'Glicemia'
           WHEN F.OutputDiagnosis IN ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') AND CUPS.Code IN ('890203','890303') THEN 'Odonto_Gral'
           WHEN F.OutputDiagnosis IN ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z171','Z717') AND CUPS.Code IN ('906249') THEN 'Vih_Gestantes'
           WHEN CUPS.Code IN ('990223') THEN 'Educacion_Gestante'
           WHEN F.OutputDiagnosis IN ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') AND CUPS.Code IN ('907106') THEN 'Uroanalisis'
           WHEN F.OutputDiagnosis IN ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') AND CUPS.Code IN ('906127','906128') THEN 'Toxoplasma'
           WHEN F.OutputDiagnosis IN ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') AND CUPS.Code IN ('906129','906130') THEN 'Toxoplasma_IGM'
           WHEN F.OutputDiagnosis IN ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') AND CUPS.Code IN ('906134') THEN 'Test_Avidez'
           WHEN F.OutputDiagnosis IN ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') AND CUPS.Code IN ('906317','906223','906262','906332') THEN 'Hepatitis'
           WHEN F.OutputDiagnosis IN ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z171','Z717') AND CUPS.Code IN ('906249') THEN 'Vih_Rapida'
           WHEN F.OutputDiagnosis IN ('Z390','Z391','Z392') AND CUPS.Code IN ('890301','890201','890101','890350','890250') THEN 'Control_Postparto'
           WHEN F.OutputDiagnosis IN ('Z762') AND CUPS.Code IN ('890283','890383','890201','890301','890305') THEN 'Control_RN'
           WHEN F.OutputDiagnosis IN ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') AND CUPS.Code IN ('906915') THEN 'Serologia'
       END AS Indicador,
       'Perinatal' AS Grupo
       --DIAG.CODDIAGNO AS DX_Principal
FROM   INDIGO031.Billing.Invoice AS F
       INNER JOIN INDIGO031.Billing.InvoiceDetail AS FD
               ON F.Id = FD.InvoiceId /*AND F.DocumentType=5 AND F.Status=1*/
       INNER JOIN INDIGO031.Billing.ServiceOrderDetail AS SOD
               ON FD.ServiceOrderDetailId = SOD.Id
       INNER JOIN INDIGO031.Billing.ServiceOrder AS SO
               ON SOD.ServiceOrderId = SO.Id
       INNER JOIN INDIGO031.Contract.CUPSEntity AS CUPS
               ON CUPS.Id = SOD.CUPSEntityId
       INNER JOIN INDIGO031.dbo.ADINGRESO AS ING
               ON ING.NUMINGRES = SO.AdmissionNumber
       INNER JOIN INDIGO031.Contract.CareGroup AS GA
               ON GA.Id = F.CareGroupId
       INNER JOIN INDIGO031.dbo.ADCENATEN AS CA
               ON CA.CODCENATE = ING.CODCENATE
       INNER JOIN INDIGO031.dbo.INUNIFUNC AS U
               ON U.UFUCODIGO = ING.UFUCODIGO
       INNER JOIN INDIGO031.dbo.INPACIENT AS P
               ON P.IPCODPACI = ING.IPCODPACI
       LEFT JOIN  INDIGO031.Common.ThirdParty AS T
               ON F.InvoicedUser = T.Nit
       JOIN      INDIGO031.dbo.SEGusuaru AS us
               ON ING.CODUSUCRE = us.CODUSUARI
       INNER JOIN INDIGO031.Billing.BillingConcept AS CF
               ON CUPS.BillingConceptId = CF.Id
       INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS CU
               ON CF.EntityIncomeAccountId = CU.Id

       --LEFT JOIN .INDIAGNOP AS DIAG ON DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1
       --INNER JOIN .INDIAGNOS AS 
WHERE  (SOD.ServiceDate) >= '01/01/2025'
  AND  CUPS.Code IN ('890301', '890201', '890101', '890350', '890250', '890205', '890305') --and DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) <= '14'  /*DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) = '0'*/ --
  AND  IPSEXOPAC = 2  
--AND F.PatientCode IN (SELECT IPCODPACI
--FROM DBO.INDIAGNOH
--WHERE CODDIAGNO in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359'))
--AND F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359')
--ORDER BY NOMCENATE
