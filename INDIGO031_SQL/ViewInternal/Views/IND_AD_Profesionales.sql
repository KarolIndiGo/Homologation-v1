-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_AD_Profesionales
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_AD_Profesionales] as

SELECT 
us.UserCode AS CodUsuario, 
pe.Fullname AS Usuario, 
pe.Identification AS Identificación, 
us.Position AS Cargo, 
--rol.Id AS IDRol, rol.Description AS Rol, 
--GR.Id AS IDGrupo, GR.Description AS Grupo,
--us.Email, CON.Name as Empresa,
--pr.IMDIRECCI AS Dirección, pr.IMTELEFON AS Teléfono, pr.IMTELMOVI AS Celular, pr.TARJETAPR AS TarjetaProfesional, 
e.DESESPECI AS Especialidad1, E2.DESESPECI AS Especialidad2, e3.DESESPECI AS Especialidad3,
case REACONEXT when 1 then 'Si' when 0 then 'No' end as [Realiza Cons. Ext],
CASE us.state WHEN 1 THEN 'Activo' WHEN 0 THEN 'Inactivo' END AS EstadoUsuario, 
case pr.ESTADOMED when 1 then 'Activo' else 'Inactivo' end as EstadoProfesional, wc.name as 'Departamento - Ciudad'

FROM [Security].[User] AS us INNER JOIN
[Security].Person AS pe ON pe.Id = us.IdPerson INNER JOIN
[Security].Roll AS rol ON rol.Id = us.RollCode INNER JOIN
[Security].[Group] AS GR ON GR.Id = us.GroupCode inner JOIN
[Security].PermissionCompany as PC ON PC.IdUser = US.Id inner JOIN
[Security].Containers as CON ON PC.IdContainer = CON.Id left join 
dbo.INPROFSAL as pr on pr.CODUSUARI=uS.UserCode left join 
dbo.INESPECIA AS e on e.CODESPECI = pr.CODESPEC1 LEFT OUTER JOIN
dbo.INESPECIA AS E2  ON E2.CODESPECI = pr.CODESPEC2 LEFT OUTER JOIN
dbo.INESPECIA AS e3  ON e3.CODESPECI = pr.CODESPEC3 
LEFT JOIN Common.ThirdParty AS tp on tp.nit = pe.Identification--Pr.codigonit
left JOIN Payroll.Employee  as em on TP.Id = Em.ThirdPartyId left join
Payroll.WorkCenter AS wc ON wc.Id = Em.WorkCenterId
where CON.Code='031' AND PR.REACONEXT='1'

--SELECT CODPROSAL AS COD, LTRIM(RTRIM(MEDPRINOM))+' '+ LTRIM(RTRIM(MEDPRIAPEL)) AS MEDICO,  REGIONAL, SEDE, [CODIGO PROFESIONAL], [NOMBRE Y APELLIDO], ESPECIALIDAD, CLASIFICACION, [PROGRAMA CRONICOS],
--CASE WHEN [CODIGO PROFESIONAL] IS NULL THEN 'MORBILIDAD' ELSE 'PROGRAMAS' END AS PROGRAMAS, p.TARJETAPR as Tarjeta
--FROM DBO.INPROFSAL AS P
--LEFT OUTER JOIN viewinternal.MedicosProgramas AS R ON R.[CODIGO PROFESIONAL]=P.CODPROSAL  
