-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Billing_Facturación_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VIE_AD_Billing_Facturación_PB] as

SELECT uo.UnitName AS Sede, 
     --  'Control Capitación' AS Tipo, 
     --  cat.Name AS Categoría, 
       F.InvoiceNumber AS [Nro Registro], 
       F.AdmissionNumber AS Ingreso, 
      -- ing.IFECHAING AS [Fecha ingreso], 
       F.PatientCode AS Identificación, 
     --  p.IPNOMCOMP AS Paciente, 
       ga.Name AS [Grupo de Atención], 
       F.TotalInvoice AS [Total Registro], 
       F.InvoiceDate AS [Fecha Registro], 
       dos.InvoicedQuantity AS Cantidad,
       CASE
           WHEN dq.TotalSalesPrice IS NULL
           THEN dos.TotalSalesPrice
           ELSE dq.TotalSalesPrice
       END AS ValorUnitario,
       CASE
           WHEN dq.TotalSalesPrice IS NULL
           THEN DF.GrandTotalSalesPrice
           ELSE dq.TotalSalesPrice
       END AS ValorTotal, 
       t.Nit, 
       ea.Code + ' - ' + ea.Name AS [Entidad Administradora],
       CASE dos.RecordType
           WHEN '1'
           THEN 'Servicios'
           WHEN '2'
           THEN 'Medicamentos'
       END AS [Servicios/Medicamentos],
       CASE
           WHEN pr.Code IS NULL
           THEN ServiciosIPS.Code
           ELSE pr.Code
       END AS Código,
       CASE
           WHEN pr.Name IS NULL
           THEN ServiciosIPS.Name
           ELSE pr.Name
       END AS Descripción,
       --CASE dos.Presentation
       --    WHEN '1'
       --    THEN 'No Quirúrgico'
       --    WHEN '2'
       --    THEN 'Quirúrgico'
       --    WHEN '3'
       --    THEN 'Paquete'
       --END AS [Presentación Servicio], 
       --ServiciosIPSQ.Code AS Subcodigo, 
       --ServiciosIPSQ.Name AS Subnombre,
       --CASE
       --    WHEN dq.PerformsHealthProfessionalCode IS NULL
       --    THEN dos.PerformsHealthProfessionalCode
       --    ELSE dq.PerformsHealthProfessionalCode
       --END AS CodigoQX,
       --CASE
       --    WHEN RTRIM(medqx.NOMMEDICO) IS NULL
       --    THEN med.NOMMEDICO
       --    ELSE RTRIM(medqx.NOMMEDICO)
       --END AS NombreMedico, 
       UF.Name AS [Descripción Unidad Funcional], 
       --salida.FECALTPAC AS [Fecha Alta médica], 
       --ing.CODDIAEGR AS CIE10, 
       --diag.NOMDIAGNO AS Diagnóstico,
       --CASE
       --    WHEN espmed.DESESPECI IS NULL
       --    THEN espqx.DESESPECI
       --    ELSE espmed.DESESPECI
       --END AS Especialidad, 
       --per.Fullname AS Usuario, 
       CC.Number AS CuentaContable, 
       CC.Name AS NombreCuenta, 
       CCo.Code AS CC, 
       CCo.Name AS CentroCosto, 
      -- gf.Name AS [Grupo Facturación], 
       --so.Code AS [Orden Servicios],
	   case when ga.code in  ('BOG315','BOG314','BOG313','BOG312','BOG311','BOG310','BOG309','BOG308','BOG307','BOG306','BOG305','BOG304','BOG303') then 'Alto Costo Oncologia' 
			 when ga.code in ('BOG292','BOG120','BOG115') then 'Med Hemofilia y Excl.' 
			 when ga.code in ('BOG207', 'BOG200','BOG199','BOG198','BOG197','BOG196','BOG195','BOG194','BOG193','BOG192','BOG191','BOG190','BOG189','BOG188','BOG187','BOG186') then 'Med Alta Complejidad'
			 when ga.code in ('BOG098','BOG099','BOG100','BOG101','BOG102','BOG103','BOG104','BOG105','BOG106','BOG107','BOG108','BOG109','BOG110','BOG111','BOG129','BOG208') then 'Med Media y Baja Complejidad - Dispositivos' end as 'Tipo Evento',
			 pg.code as CodGrupo, PG.Name AS Grupo, CASE WHEN UO.ID IN (8,9,10,11,12,13,14,15,24) THEN 'BOYACA' WHEN UO.ID  IN (16,17,18,19,20) THEN 'META'  WHEN UO.ID  IN (22,27) THEN 'CASANARE' END AS REGIONAL
FROM Billing.Invoice AS F
     INNER JOIN Billing.RevenueControlDetail AS Brcd ON F.RevenueControlDetailId = Brcd.Id
     INNER JOIN Billing.InvoiceDetail AS DF ON DF.InvoiceId = F.Id
     INNER JOIN dbo.ADINGRESO AS ing 
			 LEFT JOIN dbo.INDIAGNOS AS diag ON diag.CODDIAGNO = ing.CODDIAEGR
			 ON ing.NUMINGRES = F.AdmissionNumber
     INNER JOIN Billing.ServiceOrderDetail AS dos 
			 INNER JOIN GeneralLedger.MainAccounts AS CC ON CC.Id = dos.IncomeMainAccountId
			 INNER JOIN Payroll.CostCenter AS CCo ON dos.CostCenterId = CCo.Id
			 LEFT JOIN Contract.IPSService AS ServiciosIPS ON ServiciosIPS.Id = dos.IPSServiceId
			 LEFT JOIN Inventory.InventoryProduct AS pr ON pr.Id = dos.ProductId
			 LEFT JOIN dbo.INPROFSAL AS med 
					LEFT JOIN dbo.INESPECIA AS espmed ON espmed.CODESPECI = med.CODESPEC1
					ON med.CODPROSAL = dos.PerformsHealthProfessionalCode
			 LEFT JOIN Billing.ServiceOrderDetailSurgical AS dq 
					--LEFT JOIN dbo.INPROFSAL AS medqx 
					--LEFT JOIN dbo.INESPECIA AS espqx ON espqx.CODESPECI = medqx.CODESPEC1 ON medqx.CODPROSAL = dq.PerformsHealthProfessionalCode
					LEFT JOIN Contract.IPSService AS ServiciosIPSQ ON ServiciosIPSQ.Id = dq.IPSServiceId
					ON dq.ServiceOrderDetailId = dos.Id
                    AND dq.OnlyMedicalFees = '0'
			 LEFT JOIN Payroll.FunctionalUnit AS UF ON UF.Id = dos.PerformsFunctionalUnitId
			 LEFT JOIN Contract.CUPSEntity AS CUPS 
					LEFT JOIN Billing.BillingGroup AS gf ON gf.Id = CUPS.BillingGroupId
					ON CUPS.Id = dos.CUPSEntityId
			 LEFT JOIN Billing.ServiceOrder AS so ON so.ID = dos.ServiceOrderId
			 ON dos.Id = DF.ServiceOrderDetailId
     INNER JOIN dbo.INPACIENT AS p ON p.IPCODPACI = F.PatientCode
     INNER JOIN Common.ThirdParty AS t ON t.Id = F.ThirdPartyId
     INNER JOIN Common.OperatingUnit AS uo ON uo.Id = F.OperatingUnitId
     
     LEFT JOIN Contract.CareGroup AS ga ON ga.Id = F.CareGroupId
     LEFT JOIN Contract.HealthAdministrator AS ea ON ea.Id = F.HealthAdministratorId
	 LEFT JOIN Inventory.ProductGroup AS PG ON PG.ID=PR.ProductGroupId
   --  LEFT JOIN Security.[User] AS u 
			--LEFT JOIN Security.Person AS per ON per.Id = u.IdPerson 
			--ON u.UserCode = F.InvoicedUser
   --  LEFT JOIN Billing.InvoiceCategories AS cat ON cat.Id = F.InvoiceCategoryId
   --  LEFT JOIN dbo.HCREGEGRE AS salida ON salida.NUMINGRES = F.AdmissionNumber
WHERE--(F.DocumentType = '5')
     --AND 
	 (F.STATUS = '1')
     AND (F.RevenueControlDetailId IS NOT NULL)
     AND year(F.InvoiceDate) = '2022'
     AND (dos.IsDelete = '0')
	 and  p.IPCODPACI <> '012345678'
	 and ga.code in ('BOG315','BOG314','BOG313','BOG312','BOG311','BOG310','BOG309','BOG308','BOG307','BOG306','BOG305','BOG304','BOG303'
	 ,'BOG292','BOG120','BOG115',
	 'BOG207', 'BOG200','BOG199','BOG198','BOG197','BOG196','BOG195','BOG194','BOG193','BOG192','BOG191','BOG190','BOG189','BOG188','BOG187','BOG186'
	 ,'BOG098','BOG099','BOG100','BOG101','BOG102','BOG103','BOG104','BOG105','BOG106','BOG107','BOG108','BOG109','BOG110','BOG111','BOG129','BOG208'
)

