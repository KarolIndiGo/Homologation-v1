-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewListadoPersonalRetirado
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[ViewListadoPersonalRetirado] as
SELECT 
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,  
 ROW_NUMBER() OVER(ORDER BY TP.Nit ASC) AS Row#,
 TP.Nit AS CÉDULA_CIUDADANÍA, TP.NAME NOMBRE_EMPLEADO, BO.Name AS SEDE, pos.Name AS CARGO, CC.Name AS CENTRO_DE_COSTO, C.JobBondingDate AS FECHA_INGRESO, 
 RR.Name AS RAZÓN_RETIRO, 
 YEAR(C.RetirementDate) AS AÑO_RETIRO,
 (SELECT DATENAME (MONTH, DATEADD(MONTH, MONTH(C.RetirementDate)- 1,'1900-01-01')) MES_RETIRO) AS MES_RETIRO,
 DAY(C.RetirementDate) AS DÍA_RETIRO,
 ET.Name AS TIPO_EMPLEADO
, CAST(e.DateModified AS date) AS 'FECHA BUSQUEDA'
, YEAR(e.DateModified) AS 'AÑO FECHA BUSQUEDA'
, MONTH(e.DateModified) AS 'MES AÑO FECHA BUSQUEDA'
, CASE MONTH(e.DateModified) 
	WHEN 1 THEN 'ENERO'
	WHEN 2 THEN 'FEBRERO'
	WHEN 3 THEN 'MARZO'
	WHEN 4 THEN 'ABRIL'
	WHEN 5 THEN 'MAYO'
	WHEN 6 THEN 'JUNIO'
	WHEN 7 THEN 'JULIO'
	WHEN 8 THEN 'AGOSTO'
	WHEN 9 THEN 'SEPTIEMBRE'
	WHEN 10 THEN 'OCTUBRE'
	WHEN 11 THEN 'NOVIEMBRE'
	WHEN 12 THEN 'DICIEMBRE'
  END AS 'MES NOMBRE FECHA BUSQUEDA'
, DAY(e.DateModified) AS 'DIA FECHA BUSQUEDA',
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM Payroll.Employee e
 Inner Join Common.ThirdParty tp ON tp.Id = e.ThirdPartyId
 Inner Join Payroll.[Contract] c ON c.EmployeeId = e.Id
 Inner Join Payroll.FunctionalUnit fu ON fu.Id = c.FunctionalUnitId
 Inner Join Payroll.BranchOffice bo ON bo.Id = fu.BranchOfficeId
 Inner Join Payroll.CostCenter cc ON cc.Id = e.CostCenterId
 Inner Join Payroll.Position pos ON pos.Id = c.PositionId
 Inner Join Payroll.RetirementReason rr ON rr.Id = c.RetirementReasonId
 Inner Join Payroll.EmployeeType et ON et.Id = e.EmployeeTypeId
WHERE c.Status IN (2,5) And Valid = 0 
