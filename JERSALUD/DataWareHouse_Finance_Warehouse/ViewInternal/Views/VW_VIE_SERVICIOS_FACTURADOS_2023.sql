-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_SERVICIOS_FACTURADOS_2023
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_SERVICIOS_FACTURADOS_2023
AS
SELECT DISTINCT ING.IFECHAING AS FECHA_INGRESO, ING.NUMINGRES AS INGRESO, ING.CODUSUCRE AS USUARIO_CREA, us.NOMUSUARI as UsuarioIngreso,CA.NOMCENATE AS CENTRO_ATENCION, U.UFUDESCRI AS UNIDAD_FUNCIONAL,
				CASE P.IPTIPODOC WHEN 1 THEN 'CC' WHEN 2 THEN 'CE' WHEN 3 THEN 'TI' WHEN 4 THEN 'RC' WHEN 5 THEN 'PA' WHEN 6 THEN 'AS' WHEN 7 THEN 'MS' WHEN 8 THEN 'NU' END AS TIPO_DOCUMENTO_PACIENTE,
				ING.IPCODPACI AS IDENTIFICACION_PACIENTE,P.IPNOMCOMP AS NOMBRE_PACIENTE, CUPS.Code AS CUPS, CUPS.Description AS CUPS_DESCRIPCION,
				F.InvoiceNumber AS FACTURA, CASE F.Status WHEN 1 THEN 'Facturado' WHEN 2 THEN 'Anulado' END AS Estado_Factura, FD.InvoicedQuantity AS CANTIDAD, 
				FD.TotalSalesPrice AS VALOR_UNITARIO, F.TotalInvoice AS TOTAL_FACTURA, 
				F.InvoiceDate AS FECHA_CIERRE, F.InvoicedUser AS USUARIOFACT, T.Name AS FUNCIONARIO,
				CA.NOMCENATE AS Sede, GA.Code AS Cod_Grupo_Atencion , GA.Name AS Grupo_Atencion,
				/*ING.CODPROING AS [Codigo Profesional Ingreso], (SELECT NOMMEDICO FROM dbo.INPROFSAL WHERE CODPROSAL=ING.CODPROING) AS Profesional_Ingreso,*/
				SOD.PerformsHealthProfessionalCode AS [Codigo Profesional Factura], 
				(SELECT NOMMEDICO FROM INDIGO031.dbo.INPROFSAL WHERE CODPROSAL=SOD.PerformsHealthProfessionalCode) AS Profesional_Factura,
				CASE F.DocumentType WHEN 1 THEN 'Factura por Evento de Servicios' WHEN 2 THEN 'Factura EAPB Sin Contrato' WHEN 3 THEN 'Factura Particular' WHEN 4 THEN 'Factura Capitada' 
					WHEN 5 THEN 'Control de Capitacion' WHEN 6 THEN 'Factura Basica' WHEN 7 THEN 'Factura de Venta de Productos' END AS TIPO_DOCUMENTO_FACTURADO,
				CU.Number AS Cuenta, CU.Name AS CuentaContable,--,concepto facturacion
				P.IPDIRECCI AS Direccion_Paciente, P.IPTELEFON AS Telefono_Paciente, P.IPTELMOVI AS Celular_Paciente, P.IPFECNACI AS FechaNacimiento_Paciente, 
				(cast(datediff(dd,P.IPFECNACI,GETDATE()) / 365.25 as int)) as Edad,
				(SELECT TOP 1 DIAG.CODDIAGNO FROM INDIGO031.dbo.INDIAGNOP AS DIAG  WHERE DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1) AS DX_Principal_HC, 
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
				DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) AS EdadEnAtencion, 
				CASE
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '0' AND '5' THEN 'Primera Infancia'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '6' AND '11' THEN 'Infancia'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '12' AND '17' THEN 'Adolecencia'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '18' AND '28' THEN 'Juventud'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '29' AND '59' THEN 'Adultez'
					WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) >= '60' THEN 'Vejez'
				END AS Ciclo_Vida,
				SOD.ServiceDate as FechaPrestacionServicio
				--DIAG.CODDIAGNO AS DX_Principal
  FROM INDIGO031.Billing.Invoice AS F 
	   INNER JOIN INDIGO031.Billing.InvoiceDetail AS FD  ON F.Id=FD.InvoiceId /*AND F.DocumentType=5 AND F.Status=1*/
	   INNER JOIN INDIGO031.Billing.ServiceOrderDetail AS SOD  ON FD.ServiceOrderDetailId=SOD.Id
	   INNER JOIN INDIGO031.Billing.ServiceOrder AS SO  ON SOD.ServiceOrderId=SO.Id
	   INNER JOIN INDIGO031.Contract.CUPSEntity AS CUPS  ON CUPS.Id=SOD.CUPSEntityId
	   INNER JOIN INDIGO031.dbo.ADINGRESO AS ING  ON ING.NUMINGRES=SO.AdmissionNumber
	   INNER JOIN INDIGO031.Contract.CareGroup AS GA  ON GA.Id=SOD.CareGroupId
       INNER JOIN INDIGO031.dbo.ADCENATEN AS CA  ON CA.CODCENATE = ING.CODCENATE
	   INNER JOIN INDIGO031.dbo.INUNIFUNC AS U  ON U.UFUCODIGO = ING.UFUCODIGO
	   INNER JOIN INDIGO031.dbo.INPACIENT AS P  ON P.IPCODPACI = ING.IPCODPACI
	   LEFT JOIN INDIGO031.Common.ThirdParty AS T  on F.InvoicedUser = T.Nit
	   JOIN INDIGO031.dbo.SEGusuaru AS us  on ING.CODUSUCRE = us.CODUSUARI
	   INNER JOIN INDIGO031.Billing.BillingConcept AS CF  ON CUPS.BillingConceptId = CF.Id 
	   INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS CU  ON CF.EntityIncomeAccountId = CU.Id 
	   --LEFT JOIN .INDIAGNOP AS DIAG ON DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1
	   --INNER JOIN .INDIAGNOS AS 
WHERE  year(ING.IFECHAING) = '2023'