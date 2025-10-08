-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_PAYROLL_NOMINACONTRATOS_INACTIVOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VW_PAYROLL_NOMINACONTRATOS_INACTIVOS] AS


SELECT  'Inactivo' as Est_Empleado,
--case when cc.code like 'N%' then 'Neiva' when  cc.code like 'T%' then 'Tunja' when  cc.code like 'F%' then 'Florencia' 
--	 when  cc.code like 'P%' then 'Pitalito'
-- when  cc.code like 'E%' then 'Abner'  
-- when  cc.code like 'C%' then 'Materno'  
--else 'Nacional' end as Sucursal,
TE.Name AS TipoEmpleado,
     --      CASE p.IdentificationType WHEN 0 THEN 'Cédula de Ciudadanía' WHEN 1 THEN 'Cédula de Extranjería' WHEN 2 THEN 'Tarjeta de Identidad' 
		   --WHEN 3 THEN 'Registro Civil' WHEN 4 THEN 'Pasporte' WHEN 5 THEN 'Adulto Sin Identificación' WHEN 6 THEN 'Menor Sin Identificación' WHEN 7 THEN 'Nit' END AS TipoIdentificacion, 
CASE p.IdentificationTypeId 
    WHEN  '0' THEN 'Cédula de Ciudadanía'
    WHEN  '1' THEN 'Cédula de Extranjería'
    WHEN  '2' THEN 'Tarjeta de Identidad'
    WHEN  '3' THEN 'Registro Civil'
    WHEN  '4' THEN 'Pasaporte'
    WHEN  '5' THEN 'Adulto Sin Identificación'
    WHEN  '6' THEN 'Menor Sin Identificación'
    WHEN  '7' THEN 'Número de Identificación Tributaria'
    WHEN  '8' THEN 'Número único de identificación personal'
    WHEN  '9' THEN 'Certificado de Nacido Vivo'
    WHEN  '10' THEN 'Carnet Diplomático'
    WHEN  '11' THEN 'Salvoconducto'
    WHEN  '12' THEN 'Permiso especial de Permanencia'
    WHEN  '13' THEN 'Permiso por Protección Temporal'
    WHEN  '14' THEN 'Documento extranjero'
    WHEN  '15' THEN 'Sin identificación'
    ELSE 'No especificado'
END AS TipoIdentificacion,
		   TP.Nit AS NumeroIdentificacion, p.FirstName + ' ' + p.SecondName AS Nombres, p.FirstLastName + ' ' + p.SecondLastName AS Apellidos, co.BasicSalary AS Salario, /*ca.Code + '  ' +*/ ca.Name AS Cargo, cc.Code as CodCentroCosto, cc.Name AS [Centro de Costo], fu.Code as UfCode, fu.Name AS UnidadFuncional, 
           co.JobBondingDate AS [Fecha de Contratación], co.ContractInitialDate AS [Fecha de Inicio], co.ContractEndingDate AS [Fecha de Finalización], CASE co.Status WHEN 1 THEN 'Activo' WHEN 2 THEN 'Liquidado' WHEN 3 THEN 'Anulado' WHEN 4 THEN 'Reemplazado' WHEN 5 THEN 'Parcialmente Retirado' ELSE '' END AS Estado, ISNULL(co.RetirementDate, '') 
           AS [Fecha Retiro], ISNULL(rr.Name, '') AS [Razón del Retiro], ct.Name AS [Tipo de Contrato], g.Code + ' - ' + g.Name AS Grupo, wc.Name AS [Centro Trabajo], ba.Name AS Banco, co.BankAccountNumber AS [Cuenta Bancaria], p.BirthDate AS FechaNaciomiento, c.Name AS LugarExpedicionID, 
           p.IdentificationExpeditionDate AS FechaExpedicionID, c1.Name AS CiudadNacimiento, CASE p.Gender WHEN 1 THEN 'H' WHEN 2 THEN 'M' WHEN 3 THEN 'Otro' END AS Genero, p.BloodGroup AS [Grupo Sanguineo], p.RH, p.Dependents AS [Personas a cargo], 
           CASE p.MaritalStatus WHEN 0 THEN 'Soltero' WHEN 1 THEN 'Casado' WHEN 2 THEN 'Divorciado' WHEN 3 THEN 'Viudo' WHEN 4 THEN 'Union libre' END AS EstadoCivil, MAX(d.Addresss) AS Dirección, MAX(ema.Email) AS Email, 
           CASE co.RowType WHEN 1 THEN 'Contrato Base' WHEN 2 THEN 'Novedad Contrato' ELSE '' END AS [Tipo de Registro], co.InitialContractNumber AS [Número de Contrato], 
           CASE DeclarantType WHEN 1 THEN 'No Declarante' WHEN 2 THEN 'Declarante' END AS Declarante, CASE co.Status WHEN 1 THEN 'Mensual' WHEN 2 THEN 'Quincenal' ELSE '' END AS [Perido de Pago], ISNULL(cmr.Name, '') AS [Razón de la Modificación del Contrato], E.ProfessionalRiskPercentage AS RiesgoProfesional, 
           MAX(TEL.Phone) AS TelFijo, MAX(mov.Phone) AS TelMovil, salud.Name AS FondoSalud, Pension.Name AS FondoPension, Cesantia.Name AS Cesantia, Riesgo.Name AS Riesgos, Caja.Name AS [Caja Compensacion],
		   Ciudad.Name AS Ciudad, ff.Name AS Departamento, YEAR(GETDATE()) - YEAR( p.BirthDate) as Edad
--		   , case when cc.Code  like 'N%' then 'Neiva' when  cc.Code  like 'T%' then 'Tunja' when  cc.Code  like 'F%' then 'Florencia' 
--	 when  cc.Code  like 'P%' then 'Pitalito'
-- when  cc.Code  like 'E%' then 'Abner'  
--else 'Nacional' end as SUCURSAL
FROM   [INDIGO031].Payroll.Employee AS E INNER JOIN
           [INDIGO031].Common.ThirdParty AS TP  ON TP.Id = E.ThirdPartyId INNER JOIN
           [INDIGO031].Common.Person AS p  ON p.Id = TP.PersonId LEFT OUTER JOIN
           [INDIGO031].Common.City AS c  ON c.Id = p.IdentificacionCityId INNER JOIN
           [INDIGO031].Common.City AS c1  ON c1.Id = p.BirthCityId LEFT OUTER JOIN
           [INDIGO031].Common.Address AS d ON d.IdPerson = p.Id LEFT OUTER JOIN
           [INDIGO031].Common.City AS Ciudad  ON Ciudad.Id = d.CityId LEFT OUTER JOIN
           [INDIGO031].Common.Department AS ff  ON ff.Id = d.DepartmentId LEFT OUTER JOIN
           (SELECT max (co.Id) as Id, EmployeeId, Status, Valid, max(co.PositionId) as idp, max(PositionId) as positionid, FunctionalUnitId, ContractTypeId, GroupId,
					RetirementReasonId, max(ContractModificationReasonId) as ContractModificationReasonId, BankId, ProfessionalRiskLevelId, max(RowType) as RowType,
					max(BasicSalary) as BasicSalary, max(JobBondingDate) as JobBondingDate, max(ContractInitialDate) as ContractInitialDate,  max(ContractEndingDate) as ContractEndingDate,
					max(RetirementDate) as RetirementDate, BankAccountNumber, max(InitialContractNumber) as InitialContractNumber
			FROM [INDIGO031].Payroll.Contract as co inner join
			    [INDIGO031].Payroll.Position AS ca  ON ca.Id = co.PositionId left outer join
				[INDIGO031].Payroll.ContractModificationReason AS cmr ON co.ContractModificationReasonId = cmr.Id
			WHERE Valid='0' and Status='2' --and co.employeeid='277'
			group by EmployeeId, Status, Valid, FunctionalUnitId, ContractTypeId, GroupId, RetirementReasonId, BankId, ProfessionalRiskLevelId, BankAccountNumber) AS co  ON co.EmployeeId = E.Id LEFT OUTER JOIN
			  [INDIGO031].Payroll.Position AS ca  on ca.Id=co.positionid left outer join
           [INDIGO031].Payroll.FunctionalUnit AS fu  ON fu.Id = co.FunctionalUnitId INNER JOIN
           [INDIGO031].Payroll.ContractType AS ct  ON co.ContractTypeId = ct.Id INNER JOIN
           [INDIGO031].Payroll.[Group] AS g  ON co.GroupId = g.Id INNER JOIN
           [INDIGO031].Payroll.CostCenter AS cc  ON fu.CostCenterId = cc.Id LEFT OUTER JOIN
           [INDIGO031].Payroll.RetirementReason AS rr  ON co.RetirementReasonId = rr.Id LEFT OUTER JOIN
           [INDIGO031].Common.Email AS ema ON ema.IdPerson = p.Id LEFT OUTER JOIN
           [INDIGO031].Payroll.Bank AS ba  ON ba.Id = co.BankId LEFT OUTER JOIN
           [INDIGO031].Payroll.FundContract AS fc ON fc.ContractId = co.Id AND fc.FundType = '1' LEFT OUTER JOIN
		   [INDIGO031].Payroll.ContractModificationReason AS cmr ON co.ContractModificationReasonId = cmr.Id left outer join
           [INDIGO031].Payroll.Fund AS salud  ON salud.Id = fc.FundId LEFT OUTER JOIN
           [INDIGO031].Payroll.FundContract AS fc1 ON fc1.ContractId = co.Id AND fc1.FundType = '3' LEFT OUTER JOIN
           [INDIGO031].Payroll.Fund AS Cesantia  ON Cesantia.Id = fc1.FundId LEFT OUTER JOIN
               (SELECT fc.ContractId, fun.Name
              FROM   [INDIGO031].Payroll.FundContract AS fc LEFT OUTER JOIN
                         [INDIGO031].Payroll.Fund AS fun  ON fun.Id = fc.FundId
              WHERE (fc.FundType = '2') AND (fc.VoluntaryContribution = '0')) AS Pension ON Pension.ContractId = co.Id LEFT OUTER JOIN
               (SELECT fc.ContractId, fun.Name
              FROM   [INDIGO031].Payroll.FundContract AS fc LEFT OUTER JOIN
                         [INDIGO031].Payroll.Fund AS fun  ON fun.Id = fc.FundId
              WHERE (fc.FundType = '4')) AS Riesgo ON Riesgo.ContractId = co.Id LEFT OUTER JOIN
               (SELECT fc.ContractId, fun.Name
              FROM   [INDIGO031].Payroll.FundContract AS fc LEFT OUTER JOIN
                         [INDIGO031].Payroll.Fund AS fun  ON fun.Id = fc.FundId
              WHERE (fc.FundType = '5')) AS Caja ON Caja.ContractId = co.Id LEFT OUTER JOIN
           [INDIGO031].Payroll.WorkCenter AS wc  ON wc.Id = E.WorkCenterId LEFT OUTER JOIN
           [INDIGO031].Common.Phone AS TEL ON TEL.IdPerson = p.Id AND TEL.IdPhoneType = '1' LEFT OUTER JOIN
           [INDIGO031].Common.Phone AS mov ON mov.IdPerson = p.Id AND mov.IdPhoneType = '2' LEFT OUTER JOIN
           [INDIGO031].Payroll.EmployeeType AS TE  ON TE.Id = E.EmployeeTypeId LEFT OUTER JOIN
           [INDIGO031].Payroll.ProfessionalRisk AS PSR  ON PSR.Id = co.ProfessionalRiskLevelId
WHERE (co.Status = '2') and 
  co.Valid='0' and rr.Name IS not null
  and  E.Id not in (select EmployeeId
									from [INDIGO031].Payroll.Contract 
									where Valid='1')
GROUP BY TE.Name, p.IdentificationType, TP.Nit, p.FirstName, p.SecondName, p.FirstLastName, p.SecondLastName, co.BasicSalary, ca.Code, ca.Name, cc.Code, cc.Name, fu.Code, fu.Name,  co.Status, co.RetirementDate, rr.Name, ct.Name, g.Code, g.Name, wc.Name, 
           ba.Name, co.BankAccountNumber, p.BirthDate, c.Name, p.IdentificationExpeditionDate, c1.Name, p.Gender, p.BloodGroup, p.RH, p.Dependents, p.MaritalStatus, co.RowType, co.InitialContractNumber, JobBondingDate, ContractInitialDate, ContractEndingDate--,co.TrialPeriod, co.TrialPeriodTime, 
		   ,E.DeclarantType, co.Status, cmr.Name, 
		   E.ProfessionalRiskPercentage, salud.Name, 
           Pension.Name, Cesantia.Name, Riesgo.Name, Caja.Name, Ciudad.Name, ff.Name,E.Id,  RetirementReasonId, E.Id, p.IdentificationTypeId
