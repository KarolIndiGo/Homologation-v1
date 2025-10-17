-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: AD_Total_Ingresos_IMO
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[AD_Total_Ingresos_IMO] AS
SELECT 
  IPCODPACI AS identificación, 
  NUMINGRES AS Ingreso, 
  IFECHAING AS FechaIngreso, 
  CODDIAING AS Diagnostico
FROM dbo.ADINGRESO
WHERE 
  IFECHAING BETWEEN '2025-01-01 00:00:00' AND '2025-12-31 23:59:59'
  AND CODDIAING IS NOT NULL;
