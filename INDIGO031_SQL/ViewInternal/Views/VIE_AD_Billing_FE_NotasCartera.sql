-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Billing_FE_NotasCartera
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Billing_FE_NotasCartera] as




SELECT	DISTINCT 
           TOP (100) PERCENT U.UnitName AS [Unidad Operativa],  pn.code as NotaCartera, pn.NoteDate AS [Fecha Nota],  C.Nit, C.Name AS Cliente,
		   CASE	pn.Nature when 1 then 'Debito' when 2 then 'Credito' end as Naturaleza,   pn.Observations as ObservaciónCartera,  pnc.name as ConceptoNota, ma.Number+'-'+ma.name as CuentaContable    ,bn.Observations as ObservacionesFactElectronica,
		  bnd.InvoiceNumber as Factura, bnd.DocumentDate as FechaFactura, bnd.AdjusmentValue as ValorAjuste, bn.Code as Consecutivo   ,  case bnd.ConceptId when 1 then 'Devolución o no aceptación de partes del servicio' when 2 then 'Anulación de factura electrónica' when 3 
		  then 'Rebaja total aplicada' when 4 then 'Descuento total aplicado' when 5 then 'Rescisión: nulidad por falta de requisitos' when 6 then 'Otros' end as Concepto_FactElectronica,
			  CASE ed.Status 
			 WHEN 0 THEN 'Invalida' 
			 WHEN 1 THEN 'Registrada' 
			 WHEN 2 THEN 'Enviada y Recibida' 
			 WHEN 3 THEN 'Factura Validada' 
			 WHEN 4 THEN 'Validacion Fallida' 
			 WHEN 99 THEN 'Pendiente - Proc. Validacion' 
			 WHEN 88 THEN 'Pendiente - Proc. Envio' 
			 when 77 then 'No Procesa - Dif. Version'  END AS [Estado Nota], ed.FilePath AS Ruta, ed.ShippingDate AS FechaEnvio, 
         CASE edd.status WHEN 0 THEN 'Fallido' WHEN 1 THEN 'Exitoso' ELSE '' END AS [Estado Envio], edd.comentarios AS Comentarios, CASE edd .destination WHEN 0 THEN 'Validación Previa a generacion XML' WHEN 1 THEN 'Envio Documento Electronico ' WHEN 2 THEN 'Validación Documento XML' END AS Destino--,
FROM			Portfolio.PortfolioNote	pn
LEFT OUTER JOIN	Billing.BillingNote	bn	 ON	bn.EntityId=pn.Id
LEFT OUTER JOIN Billing.BillingNoteDetail	bnd	 on	bnd.BillingNoteId=bn.Id	
LEFT OUTER JOIN Billing.ElectronicDocument	ed	 on	ed.EntityId=bn.Id	and ed.EntityName='BillingNote'
LEFT OUTER JOIN (select a.ElectronicDocumentID, A.Comments AS Comentarios, status, a.Id, a.destination, a.creationdate
		from Billing.ElectronicDocumentDetail  AS A inner join
			(
				select  ElectronicDocumentID, max(Id) as max_Id
					from Billing.ElectronicDocumentDetail  AS T
				group by  T.ElectronicDocumentID ) as R on  R.ElectronicDocumentID= A.ElectronicDocumentID and A.id= R.max_Id) AS edd ON edd.ElectronicDocumentID = ed.Id 
LEFT OUTER JOIN Common.OperatingUnit AS U  ON U.Id = pn.OperatingUnitId 
LEFT OUTER JOIN	Common.Customer C ON C.Id=PN.CustomerId
--LEFT OUTER JOIN Common.ThirdParty AS C  ON C.Id = bn.CustomerPartyId
LEFT OUTER JOIN	Portfolio.PortfolioNoteDetail	pnd	on	pnd.PortfolioNoteId=pn.Id
LEFT OUTER JOIN	Portfolio.PortfolioNoteConcept pnc  on pnc.Id=pnd.PortfolioNoteConceptId
LEFT OUTER JOIN	GeneralLedger.MainAccounts ma on ma.Id=pnd.MainAccountId
WHERE	pn.NoteDate>='01-01-2020'

union all

SELECT	DISTINCT 
           TOP (100) PERCENT U.UnitName AS [Unidad Operativa],  '' as NotaCartera, bn.NoteDate AS [Fecha Nota],  C.Nit, C.Name AS Cliente,
		   CASE	Bn.Nature when 1 then 'Debito' when 2 then 'Credito' end as Naturaleza,   '' as ObservaciónCartera,  '' as ConceptoNota, '' as CuentaContable    ,bn.Observations as ObservacionesFactElectronica,
		  bnd.InvoiceNumber as Factura, bnd.DocumentDate as FechaFactura, bnd.AdjusmentValue as ValorAjuste, bn.Code as Consecutivo   ,
		  case bnd.ConceptId when 1 then 'Devolución o no aceptación de partes del servicio' when 2 then 'Anulación de factura electrónica' when 3 
		  then 'Rebaja total aplicada' when 4 then 'Descuento total aplicado' when 5 then 'Rescisión: nulidad por falta de requisitos' when 6 then 'Otros' end as Concepto_FactElectronica,
			CASE ed.Status 
			 WHEN 0 THEN 'Invalida' 
			 WHEN 1 THEN 'Registrada' 
			 WHEN 2 THEN 'Enviada y Recibida' 
			 WHEN 3 THEN 'Factura Validada' 
			 WHEN 4 THEN 'Validacion Fallida' 
			 WHEN 99 THEN 'Pendiente - Proc. Validacion' 
			 WHEN 88 THEN 'Pendiente - Proc. Envio' 
			 when 77 then 'No Procesa - Dif. Version'  END AS [Estado Nota], ed.FilePath AS Ruta, ed.ShippingDate AS FechaEnvio, 
         CASE edd.status WHEN 0 THEN 'Fallido' WHEN 1 THEN 'Exitoso' ELSE '' END AS [Estado Envio], edd.comentarios AS Comentarios, CASE edd .destination WHEN 0 THEN 'Validación Previa a generacion XML' WHEN 1 THEN 'Envio Documento Electronico ' WHEN 2 THEN 'Validación Documento XML' END AS Destino--,
FROM			Billing.BillingNote	bn	 
LEFT OUTER JOIN Billing.BillingNoteDetail	bnd	 on	bnd.BillingNoteId=bn.Id	
LEFT OUTER JOIN Billing.ElectronicDocument	ed	 on	ed.EntityId=bn.Id	and ed.EntityName='BillingNote'
LEFT OUTER JOIN (select a.ElectronicDocumentID, A.Comments AS Comentarios, status, a.Id, a.destination, a.creationdate
		from Billing.ElectronicDocumentDetail  AS A inner join
			(
				select  ElectronicDocumentID, max(Id) as max_Id
					from Billing.ElectronicDocumentDetail  AS T
				group by  T.ElectronicDocumentID ) as R on  R.ElectronicDocumentID= A.ElectronicDocumentID and A.id= R.max_Id) AS edd ON edd.ElectronicDocumentID = ed.Id 
LEFT OUTER JOIN Common.OperatingUnit AS U  ON U.Id = Bn.OperatingUnitId 
--LEFT OUTER JOIN	Common.Customer C ON C.Id=BN.CustomerpartyId
LEFT OUTER JOIN Common.ThirdParty AS C  ON C.Id = bn.CustomerPartyId
--LEFT OUTER JOIN	Portfolio.PortfolioNoteDetail	pnd	on	pnd.PortfolioNoteId=pn.Id
--LEFT OUTER JOIN	Portfolio.PortfolioNoteConcept pnc  on pnc.Id=pnd.PortfolioNoteConceptId
--LEFT OUTER JOIN	GeneralLedger.MainAccounts ma on ma.Id=pnd.MainAccountId
WHERE	Bn.NoteDate>='01-01-2020' and bn.EntityName='Invoice'
