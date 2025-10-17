-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_CONT_PUC
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_CONT_PUC]
AS
SELECT TOP (100) PERCENT
       LB.Name
          AS Libro,
       puc.Id,
       PUC.Number
          AS Numero,
       PUC.Name
          AS Nombre,
       MC.Name
          AS Clase,
       ML.[Level]
          AS Nivel,
       CASE PUC.NATURE WHEN 1 THEN 'Debito' WHEN 2 THEN 'Credito' END
          AS Naturaleza,
       CASE PUC.CloseThirdParty WHEN 0 THEN 'No' WHEN 1 THEN 'Si' END
          AS [Cierre Tercero],
            CASE PUC.HandlesThirdParty WHEN 0 THEN 'No' WHEN 1 THEN 'Si' END
          AS [Maneja Tercero],
       te.Name
          AS Tercero,
       CASE PUC.RetencionType
          WHEN 0 THEN 'Ninguna'
          WHEN 1 THEN 'ReteFuente'
          WHEN 2 THEN 'ReteIva'
          WHEN 3 THEN 'ReteIca'
          WHEN 4 THEN 'Otras'
       END
          AS [Tipo Retención],
       CASE PUC.HandlesCostCenter WHEN 0 THEN 'No' WHEN 1 THEN 'Si' END
          AS [Maneja Centro Costo],
       CASE PUC.Status WHEN 0 THEN 'Inactiva' WHEN 1 THEN 'Activa' END
          AS Estado
FROM GeneralLedger.MainAccounts AS PUC
     LEFT OUTER JOIN
     GeneralLedger.MainAccountLevels AS ML 
        ON ML.Id = PUC.IdAccountLevel
     LEFT OUTER JOIN
     GeneralLedger.MainAccountClasses AS MC 
        ON MC.Id = PUC.IdAccountClass
     LEFT OUTER JOIN GeneralLedger.LegalBook AS LB 
        ON LB.Id = PUC.LegalBookId
     LEFT OUTER JOIN Common.ThirdParty AS te 
        ON te.Id = PUC.IdThirdParty
ORDER BY Numero
