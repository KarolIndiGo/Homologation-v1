-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Metas_Adolescencia
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[Metas_Adolescencia]
AS
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
				CASE
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '0' AND '5' THEN 'Primera Infancia'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '6' AND '11' THEN 'Infancia'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '12' AND '17' THEN 'Adolecencia'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '18' AND '28' THEN 'Juventud'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '29' AND '59' THEN 'Adultez'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) >= '60' THEN 'Vejez'
				END AS Ciclo_Vida,
				SOD.ServiceDate as FechaPrestacionServicio,  CASE WHEN IPSEXOPAC = '1' THEN 'M' WHEN IPSEXOPAC = '2' THEN 'F' END  as [Género (F/M)],
case when F.OutputDiagnosis in ('Z000','Z008','Z003','Z108') and cups.Code in ('890283','890263','890201') then 'Nroatenciones_Adolescencia' 
	 when F.OutputDiagnosis in ('Z000','Z008','Z003') and cups.Code in ('890205','890305') then 'Nroatenciones_Enfermeria' 
when F.OutputDiagnosis in ('K000','K001','K002','K003','K004','K005','K006','K007','K008','K009','K010','K011','K020','K021','K022','K023','K024','K025','K028','K029','K030','K031','K032','K033','K034','K035','K036',
'K037','K038','K039','K040','K041','K042','K043','K044','K045','K046','K047','K048','K049','K050','K051','K052','K053','K054','K055','K056','K060','K061','K062','K068','K069','K070','K071','K072','K073','K074',
'K075','K076','K078','K079','K080','K081','K082','K083','K088','K089','K090','K091','K092','K098','K099','K100','K101','K102','K103','K108','K109','K110','K111','K112','K113','K114','K115','K116','K117','K118',
'K119','K120','K121','K122','K123','K130','K131','K132','K133','K134','K135','K136','K137','K140','K141','K142','K143','K144','K145','K146','K148','K149','Z012') 
and cups.Code in ('890203','890303') then 'Atenciones_BucalAdolescencia' 

					 when F.OutputDiagnosis in ('Z003','Z017') and cups.Code in ('902213','902211','902210') then 'Anemia'  
				
when 
--F.OutputDiagnosis in ('K000','K001','K002','K003','K004','K005','K006','K007','K008','K009','K010','K011','K020','K021','K022','K023','K024','K025','K028','K029','K030','K031','K032','K033','K034','K035','K036',
--'K037','K038','K039','K040','K041','K042','K043','K044','K045','K046','K047','K048','K049','K050','K051','K052','K053','K054','K055','K056','K060','K061','K062','K068','K069','K070','K071','K072','K073','K074',
--'K075','K076','K078','K079','K080','K081','K082','K083','K088','K089','K090','K091','K092','K098','K099','K100','K101','K102','K103','K108','K109','K110','K111','K112','K113','K114','K115','K116','K117','K118',
--'K119','K120','K121','K122','K123','K130','K131','K132','K133','K134','K135','K136','K137','K140','K141','K142','K143','K144','K145','K146','K148','K149','Z012','Z000','Z008','Z003') 
--and 
cups.Code in ('997106','997103') then 'Barniz'

when 
--F.OutputDiagnosis in ('K000','K001','K002','K003','K004','K005','K006','K007','K008','K009','K010','K011','K020','K021','K022','K023','K024','K025','K028','K029','K030','K031','K032','K033','K034','K035','K036',
--'K037','K038','K039','K040','K041','K042','K043','K044','K045','K046','K047','K048','K049','K050','K051','K052','K053','K054','K055','K056','K060','K061','K062','K068','K069','K070','K071','K072','K073','K074',
--'K075','K076','K078','K079','K080','K081','K082','K083','K088','K089','K090','K091','K092','K098','K099','K100','K101','K102','K103','K108','K109','K110','K111','K112','K113','K114','K115','K116','K117','K118',
--'K119','K120','K121','K122','K123','K130','K131','K132','K133','K134','K135','K136','K137','K140','K141','K142','K143','K144','K145','K146','K148','K149','Z012','Z000','Z008','Z003') 
--and 
cups.Code in ('997002') then 'Profilaxis'

when 
--F.OutputDiagnosis in ('K000','K001','K002','K003','K004','K005','K006','K007','K008','K009','K010','K011','K020','K021','K022','K023','K024','K025','K028','K029','K030','K031','K032','K033','K034','K035','K036',
--'K037','K038','K039','K040','K041','K042','K043','K044','K045','K046','K047','K048','K049','K050','K051','K052','K053','K054','K055','K056','K060','K061','K062','K068','K069','K070','K071','K072','K073','K074',
--'K075','K076','K078','K079','K080','K081','K082','K083','K088','K089','K090','K091','K092','K098','K099','K100','K101','K102','K103','K108','K109','K110','K111','K112','K113','K114','K115','K116','K117','K118',
--'K119','K120','K121','K122','K123','K130','K131','K132','K133','K134','K135','K136','K137','K140','K141','K142','K143','K144','K145','K146','K148','K149','Z012','Z000','Z008','Z003') 
--and
cups.Code in ('997107') then 'Sellantes'  

when 
--F.OutputDiagnosis in ('K000','K001','K002','K003','K004','K005','K006','K007','K008','K009','K010','K011','K020','K021','K022','K023','K024','K025','K028','K029','K030','K031','K032','K033','K034','K035','K036',
--'K037','K038','K039','K040','K041','K042','K043','K044','K045','K046','K047','K048','K049','K050','K051','K052','K053','K054','K055','K056','K060','K061','K062','K068','K069','K070','K071','K072','K073','K074',
--'K075','K076','K078','K079','K080','K081','K082','K083','K088','K089','K090','K091','K092','K098','K099','K100','K101','K102','K103','K108','K109','K110','K111','K112','K113','K114','K115','K116','K117','K118',
--'K119','K120','K121','K122','K123','K130','K131','K132','K133','K134','K135','K136','K137','K140','K141','K142','K143','K144','K145','K146','K148','K149','Z012','Z000','Z008','Z003') 
--and 
cups.Code in ('997301') then 'Detartraje'

when  cups.Code in ('990201','990202','990203','990204','990205','990206','990207','990208','990209','990210','990211') then 'Educacion_IndividualAdolescencia'
when  cups.Code in ('990101', '990102','990103','990104','990105','990106','990107','990108','990109','990110','990111','990112','990113') then 'Educacion_GrupalAdolescencia'

					 end as Indicador , 'Adolescencia' as Grupo
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
WHERE  (SOD.ServiceDate) >= '01/01/2024' and cups.Code in ('990101', '990102','990103','990104','990105','990106','990107','990108','990109','990110','990111','990112','990113',
'990202','990203','990204','990205','990206','990207','990208','990209','990210','990211','997301','997002','906263','906225','906317','906249','906039','907106','903895','903868','903818','903816','903817','903815','907009','890301','890294','890201',
'906611','906612','906610', '908890','890263','890363','890201','890301','890363','890350','890301','890363','890350','890301','903841','990201','890263','890363','892901',
'903841','903895','903815','903816','903817','903818','903868','907106','890283','890263','890201','890205','890305','890203','890303','902213','902211','902210','997106','997103','997107','997002',
'997301','997002') 
and DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) >= '12'  and  DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) <= '17'  and 
F.OutputDiagnosis in ('K000','K001','K002','K003','K004','K005','K006','K007','K008','K009','K010','K011','K020','K021','K022','K023','K024','K025','K028','K029','K030','K031','K032','K033','K034','K035','K036',
'K037','K038','K039','K040','K041','K042','K043','K044','K045','K046','K047','K048','K049','K050','K051','K052','K053','K054','K055','K056','K060','K061','K062','K068','K069','K070','K071','K072','K073','K074',
'K075','K076','K078','K079','K080','K081','K082','K083','K088','K089','K090','K091','K092','K098','K099','K100','K101','K102','K103','K108','K109','K110','K111','K112','K113','K114','K115','K116','K117','K118',
'K119','K120','K121','K122','K123','K130','K131','K132','K133','K134','K135','K136','K137','K140','K141','K142','K143','K144','K145','K146','K148','K149','Z012','Z000','Z008','Z017','Z136','Z125'
,'Z123','Z124','Z000','Z008','Z003','Z108','Z003','Z017')


--order by ING.IFECHAING DESC;
--ING.IPCODPACI IN ('20851115')
--ING.IFECHAING BETWEEN '2019-01-01' AND '2019-12-31' AND  GA.Code in ('BOG037', 'BOG038', 'BOG075')--ING.NUMINGRES='215531' O 88643')
--union all

--SELECT DISTINCT  CASE
--                 WHEN ca.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
--                THEN 'BOYACA'
--                WHEN ca.codcenate IN(010, 011, 012, 013, 014,018)
--                THEN 'META'
--                WHEN ca.codcenate IN (015,016,019,020)
--                THEN 'CASANARE'
--            END AS Regional,  ING.IFECHAING AS FECHA_INGRESO, ING.NUMINGRES AS INGRESO, LTRIM(RTRIM(CA.NOMCENATE)) AS CENTRO_ATENCION, U.UFUDESCRI AS UNIDAD_FUNCIONAL,
--				ING.IPCODPACI AS IDENTIFICACION_PACIENTE,P.IPNOMCOMP AS NOMBRE_PACIENTE, pr.Code AS CUPS, pr.Description AS CUPS_DESCRIPCION,
--				F.InvoiceNumber AS FACTURA, CASE F.Status WHEN 1 THEN 'Facturado' WHEN 2 THEN 'Anulado' END AS Estado_Factura, FD.InvoicedQuantity AS CANTIDAD, 
--				FD.TotalSalesPrice AS VALOR_UNITARIO, F.TotalInvoice AS TOTAL_FACTURA, 
--				F.InvoiceDate AS FECHA_CIERRE, 
--				CA.NOMCENATE AS Sede, GA.Code AS Cod_Grupo_Atencion , GA.Name AS Grupo_Atencion,
--				/*ING.CODPROING AS [Codigo Profesional Ingreso], (SELECT NOMMEDICO FROM dbo.INPROFSAL WHERE CODPROSAL=ING.CODPROING) AS Profesional_Ingreso,*/
				
--				(SELECT NOMMEDICO FROM dbo.INPROFSAL WHERE CODPROSAL=SOD.PerformsHealthProfessionalCode) AS Profesional_Factura,
				
--				--CU.Number AS Cuenta, CU.Name AS CuentaContable,--,concepto facturacion
--				 P.IPFECNACI AS FechaNacimiento_Paciente, 
--				(cast(datediff(dd,P.IPFECNACI,GETDATE()) / 365.25 as int)) as Edad,
--				(SELECT TOP 1 DIAG.CODDIAGNO FROM dbo.INDIAGNOP AS DIAG  WHERE DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1) AS DX_Principal_HC, 
--				CASE WHEN DX.CODDIAGNO IS NULL THEN F.OutputDiagnosis ELSE DX.CODDIAGNO END AS DX_Cierre_Ing, 
				
--				--CASE CUPS.RIPSConcept 
--				--	WHEN 01 THEN 'Consultas (AC)'
--				--	WHEN 02 THEN 'Procedimientos de diagnósticos (AP)'
--				--	WHEN 03 THEN 'Procedimientos terapéuticos no quirúrgicos (AP)'
--				--	WHEN 04 THEN 'Procedimientos terapéuticos quirúrgicos (AP)'
--				--	WHEN 05 THEN 'Procedimientos de promoción y prevención (AP)'
--				--	WHEN 06 THEN 'Estancias (AT)'
--				--	WHEN 07 THEN 'Honorarios (AT)'
--				--	WHEN 08 THEN 'Derechos de sala (AT)'
--				--	WHEN 09 THEN 'Materiales e insumos (AT)'
--				--	WHEN 10 THEN 'Banco de sangre (AP)' 
--				--	WHEN 11 THEN 'Prótesis y órtesis (AT)' 
--				--	WHEN 12 THEN 'Medicamentos POS (AM)' 
--				--	WHEN 13 THEN 'Medicamentos no POS (AM)' 
--				--	WHEN 14 THEN 'Traslado de pacientes (AT)' 
--				--END AS Concepto_RIPS,
--				DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) AS EdadEnAtencion, 
--				CASE
--					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '0' AND '5' THEN 'Primera Infancia'
--					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '6' AND '11' THEN 'Infancia'
--					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '12' AND '17' THEN 'Adolecencia'
--					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '18' AND '28' THEN 'Juventud'
--					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '29' AND '59' THEN 'Adultez'
--					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) >= '60' THEN 'Vejez'
--				END AS Ciclo_Vida,
--				SOD.ServiceDate as FechaPrestacionServicio,  CASE WHEN IPSEXOPAC = '1' THEN 'M' WHEN IPSEXOPAC = '2' THEN 'F' END  as [Género (F/M)],
--				case  when pr.Code in (select Codigo from [ViewInternal].[AcidoFolico]
--										union all 
--										select Codigo from [ViewInternal].[CarbonatoCalcio]
--										union all 
--										select Codigo from [ViewInternal].[Sulfatoferroso]) then 'Multivitaminicos' 

--					 end as Indicador , 'Perinatal' as Grupo
--				--DIAG.CODDIAGNO AS DX_Principal
--  FROM Billing.Invoice AS F 
--	   INNER JOIN Billing.InvoiceDetail AS FD  ON F.Id=FD.InvoiceId /*AND F.DocumentType=5 AND F.Status=1*/
--	   INNER JOIN Billing.ServiceOrderDetail AS SOD  ON FD.ServiceOrderDetailId=SOD.Id
--	   INNER JOIN Billing.ServiceOrder AS SO  ON SOD.ServiceOrderId=SO.Id
--	   INNER JOIN Inventory.InventoryProduct AS pr  ON pr.Id=SOD.ProductId
--	  inner join Inventory.ATC AS ATC ON ATC.ID=PR.ATCId 
--	  INNER JOIN dbo.ADINGRESO AS ING  ON ING.NUMINGRES=SO.AdmissionNumber
--	   INNER JOIN Contract.CareGroup AS GA  ON GA.Id=F.CareGroupId
--       INNER JOIN dbo.ADCENATEN AS CA  ON CA.CODCENATE = ING.CODCENATE
--	   INNER JOIN dbo.INUNIFUNC AS U  ON U.UFUCODIGO = ING.UFUCODIGO
--	   INNER JOIN dbo.INPACIENT AS P  ON P.IPCODPACI = ING.IPCODPACI
--	   LEFT JOIN Common.ThirdParty AS T  on f.InvoicedUser = t.Nit
--	   JOIN dbo.SEGusuaru AS us  on ing.CODUSUCRE = us.CODUSUARI
--	  LEFT JOIN (SELECT a.IPCODPACI, CODPRODUC,  a.CODDIAGNO, NOMDIAGNO, a.FECINIDOS,
--concat(MONTH(a.FECINIDOS),'/',YEAR(a.FECINIDOS)) as Fecha, tp.nit, tp.Name
--FROM DBO.HCPRESCRA AS A 
----inner join dbo.HCVIAADMI as via on via.CODVIAADM=a.CODVIAADM
--inner join dbo.INDIAGNOS as dx on dx.CODDIAGNO=a.CODDIAGNO
--inner join dbo.ADINGRESO as i on i.NUMINGRES=a.NUMINGRES
--inner join Contract.HealthAdministrator as ha on ha.id=i.GENCONENTITY
--inner join Common.ThirdParty as tp on tp.id=ha.ThirdPartyId
--WHERE FECINIDOS>='01-01-2024' ) AS DX ON DX.IPCODPACI=F.PatientCode AND DX.Fecha=concat(MONTH(SO.OrderDate),'/',YEAR(SO.OrderDate)) AND DX.CODPRODUC=ATC.CODE
--WHERE  (SOD.ServiceDate) >= '01/01/2024' and pr.Code in (select Codigo from [ViewInternal].[AcidoFolico]
--										union all 
--										select Codigo from [ViewInternal].[CarbonatoCalcio]
--										union all 
--										select Codigo from [ViewInternal].[Sulfatoferroso]) 
--order by ING.IFECHAING DESC;
--ING.IPCODPACI IN ('20851115')
--ING.IFECHAING BETWEEN '2019-01-01' AND '2019-12-31' AND  GA.Code in ('BOG037', 'BOG038', 'BOG075')--ING.NUMINGRES='215531' O 88643')

--select *
--from INDIGO031.dbo.INDIAGNOS
--where CODDIAGNO >='z390'
