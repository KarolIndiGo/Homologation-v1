-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Listado_Talento_Humano_General
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[Listado_Talento_Humano_General]
AS
SELECT TE.Name AS TipoEmpleado,
		CASE p.IdentificationType
			WHEN 0 THEN 'Cédula de Ciudadanía'
			WHEN 1 THEN 'Cédula de Extranjería'
			WHEN 2 THEN 'Tarjeta de Identidad'
			WHEN 3 THEN 'Registro Civil'
			WHEN 4 THEN 'Pasporte'
			WHEN 5 THEN 'Adulto Sin Identificación'
			WHEN 6 THEN 'Menor Sin Identificación'
			WHEN 7 THEN 'Nit'
		END AS TipoIdentificacion,
		TP.Nit AS NumeroIdentificacion,
		p.FirstName + ' ' + p.SecondName AS Nombres,
		p.FirstLastName + ' ' + p.SecondLastName AS Apellidos,
		co.BasicSalary AS Salario,
		ca.Code + ' ' + ca.Name AS Cargo,
		cc.Code + ' ' + cc.Name AS [Centro de Costo],
		fu.Code + ' ' + fu.Name AS UnidadFuncional,
		co.JobBondingDate AS [Fecha de Contratación],
		co.ContractInitialDate AS [Fecha de Inicio],
		co.ContractEndingDate AS [Fecha de Finalización],
		CASE co.Status
			WHEN 1 THEN 'Activo'
			WHEN 2 THEN 'Liquidado'
			WHEN 3 THEN 'Anulado'
			WHEN 4 THEN 'Reemplazado'
			ELSE ''
		END AS Estado,
		ISNULL (co.RetirementDate, '') AS [Fecha Retiro]
		--ISNULL (rr.Name, '') AS [Razón del Retiro]
		--ct.Name AS [Tipo de Contrato],
		--g.Code + ' - ' + g.Name AS Grupo,
		--wc.Name AS [Centro Trabajo],
		--ba.Name AS Banco,
		--co.BankAccountNumber AS [Cuenta Bancaria],
		--p.BirthDate AS FechaNaciomiento,
		--c.Name AS LugarExpedicionID,
		--p.IdentificationExpeditionDate AS FechaExpedicionID,
		--c1.Name AS CiudadNacimiento,
		--CASE p.Gender
		--	WHEN 1 THEN 'Masculino'
		--	WHEN 2 THEN 'Femenino'
		--	WHEN 3 THEN 'Otro'
		--END AS Genero,
		--p.BloodGroup AS [Grupo Sanguineo],
		--p.RH,
		--p.Dependents AS [Personas a cargo],
		--CASE p.MaritalStatus
		--	WHEN 0 THEN 'Soltero'
		--	WHEN 1 THEN 'Casado'
		--	WHEN 2 THEN 'Divorciado'
		--	WHEN 3 THEN 'Viudo'
		--	WHEN 4 THEN 'Union libre'
		--END AS EstadoCivil,
		--MAX (d.Addresss) AS Dirección,
		--MAX (ema.Email) AS Email,
		--CASE cO.RowType
		--	WHEN 1 THEN 'Contrato Base'
		--	WHEN 2 THEN 'Novedad Contrato'
		--	ELSE ''
		--END AS [Tipo de Registro],
		--co.InitialContractNumber AS [Número de Contrato],
		--CASE co.TrialPeriod WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END AS [Periodo Prueba],
		--co.TrialPeriodTime
		--AS [Tiempo Periodo Prueba (Dias)],
		--CASE DeclarantType
		--	WHEN 1 THEN 'No Declarante'
		--	WHEN 2 THEN 'Declarante'
		--END AS Declarante,
		--CASE cO.Status
		--	WHEN 1 THEN 'Mensual'
		--	WHEN 2 THEN 'Quincenal'
		--	ELSE ''
		--END AS [Perido de Pago],
		--ISNULL (cmr.Name, '')
		--AS [Razón de la Modificación del Contrato],
		--E.ProfessionalRiskPercentage AS RiesgoProfesional,
		--MAX (TEL.Phone) AS TelFijo,
		--MAX (mov.Phone) AS TelMovil,
		--salud.Name AS FondoSalud,
		--Pension.Name AS FondoPension,
		--Cesantia.Name AS Cesantia,
		--Riesgo.Name AS Riesgos,
		--Caja.Name AS [Caja Compensacion],
		--Ciudad.Name AS Ciudad,
		--ff.Name AS Departamento --, ps.name as [Centro Estudio]
FROM Payroll.Employee AS E
		INNER JOIN Common.ThirdParty AS TP ON TP.Id = E.ThirdPartyId
		LEFT OUTER JOIN Common.Person AS p ON p.Id = TP.PersonId
		LEFT OUTER JOIN Common.City AS c ON c.Id = p.IdentificacionCityId
		LEFT OUTER JOIN Common.City AS c1 ON c1.Id = p.BirthCityId
		LEFT OUTER JOIN Common.Address AS d ON d.IdPerson = p.Id
		LEFT OUTER JOIN Common.City AS Ciudad ON Ciudad.Id = d.CityId
		LEFT OUTER JOIN Common.Department AS ff ON ff.Id = d.DepartmentId
		LEFT OUTER JOIN Payroll.Contract AS co ON co.EmployeeId = E.Id-- AND co.Valid = '1'
		LEFT OUTER JOIN Payroll.Position AS ca ON ca.Id = co.PositionId
		LEFT OUTER JOIN Payroll.FunctionalUnit AS fu ON fu.Id = co.FunctionalUnitId
		LEFT OUTER JOIN Payroll.ContractType AS ct ON co.ContractTypeId = ct.Id
		LEFT OUTER JOIN Payroll.[Group] AS g ON co.GroupId = g.Id
		LEFT OUTER JOIN Payroll.CostCenter AS cc ON fu.CostCenterId = cc.Id
		--LEFT OUTER JOIN Payroll.RetirementReason AS rr ON co.RetirementReasonId = rr.Id
		--LEFT OUTER JOIN Payroll.ContractModificationReason AS cmr ON co.ContractModificationReasonId = cmr.Id
		--LEFT OUTER JOIN Common.Email AS ema ON ema.IdPerson = p.Id
		--LEFT OUTER JOIN Payroll.Bank AS ba ON ba.Id = co.BankId
		--LEFT OUTER JOIN Payroll.FundContract AS fc ON fc.ContractId = co.Id AND fc.FundType = '1' AND fc.State = '1'
		--LEFT OUTER JOIN Payroll.Fund AS salud ON salud.Id = fc.FundId
		--LEFT OUTER JOIN Payroll.FundContract AS fc1 ON fc1.ContractId = co.Id AND fc1.FundType = '3' AND fc1.State = '1'
		--LEFT OUTER JOIN Payroll.Fund AS Cesantia ON Cesantia.Id = fc1.FundId
		LEFT OUTER JOIN
			(SELECT fc.ContractId, fun.Name
			FROM Payroll.FundContract AS fc
			LEFT OUTER JOIN Payroll.Fund AS fun
			ON fun.Id = fc.FundId
			WHERE (fc.FundType = '2')
			AND (fc.VoluntaryContribution = '0')
			AND (fc.State = '1')) AS Pension ON Pension.ContractId = co.Id
		LEFT OUTER JOIN
			(SELECT fc.ContractId, fun.Name
			FROM Payroll.FundContract AS fc
			LEFT OUTER JOIN Payroll.Fund AS fun
			ON fun.Id = fc.FundId
			WHERE (fc.FundType = '4') AND (fc.State = '1')) AS Riesgo ON Riesgo.ContractId = co.Id
		LEFT OUTER JOIN
			(SELECT fc.ContractId, fun.Name
			FROM Payroll.FundContract AS fc
			LEFT OUTER JOIN Payroll.Fund AS fun
			ON fun.Id = fc.FundId
			WHERE (fc.FundType = '5') AND (fc.State = '1')) AS Caja ON Caja.ContractId = co.Id
		LEFT OUTER JOIN Payroll.WorkCenter AS wc ON wc.Id = E.WorkCenterId
		LEFT OUTER JOIN Common.Phone AS TEL ON TEL.IdPerson = p.Id AND TEL.IdPhoneType = '12'
		LEFT OUTER JOIN Common.Phone AS mov ON mov.IdPerson = p.Id AND mov.IdPhoneType = '13'
		LEFT OUTER JOIN Payroll.EmployeeType AS TE ON TE.Id = E.EmployeeTypeId
		LEFT OUTER JOIN Payroll.ProfessionalRisk AS PSR ON PSR.Id = ca.ProfessionalRiskLevelId 
		--left outer join Common.PersonStudy as pp on pp.personid=p.id 
		--left outer join Payroll.StudyCenter as ps on ps.id=pp.studycenterid
--WHERE (E.State = '1')
--		AND (p.State = '1')
--		AND (co.Status = '1')
--		AND (co.Valid = '1')
GROUP BY TE.Name,
		p.IdentificationType,
		TP.Nit,
		p.FirstName,
		p.SecondName,
		p.FirstLastName,
		p.SecondLastName,
		co.BasicSalary,
		ca.Code,
		ca.Name,
		cc.Code,
		cc.Name,
		fu.Code,
		fu.Name,
		co.JobBondingDate,
		co.ContractInitialDate,
		co.ContractEndingDate,
		co.Status,
		co.RetirementDate
		--rr.Name,
		--ct.Name,
		--g.Code,
		--g.Name,
		--wc.Name,
		--ba.Name,
		--co.BankAccountNumber,
		--p.BirthDate,
		--c.Name,
		--p.IdentificationExpeditionDate,
		--c1.Name,
		--p.Gender,
		--p.BloodGroup,
		--p.RH,
		--p.Dependents,
		--p.MaritalStatus,
		--co.RowType,
		--co.InitialContractNumber,
		--co.TrialPeriod,
		--co.TrialPeriodTime,
		--E.DeclarantType,
		--co.Status,
		--cmr.Name,
		--E.ProfessionalRiskPercentage,
		--salud.Name,
		--Pension.Name,
		--Cesantia.Name,
		--Riesgo.Name,
		--Caja.Name,
		--Ciudad.Name,
		--ff.Name
