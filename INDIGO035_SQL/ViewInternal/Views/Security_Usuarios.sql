-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Security_Usuarios
-- Extracted by Fabric SQL Extractor SPN v3.9.0



create view [ViewInternal].[Security_Usuarios] as
SELECT	usercode as CodUsuario, fullname as Usuario, Identification as Identificación, position as Cargo, case us.state when 1 then 'Activo' when 0 then 'Inactivo' end as Estado,
		case usertype when '1' then 'Si' when 2 then 'No' end as UsuarioAdministrador, rol.id as IDRol,rol.description as Rol, gr.id as IDGrupo,GR.Description AS Grupo, us.*

FROM	Security.[User] as us 
inner join Security.Person as pe on pe.id=us.IdPerson
inner join Security.roll as rol on rol.id=us.rollcode
inner join Security.[Group] AS GR ON GR.Id=US.GroupCode
inner join Security.PermissionCompany as o on o.IdUser=us.Id
where o.IdContainer='50'
--order by Fullname

