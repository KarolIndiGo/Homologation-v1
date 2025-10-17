-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_CTN_Terceros
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[V_CTN_Terceros]  
AS
SELECT DISTINCT t.Nit,   
            t.DigitVerification AS DIGITO_VERIFICACION,   
            t.Name AS TERCERO,  
			case p.IdentificationType when 0 then 'Cédula de Ciudadanía (CC)'
			when 1 then 'Cédula de Extranjería (CE)'
			when 2 then 'Tarjeta de Identidad (TI)' 
			when 3 then 'Registro Civil (RC)'
			when 4 then 'Pasaporte (PA)'
			when 5 then 'Adulto Sin Identificación (AS)'
			when 6 then 'Menor Sin Identificación (MS)'
			when 7 then 'Nit (NI)'
			when 8 then 'Número único de identificación personal (NU)'
			when 9 then 'Cetrigicado Nacido Vivo (CN)'
			when 10 then 'Carnet Diplomático (CD)'
			when 11 then 'Salvoconducto (SC)'
			when 12 then 'Permiso especial de Permanencia (PE)' end TipoIdentificacion,
            e.Email  as EMAIL,  			
   ---(SELECT /*TOP 1*/ z.Email FROM Common.Email z WHERE p.Id = z.IdPerson) as Email,  
            a.Addresss AS DIRECCION,   
            ph.Phone AS TELEFONO,   
   ---(SELECT TOP 1 z.Phone FROM Common.Phone z WHERE p.Id = z.IdPerson) as TELEFONO,  
            c.name AS CIUDAD,   
            dp.Name AS DEPARTAMENTO,  
            CASE t.[PersonType]  
                WHEN 1 THEN 'Natural'  
                WHEN 2 THEN 'Jurídico'  
            END AS TIPO_PERSONA,  
            CASE t.[RetentionType]  
                WHEN 0 THEN 'Ninguna'  
                WHEN 1 THEN 'Exento de retencion'  
                WHEN 2 THEN 'Hace Retencion'  
                WHEN 3 THEN 'Autoretenedor'  
            END AS TIPO_RETENCION,  
            CASE t.[ContributionType]  
                WHEN 0 THEN 'Simplificado'  
                WHEN 1 THEN 'Común'  
                WHEN 2 THEN 'Empresa estatal'  
                WHEN 3 THEN 'Gran Contribuyente'  
            END AS TIPO_CONTRIBUYENTE,  
            CASE t.[StateEnterpriseType]  
                WHEN 0 THEN 'No Aplica'  
                WHEN 1 THEN 'Municipal'  
                WHEN 2 THEN 'Departamental'  
                WHEN 3 THEN 'Distrital'  
            END AS TIPO_EMPRESA,  
            CASE t.[Ica]  
                WHEN 0 THEN 'No'  
                WHEN 1 THEN 'Si'  
            END AS MANEJA_ICA,   
            t.IcaPercentage AS PORCENTAJE_ICA,   
            ae.Name AS ACTIVIDAD_ECONOMICA,  
            CASE [Class]  
                WHEN 1 THEN 'Nacional'  
                WHEN 2 THEN 'Extranjero'  
            END AS CLASE_TERCERO,   
            t.CodeCIIU AS CODIGO_CIIU,  
            CASE t.State  
                WHEN 1 THEN 'Activo'  
                WHEN 0 THEN 'Inactivo'  
            END AS ESTADO  
     FROM Common.ThirdParty AS t  
          LEFT OUTER JOIN Common.EconomicActivity AS ae ON t.EconomicActivityId = ae.Id  
          LEFT OUTER JOIN Common.Person AS p ON p.IdentificationNumber = t.nit
          LEFT OUTER JOIN Common.Email AS e ON p.Id = e.IdPerson  
          LEFT OUTER JOIN Common.Address AS a ON p.Id = a.IdPerson  
          LEFT OUTER JOIN Common.Phone AS ph ON p.Id = ph.IdPerson  
          LEFT OUTER JOIN Common.Department AS dp ON a.DepartmentId = dp.Id  
          LEFT JOIN Common.City C ON a.CityId = C.id  
		 
		  --where t.State=1  
          --and t.Nit LIKE '%819006966%'  
  
