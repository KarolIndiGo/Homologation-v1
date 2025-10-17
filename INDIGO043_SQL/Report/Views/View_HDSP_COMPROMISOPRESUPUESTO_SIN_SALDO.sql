-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSP_COMPROMISOPRESUPUESTO_SIN_SALDO
-- Extracted by Fabric SQL Extractor SPN v3.9.0







CREATE VIEW [Report].[View_HDSP_COMPROMISOPRESUPUESTO_SIN_SALDO]
AS

SELECT
    DISTINCT 
	c.Code AS [Código Compromiso],
    tp.Nit,
    tp.Name AS Tercero,
    c.DocumentDate AS Fecha,
    cd.ExpiredDate AS [Fecha Expiración],
    c.Document AS Documento,
    c.Observations AS Observación,
    a.code AS [Código Disponibilidad],
    CASE c.CommitmentType
                   WHEN 1 THEN 'Compromiso'
                   WHEN 2 THEN 'Reserva'
                   END AS [Nombre Compromiso],
    CASE c.Status 
                  WHEN 1 THEN 'Registrado' 
                  WHEN 2 THEN 'Confirmado' 
                  WHEN 3 THEN 'Anulado' 
                  END AS Estado,
    cat.Code AS Codigo,
    cat.Name AS Rubro,
    cpc.Code AS Código,
    cpc.Name AS NombreCPC,
    CONCAT(fs.code, '-', fs.name) AS Recurso,
    CONCAT(rt.Code, '-', rt.Name) AS Tipo,
    rt.Code AS RevenueTypeCode,
    rt.Name AS RevenueTypeName,
    cd.InitialValue,
	cm.DebitValue Debito,
	cm.CreditValue Credito,
	cd.ExecutedValue ValorEjecutado,
	cd.InitialValue - ISNULL(cm.DebitValue, 0) + ISNULL(cm.CreditValue, 0) TotalValue


FROM     Budget.Commitment c
JOIN     Common.ThirdParty tp ON c.ThirdPartyId = tp.Id
JOIN     Budget.CommitmentDetail cd ON c.Id = cd.CommitmentId
JOIN     Budget.AvailabilityDetail ad ON cd.AvailabilityDetailId = ad.id
JOIN     Budget.Availability a ON ad.AvailabilityId = a.id
LEFT JOIN     Budget.CPCCatalog cpc ON CPC.id = ad.CPCCodeId
JOIN     Budget.Category cat ON cd.CategoryId = cat.Id
JOIN     Budget.FinancialSource fs ON cat.FinancialSourceId = fs.Id
JOIN     Budget.RevenueType rt ON cd.RevenueTypeId = rt.Id
LEFT JOIN     Common.GetEntityNameDescriptions() gend ON c.EntityName = gend.EntityName
LEFT JOIN 
    (SELECT
        cmd.CommitmentDetailId,
        SUM(IIF(cmd.Nature = 1, cmd.Value, 0)) AS DebitValue,
        SUM(IIF(cmd.Nature = 1, 0, cmd.Value)) AS CreditValue
    FROM 
        Budget.CommitmentModification cm
    JOIN 
        Budget.CommitmentModificationDetail cmd ON cm.Id = cmd.CommitmentModificationId
    WHERE 
        cm.Status = 2
    GROUP BY 
        cmd.CommitmentDetailId) cm ON cd.Id = cm.CommitmentDetailId

	WHERE cd.balance > 0 and C.Status = 2;



