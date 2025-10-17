-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Security_Usuarios_Miomed
-- Extracted by Fabric SQL Extractor SPN v3.9.0



create VIEW [ViewInternal].[VIE_AD_Security_Usuarios_Miomed] as
SELECT
us.UserCode AS CodUsuario, pe.Fullname AS Usuario, pe.Identification AS Identificación, us.Position AS Cargo, CASE us.state WHEN 1 THEN 'Activo' WHEN 0 THEN 'Inactivo' END AS Estado, CASE usertype WHEN '1' THEN 'Si' WHEN 2 THEN 'No' END AS UsuarioAdministrador,
rol.Id AS IDRol, rol.Description AS Rol, GR.Id AS IDGrupo, GR.Description AS Grupo, 
CASE us.UserType WHEN 1 THEN 'Administrativo' WHEN 2 THEN 'Asistencial' END AS Tipo--, pp.UnitName
FROM Security.[User] AS us INNER JOIN
Security.Person AS pe ON pe.Id = us.IdPerson INNER JOIN
Security.Roll AS rol ON rol.Id = us.RollCode INNER JOIN
Security.[Group] AS GR ON GR.Id = us.GroupCode inner join
Security.[UserOperatingUnit] as up on up.IdUser=us.Id inner join 
Common.OperatingUnit as pp on pp.Id=up.IdOperatingUnit
where IdContainer=99
group by us.UserCode, pe.Fullname , pe.Identification, us.Position , us.state ,  usertype , rol.Id , rol.Description , GR.Id , GR.Description , 
 us.UserType

--select *
--from Security.Containers
--where name like '%miomed%'