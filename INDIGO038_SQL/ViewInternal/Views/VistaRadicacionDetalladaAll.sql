-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VistaRadicacionDetalladaAll
-- Extracted by Fabric SQL Extractor SPN v3.9.0



/*WHERE        (rd.State = '2') AND (rc.State = '2')*/
CREATE VIEW [ViewInternal].[VistaRadicacionDetalladaAll]
AS
SELECT        rc.RadicatedConsecutive AS Radicado, c.Nit AS NitCliente, c.Name AS Cliente, rc.DocumentDate AS FechaDocumento, CAST(rc.ConfirmDateSystem AS date) AS FechaConfirmacion, CAST(rc.ConfirmDate AS date) 
                         AS FechaRadicado, rd.InvoiceNumber AS NumeroFactura, CASE rd.Devolution WHEN 1 THEN 'Si' ELSE 'No' END AS Devolucion, 
                         CASE rd.Devolution WHEN 1 THEN gdrc.CreationUser + ' - ' + p.fullname ELSE '' END AS UsuarioDevolucion, ISNULL(ic.Code + ' - ' + ic.Name, '') AS Categoria, rd.InvoiceDate AS FechaFactura, 
                         rd.IngressNumber AS Ingreso, rd.InvoiceValueEntity AS ValorEntidad, rd.InvoiceValuePacient AS ValorPaciente, 
                         CASE MA.Number WHEN '14090103' THEN 'Contributivo' WHEN '14090304' THEN 'Subsidiado' WHEN '14090401' THEN 'Servicio IPS Privada' WHEN '14090501' THEN 'Medicina Prepagada' WHEN '14090601' THEN
                          'Compañias Aseguradoras' WHEN '14090701' THEN 'Particulares' WHEN '14090901' THEN 'Servicio IPS Publicas' WHEN '14091004' THEN 'Regimen Especial' WHEN '14091102' THEN 'Vinculados - Departamentos'
                          WHEN '14091103' THEN 'Vinculados Municipios' WHEN '14091201' THEN 'Arl Riesgos Profesionales' WHEN '14091403' THEN 'Accidentes de Transito' WHEN '14090201' THEN 'Otras Cuentas X Cobrar' END AS
                          Regimen, rd.State AS EstadoFacRadicada
FROM            Portfolio.RadicateInvoiceC AS rc WITH (nolock) INNER JOIN
                         Portfolio.RadicateInvoiceD AS rd WITH (nolock) ON rc.Id = rd.RadicateInvoiceCId INNER JOIN
                         Common.Customer AS c WITH (nolock) ON c.Id = rc.CustomerId INNER JOIN
                         Portfolio.AccountReceivable AS ar WITH (nolock) ON ar.InvoiceNumber = rd.InvoiceNumber AND ar.AccountReceivableType = 2 INNER JOIN
                         GeneralLedger.MainAccounts AS MA WITH (nolock) ON MA.Id = ar.AccountWithoutRadicateId LEFT OUTER JOIN
                         Billing.Invoice AS i WITH (nolock) ON i.InvoiceNumber = ar.InvoiceNumber LEFT OUTER JOIN
                         Billing.InvoiceCategories AS ic WITH (nolock) ON ic.Id = i.InvoiceCategoryId LEFT OUTER JOIN
                             (SELECT        MAX(gdrc.Id) AS id, gdrd.InvoiceNumber
                               FROM            Glosas.GlosaDevolutionsReceptionD AS gdrd WITH (nolock) INNER JOIN
                                                         Glosas.GlosaDevolutionsReceptionC AS gdrc WITH (nolock) ON gdrc.Id = gdrd.GlosaDevolutionsReceptionCId
                               GROUP BY gdrd.InvoiceNumber) AS dev ON ar.InvoiceNumber = dev.InvoiceNumber LEFT OUTER JOIN
                         Glosas.GlosaDevolutionsReceptionC AS gdrc WITH (nolock) ON dev.id = gdrc.Id LEFT OUTER JOIN
                         Security.[User] AS u ON gdrc.CreationUser = u.UserCode LEFT OUTER JOIN
                         Security.Person AS p ON u.IdPerson = p.Id

