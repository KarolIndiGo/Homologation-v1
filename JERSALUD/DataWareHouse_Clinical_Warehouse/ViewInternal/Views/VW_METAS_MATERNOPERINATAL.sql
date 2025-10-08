-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_METAS_MATERNOPERINATAL
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VW_METAS_MATERNOPERINATAL]
AS

SELECT DISTINCT  CASE
                WHEN CA.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN CA.CODCENATE IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN CA.CODCENATE IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional,  ING.IFECHAING AS FECHA_INGRESO, ING.NUMINGRES AS INGRESO, LTRIM(RTRIM(CA.NOMCENATE)) AS CENTRO_ATENCION, U.UFUDESCRI AS UNIDAD_FUNCIONAL,
				ING.IPCODPACI AS IDENTIFICACION_PACIENTE,P.IPNOMCOMP AS NOMBRE_PACIENTE, CUPS.Code AS CUPS, CUPS.Description AS CUPS_DESCRIPCION,
				F.InvoiceNumber AS FACTURA, CASE F.Status WHEN 1 THEN 'Facturado' WHEN 2 THEN 'Anulado' END AS Estado_Factura, FD.InvoicedQuantity AS CANTIDAD, 
				FD.TotalSalesPrice AS VALOR_UNITARIO, F.TotalInvoice AS TOTAL_FACTURA, 
				F.InvoiceDate AS FECHA_CIERRE, 
				CA.NOMCENATE AS Sede, GA.Code AS Cod_Grupo_Atencion , GA.Name AS Grupo_Atencion,
				/*ING.CODPROING AS [Codigo Profesional Ingreso], (SELECT NOMMEDICO FROM dbo.INPROFSAL WHERE CODPROSAL=ING.CODPROING) AS Profesional_Ingreso,*/
				
				(SELECT NOMMEDICO FROM [INDIGO031].dbo.INPROFSAL WHERE CODPROSAL=SOD.PerformsHealthProfessionalCode) AS Profesional_Factura,
				
				--CU.Number AS Cuenta, CU.Name AS CuentaContable,--,concepto facturacion
				 P.IPFECNACI AS FechaNacimiento_Paciente, 
				(cast(datediff(dd,P.IPFECNACI,GETDATE()) / 365.25 as int)) as Edad,
				(SELECT TOP 1 DIAG.CODDIAGNO FROM [INDIGO031].dbo.INDIAGNOP AS DIAG  WHERE DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1) AS DX_Principal_HC, 
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
				CASE
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '0' AND '5' THEN 'Primera Infancia'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '6' AND '11' THEN 'Infancia'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '12' AND '17' THEN 'Adolecencia'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '18' AND '28' THEN 'Juventud'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '29' AND '59' THEN 'Adultez'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) >= '60' THEN 'Vejez'
				END AS Ciclo_Vida,
				SOD.ServiceDate as FechaPrestacionServicio,  CASE WHEN IPSEXOPAC = '1' THEN 'M' WHEN IPSEXOPAC = '2' THEN 'F' END  as [Género (F/M)],
				case when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and CUPS.Code in ('890250','890201') then 'Prenatal_1vez' 
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and CUPS.Code in ('890363','890350','890301') then 'Prenatal_Control' 
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and CUPS.Code in ('890205','890305') then 'Prenatal_Enfermeria' 
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and CUPS.Code in ('902207','902208','902209','902210') then 'Hemograma' 
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and CUPS.Code in ('911015','911017','911018','911016') then 'Hemoclasificacion' 
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and CUPS.Code in ('901235','901236','901237') then 'Urocultivo' 
when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and CUPS.Code in ('903841','903843','903844') then 'Glicemia'
when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and CUPS.Code in ('890203','890303') then 'Odonto_Gral'
when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z171','Z717') AND CUPS.Code IN ('906249') THEN 'Vih_Gestantes'
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and CUPS.Code in ('906039') then 'Treponema'
when CUPS.Code in ('990223') then 'Educacion_Gestante'
when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and CUPS.Code in ('907106') then 'Uroanalisis'
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and CUPS.Code in ('906127','906128') then 'Toxoplasma'
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and CUPS.Code in ('906129','906130') then 'Toxoplasma_IGM'
					 
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and CUPS.Code in ('906134') then 'Test_Avidez'
when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') and CUPS.Code in ('906317','906223','906262','906332') then 'Hepatitis'
			
				when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z171','Z717') AND CUPS.Code IN ('906249') THEN 'Vih_Rapida'
					 when F.OutputDiagnosis in ('Z390','Z391','Z392') AND CUPS.Code IN ('890301','890201','890101','890350','890250') THEN 'Control_Postparto'
					 when F.OutputDiagnosis in ('Z762') AND CUPS.Code IN ('890283','890383','890201','890301','890305') THEN 'Control_RN'
					 when F.OutputDiagnosis in ('Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359') AND CUPS.Code IN ('906915') THEN 'Serologia'

					 end as Indicador , 'Perinatal' as Grupo
				--DIAG.CODDIAGNO AS DX_Principal
  FROM [INDIGO031].Billing.Invoice AS F 
	   INNER JOIN [INDIGO031].Billing.InvoiceDetail AS FD  ON F.Id=FD.InvoiceId /*AND F.DocumentType=5 AND F.Status=1*/
	   INNER JOIN [INDIGO031].Billing.ServiceOrderDetail AS SOD  ON FD.ServiceOrderDetailId=SOD.Id
	   INNER JOIN [INDIGO031].Billing.ServiceOrder AS SO  ON SOD.ServiceOrderId=SO.Id
	   INNER JOIN [INDIGO031].Contract.CUPSEntity AS CUPS  ON CUPS.Id=SOD.CUPSEntityId
	   INNER JOIN [INDIGO031].dbo.ADINGRESO AS ING  ON ING.NUMINGRES=SO.AdmissionNumber
	   INNER JOIN [INDIGO031].Contract.CareGroup AS GA  ON GA.Id=F.CareGroupId
       INNER JOIN [INDIGO031].dbo.ADCENATEN AS CA  ON CA.CODCENATE = ING.CODCENATE
	   INNER JOIN [INDIGO031].dbo.INUNIFUNC AS U  ON U.UFUCODIGO = ING.UFUCODIGO
	   INNER JOIN [INDIGO031].dbo.INPACIENT AS P  ON P.IPCODPACI = ING.IPCODPACI
	   LEFT JOIN [INDIGO031].Common.ThirdParty AS T  on F.InvoicedUser = T.Nit
	   JOIN [INDIGO031].dbo.SEGusuaru AS us  on ING.CODUSUCRE = us.CODUSUARI
	   INNER JOIN [INDIGO031].Billing.BillingConcept AS CF  ON CUPS.BillingConceptId = CF.Id 
	   INNER JOIN [INDIGO031].GeneralLedger.MainAccounts AS CU  ON CF.EntityIncomeAccountId = CU.Id 

	   --LEFT JOIN .INDIAGNOP AS DIAG ON DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1
	   --INNER JOIN .INDIAGNOS AS 
WHERE  (SOD.ServiceDate) >= '01/01/2024' and CUPS.Code in ('890250','890201','890363','890350','890301','890205','890305','902207','902208','902209','902210','911015','911017','911018','911016','901235','901236','901237','903841',
'890203','890303','890205','890201','906039','990223','907106','907106','906127','906128','906129','906134','906317','906249','890301','890201','890101','890350','890250', '890283',
'890383','890201','890301','890305',
'906915','903843','903844','906249','906130','906317','906223','906262','906332') and DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) between '15' and '50' and IPSEXOPAC=2 and 
F.OutputDiagnosis in ('Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z171','Z762','Z321',
'Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z012',
					 'K000','K001','K002','K003','K004','K005','K006','K007','K008','K009','K010','K011','K020','K021','K022','K023','K024','K025','K028','K029','K030','K031','K032','K033','K034','K035','K036',
'K037','K038','K039','K040','K041','K042','K043','K044','K045','K046','K047','K048','K049','K050','K051','K052','K053','K054','K055','K056','K060','K061','K062','K068','K069','K070','K071','K072','K073','K074',
'K075','K076','K078','K079','K080','K081','K082','K083','K088','K089','K090','K091','K092','K098','K099','K100','K101','K102','K103','K108','K109','K110','K111','K112','K113','K114','K115','K116','K117','K118',
'K119','K120','K121','K122','K123','K130','K131','K132','K133','K134','K135','K136','K137','K140','K141','K142','K143','K144','K145','K146','K148','K149','Z390','Z391','Z392','Z321','Z340','Z348','Z349','Z350','Z351','Z352','Z353','Z354','Z355','Z356','Z357','Z358','Z359','Z171','Z717')


--order by ING.IFECHAING DESC;
--ING.IPCODPACI IN ('20851115')
--ING.IFECHAING BETWEEN '2019-01-01' AND '2019-12-31' AND  GA.Code in ('BOG037', 'BOG038', 'BOG075')--ING.NUMINGRES='215531' O 88643')
union all

SELECT DISTINCT  CASE
                WHEN CA.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN CA.CODCENATE IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN CA.CODCENATE IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional,  ING.IFECHAING AS FECHA_INGRESO, ING.NUMINGRES AS INGRESO, LTRIM(RTRIM(CA.NOMCENATE)) AS CENTRO_ATENCION, U.UFUDESCRI AS UNIDAD_FUNCIONAL,
				ING.IPCODPACI AS IDENTIFICACION_PACIENTE,P.IPNOMCOMP AS NOMBRE_PACIENTE, pr.Code AS CUPS, pr.Description AS CUPS_DESCRIPCION,
				F.InvoiceNumber AS FACTURA, CASE F.Status WHEN 1 THEN 'Facturado' WHEN 2 THEN 'Anulado' END AS Estado_Factura, FD.InvoicedQuantity AS CANTIDAD, 
				FD.TotalSalesPrice AS VALOR_UNITARIO, F.TotalInvoice AS TOTAL_FACTURA, 
				F.InvoiceDate AS FECHA_CIERRE, 
				CA.NOMCENATE AS Sede, GA.Code AS Cod_Grupo_Atencion , GA.Name AS Grupo_Atencion,
				/*ING.CODPROING AS [Codigo Profesional Ingreso], (SELECT NOMMEDICO FROM dbo.INPROFSAL WHERE CODPROSAL=ING.CODPROING) AS Profesional_Ingreso,*/
				
				(SELECT NOMMEDICO FROM [INDIGO031].dbo.INPROFSAL WHERE CODPROSAL=SOD.PerformsHealthProfessionalCode) AS Profesional_Factura,
				
				--CU.Number AS Cuenta, CU.Name AS CuentaContable,--,concepto facturacion
				 P.IPFECNACI AS FechaNacimiento_Paciente, 
				(cast(datediff(dd,P.IPFECNACI,GETDATE()) / 365.25 as int)) as Edad,
				(SELECT TOP 1 DIAG.CODDIAGNO FROM [INDIGO031].dbo.INDIAGNOP AS DIAG  WHERE DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1) AS DX_Principal_HC, 
				CASE WHEN DX.CODDIAGNO IS NULL THEN F.OutputDiagnosis ELSE DX.CODDIAGNO END AS DX_Cierre_Ing, 
				
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
				CASE
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '0' AND '5' THEN 'Primera Infancia'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '6' AND '11' THEN 'Infancia'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '12' AND '17' THEN 'Adolecencia'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '18' AND '28' THEN 'Juventud'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '29' AND '59' THEN 'Adultez'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) >= '60' THEN 'Vejez'
				END AS Ciclo_Vida,
				SOD.ServiceDate as FechaPrestacionServicio,  CASE WHEN IPSEXOPAC = '1' THEN 'M' WHEN IPSEXOPAC = '2' THEN 'F' END  as [Género (F/M)],
				case  when pr.Code in (select Codigo from INDIGO031.[ViewInternal].[AcidoFolico]
										union all 
										select Codigo from INDIGO031.[ViewInternal].[CarbonatoCalcio]
										union all 
										select Codigo from INDIGO031.[ViewInternal].[Sulfatoferroso]) then 'Multivitaminicos' 

					 end as Indicador , 'Perinatal' as Grupo
				--DIAG.CODDIAGNO AS DX_Principal
  FROM [INDIGO031].Billing.Invoice AS F 
	   INNER JOIN [INDIGO031].Billing.InvoiceDetail AS FD  ON F.Id=FD.InvoiceId /*AND F.DocumentType=5 AND F.Status=1*/
	   INNER JOIN [INDIGO031].Billing.ServiceOrderDetail AS SOD  ON FD.ServiceOrderDetailId=SOD.Id
	   INNER JOIN [INDIGO031].Billing.ServiceOrder AS SO  ON SOD.ServiceOrderId=SO.Id
	   INNER JOIN [INDIGO031].Inventory.InventoryProduct AS pr  ON pr.Id=SOD.ProductId
	   inner join [INDIGO031].Inventory.ATC AS ATC ON ATC.Id=pr.ATCId 
	   INNER JOIN [INDIGO031].dbo.ADINGRESO AS ING  ON ING.NUMINGRES=SO.AdmissionNumber
	   INNER JOIN [INDIGO031].Contract.CareGroup AS GA  ON GA.Id=F.CareGroupId
       INNER JOIN [INDIGO031].dbo.ADCENATEN AS CA  ON CA.CODCENATE = ING.CODCENATE
	   INNER JOIN [INDIGO031].dbo.INUNIFUNC AS U  ON U.UFUCODIGO = ING.UFUCODIGO
	   INNER JOIN [INDIGO031].dbo.INPACIENT AS P  ON P.IPCODPACI = ING.IPCODPACI
	   LEFT JOIN [INDIGO031].Common.ThirdParty AS T  on F.InvoicedUser = T.Nit
	   JOIN [INDIGO031].dbo.SEGusuaru AS us  on ING.CODUSUCRE = us.CODUSUARI
	  LEFT JOIN (SELECT A.IPCODPACI, CODPRODUC,  A.CODDIAGNO, NOMDIAGNO, A.FECINIDOS,
concat(MONTH(A.FECINIDOS),'/',YEAR(A.FECINIDOS)) as Fecha, tp.Nit, tp.Name
FROM [INDIGO031].dbo.HCPRESCRA AS A 
--inner join dbo.HCVIAADMI as via on via.CODVIAADM=a.CODVIAADM
inner join [INDIGO031].dbo.INDIAGNOS as dx on dx.CODDIAGNO=A.CODDIAGNO
inner join [INDIGO031].dbo.ADINGRESO as i on i.NUMINGRES=A.NUMINGRES
inner join [INDIGO031].Contract.HealthAdministrator as ha on ha.Id=i.GENCONENTITY
inner join [INDIGO031].Common.ThirdParty as tp on tp.Id=ha.ThirdPartyId
WHERE FECINIDOS>='01-01-2024' ) AS DX ON DX.IPCODPACI=F.PatientCode AND DX.Fecha=concat(MONTH(SO.OrderDate),'/',YEAR(SO.OrderDate)) AND DX.CODPRODUC=ATC.Code
WHERE  (SOD.ServiceDate) >= '01/01/2024' and pr.Code in (select Codigo from [INDIGO031].[ViewInternal].[AcidoFolico]
										union all 
										select Codigo from [INDIGO031].[ViewInternal].[CarbonatoCalcio]
										union all 
										select Codigo from [INDIGO031].[ViewInternal].[Sulfatoferroso]) 
--order by ING.IFECHAING DESC;
--ING.IPCODPACI IN ('20851115')
--ING.IFECHAING BETWEEN '2019-01-01' AND '2019-12-31' AND  GA.Code in ('BOG037', 'BOG038', 'BOG075')--ING.NUMINGRES='215531' O 88643')

--select *
--from INDIGO031.dbo.INDIAGNOS
--where CODDIAGNO >='z390'
