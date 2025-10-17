-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_Servicios_Facturados_2025
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VIE_Servicios_Facturados_2025]
AS
SELECT DISTINCT ING.IFECHAING AS FECHA_INGRESO, ING.NUMINGRES AS INGRESO, ING.CODUSUCRE AS USUARIO_CREA, us.NOMUSUARI as UsuarioIngreso,CA.NOMCENATE AS CENTRO_ATENCION, U.UFUDESCRI AS UNIDAD_FUNCIONAL,
				CASE P.IPTIPODOC WHEN 1 THEN 'CC' WHEN 2 THEN 'CE' WHEN 3 THEN 'TI' WHEN 4 THEN 'RC' WHEN 5 THEN 'PA' WHEN 6 THEN 'AS' WHEN 7 THEN 'MS' WHEN 8 THEN 'NU' END AS TIPO_DOCUMENTO_PACIENTE,
				ING.IPCODPACI AS IDENTIFICACION_PACIENTE,P.IPNOMCOMP AS NOMBRE_PACIENTE, CUPS.Code AS CUPS, CUPS.Description AS CUPS_DESCRIPCION,
				F.InvoiceNumber AS FACTURA, CASE F.Status WHEN 1 THEN 'Facturado' WHEN 2 THEN 'Anulado' END AS Estado_Factura, FD.InvoicedQuantity AS CANTIDAD, 
				FD.TotalSalesPrice AS VALOR_UNITARIO, F.TotalInvoice AS TOTAL_FACTURA, 
				F.InvoiceDate AS FECHA_CIERRE, F.InvoicedUser AS USUARIOFACT, t.Name AS FUNCIONARIO, OP.UnitName AS [Unidad Operativa], GF.Name AS [Grupo Facturacion], SCUP.Code AS [Codigo SubCups] , SCUP.Description AS [Descripcion SubCups], SR.Name AS [Servicio Rips],
				CA.NOMCENATE AS Sede, GA.Code AS Cod_Grupo_Atencion , GA.Name AS Grupo_Atencion, 
				/*ING.CODPROING AS [Codigo Profesional Ingreso], (SELECT NOMMEDICO FROM dbo.INPROFSAL WHERE CODPROSAL=ING.CODPROING) AS Profesional_Ingreso,*/
				SOD.PerformsHealthProfessionalCode AS [Codigo Profesional Factura], 
				(SELECT NOMMEDICO FROM dbo.INPROFSAL WHERE CODPROSAL=SOD.PerformsHealthProfessionalCode) AS Profesional_Factura,
				CASE F.DocumentType WHEN 1 THEN 'Factura por Evento de Servicios' WHEN 2 THEN 'Factura EAPB Sin Contrato' WHEN 3 THEN 'Factura Particular' WHEN 4 THEN 'Factura Capitada' 
					WHEN 5 THEN 'Control de Capitacion' WHEN 6 THEN 'Factura Basica' WHEN 7 THEN 'Factura de Venta de Productos' END AS TIPO_DOCUMENTO_FACTURADO,
				CU.Number AS Cuenta, CU.Name AS CuentaContable,--,concepto facturacion
				P.IPDIRECCI AS Direccion_Paciente, P.IPTELEFON AS Telefono_Paciente, P.IPTELMOVI AS Celular_Paciente, P.IPFECNACI AS FechaNacimiento_Paciente, 
				(cast(datediff(dd,P.IPFECNACI,GETDATE()) / 365.25 as int)) as Edad,
				(SELECT TOP 1 DIAG.CODDIAGNO FROM dbo.INDIAGNOP AS DIAG  WHERE DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1) AS DX_Principal_HC, 
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
  FROM Billing.Invoice AS F WITH (NOLOCK)
	   INNER JOIN Billing.InvoiceDetail AS FD WITH (NOLOCK) ON F.Id=FD.InvoiceId /*AND F.DocumentType=5 AND F.Status=1*/
	   INNER JOIN Billing.ServiceOrderDetail AS SOD WITH (NOLOCK) ON FD.ServiceOrderDetailId=SOD.Id
	   INNER JOIN Billing.ServiceOrder AS SO WITH (NOLOCK) ON SOD.ServiceOrderId=SO.Id
	   INNER JOIN Contract.CUPSEntity AS CUPS WITH (NOLOCK) ON CUPS.Id=SOD.CUPSEntityId
	   INNER JOIN dbo.ADINGRESO AS ING WITH (NOLOCK) ON ING.NUMINGRES=SO.AdmissionNumber
	   INNER JOIN Contract.CareGroup AS GA WITH (NOLOCK) ON GA.Id=SOD.CareGroupId
       INNER JOIN dbo.ADCENATEN AS CA WITH (NOLOCK) ON CA.CODCENATE = ING.CODCENATE
	   INNER JOIN dbo.INUNIFUNC AS U WITH (NOLOCK) ON U.UFUCODIGO = ING.UFUCODIGO
	   INNER JOIN dbo.INPACIENT AS P WITH (NOLOCK) ON P.IPCODPACI = ING.IPCODPACI
	   LEFT JOIN Common.ThirdParty AS T WITH (NOLOCK) on f.InvoicedUser = t.Nit
	   JOIN dbo.SEGusuaru AS us WITH (NOLOCK) on ing.CODUSUCRE = us.CODUSUARI
	   INNER JOIN Billing.BillingConcept AS CF WITH (NOLOCK) ON CUPS.BillingConceptId = CF.Id 
	   INNER JOIN GeneralLedger.MainAccounts AS CU WITH (NOLOCK) ON CF.EntityIncomeAccountId = CU.Id 
	   LEFT JOIN common.OperatingUnit AS OP WITH (NOLOCK) ON f.OperatingUnitId = op.Id
	   LEFT JOIN Billing.BillingGroup AS GF WITH (NOLOCK) ON CUPS.BillingGroupId = GF.Id
	   LEFT JOIN Contract.CupsSubgroup AS SCUP WITH (NOLOCK) ON CUPS.CUPSSubGroupId = SCUP.Id
	   LEFT JOIN Contract.RIPSServices AS SR WITH (NOLOCK) on SR.Id = CUPS.RIPSServiceId 


	   --LEFT JOIN .INDIAGNOP AS DIAG ON DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1
	   --INNER JOIN .INDIAGNOS AS 
WHERE  ING.IFECHAING >= '07-01-2025 00:00:00' and f.InvoiceDate >= '07-01-2025 00:00:00' 
--order by ING.IFECHAING DESC;
--ING.IPCODPACI IN ('20851115')
--ING.IFECHAING BETWEEN '2019-01-01' AND '2019-12-31' AND  GA.Code in ('BOG037', 'BOG038', 'BOG075')--ING.NUMINGRES='215531' O 88643')
