-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_NominaActivos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

create VIEW [ViewInternal].[IMO_NominaActivos]
AS
SELECT DISTINCT 
             LTRIM(TP.Nit) AS NumeroIdentificacion, 
             CASE p.IdentificationType WHEN 0 THEN 'Cédula de Ciudadanía' WHEN 1 THEN 'Cédula de Extranjería' WHEN 2 THEN 'Tarjeta de Identidad' WHEN 3 THEN 'Registro Civil' WHEN 4 THEN 'Pasporte' WHEN 5 THEN 'Adulto Sin Identificación' WHEN 6 THEN 'Menor Sin Identificación' WHEN 7
              THEN 'Nit' END AS TipoIdentificacion, p.FirstName + ' ' + p.SecondName + ' ' + p.FirstLastName + ' ' + p.SecondLastName AS Nombre, MAX(ca.Name) AS Cargo, MAX(cc.Code) + '  ' + MAX(cc.Name) AS [Centro de Costo], MAX(fu.Code) + '  ' + MAX(fu.Name) AS UnidadFuncional, 
             wc.Name AS [Centro Trabajo], c1.Name AS CiudadNacimiento, d.Direccion, ema.Email, MAX(TEL.Phone) AS Fijo, MAX(mov.Phone) AS Movil, CASE MAX(co.Estado) WHEN 1 THEN 'Activo' WHEN 2 THEN 'Inactivo' WHEN 3 THEN 'Inactivo' WHEN 4 THEN 'Activo' END AS Estado, 
             TE.Name AS TipoEmpleado
FROM   Payroll.Employee AS E LEFT OUTER JOIN
             Common.ThirdParty AS TP ON TP.Id = E.ThirdPartyId LEFT OUTER JOIN
             Common.Person AS p ON p.Id = TP.PersonId LEFT OUTER JOIN
             Common.City AS c ON c.Id = p.IdentificacionCityId LEFT OUTER JOIN
             Common.City AS c1 ON c1.Id = p.BirthCityId LEFT OUTER JOIN
                 (SELECT IdPerson, Addresss AS Direccion
                 FROM    Common.Address) AS d ON d.IdPerson = p.Id LEFT OUTER JOIN
                 (SELECT MAX(Id) AS id, EmployeeId, PositionId, FunctionalUnitId, MAX(Status) AS Estado
                 FROM    Payroll.Contract
                 GROUP BY EmployeeId, PositionId, FunctionalUnitId) AS co ON co.EmployeeId = E.Id LEFT OUTER JOIN
                 (SELECT MAX(Id) AS Id, Name, Code
                 FROM    Payroll.Position
                 GROUP BY Name, Code) AS ca ON ca.Id = co.PositionId LEFT OUTER JOIN
                 (SELECT MAX(Id) AS id, Code, Name, CostCenterId
                 FROM    Payroll.FunctionalUnit
                 GROUP BY Code, Name, CostCenterId) AS fu ON fu.id = co.FunctionalUnitId INNER JOIN
                 (SELECT MAX(Id) AS Id, Name, Code
                 FROM    Payroll.CostCenter
                 GROUP BY Name, Code) AS cc ON fu.CostCenterId = cc.Id LEFT OUTER JOIN
                 (SELECT IdPerson, Email
                 FROM    Common.Email) AS ema ON ema.IdPerson = p.Id LEFT OUTER JOIN
             Payroll.WorkCenter AS wc ON wc.Id = E.WorkCenterId LEFT OUTER JOIN
             Common.Phone AS TEL ON TEL.IdPerson = p.Id AND TEL.IdPhoneType = '1' LEFT OUTER JOIN
             Common.Phone AS mov ON mov.IdPerson = p.Id AND mov.IdPhoneType = '2' LEFT OUTER JOIN
             Payroll.EmployeeType AS TE ON TE.Id = E.EmployeeTypeId
GROUP BY TP.Nit, p.Id, p.IdentificationType, p.FirstName, p.SecondName, p.FirstLastName, p.SecondLastName, wc.Name, c1.Name, d.Direccion, ema.Email, E.State, TE.Name
