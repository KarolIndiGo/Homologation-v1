-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: MM_V_CTN_Terceros
-- Extracted by Fabric SQL Extractor SPN v3.9.0


create VIEW [ViewInternal].[MM_V_CTN_Terceros]
AS
SELECT t.Nit, t.DigitVerification AS DIGITO_VERIFICACION, t.Name AS TERCERO, e.Email, a.Addresss AS DIRECCION, ph.Phone AS TELEFONO, c.Name AS Ciudad, dp.Name AS DEPARTAMENTO, CASE t .[PersonType] WHEN 1 THEN 'Natural' WHEN 2 THEN 'Jurídico' END AS TIPO_PERSONA, 
             CASE t .[RetentionType] WHEN 0 THEN 'Ninguna' WHEN 1 THEN 'Exento de retencion' WHEN 2 THEN 'Hace Retencion' WHEN 3 THEN 'Autoretenedor' END AS TIPO_RETENCION, 
             CASE t .[ContributionType] WHEN 0 THEN 'Simplificado' WHEN 1 THEN 'Común' WHEN 2 THEN 'Empresa estatal' WHEN 3 THEN 'Gran Contribuyente' END AS TIPO_CONTRIBUYENTE, 
             CASE t .[StateEnterpriseType] WHEN 0 THEN 'No Aplica' WHEN 1 THEN 'Municipal' WHEN 2 THEN 'Departamental' WHEN 3 THEN 'Distrital' END AS TIPO_EMPRESA, CASE t .[Ica] WHEN 0 THEN 'No' WHEN 1 THEN 'Si' END AS MANEJA_ICA, t.IcaPercentage AS PORCENTAJE_ICA, 
             ae.Name AS ACTIVIDAD_ECONOMICA, CASE [Class] WHEN 1 THEN 'Nacional' WHEN 2 THEN 'Extranjero' END AS CLASE_TERCERO, t.CodeCIIU AS CODIGO_CIIU, t.State AS ESTADO
FROM   Common.ThirdParty AS t LEFT OUTER JOIN
             Common.EconomicActivity AS ae ON t.EconomicActivityId = ae.Id LEFT OUTER JOIN
             Common.Person AS p ON p.IdentificationNumber = t.Nit LEFT OUTER JOIN
             Common.Email AS e ON p.Id = e.IdPerson LEFT OUTER JOIN
             Common.Address AS a ON p.Id = a.IdPerson LEFT OUTER JOIN
             Common.Phone AS ph ON p.Id = ph.IdPerson LEFT OUTER JOIN
             Common.Department AS dp ON a.DepartmentId = dp.Id LEFT OUTER JOIN 
			 Common.City AS C ON A.CityId=c.Id 
