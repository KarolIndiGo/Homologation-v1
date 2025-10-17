-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Billing_FacturacionDetallada
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE  VIEW [ViewInternal].[Billing_FacturacionDetallada] AS
select  TipoDocumento, Categoría, Factura, Ingreso, FechaIngreso, [Causa de Ingreso], 
Tipo_Ingreso, AutorizacionIngreso, Identificación, Paciente, GrupoAtención, TotalFactura, [Fecha Factura], Cantidad, ValorUnitario, ValorTotal, Nit, [Entidad Administradora], 
             ServiciosMedicamentos, Código, Descripción, PresentacionServicio, Subcodigo, Subnombre, 
			 case when CodigoMèdico='YCS' then 'YCASTILLO' else CodigoMèdico end as CodigoMèdico, 
			 case when CodigoMèdico='YCS' then 'YEINSI MARIVEL CASTILLO SIERRA' else NombreMedico end as NombreMedico, UnidadFuncional, DescripcionUnidadFuncional, FechaAltaMedica, CIE10, Diagnóstico, 
			 case when CodigoMèdico='YCS' then 'BACTERIOLOGO' else Especialidad end as Especialidad, Orden, FechaOrden, AutorizacionOrden, 
             AplicaProcedimiento, Corte, Usuario, [Grupo Facturación], CUPS, [Descripcion CUPS], Ubicación, Municipio, UVR, [UVR > 450], [Grupo Quirurgico], Observacion as ObservacionFolio
from (
SELECT        CASE ing.CODCENATE WHEN '001' THEN 'Neiva' WHEN '002' THEN 'Florencia' WHEN '003' THEN 'Pitalito' WHEN '004' THEN 'Tunja'  WHEN '00401' THEN 'Tunja' WHEN '00101' THEN 'Neiva' WHEN '00102' THEN 'Neiva' WHEN '00103' THEN 'Neiva' WHEN
                          '00104' THEN 'Neiva' END AS Sucursal, 
                         CASE F.DocumentType WHEN '1' THEN 'Factura EAPB con Contrato' WHEN '2' THEN 'Factura EAPB Sin Contrato' WHEN '3' THEN 'Factura Particular' WHEN '4' THEN 'Factura Capitada ' WHEN '5' THEN 'Control de Capitacion' WHEN
                          '6' THEN 'Factura Basica' WHEN '7' THEN 'Factura de Venta de Productos' END AS TipoDocumento, cat.Name AS Categoría, F.InvoiceNumber AS Factura, F.AdmissionNumber AS Ingreso, ing.IFECHAING AS FechaIngreso, 
                         CASE ing.ICAUSAING WHEN '1' THEN 'Heridos_en_combate' WHEN '2' THEN 'Enfermedad_profesional' WHEN '3' THEN 'Enfermedad_gral_adulto' WHEN '4' THEN 'Enfermedad_gral_pediatria' WHEN '5' THEN 'Odontología' WHEN
                          '6' THEN 'Accidente_transito' WHEN '7' THEN 'Catastrofe/Fisalud' WHEN '8' THEN 'Quemados' WHEN '9' THEN 'Maternidad' WHEN '10' THEN 'Accidente_Laboral' WHEN '11' THEN 'Cirugia_Programada' END AS [Causa de Ingreso],
                          CASE ing.TIPOINGRE WHEN '1' THEN 'Ambulatorio' WHEN '2' THEN 'Hospitalario' END AS Tipo_Ingreso, ING.IAUTORIZA AS AutorizacionIngreso, F.PatientCode AS Identificación, P.IPNOMCOMP AS Paciente, ga.Name AS GrupoAtención, F.TotalInvoice AS TotalFactura, 
                         F.InvoiceDate AS [Fecha Factura], dos.InvoicedQuantity AS Cantidad, CASE WHEN dq.TotalSalesPrice IS NULL THEN dos.TotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorUnitario, CASE WHEN dq.TotalSalesPrice IS NULL 
                         THEN DF.GrandTotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorTotal, t.Nit, ea.Code + ' - ' + ea.Name AS [Entidad Administradora], 
                         CASE dos.RecordType WHEN '1' THEN 'Servicios' WHEN '2' THEN 'Medicamentos' END AS ServiciosMedicamentos, CASE WHEN pr.Code IS NULL THEN ServiciosIPS.Code ELSE pr.Code END AS Código, 
                         CASE WHEN pr.Name IS NULL THEN ServiciosIPS.Name ELSE pr.Name END AS Descripción, 
                         CASE dos.Presentation WHEN '1' THEN 'No Quirúrgico' WHEN '2' THEN 'Quirúrgico' WHEN '3' THEN 'Paquete' END AS PresentacionServicio, ServiciosIPSQ.Code AS Subcodigo, ServiciosIPSQ.Name AS Subnombre, 
                         CASE WHEN dq.PerformsHealthProfessionalCode IS NULL THEN dos.PerformsHealthProfessionalCode ELSE dq.PerformsHealthProfessionalCode END AS CodigoMèdico, CASE WHEN RTRIM(medqx.NOMMEDICO) IS NULL 
                         THEN med.NOMMEDICO ELSE RTRIM(medqx.NOMMEDICO) END AS NombreMedico, UF.Code AS UnidadFuncional, UF.Name AS DescripcionUnidadFuncional, salida.FECALTPAC AS FechaAltaMedica, ing.CODDIAEGR AS CIE10, 
                         diag.NOMDIAGNO AS Diagnóstico, CASE WHEN espmed.DESESPECI IS NULL THEN espqx.DESESPECI ELSE espmed.DESESPECI END AS Especialidad, os.Code AS Orden, os.OrderDate AS FechaOrden, dos.AuthorizationNumber as AutorizacionOrden,
                         CASE dos.SettlementType WHEN '3' THEN 'Si' ELSE 'No' END AS AplicaProcedimiento, CASE F.IsCutAccount WHEN 'True' THEN 'Si' ELSE 'No' END AS Corte, per.Fullname AS Usuario, gf.Name AS [Grupo Facturación], 
                         CUPS.Code AS CUPS, CUPS.Description AS [Descripcion CUPS], BB.UBINOMBRE AS Ubicación, EE.MUNNOMBRE AS Municipio, ServiciosIPSQ.Score AS UVR, ServiciosIPSQ.NewScore AS [UVR > 450], 
                         sg.Name AS [Grupo Quirurgico], rcd.Observation as Observacion, rcd.*
FROM            Billing.Invoice AS F INNER JOIN
                         Billing.InvoiceDetail AS DF INNER JOIN
                         Billing.ServiceOrderDetail AS dos LEFT OUTER JOIN
                         Contract.IPSService AS ServiciosIPS ON ServiciosIPS.Id = dos.IPSServiceId LEFT OUTER JOIN
                         Inventory.InventoryProduct AS pr ON pr.Id = dos.ProductId LEFT OUTER JOIN
                         dbo.INPROFSAL AS med LEFT OUTER JOIN
                         dbo.INESPECIA AS espmed ON espmed.CODESPECI = med.CODESPEC1 ON med.CODPROSAL = dos.PerformsHealthProfessionalCode LEFT OUTER JOIN
                         Payroll.FunctionalUnit AS UF ON UF.Id = dos.PerformsFunctionalUnitId LEFT OUTER JOIN
                         Billing.ServiceOrder AS os ON os.Id = dos.ServiceOrderId LEFT OUTER JOIN
                         Contract.CUPSEntity AS CUPS LEFT OUTER JOIN
                         Billing.BillingGroup AS gf ON gf.Id = CUPS.BillingGroupId ON CUPS.Id = dos.CUPSEntityId LEFT OUTER JOIN
                         Billing.ServiceOrderDetailSurgical AS dq LEFT OUTER JOIN
                         dbo.INPROFSAL AS medqx LEFT OUTER JOIN
                         dbo.INESPECIA AS espqx ON espqx.CODESPECI = medqx.CODESPEC1 ON medqx.CODPROSAL = dq.PerformsHealthProfessionalCode LEFT OUTER JOIN
                         Contract.IPSService AS ServiciosIPSQ ON ServiciosIPSQ.Id = dq.IPSServiceId ON dq.ServiceOrderDetailId = dos.Id AND dq.OnlyMedicalFees = '0' ON dos.Id = DF.ServiceOrderDetailId AND dos.IsDelete = '0' ON 
                         DF.InvoiceId = F.Id INNER JOIN
                         Security.[User] AS u INNER JOIN
                         Security.Person AS per ON per.Id = u.IdPerson ON u.UserCode = F.InvoicedUser INNER JOIN
                         dbo.ADINGRESO AS ing LEFT OUTER JOIN
                         dbo.INDIAGNOS AS diag ON diag.CODDIAGNO = ing.CODDIAEGR ON ing.NUMINGRES = F.AdmissionNumber INNER JOIN
                         dbo.INPACIENT AS P LEFT OUTER JOIN
                         dbo.INUBICACI AS BB LEFT OUTER JOIN
                         dbo.INMUNICIP AS EE ON EE.DEPMUNCOD = BB.DEPMUNCOD ON BB.AUUBICACI = P.AUUBICACI ON P.IPCODPACI = F.PatientCode INNER JOIN
                         Common.ThirdParty AS t ON t.Id = F.ThirdPartyId INNER JOIN
                         Contract.CareGroup AS ga ON ga.Id = F.CareGroupId LEFT OUTER JOIN
                         Contract.HealthAdministrator AS ea ON ea.Id = F.HealthAdministratorId LEFT OUTER JOIN
                         Billing.InvoiceCategories AS cat ON cat.Id = F.InvoiceCategoryId LEFT OUTER JOIN
                         dbo.HCREGEGRE AS salida ON salida.NUMINGRES = F.AdmissionNumber LEFT OUTER JOIN
                         Common.OperatingUnit AS uo ON uo.Id = F.OperatingUnitId LEFT OUTER JOIN
                         Contract.SurgicalGroup AS sg ON sg.Id = ServiciosIPSQ.SurgicalGroupId LEFT OUTER JOIN
                         Billing.RevenueControl AS RC ON RC.AdmissionNumber = F.AdmissionNumber LEFT OUTER JOIN
                         --Billing.revenuecontroldetailinvoice as rcdd on rcdd.InvoiceId=f.id LEFT OUTER JOIN
                         Billing.RevenueControlDetail AS rcd ON rcd.RevenueControlId = RC.Id AND F.HealthAdministratorId = rcd.HealthAdministratorId and rcd.CareGroupId=f.CareGroupId
                         and rcd.InvoiceCategoryId=f.InvoiceCategoryId and rcd.Status=2 and f.TotalInvoice=rcd.TotalFolio
WHERE        (F.Status = '1') AND YEAR(F.InvoiceDate) >= '2022' ) as a 
--where ingreso='4485425'
