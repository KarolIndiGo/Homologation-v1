-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_CXC_NotasCartera_FacturacionElectronica
-- Extracted by Fabric SQL Extractor SPN v3.9.0

--/****** Object:  View [ViewInternal].[FQ45_V_CXC_NotasCartera_FacturacionElectronica]    Script Date: 16/06/2025 8:14:29 a. m. ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


CREATE view [ViewInternal].[FQ45_V_CXC_NotasCartera_FacturacionElectronica] as

SELECT DISTINCT 
    NC.Id AS IdNota,
    NC.Code AS Nota,
    NC.NoteDate AS Fecha,
    NC.Observations AS Observaciones,
    CASE NC.Nature 
        WHEN '1' THEN 'Debito' 
        WHEN '2' THEN 'Credito' 
    END AS Tipo,
    ter.Nit AS Nit,
    ter.name AS Tercero,
	cli.Nit AS NitCliente,
    cli.name AS Cliente,
	
    CASE
        WHEN nc.Nature = 1 AND fa.ConceptId = 1 THEN 'Intereses'
        WHEN nc.Nature = 1 AND fa.ConceptId = 2 THEN 'Gastos por cobrar'
        WHEN nc.Nature = 1 AND fa.ConceptId = 3 THEN 'Cambio del valor'
        WHEN nc.Nature = 2 AND fa.ConceptId = 1 THEN 'Devolución o no aceptación de partes del servicio'
        WHEN nc.Nature = 2 AND fa.ConceptId = 2 THEN 'Anulación de factura electrónica'
        WHEN nc.Nature = 2 AND fa.ConceptId = 3 THEN 'Rebaja total aplicada'
        WHEN nc.Nature = 2 AND fa.ConceptId = 4 THEN 'Descuento total aplicado'
        WHEN nc.Nature = 2 AND fa.ConceptId = 5 THEN 'Rescisión: nulidad por falta de requisitos'
        WHEN nc.Nature = 2 AND fa.ConceptId = 6 THEN 'Otros'
    END AS ConcetoCXC,
    SUM(fa.AdjusmentValue) AS ValorNota,
    e.ConsecutivoDian,
    ar.InvoiceNumber AS Factura,
    e.NaturalezaFE,
    [Estado Nota DIAN],
    [Estado Envio DIAN]
FROM portfolio.PortfolioNote AS nc
INNER JOIN portfolio.PortfolioNoteAccountReceivableAdvance AS fa 
    ON fa.PortfolioNoteId = nc.Id
INNER JOIN Portfolio.AccountReceivable AS ar 
    ON ar.Id = fa.AccountReceivableId
LEFT JOIN Common.ThirdParty AS ter 
    ON ter.Id = nc.CustomerId
LEFT JOIN Common.Customer AS cli 
    ON cli.Id = nc.CustomerId
LEFT OUTER JOIN (
    SELECT
        DISTINCT(BN.CODE) AS ConsecutivoDian,
        InvoiceNumber,
        CASE BN.NATURE 
            WHEN 1 THEN 'Debito' 
            WHEN 2 THEN 'Credito' 
        END AS NaturalezaFE, 
        CASE ed.Status 
            WHEN 0 THEN 'Invalida' 
            WHEN 1 THEN 'Registrada' 
            WHEN 2 THEN 'Enviada y Recibida' 
            WHEN 3 THEN 'Validada' 
            WHEN 4 THEN 'Validacion Fallida' 
            WHEN 99 THEN 'Pendiente - Proc. Validacion' 
            WHEN 88 THEN 'Pendiente - Proc. Envio' 
            WHEN 77 THEN 'No Procesa - Dif. Version'  
        END AS [Estado Nota DIAN],  
        CASE A.status 
            WHEN 0 THEN 'Fallido' 
            WHEN 1 THEN 'Exitoso' 
            ELSE '' 
        END AS [Estado Envio DIAN],
        BN.EntityId
    FROM Billing.BillingNote BN
    INNER JOIN Billing.BillingNoteDetail BND 
        ON BND.BillingNoteId = BN.Id
    LEFT JOIN Common.Customer CLI 
        ON CLI.Id = BN.CustomerPartyId
    LEFT JOIN Common.ThirdParty ter 
        ON ter.Id = BN.CustomerPartyId
    INNER JOIN Billing.ElectronicDocument ED 
        ON ED.EntityId = BN.Id AND ED.EntityName = 'BillingNote'
    INNER JOIN (
        SELECT ElectronicDocumentID, MAX(Id) AS max_Id
        FROM Billing.ElectronicDocumentDetail
        GROUP BY ElectronicDocumentID
    ) AS R 
        ON R.ElectronicDocumentID = ED.Id
    LEFT OUTER JOIN Billing.ElectronicDocumentDetail AS A 
        ON A.Id = R.max_Id
    WHERE YEAR(BN.NoteDate) >= 2021
) AS e 
    ON e.EntityId = nc.Id
WHERE YEAR(nc.NoteDate) >= 2021
GROUP BY 
    NC.Id,  
    NC.Code, 
    NC.NoteDate, 
    NC.Observations,  
    NC.Nature, 
    fa.ConceptId, 
    e.ConsecutivoDian, 
    ar.InvoiceNumber, 
    e.NaturalezaFE, 
    [Estado Nota DIAN],  
    [Estado Envio DIAN], 
    ter.name,
    ter.nit,
    cli.name,
	cli.Nit


--select * from Billing.BillingNote

--select * from Common.Customer


