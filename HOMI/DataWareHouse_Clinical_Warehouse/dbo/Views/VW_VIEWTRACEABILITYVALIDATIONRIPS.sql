-- Workspace: HOMI
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9e4ad354-8031-4a13-8643-33b3234761ff
-- Schema: dbo
-- Object: VW_VIEWTRACEABILITYVALIDATIONRIPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW dbo.VW_VIEWTRACEABILITYVALIDATIONRIPS AS 

WITH cte_Rips_Detail AS (
    SELECT 
        ElectronicsRIPSId,
        MAX(CreationDate) AS CreationDate
    FROM [INDIGO036].[Billing].[ElectronicsRIPSDetail]
    GROUP BY ElectronicsRIPSId
),
cte_RIPS_id AS (
    SELECT 
        r.Id,
		i.InvoiceValue,
		ISNULL(i.InvoiceNumber,bn.Code) as InvoiceNumber,
		ISNULL(i.InvoiceDate,bn.NoteDate) as InvoiceDate,
		i.PatientCode,
		i.AdmissionNumber,
		TER.Nit+'-'+TER.Name AS CLIENTE,
		ep.StatusRIPS,
		bn.Id AS NOTA
    FROM INDIGO036.Billing.ElectronicsProperties ep
    INNER JOIN INDIGO036.Billing.ElectronicsRIPS r ON ep.Id = r.ElectronicsPropertiesId
    LEFT JOIN INDIGO036.Billing.Invoice i ON ep.EntityId = i.Id AND ep.EntityName = 'Invoice'
    LEFT JOIN INDIGO036.Billing.BillingNote bn  ON ep.EntityId = bn.Id AND ep.EntityName = 'BillingNote'
	LEFT JOIN INDIGO036.Common.ThirdParty TER ON i.ThirdPartyId=TER.Id
    WHERE ((ep.EntityName = 'Invoice' AND i.Status = 1) OR (ep.EntityName = 'BillingNote'))     
)
SELECT DISTINCT 
--ripd.ElectronicsRIPSId, 
--ripd.MessageCode,
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
CASE WHEN cte_id.NOTA IS NULL THEN 'FACTURA' ELSE 'NOTA' END AS TIPO, 
cte_id.InvoiceValue AS [VALOR FACTURA],
cte_id.InvoiceNumber AS [NUMERO FACTURA],
cte_id.InvoiceDate AS [FECHA FACTURA],
cte_id.[CLIENTE],
cte_id.PatientCode AS PACIENTE,
cte_id.AdmissionNumber AS INGRESO,
CASE cte_id.StatusRIPS WHEN 1 THEN 'REGISTRADA'--'AMARILLO'
				   WHEN 2 THEN 'ACEPTADA'--'VERDE'
				   WHEN 3 THEN 'RECHAZADA' END AS [ESTADO FACTURA],
CASE ripd.TypeMessage WHEN '' THEN 'EXEPCION INTERNA' ELSE ripd.TypeMessage END AS [ESTADO RIPS],
1 AS CANTIDAD,
ripd.MessageCode AS CODIGO,
convert(varchar(1000),ripd.[Message]) AS MENSAJE,
ripd.CreationDate AS [FECHA VALIDACION DETALLE],
CAST(SYSDATETIMEOFFSET() AT TIME ZONE 'UTC' AT TIME ZONE 'SA Pacific Standard Time' AS DATETIME) AS [FECHA ACTUALIZACION]
FROM [INDIGO036].[Billing].[ElectronicsRIPSDetail] ripd
INNER JOIN cte_Rips_Detail cte ON ripd.ElectronicsRIPSId = cte.ElectronicsRIPSId AND ripd.CreationDate = cte.CreationDate
INNER JOIN cte_RIPS_id cte_id ON ripd.ElectronicsRIPSId = cte_id.Id
--WHERE ripd.MessageCode = '-999';}
--group by     ripd.ElectronicsRIPSId, 
--    ripd.MessageCode
-- WHERE cte_id.NOTA IS NOT NULL
--GO


--	select * from Billing.BillingNote