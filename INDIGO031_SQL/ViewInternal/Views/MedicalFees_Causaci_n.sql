-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: MedicalFees_Causación
-- Extracted by Fabric SQL Extractor SPN v3.9.0



create VIEW [ViewInternal].[MedicalFees_Causación] AS

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
						 MFL.Code AS ConsecutivoLiquidación, GF.NAME AS GrupoFacturacion, cups.code as CodCUPS, cups.Description as CUPS, so.OrderDate as FechaOrden, dos.servicedate as [Fecha Servicio],
						 C.Name AS Categoria, --se agrega campo categoria por solicitud en caso 230926
						 CON.Code as Contrato,CON.ContractName AS NombreContrato, --,  deduc.TotalAmountPayable as TotalDeduccion--, 
						-- (cXp.Value) AS [Valor CxP]
						CASE WHEN MEDPERCIR = '0' THEN 'Ninguno' WHEN MEDPERCIR = '1' THEN 'Cirujano' WHEN MEDPERCIR = '2' THEN 'Anestesiologos' WHEN MEDPERCIR = '3' THEN 'Ayudantes' WHEN MEDPERCIR = '4' THEN 'Anestesiologos/ Cirujano' END AS PerfilCirugia,
						prove.name as Proveedor, aty.name as TipodeIngreso
FROM            INDIGO031.MedicalFees.MedicalFeesCausation AS caus WITH (nolock) INNER JOIN
                         INDIGO031.dbo.ADINGRESO AS ing WITH (nolock) ON (ing.NUMINGRES ) = caus.AdmissionNumber AND caus.CausationDate >= '01-01-2025 00:00:00' INNER JOIN
                         INDIGO031.dbo.INPACIENT AS p WITH (nolock) ON p.IPCODPACI = caus.PatientCode INNER JOIN
                         INDIGO031.dbo.INPROFSAL AS med WITH (nolock) ON med.CODPROSAL = caus.HealthProfessionalCode INNER JOIN
                         INDIGO031.dbo.INESPECIA AS espmed WITH (nolock) ON espmed.CODESPECI = med.CODESPEC1 INNER JOIN
                         INDIGO031.Billing.Invoice AS F WITH (nolock) ON F.AdmissionNumber = (ing.NUMINGRES ) INNER JOIN
                         INDIGO031.Billing.InvoiceDetail AS DF WITH (nolock) ON DF.InvoiceId = F.Id AND DF.Id = caus.InvoiceDetailId INNER JOIN
                         INDIGO031.Billing.ServiceOrderDetail AS dos WITH (nolock) ON dos.Id = DF.ServiceOrderDetailId INNER JOIN
                         INDIGO031.Billing.ServiceOrder AS so ON so.Id = caus.ServiceOrderId INNER JOIN
                         INDIGO031.Common.OperatingUnit AS uo WITH (nolock) ON uo.Id = F.OperatingUnitId INNER JOIN
                         INDIGO031.Contract.CareGroup AS ga WITH (nolock) ON ga.Id = F.CareGroupId INNER JOIN
                         INDIGO031.Contract.HealthAdministrator AS ea WITH (nolock) ON ea.Id = F.HealthAdministratorId INNER JOIN
                         INDIGO031.Contract.IPSService AS ServiciosIPS WITH (nolock) ON ServiciosIPS.Id = dos.IPSServiceId LEFT OUTER JOIN
                         INDIGO031.Inventory.InventoryProduct AS pr WITH (nolock) ON pr.Id = dos.ProductId LEFT OUTER JOIN
                         INDIGO031.Billing.ServiceOrderDetailSurgical AS dq WITH (nolock) ON dq.ServiceOrderDetailId = dos.Id AND dq.OnlyMedicalFees = '0' AND dq.Id = caus.ServiceOrderDetailSurgicalId LEFT OUTER JOIN
                         INDIGO031.Contract.IPSService AS ServiciosIPSQ WITH (nolock) ON ServiciosIPSQ.Id = dq.IPSServiceId LEFT OUTER JOIN
                         INDIGO031.Payroll.FunctionalUnit AS UF WITH (nolock) ON UF.Id = dos.PerformsFunctionalUnitId LEFT OUTER JOIN
                         INDIGO031.Security.[User] AS u  ON u.UserCode = caus.CreationUser LEFT OUTER JOIN
                         INDIGO031.Security.Person AS per  ON per.Id = u.IdPerson LEFT OUTER JOIN
                         INDIGO031.MedicalFees.MedicalFeesLiquidationDetail AS MFLD WITH (nolock) ON MFLD.MedicalFeesCausationId = caus.Id LEFT OUTER JOIN
                         INDIGO031.MedicalFees.MedicalFeesLiquidation AS MFL WITH (nolock) ON MFL.Id = MFLD.MedicalFeesLiquidacionId LEFT OUTER JOIN
                         INDIGO031.Payments.AccountPayable AS cxp WITH (nolock) ON cxp.Id = MFL.AccountPayableId LEFT OUTER JOIN
						 INDIGO031.Common.Supplier as prove on prove.id=mfl.supplierid LEFT OUTER JOIN
                         INDIGO031.Security.[User] AS u2  ON u2.UserCode = cxp.ConfirmationUser LEFT OUTER JOIN
                         INDIGO031.Security.Person AS per2 ON per2.Id = u2.IdPerson  LEFT JOIN
						 INDIGO031.Contract.CUPSEntity AS CUPS ON CUPS.ID=DOS.CUPSEntityId  LEFT JOIN
						 INDIGO031.Billing.BillingGroup AS gf ON gf.Id = CUPS.BillingGroupId LEFT JOIN 
						 INDIGO031.Billing.InvoiceCategories AS C WITH (nolock) ON C.Id = f.InvoiceCategoryId LEFT JOIN
						 INDIGO031.[MedicalFees].[MedicalFeesContract] AS CON WITH(NOLOCK) ON CON.id = caus.MedicalFeesContractId
						 left join INDIGO031.[Admissions].[AdmissionType] as aty with (nolock) on aty.id=ing.IdAdmissionType
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
                         'No' AS [Estado Liquidación], '0' AS ConsecutivoLiquidación, GF.NAME AS GrupoFacturacion, cups.code as CodCUPS, cups.Description as CUPS, so.OrderDate as FechaOrden, dos.servicedate as [Fecha Servicio], C.Name AS Categoria,
						 CON.Code as Contrato,CON.ContractName AS NombreContrato,--, deduc.TotalAmountPayable as TotalDeduccion--, '' AS [Valor CxP]
						-- ,0 AS [Valor CxP]
						CASE WHEN MEDPERCIR = '0' THEN 'Ninguno' WHEN MEDPERCIR = '1' THEN 'Cirujano' WHEN MEDPERCIR = '2' THEN 'Anestesiologos' WHEN MEDPERCIR = '3' THEN 'Ayudantes' WHEN MEDPERCIR = '4' THEN 'Anestesiologos/ Cirujano' END AS PerfilCirugia,
						provee.name as Proveedor, aty.name as TipodeIngreso
FROM            INDIGO031.MedicalFees.MedicalFeesCausation AS caus WITH (nolock) INNER JOIN
                         INDIGO031.dbo.ADINGRESO AS ing WITH (nolock) ON (ing.NUMINGRES ) = caus.AdmissionNumber AND caus.CausationDate >= '01/01/2025 00:00:00' INNER JOIN
                         INDIGO031.dbo.INPACIENT AS p WITH (nolock) ON p.IPCODPACI = caus.PatientCode INNER JOIN
                         INDIGO031.dbo.INPROFSAL AS med WITH (nolock) ON med.CODPROSAL = caus.HealthProfessionalCode INNER JOIN
                         INDIGO031.dbo.INESPECIA AS espmed WITH (nolock) ON espmed.CODESPECI = med.CODESPEC1 INNER JOIN
                         INDIGO031.Billing.Invoice AS F WITH (nolock) ON F.AdmissionNumber = (ing.NUMINGRES ) INNER JOIN
                         INDIGO031.Billing.InvoiceDetail AS DF WITH (nolock) ON DF.InvoiceId = F.Id AND DF.Id = caus.InvoiceDetailId INNER JOIN
                         INDIGO031.Billing.ServiceOrderDetail AS dos WITH (nolock) ON dos.Id = DF.ServiceOrderDetailId INNER JOIN
                         INDIGO031.Billing.ServiceOrder AS so ON so.Id = caus.ServiceOrderId INNER JOIN
                         INDIGO031.Common.OperatingUnit AS uo WITH (nolock) ON uo.Id = F.OperatingUnitId INNER JOIN
                         INDIGO031.Contract.CareGroup AS ga WITH (nolock) ON ga.Id = F.CareGroupId INNER JOIN
                         INDIGO031.Contract.HealthAdministrator AS ea WITH (nolock) ON ea.Id = F.HealthAdministratorId INNER JOIN
                         INDIGO031.Contract.IPSService AS ServiciosIPS WITH (nolock) ON ServiciosIPS.Id = dos.IPSServiceId LEFT OUTER JOIN
                         INDIGO031.Inventory.InventoryProduct AS pr WITH (nolock) ON pr.Id = dos.ProductId LEFT OUTER JOIN
                         INDIGO031.Billing.ServiceOrderDetailSurgical AS dq WITH (nolock) ON dq.ServiceOrderDetailId = dos.Id AND dq.OnlyMedicalFees = '0' AND dq.Id = caus.ServiceOrderDetailSurgicalId LEFT OUTER JOIN
                         INDIGO031.Contract.IPSService AS ServiciosIPSQ WITH (nolock) ON ServiciosIPSQ.Id = dq.IPSServiceId LEFT OUTER JOIN
                         INDIGO031.Payroll.FunctionalUnit AS UF WITH (nolock) ON UF.Id = dos.PerformsFunctionalUnitId LEFT OUTER JOIN
                         INDIGO031.Security.[User] AS u ON u.UserCode = caus.CreationUser LEFT OUTER JOIN
                         INDIGO031.Security.Person AS per  ON per.Id = u.IdPerson LEFT JOIN
						 INDIGO031.Contract.CUPSEntity AS CUPS ON CUPS.ID=DOS.CUPSEntityId  LEFT JOIN
						 INDIGO031.Common.Supplier as provee on provee.id=med.genprovee left outer join
						 INDIGO031.Billing.BillingGroup AS gf ON gf.Id = CUPS.BillingGroupId LEFT JOIN 
						 INDIGO031.Billing.InvoiceCategories AS C WITH (nolock) ON C.Id = f.InvoiceCategoryId LEFT JOIN
						 INDIGO031.[MedicalFees].[MedicalFeesContract] AS CON WITH(NOLOCK) ON CON.id = caus.MedicalFeesContractId
						 left join INDIGO031.[Admissions].[AdmissionType] as aty with (nolock) on aty.id=ing.IdAdmissionType
--						 						 left join (select c.AdmissionNumber, c.TotalAmountPayable
--from INDIGO031.MedicalFees.MedicalFeesCausation as c
--where  InvoiceReversal=1) as deduc on deduc.AdmissionNumber=caus.AdmissionNumber
WHERE        (F.Status = '1') --AND ATY.id<>'10'
AND caus.Id NOT IN
                             (SELECT        MedicalFeesCausationId
                               FROM            INDIGO031.MedicalFees.MedicalFeesLiquidationDetail) AND caus.Status = '1'  and caus.CausationDate >= '01/01/2025 00:00:00'