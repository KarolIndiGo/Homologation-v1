-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_PAYROLL_TRAZABILIDADNOMINAELECTRONICA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VW_PAYROLL_TRAZABILIDADNOMINAELECTRONICA] AS

SELECT 
    e.Id as IdDocumento, 
    CONCAT(e.Year, '-', RIGHT(CONCAT('00', e.Month), 2)) as Periodo, 
    e.Consecutive as Consecutivo, 
    e.DocumentNumber as [Numero Documento], 
    TP.Nit+' - '+ TP.Name AS Empleado, 
    CASE e.Status 
        WHEN 0 THEN 'Erronea'
        WHEN 1 THEN 'Registrada'
        WHEN 2 THEN 'Enviada'
        WHEN 3 THEN 'Validada'
        WHEN 4 THEN 'Invalida'
        WHEN 66 THEN 'Reenvío Obligatorio'
        WHEN 88 THEN 'Pendiente'
        WHEN 222 THEN 'Procesando' 
    END as [Estado Registro DIAN],  
    e.CreationDate as [Fecha Crea Registro], 
    e.ShippingDate as [Fecha Envio DIAN], 
    e.ValidationDate as [Fecha Validación DIAN],
    e.FilePath as [RutaArchivo],  
    e.Retry as [Intentos Envio], 
    e.CUNE as CUNE, 
    CASE d.Destination 
        WHEN 0 THEN 'Validacion previa a la generacion del XML' 
        WHEN 1 THEN 'Envio Documento Electronico a la DIAN' 
        WHEN 2 THEN 'Validacion del Documento Enviado' 
    END as [Destino Envio], 
    d.CreationDate as [Fecha Registro e Intento Envio], 
    CASE d.Status 
        WHEN 0 THEN 'Fallido'
        WHEN 1 THEN 'Exitoso' 
    END as [Estado Envio],  
    d.Comments as Comentarios, 
    d.ResponseData as [Respuesta Recibida], 
    CASE 
        WHEN e.Retry > 1 
             AND EXISTS (
                 SELECT 1 
                 FROM [INDIGO031].Payroll.ElectronicPayrollDetail d2 
                 WHERE d2.ElectronicPayrollId = e.Id AND d2.Status = 1
             ) THEN 'Exitoso'
        WHEN e.Retry > 1 
             AND NOT EXISTS (
                 SELECT 1 
                 FROM [INDIGO031].Payroll.ElectronicPayrollDetail d2 
                 WHERE d2.ElectronicPayrollId = e.Id AND d2.Status = 1
             ) THEN 'Fallido'
        WHEN e.Retry = 1 AND d.Status = 1 THEN 'Exitoso'
        WHEN e.Retry = 1 AND d.Status = 0 THEN 'Fallido' 
    END as [Estado Envio Real], 
    e.[Year] as Año, 
    e.[Month] as NroMes

FROM [INDIGO031].Payroll.ElectronicPayroll as e
INNER JOIN [INDIGO031].Payroll.ElectronicPayrollDetail AS d ON d.ElectronicPayrollId = e.Id
--INNER JOIN [INDIGO031].Payroll.Employee AS EM ON EM.Id = E.EmployeePartyId
INNER JOIN [INDIGO031].Common.ThirdParty AS TP ON TP.Id = e.EmployeePartyId
WHERE e.DocumentType = '1' 
  AND CONCAT(e.Year, '-', RIGHT(CONCAT('00', e.Month), 2)) >= '2021-09'
