-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_MEDICALFEES_CAUSACION
-- Extracted by Fabric SQL Extractor SPN v3.9.0




create VIEW [ViewInternal].[VW_MEDICALFEES_CAUSACION] AS

SELECT   uo.UnitName AS Sucursal, F.InvoiceNumber AS [Nro Factura/Registro], F.AdmissionNumber AS Ingreso, ing.IFECHAING AS [Fecha ingreso], F.PatientCode AS Identificación, p.IPNOMCOMP AS Paciente, 
                         ga.Name AS [Grupo de Atención], F.InvoiceDate AS [Fecha Factura/Registro], so.Code AS NroOrden, dos.InvoicedQuantity AS Cantidad, CASE WHEN dq.TotalSalesPrice IS NULL 
                         THEN dos.TotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorUnitario, CASE WHEN dq.TotalSalesPrice IS NULL THEN DF.GrandTotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorTotal, 
                         ea.Code + ' - ' + ea.Name AS [Entidad Administradora], CASE dos.RecordType WHEN '1' THEN 'Servicios' WHEN '2' THEN 'Medicamentos' END AS [Servicios/Medicamentos], CASE WHEN pr.Code IS NULL 
                         THEN ServiciosIPS.Code ELSE pr.Code END AS Código, CASE WHEN pr.Name IS NULL THEN ServiciosIPS.Name ELSE pr.Name END AS Descripción, 
                         CASE dos.Presentation WHEN '1' THEN 'No Quirúrgico' WHEN '2' THEN 'Quirúrgico' WHEN '3' THEN 'Paquete' END AS [Presentación Servicio], ServiciosIPSQ.Code AS Subcodigo, ServiciosIPSQ.Name AS Subnombre, 
                         caus.HealthProfessionalCode AS CodigoMèdico, med.NOMMEDICO AS Medico,  espmed.DESESPECI AS Especialidad, UF.Code as CodUf, UF.Name AS [Descripción Unidad Funcional], caus.CausationDate AS FechaCausacion, 
                         caus.TotalAmountPayable AS ValorCausado, per.Fullname AS UsuarioCreaCausación, caus.CreationDate AS FechaCreación, per2.Fullname AS UsuarioConfirmaCxP, cxp.ConfirmationDate AS FechaConfirmación, 
                         MFL.BillNumber AS FacturaCausada, cxp.Code AS CuentaXPagar, CASE caus.Status WHEN '1' THEN 'Causado' WHEN '2' THEN 'Liquidado' WHEN '3' THEN 'Confirmado' WHEN '4' THEN 'Anulado' END AS [Estado Causación], 
                         CASE MFL.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS [Estado Liquidación], 
						 MFL.Code AS ConsecutivoLiquidación, gf.Name AS GrupoFacturacion, CUPS.Code as CodCUPS, CUPS.Description as CUPS, so.OrderDate as FechaOrden, dos.ServiceDate as [Fecha Servicio],
						 C.Name AS Categoria, --se agrega campo categoria por solicitud en caso 230926
						 CON.Code as Contrato,CON.ContractName AS NombreContrato, --,  deduc.TotalAmountPayable as TotalDeduccion--, 
						-- (cXp.Value) AS [Valor CxP]
						CASE WHEN MEDPERCIR = '0' THEN 'Ninguno' WHEN MEDPERCIR = '1' THEN 'Cirujano' WHEN MEDPERCIR = '2' THEN 'Anestesiologos' WHEN MEDPERCIR = '3' THEN 'Ayudantes' WHEN MEDPERCIR = '4' THEN 'Anestesiologos/ Cirujano' END AS PerfilCirugia,
						prove.Name as Proveedor, aty.Name as TipodeIngreso
FROM            INDIGO031.MedicalFees.MedicalFeesCausation AS caus  INNER JOIN
                         INDIGO031.dbo.ADINGRESO AS ing  ON (ing.NUMINGRES ) = caus.AdmissionNumber AND caus.CausationDate >= '01-01-2025 00:00:00' INNER JOIN
                         INDIGO031.dbo.INPACIENT AS p  ON p.IPCODPACI = caus.PatientCode INNER JOIN
                         INDIGO031.dbo.INPROFSAL AS med  ON med.CODPROSAL = caus.HealthProfessionalCode INNER JOIN
                         INDIGO031.dbo.INESPECIA AS espmed  ON espmed.CODESPECI = med.CODESPEC1 INNER JOIN
                         INDIGO031.Billing.Invoice AS F  ON F.AdmissionNumber = (ing.NUMINGRES ) INNER JOIN
                         INDIGO031.Billing.InvoiceDetail AS DF  ON DF.InvoiceId = F.Id AND DF.Id = caus.InvoiceDetailId INNER JOIN
                         INDIGO031.Billing.ServiceOrderDetail AS dos  ON dos.Id = DF.ServiceOrderDetailId INNER JOIN
                         INDIGO031.Billing.ServiceOrder AS so ON so.Id = caus.ServiceOrderId INNER JOIN
                         INDIGO031.Common.OperatingUnit AS uo  ON uo.Id = F.OperatingUnitId INNER JOIN
                         INDIGO031.Contract.CareGroup AS ga  ON ga.Id = F.CareGroupId INNER JOIN
                         INDIGO031.Contract.HealthAdministrator AS ea  ON ea.Id = F.HealthAdministratorId INNER JOIN
                         INDIGO031.Contract.IPSService AS ServiciosIPS  ON ServiciosIPS.Id = dos.IPSServiceId LEFT OUTER JOIN
                         INDIGO031.Inventory.InventoryProduct AS pr  ON pr.Id = dos.ProductId LEFT OUTER JOIN
                         INDIGO031.Billing.ServiceOrderDetailSurgical AS dq  ON dq.ServiceOrderDetailId = dos.Id AND dq.OnlyMedicalFees = '0' AND dq.Id = caus.ServiceOrderDetailSurgicalId LEFT OUTER JOIN
                         INDIGO031.Contract.IPSService AS ServiciosIPSQ  ON ServiciosIPSQ.Id = dq.IPSServiceId LEFT OUTER JOIN
                         INDIGO031.Payroll.FunctionalUnit AS UF  ON UF.Id = dos.PerformsFunctionalUnitId LEFT OUTER JOIN
                         INDIGO031.Security.[UserInt] AS u  ON u.UserCode = caus.CreationUser LEFT OUTER JOIN
                         INDIGO031.Security.PersonInt AS per  ON per.Id = u.IdPerson LEFT OUTER JOIN
                         INDIGO031.MedicalFees.MedicalFeesLiquidationDetail AS MFLD  ON MFLD.MedicalFeesCausationId = caus.Id LEFT OUTER JOIN
                         INDIGO031.MedicalFees.MedicalFeesLiquidation AS MFL  ON MFL.Id = MFLD.MedicalFeesLiquidacionId LEFT OUTER JOIN
                         INDIGO031.Payments.AccountPayable AS cxp  ON cxp.Id = MFL.AccountPayableId LEFT OUTER JOIN
						 INDIGO031.Common.Supplier as prove on prove.Id=MFL.SupplierId LEFT OUTER JOIN
                         INDIGO031.Security.[UserInt] AS u2  ON u2.UserCode = cxp.ConfirmationUser LEFT OUTER JOIN
                         INDIGO031.Security.PersonInt AS per2 ON per2.Id = u2.IdPerson  LEFT JOIN
						 INDIGO031.Contract.CUPSEntity AS CUPS ON CUPS.Id=dos.CUPSEntityId  LEFT JOIN
						 INDIGO031.Billing.BillingGroup AS gf ON gf.Id = CUPS.BillingGroupId LEFT JOIN 
						 INDIGO031.Billing.InvoiceCategories AS C  ON C.Id = F.InvoiceCategoryId LEFT JOIN
						 INDIGO031.[MedicalFees].[MedicalFeesContract] AS CON  ON CON.Id = caus.MedicalFeesContractId
						 left join INDIGO031.[Admissions].[AdmissionType] as aty  on aty.Id=ing.IdAdmissionType
--						 left join (select c.AdmissionNumber, c.TotalAmountPayable
--from INDIGO031.MedicalFees.MedicalFeesCausation as c
--where InvoiceReversal=1) as deduc on deduc.AdmissionNumber=caus.AdmissionNumber
WHERE        (F.Status = '1')  AND (MFL.Status <> '3') AND caus.Status <> '1'  and caus.CausationDate >= '01/01/2025 00:00:00'
--AND ATY.id<>'10'
--and f.AdmissionNumber='5407805'
UNION ALL

SELECT      uo.UnitName AS Sucursal, F.InvoiceNumber AS [Nro Factura/Registro], F.AdmissionNumber AS Ingreso, ing.IFECHAING AS [Fecha ingreso], F.PatientCode AS Identificación, p.IPNOMCOMP AS Paciente, 
                         ga.Name AS [Grupo de Atención], F.InvoiceDate AS [Fecha Factura/Registro], so.Code AS NroOrden, dos.InvoicedQuantity AS Cantidad, CASE WHEN dq.TotalSalesPrice IS NULL 
                         THEN dos.TotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorUnitario, CASE WHEN dq.TotalSalesPrice IS NULL THEN DF.GrandTotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorTotal, 
                         ea.Code + ' - ' + ea.Name AS [Entidad Administradora], CASE dos.RecordType WHEN '1' THEN 'Servicios' WHEN '2' THEN 'Medicamentos' END AS [Servicios/Medicamentos], CASE WHEN pr.Code IS NULL 
                         THEN ServiciosIPS.Code ELSE pr.Code END AS Código, CASE WHEN pr.Name IS NULL THEN ServiciosIPS.Name ELSE pr.Name END AS Descripción, 
                         CASE dos.Presentation WHEN '1' THEN 'No Quirúrgico' WHEN '2' THEN 'Quirúrgico' WHEN '3' THEN 'Paquete' END AS [Presentación Servicio], ServiciosIPSQ.Code AS Subcodigo, ServiciosIPSQ.Name AS Subnombre, 
                         caus.HealthProfessionalCode AS CodigoMèdico, med.NOMMEDICO AS Medico,  espmed.DESESPECI AS Especialidad, UF.Code as CodUf, UF.Name AS [Descripción Unidad Funcional], caus.CausationDate AS FechaCausacion, 
                         caus.TotalAmountPayable AS ValorCausado, per.Fullname AS UsuarioCreaCausación, caus.CreationDate AS FechaCreación, 'NA' AS UsuarioConfirmaCxP, '01/01/1900 00:00:00' AS FechaConfirmación, 
                         'SinDato' AS FacturaCausada, 'SinLiquidar' AS CuentaXPagar, CASE caus.Status WHEN '1' THEN 'Causado' WHEN '2' THEN 'Liquidado' WHEN '3' THEN 'Confirmado' WHEN '4' THEN 'Anulado' END AS [Estado Causación], 
                         'No' AS [Estado Liquidación], '0' AS ConsecutivoLiquidación, gf.Name AS GrupoFacturacion, CUPS.Code as CodCUPS, CUPS.Description as CUPS, so.OrderDate as FechaOrden, dos.ServiceDate as [Fecha Servicio], C.Name AS Categoria,
						 CON.Code as Contrato,CON.ContractName AS NombreContrato,--, deduc.TotalAmountPayable as TotalDeduccion--, '' AS [Valor CxP]
						-- ,0 AS [Valor CxP]
						CASE WHEN MEDPERCIR = '0' THEN 'Ninguno' WHEN MEDPERCIR = '1' THEN 'Cirujano' WHEN MEDPERCIR = '2' THEN 'Anestesiologos' WHEN MEDPERCIR = '3' THEN 'Ayudantes' WHEN MEDPERCIR = '4' THEN 'Anestesiologos/ Cirujano' END AS PerfilCirugia,
						provee.Name as Proveedor, aty.Name as TipodeIngreso
FROM            INDIGO031.MedicalFees.MedicalFeesCausation AS caus  INNER JOIN
                         INDIGO031.dbo.ADINGRESO AS ing  ON (ing.NUMINGRES ) = caus.AdmissionNumber AND caus.CausationDate >= '01/01/2025 00:00:00' INNER JOIN
                         INDIGO031.dbo.INPACIENT AS p  ON p.IPCODPACI = caus.PatientCode INNER JOIN
                         INDIGO031.dbo.INPROFSAL AS med  ON med.CODPROSAL = caus.HealthProfessionalCode INNER JOIN
                         INDIGO031.dbo.INESPECIA AS espmed  ON espmed.CODESPECI = med.CODESPEC1 INNER JOIN
                         INDIGO031.Billing.Invoice AS F  ON F.AdmissionNumber = (ing.NUMINGRES ) INNER JOIN
                         INDIGO031.Billing.InvoiceDetail AS DF  ON DF.InvoiceId = F.Id AND DF.Id = caus.InvoiceDetailId INNER JOIN
                         INDIGO031.Billing.ServiceOrderDetail AS dos  ON dos.Id = DF.ServiceOrderDetailId INNER JOIN
                         INDIGO031.Billing.ServiceOrder AS so ON so.Id = caus.ServiceOrderId INNER JOIN
                         INDIGO031.Common.OperatingUnit AS uo  ON uo.Id = F.OperatingUnitId INNER JOIN
                         INDIGO031.Contract.CareGroup AS ga  ON ga.Id = F.CareGroupId INNER JOIN
                         INDIGO031.Contract.HealthAdministrator AS ea  ON ea.Id = F.HealthAdministratorId INNER JOIN
                         INDIGO031.Contract.IPSService AS ServiciosIPS  ON ServiciosIPS.Id = dos.IPSServiceId LEFT OUTER JOIN
                         INDIGO031.Inventory.InventoryProduct AS pr  ON pr.Id = dos.ProductId LEFT OUTER JOIN
                         INDIGO031.Billing.ServiceOrderDetailSurgical AS dq  ON dq.ServiceOrderDetailId = dos.Id AND dq.OnlyMedicalFees = '0' AND dq.Id = caus.ServiceOrderDetailSurgicalId LEFT OUTER JOIN
                         INDIGO031.Contract.IPSService AS ServiciosIPSQ  ON ServiciosIPSQ.Id = dq.IPSServiceId LEFT OUTER JOIN
                         INDIGO031.Payroll.FunctionalUnit AS UF  ON UF.Id = dos.PerformsFunctionalUnitId LEFT OUTER JOIN
                         INDIGO031.Security.[UserInt] AS u ON u.UserCode = caus.CreationUser LEFT OUTER JOIN
                         INDIGO031.Security.PersonInt AS per  ON per.Id = u.IdPerson LEFT JOIN
						 INDIGO031.Contract.CUPSEntity AS CUPS ON CUPS.Id=dos.CUPSEntityId  LEFT JOIN
						 INDIGO031.Common.Supplier as provee on provee.Id=med.GENPROVEE left outer join
						 INDIGO031.Billing.BillingGroup AS gf ON gf.Id = CUPS.BillingGroupId LEFT JOIN 
						 INDIGO031.Billing.InvoiceCategories AS C  ON C.Id = F.InvoiceCategoryId LEFT JOIN
						 INDIGO031.[MedicalFees].[MedicalFeesContract] AS CON  ON CON.Id = caus.MedicalFeesContractId
						 left join INDIGO031.[Admissions].[AdmissionType] as aty  on aty.Id=ing.IdAdmissionType
--						 						 left join (select c.AdmissionNumber, c.TotalAmountPayable
--from INDIGO031.MedicalFees.MedicalFeesCausation as c
--where  InvoiceReversal=1) as deduc on deduc.AdmissionNumber=caus.AdmissionNumber
WHERE        (F.Status = '1') --AND ATY.id<>'10'
AND caus.Id NOT IN
                             (SELECT        MedicalFeesCausationId
                               FROM            INDIGO031.MedicalFees.MedicalFeesLiquidationDetail) AND caus.Status = '1'  and caus.CausationDate >= '01/01/2025 00:00:00'
