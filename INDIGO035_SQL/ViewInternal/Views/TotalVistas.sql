-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: TotalVistas
-- Extracted by Fabric SQL Extractor SPN v3.9.0




create VIEW [ViewInternal].[TotalVistas] as

SELECT distinct (sysobjects.name) , crdate
FROM sysobjects 
left outer join syscolumns on sysobjects.id = syscolumns.id 
where sysobjects.xtype = 'v'-- and crdate >='01-01-2022'
--order by crdate
