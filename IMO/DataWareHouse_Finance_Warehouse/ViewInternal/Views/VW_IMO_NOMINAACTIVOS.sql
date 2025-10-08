-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_NOMINAACTIVOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IMO_NominaActivos]
AS

SELECT DISTINCT 
    LTRIM(TP.Nit) AS NumeroIdentificacion, 
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
    p.FirstName + ' ' + p.SecondName + ' ' + p.FirstLastName + ' ' + p.SecondLastName AS Nombre, 
    MAX(ca.Name) AS Cargo, 
    MAX(cc.Code) + '  ' + MAX(cc.Name) AS [Centro de Costo], 
    MAX(fu.Code) + '  ' + MAX(fu.Name) AS UnidadFuncional, 
    wc.Name AS [Centro Trabajo], 
    c1.Name AS CiudadNacimiento, 
    d.Direccion, 
    ema.Email, 
    MAX(TEL.Phone) AS Fijo, 
    MAX(mov.Phone) AS Movil, 
    CASE MAX(co.Estado) 
        WHEN 1 THEN 'Activo' 
        WHEN 2 THEN 'Inactivo' 
        WHEN 3 THEN 'Inactivo' 
        WHEN 4 THEN 'Activo' 
    END AS Estado, 
    TE.Name AS TipoEmpleado
FROM [INDIGO035].[Payroll].[Employee] AS E 
LEFT OUTER JOIN [INDIGO035].[Common].[ThirdParty] AS TP 
    ON TP.Id = E.ThirdPartyId 
LEFT OUTER JOIN [INDIGO035].[Common].[Person] AS p 
    ON p.Id = TP.PersonId 
LEFT OUTER JOIN [INDIGO035].[Common].[City] AS c 
    ON c.Id = p.IdentificacionCityId 
LEFT OUTER JOIN [INDIGO035].[Common].[City] AS c1 
    ON c1.Id = p.BirthCityId 
LEFT OUTER JOIN (
    SELECT IdPerson, Addresss AS Direccion
    FROM [INDIGO035].[Common].[Address]
) AS d 
    ON d.IdPerson = p.Id 
LEFT OUTER JOIN (
    SELECT MAX(Id) AS Id, EmployeeId, PositionId, FunctionalUnitId, MAX(Status) AS Estado
    FROM [INDIGO035].[Payroll].[Contract]
    GROUP BY EmployeeId, PositionId, FunctionalUnitId
) AS co 
    ON co.EmployeeId = E.Id 
LEFT OUTER JOIN (
    SELECT MAX(Id) AS Id, Name, Code
    FROM [INDIGO035].[Payroll].[Position]
    GROUP BY Name, Code
) AS ca 
    ON ca.Id = co.PositionId 
LEFT OUTER JOIN (
    SELECT MAX(Id) AS Id, Code, Name, CostCenterId
    FROM [INDIGO035].[Payroll].[FunctionalUnit]
    GROUP BY Code, Name, CostCenterId
) AS fu 
    ON fu.Id = co.FunctionalUnitId 
INNER JOIN (
    SELECT MAX(Id) AS Id, Name, Code
    FROM [INDIGO035].[Payroll].[CostCenter]
    GROUP BY Name, Code
) AS cc 
    ON fu.CostCenterId = cc.Id 
LEFT OUTER JOIN (
    SELECT IdPerson, Email
    FROM [INDIGO035].[Common].[Email]
) AS ema 
    ON ema.IdPerson = p.Id 
LEFT OUTER JOIN [INDIGO035].[Payroll].[WorkCenter] AS wc 
    ON wc.Id = E.WorkCenterId 
LEFT OUTER JOIN [INDIGO035].[Common].[Phone] AS TEL 
    ON TEL.IdPerson = p.Id AND TEL.IdPhoneType = '1' 
LEFT OUTER JOIN [INDIGO035].[Common].[Phone] AS mov 
    ON mov.IdPerson = p.Id AND mov.IdPhoneType = '2' 
LEFT OUTER JOIN [INDIGO035].[Payroll].[EmployeeType] AS TE 
    ON TE.Id = E.EmployeeTypeId
GROUP BY 
    TP.Nit, 
    p.Id, 
    p.IdentificationType, 
    p.FirstName, 
    p.SecondName, 
    p.FirstLastName, 
    p.SecondLastName, 
    wc.Name, 
    c1.Name, 
    d.Direccion, 
    ema.Email, 
    E.State, 
    TE.Name;