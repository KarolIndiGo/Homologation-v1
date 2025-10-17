-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Comparativo_Usuario_Indigo
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[Comparativo_Usuario_Indigo]
AS
select  uc.CODUSUARI as Usu_Crystal, uc.NOMUSUARI AS Nom_Crystal, 
		CASE uc.USUACTIVO WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS Estado_Crystal, 
		rc.descrirol as Rol_Crystal, CA.NOMCENATE AS Centro_Atencion_Crystal, 
		uv.Identification AS Usu_VIE, uv.Fullname AS Nom_VIE, 
		CASE uv.State  WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS Estado_VIe, uv.Description AS Rol_Vie,
		uv.FirstName, uv.SecondName, uv.FirstLastName, uv.SecondLastName, uv.Position,
		uv.Container, uv.Permiso, g.descrigru as grupo_crystal, uv.grupo as grupo_vie
from [dbo].[SEGusuaru] as uc
inner join [dbo].[SEGrolesu] as rc on rc.codigorol=uc.CODIGOROL
inner join [dbo].[SEGgruusu] as g on g.codgrupou=uc.CODGRUPOU
 LEFT JOIN dbo.ADCENATEN CA ON uc.CODCENATE = CA.CODCENATE
left join (
		select p.Identification, p.Fullname, u.Position, u.State, r.Description, p.FirstName, p.SecondName, p.FirstLastName, p.SecondLastName,
			CON.Code + ' - ' + CON.Name AS Container,
			CASE PC.Permission
                WHEN 1 THEN 'SI'
                WHEN 0 THEN 'NO'
            END AS Permiso,
			g.[Description] as grupo
		from [Security].[Person] as p 
		inner join [Security].[User] as u on u.IdPerson=p.Id
		inner join [Security].[Roll] as r on r.Id=u.RollCode
		inner join [Security].[Group] as g on g.Id=u.GroupCode
		inner JOIN [Security].PermissionCompany as PC ON PC.IdUser = U.Id
        inner JOIN [Security].Containers as CON ON PC.IdContainer = CON.Id
		WHERE CON.Name  LIKE 'FARMAQUIRURGICOS%'
	) as uv on uv.Identification = uc.CODUSUARI
where uc.USUACTIVO = 1 --and uv.State='NULL'

/*
select uc.CODUSUARI, uc.NOMUSUARI, uc.USUACTIVO, uv.Identification, uv.Fullname, uv.State
from [dbo].[SEGusuaru] as uc
right join (
		select p.Identification, p.Fullname, u.Position, u.State
		from [Security].[Person] as p 
		inner join [Security].[User] as u on u.IdPerson=p.Id
	) as uv on uv.Identification = uc.CODUSUARI
where uv.State = 1 --
*/
