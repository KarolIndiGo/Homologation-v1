-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Billing_FacturacionServicios
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE view [ViewInternal].[Billing_FacturacionServicios] as

SELECT unitname as UnidadOperativa,
       CASE F.DocumentType
           WHEN '1' THEN
               'Factura EAPB con Contrato'
           WHEN '2' THEN
               'Factura EAPB Sin Contrato'
           WHEN '3' THEN
               'Factura Particular'
           WHEN '4' THEN
               'Factura Capitada '
           WHEN '5' THEN
               'Control de Capitacion'
           WHEN '6' THEN
               'Factura Basica'
           WHEN '7' THEN
               'Factura de Venta de Productos'
       END AS TipoDocumento,
       cat.Name AS Categoría,
       F.InvoiceNumber AS Factura,
       F.AdmissionNumber AS Ingreso,
       ing.IFECHAING AS FechaIngreso,
       
       CASE ing.TIPOINGRE
           WHEN '1' THEN
               'Ambulatorio'
           WHEN '2' THEN
               'Hospitalario'
       END AS Tipo_Ingreso,
	   ING.IAUTORIZA AS AutorizacionIngreso,
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
       t.Nit,
       ea.Code + ' - ' + ea.Name AS [Entidad Administradora],
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
    
       CASE
           WHEN espmed.DESESPECI IS NULL THEN
               espqx.DESESPECI
           ELSE
               espmed.DESESPECI
       END AS Especialidad,
       os.Code AS Orden,
       os.OrderDate AS FechaOrden,
	 --  dos.ServiceDate as FechaServicio,
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
        case when gf.Name is null then gfp.name else gf.name end AS [Grupo Facturación],
       CUPS.Code AS CUPS,
       CUPS.Description AS [Descripcion CUPS],
       BB.UBINOMBRE AS Ubicación,
       EE.MUNNOMBRE AS Municipio, f.CUFE as CUFE
FROM Billing.Invoice AS F
    INNER JOIN Billing.InvoiceDetail AS DF
        INNER JOIN Billing.ServiceOrderDetail AS dos
            LEFT JOIN Contract.IPSService AS ServiciosIPS
                ON ServiciosIPS.Id = dos.IPSServiceId
            LEFT JOIN Inventory.InventoryProduct AS pr
                ON pr.Id = dos.ProductId
            LEFT JOIN dbo.INPROFSAL AS med
                LEFT JOIN dbo.INESPECIA AS espmed
                    ON espmed.CODESPECI = med.CODESPEC1
                ON med.CODPROSAL = dos.PerformsHealthProfessionalCode
            LEFT JOIN Payroll.FunctionalUnit AS UF
                ON UF.Id = dos.PerformsFunctionalUnitId
            LEFT JOIN Billing.ServiceOrder AS os
                ON os.Id = dos.ServiceOrderId
            LEFT JOIN Contract.CUPSEntity AS CUPS
                LEFT JOIN Billing.BillingGroup AS gf
                    ON gf.Id = CUPS.BillingGroupId
                ON CUPS.Id = dos.CUPSEntityId
            LEFT JOIN Billing.ServiceOrderDetailSurgical AS dq
                LEFT JOIN dbo.INPROFSAL AS medqx
                    LEFT JOIN dbo.INESPECIA AS espqx
                        ON espqx.CODESPECI = medqx.CODESPEC1
                    ON medqx.CODPROSAL = dq.PerformsHealthProfessionalCode
                LEFT JOIN Contract.IPSService AS ServiciosIPSQ
                    ON ServiciosIPSQ.Id = dq.IPSServiceId
                ON dq.ServiceOrderDetailId = dos.Id
                   AND dq.OnlyMedicalFees = '0'
            ON dos.Id = DF.ServiceOrderDetailId
               AND (dos.IsDelete = '0')
        ON DF.InvoiceId = F.Id
    INNER JOIN Security.[User] AS u
        INNER JOIN Security.Person AS per
            ON per.Id = u.IdPerson
        ON u.UserCode = F.InvoicedUser
    INNER JOIN dbo.ADINGRESO AS ing
        LEFT JOIN dbo.INDIAGNOS AS diag
            ON diag.CODDIAGNO = ing.CODDIAEGR
        ON ing.NUMINGRES = F.AdmissionNumber
    INNER JOIN dbo.INPACIENT AS P
        LEFT JOIN dbo.INUBICACI AS BB
            LEFT JOIN dbo.INMUNICIP AS EE
                ON EE.DEPMUNCOD = BB.DEPMUNCOD
            ON BB.AUUBICACI = P.AUUBICACI
        ON P.IPCODPACI = F.PatientCode
    INNER JOIN Common.ThirdParty AS t
        ON t.Id = F.ThirdPartyId
    INNER JOIN Contract.CareGroup AS ga
        ON ga.Id = F.CareGroupId
    LEFT JOIN Contract.HealthAdministrator AS ea
        ON ea.Id = F.HealthAdministratorId
    LEFT JOIN Billing.InvoiceCategories AS cat
        ON cat.Id = F.InvoiceCategoryId
    LEFT JOIN dbo.HCREGEGRE AS salida
        ON salida.NUMINGRES = F.AdmissionNumber   
    LEFT JOIN Common.OperatingUnit AS uo
        ON uo.Id = F.OperatingUnitId
    LEFT JOIN Contract.SurgicalGroup AS sg
        ON sg.Id = ServiciosIPSQ.SurgicalGroupId
		LEFT JOIN Billing.BillingGroup AS gfp
                    ON gfp.Id = pr.BillingGroupId
WHERE (F.Status = '1')
      AND F.InvoiceDate >= '2023/01/01 00:00:00'
      --AND F.InvoiceDate <= '31/12/2024 23:59:59'
      --AND (F.DocumentType <> '5')
      --AND (uo.Id = '3') --and UF.Code not like 'E%'
	  --and  ing.CODCENATE='00104' and f.AdmissionNumber='3917400   '

