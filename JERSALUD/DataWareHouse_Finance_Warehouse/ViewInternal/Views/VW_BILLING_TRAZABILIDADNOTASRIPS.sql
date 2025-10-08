-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_BILLING_TRAZABILIDADNOTASRIPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VW_BILLING_TRAZABILIDADNOTASRIPS
AS
SELECT 
    OU.UnitName AS UnidadOperativa,
    CASE bn.Nature WHEN 1 THEN 'Debito' WHEN 2 THEN 'Credito' END AS Naturaleza,
    bn.Code AS NotaRIPS,
    bn.NoteDate AS FechaNotaRIPS,
    i.InvoiceNumber AS NroFactura,
    tp.Nit AS Nit,
    tp.Name AS Entidad,
    i.PatientCode AS DocumentoPaciente,
    paciente.IPNOMCOMP AS Paciente,
    ep.CUV,
    CASE ep.StatusRIPS 
        WHEN 1 THEN 'Registrado' 
        WHEN 2 THEN 'Validado' 
        WHEN 3 THEN 'Invalido' 
        WHEN 99 THEN 'Erroneo' 
    END AS EstadoRIPS,
    er.sendDate AS FechaValidación,
    i.AdmissionNumber AS Ingreso,
    erd.MessageCode AS CodigoMensaje,
    Message AS Mensaje,
    erd.Path AS Ruta,
    TypeMessage AS TipoMensaje,
    PN.Code AS NotaCartera,
    PE.Fullname AS UsuarioNotaCartera,
    i.OutputDate AS FechaEgresoFactura,
    CASE
        WHEN AC.PortfolioStatus = '1' THEN 'SINRADICAR'
        WHEN AC.PortfolioStatus = '2' THEN 'RADICADA SIN CONFIRMAR'
        WHEN AC.PortfolioStatus = '3' THEN 'RADICADA ENTIDAD'
        WHEN AC.PortfolioStatus = '7' THEN 'CERTIFICADA_PARCIAL'
        WHEN AC.PortfolioStatus = '8' THEN 'CERTIFICADA_TOTAL'
        WHEN AC.PortfolioStatus = '14' THEN 'DEVOLUCION_FACTURA'
        WHEN AC.PortfolioStatus = '15' THEN 'TRASLADO_COBRO_JURIDICO'
    END AS EstadoFactura
FROM INDIGO031.Billing.ElectronicsProperties ep
JOIN INDIGO031.Billing.ElectronicsRIPS er ON ep.Id = er.ElectronicsPropertiesId
JOIN (
    SELECT 
        MAX(FORMAT(erd.CreationDate, 'yyyy-MM-dd HH:mm')) AS Fecha, 
        ElectronicsRIPSId
    FROM INDIGO031.Billing.ElectronicsRIPSDetail AS erd
    GROUP BY ElectronicsRIPSId
) AS erd1 ON erd1.ElectronicsRIPSId = ep.Id
JOIN INDIGO031.Billing.ElectronicsRIPSDetail AS erd ON erd.ElectronicsRIPSId = erd1.ElectronicsRIPSId AND FORMAT(erd.CreationDate, 'yyyy-MM-dd HH:mm') = Fecha
JOIN INDIGO031.Billing.BillingNote bn ON ep.EntityId = bn.Id
JOIN INDIGO031.Billing.BillingNoteDetail bnd ON bnd.BillingNoteId = bn.Id
JOIN INDIGO031.Billing.Invoice i ON bnd.InvoiceId = i.Id
JOIN INDIGO031.Common.OperatingUnit AS OU ON OU.Id = i.OperatingUnitId
JOIN INDIGO031.Common.ThirdParty tp ON i.ThirdPartyId = tp.Id
JOIN [INDIGO031].[dbo].[INPACIENT] paciente ON i.PatientCode = paciente.IPCODPACI
LEFT JOIN INDIGO031.Portfolio.PortfolioNote PN ON PN.Id = bn.EntityId
LEFT JOIN [INDIGO031].[Security].[UserInt] AS US ON US.UserCode = PN.CreationUser
LEFT JOIN [INDIGO031].[Security].[PersonInt] AS PE ON PE.Id = US.IdPerson
LEFT JOIN INDIGO031.Portfolio.AccountReceivable AS AC ON AC.InvoiceNumber = i.InvoiceNumber
WHERE ep.EntityName = 'BillingNote' AND erd.MessageCode <> '00'
