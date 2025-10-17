-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_MedicalFees_Causación
-- Extracted by Fabric SQL Extractor SPN v3.9.0



create VIEW [ViewInternal].[IMO_MedicalFees_Causación] AS

SELECT        uo.UnitName AS Sucursal, F.InvoiceNumber AS [Nro Factura/Registro], F.AdmissionNumber AS Ingreso, ing.IFECHAING AS [Fecha ingreso], F.PatientCode AS Identificación, p.IPNOMCOMP AS Paciente, 
                         ga.Name AS [Grupo de Atención], F.InvoiceDate AS [Fecha Factura/Registro], so.Code AS NroOrden, dos.InvoicedQuantity AS Cantidad, CASE WHEN dq.TotalSalesPrice IS NULL 
                         THEN dos.TotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorUnitario, CASE WHEN dq.TotalSalesPrice IS NULL THEN DF.GrandTotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorTotal, 
                         ea.Code + ' - ' + ea.Name AS [Entidad Administradora], CASE dos.RecordType WHEN '1' THEN 'Servicios' WHEN '2' THEN 'Medicamentos' END AS [Servicios/Medicamentos], CASE WHEN pr.Code IS NULL 
                         THEN ServiciosIPS.Code ELSE pr.Code END AS Código, CASE WHEN pr.Name IS NULL THEN ServiciosIPS.Name ELSE pr.Name END AS Descripción, 
                         CASE dos.Presentation WHEN '1' THEN 'No Quirúrgico' WHEN '2' THEN 'Quirúrgico' WHEN '3' THEN 'Paquete' END AS [Presentación Servicio], ServiciosIPSQ.Code AS Subcodigo, ServiciosIPSQ.Name AS Subnombre, 
                         caus.HealthProfessionalCode AS CodigoMèdico, med.NOMMEDICO AS Medico,  espmed.DESESPECI AS Especialidad, UF.Code as CodUf, UF.Name AS [Descripción Unidad Funcional], caus.CausationDate AS FechaCausacion, 
                         caus.TotalAmountPayable AS ValorCausado, per.Fullname AS UsuarioCreaCausación, caus.CreationDate AS FechaCreación, per2.Fullname AS UsuarioConfirmaCxP, cxp.ConfirmationDate AS FechaConfirmación, 
                         MFL.BillNumber AS FacturaCausada, cxp.Code AS CuentaXPagar, CASE caus.Status WHEN '1' THEN 'Causado' WHEN '2' THEN 'Liquidado' WHEN '3' THEN 'Confirmado' WHEN '4' THEN 'Anulado' END AS [Estado Causación], 
                         CASE MFL.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS [Estado Liquidación], 
						 MFL.Code AS ConsecutivoLiquidación, GF.NAME AS GrupoFacturacion
FROM            MedicalFees.MedicalFeesCausation AS caus  INNER JOIN
                         dbo.ADINGRESO AS ing  ON (ing.NUMINGRES ) = caus.AdmissionNumber AND caus.CausationDate >= '01/01/2024 00:00:00' INNER JOIN
                         dbo.INPACIENT AS p  ON p.IPCODPACI = caus.PatientCode INNER JOIN
                         dbo.INPROFSAL AS med  ON med.CODPROSAL = caus.HealthProfessionalCode INNER JOIN
                         dbo.INESPECIA AS espmed  ON espmed.CODESPECI = med.CODESPEC1 INNER JOIN
                         Billing.Invoice AS F  ON F.AdmissionNumber = (ing.NUMINGRES ) INNER JOIN
                         Billing.InvoiceDetail AS DF  ON DF.InvoiceId = F.Id AND DF.Id = caus.InvoiceDetailId INNER JOIN
                         Billing.ServiceOrderDetail AS dos  ON dos.Id = DF.ServiceOrderDetailId INNER JOIN
                         Billing.ServiceOrder AS so ON so.Id = caus.ServiceOrderId INNER JOIN
                         Common.OperatingUnit AS uo  ON uo.Id = F.OperatingUnitId INNER JOIN
                         Contract.CareGroup AS ga  ON ga.Id = F.CareGroupId INNER JOIN
                         Contract.HealthAdministrator AS ea  ON ea.Id = F.HealthAdministratorId INNER JOIN
                         Contract.IPSService AS ServiciosIPS  ON ServiciosIPS.Id = dos.IPSServiceId LEFT OUTER JOIN
                         Inventory.InventoryProduct AS pr  ON pr.Id = dos.ProductId LEFT OUTER JOIN
                         Billing.ServiceOrderDetailSurgical AS dq  ON dq.ServiceOrderDetailId = dos.Id AND dq.OnlyMedicalFees = '0' AND dq.Id = caus.ServiceOrderDetailSurgicalId LEFT OUTER JOIN
                         Contract.IPSService AS ServiciosIPSQ  ON ServiciosIPSQ.Id = dq.IPSServiceId LEFT OUTER JOIN
                         Payroll.FunctionalUnit AS UF  ON UF.Id = dos.PerformsFunctionalUnitId LEFT OUTER JOIN
                         Security.[User] AS u  ON u.UserCode = caus.CreationUser LEFT OUTER JOIN
                         Security.Person AS per  ON per.Id = u.IdPerson LEFT OUTER JOIN
                         MedicalFees.MedicalFeesLiquidationDetail AS MFLD  ON MFLD.MedicalFeesCausationId = caus.Id LEFT OUTER JOIN
                         MedicalFees.MedicalFeesLiquidation AS MFL  ON MFL.Id = MFLD.MedicalFeesLiquidacionId LEFT OUTER JOIN
                         Payments.AccountPayable AS cxp  ON cxp.Id = MFL.AccountPayableId LEFT OUTER JOIN
                         Security.[User] AS u2  ON u2.UserCode = cxp.ConfirmationUser LEFT OUTER JOIN
                         Security.Person AS per2  ON per2.Id = u2.IdPerson  LEFT JOIN
						 Contract.CUPSEntity AS CUPS ON CUPS.ID=DOS.CUPSEntityId  LEFT JOIN
						 Billing.BillingGroup AS gf ON gf.Id = CUPS.BillingGroupId
WHERE        (F.Status = '1')  AND (MFL.Status <> '3') AND caus.Status <> '1' 

UNION ALL

SELECT        uo.UnitName AS Sucursal, F.InvoiceNumber AS [Nro Factura/Registro], F.AdmissionNumber AS Ingreso, ing.IFECHAING AS [Fecha ingreso], F.PatientCode AS Identificación, p.IPNOMCOMP AS Paciente, 
                         ga.Name AS [Grupo de Atención], F.InvoiceDate AS [Fecha Factura/Registro], so.Code AS NroOrden, dos.InvoicedQuantity AS Cantidad, CASE WHEN dq.TotalSalesPrice IS NULL 
                         THEN dos.TotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorUnitario, CASE WHEN dq.TotalSalesPrice IS NULL THEN DF.GrandTotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorTotal, 
                         ea.Code + ' - ' + ea.Name AS [Entidad Administradora], CASE dos.RecordType WHEN '1' THEN 'Servicios' WHEN '2' THEN 'Medicamentos' END AS [Servicios/Medicamentos], CASE WHEN pr.Code IS NULL 
                         THEN ServiciosIPS.Code ELSE pr.Code END AS Código, CASE WHEN pr.Name IS NULL THEN ServiciosIPS.Name ELSE pr.Name END AS Descripción, 
                         CASE dos.Presentation WHEN '1' THEN 'No Quirúrgico' WHEN '2' THEN 'Quirúrgico' WHEN '3' THEN 'Paquete' END AS [Presentación Servicio], ServiciosIPSQ.Code AS Subcodigo, ServiciosIPSQ.Name AS Subnombre, 
                         caus.HealthProfessionalCode AS CodigoMèdico, med.NOMMEDICO AS Medico,  espmed.DESESPECI AS Especialidad, UF.Code as CodUf, UF.Name AS [Descripción Unidad Funcional], caus.CausationDate AS FechaCausacion, 
                         caus.TotalAmountPayable AS ValorCausado, per.Fullname AS UsuarioCreaCausación, caus.CreationDate AS FechaCreación, 'NA' AS UsuarioConfirmaCxP, '01/01/1900 00:00:00' AS FechaConfirmación, 
                         'SinDato' AS FacturaCausada, 'SinLiquidar' AS CuentaXPagar, CASE caus.Status WHEN '1' THEN 'Causado' WHEN '2' THEN 'Liquidado' WHEN '3' THEN 'Confirmado' WHEN '4' THEN 'Anulado' END AS [Estado Causación], 
                         'No' AS [Estado Liquidación], '0' AS ConsecutivoLiquidación, GF.NAME AS GrupoFacturacion
FROM            MedicalFees.MedicalFeesCausation AS caus  INNER JOIN
                         dbo.ADINGRESO AS ing  ON (ing.NUMINGRES ) = caus.AdmissionNumber AND caus.CausationDate >= '01/01/2024 00:00:00' INNER JOIN
                         dbo.INPACIENT AS p  ON p.IPCODPACI = caus.PatientCode INNER JOIN
                         dbo.INPROFSAL AS med  ON med.CODPROSAL = caus.HealthProfessionalCode INNER JOIN
                         dbo.INESPECIA AS espmed  ON espmed.CODESPECI = med.CODESPEC1 INNER JOIN
                         Billing.Invoice AS F  ON F.AdmissionNumber = (ing.NUMINGRES ) INNER JOIN
                         Billing.InvoiceDetail AS DF  ON DF.InvoiceId = F.Id AND DF.Id = caus.InvoiceDetailId INNER JOIN
                         Billing.ServiceOrderDetail AS dos  ON dos.Id = DF.ServiceOrderDetailId INNER JOIN
                         Billing.ServiceOrder AS so ON so.Id = caus.ServiceOrderId INNER JOIN
                         Common.OperatingUnit AS uo  ON uo.Id = F.OperatingUnitId INNER JOIN
                         Contract.CareGroup AS ga  ON ga.Id = F.CareGroupId INNER JOIN
                         Contract.HealthAdministrator AS ea  ON ea.Id = F.HealthAdministratorId INNER JOIN
                         Contract.IPSService AS ServiciosIPS  ON ServiciosIPS.Id = dos.IPSServiceId LEFT OUTER JOIN
                         Inventory.InventoryProduct AS pr  ON pr.Id = dos.ProductId LEFT OUTER JOIN
                         Billing.ServiceOrderDetailSurgical AS dq  ON dq.ServiceOrderDetailId = dos.Id AND dq.OnlyMedicalFees = '0' AND dq.Id = caus.ServiceOrderDetailSurgicalId LEFT OUTER JOIN
                         Contract.IPSService AS ServiciosIPSQ  ON ServiciosIPSQ.Id = dq.IPSServiceId LEFT OUTER JOIN
                         Payroll.FunctionalUnit AS UF  ON UF.Id = dos.PerformsFunctionalUnitId LEFT OUTER JOIN
                         Security.[User] AS u  ON u.UserCode = caus.CreationUser LEFT OUTER JOIN
                         Security.Person AS per  ON per.Id = u.IdPerson LEFT JOIN
						 Contract.CUPSEntity AS CUPS ON CUPS.ID=DOS.CUPSEntityId  LEFT JOIN
						 Billing.BillingGroup AS gf ON gf.Id = CUPS.BillingGroupId
WHERE        (F.Status = '1') AND caus.Id NOT IN
                             (SELECT        MedicalFeesCausationId
                               FROM            MedicalFees.MedicalFeesLiquidationDetail) AND caus.Status = '1'