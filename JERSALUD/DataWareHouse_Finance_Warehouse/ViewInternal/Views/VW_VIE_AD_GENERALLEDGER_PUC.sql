-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_GENERALLEDGER_PUC
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_GENERALLEDGER_PUC AS

SELECT TOP (100) PERCENT LB.Name AS Libro, PUC.Id,PUC.Number AS Numero, PUC.Name AS Nombre, MC.Name AS Clase, ML.[Level] AS Nivel, CASE PUC.Nature WHEN 1 THEN 'Debito' WHEN 2 THEN 'Credito' END AS Naturaleza, CASE PUC.CloseThirdParty WHEN 0 THEN 'No' WHEN 1 THEN 'Si' END AS [Maneja Tercero], te.Name AS Tercero, 
           CASE PUC.RetencionType WHEN 0 THEN 'Ninguna' WHEN 1 THEN 'ReteFuente' WHEN 2 THEN 'ReteIva' WHEN 3 THEN 'ReteIca' WHEN 4 THEN 'Otras' END AS [Tipo Retención], 
		   CASE PUC.HandlesCostCenter WHEN 0 THEN 'No' WHEN 1 THEN 'Si' END AS [Maneja Centro Costo], case PUC.AllowsMovement when 1 then 'Si' when 0 then 'No' end as 'Permite Movimientos',
           CASE PUC.Status WHEN 0 THEN 'Inactiva' WHEN 1 THEN 'Activa' END AS Estado
FROM   INDIGO031.GeneralLedger.MainAccounts AS PUC LEFT OUTER JOIN
           INDIGO031.GeneralLedger.MainAccountLevels AS ML ON ML.Id = PUC.IdAccountLevel LEFT OUTER JOIN
           INDIGO031.GeneralLedger.MainAccountClasses AS MC ON MC.Id = PUC.IdAccountClass LEFT OUTER JOIN
           INDIGO031.GeneralLedger.LegalBook AS LB ON LB.Id = PUC.LegalBookId LEFT OUTER JOIN
           INDIGO031.Common.ThirdParty AS te ON te.Id = PUC.IdThirdParty
ORDER BY Numero