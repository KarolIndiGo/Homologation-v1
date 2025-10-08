-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_SERVICIOS_FACTURADOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_SERVICIOS_FACTURADOS 
AS  

SELECT 
  (ING.IFECHAING) AS FECHA_INGRESO, ING.NUMINGRES AS INGRESO, ING.CODUSUCRE AS USUARIO_CREA, us.NOMUSUARI as UsuarioIngreso,CA.NOMCENATE AS CENTRO_ATENCION, U.UFUDESCRI AS UNIDAD_FUNCIONAL,
				CASE P.IPTIPODOC WHEN 1 THEN 'CC' WHEN 2 THEN 'CE' WHEN 3 THEN 'TI' WHEN 4 THEN 'RC' WHEN 5 THEN 'PA' WHEN 6 THEN 'AS' WHEN 7 THEN 'MS' WHEN 8 THEN 'NU' END AS TIPO_DOCUMENTO_PACIENTE,
				ING.IPCODPACI AS IDENTIFICACION_PACIENTE,P.IPNOMCOMP AS NOMBRE_PACIENTE, CUPS.Code AS CUPS, CUPS.Description AS CUPS_DESCRIPCION,
				F.InvoiceNumber AS FACTURA, CASE F.Status WHEN 1 THEN 'Facturado' WHEN 2 THEN 'Anulado' END AS Estado_Factura, FD.InvoicedQuantity AS CANTIDAD, 
				FD.TotalSalesPrice AS VALOR_UNITARIO, F.TotalInvoice AS TOTAL_FACTURA, 
				F.InvoiceDate AS FECHA_CIERRE, F.InvoicedUser AS USUARIOFACT, usufac.NOMUSUARI AS FUNCIONARIO,--t.Name AS FUNCIONARIO,
				CA.NOMCENATE AS Sede, GA.Code AS Cod_Grupo_Atencion , GA.Name AS Grupo_Atencion,

				SOD.PerformsHealthProfessionalCode AS [Codigo Profesional Factura], 

				PR.NOMMEDICO AS Profesional_Factura,
				ESP.DESESPECI AS Especialidad, 
				CASE F.DocumentType WHEN 1 THEN 'Factura por Evento de Servicios' WHEN 2 THEN 'Factura EAPB Sin Contrato' WHEN 3 THEN 'Factura Particular' WHEN 4 THEN 'Factura Capitada' 
				WHEN 5 THEN 'Control de Capitacion' WHEN 6 THEN 'Factura Basica' WHEN 7 THEN 'Factura de Venta de Productos' END AS TIPO_DOCUMENTO_FACTURADO,
				CASE WHEN CU.Number IS NULL THEN CCM.Number ELSE CU.Number END AS Cuenta, 
				CASE WHEN CU.Name IS NULL THEN CCM.Name ELSE CU.Name END AS CuentaContable,
				--,concepto facturacion
				P.IPDIRECCI AS Direccion_Paciente, P.IPTELEFON AS Telefono_Paciente, P.IPTELMOVI AS Celular_Paciente, P.IPFECNACI AS FechaNacimiento_Paciente, 
				datediff(year,P.IPFECNACI,GETDATE()) as Edad, DIAG.CODDIAGNO AS DX_Principal_HC,

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
			RTRIM(LTRIM(INDIGO031.dbo.Edad(CONVERT(varchar, P.IPFECNACI, 23), CONVERT(varchar,ING.IFECHAING, 23)))) AS EdadEnAtencion,
				
				CASE
					WHEN (DATEDIFF(year, P.IPFECNACI, ING.IFECHAING))  BETWEEN '0' AND '5' THEN 'Primera Infancia'
					WHEN (DATEDIFF(year, P.IPFECNACI, ING.IFECHAING))  BETWEEN '6' AND '11' THEN 'Infancia'
					WHEN (DATEDIFF(year, P.IPFECNACI, ING.IFECHAING))  BETWEEN '12' AND '17' THEN 'Adolecencia'
					WHEN (DATEDIFF(year, P.IPFECNACI, ING.IFECHAING))  BETWEEN '18' AND '28' THEN 'Juventud'
					WHEN (DATEDIFF(year, P.IPFECNACI, ING.IFECHAING))  BETWEEN '29' AND '59' THEN 'Adultez'
					WHEN (DATEDIFF(year, P.IPFECNACI, ING.IFECHAING))  >= '60' THEN 'Vejez'
				END AS Ciclo_Vida,
			cccd.Name as CentroCostoFacturacion,
			SOD.ServiceDate as FechaPrestacionServicio,
			CASE 
                WHEN SOD.ApplyRIAS = '1' THEN 'Si' 
                ELSE 'No' END AS AplicaRIAS,
			RIAS.NOMBRE AS RIAS_Facturado,
--
ne.Code AS [Codigo Finalidad Consulta/Procedimiento], 
ne.Name As [Finalidad Consulta/Procedimiento],
CASE
			WHEN ne.Code in ('11','12','13','15','16','17','18','19','20','22','23','24','25','27','43','44') THEN 'AC y AP'
			WHEN ne.Code in ('14','26','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42') THEN 'AP'
			WHEN ne.Code in ('21') THEN 'AC'
			ELSE '' END AS 'Finalidad Aplica Para',

A.DESACTMED AS ACTIVIDAD,--, A.IDRIASCUPS--,  RC.ID
 F.AnnulmentUser + ' - ' + usAnu.NOMUSUARI AS [Usuario Anula], F.AnnulmentDate AS [Fecha Anulación], rf.Name AS [Motivo Anulación],
 FD.InvoicedQuantity *	FD.TotalSalesPrice AS ValorTotal

FROM INDIGO031.Billing.Invoice AS F 
INNER JOIN INDIGO031.Billing.InvoiceDetail AS FD  ON F.Id=FD.InvoiceId /*AND F.DocumentType=5 AND F.Status=1*/
INNER JOIN INDIGO031.Billing.ServiceOrderDetail AS SOD  ON FD.ServiceOrderDetailId=SOD.Id
INNER JOIN INDIGO031.Payroll.CostCenter as cccd    on cccd.Id= SOD.CostCenterId
INNER JOIN INDIGO031.Billing.ServiceOrder AS SO  ON SOD.ServiceOrderId=SO.Id and SO.AdmissionNumber=F.AdmissionNumber
INNER JOIN INDIGO031.Contract.CUPSEntity AS CUPS  ON CUPS.Id=SOD.CUPSEntityId
INNER JOIN INDIGO031.dbo.ADINGRESO AS ING  ON ING.NUMINGRES=F.AdmissionNumber
LEFT JOIN  INDIGO031.dbo.INPROFSAL AS PR ON PR.CODPROSAL=SOD.PerformsHealthProfessionalCode
LEFT JOIN  INDIGO031.dbo.INESPECIA AS ESP ON PR.CODESPEC1 = ESP.CODESPECI
INNER JOIN INDIGO031.Contract.CareGroup AS GA  ON GA.Id=SOD.CareGroupId
INNER JOIN INDIGO031.dbo.ADCENATEN AS CA  ON CA.CODCENATE = ING.CODCENATE
INNER JOIN INDIGO031.dbo.INUNIFUNC AS U  ON U.UFUCODIGO = ING.UFUCODIGO
INNER JOIN INDIGO031.dbo.INPACIENT AS P  ON P.IPCODPACI = ING.IPCODPACI
LEFT JOIN INDIGO031.Common.ThirdParty AS T  on F.InvoicedUser = T.Nit
JOIN INDIGO031.dbo.SEGusuaru AS us  on ING.CODUSUCRE = us.CODUSUARI
LEFT JOIN INDIGO031.Billing.BillingConcept AS CF  ON CUPS.BillingConceptId = CF.Id 
left JOIN INDIGO031.GeneralLedger.MainAccounts AS CU  ON CF.EntityIncomeAccountId = CU.Id  ---left era inner
LEFT JOIN INDIGO031.dbo.INDIAGNOP AS DIAG ON DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1
LEFT JOIN INDIGO031.dbo.RIASCUPSPACIENTE AS RP ON RP.IDDETALLEORDENSERVICIO=SOD.Id 
LEFT JOIN INDIGO031.dbo.RIASCUPS AS RC ON RC.ID = RP.IDRIASCUPS
LEFT JOIN INDIGO031.dbo.RIAS AS RIAS ON RIAS.ID = RC.IDRIAS 
LEFT join INDIGO031.dbo.AGACTIMED AS A ON RC.ID = A.IDRIASCUPS and A.ESTADOACT = '1'
LEFT JOIN INDIGO031.dbo.SEGusuaru AS usufac  on F.InvoicedUser = usufac.CODUSUARI
LEFT JOIN INDIGO031.dbo.SEGusuaru AS usAnu  on F.AnnulmentUser = usAnu.CODUSUARI
left join INDIGO031.Billing.BillingReversalReason as rf on F.ReversalReasonId = rf.Id
left join INDIGO031.Admissions.HealthPurposes as ne on  ne.Id = ING.IdHealthPurposes
LEFT JOIN (SELECT  B.Id AS IDCONCEPTO, M.Number, M.Name, B.Code
            FROM INDIGO031.Billing.BillingConceptAccount AS C 
            INNER JOIN INDIGO031.Billing.BillingConcept AS B  ON B.Id=C.BillingConceptId
            INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS M  ON M.Id=C.EntityIncomeAccountId
            GROUP BY B.Id, M.Number, M.Name, B.Code) AS CCM ON CCM.IDCONCEPTO=CUPS.BillingConceptId

