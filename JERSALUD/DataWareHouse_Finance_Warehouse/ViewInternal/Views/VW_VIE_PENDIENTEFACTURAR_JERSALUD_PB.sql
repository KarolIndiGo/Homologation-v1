-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_PENDIENTEFACTURAR_JERSALUD_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_PENDIENTEFACTURAR_JERSALUD_PB as
SELECT   
 case  ing.CODCENATE  WHEN '001' THEN 'BOGOTA' 
										  WHEN '002' THEN 'TUNJA'
										  WHEN '003' THEN 'DUITAMA'
										  WHEN '004' THEN 'SOGAMOSO'
										  WHEN '005' THEN 'CHIQUINQUIRA'
										  WHEN '006' THEN 'GARAGOA'
										  WHEN '007' THEN 'GUATEQUE'
										  WHEN '008' THEN 'SOATA'
										  WHEN '009' THEN 'MONIQUIRA'
										  WHEN '010' THEN 'VILLAVICENCIO'
										  WHEN '011' THEN 'ACACIAS'
										  WHEN '012' THEN 'GRANADA'
										  WHEN '013' THEN 'PUERTO LOPEZ'
										  WHEN '014' THEN 'PUERTO GAITAN'
										  WHEN '015' THEN 'YOPAL'
										  WHEN '016' THEN 'VILLANUEVA'
										  WHEN '017' THEN 'PUERTO BOYACA'
										  WHEN '018' THEN 'SAN MARTIN'
										  WHEN '019' THEN 'PAZ DE ARIPORO'
										  WHEN '020' THEN 'AGUAZUL'
										  WHEN '021' THEN 'MIRAFLOREZ' END AS Sede,  ing.IESTADOIN AS EstadoIngreso, so.AdmissionNumber AS Ingreso, ing.IFECHAING AS FechaIngreso, 
                     
						t .Name AS Entidad, 
						 t .Nit AS [Nit Entidad], ga.Code AS [Grupo Atención], ga.Name AS [Descripción Grupo Atención], 
                         rcd.TotalFolio AS [Vr total folio pendiente facturar],
                         
                         CASE sod.RecordType WHEN '1' THEN 'Servicios' WHEN '2' THEN 'Medicamentos' END AS [Servicios/Medicamentos], cups.Code AS [Código CUPS], 
                         cups.Description AS [Descripción CUPS], ServiciosIPS.Code AS [Código Servicio], ServiciosIPS.Name AS [Descripción Servicio],
                         
						  pr.Code AS [Cód Producto], 
                         pr.Name AS [Descripción Producto], 
						 
						 UF.Code AS [Unidad Funcional], 
                         UF.Name AS [Descripción Unidad Funcional], salida.FECALTPAC AS [Fecha Alta médica], 
						  ing.UFUEGRMED AS UnidadEgreso--,
					
FROM           INDIGO031.Billing.RevenueControlDetail as rcd  INNER JOIN
               INDIGO031.Billing.ServiceOrderDetailDistribution as sodd  ON rcd.Id =  sodd.RevenueControlDetailId AND 
                      rcd.Status IN ('1', '3') INNER JOIN
               INDIGO031.Billing.ServiceOrderDetail as sod  ON sodd.ServiceOrderDetailId = sod.Id INNER JOIN
               INDIGO031.Billing.RevenueControl as rc  ON rcd.RevenueControlId = rc.Id LEFT OUTER JOIN
               INDIGO031.dbo.INPACIENT AS p  ON p.IPCODPACI = rc.PatientCode LEFT OUTER JOIN
               INDIGO031.Contract.CareGroup AS ga  ON ga.Id = rcd.CareGroupId LEFT OUTER JOIN
               INDIGO031.Billing.InvoiceCategories AS cat  ON cat.Id = rcd.InvoiceCategoryId LEFT OUTER JOIN
                --[INDIGO031].[INDIGO031].Security.[User] AS u   ON u.UserCode = rcd.CreationUser LEFT OUTER JOIN
                --        Security.Person AS per   ON per.Id = u.IdPerson LEFT OUTER JOIN
                --        Security.[User] AS um   ON um.UserCode =Billing.RevenueControlDetail.ModificationUser LEFT OUTER JOIN
                --        Security.Person AS PERM   ON PERM.Id = um.IdPerson LEFT OUTER JOIN
               INDIGO031.Contract.CUPSEntity AS cups  ON cups.Id = sod.CUPSEntityId LEFT OUTER JOIN
               INDIGO031.Contract.IPSService AS ServiciosIPS  ON ServiciosIPS.Id = sod.IPSServiceId LEFT OUTER JOIN
               INDIGO031.Inventory.InventoryProduct AS pr  ON pr.Id = sod.ProductId LEFT OUTER JOIN
               INDIGO031.Payroll.FunctionalUnit AS UF  ON UF.Id = sod.PerformsFunctionalUnitId LEFT OUTER JOIN
               INDIGO031.dbo.HCREGEGRE AS salida  ON salida.NUMINGRES = rc.AdmissionNumber LEFT OUTER JOIN
               INDIGO031.Contract.HealthAdministrator AS ea  ON ea.Id = rcd.HealthAdministratorId LEFT OUTER JOIN
               INDIGO031.Common.ThirdParty AS t  ON t .Id = sod.ThirdPartyId LEFT OUTER JOIN
               INDIGO031.dbo.ADINGRESO AS ing  ON ing.NUMINGRES  = rc.AdmissionNumber LEFT OUTER JOIN
               INDIGO031.Billing.ServiceOrderDetailSurgical AS dq  ON dq.ServiceOrderDetailId = sod.Id LEFT OUTER JOIN
               INDIGO031.Contract.IPSService AS ServiciosIPSQ  ON ServiciosIPSQ.Id = dq.IPSServiceId LEFT OUTER JOIN
               INDIGO031.Billing.ServiceOrder AS so   ON so.Id = sod.ServiceOrderId LEFT OUTER JOIN
		  INDIGO031.Contract.SurgicalGroup AS sg  on sg.Id=ServiciosIPSQ.SurgicalGroupId 
WHERE       rcd.Status IN ('1', '3')  AND sod.IsDelete = '0' AND ing.IESTADOIN <> 'A' AND 
                         ing.IESTADOIN <> 'F' AND ing.IESTADOIN <>  'C' AND YEAR(ing.IFECHAING)>='2021'