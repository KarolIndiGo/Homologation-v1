-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Metas_Planificacion
-- Extracted by Fabric SQL Extractor SPN v3.9.0

--/****** Object:  View [ViewInternal].[VIE_Servicios_Facturados_General_ECIS]    Script Date: 2/12/2024 10:12:26 a. m. ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


CREATE VIEW [ViewInternal].[Metas_Planificacion]
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
				case when F.OutputDiagnosis not in ('Z316','Z318','Z319') and cups.Code in ('890263','890201','890205','890250') then 'Planifica_1vez' 
					 when F.OutputDiagnosis not in ('Z316','Z318','Z319') and cups.code in ('890363','890301','890305','890350') then 'Planifica_Control'
					 when F.OutputDiagnosis not in ('Z316','Z318','Z319') and cups.code in ('697101') then 'Dispositivo_Intrauterino'
					 when F.OutputDiagnosis in ('Z316','Z318','Z319') and cups.code in ('890263', '890201','890205','890250','890363','890301','890305','890350','697101') then 'Preconcepcional'  end as Indicador , 'Planificación' as Grupo
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
WHERE  (SOD.ServiceDate) >= '01/01/2024' and cups.Code in ('890263', '890201','890205','890250','890363','890301','890305','890350','697101') 
--order by ING.IFECHAING DESC;
--ING.IPCODPACI IN ('20851115')
--ING.IFECHAING BETWEEN '2019-01-01' AND '2019-12-31' AND  GA.Code in ('BOG037', 'BOG038', 'BOG075')--ING.NUMINGRES='215531' O 88643')
union all

SELECT DISTINCT  CASE
                 WHEN ca.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN ca.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN ca.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional,  ING.IFECHAING AS FECHA_INGRESO, ING.NUMINGRES AS INGRESO, LTRIM(RTRIM(CA.NOMCENATE)) AS CENTRO_ATENCION, U.UFUDESCRI AS UNIDAD_FUNCIONAL,
				ING.IPCODPACI AS IDENTIFICACION_PACIENTE,P.IPNOMCOMP AS NOMBRE_PACIENTE, pr.Code AS CUPS, pr.Description AS CUPS_DESCRIPCION,
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
				case  when pr.Code in (select Codigo from ViewInternal.InyectableTrimestral
										union all 
										select Codigo from ViewInternal.[ImplantesSubderm]) then 'InyectableTrimestralSubderm' 
				when pr.Code in (select Codigo from ViewInternal.InyectableTrimestral) then 'InyectableTrimestral' 
				     when pr.Code in (select Codigo from ViewInternal.InyectableMensual
										union all 
										select Codigo from ViewInternal.OralesCombinados) then 'InyectableMensualOralCombinado' 
					     
					 when pr.Code in (select Codigo from ViewInternal.InyectableMensual) then 'InyectableMensual' 
					 when pr.Code in (select Codigo from ViewInternal.OralesCombinados) then 'OralesCombinados'
					 when pr.Code in (select Codigo from [ViewInternal].[OralesProgestina]) then 'OralesProgestina'
					 when pr.Code in (select Codigo from [ViewInternal].[OralesEmergencia]) then 'OralesEmergencia'
					 when pr.Code in (select Codigo from ViewInternal.DIU) then 'DIU'
					 when pr.Code in (select Codigo from [ViewInternal].[ImplantesSubderm]) then 'ImplantesSubderm'
					 when pr.Code in (select Codigo from [ViewInternal].[ParchesTransderm]) then 'ParchesTransderm'
					 when pr.Code in (select Codigo from [ViewInternal].[AnilloVaginal]) then 'AnilloVaginal'
					 end as Indicador , 'Planificación' as Grupo
				--DIAG.CODDIAGNO AS DX_Principal
  FROM Billing.Invoice AS F 
	   INNER JOIN Billing.InvoiceDetail AS FD  ON F.Id=FD.InvoiceId /*AND F.DocumentType=5 AND F.Status=1*/
	   INNER JOIN Billing.ServiceOrderDetail AS SOD  ON FD.ServiceOrderDetailId=SOD.Id
	   INNER JOIN Billing.ServiceOrder AS SO  ON SOD.ServiceOrderId=SO.Id
	   INNER JOIN Inventory.InventoryProduct AS pr  ON pr.Id=SOD.ProductId
	  inner join Inventory.ATC AS ATC ON ATC.ID=PR.ATCId 
	  INNER JOIN dbo.ADINGRESO AS ING  ON ING.NUMINGRES=SO.AdmissionNumber
	   INNER JOIN Contract.CareGroup AS GA  ON GA.Id=F.CareGroupId
       INNER JOIN dbo.ADCENATEN AS CA  ON CA.CODCENATE = ING.CODCENATE
	   INNER JOIN dbo.INUNIFUNC AS U  ON U.UFUCODIGO = ING.UFUCODIGO
	   INNER JOIN dbo.INPACIENT AS P  ON P.IPCODPACI = ING.IPCODPACI
	   LEFT JOIN Common.ThirdParty AS T  on f.InvoicedUser = t.Nit
	   JOIN dbo.SEGusuaru AS us  on ing.CODUSUCRE = us.CODUSUARI
	  LEFT JOIN (SELECT a.IPCODPACI, CODPRODUC,  a.CODDIAGNO, NOMDIAGNO, a.FECINIDOS,
concat(MONTH(a.FECINIDOS),'/',YEAR(a.FECINIDOS)) as Fecha, tp.nit, tp.Name
FROM DBO.HCPRESCRA AS A 
--inner join dbo.HCVIAADMI as via on via.CODVIAADM=a.CODVIAADM
inner join dbo.INDIAGNOS as dx on dx.CODDIAGNO=a.CODDIAGNO
inner join dbo.ADINGRESO as i on i.NUMINGRES=a.NUMINGRES
inner join Contract.HealthAdministrator as ha on ha.id=i.GENCONENTITY
inner join Common.ThirdParty as tp on tp.id=ha.ThirdPartyId
WHERE FECINIDOS>='01-01-2024' ) AS DX ON DX.IPCODPACI=F.PatientCode AND DX.Fecha=concat(MONTH(SO.OrderDate),'/',YEAR(SO.OrderDate)) AND DX.CODPRODUC=ATC.CODE
WHERE  (SOD.ServiceDate) >= '01/01/2024' and pr.Code in ('42163-01','19989893-01','19997397-01','19997397-02','20011793-01','20002868-01','20002868-02','20002868-03','20018905-01','20018905-02',
'20018905-05','19946883-03','19946883-04','19946883-07','19987723-05','51922-01','51922-02','51922-03','20035472-01','20014675-01','27076-01','27076-02','38692-01','228238-01','19942145-01','19942145-02','19942145-03',
'19948265-03','19948265-04','19971488-01','19971833-01','19972438-01','19979565-01','19981474-01','19981474-02','19985113-01','19988571-01','19988571-02','19988571-03','19988571-04','19988755-01','19988755-05',
'19988755-02','19988755-03','19988755-04','19990135-01','19990135-02','19990135-03','19990135-04','19990135-05','19990135-06','19990135-07','19990317-01','19994000-01','19994000-02','19997297-01','20009360-01',
'20011474-01','20046074-01','20046074-02','20046074-03','20046074-04','20046074-05','20068867-01','20071421-01','20077143-01','19906274-14','19906274-15','19906274-16','19953663-01','19953663-02','19953663-03',
'19971488-02','19966573-05','19966573-06','19989179-02','20053396-02','20055000-03','20070573-02','20070619-04','20071109-01','20077742-02','20080146-02','20071110-01','20034500-01','19903056-01','19903056-02',
'19903056-03','19979564-01','19979564-03','19979564-04','19979564-02','19981711-01','19981711-02','20013439-01','19908046-01','19908046-03','19951553-01','19951553-12','19951553-10','19951553-11','19951553-07',
'19951553-13','19951553-04','19951553-08','19951553-14','19951553-05','19951553-09','19951553-15','19951553-06','19977582-01','19977582-06','19977582-07','19977582-09','19977582-08','19977582-03','19977582-10',
'19977582-04','19977582-11','19977582-05','19977706-01','19979560-01','19981398-01','19989785-02','19989785-01','19989785-03','19989785-04','19989785-05','19993039-01','19996115-01','19999383-01','20014912-01',
'20014969-01','20023279-01','20052210-01','20052210-05','20052210-11','20052210-20','20052210-27','20052210-02','20052210-06','20052210-12','20052210-18','20052210-21','20052210-28','20052210-07',
'20052210-13','20052210-22','20052210-29','20052210-08','20052210-14','20052210-23','20052210-30','20052210-09','20052210-15','20052210-24','20052210-31','20052210-10','20052210-16','20052210-26',
'20052210-32','20062770-01','20063441-01','20063441-02','20063441-03','20063441-04','20067960-01','20067960-02','20080147-01','20095174-01','20097975-01','20097975-02','20097975-03','20097975-04',
'20099554-01','20102114-01','20103221-01','20104469-01','19900498-01','20046501-01','19900498-02','19901195-01','19901195-02','19901195-03','19934015-02','19934015-01','20071862-01','19969493-01','19990355-01',
'19901670-01','19930208-01','19930208-02','19987333-01','20055021-01','19987333-02') 
--order by ING.IFECHAING DESC;
--ING.IPCODPACI IN ('20851115')
--ING.IFECHAING BETWEEN '2019-01-01' AND '2019-12-31' AND  GA.Code in ('BOG037', 'BOG038', 'BOG075')--ING.NUMINGRES='215531' O 88643')
