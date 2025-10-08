-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_BILLING_TRAZABILIDADRIPS_GRAL
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.Billing_TrazabilidadRIPS_Gral AS

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
    DATEDIFF(MINUTE, FechaFactura, FechaValidación) AS TiempoValida
FROM (
    SELECT 
        OU.UnitName AS UnidadOperativa,
        I.InvoiceNumber AS NroFactura,
        I.InvoiceDate AS FechaFactura,
        TP.Nit AS Nit,
        TP.Name AS Entidad,
        I.PatientCode AS DocumentoPaciente,
        Paciente.IPNOMCOMP AS Paciente,
        EP.CUV,
        CASE EP.StatusRIPS 
            WHEN 1 THEN 'Por Validar' 
            WHEN 2 THEN 'Validado' 
            WHEN 3 THEN 'Invalido' 
            WHEN 99 THEN 'Erroneo' 
        END AS EstadoRIPS,
        ER.sendDate AS FechaValidación,
        I.AdmissionNumber AS Ingreso,
        ERD.CreationDate AS FechaValidaciónDetalle,
        ERD.MessageCode AS CodigoMensaje,
        Message AS Mensaje,
        ERD.Path AS Ruta,
        TypeMessage AS TipoMensaje,
        PE.Fullname AS UsuarioFactura
    FROM [INDIGO035].[Billing].[ElectronicsProperties] AS EP
    JOIN [INDIGO035].[Billing].[ElectronicsRIPS] AS ER 
        ON EP.Id = ER.ElectronicsPropertiesId
    JOIN (
        SELECT 
            MAX(FORMAT(ERD.CreationDate,'yyyy-MM-dd HH:mm')) AS Fecha, 
            ElectronicsRIPSId
        FROM [INDIGO035].[Billing].[ElectronicsRIPSDetail] AS ERD
        GROUP BY ElectronicsRIPSId
    ) AS ERD1 
        ON ERD1.ElectronicsRIPSId = EP.Id
    JOIN [INDIGO035].[Billing].[ElectronicsRIPSDetail] AS ERD 
        ON ERD.ElectronicsRIPSId = ERD1.ElectronicsRIPSId 
        AND FORMAT(ERD.CreationDate,'yyyy-MM-dd HH:mm') = Fecha
    JOIN [INDIGO035].[Billing].[Invoice] AS I 
        ON EP.EntityId = I.Id
    JOIN [INDIGO035].[Common].[OperatingUnit] AS OU 
        ON OU.Id = I.OperatingUnitId
    JOIN [INDIGO035].[Common].[ThirdParty] AS TP 
        ON I.ThirdPartyId = TP.Id
    LEFT JOIN [INDIGO035].[dbo].[INPACIENT] AS Paciente 
        ON I.PatientCode = Paciente.IPCODPACI
    LEFT JOIN [INDIGO035].[Security].[UserInt] AS US 
        ON US.UserCode = I.InvoicedUser
    LEFT JOIN [INDIGO035].[Security].[PersonInt] AS PE  
        ON PE.Id = US.IdPerson
    WHERE EP.EntityName = 'Invoice' 
      AND I.InvoiceDate >= '01/01/2025'  
      AND I.Status <> '2'  
      AND ERD.MessageCode <> '99'
) AS A
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
    UsuarioFactura;