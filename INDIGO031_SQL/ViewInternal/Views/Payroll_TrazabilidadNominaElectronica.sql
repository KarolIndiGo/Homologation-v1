-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Payroll_TrazabilidadNominaElectronica
-- Extracted by Fabric SQL Extractor SPN v3.9.0





create view [ViewInternal].[Payroll_TrazabilidadNominaElectronica] as
select e.Id as IdDocumento, CONCAT(e.Year, '-', RIGHT(CONCAT('00', e.Month), 2)) as Periodo, e.Consecutive as Consecutivo, e.DocumentNumber as [Numero Documento], TP.Nit+' - '+ TP.Name AS Empleado, 
case e.Status when 0 then 'Erronea'
			  when 1 then 'Registrada'
			  when 2 then 'Enviada'
			  when 3 then 'Validada'
			  when 4 then 'Invalida'
			  when 66 then 'Reenvío Obligatorio'
			  when 88 then 'Pendiente'
			  when 222 then 'Procesando' end as [Estado Registro DIAN],  e.CreationDate as [Fecha Crea Registro], e.ShippingDate as [Fecha Envio DIAN] , e. ValidationDate as [Fecha Validación DIAN],
			  e.FilePath as [RutaArchivo] ,  e.Retry as [Intentos Envio], e.CUNE as CUNE, 
case d.Destination when 0 then 'Validacion previa a la generacion del XML' 
when 1 then 'Envio Documento Electronico a la DIAN' 
when 2 then 'Validacion del Documento Enviado' end as [Destino Envio], d.CreationDate as [Fecha Registro e Intento Envio], 


case d.status when 0 then 'Fallido'
			  when 1 then 'Exitoso' end as [Estado Envio],  d.Comments as Comentarios, d.ResponseData as [Respuesta Recibida], 
			  
			  CASE 
        WHEN e.Retry > 1 AND EXISTS (SELECT 1 FROM  Payroll.ElectronicPayrollDetail d2 WHERE d2.ElectronicPayrollId = e.id AND d2.Status = 1) THEN 'Exitoso'
        WHEN e.Retry > 1 AND NOT EXISTS (SELECT 1 FROM  Payroll.ElectronicPayrollDetail d2 WHERE d2.ElectronicPayrollId = e.id AND d2.Status = 1) THEN 'Fallido'
        WHEN e.Retry = 1 AND d.Status = 1 THEN 'Exitoso'
        WHEN e.Retry = 1 AND d.Status = 0 THEN 'Fallido' end as  [Estado Envio Real], e.[year] as Año, e.[Month] as NroMes

from Payroll.ElectronicPayroll as e
inner join Payroll.ElectronicPayrollDetail AS D ON D.ElectronicPayrollId=E.Id
--inner join Payroll.Employee AS EM ON EM.Id=E.EmployeePartyId
INNER JOIN Common.ThirdParty AS TP ON TP.Id=E.EmployeePartyId
where e.DocumentType='1' and CONCAT(e.Year, '-', RIGHT(CONCAT('00', e.Month), 2))>='2021-09'
