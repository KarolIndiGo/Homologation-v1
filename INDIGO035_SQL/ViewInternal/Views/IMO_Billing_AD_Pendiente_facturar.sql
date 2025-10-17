-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_Billing_AD_Pendiente_facturar
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IMO_Billing_AD_Pendiente_facturar] AS

SELECT        Billing.RevenueControlDetail.CareGroupId, Billing.RevenueControlDetail.id, case when ing.codcenate in ('001', '00101', '00102', '00103') then 'Neiva' when ing.codcenate='00104' then 'Abner' end AS Sede, ING.IESTADOIN AS EstadoIngreso, so.AdmissionNumber AS Ingreso, ing.ifechaing AS FechaIngreso, 
                         Billing.RevenueControl.PatientCode AS Identificación, p.IPNOMCOMP AS Paciente, --t .Name AS Entidad, 
						 Billing.RevenueControlDetail.FolioOrder AS [Folios a facturar], 
                         CASE Billing.RevenueControlDetail.FolioType WHEN '1' THEN 'EAPB con contrato' WHEN '2' THEN 'EAPB sin contrato' WHEN '3' THEN 'Particulares' WHEN '4' THEN 'Aseguradoras' END AS Tipo, 
                         CASE Billing.RevenueControlDetail.LiquidationType WHEN '1' THEN 'Pago por servicios' WHEN '2' THEN 'Capitacion' WHEN '3' THEN 'Factura Global' WHEN '4' THEN 'Capitacion Global' END AS [Tipo de liquidacion],
                          ea.HealthEntityCode AS [Entidad Administradora],
						   CASE WHEN t.persontype = '1' THEN '999' ELSE t.Nit END AS [Nit Entidad], 
CASE WHEN t.persontype = '1' THEN 'PACIENTES PARTICULARES' ELSE t.Name END AS Entidad,
						  --t .Nit AS [Nit Entidad], 
						  ga.Code AS [Grupo Atención], ga.Name AS [Descripción Grupo Atención], 
                         Billing.RevenueControlDetail.TotalFolio AS [Vr total folio pendiente facturar], dq.InvoicedQuantity AS [Cantidad QX], dq.TotalSalesPrice AS [Total Facturado QX], 
                         dq.PerformsHealthProfessionalCode AS [Cód Profesional QX], rtrim(medqx.CODPROSAL) + ' - ' + ltrim(medqx.NOMMEDICO) AS [Profesional QX], 
                         CASE Billing.RevenueControlDetail.ResponsibleRecoveryFee WHEN '1' THEN 'Ninguno' WHEN '2' THEN 'Paciente' WHEN '3' THEN 'Tercero' END AS [Responsable cuota recuperación], 
                         Billing.RevenueControlDetail.TotalPatientWithDiscount AS [Vr cobrado a Paciente], Billing.RevenueControlDetail.ValueCopay AS [Vr cuota recuperación folio], 
                         Billing.RevenueControlDetail.ValueFeeModerator AS [Vr cuota moderadora folio], Billing.RevenueControlDetail.Observation AS [Observaciones], cat.Name AS [Categoría para RIPS], 
                         CASE Billing.RevenueControlDetail.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Facturado' WHEN '3' THEN 'Bloqueado' END AS 'Estado', per.Fullname AS [Usuario Crea], 
                         Billing.RevenueControlDetail.CreationDate AS [Fecha creación], PERM .Fullname AS [Usuario modifica], Billing.RevenueControlDetail.ModificationDate AS [Fecha modificación], 
                         CASE Billing.ServiceOrderDetail.ServiceType WHEN '1' THEN 'SOAT' WHEN '2' THEN 'ISS' WHEN '3' THEN 'CUPS' END AS [Tipo Servicio], 
                         CASE Billing.ServiceOrderDetail.RecordType WHEN '1' THEN 'Servicios' WHEN '2' THEN 'Medicamentos' END AS [Servicios/Medicamentos], CUPS.Code AS [Código CUPS], 
                         CUPS.Description AS [Descripción CUPS], ServicioSIPS.Code AS [Código Servicio], ServicioSIPS.Name AS [Descripción Servicio], Billing.ServiceOrderDetail.Packaging AS [Servicio incluido en Paquete], 
                         CASE Billing.ServiceOrderDetail.Presentation WHEN '1' THEN 'No Quirúrgico' WHEN '2' THEN 'Quirúrgico' WHEN '3' THEN 'Paquete' END AS [Presentación Servicio], pr.Code AS [Cód Producto], 
                         pr.Name AS [Descripción Producto], Billing.ServiceOrderDetail.SupplyQuantity AS [Cantidad entregada], Billing.ServiceOrderDetail.DevolutionQuantity AS [Cantidad devuelta], 
                         Billing.ServiceOrderDetail.InvoicedQuantity AS [Cantidad a facturar], Billing.ServiceOrderDetail.RateManualSalePrice AS [Valor unitario  a facturar ], (Billing.ServiceOrderDetail.InvoicedQuantity) 
                         * (Billing.ServiceOrderDetail.RateManualSalePrice) AS [Total a facturar], Billing.RevenueControlDetail.TotalPatientSalesPrice AS [Total Cuota Recuperación], 
                         Billing.ServiceOrderDetail.ServiceDate AS [Fecha Servicio],  Billing.ServiceOrderDetail.AuthorizationNumber AS [Autorización], uf.Code AS [Unidad Funcional], 
                         uf.Name AS [Descripción Unidad Funcional], salida.fecaltpac AS [Fecha Alta médica], Billing.RevenueControlDetail.TimeStamp, ing.ufuegrmed AS UnidadEgreso,
						 ServiciosIPSQ.Score as UVR, ServiciosIPSQ.NewScore as [UVR > 450], sg.name as [Grupo Quirurgico],CASE ga.EntityType WHEN '1' THEN 'EPS Contributivo' WHEN '2' THEN 'EPS Subsidiado' WHEN '3' THEN 'ET Vinculados Municipios' WHEN '4' THEN 'ET Vinculados Departamentos' WHEN '5' THEN 'ARL' WHEN '6' THEN 'Prepagada' WHEN '7' THEN 'IPS' WHEN '8' THEN 'IPS' WHEN '9' THEN 'Regimen Especial' WHEN '10' THEN 'Accidentes Transito'
WHEN '11' THEN 'Fosyga' WHEN '12' THEN 'Otros' WHEN '13' THEN 'Aseguradoras' WHEN '99' THEN 'Particulares' END AS Regimen,
CONCAT(ne.Code,' - ',ne.Name) As [Finalidad Consulta/Procedimiento],
			CASE
			WHEN ne.code in ('11','12','13','15','16','17','18','19','20','22','23','24','25','27','43','44') THEN 'AC y AP'
			WHEN ne.Code in ('14','26','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42') THEN 'AP'
			WHEN ne.Code in ('21') THEN 'AC'
			ELSE '' END AS 'Finalidad Aplica Para'
FROM            Billing.RevenueControlDetail INNER JOIN
                         Billing.ServiceOrderDetailDistribution ON Billing.RevenueControlDetail.Id =  Billing.ServiceOrderDetailDistribution.RevenueControlDetailId AND 
                         Billing.RevenueControlDetail.Status IN ('1', '3') INNER JOIN
                         Billing.ServiceOrderDetail ON Billing.ServiceOrderDetailDistribution.ServiceOrderDetailId = Billing.ServiceOrderDetail.Id INNER JOIN
                         Billing.RevenueControl ON Billing.RevenueControlDetail.RevenueControlId = Billing.RevenueControl.Id LEFT OUTER JOIN
                         dbo.INPACIENT AS p ON p.IPCODPACI = Billing.RevenueControl.PatientCode LEFT OUTER JOIN
                         Contract.ContractEntity AS e ON e.Id = Billing.RevenueControlDetail.ContractEntityId LEFT OUTER JOIN
                         Contract.CareGroup AS ga ON ga.Id = Billing.RevenueControlDetail.CareGroupId LEFT OUTER JOIN
                         Billing.InvoiceCategories AS cat ON cat.Id = Billing.RevenueControlDetail.InvoiceCategoryId LEFT OUTER JOIN
                         Security.[User] AS u ON u.UserCode = Billing.RevenueControlDetail.CreationUser LEFT OUTER JOIN
                         Security.Person AS per ON per.Id = u.IdPerson LEFT OUTER JOIN
                         Security.[User] AS um ON um.UserCode = Billing.RevenueControlDetail.ModificationUser LEFT OUTER JOIN
                         Security.Person AS PERM ON PERM.Id = um.IdPerson LEFT OUTER JOIN
                         Contract.CUPSEntity AS cups ON cups.id = Billing.ServiceOrderDetail.CUPSEntityId LEFT OUTER JOIN
                         Contract.IPSService AS ServiciosIPS ON ServiciosIPS.id = Billing.ServiceOrderDetail.IPSServiceId LEFT OUTER JOIN
                         Inventory.InventoryProduct AS pr ON pr.id = Billing.ServiceOrderDetail.ProductId LEFT OUTER JOIN
                         Payroll.FunctionalUnit AS UF ON uf.Id = Billing.ServiceOrderDetail.PerformsFunctionalUnitId LEFT OUTER JOIN
                         dbo.HCREGEGRE AS salida ON salida.numingres = Billing.RevenueControl.AdmissionNumber LEFT OUTER JOIN
                         Contract.HealthAdministrator AS ea ON ea.id = Billing.RevenueControlDetail.HealthAdministratorId LEFT OUTER JOIN
                         Common.ThirdParty AS t ON t .id = Billing.ServiceOrderDetail.ThirdPartyId LEFT OUTER JOIN
                         DBO.ADINGRESO AS ing ON ing.numingres  = Billing.RevenueControl.AdmissionNumber LEFT OUTER JOIN
                         Billing.ServiceOrderDetailSurgical AS dq ON dq.ServiceOrderDetailId = Billing.ServiceOrderDetail.id LEFT OUTER JOIN
                         Contract.IPSService AS ServiciosIPSQ ON ServiciosIPSQ.id = dq.IPSServiceId LEFT OUTER JOIN
                         dbo.INPROFSAL AS medqx ON medqx.CODPROSAL = dq.PerformsHealthProfessionalCode LEFT OUTER JOIN
                         Billing.ServiceOrder AS so  ON so.id = Billing.ServiceOrderDetail.ServiceOrderId LEFT OUTER JOIN
		   Contract.SurgicalGroup AS sg on sg.Id=ServiciosIPSQ.SurgicalGroupId left join 
		   Admissions.HealthPurposes as NE on NE.Id = Ing.IdHealthPurposes
WHERE        Billing.RevenueControlDetail.Status IN ('1', '3') AND Billing.ServiceOrderDetail.IsDelete = '0' AND ing.iestadoin <> 'A' AND 
                         ing.iestadoin <> 'F' AND ing.iestadoin <>  'C'  and Billing.RevenueControl.PatientCode<>'0123456789'
