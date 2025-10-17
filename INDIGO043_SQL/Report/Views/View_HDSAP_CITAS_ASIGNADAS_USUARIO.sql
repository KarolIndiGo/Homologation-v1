-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_CITAS_ASIGNADAS_USUARIO
-- Extracted by Fabric SQL Extractor SPN v3.9.0








CREATE VIEW [Report].[View_HDSAP_CITAS_ASIGNADAS_USUARIO]
AS

SELECT COUNT(a.IPCODPACI) AS CitasAsignadas,
       p.Fullname AS UsuarioAsigna,
	   a.FECREGSIS Fecha,
	   INE.DESESPECI Especialidad,
	   a.IPCODPACI DocumentoPaciente
FROM AGASICITA a
JOIN INESPECIA INE ON INE.CODESPECI = A.CODESPECI
JOIN Security.[user] us ON us.UserCode = a.CODUSUASI
JOIN Security.Person p ON p.id = us.IdPerson
GROUP BY p.Fullname,
         a.FECREGSIS,
		 INE.DESESPECI,
		 a.IPCODPACI

