-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_VISTARADICADOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VistaRadicados
AS 

select 
rc.RadicatedConsecutive as NumeroRadicado
,c.Nit as NitCliente
,c.Name as Cliente
,rc.RadicatedDate as FechaRadicado
,rc.ConfirmDate AS FechConfirmacion
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
from [INDIGO035].[Portfolio].[RadicateInvoiceC] rc
inner join [INDIGO035].[Portfolio].[RadicateInvoiceD] rd on rc.Id = rd.RadicateInvoiceCId
inner join [INDIGO035].[Common].[Customer] c on c.Id = rc.CustomerId
where rd.State <> 4
