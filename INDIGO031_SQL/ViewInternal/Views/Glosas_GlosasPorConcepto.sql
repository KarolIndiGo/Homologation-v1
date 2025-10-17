-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Glosas_GlosasPorConcepto
-- Extracted by Fabric SQL Extractor SPN v3.9.0

--/****** Object:  View [ViewInternal].[Glosas_GlosasPorConcepto]    Script Date: 5/10/2025 7:37:57 p. m. ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


CREATE view [ViewInternal].[Glosas_GlosasPorConcepto] as
 SELECT distinct
	 DE.ServiceOrderDetailId AS ideorden,
            op.UnitName AS Sede, 
            CO.Code AS CodConcepto, 
            CO.NameGeneral AS General, 
            CO.NameSpecific AS Especifico, 
            DG.RationaleGlosa AS Comentario, 
            DG.InvoiceNumber AS NroFactura, 
            G.InvoiceDate AS FechaFactura, 
            C.Nit, 
            C.Name AS Entidad, 
            DE.CostCenterCode AS CC, 
            DE.CostCenterName AS NombreCentro, 
            DG.ValueGlosado AS ValorGlosado, 
            G.InvoiceValueEntity AS ValorFactura, 
            DE.ServiceCode AS CodServicio, 
            DE.ServiceName AS Servicio, 
            DE.UnitValue AS ValorUnitario, 
            DE.Ammount AS Cantidad, 
            DE.MedicalCode AS CodMedico, 
            DE.MedicalName AS Medico, 
            G.RadicatedNumber AS RadicadoERP, 
            G.RadicatedDate AS FechaRadicadoERP, 
            GC.RadicatedDate AS FechaRecepcionObjecion, 
            GC.DocumentDate AS [Fecha Oficio Radicación Glosa], 
            DE.BillerCode AS Codfacturador, 
            G.UserNameInvoice AS Facturador,
            CASE
                WHEN DE.TypeServiceProduct = '1'
                THEN 'Servicio'
                WHEN DE.TypeServiceProduct = '2'
                THEN 'Medicamento o Insumo'
            END AS TipoServicio,
            CASE
                WHEN DE.TypeProcedure = '1'
                THEN 'No quirurgico'
                WHEN DE.TypeProcedure = '2'
                THEN 'Quirurgico'
                WHEN DE.TypeProcedure = '3'
                THEN 'Paquete'
                WHEN DE.TypeProcedure = '4'
                THEN 'NoAplica'
            END AS TipoProcedimiento, 
            case when DG.ValueAcceptedFirstInstance >0  then DG.ValueAcceptedFirstInstance 
			     --when DG.ValueAcceptedFirstInstance >0 and  dg.ValueAcceptedIPSconciliation >0 then DG.ValueAcceptedIPSconciliation 
			else DG.ValueAcceptedIPSconciliation end AS AceptacionIPS, 
			
            DG.ValueAcceptedEAPBconciliation AS AceptacionEAPB, 
            DG.ValueAcceptedIPSconciliation + DG.ValueAcceptedEAPBconciliation AS ValorConciliado, 
            DG.ValuePendingConciliation AS ValorPendienteConciliacion, 
            CONT.ContractNumber AS [Número de contrato], 
            DG.JustificationGlosaText AS [Justificación Glosa], 
            CAT.Name AS Categoria, 
            T.Name AS Tercero, 
            CAR.Balance AS [Saldo Cartera],
			F.PatientCode AS Identificacion, 
            p.IPNOMCOMP AS Paciente,
			--dG.ValueAcceptedFirstInstance,
			--con.ConfirmDate ,
			--con.ConciliationDate ,
			--CON.ModificationDate,
			 case when dG.ValueAcceptedFirstInstance >0 then CoordinationDateGlosa  
								 ELSE CON.ConciliationDate
			 --when dG.ValueAcceptedFirstInstance = 0   AND CON.ConfirmDate>CON.ConciliationDate THEN CON.ModificationDate 
			 --when  con.ConfirmDate is not null  AND CON.ConfirmDate>CON.ConciliationDate then con.ConciliationDate
			 --when  con.ConfirmDate is null then con.ConciliationDate
			 
			  --when (dG.ValueAcceptedFirstInstance is null or dG.ValueAcceptedFirstInstance = 0) then con.CreationDate  
				   --when dG.ValueAcceptedFirstInstance = 0 and con.ConfirmDate is not null then con.ConfirmDate 
				   --when dG.ValueAcceptedFirstInstance = 0 and con.ConfirmDate is null then con.ConciliationDate  
				   
				   end as FechaConciliacion,
				   con.ConfirmDate as FechaConciliacion1, 
				   con.ConciliationDate as FechaConciliacion2, 
				   con.ModificationDate as FechaConciliacion3, 
				   EvaluationDateGlosa as FechaConciliacion4, 
			f.AdmissionNumber as Ingreso,
			USS.UserCode AS [Cod Usuario Radicado],
			pee.Fullname as [Usuario Radicado] ,case when DE.TypeServiceProduct = '2' then 'MEDICAMENTOS'
												     when DE.TypeServiceProduct = '1' and cuentaS.Name is not null then  cuentaS.Name
													 when DE.TypeServiceProduct = '1' and  cuentaS.Name is null then cuenta.Name
													  end   as Cuenta, BG.CODE as Cod_GrupoFactura, BG.NAME AS GrupoFacturació,
													  nf.Notas, dc.VrCruceAnticipo, recla.ValorReclasificación, pp.PagoParcial
     FROM Glosas.GlosaMovementGlosa AS DG with (nolock)
          INNER JOIN Glosas.GlosaPortfolioGlosada AS G with (nolock)
					INNER JOIN Glosas.GlosaObjectionsReceptionD AS RG with (nolock)
							INNER JOIN Glosas.GlosaObjectionsReceptionC AS GC with (nolock)
									 LEFT JOIN Common.Customer AS C with (nolock)
											ON GC.CustomerId = C.Id
									  ON RG.GlosaObjectionsReceptionCId = GC.Id
							ON G.Id = RG.PortfolioGlosaId
                            AND RG.State <> '4'
		  ON DG.InvoiceNumber = G.InvoiceNumber
          LEFT JOIN Common.ConceptGlosas AS CO with (nolock) ON DG.CodeGlosaId = CO.Id
          LEFT JOIN Glosas.GlosaInvoiceDetail AS DE with (nolock) ON DG.InvoiceDetailId = DE.Id
		  LEFT JOIN Glosas.GlosaInvoiceDetailQX AS DQE with (nolock) ON DG.InvoiceDetailIdQX = DQE.Id
		  LEFT JOIN Contract.IPSService AS IPS with (nolock) ON IPS.CODE=DQE.ServiceCode left join
          --LEFT JOIN Billing.Invoice AS F 
		   (
--select distinct  * from (
SELECT 
PatientCode, 
AdmissionNumber,
InvoiceCategoryId,
CareGroupId,
InvoiceNumber,
OperatingUnitId
 FROM Billing.Invoice with (nolock)

--UNION ALL
--SELECT 
--PatientCode, 
--AdmissionNumber,
--InvoiceCategoryId,
--CareGroupId,
--InvoiceNumber
-- FROM [192.168.10.4].VIE18.Billing.Invoice 
--) as b
) --se agrega subconsulta
as F
				LEFT JOIN Billing.InvoiceCategories AS CAT with (nolock) ON CAT.Id = F.InvoiceCategoryId
				LEFT JOIN Contract.CareGroup AS GA  with (nolock)
				LEFT JOIN Contract.Contract AS CONT with (nolock) ON CONT.Id = GA.ContractId ON F.CareGroupId = GA.Id
				LEFT JOIN Portfolio.AccountReceivable AS CAR with (nolock)
				LEFT OUTER JOIN Common.ThirdParty AS T with (nolock) ON T.Id = CAR.ThirdPartyId AND T.PersonType = '2' ON CAR.InvoiceNumber = F.InvoiceNumber AND CAR.AccountReceivableType <> '6' ON F.InvoiceNumber = DG.InvoiceNumber
				LEFT JOIN dbo.INPACIENT AS P with (nolock) ON P.ipcodpaci = F.PatientCode
				LEFT JOIN Glosas.ConciliationC AS con with (nolock) ON con.ID=DG.ConciliationCId
				--LEFT OUTER JOIN (SELECT max(c.id) as ID, D.InvoiceNumber as Factura, max(c.ConciliationDate) as FechaConciliacion
				--					FROM Glosas.ConciliationD as d with (nolock)
				--							inner join Glosas.ConciliationC as c with (nolock) on c.Id=d.ConciliationCId
				--							group by d.InvoiceNumber) as con on con.Factura=dg.InvoiceNumber
				LEFT OUTER JOIN Security.[User] AS USS  ON USS.Id=GC.RadicatedUser
				LEFT OUTER JOIN Security.Person AS PEE  ON PEE.ID=USS.IdPerson
				left join Contract.CUPSEntity as cups with (nolock) on cups.code=de.ServiceCode
				LEFT JOIN Billing.BillingGroup AS BG WITH (NOLOCK) ON BG.ID=CUPS.BillingGroupId
				left join Common.OperatingUnit as op on op.id=f.OperatingUnitId
		--		left join (	 select cc.code, cc.id, uf.iduf
	 --from  Payroll.CostCenter as cc with (nolock) 
		--		left join (select max(id) as iduf, CostCenterId
		--					from Payroll.FunctionalUnit as uf with (nolock)
		--					group by CostCenterId) as uf on uf.CostCenterId=cc.id) as cc on cc.code=de.CostCenterCode
		--		left join Payroll.FunctionalUnit as uf with (nolock) on uf.id=cc.iduf

		--				left join Billing.BillingConceptAccount as concp with (nolock) on concp.BillingConceptId=cups.BillingConceptId and concp.UnitType=uf.UnitType
			--	left join Billing.BillingConcept conc with (nolock) on conc.ID=IPS.BillingConceptId 
			--	eft join Billing.BillingConceptAccount as concpS with (nolock) on concpS.BillingConceptId=IPS.BillingConceptId and concpS.UnitType=UFQ.UnitType
				left join GeneralLedger.MainAccounts as cuenta  on cuenta.NUMBER= DE.AccountantAccountIncome --concp.IncomeRecognitionMainAccountId
				left join GeneralLedger.MainAccounts as cuentaS  on cuentaS.Number=DQE.AccountantAccountIncome
			--	left join Billing.BillingConcept as concp1 with (nolock) on concp1.Id=cups.BillingConceptId
			--	left join GeneralLedger.MainAccounts as cuenta1 with (nolock) on cuenta1.id=concp1.IncomeRecognitionPendingBillingMainAccountId

			LEFT JOIN (SELECT Factura, Ajuste as Notas
			FROM [ViewInternal].[Portfolio_NotasCartera_Entidad] WITH (NOLOCK)) as nf on nf.Factura=  DG.InvoiceNumber 
			LEFT JOIN (SELECT 

           --CASE CA.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' WHEN '4' THEN 'Reversado' END AS EstadoCruce, 
		   CAR.InvoiceNumber AS Factura, DT.Value AS VrCruceAnticipo
          -- CA.CreationUser + '_' + per.Fullname AS Usuario, F.TotalInvoice AS VrFactura, pa.code as Anticipo, ca.Id,
		
FROM   Portfolio.PortfolioTransfer AS CA WITH (nolock) LEFT OUTER JOIN
           Common.Customer AS C WITH (nolock) ON C.Id = CA.CustomerId LEFT OUTER JOIN
           GeneralLedger.MainAccounts AS cuenta WITH (nolock) ON cuenta.Id = CA.MainAccountId INNER JOIN
           Portfolio.PortfolioTransferDetail AS DT WITH (nolock) ON DT.PortfolioTrasferId = CA.Id INNER JOIN
           Portfolio.AccountReceivable AS CAR WITH (nolock) ON CAR.Id = DT.AccountReceivableId INNER JOIN
           Common.ThirdParty AS T WITH (nolock) ON T.Id = CAR.ThirdPartyId INNER JOIN
           Portfolio.PortfolioAdvance AS pa WITH (nolock) ON pa.Id = CA.PortfolioAdvanceId INNER JOIN
           --Security.[User] AS u  ON u.UserCode = CA.CreationUser LEFT OUTER JOIN
           --Security.Person AS per  ON per.Id = u.IdPerson LEFT OUTER JOIN
           Billing.Invoice AS F WITH (nolock) ON F.Id = CAR.InvoiceId LEFT OUTER JOIN
           Common.OperatingUnit AS UO WITH (nolock) ON UO.Id = F.OperatingUnitId 
WHERE (cuenta.LegalBookId = 1) and CA.Status=2) --and car.InvoiceNumber='JSV129647') 
AS DC ON DC.Factura= DG.InvoiceNumber 
left join (
select ac.InvoiceNumber, sum(rp.Value) as ValorReclasificación
from Portfolio.PortfolioReclassification as rp WITH (nolock)
inner join Portfolio.AccountReceivable as ac WITH (nolock) on ac.id=rp.AccountReceivableId
where rp.Status=2
group by ac.InvoiceNumber) as recla on recla.InvoiceNumber=dg.InvoiceNumber

left join (select InvoiceNumber, sum(ValuePayments) as PagoParcial
from Glosas.PartialPaymentsC as c WITH (nolock) 
inner join  Glosas.PartialPaymentsD as D WITH (nolock)  on D.PartialPaymentsCId=c.Id
group by InvoiceNumber) as pp on pp.InvoiceNumber=dg.InvoiceNumber

     WHERE --DG.Invoicenumber='NEV1190843' and 
	 (GC.DocumentDate >= '2021-01-01 00:00:00')-- and CAR.Balance>0
