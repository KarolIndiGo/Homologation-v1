-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_GeneralLedger_PUC
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view [ViewInternal].[VIE_AD_GeneralLedger_PUC]
 
 
as
 
SELECT TOP (100) PERCENT LB.Name AS Libro, puc.Id,PUC.Number AS Numero, PUC.Name AS Nombre, MC.Name AS Clase, ML.[Level] AS Nivel, CASE PUC.NATURE WHEN 1 THEN 'Debito' WHEN 2 THEN 'Credito' END AS Naturaleza, CASE PUC.CloseThirdParty WHEN 0 THEN 'No' WHEN 1 THEN 'Si' END AS [Maneja Tercero], te.Name AS Tercero, 
           CASE PUC.RetencionType WHEN 0 THEN 'Ninguna' WHEN 1 THEN 'ReteFuente' WHEN 2 THEN 'ReteIva' WHEN 3 THEN 'ReteIca' WHEN 4 THEN 'Otras' END AS [Tipo Retención], 
		   CASE PUC.HandlesCostCenter WHEN 0 THEN 'No' WHEN 1 THEN 'Si' END AS [Maneja Centro Costo], case puc.AllowsMovement when 1 then 'Si' when 0 then 'No' end as 'Permite Movimientos',
           CASE PUC.Status WHEN 0 THEN 'Inactiva' WHEN 1 THEN 'Activa' END AS Estado
FROM   INDIGO031.GeneralLedger.MainAccounts AS PUC LEFT OUTER JOIN
           INDIGO031.GeneralLedger.MainAccountLevels AS ML WITH (NOLOCK) ON ML.Id = PUC.IdAccountLevel LEFT OUTER JOIN
           INDIGO031.GeneralLedger.MainAccountClasses AS MC WITH (NOLOCK) ON MC.Id = PUC.IdAccountClass LEFT OUTER JOIN
           INDIGO031.GeneralLedger.LegalBook AS LB WITH (NOLOCK) ON LB.Id = PUC.LegalBookId LEFT OUTER JOIN
           INDIGO031.Common.ThirdParty AS te WITH (NOLOCK) ON te.Id = PUC.IdThirdParty
ORDER BY Numero
 

