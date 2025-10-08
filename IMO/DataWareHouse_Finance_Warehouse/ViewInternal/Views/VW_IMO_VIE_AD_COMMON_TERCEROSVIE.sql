-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_VIE_AD_COMMON_TERCEROSVIE
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_VIE_AD_Common_TercerosVie
AS

SELECT DISTINCT (T.Nit), T.DigitVerification AS [Digito de Verificación], T.Name AS Nombre, 
           CASE P.IdentificationType WHEN '0' THEN 'Cédula de Ciudadanía' WHEN '1' THEN 'Cédula de Extranjería' WHEN '2' THEN 'Tarjeta de Identidad' WHEN '3' THEN 'Registro Civil' WHEN '4' THEN 'Pasporte' WHEN '7' THEN 'Nit' ELSE 'Sin Identificación' END AS [Tipo de identificación], T.CodeCIIU AS [Codigo CIIU], D.Addresss AS Direccion, 
           C.Name AS Ciudad, ff.Name AS Departamento, TE.Phone AS Telefono, E.Email AS Correo, CASE T .PersonType WHEN '1' THEN 'Natural' WHEN '2' THEN 'Juridica' END AS [Tipo de persona], 
           CASE T .RetentionType WHEN '0' THEN 'Ninguna' WHEN '1' THEN 'Exento de retencion' WHEN '2' THEN 'Hace Retencion' WHEN '3' THEN 'Autoretenedor' END AS [Tipo de Retención], 
           CASE T .ContributionType WHEN '0' THEN 'Simplificado' WHEN '1' THEN 'Común' WHEN '2' THEN 'Empresa estatal' WHEN '3' THEN 'Gran Contribuyente' END AS [Tipo de Contribuyente], CASE T .Ica WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS ICA, T.IcaPercentage AS [Porcentaje ICA], 
           CASE T .IcaTop WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS [Maneja Tope Retención ICA], T.IcaTopValue AS [Valor Tope Retención ICA],
		   case T.State when 1 then 'Activo' else 'Inactivo' end as Estado
FROM   [INDIGO035].[Common].[ThirdParty] AS T  INNER JOIN
           [INDIGO035].[Common].[Person] AS P  ON T.PersonId = P.Id LEFT OUTER JOIN
           [INDIGO035].[Common].[Address] AS D  ON P.Id = D.IdPerson LEFT OUTER JOIN
           [INDIGO035].[Common].[Phone] AS TE  ON P.Id = TE.IdPerson LEFT OUTER JOIN
           [INDIGO035].[Common].[Email] AS E  ON P.Id = E.IdPerson LEFT OUTER JOIN
           [INDIGO035].[Common].[City] AS C  ON D.CityId = C.Id LEFT OUTER JOIN
           [INDIGO035].[Common].[Department] AS ff  ON ff.Id = D.DepartmentId 
--WHERE t.id in (
--					select jd.IdThirdParty
--					from GeneralLedger.JournalVouchers as j 
--					inner join GeneralLedger.JournalVoucherDetails as jd  on jd.IdAccounting=j.Id
--					where year(j.CreationDate)>=2022 and j.Status='2'
--					group by jd.IdThirdParty)