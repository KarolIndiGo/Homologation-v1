-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_AEF_Seguimiento_Pagos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

/*
select * from Common.ThirdParty where Nit='900976977'
select * from Common.Person where Id=29748
select * from Common.Email where IdPerson=29748
*/
CREATE VIEW [ViewInternal].[V_AEF_Seguimiento_Pagos]
AS
Select 
c.Code,
t.Nit as 'Nit Tercero',
t.Name as 'Tercero',
CASE c.VoucherClass	WHEN 1 THEN 'Pago'WHEN 2 THEN 'Reembolso' WHEN 3 THEN 'Traslado' END AS 'Tipo de Comprobante',
CASE c.ExpenseType	WHEN 1 THEN 'Afecta Banco'WHEN 2 THEN 'Afecta Caja Menor' WHEN 3 THEN 'Afecta Caja Mayor' WHEN 4 THEN 'Producto Bancario' END AS 'Tipo de Egreso',
c.Detail,
CASE c.EmailSent WHEN 0 THEN 'No Enviado' WHEN 1 THEN 'Enviado' END AS 'Envio Email',
CASE 
	WHEN c.SchedulePaymentId IS NULL THEN 'No tiene'
	ELSE 'Tiene'
END 'Dispersion de Fondos',
e.Email as 'Email Tercero',
CASE e.Type WHEN 1 THEN 'Notificaciones varias' WHEN 2 THEN 'Notificación Facturación Electrónica' END AS 'Tipo de Email',
c.DocumentDate as 'Fecha Documento',
c.Value,
c.PaymentMethod, --Método de pago. Cheque = 1, Nota débito = 2
c.TransactionDate, --Fecha la consignación
c.IdPaymentOrder, --Id de la orden de pago
c.RTEValue as 'Valor de la retencion',
c.IVAValue as 'Valor del IVA',
c.ICAValue as 'Valor del ICA',
c.OtherValue as 'Otros valores',
c.BankAccountNumber as 'Número de la cuenta que consigna',
c.BankName as 'Nombre del banco',
u.UnitName as 'Unidad Operativa',
CASE c.Status WHEN 1 THEN 'registrado'WHEN 2 THEN 'confirmado' WHEN 3 THEN 'anulado' WHEN 4 THEN 'Reversado' END AS 'Estado',
(select p.Identification + ' - '+ p.Fullname from [Security].[Person] as p where p.Identification=c.CreationUser) as 'Usuario Crea',
c.CreationDate as 'Fecha Creación', --Fecha de Creación
(select p.Identification + ' - '+ p.Fullname from [Security].[Person] as p where p.Identification=c.ModificationUser) as 'Usuario Modifica',
c.ModificationDate as 'Fecha Modificación', --Fecha Modificación
(select p.Identification + ' - '+ p.Fullname from [Security].[Person] as p where p.Identification=c.ConfirmationUser) as 'Usuario Confirma',
c.ConfirmationDate as 'Fecha Confirmación', --Fecha Confirmación
(select p.Identification + ' - '+ p.Fullname from [Security].[Person] as p where p.Identification=c.AnnulmentUser) as 'Usuario Anula',
c.AnnulmentDate as 'Fecha Anulación', --Fecha Anulación
(select p.Identification + ' - '+ p.Fullname from [Security].[Person] as p where p.Identification=c.ReversedUser) as 'Usuario Reversa',
c.ReversedDate --Especifica la fecha en que se reverso el documento
from Treasury.VoucherTransaction as c
inner join Common.ThirdParty as t on t.Id=c.IdThirdParty
left join Common.Email as e on e.IdPerson=t.PersonId
inner join Common.OperatingUnit as u on u.Id=c.IdUnitOperative
left join Treasury.EntityBankAccounts as b on b.Id=c.IdEntityBankAccount
--where t.Nit='900976977'
--order by c.DocumentDate desc
--Select * from Treasury.VoucherTransactionDetails
