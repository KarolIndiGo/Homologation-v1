-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VistaRadicados
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE view [ViewInternal].[VistaRadicados]
as (
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
from Portfolio.RadicateInvoiceC rc
inner join Portfolio.RadicateInvoiceD rd on rc.Id = rd.RadicateInvoiceCId
inner join Common.Customer c on c.Id = rc.CustomerId
where rd.State <> 4
)





