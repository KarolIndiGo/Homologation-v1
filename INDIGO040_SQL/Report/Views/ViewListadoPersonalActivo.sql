-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewListadoPersonalActivo
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[ViewListadoPersonalActivo] as 
SELECT
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
CASE p.IdentificationType WHEN '0' THEN 'Cédula de Ciudadanía' WHEN '1' THEN 'Cédula de Extranjería' WHEN '2' THEN 'Tarjeta de Identidad' WHEN '3' THEN 'Registro Civil' WHEN '4' THEN 'Pasporte' 
WHEN '5' THEN 'Adulto Sin Identificación' WHEN '6' THEN 'Menor Sin Identificación' WHEN '7' THEN 'Nit' WHEN '8' THEN 'Número único de identificación personal (NU)' WHEN '9' THEN 'Cetrigicado Nacido Vivo (CN)' 
WHEN '10' THEN 'Carnet Diplomático (CD)' WHEN '11' THEN 'Salvoconducto (SC)' WHEN '12' THEN 'Permiso especial de Permanencia (PE)' END AS TIPO_DOCUMENTO,
P.IdentificationNumber AS NÚMERO_DOCUMENTO,
ce.Name AS CIUDAD_EXPEDICIÓN,
tp.name AS EMPLEADO, 
pos.Name AS CARGO,
bo.Name AS SEDE,
fu.Name AS UNIDAD_FUNCIONAL,
cc.Name AS CENTRO_COSTO,
et.Name AS TIPO_EMPLEADO,
CASE p.Gender WHEN '1' THEN 'Masculino' WHEN '2' THEN 'Femenino' WHEN '3' THEN 'Otro' END AS GÉNERO,
CASE p.MaritalStatus WHEN '0' THEN 'Soltero' WHEN '1' THEN 'Casado' WHEN '2' THEN 'Divorciado' WHEN '3' THEN 'Viudo' WHEN '4' THEN 'Unión Libre' END AS ESTADO_CIVIL,
CASE p.SocioEconomicStatus WHEN '1' THEN 'Bajo - bajo' WHEN '2' THEN 'Bajo' WHEN '3' THEN 'Medio-bajo' WHEN '4' THEN 'Medio' WHEN '5' THEN 'Medio-alto' WHEN '6' THEN 'Alto' END AS ESTRATO,
p.BirthDate AS FECHA_NACIMIENTO,
DATEDIFF(YEAR,p.BirthDate,GETDATE()) AS EDAD,
cn.Name AS CIUDAD_NACIMIENTO,
p.BloodGroup AS GRUPO_SANGUINEO,
p.RH,
ps.ProfessionalCardNumber AS #TARJETA_PROFESIONAL,
--ca.Addresss AS ,
(SELECT TOP 1 ca.Addresss FROM  Common.[Address] ca WHERE ca.IdPerson = P.Id) AS DIRECCION_RESIDENCIAL, 
(SELECT TOP 1 CR.Name FROM  Common.City CR, Common.[Address] ca  WHERE CA.CityId = CR.Id) AS CIUDAD_RESIDENCIAL, 
(SELECT TOP 1 EM.Email FROM  Common.Email EM WHERE EM.IdPerson = P.Id) AS CORREO_ELECTRONICO,
(SELECT TOP 1 PH.Phone FROM Common.Phone PH, Common.PhoneType PT WHERE PH.IdPerson = p.Id AND PH.IdPhoneType = PT.Id AND PT.Id = 1 AND PH.State = 1) AS TELÉFONO_CELULAR,
(SELECT TOP 1 PH.Phone FROM Common.Phone PH, Common.PhoneType PT WHERE PH.IdPerson = p.Id AND PH.IdPhoneType = PT.Id AND PT.Id = 2 AND PH.State = 1) AS TELÉFONO_FIJO,
c.JobBondingDate AS FECHA_INGRESO,
DATEDIFF(MONTH,c.JobBondingDate,GETDATE()) AS ANTIGÜEDAD_MESES,
CASE c.RowType WHEN '1' THEN 'INICIAL' WHEN '2' THEN 'PRÓRROGA' END AS CONTRATO,
ct.Name AS TIPO_DE_CONTRATO,
C.ContractEndingDate AS FECHA_FIN_CONTRATO,
--DATEDIFF(YEAR,p.BirthDate,GETDATE()) AS NÚMERO_DE_PRORROGA, 
c.BasicSalary AS SALARIO,
b.Name AS BANCO,
c.BankAccountNumber AS #_DE_CUENTA_DE_NÓMINA,
(SELECT TOP 1 f.Name FROM Payroll.FundContract FC, Payroll.Fund F WHERE FC.ContractId = c.id and FC.FundType = 1 AND F.Id = FC.FundId and FC.State = 1 AND FC.VoluntaryContribution = 0) as SALUD,
(SELECT TOP 1 f.Name FROM Payroll.FundContract FC, Payroll.Fund F WHERE FC.ContractId = c.id and FC.FundType = 1 AND F.Id = FC.FundId and FC.State = 1 AND FC.VoluntaryContribution = 1) as SALUD_VOLUNTARIA,
(SELECT TOP 1 f.Name FROM Payroll.FundContract FC, Payroll.Fund F WHERE FC.ContractId = c.id and FC.FundType = 2 AND F.Id = FC.FundId and FC.State = 1 AND FC.VoluntaryContribution = 0) as PENSIÓN,
(SELECT TOP 1 f.Name FROM Payroll.FundContract FC, Payroll.Fund F WHERE FC.ContractId = c.id and FC.FundType = 2 AND F.Id = FC.FundId and FC.State = 1 AND FC.VoluntaryContribution = 1) as PENSIÓN_VOLUNTARIA,
(SELECT TOP 1 f.Name FROM Payroll.FundContract FC, Payroll.Fund F WHERE FC.ContractId = c.id and FC.FundType = 3 AND F.Id = FC.FundId and FC.State = 1 AND FC.VoluntaryContribution = 0) as CESANTÍAS,
(SELECT TOP 1 f.Name FROM Payroll.FundContract FC, Payroll.Fund F WHERE FC.ContractId = c.id and FC.FundType = 4 AND F.Id = FC.FundId and FC.State = 1 AND FC.VoluntaryContribution = 0) as ARL,
(SELECT TOP 1 f.Name FROM Payroll.FundContract FC, Payroll.Fund F WHERE FC.ContractId = c.id and FC.FundType = 5 AND F.Id = FC.FundId and FC.State = 1 AND FC.VoluntaryContribution = 0) as CAJA_COMPENSACIÓN,
e.ProfessionalRiskPercentage AS PORCENTAJE_ARL,
st.StudyLevel AS NIVEL_ACADEMICO,
pp.Name AS PROFESIÓN,
k.Name AS PARENTESCO,
rs.Name AS NOMBRE_FAMILIAR,
rs.BirthDate AS FECHA_NACIMIENTO_FAMILIAR
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
From Common.Person p
Inner Join Common.ThirdParty tp ON tp.PersonId = p.id
Inner Join Payroll.Employee e ON e.ThirdPartyId = tp.Id
Inner Join Payroll.[Contract] c ON c.EmployeeId = e.Id
Inner Join Payroll.Position pos ON pos.Id = c.PositionId
LEFT Join Common.City ce ON ce.Id = p.IdentificacionCityId
Inner Join Payroll.FunctionalUnit fu ON fu.Id = c.FunctionalUnitId
Inner Join Payroll.BranchOffice bo ON bo.Id = fu.BranchOfficeId
Inner Join Payroll.CostCenter cc ON cc.Id = e.CostCenterId
Inner Join Payroll.EmployeeType et ON et.Id = e.EmployeeTypeId
Inner Join Common.City cn ON cn.Id = p.BirthCityId
LEFT Join Common.PersonStudy ps ON ps.PersonId = P.Id 
INNER JOIN Payroll.ContractType ct ON ct.Id = c.ContractTypeId
Inner Join Payroll.Bank b ON b.Id = c.BankId
LEFT Join Payroll.StudyType st ON st.Id = ps.StudyTypeId
LEFT Join Common.PersonProfession cpp ON cpp.PersonId = p.Id
LEFT Join Payroll.Profession pp ON pp.Id = cpp.IdProfession
LEFT Join [Payroll].[Relationship] rs ON  rs.EmployeeId = e.Id
LEFT Join [Payroll].[Kinship] k ON k.Id = rs.KinshipId
Inner Join Payroll.[Group] g ON g.Id = c.GroupId
Where c.Status = 1 And c.Valid = 1 
