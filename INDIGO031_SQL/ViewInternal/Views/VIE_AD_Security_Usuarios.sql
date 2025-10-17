-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Security_Usuarios
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Security_Usuarios] as
SELECT 
us.UserCode AS CodUsuario, pe.Fullname AS Usuario, pe.Identification AS Identificación, us.Position AS Cargo, CASE us.state WHEN 1 THEN 'Activo' WHEN 0 THEN 'Inactivo' END AS Estado, 
rol.Id AS IDRol, rol.Description AS Rol, GR.Id AS IDGrupo, GR.Description AS Grupo,us.Email, CON.Name as Empresa
FROM [Security].[User] AS us INNER JOIN
[Security].Person AS pe ON pe.Id = us.IdPerson INNER JOIN
[Security].Roll AS rol ON rol.Id = us.RollCode INNER JOIN
[Security].[Group] AS GR ON GR.Id = us.GroupCode inner JOIN
[Security].PermissionCompany as PC ON PC.IdUser = US.Id inner JOIN
[Security].Containers as CON ON PC.IdContainer = CON.Id
where CON.Name  LIKE 'JERSALUD%'  


--SELECT us.UserCode AS CodUsuario, pe.Fullname AS Usuario, pe.Identification AS Identificación, us.Position AS Cargo, CASE us.state WHEN 1 THEN 'Activo' WHEN 0 THEN 'Inactivo' END AS Estado, CASE usertype WHEN '1' THEN 'Si' WHEN 2 THEN 'No' END AS UsuarioAdministrador,
--rol.Id AS IDRol, rol.Description AS Rol, GR.Id AS IDGrupo, GR.Description AS Grupo, CASE us.UserType WHEN 1 THEN 'Administrativo' WHEN 2 THEN 'Asistencial' END AS Tipo
--FROM Security.[User] AS us INNER JOIN
--Security.Person AS pe ON pe.Id = us.IdPerson INNER JOIN
--Security.Roll AS rol ON rol.Id = us.RollCode INNER JOIN
--Security.[Group] AS GR ON GR.Id = us.GroupCode
