-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_FACT_Prefacturacion
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_FACT_Prefacturacion] AS
     SELECT RC.PatientCode AS Doc,
            CASE
                WHEN RCD.InvoiceCategoryId IS NULL
                THEN ''
                ELSE CONCAT(IC.Code, ' - ', IC.Name)
            END AS InvoiceCategoryCodeName, 
            SO.Code AS ServiceOrderCode, 
            RC.AdmissionNumber AS '#Admision', 
            CONCAT(CONCAT(TP.Nit, ' - '), TP.Name) AS Tercero, 
            CONCAT(CONCAT(CG.Code, ' - '), CG.Name) AS GrupoAtencion, 
            RCD.TotalFolio, 
            COALESCE(SOD1.DGrandTotalSalesPrice, 0) AS GrandTotalSalesPrice, 
            COALESCE(SOD1.DistributionType, 1) AS DistributionType, 
            COALESCE(SOD1.ThirdPartySalesPrice, 0) AS ThirdPartySalesPrice, 
            COALESCE(SOD1.ThirdPartyPercentage, 0) AS ThirdPartyPercentage, 
            RCD.PatientDiscount AS Descuento, 
            COALESCE(RCD.TotalPatientSalesPrice, 0) AS TotalPatientSalesPrice, 
            COALESCE(RCD.TotalPatientWithDiscount, 0) AS TotalPatientWithDiscount, 
            COALESCE(RCD.ValueVoucher, 0) AS VoucherValue, 
            COALESCE(IPSS.Code, '') AS CodService, 
            CONCAT(CUPSE.Code, ' - ', CUPSE.Description) AS CUPS, 
            COALESCE(IPSS.Name, '') AS IPSServiceName, 
            CONCAT(CONCAT(BG1.Code, ' - '), BG1.Name) AS GrupoFacturacion, 
            COALESCE(SOD1.Quantity, 0) AS InvoicedQuantity, 
            COALESCE(SOD1.SupplyQuantity, 0) AS SupplyQuantity, 
            COALESCE(SOD1.DevolutionQuantity, 0) AS DevolutionQuantity, 
            COALESCE(SOD1.RateManualSalePrice, 0) AS RateManualSalePrice, 
            (CASE SOD1.SettlementType
                 WHEN 3
                 THEN 'Si'
                 ELSE 'No'
             END) AS SurchargeApply, 
            COALESCE(SOD1.RecoveryFeeType, 0) AS RecoveryFeeType, 
            COALESCE(SOD1.CostValue, 0) AS Costo, 
            COALESCE(SOD1.ServiceDate, GETDATE()) AS FechaServico, 
            COALESCE(SOD1.AuthorizationNumber, '0') AS AuthorizationNumber, 
            CONCAT(CONCAT(FU.Code, ' - '), FU.Name) AS UnidadFuncional, 
            COALESCE(SOD1.PerformsHealthProfessionalCode, '') AS Profesional, 
            COALESCE(SOD1.PerformsProfessionalSpecialty, -1) AS PerformsProfessionalSpecialty, 
            CONCAT(CONCAT(IPSSG.Code, ' - '), IPSSG.Name) AS ConceptoFactutacion, 
            CONCAT(CONCAT(CC.Code, ' - '), CC.Name) AS CostCenterCodeName, 
            COALESCE(SOD1.SubTotalSalesPrice, 0) AS SubTotalSalesPrice, 
            COALESCE(SOD1.ThirdPartyDiscountPercentage, 0) AS ThirdPartyDiscountPercentage, 
            COALESCE(SOD1.TotalSalesPrice, 0) AS TotalSalesPrice,
            CASE RCD.STATUS
                WHEN 1
                THEN 'Registrado'
                WHEN 2
                THEN 'Facturado'
                WHEN 3
                THEN 'Bloqueado'
            END AS Estado, 
            COALESCE(SOD1.IsPackage, 0) AS Paquete,
            CASE
                WHEN SOD1.RecordType = 1
                THEN COALESCE(IPSS.Code, '')
            END AS Codigo,
            CASE
                WHEN SOD1.RecordType = 1
                THEN COALESCE(IPSS.Name, '')
            END AS 'Servicio', 
            CONCAT(LTRIM(RTRIM(RC.AdmissionNumber)), ' - Paciente: ', LTRIM(RTRIM(RC.PatientCode)), ' - ', THP.Name) AS Paciente,
            CASE
                WHEN cc.Code LIKE 'B0%'
                THEN 'Boyaca'
                WHEN cc.Code LIKE 'MET%'
                THEN 'Meta'
                WHEN cc.Code LIKE 'YOP%'
                THEN 'Casanare'
				WHEN cc.Code LIKE 'CAS%'
                THEN 'Casanare'
                WHEN cc.Code LIKE 'TAM%'
                THEN 'Bogota'
            END AS Regional, 
			
			CONCAT(ne.Code,' - ',ne.Name) As [Finalidad Consulta/Procedimiento],
			CASE
			WHEN ne.code in ('11','12','13','15','16','17','18','19','20','22','23','24','25','27','43','44') THEN 'AC y AP'
			WHEN ne.Code in ('14','26','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42') THEN 'AP'
			WHEN ne.Code in ('21') THEN 'AC'
			ELSE '' END AS 'Finalidad Aplica Para'

     /*, ING.IFECHAING AS FechaIngreso*/

     FROM Billing.RevenueControlDetail RCD 
          INNER JOIN Billing.RevenueControl RC  ON RCD.RevenueControlId = RC.Id
                                                                                 AND RCD.STATUS <> 2
          INNER JOIN Common.ThirdParty TP  ON RCD.ThirdPartyId = TP.Id
          INNER JOIN Contract.CareGroup CG  ON RCD.CareGroupId = CG.Id
          LEFT JOIN Billing.InvoiceCategories IC  ON RCD.InvoiceCategoryId = IC.Id
          LEFT JOIN
     (
         SELECT SOD.ServiceOrderId, 
                SOD.PerformsFunctionalUnitId, 
                SOD.BillingConceptId, 
                SOD.CostCenterId, 
                SOD.DefinitionRateDetailId, 
                SOD.ProductId, 
                SOD.IPSServiceId, 
                SOD.CUPSEntityId, 
                SOD.SurgeryNumber, 
                SOD.Presentation, 
                SOD.CodeAssociateService, 
                SOD.Id AS SODID, 
                SOD.SettlementType, 
                SOD.RecordType, 
                SOD.SupplyQuantity, 
                SOD.DevolutionQuantity, 
                SOD.RateManualSalePrice, 
                SOD.CostValue, 
                SOD.ServiceDate, 
                SOD.AuthorizationNumber, 
                SOD.PerformsHealthProfessionalCode, 
                SOD.PerformsProfessionalSpecialty, 
                SOD.SubTotalSalesPrice, 
                SOD.ThirdPartyDiscount, 
                SOD.ThirdPartyDiscountPercentage, 
                SOD.TotalSalesPrice, 
                SOD.IsPackage, 
                SODD.RevenueControlDetailId, 
                SODD.Id AS SODDID, 
                SODD.GrandTotalSalesPrice AS DGrandTotalSalesPrice, 
                SODD.DistributionType, 
                SODD.ThirdPartySalesPrice, 
                SODD.ThirdPartyPercentage, 
                SODD.SubTotalPatientSalesPrice, 
                SODD.PatientPercentage, 
                SODD.Quantity, 
                SODD.RecoveryFeeType, 
                SODD.ApplyRecoveryFee, 
                SODD.GrandTotalDiscount
         FROM Billing.ServiceOrderDetailDistribution SODD
              INNER JOIN Billing.ServiceOrderDetail SOD ON SODD.ServiceOrderDetailId = SOD.Id
                                                                             AND SOD.InvoicedQuantity > 0
                                                                             AND SOD.IsDelete = 0
         WHERE SODD.Quantity > 0
     ) AS SOD1 ON SOD1.RevenueControlDetailId = RCD.Id
                  AND SOD1.DGrandTotalSalesPrice > 0
          LEFT JOIN Billing.ServiceOrder SO  ON SOD1.ServiceOrderId = SO.Id
          LEFT JOIN Payroll.FunctionalUnit FU  ON SOD1.PerformsFunctionalUnitId = FU.Id
          LEFT JOIN Billing.BillingConcept IPSSG  ON SOD1.BillingConceptId = IPSSG.Id
          LEFT JOIN Payroll.CostCenter CC  ON SOD1.CostCenterId = CC.Id
          LEFT JOIN Contract.DefinitionRateDetail DRD  ON DRD.Id = SOD1.DefinitionRateDetailId
          LEFT JOIN

     /*Inventory.InventoryProduct IP  ON SOD1.ProductId = IP.Id LEFT JOIN*/

     Contract.IPSService IPSS  ON SOD1.IPSServiceId = IPSS.Id
          LEFT JOIN Contract.CUPSEntity CUPSE  ON SOD1.CUPSEntityId = CUPSE.Id
          LEFT JOIN Billing.BillingGroup BG1  ON CUPSE.BillingGroupId = BG1.Id
          LEFT JOIN

/*Billing.BillingGroup BG2  ON IP.BillingGroupId = BG2.Id LEFT JOIN
             Inventory.InventoryProduct P  ON P.Id = SOD1.ProductId LEFT JOIN
             Billing.BillingGroup BG3  ON P.BillingGroupId = BG3.Id LEFT JOIN
             Inventory.ATC AT  ON P.ATCId = AT.Id LEFT JOIN */

     Common.ThirdParty THP  ON RC.PatientCode = THP.Nit
          INNER JOIN dbo.ADINGRESO I  ON RC.AdmissionNumber = I.NUMINGRES AND I.IESTADOIN = ''
		  left join Admissions.HealthPurposes as NE on NE.Id = I.IdHealthPurposes


