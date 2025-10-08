-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_PAYROLL_TRAZABILIDADNOMINAELECTRONICA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[Payroll_TrazabilidadNominaElectronica]
AS

SELECT 
    e.Id AS IdDocumento,
    CONCAT(e.Year, '-', RIGHT(CONCAT('00', e.Month), 2)) AS Periodo,
    e.Consecutive AS Consecutivo,
    e.DocumentNumber AS [Numero Documento],
    TP.Nit + ' - ' + TP.Name AS Empleado,
    CASE e.Status
        WHEN 0   THEN 'Erronea'
        WHEN 1   THEN 'Registrada'
        WHEN 2   THEN 'Enviada'
        WHEN 3   THEN 'Validada'
        WHEN 4   THEN 'Invalida'
        WHEN 66  THEN 'Reenvío Obligatorio'
        WHEN 88  THEN 'Pendiente'
        WHEN 222 THEN 'Procesando'
    END AS [Estado Registro DIAN],
    e.CreationDate AS [Fecha Crea Registro],
    e.ShippingDate AS [Fecha Envio DIAN],
    e.ValidationDate AS [Fecha Validación DIAN],
    e.FilePath AS [RutaArchivo],
    e.Retry AS [Intentos Envio],
    e.CUNE AS CUNE,
    CASE d.Destination
        WHEN 0 THEN 'Validacion previa a la generacion del XML'
        WHEN 1 THEN 'Envio Documento Electronico a la DIAN'
        WHEN 2 THEN 'Validacion del Documento Enviado'
    END AS [Destino Envio],
    d.CreationDate AS [Fecha Registro e Intento Envio],
    CASE d.Status
        WHEN 0 THEN 'Fallido'
        WHEN 1 THEN 'Exitoso'
    END AS [Estado Envio],
    d.Comments AS Comentarios,
    d.ResponseData AS [Respuesta Recibida],
    CASE 
        WHEN e.Retry > 1 AND EXISTS (
            SELECT 1
            FROM [INDIGO035].[Payroll].[ElectronicPayrollDetail] d2
            WHERE d2.ElectronicPayrollId = e.Id AND d2.Status = 1
        ) THEN 'Exitoso'
        WHEN e.Retry > 1 AND NOT EXISTS (
            SELECT 1
            FROM [INDIGO035].[Payroll].[ElectronicPayrollDetail] d2
            WHERE d2.ElectronicPayrollId = e.Id AND d2.Status = 1
        ) THEN 'Fallido'
        WHEN e.Retry = 1 AND d.Status = 1 THEN 'Exitoso'
        WHEN e.Retry = 1 AND d.Status = 0 THEN 'Fallido'
    END AS [Estado Envio Real],
    e.[Year] AS Año,
    e.[Month] AS NroMes
FROM [INDIGO035].[Payroll].[ElectronicPayroll] AS e
INNER JOIN [INDIGO035].[Payroll].[ElectronicPayrollDetail] AS d
    ON d.ElectronicPayrollId = e.Id
--INNER JOIN [INDIGO035].[Payroll].[Employee] AS EM ON EM.Id = e.EmployeePartyId
INNER JOIN [INDIGO035].[Common].[ThirdParty] AS TP
    ON TP.Id = e.EmployeePartyId
WHERE e.DocumentType = '1'
  AND CONCAT(e.Year, '-', RIGHT(CONCAT('00', e.Month), 2)) >= '2021-09';