-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Ruta_MaternoPerinatal_Den_Nacidos3a5
-- Extracted by Fabric SQL Extractor SPN v3.9.0


--/****** Object:  View [ViewInternal].[Ruta_MaternoPerinatal_Sifilis]    Script Date: 18/03/2025 8:00:52 a. m. ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO



create VIEW [ViewInternal].[Ruta_MaternoPerinatal_Den_Nacidos3a5] AS
SELECT DISTINCT  CASE
                 WHEN ca.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN ca.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN ca.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional,  ING.IFECHAING AS FECHA_INGRESO, ING.NUMINGRES AS INGRESO, LTRIM(RTRIM(CA.NOMCENATE)) AS CENTRO_ATENCION, U.UFUDESCRI AS UNIDAD_FUNCIONAL,
				ING.IPCODPACI AS IDENTIFICACION_PACIENTE,P.IPNOMCOMP AS NOMBRE_PACIENTE, CUPS.Code AS CUPS, CUPS.Description AS CUPS_DESCRIPCION,
				F.InvoiceNumber AS FACTURA, CASE F.Status WHEN 1 THEN 'Facturado' WHEN 2 THEN 'Anulado' END AS Estado_Factura, FD.InvoicedQuantity AS CANTIDAD, 
				FD.TotalSalesPrice AS VALOR_UNITARIO, F.TotalInvoice AS TOTAL_FACTURA, 
				F.InvoiceDate AS FECHA_CIERRE, 
				CA.NOMCENATE AS Sede, GA.Code AS Cod_Grupo_Atencion , GA.Name AS Grupo_Atencion,
				/*ING.CODPROING AS [Codigo Profesional Ingreso], (SELECT NOMMEDICO FROM dbo.INPROFSAL WHERE CODPROSAL=ING.CODPROING) AS Profesional_Ingreso,*/
				
				(SELECT NOMMEDICO FROM dbo.INPROFSAL WHERE CODPROSAL=SOD.PerformsHealthProfessionalCode) AS Profesional_Factura,
				
				--CU.Number AS Cuenta, CU.Name AS CuentaContable,--,concepto facturacion
				 P.IPFECNACI AS FechaNacimiento_Paciente, 
				(cast(datediff(dd,P.IPFECNACI,GETDATE()) / 365.25 as int)) as Edad,
				(SELECT TOP 1 DIAG.CODDIAGNO FROM dbo.INDIAGNOP AS DIAG  WHERE DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1) AS DX_Principal_HC, 
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
				DATEDIFF(DAY, P.IPFECNACI, ING.IFECHAING) AS EdadDiasEnAtencion, 
				RTRIM(LTRIM(ViewInternal.Edad(P.IPFECNACI, ING.IFECHAING)))  AS EdadDetalle,
				CASE
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '0' AND '5' THEN 'Primera Infancia'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '6' AND '11' THEN 'Infancia'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '12' AND '17' THEN 'Adolecencia'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '18' AND '28' THEN 'Juventud'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '29' AND '59' THEN 'Adultez'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) >= '60' THEN 'Vejez'
				END AS Ciclo_Vida,
				SOD.ServiceDate as FechaPrestacionServicio,  CASE WHEN IPSEXOPAC = '1' THEN 'M' WHEN IPSEXOPAC = '2' THEN 'F' END  as [Género (F/M)],
				case when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and cups.Code in ('890250','890201') then 'Prenatal_1vez' 
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and cups.Code in ('890363','890350','890301') then 'Prenatal_Control' 
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and cups.Code in ('890205','890305') then 'Prenatal_Enfermeria' 
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and cups.Code in ('902207','902208','902209','902210') then 'Hemograma' 
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and cups.Code in ('911015','911017','911018','911016') then 'Hemoclasificacion' 
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and cups.Code in ('901235','901236','901237') then 'Urocultivo' 
when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and cups.Code in ('903841','903843','903844') then 'Glicemia'
when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and cups.Code in ('890203','890303') then 'Odonto_Gral'
when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z171','Z717') AND CUPS.CODE IN ('906249') THEN 'Vih_Gestantes'
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and cups.Code in ('906039') then 'Treponema'
when cups.Code in ('990223') then 'Educacion_Gestante'
when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and cups.Code in ('907106') then 'Uroanalisis'
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and cups.Code in ('906127','906128') then 'Toxoplasma'
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and cups.Code in ('906129','906130') then 'Toxoplasma_IGM'
					 
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and cups.Code in ('906134') then 'Test_Avidez'
when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and cups.Code in ('906317','906223','906262','906332') then 'Hepatitis'
			
				when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z171','Z717') AND CUPS.CODE IN ('906249') THEN 'Vih_Rapida'
					 when F.OutputDiagnosis in ('Z390','Z391','Z392') AND CUPS.CODE IN ('890301','890201','890101','890350','890250') THEN 'Control_Postparto'
					 when F.OutputDiagnosis in ('Z762') AND CUPS.CODE IN ('890283','890383','890201','890301','890305') THEN 'Control_RN'
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') AND CUPS.CODE IN ('906915') THEN 'Serologia'

					 end as Indicador , 'Perinatal' as Grupo
				--DIAG.CODDIAGNO AS DX_Principal
  FROM Billing.Invoice AS F 
	   INNER JOIN Billing.InvoiceDetail AS FD  ON F.Id=FD.InvoiceId /*AND F.DocumentType=5 AND F.Status=1*/
	   INNER JOIN Billing.ServiceOrderDetail AS SOD  ON FD.ServiceOrderDetailId=SOD.Id
	   INNER JOIN Billing.ServiceOrder AS SO  ON SOD.ServiceOrderId=SO.Id
	   INNER JOIN Contract.CUPSEntity AS CUPS  ON CUPS.Id=SOD.CUPSEntityId
	   INNER JOIN dbo.ADINGRESO AS ING  ON ING.NUMINGRES=SO.AdmissionNumber
	   INNER JOIN Contract.CareGroup AS GA  ON GA.Id=F.CareGroupId
       INNER JOIN dbo.ADCENATEN AS CA  ON CA.CODCENATE = ING.CODCENATE
	   INNER JOIN dbo.INUNIFUNC AS U  ON U.UFUCODIGO = ING.UFUCODIGO
	   INNER JOIN dbo.INPACIENT AS P  ON P.IPCODPACI = ING.IPCODPACI
	   LEFT JOIN Common.ThirdParty AS T  on f.InvoicedUser = t.Nit
	   JOIN dbo.SEGusuaru AS us  on ing.CODUSUCRE = us.CODUSUARI
	   INNER JOIN Billing.BillingConcept AS CF  ON CUPS.BillingConceptId = CF.Id 
	   INNER JOIN GeneralLedger.MainAccounts AS CU  ON CF.EntityIncomeAccountId = CU.Id 

	   --LEFT JOIN .INDIAGNOP AS DIAG ON DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1
	   --INNER JOIN .INDIAGNOS AS 
WHERE  /*(SOD.ServiceDate) >= '01/01/2025' and cups.Code in ('890283', '890383',  '890201', '890301', '890305', '890205') and*/ DATEDIFF(DAY, P.IPFECNACI, ING.IFECHAING)<=30 /*DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) = '0'*/ --and IPSEXOPAC=2  
/*AND F.PatientCode IN (SELECT IPCODPACI
FROM DBO.INDIAGNOH
WHERE CODDIAGNO in ('Z762'))*/
--AND F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359')
--ORDER BY NOMCENATE

