-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Ruta_MaternoPerinatal_MedicamentoIVE
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [ViewInternal].[Ruta_MaternoPerinatal_MedicamentoIVE] as
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
WHERE FECINIDOS>='01-01-2025' ) AS DX ON DX.IPCODPACI=F.PatientCode AND DX.Fecha=concat(MONTH(SO.OrderDate),'/',YEAR(SO.OrderDate)) AND DX.CODPRODUC=ATC.CODE
WHERE  (SOD.ServiceDate) >= '01/01/2025' and pr.Code in ('20010043-34','19914260-1')  and IPSEXOPAC=2  
 and DATEDIFF(year, P.IPFECNACI, ING.IFECHAING)between '14' and '49' and f.Status=1

