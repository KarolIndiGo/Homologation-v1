-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VISTARADICADOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view ViewInternal.VW_VISTARADICADOS
as 
select 
rc.RadicatedConsecutive as NumeroRadicado
,c.Nit as NitCliente
,c.Name as Cliente
,rc.RadicatedDate as FechaRadicado
,rc.DocumentDate as FechaDocumento
,case rc.State when 1 then 'Registrado' when 2 then 'Confirmado' end as Estado
,rc.RadicatedUser as UsuarioRadico
,rd.InvoiceNumber as Factura
,rd.InvoiceValueEntity as ValorEntidad
,rd.InvoiceValuePacient as ValorPaciente
,rd.IngressNumber as Ingreso
,rd.PatientCode as IdentificacionPaciente
,rd.PatientName as NombrePaciente
,rd.InvoiceDate as FechaFactura
,rc.Comment as ComentarioRadicado
from INDIGO031.Portfolio.RadicateInvoiceC rc
inner join INDIGO031.Portfolio.RadicateInvoiceD rd on rc.Id = rd.RadicateInvoiceCId
inner join INDIGO031.Common.Customer c on c.Id = rc.CustomerId
where rd.State <> 4