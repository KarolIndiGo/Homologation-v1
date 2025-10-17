-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_FACTURA_DIA
-- Extracted by Fabric SQL Extractor SPN v3.9.0







CREATE VIEW [Report].[View_HDSAP_FACTURA_DIA]
AS

SELECT       CASE f.documentType WHEN '1' THEN 'Factura EAPB con Contrato' WHEN '2' THEN 'Factura EAPB Sin Contrato' WHEN '3' THEN 'Factura Particular' WHEN '4' THEN 'Factura Capitada ' WHEN '5' THEN 'Control de Capitacion' WHEN
                          '6' THEN 'Factura Basica' WHEN '7' THEN 'Factura de Venta de Productos' END AS TipoDocumento, cat.Name AS Categoría, F.InvoiceNumber AS Factura,case f.[Status] when '1' THEN 'Facturado' when '2' then 'Anulado' end as 'Estado'
						   , F.InvoiceDate AS FechaFactura, F.TotalInvoice AS TotalFactura, 
                         F.AdmissionNumber AS Ingreso, ing.IFECHAING AS FechaIngreso, 
                         CASE ing.ICAUSAING WHEN '1' THEN 'Heridos_en_combate' WHEN '2' THEN 'Enfermedad_profesional' WHEN '3' THEN 'Enfermedad_gral_adulto' WHEN '4' THEN 'Enfermedad_gral_pediatria' WHEN '5' THEN 'Odontología' WHEN
                          '6' THEN 'Accidente_transito' WHEN '7' THEN 'Catastrofe/Fisalud' WHEN '8' THEN 'Quemados' WHEN '9' THEN 'Maternidad' WHEN '10' THEN 'Accidente_Laboral' WHEN '11' THEN 'Cirugia_Programada' END AS [Causa de Ingreso],
                          CASE ing.TIPOINGRE WHEN '1' THEN 'Ambulatorio' WHEN '2' THEN 'Hospitalario' END AS Tipo_Ingreso, F.PatientCode AS Identificación,
						  CASE p.IPTIPODOC
                             WHEN '1'
                             THEN 'CC'
                             WHEN '2'
                             THEN 'CE '
                             WHEN '3'
                             THEN 'TI'
                             WHEN '4'
                             THEN 'RC'
                             WHEN '5'
                             THEN 'PA'
                             WHEN '6'
                             THEN 'AS'
                             WHEN '7'
                             THEN 'MS'
                             WHEN '8'
                             THEN 'NU'
                         END AS [Tipo Documento],
						  
						  P.IPNOMCOMP AS Paciente,DATEDIFF(YEAR, P.IPFECNACI,ing.IFECHAING) AS EdadAños, ga.Name AS GrupoAtención, t.Nit,t.Name as 'Tercero',  
                         ea.Code + ' - ' + ea.Name AS [Entidad Administradora], CASE dos.RecordType WHEN '1' THEN 'Servicios' WHEN '2' THEN 'Medicamentos' END AS ServiciosMedicamentos, CASE WHEN pr.Code IS NULL 
                         THEN ServiciosIPS.Code ELSE pr.Code END AS Código, CASE WHEN pr.Name IS NULL THEN ServiciosIPS.Name ELSE pr.Name END AS Descripción, 
                         CASE dos.Presentation WHEN '1' THEN 'No Quirúrgico' WHEN '2' THEN 'Quirúrgico' WHEN '3' THEN 'Paquete' END AS PresentacionServicio, ServiciosIPSQ.Code AS Subcodigo, ServiciosIPSQ.Name AS Subnombre, 
                         dos.InvoicedQuantity AS Cantidad,df. SubTotalPatientSalesPrice As [Cuota Paciente], CASE WHEN dq.TotalSalesPrice IS NULL THEN dos.TotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorUnitario, CASE WHEN dq.TotalSalesPrice IS NULL 
                         THEN DF.GrandTotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorTotal, UF.Code AS UnidadFuncional, UF.Name AS DescripcionUnidadFuncional, cc.Code + '-' + cc.Name AS CentroCosto, 
                         salida.FECALTPAC AS FechaAltaMedica, ing.CODDIAEGR AS CIE10, diag.NOMDIAGNO AS Diagnóstico, CASE WHEN dq.PerformsHealthProfessionalCode IS NULL 
                         THEN dos.PerformsHealthProfessionalCode ELSE dq.PerformsHealthProfessionalCode END AS CodigoMèdico, CASE WHEN rtrim(medqx.NOMMEDICO) IS NULL THEN med.NOMMEDICO ELSE rtrim(medqx.NOMMEDICO) 
                         END AS NombreMedico, CASE WHEN espmed.DESESPECI IS NULL THEN espqx.DESESPECI ELSE espmed.DESESPECI END AS Especialidad, os.Code AS Orden, os.OrderDate AS FechaOrden, 
                         CASE dos.SettlementType WHEN '3' THEN 'Si' ELSE 'No' END AS AplicaProcedimiento, CASE F.IsCutAccount WHEN 'True' THEN 'Si' ELSE 'No' END AS Corte, per.Fullname AS Usuario, gf.Name AS [Grupo Facturación], 
                         CUPS.Code AS CUPS, CUPS.Description AS [Descripcion CUPS], BB.UBINOMBRE AS Ubicación, EE.MUNNOMBRE AS Municipio, GQ.Name AS GrupoQX, 
                         CASE ing.IINGREPOR WHEN '1' THEN 'Urgencias' WHEN '2' THEN 'CX' WHEN '3' THEN 'Nacido Hospital' WHEN '4' THEN 'Remitido' WHEN '5' THEN 'Hospitalizacion' END AS IngresaPor, 
                         CASE CUPS.ServiceType WHEN '1' THEN 'Laboratorios' WHEN '2' THEN 'Patologias' WHEN '3' THEN 'Imagenes DX' WHEN '4' THEN 'QX' WHEN '5' THEN 'No Qx' WHEN '6' THEN 'Interconsulta' WHEN '7' THEN 'Ninguno' WHEN
                          '8' THEN 'CX' END AS TipoServicio, DATENAME(MONTH,F.InvoiceDate) AS MesFactura,
						dos.CostValue AS CostoUnit, dos.CostValue*dos.InvoicedQuantity AS CostTotal
FROM            Billing.Invoice AS F  INNER JOIN
                         Billing.InvoiceDetail AS DF  ON DF.InvoiceId = F.Id INNER JOIN
                         Security.[User] AS u  ON u.UserCode = F.InvoicedUser INNER JOIN
                         Security.Person AS per  ON per.Id = u.IdPerson INNER JOIN
                         dbo.ADINGRESO AS ing  ON ing.NUMINGRES = F.AdmissionNumber INNER JOIN
                         dbo.INPACIENT AS P  ON P.IPCODPACI = F.PatientCode INNER JOIN
                         Billing.ServiceOrderDetail AS dos  ON dos.Id = DF.ServiceOrderDetailId INNER JOIN
                         Common.ThirdParty AS t  ON t.Id = F.ThirdPartyId INNER JOIN
                         Contract.CareGroup AS ga  ON ga.Id = F.CareGroupId left JOIN
                         Contract.HealthAdministrator AS ea  ON ea.Id = F.HealthAdministratorId INNER JOIN
                         Billing.InvoiceCategories AS cat  ON cat.Id = F.InvoiceCategoryId LEFT OUTER JOIN
                         Contract.IPSService AS ServiciosIPS  ON ServiciosIPS.Id = dos.IPSServiceId LEFT OUTER JOIN
                         Contract.SurgicalGroup AS GQ  ON ServiciosIPS.SurgicalGroupId = GQ.Id LEFT OUTER JOIN
                         Inventory.InventoryProduct AS pr  ON pr.Id = dos.ProductId LEFT OUTER JOIN
                         dbo.INPROFSAL AS med  ON med.CODPROSAL = dos.PerformsHealthProfessionalCode LEFT OUTER JOIN
                         dbo.INESPECIA AS espmed  ON espmed.CODESPECI = med.CODESPEC1 LEFT OUTER JOIN
                         dbo.INDIAGNOS AS diag  ON diag.CODDIAGNO = ing.CODDIAEGR LEFT OUTER JOIN
                         dbo.HCREGEGRE AS salida  ON salida.NUMINGRES = F.AdmissionNumber LEFT OUTER JOIN
                         Billing.ServiceOrderDetailSurgical AS dq  ON dq.ServiceOrderDetailId = dos.Id AND dq.OnlyMedicalFees = '0' LEFT OUTER JOIN
                         dbo.INPROFSAL AS medqx  ON medqx.CODPROSAL = dq.PerformsHealthProfessionalCode LEFT OUTER JOIN
                         dbo.INESPECIA AS espqx  ON espqx.CODESPECI = medqx.CODESPEC1 LEFT OUTER JOIN
                         Contract.IPSService AS ServiciosIPSQ  ON ServiciosIPSQ.Id = dq.IPSServiceId LEFT OUTER JOIN
                         Payroll.FunctionalUnit AS UF  ON UF.Id = dos.PerformsFunctionalUnitId LEFT OUTER JOIN
                         Billing.ServiceOrder AS os  ON os.Id = dos.ServiceOrderId LEFT OUTER JOIN
                         Contract.CUPSEntity AS CUPS  ON CUPS.Id = dos.CUPSEntityId LEFT OUTER JOIN
                         Billing.BillingGroup AS gf  ON gf.Id = CUPS.BillingGroupId LEFT OUTER JOIN
                         dbo.INUBICACI AS BB  ON BB.AUUBICACI = P.AUUBICACI LEFT OUTER JOIN
                         dbo.INMUNICIP AS EE  ON EE.DEPMUNCOD = BB.DEPMUNCOD LEFT OUTER JOIN
                         Payroll.CostCenter AS cc  ON dos.CostCenterId = cc.Id
WHERE  (F.Status = '1') AND (ing.CODCENATE = '001') AND (dos.IsDelete = '0') AND (dos.IsDelete = '0') AND (F.DocumentType IN ('1', '2', '3', '4', '5', '6')) 

---and F.InvoiceDate BETWEEN '01/02/2019' AND '28/02/2019'












