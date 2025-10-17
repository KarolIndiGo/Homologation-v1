-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_SECURITY_UsuariosCreados
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[V_SECURITY_UsuariosCreados]
AS
     SELECT U.UserCode, 
            P.Fullname, 
            r.Description, 
            U.Position,
            CASE U.State
                WHEN 1
                THEN 'Activo'
                WHEN 0
                THEN 'Inactivo'
            END AS Estado, 
            CON.Code + ' - ' + CON.Name AS Container,
            CASE PC.Permission
                WHEN 1
                THEN 'SI'
                WHEN 0
                THEN 'NO'
            END AS Permiso, 
            'Vie' AS Plataforma
     FROM [Security].[USER] U
          JOIN [Security].[Person] P ON U.IdPerson = P.Id
          JOIN [Security].[Roll] r ON u.RollCode = r.Id
          JOIN [Security].PermissionCompany PC ON PC.IdUser = U.Id
          JOIN [Security].Containers CON ON PC.IdContainer = CON.Id
	 WHERE CON.Name  LIKE '%JERSALUD%'
     UNION ALL
     SELECT U.CODUSUARI, 
            U.NOMUSUARI, 
            R.descrirol, 
            U.DESCARUSU,
            CASE U.USUACTIVO
                WHEN 1
                THEN 'Activo'
                WHEN 0
                THEN 'Inactivo'
            END AS Estado, 
            '010 - JERSALUD SAS' AS Container, 
            CA.NOMCENATE AS Permiso, 
            'Crystal' AS Plataforma
     FROM dbo.SEGusuaru U
          JOIN dbo.SEGrolesu R ON U.CODIGOROL = R.codigorol
          LEFT JOIN dbo.ADCENATEN CA ON U.CODCENATE = CA.CODCENATE;
