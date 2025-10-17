-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: SG_ControlUsuariosActivos
-- Extracted by Fabric SQL Extractor SPN v3.9.0





create view [ViewInternal].[SG_ControlUsuariosActivos] as
SELECT 
        [Extent1].[Id] AS [Id], 
        --[Extent1].[IdPerson] AS [IdPerson], 
         
      -- [Extent1].[RollCode] AS [RollCode], 
	   
       
		[Extent1].[UserCode] AS [CodUsuario],
		 [Extent2].[Identification] AS [Identificacion], 
        case [Extent2].[IdentificationType] when 1 then 'CC' when 2 then 'CE' else '' end AS [Tipo Identificacion], 
		
         [Extent2].[Fullname] AS [Usuario], 
        --[Extent2].[BirthDay] AS [BirthDay], 
        --[Extent2].[Fingerprint] AS [Fingerprint], 
        case [Extent2].[Gender] when 1 then 'Masculino' when 2 then 'Femenino' end AS [Genero], 
		[Extent1].[Position] AS [Cargo],
		ROL.Description AS Rol,
		grupo.Description as Grupo ,
        --[Extent2].[State] AS [State1],
       -- [Extent1].[UserType] AS [UserType], 
        --[Extent1].[ChangePassword] AS [ChangePassword], 
        --[Extent1].[DaysChangePassword] AS [DaysChangePassword], 
        --[Extent1].[DateLastChangePassword] AS [DateLastChangePassword], 
        --[Extent1].[DateExpiryAccount] AS [DateExpiryAccount], 
        --[Extent1].[Password] AS [Password], 
        --[Extent1].[State] AS [State], 
        --[Extent1].[UserNameLync] AS [UserNameLync], 
        --[Extent1].[AddressSingInLync] AS [AddressSingInLync], 
        --[Extent1].[PasswordLync] AS [PasswordLync], 
        --[Extent1].[PersonalNote] AS [PersonalNote], 
       -- [Extent1].[ViewForm] AS [ViewForm], 
       -- [Extent1].[CodeInterface] AS [CodeInterface], 
       -- [Extent1].[IsLockedOut] AS [IsLockedOut], 
       -- [Extent1].[FailedPasswordCount] AS [FailedPasswordCount], 
    case    [Extent1].[ProfileType]  when 1 then 'Administrativo' when 2 then 'Asistencial' end AS [Perfil], 
        [Extent1].[Email] AS [Email], 
        --[Extent1].[TimeStamp] AS [TimeStamp], 
        --[Extent1].[OldId] AS [OldId], 
        --[Extent1].[RefreshToken] AS [RefreshToken], 
  --      [Extent1].[CreationUser] AS [CodUsuCrea], 
		--pc.Fullname as UsuarioCrea,
  --      [Extent1].[CreationDate] AS [FechaCreacion], 
  --      [Extent1].[ModificationUser] AS [CodUsuModifica], 
		--pcm.Fullname as UsuarioModifica,
  --      [Extent1].[ModificationDate] AS [FechaMoficiacion],
		 p.IMDIRECCI AS Dirección, p.IMTELEFON AS Teléfono, p.IMTELMOVI AS Celular, p.TARJETAPR AS TarjetaProfesional, e.DESESPECI AS Especialidad1, E2.DESESPECI AS Especialidad2, e3.DESESPECI AS Especialidad3,
--case when p.medifirma is null then 'No' else 'Si' end as Firma, USUEMAILC AS Correo, case when u.nomusuari like '%NVA' then 'Neiva' when u.nomusuari like '%TJA' then 'Tunja' when u.nomusuari like '%FLA' then 'Florencia' end as 'Sucursal',
case ESTADOMED when 1 then 'Activo' else 'Inactivo' end as EstadoProfesional,

 case p.tipprofes when 1 then 'Medico General' when 2 then 'Medico Especialista'
when 3 then 'Enfermera'
when 4 then 'Auxiliar Enfermeria'
when 5 then 'Odontologo General'
when 6 then 'Odontologo Especialista'
when 7 then 'Nutricionista'
when 8 then 'Higienista'
when 9 then 'Psicologo'
when 10 then 'Trabajadora Social'
when 11 then 'Promotor de Saneamiento'
when 12 then  'Ingeniero Sanitario'
when 13 then  'Medico Veterinario'
when 14 then 'Ingeniero Alimento'
when 15 then 'Auxiliar Bacteriologo'
when 16 then  'Terapeuta'
when 17 then 'Optometra'
when 18 then 'Quimico Farmaceutico'
when 19 then 'Radiologo'
when 20 then 'Tecnologo Radiologo'
when 21 then  'Instrumentador Qx'
when 22 then 'Auxiliar Patologia'
when 23 then 'Otros'
when 24 then 'Medico Interno'
when 25 then 'Bacteriologo(a)'
when 26 then 'Patólogo(a)'
when 27 then 'Médico residente' end as Profesion,
case [Extent1].State when 1 then 'Activo' else 'Inactivo' end as EstadoUsuario
        --[Extent2].[Id] AS [Id1], 
        --[Extent2].[FirstName] AS [FirstName], 
        --[Extent2].[SecondName] AS [SecondName], 
        --[Extent2].[FirstLastName] AS [FirstLastName], 
        --[Extent2].[SecondLastName] AS [SecondLastName], 
     
   FROM  [Security].[User] AS [Extent1]
        INNER JOIN  [Security].[Person] AS [Extent2] ON [Extent1].[IdPerson] = [Extent2].[Id]
		INNER JOIN  [Security].[Roll] AS ROL ON ROL.Id=[Extent1].RollCode
		INNER JOIN  [Security].[Group] AS grupo ON grupo.Id=[Extent1].GroupCode
		--left join  [Security].[User] AS [usucrea] on [usucrea].UserCode=[Extent1].[CreationUser]
       -- left join  [Security].[Person] AS [pc] ON [pc].[Id] = [usucrea].[IdPerson]
		--left join  [Security].[User] AS [usumod] on [usumod].UserCode=[Extent1].[ModificationUser]
       -- left join  [Security].[Person] AS [pcm] ON [pcm].[Id] = [usumod].[IdPerson]
		left join dbo.INPROFSAL as p on p.CODPROSAL=[Extent1].UserCode LEFT OUTER JOIN
		 dbo.INESPECIA AS e WITH (NOLOCK) ON e.CODESPECI = p.CODESPEC1 LEFT OUTER JOIN
           dbo.INESPECIA AS E2 WITH (NOLOCK) ON E2.CODESPECI = p.CODESPEC2 LEFT OUTER JOIN
           dbo.INESPECIA AS e3 WITH (NOLOCK) ON e3.CODESPECI = p.CODESPEC3 
		   LEFT OUTER JOIN Security.PermissionCompany as o on o.IdUser= [Extent1].Id
 where o.IdContainer='50'

		and [Extent1].[State]=1 -- and [Extent1].[UserCode]='446'
		--order by [Extent1].[CreationDate] desc

