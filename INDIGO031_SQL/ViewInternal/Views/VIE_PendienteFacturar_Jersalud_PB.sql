-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_PendienteFacturar_Jersalud_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VIE_PendienteFacturar_Jersalud_PB] as
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
										  WHEN '021' THEN 'MIRAFLOREZ' END AS Sede,  ING.IESTADOIN AS EstadoIngreso, so.AdmissionNumber AS Ingreso, ing.ifechaing AS FechaIngreso, 
                     
						t .Name AS Entidad, 
						 t .Nit AS [Nit Entidad], ga.Code AS [Grupo Atención], ga.Name AS [Descripción Grupo Atención], 
                         rcd.TotalFolio AS [Vr total folio pendiente facturar],
                         
                         CASE sod.RecordType WHEN '1' THEN 'Servicios' WHEN '2' THEN 'Medicamentos' END AS [Servicios/Medicamentos], CUPS.Code AS [Código CUPS], 
                         CUPS.Description AS [Descripción CUPS], ServicioSIPS.Code AS [Código Servicio], ServicioSIPS.Name AS [Descripción Servicio],
                         
						  pr.Code AS [Cód Producto], 
                         pr.Name AS [Descripción Producto], 
						 
						 uf.Code AS [Unidad Funcional], 
                         uf.Name AS [Descripción Unidad Funcional], salida.fecaltpac AS [Fecha Alta médica], 
						  ing.ufuegrmed AS UnidadEgreso--,
					
FROM           Billing.RevenueControlDetail as rcd  INNER JOIN
               Billing.ServiceOrderDetailDistribution as sodd  ON rcd.Id =  sodd.RevenueControlDetailId AND 
                      rcd.Status IN ('1', '3') INNER JOIN
               Billing.ServiceOrderDetail as sod  ON sodd.ServiceOrderDetailId = sod.Id INNER JOIN
               Billing.RevenueControl as rc  ON rcd.RevenueControlId = rc.Id LEFT OUTER JOIN
               dbo.INPACIENT AS p  ON p.IPCODPACI = rc.PatientCode LEFT OUTER JOIN
               Contract.CareGroup AS ga  ON ga.Id = rcd.CareGroupId LEFT OUTER JOIN
               Billing.InvoiceCategories AS cat  ON cat.Id = rcd.InvoiceCategoryId LEFT OUTER JOIN
                --[INDIGO031].[INDIGO031].Security.[User] AS u   ON u.UserCode = rcd.CreationUser LEFT OUTER JOIN
                --        Security.Person AS per   ON per.Id = u.IdPerson LEFT OUTER JOIN
                --        Security.[User] AS um   ON um.UserCode =Billing.RevenueControlDetail.ModificationUser LEFT OUTER JOIN
                --        Security.Person AS PERM   ON PERM.Id = um.IdPerson LEFT OUTER JOIN
               Contract.CUPSEntity AS cups  ON cups.id = sod.CUPSEntityId LEFT OUTER JOIN
               Contract.IPSService AS ServiciosIPS  ON ServiciosIPS.id = sod.IPSServiceId LEFT OUTER JOIN
               Inventory.InventoryProduct AS pr  ON pr.id = sod.ProductId LEFT OUTER JOIN
               Payroll.FunctionalUnit AS UF  ON uf.Id = sod.PerformsFunctionalUnitId LEFT OUTER JOIN
               dbo.HCREGEGRE AS salida  ON salida.numingres = rc.AdmissionNumber LEFT OUTER JOIN
               Contract.HealthAdministrator AS ea  ON ea.id = rcd.HealthAdministratorId LEFT OUTER JOIN
               Common.ThirdParty AS t  ON t .id = sod.ThirdPartyId LEFT OUTER JOIN
               dbo.ADINGRESO AS ing  ON ing.numingres  = rc.AdmissionNumber LEFT OUTER JOIN
                Billing.ServiceOrderDetailSurgical AS dq  ON dq.ServiceOrderDetailId = sod.id LEFT OUTER JOIN
                Contract.IPSService AS ServiciosIPSQ  ON ServiciosIPSQ.id = dq.IPSServiceId LEFT OUTER JOIN
                Billing.ServiceOrder AS so   ON so.id = sod.ServiceOrderId LEFT OUTER JOIN
		  Contract.SurgicalGroup AS sg  on sg.Id=ServiciosIPSQ.SurgicalGroupId 
WHERE       rcd.Status IN ('1', '3')  AND sod.IsDelete = '0' AND ing.iestadoin <> 'A' AND 
                         ing.iestadoin <> 'F' AND ing.iestadoin <>  'C' AND YEAR(ing.ifechaing)>='2021'
