-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_BILLING_TRAZABILIDADRIPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VW_BILLING_TRAZABILIDADRIPS 
AS

SELECT 
    UPPER(LEFT(UnidadOperativa, 1)) + LOWER(SUBSTRING(UnidadOperativa, 2, LEN(UnidadOperativa))) AS UnidadOperativa,
    NroFactura,
    FechaFactura,
    Nit,
    Entidad,
    DocumentoPaciente,
    Paciente,
    CUV,
    EstadoRIPS,
    FechaValidación,
    Ingreso,
    FechaValidaciónDetalle,
    CodigoMensaje,
    Mensaje,
    Ruta,
    TipoMensaje,
    UsuarioFactura,
    DATEDIFF(MINUTE, FechaFactura, FechaValidación) AS TiempoValida,
    FechaIngreso,
    FechaEgreso
FROM (
    SELECT 
        OU.UnitName AS UnidadOperativa,
        i.InvoiceNumber AS NroFactura,
        i.InvoiceDate AS FechaFactura,
        tp.Nit AS Nit,
        tp.Name AS Entidad,
        i.PatientCode AS DocumentoPaciente,
        paciente.IPNOMCOMP AS Paciente,
        ep.CUV,
        CASE ep.StatusRIPS 
            WHEN 1 THEN 'Por Validar'
            WHEN 2 THEN 'Validado'
            WHEN 3 THEN 'Invalido'
            WHEN 99 THEN 'Erroneo'
        END AS EstadoRIPS,
        er.sendDate AS FechaValidación,
        i.AdmissionNumber AS Ingreso,
        erd.CreationDate AS FechaValidaciónDetalle,
        erd.MessageCode AS CodigoMensaje,
        Message AS Mensaje,
        erd.Path AS Ruta,
        TypeMessage AS TipoMensaje,
        PE.Fullname AS UsuarioFactura,
        i.InitialDate AS FechaIngreso,
        i.OutputDate AS FechaEgreso
    FROM INDIGO031.Billing.ElectronicsProperties ep
    JOIN INDIGO031.Billing.ElectronicsRIPS er ON ep.Id = er.ElectronicsPropertiesId
    JOIN (
        SELECT 
            MAX(FORMAT(erd.CreationDate, 'yyyy-MM-dd HH:mm')) AS Fecha,
            ElectronicsRIPSId
        FROM INDIGO031.Billing.ElectronicsRIPSDetail AS erd
        WHERE erd.MessageCode <> '-999'
        GROUP BY ElectronicsRIPSId
    ) AS erd1 ON erd1.ElectronicsRIPSId = er.Id
    JOIN INDIGO031.Billing.ElectronicsRIPSDetail AS erd ON erd.ElectronicsRIPSId = erd1.ElectronicsRIPSId AND FORMAT(erd.CreationDate, 'yyyy-MM-dd HH:mm') = Fecha
    JOIN INDIGO031.Billing.Invoice i ON ep.EntityId = i.Id
    JOIN INDIGO031.Common.OperatingUnit AS OU ON OU.Id = i.OperatingUnitId
    JOIN INDIGO031.Common.ThirdParty tp ON i.ThirdPartyId = tp.Id
    LEFT JOIN [INDIGO031].[dbo].[INPACIENT] paciente ON i.PatientCode = paciente.IPCODPACI
    LEFT JOIN [INDIGO031].[Security].[UserInt] AS US ON US.UserCode = i.InvoicedUser
    LEFT JOIN [INDIGO031].[Security].[PersonInt] AS PE ON PE.Id = US.IdPerson
    WHERE ep.EntityName = 'Invoice'
      AND i.InvoiceDate >= '04/01/2025'
      AND TypeMessage IN ('RECHAZADO')
      AND i.Status <> '2'

    UNION ALL

    SELECT 
        OU.UnitName AS UnidadOperativa,
        i.InvoiceNumber AS NroFactura,
        i.InvoiceDate AS FechaFactura,
        tp.Nit AS Nit,
        tp.Name AS Entidad,
        i.PatientCode AS DocumentoPaciente,
        paciente.IPNOMCOMP AS Paciente,
        ep.CUV,
        CASE ep.StatusRIPS 
            WHEN 1 THEN 'Por Validar'
            WHEN 2 THEN 'Validado'
            WHEN 3 THEN 'Invalido'
            WHEN 99 THEN 'Erroneo'
        END AS EstadoRIPS,
        er.sendDate AS FechaValidación,
        i.AdmissionNumber AS Ingreso,
        erd.CreationDate AS FechaValidaciónDetalle,
        erd.MessageCode AS CodigoMensaje,
        Message AS Mensaje,
        erd.Path AS Ruta,
        TypeMessage AS TipoMensaje,
        PE.Fullname AS UsuarioFactura,
        i.InitialDate AS FechaIngreso,
        i.OutputDate AS FechaEgreso
    FROM INDIGO031.Billing.ElectronicsProperties ep
    JOIN INDIGO031.Billing.ElectronicsRIPS er ON ep.Id = er.ElectronicsPropertiesId
    JOIN (
        SELECT 
            MAX(FORMAT(erd.CreationDate, 'yyyy-MM-dd HH:mm')) AS Fecha,
            ElectronicsRIPSId
        FROM INDIGO031.Billing.ElectronicsRIPSDetail AS erd
        WHERE erd.MessageCode <> '-999'
        GROUP BY ElectronicsRIPSId
    ) AS erd1 ON erd1.ElectronicsRIPSId = er.Id
    JOIN INDIGO031.Billing.ElectronicsRIPSDetail AS erd ON erd.ElectronicsRIPSId = erd1.ElectronicsRIPSId AND FORMAT(erd.CreationDate, 'yyyy-MM-dd HH:mm') = Fecha
    JOIN INDIGO031.Billing.Invoice i ON ep.EntityId = i.Id
    JOIN INDIGO031.Common.OperatingUnit AS OU ON OU.Id = i.OperatingUnitId
    JOIN INDIGO031.Common.ThirdParty tp ON i.ThirdPartyId = tp.Id
    LEFT JOIN [INDIGO031].[dbo].[INPACIENT] paciente ON i.PatientCode = paciente.IPCODPACI
    LEFT JOIN [INDIGO031].[Security].[UserInt] AS US ON US.UserCode = i.InvoicedUser
    LEFT JOIN [INDIGO031].[Security].[PersonInt] AS PE ON PE.Id = US.IdPerson
    WHERE ep.EntityName = 'Invoice'
      AND i.InvoiceDate >= '04/01/2025'
      AND i.Status <> '2'

    UNION ALL

    SELECT 
        OU.UnitName AS UnidadOperativa,
        i.InvoiceNumber AS NroFactura,
        i.InvoiceDate AS FechaFactura,
        tp.Nit AS Nit,
        tp.Name AS Entidad,
        i.PatientCode AS DocumentoPaciente,
        paciente.IPNOMCOMP AS Paciente,
        ep.CUV,
        CASE ep.StatusRIPS 
            WHEN 1 THEN 'Por Validar'
            WHEN 2 THEN 'Validado'
            WHEN 3 THEN 'Invalido'
            WHEN 99 THEN 'Erroneo'
        END AS EstadoRIPS,
        er.sendDate AS FechaValidación,
        i.AdmissionNumber AS Ingreso,
        erd.CreationDate AS FechaValidaciónDetalle,
        erd.MessageCode AS CodigoMensaje,
        Message AS Mensaje,
        erd.Path AS Ruta,
        TypeMessage AS TipoMensaje,
        PE.Fullname AS UsuarioFactura,
        i.InitialDate AS FechaIngreso,
        i.OutputDate AS FechaEgreso
    FROM INDIGO031.Billing.ElectronicsProperties ep
    JOIN INDIGO031.Billing.ElectronicsRIPS er ON ep.Id = er.ElectronicsPropertiesId
    JOIN (
        SELECT 
            MAX(FORMAT(erd.CreationDate, 'yyyy-MM-dd HH:mm')) AS Fecha,
            ElectronicsRIPSId
        FROM INDIGO031.Billing.ElectronicsRIPSDetail AS erd
        WHERE erd.MessageCode <> '-999'
        GROUP BY ElectronicsRIPSId
    ) AS erd1 ON erd1.ElectronicsRIPSId = er.Id
    JOIN INDIGO031.Billing.ElectronicsRIPSDetail AS erd ON erd.ElectronicsRIPSId = erd1.ElectronicsRIPSId AND FORMAT(erd.CreationDate, 'yyyy-MM-dd HH:mm') = Fecha
    JOIN INDIGO031.Billing.Invoice i ON ep.EntityId = i.Id
    JOIN INDIGO031.Common.OperatingUnit AS OU ON OU.Id = i.OperatingUnitId
    JOIN INDIGO031.Common.ThirdParty tp ON i.ThirdPartyId = tp.Id
    LEFT JOIN [INDIGO031].[dbo].[INPACIENT] paciente ON i.PatientCode = paciente.IPCODPACI
    LEFT JOIN [INDIGO031].[Security].[UserInt] AS US ON US.UserCode = i.InvoicedUser
    LEFT JOIN [INDIGO031].[Security].[PersonInt] AS PE ON PE.Id = US.IdPerson
    WHERE ep.EntityName = 'Invoice'
      AND i.InvoiceDate >= '04/01/2025'
      AND erd.MessageCode = '99'
      AND i.Status <> '2'
) AS a
WHERE EstadoRIPS <> 'Validado'
  AND CodigoMensaje NOT LIKE 'CF%'
GROUP BY 
    UnidadOperativa,
    NroFactura,
    FechaFactura,
    Nit,
    Entidad,
    DocumentoPaciente,
    Paciente,
    CUV,
    EstadoRIPS,
    FechaValidación,
    Ingreso,
    FechaValidaciónDetalle,
    CodigoMensaje,
    Mensaje,
    Ruta,
    TipoMensaje,
    UsuarioFactura,
    FechaIngreso,
    FechaEgreso
