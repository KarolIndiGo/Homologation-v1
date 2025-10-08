-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_PAYROLL_NOMINACONTRATOS_INACTIVOS_IMO
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[Payroll_NominaContratos_Inactivos_IMO]
AS

SELECT 
    'Inactivo' AS Est_Empleado,
    TE.Name AS TipoEmpleado,
    CASE p.IdentificationTypeId 
        WHEN '0'  THEN 'Cédula de Ciudadanía'
        WHEN '1'  THEN 'Cédula de Extranjería'
        WHEN '2'  THEN 'Tarjeta de Identidad'
        WHEN '3'  THEN 'Registro Civil'
        WHEN '4'  THEN 'Pasaporte'
        WHEN '5'  THEN 'Adulto Sin Identificación'
        WHEN '6'  THEN 'Menor Sin Identificación'
        WHEN '7'  THEN 'Número de Identificación Tributaria'
        WHEN '8'  THEN 'Número único de identificación personal'
        WHEN '9'  THEN 'Certificado de Nacido Vivo'
        WHEN '10' THEN 'Carnet Diplomático'
        WHEN '11' THEN 'Salvoconducto'
        WHEN '12' THEN 'Permiso especial de Permanencia'
        WHEN '13' THEN 'Permiso por Protección Temporal'
        WHEN '14' THEN 'Documento extranjero'
        WHEN '15' THEN 'Sin identificación'
        ELSE 'No especificado'
    END AS TipoIdentificacion,
    TP.Nit AS NumeroIdentificacion,
    p.FirstName + ' ' + p.SecondName AS Nombres,
    p.FirstLastName + ' ' + p.SecondLastName AS Apellidos,
    co.BasicSalary AS Salario,
    /*ca.Code + '  ' +*/ ca.Name AS Cargo,
    cc.Code AS CodCentroCosto,
    cc.Name AS [Centro de Costo],
    fu.Code AS UfCode,
    fu.Name AS UnidadFuncional,
    co.JobBondingDate AS [Fecha de Contratación],
    co.ContractInitialDate AS [Fecha de Inicio],
    co.ContractEndingDate AS [Fecha de Finalización],
    CASE co.Status
        WHEN 1 THEN 'Activo'
        WHEN 2 THEN 'Liquidado'
        WHEN 3 THEN 'Anulado'
        WHEN 4 THEN 'Reemplazado'
        WHEN 5 THEN 'Parcialmente Retirado'
        ELSE ''
    END AS Estado,
    ISNULL(co.RetirementDate, '') AS [Fecha Retiro],
    ISNULL(rr.Name, '') AS [Razón del Retiro],
    ct.Name AS [Tipo de Contrato],
    g.Code + ' - ' + g.Name AS Grupo,
    wc.Name AS [Centro Trabajo],
    ba.Name AS Banco,
    co.BankAccountNumber AS [Cuenta Bancaria],
    p.BirthDate AS FechaNaciomiento,
    c.Name AS LugarExpedicionID,
    p.IdentificationExpeditionDate AS FechaExpedicionID,
    c1.Name AS CiudadNacimiento,
    CASE p.Gender WHEN 1 THEN 'H' WHEN 2 THEN 'M' WHEN 3 THEN 'Otro' END AS Genero,
    p.BloodGroup AS [Grupo Sanguineo],
    p.RH,
    p.Dependents AS [Personas a cargo],
    CASE p.MaritalStatus
        WHEN 0 THEN 'Soltero'
        WHEN 1 THEN 'Casado'
        WHEN 2 THEN 'Divorciado'
        WHEN 3 THEN 'Viudo'
        WHEN 4 THEN 'Union libre'
    END AS EstadoCivil,
    MAX(d.Addresss) AS Dirección,
    MAX(ema.Email) AS Email,
    CASE co.RowType WHEN 1 THEN 'Contrato Base' WHEN 2 THEN 'Novedad Contrato' ELSE '' END AS [Tipo de Registro],
    co.InitialContractNumber AS [Número de Contrato],
    CASE DeclarantType WHEN 1 THEN 'No Declarante' WHEN 2 THEN 'Declarante' END AS Declarante,
    CASE co.Status WHEN 1 THEN 'Mensual' WHEN 2 THEN 'Quincenal' ELSE '' END AS [Perido de Pago],
    ISNULL(cmr.Name, '') AS [Razón de la Modificación del Contrato],
    E.ProfessionalRiskPercentage AS RiesgoProfesional,
    MAX(TEL.Phone) AS TelFijo,
    MAX(mov.Phone) AS TelMovil,
    salud.Name AS FondoSalud,
    Pension.Name AS FondoPension,
    Cesantia.Name AS Cesantia,
    Riesgo.Name AS Riesgos,
    Caja.Name AS [Caja Compensacion],
    Ciudad.Name AS Ciudad,
    ff.Name AS Departamento,
    YEAR(GETDATE()) - YEAR(p.BirthDate) AS Edad
FROM [INDIGO035].[Payroll].[Employee] AS E
INNER JOIN [INDIGO035].[Common].[ThirdParty] AS TP
    ON TP.Id = E.ThirdPartyId
INNER JOIN [INDIGO035].[Common].[Person] AS p
    ON p.Id = TP.PersonId
LEFT OUTER JOIN [INDIGO035].[Common].[City] AS c
    ON c.Id = p.IdentificacionCityId
INNER JOIN [INDIGO035].[Common].[City] AS c1
    ON c1.Id = p.BirthCityId
LEFT OUTER JOIN [INDIGO035].[Common].[Address] AS d
    ON d.IdPerson = p.Id
LEFT OUTER JOIN [INDIGO035].[Common].[City] AS Ciudad
    ON Ciudad.Id = d.CityId
LEFT OUTER JOIN [INDIGO035].[Common].[Department] AS ff
    ON ff.Id = d.DepartmentId
LEFT OUTER JOIN (
    SELECT 
        MAX(co.Id) AS Id,
        EmployeeId,
        Status,
        Valid,
        MAX(co.PositionId) AS idp,
        MAX(PositionId) AS positionid,
        FunctionalUnitId,
        ContractTypeId,
        GroupId,
        RetirementReasonId,
        MAX(ContractModificationReasonId) AS ContractModificationReasonId,
        BankId,
        ProfessionalRiskLevelId,
        MAX(RowType) AS RowType,
        MAX(BasicSalary) AS BasicSalary,
        MAX(JobBondingDate) AS JobBondingDate,
        MAX(ContractInitialDate) AS ContractInitialDate,
        MAX(ContractEndingDate) AS ContractEndingDate,
        MAX(RetirementDate) AS RetirementDate,
        BankAccountNumber,
        MAX(InitialContractNumber) AS InitialContractNumber
    FROM [INDIGO035].[Payroll].[Contract] AS co
    INNER JOIN [INDIGO035].[Payroll].[Position] AS ca
        ON ca.Id = co.PositionId
    LEFT OUTER JOIN [INDIGO035].[Payroll].[ContractModificationReason] AS cmr
        ON co.ContractModificationReasonId = cmr.Id
    WHERE Valid = '0' AND Status = '2'
    GROUP BY EmployeeId, Status, Valid, FunctionalUnitId, ContractTypeId, GroupId, RetirementReasonId, BankId, ProfessionalRiskLevelId, BankAccountNumber
) AS co
    ON co.EmployeeId = E.Id
LEFT OUTER JOIN [INDIGO035].[Payroll].[Position] AS ca
    ON ca.Id = co.positionid
LEFT OUTER JOIN [INDIGO035].[Payroll].[FunctionalUnit] AS fu
    ON fu.Id = co.FunctionalUnitId
INNER JOIN [INDIGO035].[Payroll].[ContractType] AS ct
    ON co.ContractTypeId = ct.Id
INNER JOIN [INDIGO035].[Payroll].[Group] AS g
    ON co.GroupId = g.Id
INNER JOIN [INDIGO035].[Payroll].[CostCenter] AS cc
    ON fu.CostCenterId = cc.Id
LEFT OUTER JOIN [INDIGO035].[Payroll].[RetirementReason] AS rr
    ON co.RetirementReasonId = rr.Id
LEFT OUTER JOIN [INDIGO035].[Common].[Email] AS ema
    ON ema.IdPerson = p.Id
LEFT OUTER JOIN [INDIGO035].[Payroll].[Bank] AS ba
    ON ba.Id = co.BankId
LEFT OUTER JOIN [INDIGO035].[Payroll].[FundContract] AS fc
    ON fc.ContractId = co.Id AND fc.FundType = '1'
LEFT OUTER JOIN [INDIGO035].[Payroll].[ContractModificationReason] AS cmr
    ON co.ContractModificationReasonId = cmr.Id
LEFT OUTER JOIN [INDIGO035].[Payroll].[Fund] AS salud
    ON salud.Id = fc.FundId
LEFT OUTER JOIN [INDIGO035].[Payroll].[FundContract] AS fc1
    ON fc1.ContractId = co.Id AND fc1.FundType = '3'
-- ►► JOIN agregado para Cesantías
LEFT OUTER JOIN [INDIGO035].[Payroll].[Fund] AS Cesantia
    ON Cesantia.Id = fc1.FundId
-- ◄◄
LEFT OUTER JOIN (
    SELECT fc.ContractId, fun.Name
    FROM [INDIGO035].[Payroll].[FundContract] AS fc
    LEFT OUTER JOIN [INDIGO035].[Payroll].[Fund] AS fun
        ON fun.Id = fc.FundId
    WHERE (fc.FundType = '2') AND (fc.VoluntaryContribution = '0')
) AS Pension
    ON Pension.ContractId = co.Id
LEFT OUTER JOIN (
    SELECT fc.ContractId, fun.Name
    FROM [INDIGO035].[Payroll].[FundContract] AS fc
    LEFT OUTER JOIN [INDIGO035].[Payroll].[Fund] AS fun
        ON fun.Id = fc.FundId
    WHERE (fc.FundType = '4')
) AS Riesgo
    ON Riesgo.ContractId = co.Id
LEFT OUTER JOIN (
    SELECT fc.ContractId, fun.Name
    FROM [INDIGO035].[Payroll].[FundContract] AS fc
    LEFT OUTER JOIN [INDIGO035].[Payroll].[Fund] AS fun
        ON fun.Id = fc.FundId
    WHERE (fc.FundType = '5')
) AS Caja
    ON Caja.ContractId = co.Id
LEFT OUTER JOIN [INDIGO035].[Payroll].[WorkCenter] AS wc
    ON wc.Id = E.WorkCenterId
LEFT OUTER JOIN [INDIGO035].[Common].[Phone] AS TEL
    ON TEL.IdPerson = p.Id AND TEL.IdPhoneType = '1'
LEFT OUTER JOIN [INDIGO035].[Common].[Phone] AS mov
    ON mov.IdPerson = p.Id AND mov.IdPhoneType = '2'
LEFT OUTER JOIN [INDIGO035].[Payroll].[EmployeeType] AS TE
    ON TE.Id = E.EmployeeTypeId
LEFT OUTER JOIN [INDIGO035].[Payroll].[ProfessionalRisk] AS PSR
    ON PSR.Id = co.ProfessionalRiskLevelId
WHERE (co.Status = '2')
  AND co.Valid = '0'
  AND rr.Name IS NOT NULL
  AND E.Id NOT IN (
        SELECT EmployeeId
        FROM [INDIGO035].[Payroll].[Contract]
        WHERE Valid = '1'
  )
GROUP BY 
    TE.Name,
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
    co.Status,
    co.RetirementDate,
    rr.Name,
    ct.Name,
    g.Code,
    g.Name,
    wc.Name,
    ba.Name,
    co.BankAccountNumber,
    p.BirthDate,
    c.Name,
    p.IdentificationExpeditionDate,
    c1.Name,
    p.Gender,
    p.BloodGroup,
    p.RH,
    p.Dependents,
    p.MaritalStatus,
    co.RowType,
    co.InitialContractNumber,
    JobBondingDate,
    ContractInitialDate,
    ContractEndingDate--,co.TrialPeriod, co.TrialPeriodTime,
    ,E.DeclarantType,
    co.Status,
    cmr.Name,
    E.ProfessionalRiskPercentage,
    salud.Name,
    Pension.Name,
    Cesantia.Name,
    Riesgo.Name,
    Caja.Name,
    Ciudad.Name,
    ff.Name,
    E.Id,
    RetirementReasonId,
    E.Id,
    p.IdentificationTypeId;