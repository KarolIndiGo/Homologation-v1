-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_Medicamentos
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[FQ45_V_INN_Medicamentos]
AS
SELECT atc.id, atc.Code AS [Codigo Medicamento],
       atc.name AS [Nombre Medicamento],
       dci.Code + ' - ' + dci.[Name] AS [DCI],
       atcen.Code + ' - ' + atcen.[Name] AS [ATC],
       atc.AbbreviationName AS [Abreviacion],
       atc.Presentations AS [Presentacion],
       atc.Concentration AS [Concentracion],
       sp1.Fullname AS [Usuario Creacion],
       atc.CreationDate AS [Fecha Creacion],
       sp2.Fullname AS [Usuario Modifica],
       atc.ModificationDate AS [Fecha Modificacion],
	   atc.POSProduct as ProductoPos
	  , case atc.status when 1 then 'Activo' when 0 then 'Inactivo' end as Estado
FROM Inventory.ATC atc
     INNER JOIN Inventory.DCI dci ON atc.DCIId = dci.Id
     INNER JOIN Inventory.ATCEntity atcen ON atcen.Id = atc.ATCEntityId
     LEFT OUTER JOIN Security.[User] AS s1
        ON s1.UserCode = atc.CreationUser
     LEFT OUTER JOIN Security.Person AS sp1 
        ON sp1.Id = s1.IdPerson
     LEFT OUTER JOIN Security.[User] AS s2 
        ON s2.UserCode = atc.ModificationUser
     LEFT OUTER JOIN Security.Person AS sp2 
        ON sp2.Id = s2.IdPerson
--WHERE --atc.status = 1
