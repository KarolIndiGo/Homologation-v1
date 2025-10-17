-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_CXP_Proveedores
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_CXP_Proveedores] AS
SELECT PRO.Code
          AS Nit,
       TER.DigitVerification
          AS DV,
       PRO.Name
          AS Cliente,
       DIR.Addresss
          AS Direccion,
       CIU.Name
          AS Ciudad,
       TEL.Phone
          AS Telefono,
       EMA.Email
          AS Email,
       BAN.Code
          AS [Codigo de Banco],
       BAN.Name
          AS Banco,
       CASE CUE.Type WHEN 1 THEN 'AHORRO' WHEN 2 THEN 'CORRIENTE' END
          AS [Tipo de Cuenta],
       CUE.Number
          AS [Nro de Cuenta],
       CASE PRO.Status WHEN 1 THEN 'ACTIVO' ELSE 'INACTIVO' END
          AS Estado,
		  PRO.TimeLimitDays AS DiasDePlazo,  --se agrega campo por solicitud en caso 142927
		  case ExposeFactoring when 1 then '' when 0 then '' end as ExponerFactoring,
		 PRO.CreationDate AS [Fecha de Registro], --se agrega campo por solicitud en caso 142927
		CONCAT(PRO.ModificationUser,' - ',usmo.Fullname) AS UsuarioModifica,
		 PRO.ModificationDate AS FechaModifica
--li.Code + ' - ' + li.[Name]
--   AS [Linea de Distribucion]
FROM Common.Supplier PRO
     LEFT JOIN Common.SupplierBankAccount CUE ON PRO.Id = CUE.SupplierId
     LEFT JOIN Payroll.Bank BAN ON CUE.BankId = BAN.Id
     LEFT JOIN Common.Person PER ON PRO.Code = PER.IdentificationNumber
     LEFT JOIN Common.Address DIR ON DIR.IdPerson = PER.Id
     LEFT JOIN Common.City CIU ON PRO.IdCity = CIU.Id
     LEFT JOIN Common.Email EMA ON EMA.IdPerson = PER.Id
     LEFT JOIN Common.Phone TEL ON PER.Id = TEL.IdPerson
     LEFT JOIN Common.ThirdParty TER ON TER.Nit = PRO.Code
	 left join Security.[User] as usm on usm.UserCode = pro.ModificationUser
	 left join Security.[Person] as usmo on usmo.id=usm.IdPerson
where cue.State='1' --caso 264998
