-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_Servicios_Facturados
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_Servicios_Facturados] as  
------ALTER VIEW VIE_Servicios_Facturados_General
SELECT 
  (ING.IFECHAING) AS FECHA_INGRESO, ING.NUMINGRES AS INGRESO, ING.CODUSUCRE AS USUARIO_CREA, us.NOMUSUARI as UsuarioIngreso,CA.NOMCENATE AS CENTRO_ATENCION, U.UFUDESCRI AS UNIDAD_FUNCIONAL,
				CASE P.IPTIPODOC WHEN 1 THEN 'CC' WHEN 2 THEN 'CE' WHEN 3 THEN 'TI' WHEN 4 THEN 'RC' WHEN 5 THEN 'PA' WHEN 6 THEN 'AS' WHEN 7 THEN 'MS' WHEN 8 THEN 'NU' END AS TIPO_DOCUMENTO_PACIENTE,
				ING.IPCODPACI AS IDENTIFICACION_PACIENTE,P.IPNOMCOMP AS NOMBRE_PACIENTE, CUPS.Code AS CUPS, CUPS.Description AS CUPS_DESCRIPCION,
				F.InvoiceNumber AS FACTURA, CASE F.Status WHEN 1 THEN 'Facturado' WHEN 2 THEN 'Anulado' END AS Estado_Factura, FD.InvoicedQuantity AS CANTIDAD, 
				FD.TotalSalesPrice AS VALOR_UNITARIO, F.TotalInvoice AS TOTAL_FACTURA, 
				F.InvoiceDate AS FECHA_CIERRE, F.InvoicedUser AS USUARIOFACT, usufac.NOMUSUARI AS FUNCIONARIO,--t.Name AS FUNCIONARIO,
				CA.NOMCENATE AS Sede, GA.Code AS Cod_Grupo_Atencion , GA.Name AS Grupo_Atencion,
				/*ING.CODPROING AS [Codigo Profesional Ingreso], (SELECT NOMMEDICO FROM dbo.INPROFSAL WHERE CODPROSAL=ING.CODPROING) AS Profesional_Ingreso,*/
				SOD.PerformsHealthProfessionalCode AS [Codigo Profesional Factura], 
				/*(SELECT NOMMEDICO FROM dbo.INPROFSAL WHERE CODPROSAL=SOD.PerformsHealthProfessionalCode) AS Profesional_Factura,*/
				PR.NOMMEDICO AS Profesional_Factura,
				ESP.DESESPECI AS Especialidad, 
				CASE F.DocumentType WHEN 1 THEN 'Factura por Evento de Servicios' WHEN 2 THEN 'Factura EAPB Sin Contrato' WHEN 3 THEN 'Factura Particular' WHEN 4 THEN 'Factura Capitada' 
				WHEN 5 THEN 'Control de Capitacion' WHEN 6 THEN 'Factura Basica' WHEN 7 THEN 'Factura de Venta de Productos' END AS TIPO_DOCUMENTO_FACTURADO,
				CASE WHEN CU.Number IS NULL THEN CCM.Number ELSE CU.Number END AS Cuenta, 
				CASE WHEN CU.Name IS NULL THEN CCM.Name ELSE CU.NAME END AS CuentaContable,
				--,concepto facturacion
				P.IPDIRECCI AS Direccion_Paciente, P.IPTELEFON AS Telefono_Paciente, P.IPTELMOVI AS Celular_Paciente, P.IPFECNACI AS FechaNacimiento_Paciente, 
				datediff(year,P.IPFECNACI,GETDATE()) as Edad, DIAG.CODDIAGNO AS DX_Principal_HC,
--				(SELECT TOP 1 DIAG.CODDIAGNO FROM dbo.INDIAGNOP AS DIAG  WHERE DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1) AS DX_Principal_HC--, 
				F.OutputDiagnosis AS DX_Cierre_Ing, SOD.AuthorizationNumber as Autorizacion,
				CASE CUPS.RIPSConcept 
					WHEN 01 THEN 'Consultas (AC)'
					WHEN 02 THEN 'Procedimientos de diagnósticos (AP)'
					WHEN 03 THEN 'Procedimientos terapéuticos no quirúrgicos (AP)'
					WHEN 04 THEN 'Procedimientos terapéuticos quirúrgicos (AP)'
					WHEN 05 THEN 'Procedimientos de promoción y prevención (AP)'
					WHEN 06 THEN 'Estancias (AT)'
					WHEN 07 THEN 'Honorarios (AT)'
					WHEN 08 THEN 'Derechos de sala (AT)'
					WHEN 09 THEN 'Materiales e insumos (AT)'
					WHEN 10 THEN 'Banco de sangre (AP)' 
					WHEN 11 THEN 'Prótesis y órtesis (AT)' 
					WHEN 12 THEN 'Medicamentos POS (AM)' 
					WHEN 13 THEN 'Medicamentos no POS (AM)' 
					WHEN 14 THEN 'Traslado de pacientes (AT)' 
				END AS Concepto_RIPS,
				DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) AS [EdadEnAtencion (Años)], 
			RTRIM(LTRIM(dbo.Edad(CONVERT(varchar, P.IPFECNACI, 23), CONVERT(varchar,ING.IFECHAING, 23)))) AS EdadEnAtencion,
				
				CASE
					WHEN (DATEDIFF(year, P.IPFECNACI, ING.IFECHAING))  BETWEEN '0' AND '5' THEN 'Primera Infancia'
					WHEN (DATEDIFF(year, P.IPFECNACI, ING.IFECHAING))  BETWEEN '6' AND '11' THEN 'Infancia'
					WHEN (DATEDIFF(year, P.IPFECNACI, ING.IFECHAING))  BETWEEN '12' AND '17' THEN 'Adolecencia'
					WHEN (DATEDIFF(year, P.IPFECNACI, ING.IFECHAING))  BETWEEN '18' AND '28' THEN 'Juventud'
					WHEN (DATEDIFF(year, P.IPFECNACI, ING.IFECHAING))  BETWEEN '29' AND '59' THEN 'Adultez'
					WHEN (DATEDIFF(year, P.IPFECNACI, ING.IFECHAING))  >= '60' THEN 'Vejez'
				END AS Ciclo_Vida,
--			--ccc.name as CentroCostoDispensacion,
			cccd.name as CentroCostoFacturacion,
			SOD.ServiceDate as FechaPrestacionServicio,
			CASE WHEN SOD.ApplyRIAS = '1' THEN 'Si' ELSE 'No' END AS AplicaRIAS,--Se agrega 01/08/2024 caso 212743
			RIAS.NOMBRE AS RIAS_Facturado,--Se agrega 01/08/2024 caso 212743
--
ne.Code AS [Codigo Finalidad Consulta/Procedimiento],-- 05/08/2025 se agrega campo para seguimiento de rips electronicos
ne.Name As [Finalidad Consulta/Procedimiento],
CASE
			WHEN ne.code in ('11','12','13','15','16','17','18','19','20','22','23','24','25','27','43','44') THEN 'AC y AP'
			WHEN ne.Code in ('14','26','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42') THEN 'AP'
			WHEN ne.Code in ('21') THEN 'AC'
			ELSE '' END AS 'Finalidad Aplica Para',
	--Se agrega 01/08/2024 caso 212743
				--select * from Billing.ServiceOrderDetail
A.DESACTMED AS ACTIVIDAD,--, A.IDRIASCUPS--,  RC.ID
 f.AnnulmentUser + ' - ' + usAnu.NOMUSUARI AS [Usuario Anula], f.AnnulmentDate AS [Fecha Anulación], rf.Name AS [Motivo Anulación],
 FD.InvoicedQuantity *	FD.TotalSalesPrice AS ValorTotal
  FROM Billing.Invoice AS F 
	   INNER JOIN Billing.InvoiceDetail AS FD  ON F.Id=FD.InvoiceId /*AND F.DocumentType=5 AND F.Status=1*/
	   INNER JOIN Billing.ServiceOrderDetail AS SOD  ON FD.ServiceOrderDetailId=SOD.Id
	   INNER JOIN Payroll.costcenter as cccd    on cccd.id= SOD.costcenterid
	   INNER JOIN Billing.ServiceOrder AS SO  ON SOD.ServiceOrderId=SO.Id and so.AdmissionNumber=f.AdmissionNumber
	   INNER JOIN Contract.CUPSEntity AS CUPS  ON CUPS.Id=SOD.CUPSEntityId
	   INNER JOIN dbo.ADINGRESO AS ING  ON ING.NUMINGRES=f.AdmissionNumber
	   LEFT JOIN dbo.INPROFSAL AS PR ON PR.CODPROSAL=SOD.PerformsHealthProfessionalCode
	   LEFT JOIN dbo.INESPECIA AS ESP ON PR.CODESPEC1 = ESP.CODESPECI
	   INNER JOIN Contract.CareGroup AS GA  ON GA.Id=SOD.CareGroupId
       INNER JOIN dbo.ADCENATEN AS CA  ON CA.CODCENATE = ING.CODCENATE
	   INNER JOIN dbo.INUNIFUNC AS U  ON U.UFUCODIGO = ING.UFUCODIGO
	   INNER JOIN dbo.INPACIENT AS P  ON P.IPCODPACI = ING.IPCODPACI
	   LEFT JOIN Common.ThirdParty AS T  on f.InvoicedUser = t.Nit
	   JOIN dbo.SEGusuaru AS us  on ing.CODUSUCRE = us.CODUSUARI
	   LEFT JOIN Billing.BillingConcept AS CF  ON CUPS.BillingConceptId = CF.Id 
	   left JOIN GeneralLedger.MainAccounts AS CU  ON CF.EntityIncomeAccountId = CU.Id  ---left era inner
	   LEFT JOIN DBO.INDIAGNOP AS DIAG ON DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1
	   LEFT JOIN dbo.RIASCUPSPACIENTE AS RP ON RP.IDDETALLEORDENSERVICIO=SOD.Id --Se agrega 01/08/2024 caso 212743
	   LEFT JOIN dbo.RIASCUPS AS RC ON RC.ID = RP.IDRIASCUPS --Se agrega 01/08/2024 caso 212743
	   LEFT JOIN dbo.RIAS AS RIAS ON RIAS.ID = RC.IDRIAS --Se agrega 01/08/2024 caso 212743
	   LEFT join dbo.AGACTIMED AS A ON RC.ID = A.IDRIASCUPS and a.ESTADOACT = '1'
	   LEFT JOIN dbo.SEGusuaru AS usufac  on F.InvoicedUser = usufac.CODUSUARI
	   LEFT JOIN dbo.SEGusuaru AS usAnu  on f.AnnulmentUser = usAnu.CODUSUARI
	   left join Billing.BillingReversalReason as rf on f.ReversalReasonId = rf.id
	   left join Admissions.HealthPurposes as ne on  ne.Id = ING.IdHealthPurposes
	   LEFT JOIN (SELECT  B.ID AS IDCONCEPTO, M.Number, M.Name, B.CODE
					FROM INDIGO031.Billing.BillingConceptAccount AS C WITH (NOLOCK)
					INNER JOIN INDIGO031.Billing.BillingConcept AS B WITH (NOLOCK) ON B.ID=C.BillingConceptId
					INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS M WITH (NOLOCK) ON M.ID=C.EntityIncomeAccountId
					GROUP BY B.ID, M.Number, M.Name, B.CODE) AS CCM ON CCM.IDCONCEPTO=CUPS.BillingConceptId
	   --WHERE ING.NUMINGRES='A637BF10F3' 
	   --WHERE ING.NUMINGRES='3897393'
	   --LEFT JOIN dbo.RIASCUPS AS RC1 ON RC1.ID = RP.IDRIASCUPS
	   --INNER JOIN .INDIAGNOS AS 
--WHERE  ING.IFECHAING >= DATEADD(MONTH, -2, GETDATE())  --AND F.InvoiceNumber='Y389187'
--ING.NUMINGRES='1775738'
--order by ING.IFECHAING DESC;
  -- WHERE ING.IPCODPACI IN ('1000119809')
   --and ING.NUMINGRES='46352'
--ING.IFECHAING BETWEEN '2019-01-01' AND '2019-12-31' AND  GA.Code in ('BOG037', 'BOG038', 'BOG075')--ING.NUMINGRES='215531' O 88643')
--where ING.NUMINGRES='3359355'
--WHERE ing.IFECHAING >='07-31-2024 00:00:00'
--ING.NUMINGRES ='3855596'
 --WHERE INGRESO='3855596'
--select * from  dbo.RIASCUPSPACIENTE where YEAR(FECHACREACION)='2024' AND ESTADO='2' AND NUMINGRES='3855596'
--ORDER BY FECHAREALIZACION DESC

--select * from dbo.RIASCUPS where id in ('322','36')

--SELECT * FROM dbo.RIAS
--where f.Status='2'
--WHERE FD.InvoicedQuantity>1
