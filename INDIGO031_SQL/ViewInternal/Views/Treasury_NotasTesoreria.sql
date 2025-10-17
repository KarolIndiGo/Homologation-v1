-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Treasury_NotasTesoreria
-- Extracted by Fabric SQL Extractor SPN v3.9.0


create view ViewInternal.Treasury_NotasTesoreria as

SELECT o.UnitName as UnidadOperativa, n.CODE as Código, 
case NoteType when 1 then 'Nota a Cuenta Bancaria'
			  when 2 then 'Nota a Caja'
			  when 3 then 'Anulación de Comprobante de Egreso'
			  when 4 then 'Anulación de Recibo de caja'
			  when 5 then 'Anulación de Consignacion'
			  when 6 then 'Reversión cruce CxC vs CxP'
			  when 7 then 'Devolucion de Recibo de Caja' end as TipoNota, 
 c.code as [Recibo de Caja], d.code as [Comprobante Egreso], Description as Descripción, n.Value as Valor, 
case n.Status when 1 then 'Registrado' when 2 then 'Confirmado' when 3 then 'Anulado' end 'Estado Documento'
FROM INDIGO031.Treasury.TreasuryNote as n
inner join INDIGO031.Common.OperatingUnit as o on o.id=n.OperatingUnitId
left join INDIGO031.Treasury.CashRegisters as c on c.id=n.CashRegisterId
left join INDIGO031.Treasury.VoucherTransaction as d on d.id=n.VoucherTransactionId
