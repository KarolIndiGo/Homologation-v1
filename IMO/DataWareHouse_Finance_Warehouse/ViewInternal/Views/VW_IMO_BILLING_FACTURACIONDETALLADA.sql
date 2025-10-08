-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_BILLING_FACTURACIONDETALLADA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   VIEW [ViewInternal].[VW_IMO_BILLING_FACTURACIONDETALLADA]
AS

SELECT 
       CASE 
           WHEN UF.Code like 'IMON%' THEN 'Neiva'
           else 'Pitalito'
       END AS Sucursal,
       CASE F.DocumentType
           WHEN '1' THEN               'Factura EAPB con Contrato'
           WHEN '2' THEN               'Factura EAPB Sin Contrato'
           WHEN '3' THEN               'Factura Particular'
           WHEN '4' THEN               'Factura Capitada '
           WHEN '5' THEN               'Control de Capitacion'
           WHEN '6' THEN               'Factura Basica'
           WHEN '7' THEN               'Factura de Venta de Productos'
       END AS TipoDocumento,
       cat.Name AS Categoría,
       F.InvoiceNumber AS Factura,
       F.AdmissionNumber AS Ingreso,
       ing.IFECHAING AS FechaIngreso,--ing.ICAUSAING,
       CASE ing.ICAUSAING
           WHEN '1' THEN               'Heridos en combate'
           WHEN '2' THEN               'Enfermedad profesional'
           WHEN '3' THEN               'Enfermedad general adulto'
           WHEN '4' THEN               'Enfermedad general pediatría'
           WHEN '5' THEN               'Odontología'
           WHEN '6' THEN               'Accidente_transito'
           WHEN '7' THEN               'Catastrofe/Fisalud'
           WHEN '8' THEN               'Quemados'
           WHEN '9' THEN               'Maternidad'
           WHEN '10' THEN               'Accidente_Laboral'
           WHEN '11' THEN               'Cirugia_Programada'
		   WHEN '12' THEN				'Accidente de trabajo'
		   WHEN '13' THEN               'Accidente en el hogar'
		   WHEN '15' THEN               'Derivado de consulta externa'
		   WHEN '16' THEN               'Accidente en el entorno educativo'
		   WHEN '27' THEN               'IVE por violencia sexual, incesto o por inseminacion artificial o transferencia de ovulo fecundado no consentida'
		   WHEN '28' THEN               'Evento adverso en salud'
		   WHEN '29' THEN               'Enfermedad general'
		   WHEN '30' THEN               'Enfermedad laboral'
       END AS [Causa de Ingreso],
       CASE ing.TIPOINGRE
           WHEN '1' THEN
               'Ambulatorio'
           WHEN '2' THEN
               'Hospitalario'
       END AS Tipo_Ingreso,
	   ing.IAUTORIZA AS AutorizacionIngreso,

	   CASE 
    WHEN P.IPTIPODOC = 1 THEN 'CC - Cédula de Ciudadanía'
    WHEN P.IPTIPODOC = 2 THEN 'CE - Cédula de Extranjería'
    WHEN P.IPTIPODOC = 3 THEN 'TI - Tarjeta de Identidad'
    WHEN P.IPTIPODOC = 4 THEN 'RC - Registro Civil'
    WHEN P.IPTIPODOC = 5 THEN 'PA - Pasaporte'
    WHEN P.IPTIPODOC = 6 THEN 'AS - Adulto Sin Identificación'
    WHEN P.IPTIPODOC = 7 THEN 'MS - Menor Sin Identificación'
    WHEN P.IPTIPODOC = 8 THEN 'NU - Número único de identificación personal'
    WHEN P.IPTIPODOC = 9 THEN 'CN - Certificado de Nacido Vivo'
    WHEN P.IPTIPODOC = 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)'
    WHEN P.IPTIPODOC = 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
    WHEN P.IPTIPODOC = 12 THEN 'PE - Permiso Especial de Permanencia (Aplica para extranjeros)'
    WHEN P.IPTIPODOC = 13 THEN 'PT - Permiso Temporal de Permanencia'
    WHEN P.IPTIPODOC = 14 THEN 'DE - Documento Extranjero'
    WHEN P.IPTIPODOC = 15 THEN 'SI - Sin Identificación'
    ELSE 'Tipo de documento desconocido'
END AS [Tipo Documento Paciente],

       F.PatientCode AS Identificación,
       P.IPNOMCOMP AS Paciente,
       ga.Name AS GrupoAtención,
       F.TotalInvoice AS TotalFactura,
       F.InvoiceDate AS [Fecha Factura],
       dos.InvoicedQuantity AS Cantidad,
       CASE
           WHEN dq.TotalSalesPrice IS NULL THEN
               dos.TotalSalesPrice
           ELSE
               dq.TotalSalesPrice
       END AS ValorUnitario,
       CASE
           WHEN dq.TotalSalesPrice IS NULL THEN
               DF.GrandTotalSalesPrice
           ELSE
               dq.TotalSalesPrice
       END AS ValorTotal,
     CASE WHEN t.PersonType = '1' THEN '999' ELSE t.Nit END AS [Nit Entidad], 
CASE WHEN t.PersonType = '1' THEN 'PACIENTES PARTICULARES' ELSE t.Name END AS Entidad,
	 --t.Nit,
      -- ea.Code + ' - ' + ea.Name AS [Entidad Administradora],
       CASE dos.RecordType
           WHEN '1' THEN
               'Servicios'
           WHEN '2' THEN
               'Medicamentos'
       END AS ServiciosMedicamentos,
       CASE
           WHEN pr.Code IS NULL THEN
               ServiciosIPS.Code 
           ELSE
               pr.Code
       END AS Código,
       CASE
           WHEN pr.Name IS NULL THEN
               ServiciosIPS.Name
           ELSE
               pr.Name
       END AS Descripción,
       CASE dos.Presentation
           WHEN '1' THEN
               'No Quirúrgico'
           WHEN '2' THEN
               'Quirúrgico'
           WHEN '3' THEN
               'Paquete'
       END AS PresentacionServicio,
       ServiciosIPSQ.Code AS Subcodigo,
       ServiciosIPSQ.Name AS Subnombre,
       CASE
           WHEN dq.PerformsHealthProfessionalCode IS NULL THEN
               dos.PerformsHealthProfessionalCode
           ELSE
               dq.PerformsHealthProfessionalCode
       END AS CodigoMèdico,
       CASE
           WHEN RTRIM(medqx.NOMMEDICO) IS NULL THEN
               med.NOMMEDICO
           ELSE
               RTRIM(medqx.NOMMEDICO)
       END AS NombreMedico,
       UF.Code AS UnidadFuncional,
       UF.Name AS DescripcionUnidadFuncional,
	   CC.Name AS [Centro de Costo],
       CASE WHEN salida.FECALTPAC IS NULL THEN F.OutputDate ELSE salida.FECALTPAC END AS FechaAltaMedica,
       diag.CODDIAGNO AS CIE10,
       diag.NOMDIAGNO AS Diagnóstico,
       CASE
           WHEN espmed.DESESPECI IS NULL THEN
               espqx.DESESPECI
           ELSE
               espmed.DESESPECI
       END AS Especialidad,
       os.Code AS Orden,
       os.OrderDate AS FechaOrden,
	   dos.AuthorizationNumber as AutorizacionOrden,
       CASE dos.SettlementType
           WHEN '3' THEN
               'Si'
           ELSE
               'No'
       END AS AplicaProcedimiento,
       CASE F.IsCutAccount
           WHEN 'True' THEN
               'Si'
           ELSE
               'No'
       END AS Corte,
       per.Fullname AS Usuario,
       gf.Name AS [Grupo Facturación],
       CUPS.Code AS CUPS,
       CUPS.Description AS [Descripcion CUPS],
       BB.UBINOMBRE AS Ubicación,
       EE.MUNNOMBRE AS Municipio,
       ServiciosIPSQ.Score AS UVR,
       ServiciosIPSQ.NewScore AS [UVR > 450],
       sg.Name AS [Grupo Quirurgico],   dos.CostValue as ValorCosto, dos.CostValue*dos.InvoicedQuantity as CostoTotal,
	   F.CUFE AS CUFE,
	   case when fec is null then F.OutputDate else fec end AS [Fecha Egreso],
	   F.TotalPatientSalesPrice AS [Cuota Moderadora],
	   ad.AdjusmentValue AS [Valor Nota Credito],
	   fol.Observations AS [Observacion]
	   --ing.FECHEGRESO as [n]
	, F.TotalPatientSalesPrice as CuotaRecuperacionPaciente, F.ValueVoucher as ValorBonoPaciente, F.PatientPaidValue as ValorPagadoPaciente
	,ne. ConsecutivoDianNota, Naturaleza, [Estado Nota DIAN], [Estado Envio DIAN], CUDE, Cliente, FechaDocumento, FechaEnvio,
	CONCAT(NEF.Code,' - ',NEF.Name) As [Finalidad Consulta/Procedimiento],
			CASE
			WHEN NEF.Code in ('11','12','13','15','16','17','18','19','20','22','23','24','25','27','43','44') THEN 'AC y AP'
			WHEN NEF.Code in ('14','26','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42') THEN 'AP'
			WHEN NEF.Code in ('21') THEN 'AC'
			ELSE '' END AS 'Finalidad Aplica Para'

FROM [INDIGO035].[Billing].[Invoice] AS F
    INNER JOIN [INDIGO035].[Billing].[InvoiceDetail] AS DF
        INNER JOIN [INDIGO035].[Billing].[ServiceOrderDetail] AS dos
            LEFT JOIN [INDIGO035].[Contract].[IPSService] AS ServiciosIPS
                ON ServiciosIPS.Id = dos.IPSServiceId
            LEFT JOIN [INDIGO035].[Inventory].[InventoryProduct] AS pr
                ON pr.Id = dos.ProductId
            LEFT JOIN [INDIGO035].[dbo].[INPROFSAL] AS med
                LEFT JOIN [INDIGO035].[dbo].[INESPECIA] AS espmed
                    ON espmed.CODESPECI = med.CODESPEC1
                ON med.CODPROSAL = dos.PerformsHealthProfessionalCode
            LEFT JOIN [INDIGO035].[Payroll].[FunctionalUnit] AS UF
                ON UF.Id = dos.PerformsFunctionalUnitId
			LEFT JOIN [INDIGO035].[Payroll].[CostCenter] AS CC
                ON UF.CostCenterId = CC.Id
            LEFT JOIN [INDIGO035].[Billing].[ServiceOrder] AS os
                ON os.Id = dos.ServiceOrderId
            LEFT JOIN [INDIGO035].[Contract].[CUPSEntity] AS CUPS
                LEFT JOIN [INDIGO035].[Billing].[BillingGroup] AS gf
                    ON gf.Id = CUPS.BillingGroupId
                ON CUPS.Id = dos.CUPSEntityId
            LEFT JOIN [INDIGO035].[Billing].[ServiceOrderDetailSurgical] AS dq
                LEFT JOIN [INDIGO035].[dbo].[INPROFSAL] AS medqx
                    LEFT JOIN [INDIGO035].[dbo].[INESPECIA] AS espqx
                        ON espqx.CODESPECI = medqx.CODESPEC1
                    ON medqx.CODPROSAL = dq.PerformsHealthProfessionalCode
                LEFT JOIN [INDIGO035].[Contract].[IPSService] AS ServiciosIPSQ
                    ON ServiciosIPSQ.Id = dq.IPSServiceId
                ON dq.ServiceOrderDetailId = dos.Id
                   AND dq.OnlyMedicalFees = '0'
            ON dos.Id = DF.ServiceOrderDetailId
               AND (dos.IsDelete = '0')
        ON DF.InvoiceId = F.Id
    INNER JOIN [INDIGO035].[Security].[UserInt] AS u
        INNER JOIN [INDIGO035].[Security].[PersonInt] AS per
            ON per.Id = u.IdPerson
        ON u.UserCode = F.InvoicedUser
    INNER JOIN [INDIGO035].[dbo].[ADINGRESO] AS ing ON ing.NUMINGRES = F.AdmissionNumber
        LEFT JOIN [INDIGO035].[dbo].[INDIAGNOS] AS diag ON diag.CODDIAGNO = F.OutputDiagnosis --ing.CODDIAEGR SELECT * FROM Billing.Invoice WHERE InvoiceNumber='IMNV10000'
        
    INNER JOIN [INDIGO035].[dbo].[INPACIENT] AS P
        LEFT JOIN [INDIGO035].[dbo].[INUBICACI] AS BB
            LEFT JOIN [INDIGO035].[dbo].[INMUNICIP] AS EE
                ON EE.DEPMUNCOD = BB.DEPMUNCOD
            ON BB.AUUBICACI = P.AUUBICACI
        ON P.IPCODPACI = F.PatientCode
    INNER JOIN [INDIGO035].[Common].[ThirdParty] AS t
        ON t.Id = F.ThirdPartyId
    INNER JOIN [INDIGO035].[Contract].[CareGroup] AS ga
        ON ga.Id = F.CareGroupId
    LEFT JOIN [INDIGO035].[Contract].[HealthAdministrator] AS ea
        ON ea.Id = F.HealthAdministratorId
    LEFT JOIN [INDIGO035].[Billing].[InvoiceCategories] AS cat
        ON cat.Id = F.InvoiceCategoryId
    LEFT JOIN [INDIGO035].[dbo].[HCREGEGRE] AS salida
        ON salida.NUMINGRES = F.AdmissionNumber   
    LEFT JOIN [INDIGO035].[Common].[OperatingUnit] AS uo
        ON uo.Id = F.OperatingUnitId
    LEFT JOIN [INDIGO035].[Contract].[SurgicalGroup] AS sg
        ON sg.Id = ServiciosIPSQ.SurgicalGroupId
    LEFT JOIN [INDIGO035].[Portfolio].[AccountReceivable] AS por 
	    ON por.InvoiceNumber = F.InvoiceNumber
	LEFT JOIN [INDIGO035].[Portfolio].[PortfolioNoteAccountReceivableAdvance] AS ad
	    ON ad.AccountReceivableId = por.Id
    LEFT JOIN [INDIGO035].[Portfolio].[PortfolioNote] AS fol
	   ON fol.Id = ad.PortfolioNoteId



	LEFT JOIN (
	   SELECT NUMINGRES, MAX(FECHISPAC) AS fec
	   FROM [INDIGO035].[dbo].[HCHISPACA]
	   WHERE INDICAPAC = '12'
	   GROUP BY NUMINGRES
	)AS sub ON sub.NUMINGRES = ing.NUMINGRES
	left join [DataWareHouse_Finance].[ViewInternal].[VW_IMO_BILLING_REPORTENOTASELECTRONICAS] as ne on ne.Factura=F.InvoiceNumber
	left join [INDIGO035].[Admissions].[HealthPurposes] AS NEF on NEF.Id = ing.IdHealthPurposes

	
WHERE (F.Status = '1')
      AND year(F.InvoiceDate) >= '2023'
     --AND F.InvoiceDate >= '2025-07-01 23:59:59'
     -- AND (F.DocumentType <> '5')
     -- AND (uo.Id = '1') --and UF.Code not like 'E%'
	  --and  ing.CODCENATE='00104' 
	 -- and f.AdmissionNumber='20173'
	 --and f.InvoiceNumber='IMNV3145'
	 --and f.InvoiceNumber in ('IMNV10000','IMNV3145')

