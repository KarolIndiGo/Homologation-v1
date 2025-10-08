-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VISTARADICACIONDETALLADA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VistaRadicacionDetallada
AS 

SELECT        rc.RadicatedConsecutive AS Radicado, c.Nit AS NitCliente, c.Name AS Cliente, rc.DocumentDate AS FechaDocumento, CAST(rc.ConfirmDateSystem AS date) AS FechaConfirmacion, CAST(rc.ConfirmDate AS date) 
                         AS FechaRadicado, rd.InvoiceNumber AS NumeroFactura, CASE rd.Devolution WHEN 1 THEN 'Si' ELSE 'No' END AS Devolucion, 
                         CASE rd.Devolution WHEN 1 THEN gdrc.CreationUser + ' - ' + p.Fullname ELSE '' END AS UsuarioDevolucion, ISNULL(ic.Code + ' - ' + ic.Name, '') AS Categoria, rd.InvoiceDate AS FechaFactura, 
                         rd.IngressNumber AS Ingreso, rd.InvoiceValueEntity AS ValorEntidad, rd.InvoiceValuePacient AS ValorPaciente, 
                         CASE MA.Number WHEN '13190101' THEN 'Contributivo' WHEN '13190301' THEN 'Subsidiado' WHEN '13190801' THEN 'Servicio IPS Privada' WHEN '13190501' THEN 'Medicina Prepagada' WHEN '13191201' THEN
                          'Compañias Aseguradoras' WHEN '13191601' THEN 'Particulares' WHEN '13191001' THEN 'Servicio IPS Publicas' WHEN '13191401' THEN 'Regimen Especial' WHEN '13192101' THEN 'Vinculados - Departamentos'
                          WHEN '13192102' THEN 'Vinculados Municipios' WHEN '13192301' THEN 'Arl Riesgos Profesionales' WHEN '13191701' THEN 'Accidentes de Transito' WHEN '13199002' THEN 'Otras Cuentas X Cobrar' END AS
                          Regimen, rc.State AS EstadoFacRadicada
FROM            [INDIGO035].[Portfolio].[RadicateInvoiceC] AS rc  INNER JOIN
                         [INDIGO035].[Portfolio].[RadicateInvoiceD] AS rd  ON rc.Id = rd.RadicateInvoiceCId INNER JOIN
                         [INDIGO035].[Common].[Customer] AS c  ON c.Id = rc.CustomerId INNER JOIN
                         [INDIGO035].[Portfolio].[AccountReceivable] AS ar  ON ar.InvoiceNumber = rd.InvoiceNumber AND ar.AccountReceivableType = 2 INNER JOIN
                         [INDIGO035].[GeneralLedger].[MainAccounts] AS MA  ON MA.Id = ar.AccountWithoutRadicateId LEFT OUTER JOIN
                         [INDIGO035].[Billing].[Invoice] AS i  ON i.InvoiceNumber = ar.InvoiceNumber LEFT OUTER JOIN
                         [INDIGO035].[Billing].[InvoiceCategories] AS ic  ON ic.Id = i.InvoiceCategoryId LEFT OUTER JOIN
                             (SELECT        MAX(gdrc.Id) AS id, gdrd.InvoiceNumber
                               FROM            [INDIGO035].[Glosas].[GlosaDevolutionsReceptionD] AS gdrd  INNER JOIN
                                                         [INDIGO035].[Glosas].[GlosaDevolutionsReceptionC] AS gdrc  ON gdrc.Id = gdrd.GlosaDevolutionsReceptionCId
                               WHERE        (gdrd.State = 2) AND (gdrc.State <> 4)
                               GROUP BY gdrd.InvoiceNumber) AS dev ON ar.InvoiceNumber = dev.InvoiceNumber LEFT OUTER JOIN
                         [INDIGO035].[Glosas].[GlosaDevolutionsReceptionC] AS gdrc  ON dev.id = gdrc.Id LEFT OUTER JOIN
                         [INDIGO035].[Security].[UserInt] AS u ON gdrc.CreationUser = u.UserCode LEFT OUTER JOIN
                         [INDIGO035].[Security].[PersonInt] AS p ON u.IdPerson = p.Id
WHERE        (rd.State = '2') AND (rc.State = '2')
