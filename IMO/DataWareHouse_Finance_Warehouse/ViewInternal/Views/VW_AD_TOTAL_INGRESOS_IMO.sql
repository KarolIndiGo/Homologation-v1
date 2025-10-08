-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_AD_TOTAL_INGRESOS_IMO
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VW_AD_TOTAL_INGRESOS_IMO] AS
SELECT 
	IPCODPACI AS identificación 
	,NUMINGRES AS Ingreso
	,IFECHAING AS FechaIngreso 
	,CODDIAING AS Diagnostico
FROM [INDIGO035].[dbo].[ADINGRESO]
WHERE IFECHAING BETWEEN '2025-01-01 00:00:00' AND '2025-12-31 23:59:59'
	AND CODDIAING IS NOT NULL;
