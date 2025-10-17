-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VistaRadicacionDetallada2
-- Extracted by Fabric SQL Extractor SPN v3.9.0


/*WHERE        (rd.State = 2) AND (rc.State = 2)*/
CREATE VIEW [ViewInternal].[VistaRadicacionDetallada2]
AS
SELECT        rc.RadicatedConsecutive AS Radicado, c.Nit AS NitCliente, c.Name AS Cliente, rc.DocumentDate AS FechaDocumento, CAST(rc.ConfirmDateSystem AS date) 
                         AS FechaConfirmacion, CAST(rc.ConfirmDate AS date) AS FechaRadicado, rd.InvoiceNumber AS NumeroFactura, 
                         CASE rd.Devolution WHEN 1 THEN 'SI' ELSE 'NO' END AS Devolucion, ic.Code + ' - ' + ic.Name AS Categoria, rd.InvoiceDate AS FechaFactura, 
                         rd.IngressNumber AS Ingreso, rd.InvoiceValueEntity AS ValorEntidad, rd.InvoiceValuePacient AS ValorPaciente, 
                         CASE MA.Number WHEN '14090103' THEN 'Contributivo' WHEN '14090304' THEN 'Subsidiado' WHEN '14090401' THEN 'Servicio IPS Privada' WHEN '14090501' THEN
                          'Medicina Prepagada' WHEN '14090601' THEN 'Compañias Aseguradoras' WHEN '14090701' THEN 'Particulares' WHEN '14090901' THEN 'Servicio IPS Publicas' WHEN
                          '14091004' THEN 'Regimen Especial' WHEN '14091102' THEN 'Vinculados - Departamentos' WHEN '14091103' THEN 'Vinculados Municipios' WHEN '14091201' THEN
                          'Arl Riesgos Profesionales' WHEN '14091403' THEN 'Accidentes de Transito' WHEN '14090201' THEN 'Otras Cuentas X Cobrar' END AS Regimen, 
                         ar.PortfolioStatus AS EstadoCartera, rd.State AS EstadoRadFactura, rc.State AS EstadoRad, PE.Fullname AS UsuarioCrea
FROM            Billing.InvoiceCategories AS ic RIGHT OUTER JOIN
                         Billing.Invoice AS i RIGHT OUTER JOIN
                         Security.Person AS PE RIGHT OUTER JOIN
                         Portfolio.RadicateInvoiceC AS rc INNER JOIN
                         Portfolio.RadicateInvoiceD AS rd ON rc.Id = rd.RadicateInvoiceCId INNER JOIN
                         Common.Customer AS c ON c.Id = rc.CustomerId INNER JOIN
                         Portfolio.AccountReceivable AS ar ON ar.InvoiceNumber = rd.InvoiceNumber AND ar.AccountReceivableType = 2 INNER JOIN
                         GeneralLedger.MainAccounts AS MA ON MA.Id = ar.AccountWithoutRadicateId INNER JOIN
                         Security.[User] AS US ON rc.CreationUser = US.UserCode ON PE.Id = US.IdPerson ON i.InvoiceNumber = ar.InvoiceNumber ON 
                         ic.Id = i.InvoiceCategoryId
