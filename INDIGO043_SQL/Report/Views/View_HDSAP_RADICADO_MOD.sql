-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_RADICADO_MOD
-- Extracted by Fabric SQL Extractor SPN v3.9.0







CREATE VIEW [Report].[View_HDSAP_RADICADO_MOD]
AS
SELECT      DISTINCT  rc.RadicatedConsecutive AS Radicado, tp.Nit, tp.Name AS Entidad, ar.InvoiceNumber AS Factura, CASE RD.Devolution WHEN 1 THEN 'DEVOLUCION' WHEN 0 THEN 'FACTURADO POR PRIMERA VEZ' END ESTADOFACTURA,
                         CASE paci.IPTIPODOC WHEN '1' THEN '1' WHEN '2' THEN '4' WHEN '3' THEN '3' WHEN '4' THEN '7' WHEN '5' THEN '5' WHEN '6' THEN '6' WHEN '7' THEN '7' WHEN '8' THEN '8' WHEN '9' THEN '9' WHEN '10' THEN '10' WHEN
                          '13' THEN '11' ELSE '' END AS TipIdPac, paci.IPTIPODOC AS T_Id, 
                         CASE paci.IPTIPODOC WHEN '1' THEN 'Cedula' WHEN '2' THEN 'Cédula de Extranjería' WHEN '3' THEN 'Tarjeta de Identidad' WHEN '4' THEN 'Registro Civil' WHEN '5' THEN 'Pasaporte' WHEN '6' THEN 'Adulto Sin Identificación'
                          WHEN '7' THEN 'Menor Sin Identificación' ELSE '' END AS Expr1, rd.PatientCode AS IdentificacionPaciente, rd.PatientName AS NombrePaciente, rd.IngressDate AS FechaIngreso, CAST(rd.InvoiceDate AS date) AS FechaFactura, 
                         rc.RadicatedDate AS Fecha, rc.ConfirmDateSystem AS FechaRadicado, ISNULL(FUR.NUMSOA, '') AS NumeroPoliza, CAST(rd.InvoiceValueEntity + rd.InvoiceValuePacient AS decimal(18, 0)) AS ValorBrutoFactura, 
                         CAST(rd.InvoiceValuePacient AS decimal(18, 0)) AS ValorCuotaRecuperacion, CAST(ISNULL(rd.CreditNoteValue, 0) AS decimal(18, 0)) AS ValorNotaCredito, CAST(ISNULL(rd.DebitNoteValue, 0) AS decimal(18, 0)) 
                         AS ValorNotaDebito, CAST(rd.BalanceInvoice AS decimal(18, 0)) AS ValorNetoFactura, ISNULL(notas.Value, 0) AS TotalNotas, ISNULL(pagos.Valor, 0) AS TotalPagos, ar.Balance AS SaldoActual, 
                         rc.DocumentDate AS FechaDocumento, rc.CreationUser AS usuarioCrea, 
                         CASE WHEN cg.EntityType = '1' THEN 'EPS Contributivo' WHEN cg.EntityType = '2' THEN 'EPS Subsidiado' WHEN cg.EntityType = '3' THEN 'ET Vinculados Municipios' WHEN cg.EntityType = '4' THEN 'ET Vinculados Departamentos'
                          WHEN cg.EntityType = '5' THEN 'ARL Riesgos Laborales' WHEN cg.EntityType = '6' THEN 'MP Medicina Prepagada' WHEN cg.EntityType = '7' THEN 'IPS Privada' WHEN cg.EntityType = '8' THEN 'IPS Publica' WHEN cg.EntityType
                          = '9' THEN 'Regimen Especial' WHEN cg.EntityType = '10' THEN 'Accidentes de transito' WHEN cg.EntityType = '11' THEN 'Fosyga' WHEN cg.EntityType = '12' THEN 'Otros' WHEN cg.EntityType = '13' THEN 'Aseguradoras' WHEN
                          cg.EntityType = '99' THEN 'Particulares' END AS Regimen, cg.Code + ' - ' + cg.Name AS GrupoAtencion, cg.Name AS NombreGupoAtencion, ic.Code + ' - ' + ic.Name AS Categoria, vsf.Fullname, rc.State, 
                         rc.CreationDate AS FecCreacion, EA.Name AS ENTIDADADMIN, CASE rc.state WHEN 1 THEN 'Sin Confirmar' WHEN 2 THEN 'Confirmado' END AS ESTADORADICADO, i.OutputDate FechaEgreso,(datediff (year,PACI.IPFECNACI, getdate ())) EDAD
FROM            Portfolio.AccountReceivable AS ar INNER JOIN
                         Common.ThirdParty AS tp ON ar.ThirdPartyId = tp.Id INNER JOIN
                         Portfolio.RadicateInvoiceD AS rd ON rd.InvoiceNumber = ar.InvoiceNumber INNER JOIN
                         Portfolio.RadicateInvoiceC AS rc ON rc.Id = rd.RadicateInvoiceCId LEFT OUTER JOIN
                             (SELECT        ar.InvoiceNumber, SUM(ptd.Value) AS Valor
                               FROM            Portfolio.PortfolioTransfer AS pt INNER JOIN
                                                         Portfolio.PortfolioTransferDetail AS ptd ON pt.Id = ptd.PortfolioTrasferId INNER JOIN
                                                         Portfolio.AccountReceivable AS ar ON ar.Id = ptd.AccountReceivableId
                               WHERE        (pt.Status = 2) AND (ar.AccountReceivableType = 2)
                               GROUP BY ar.InvoiceNumber) AS pagos ON pagos.InvoiceNumber = ar.InvoiceNumber LEFT OUTER JOIN
                             (SELECT        ar.InvoiceNumber, SUM(pnd.AdjusmentValue) AS Value
                               FROM            Portfolio.PortfolioNote AS pn INNER JOIN
                                                         Portfolio.PortfolioNoteAccountReceivableAdvance AS pnd ON pnd.PortfolioNoteId = pn.Id INNER JOIN
                                                         Portfolio.AccountReceivable AS ar ON ar.Id = pnd.AccountReceivableId
                               WHERE        (ar.AccountReceivableType = 2)
                               GROUP BY ar.InvoiceNumber) AS notas ON notas.InvoiceNumber = ar.InvoiceNumber LEFT OUTER JOIN
                         dbo.INPACIENT AS paci ON paci.IPCODPACI = rd.PatientCode LEFT OUTER JOIN						
                         Billing.Invoice AS i ON i.InvoiceNumber = ar.InvoiceNumber LEFT OUTER JOIN
						 dbo.ADFURIPSU AS FUR ON FUR.IdInvoice = I.ID LEFT OUTER JOIN
                         Contract.CareGroup AS cg ON cg.Id = i.CareGroupId LEFT OUTER JOIN
                         Billing.InvoiceCategories AS ic ON ic.Id = i.InvoiceCategoryId LEFT OUTER JOIN
                         Security.[User] AS vsu ON vsu.UserCode = rc.CreationUser LEFT OUTER JOIN
                         Security.Person AS vsf ON vsf.Id = vsu.IdPerson LEFT OUTER JOIN
                         Contract.HealthAdministrator AS EA ON i.HealthAdministratorId = EA.Id
WHERE        (ar.AccountReceivableType = 2) AND (NOT (rc.State = 4))-- AND AR.InvoiceNumber = 'HSPE680126'


