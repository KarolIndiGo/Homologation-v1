-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_CNT_Terceros
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[FQ45_V_CNT_Terceros]
AS
SELECT TER.Nit
          AS Nit,
       TER.DigitVerification
          AS [Digito de Verificacion],
       TER.Name
          AS Tercero,
       MAIL.Email
          AS Email,
       DIR.Addresss
          AS Direccion,
       TEL.Phone
          AS Telefono,
       DEP.Name
          AS Departamento,
       CIU.[Name]
          AS [Ciudad 1 Proveedor],
       (SELECT name
        FROM Common.City
        WHERE Common.City.Id = DIR.CityId)
          AS [Ciudad 2 Tercero],
       CASE TER.PersonType WHEN 1 THEN 'Natural' WHEN 2 THEN 'Juridico' END
          AS [Tipo de Persona],
       CASE TER.ContributionType
          WHEN 0 THEN 'No Responsable de IVA'
          WHEN 1 THEN 'Responsables de IVA'
          WHEN 2 THEN 'Empresa Estatal'
          WHEN 3 THEN 'Gran Contribuyente'
		  WHEN 4 THEN 'Regimén Simple'
       END
          AS [Tipo de Contribuyente],
       CASE TER.StateEnterpriseType
          WHEN 0 THEN 'No Aplica'
          WHEN 1 THEN 'Municipal'
          WHEN 2 THEN ' Departamental'
          WHEN 3 THEN 'Distrital'
       END
          AS [Tipo Empresa],
       CASE TER.Ica WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END
          AS Ica,
       TER.IcaPercentage
          AS [Porcentaje Ica],
		   case IcaTop WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END TopeICA,
		   ICAtopValue as VrTopeICA,
       CASE BAN.Type WHEN 1 THEN 'Ahorro' WHEN 2 THEN 'Corriente' END
          AS [Tipo Cuenta],
       BAN.Number
          AS [Cuenta Bancaria],
       FR.Code + '-' + FR.[Name]
          AS [Responsabilidades Fiscales]
		 
FROM Common.ThirdParty TER
     LEFT JOIN Common.Email MAIL ON MAIL.IdPerson = TER.PersonId
     LEFT JOIN Common.Address DIR ON DIR.IdPerson = TER.PersonId
     LEFT JOIN Common.Phone TEL ON TEL.IdPerson = TER.PersonId
     LEFT JOIN Common.Person PER ON PER.Id = TER.PersonId
     LEFT JOIN Common.City CIU ON CIU.Id = PER.IdentificacionCityId
     LEFT JOIN Common.Department DEP ON DEP.Id = CIU.DepartamentId
     LEFT JOIN Common.Supplier PRO ON IdThirdParty = TER.Id
     LEFT JOIN Common.SupplierBankAccount BAN
        ON BAN.SupplierId = PRO.Id
     LEFT JOIN Common.ThirdPartyFiscalResponsibility TFR
        ON TFR.ThirdPartyId = TER.Id
     LEFT JOIN Common.FiscalResponsibility FR
        ON FR.Id = TFR.FiscalResponsibilityId
		where ter.state=1
