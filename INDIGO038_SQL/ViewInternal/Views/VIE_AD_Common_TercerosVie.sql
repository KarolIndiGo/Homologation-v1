-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Common_TercerosVie
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VIE_AD_Common_TercerosVie]
AS

SELECT 
DISTINCT (T.Nit), T.DigitVerification AS [Digito de Verificación], T.Name AS Nombre, 
           CASE P.IdentificationType WHEN '0' THEN 'Cédula de Ciudadanía' WHEN '1' THEN 'Cédula de Extranjería' WHEN '2' THEN 'Tarjeta de Identidad' WHEN '3' THEN 'Registro Civil' WHEN '4' THEN 'Pasporte' WHEN '7' THEN 'Nit' ELSE 'Sin Identificación' END AS [Tipo de identificación], T.CodeCIIU AS [Codigo CIIU], D.Addresss AS Direccion, 
           C.Name AS Ciudad, ff.Name AS Departamento, TE.Phone AS Telefono, E.Email AS Correo, CASE T .PersonType WHEN '1' THEN 'Natural' WHEN '2' THEN 'Juridica' END AS [Tipo de persona], 
           CASE T .RetentionType WHEN '0' THEN 'Ninguna' WHEN '1' THEN 'Exento de retencion' WHEN '2' THEN 'Hace Retencion' WHEN '3' THEN 'Autoretenedor' END AS [Tipo de Retención], 
           CASE T .ContributionType WHEN '0' THEN 'Simplificado' WHEN '1' THEN 'Común' WHEN '2' THEN 'Empresa estatal' WHEN '3' THEN 'Gran Contribuyente' END AS [Tipo de Contribuyente], CASE T .Ica WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS ICA, T.IcaPercentage AS [Porcentaje ICA], 
           CASE T .IcaTop WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS [Maneja Tope Retención ICA], T.IcaTopValue AS [Valor Tope Retención ICA],
		   case t.State when 1 then 'Activo' else 'Inactivo' end as Estado
FROM   Common.ThirdParty AS T  INNER JOIN
           Common.Person AS P  ON T.PersonId = P.Id LEFT OUTER JOIN
           (select max(id) as id, idperson
		    from Common.Address
			group by idperson) as d1 on d1.idperson= p.id left outer join
		   Common.Address AS D  ON d.id=d1.id LEFT OUTER JOIN
           (select max(id) as id, idperson
			from common.phone
			group by idperson) as ph on ph.idperson=p.id left outer join
		   Common.Phone AS TE  ON TE.id=ph.id LEFT OUTER JOIN
           Common.Email AS E  ON P.Id = E.IdPerson LEFT OUTER JOIN
           Common.City AS C  ON D.CityId = C.Id LEFT OUTER JOIN
           Common.Department AS ff  ON ff.Id = D.DepartmentId 
		
