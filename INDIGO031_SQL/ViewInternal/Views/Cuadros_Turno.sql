-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Cuadros_Turno
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[Cuadros_Turno] 
--ALTER VIEW [IND_CitasMedicas_General]
AS
/*
select top 10 * from payroll.SCHEDULE where Period='07/2021' and EmployeeId='134'
select top 10 * from Payroll.ScheduleDetail where EmployeeId='134' and Id in(61639,61640,61641)
select top 10 * from Payroll.Employee Where Id='134'
select top 10 * from Common.ThirdParty where Id='40423'
select top 10 * from Payroll.FunctionalUnit where Id='1'
select top 10 * from Payroll.[Contract] where Id='3918'
select top 10 * from Payroll.Position where 
*/

SELECT 	C.NIT 'Documento',c.Name 'NombreEmpleado', FU.Name as UnidadFuncional, POS.Name AS Cargo, A.Period AS Periodo, CASE C.state WHEN 1 THEN 'Activo' ELSE 'Inactivo' END AS ESTADO,
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D01) AS 'D01',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D02) AS 'D02',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D03) AS 'D03',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D04) AS 'D04',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D05) AS 'D05',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D06) AS 'D06',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D07) AS 'D07',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D08) AS 'D08',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D09) AS 'D09',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D10) AS 'D10',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D11) AS 'D11',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D12) AS 'D12',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D13) AS 'D13',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D14) AS 'D14',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D15) AS 'D15',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D16) AS 'D16',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D17) AS 'D17',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D18) AS 'D18',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D19) AS 'D19',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D20) AS 'D20',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D21) AS 'D21',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D22) AS 'D22',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D23) AS 'D23',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D24) AS 'D24',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D25) AS 'D25',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D26) AS 'D26',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D27) AS 'D27',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D28) AS 'D28',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D29) AS 'D29',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D30) AS 'D30',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D31) AS 'D31',
		/*
		A.D01,
		A.D02,
		A.D03,
		A.D04,
		A.D05,
		A.D06,
		A.D07,
		A.D08,
		A.D09,
		A.D10,
		A.D11,
		A.D12,
		A.D13,
		A.D14,
		A.D15,
		A.D16,
		A.D17,
		A.D18,
		A.D19,
		A.D20,
		A.D21,
		A.D22,
		A.D23,
		A.D24,
		A.D25,
		A.D26,
		A.D27,
		A.D28,
		A.D29,
		A.D30,
		A.D31,*/
		A.TotalHour 'Horas'
FROM 
	payroll.SCHEDULE A 
	INNER JOIN Payroll.Employee B ON A.EmployeeId = B.Id 
	INNER JOIN Common.ThirdParty C ON B.ThirdPartyId = C.Id 
	INNER JOIN Payroll.FunctionalUnit FU ON FU.Id = A.FunctionalUnitId
	INNER JOIN Payroll.[Contract] CONT ON CONT.EmployeeId = B.Id AND CONT.Valid = 1 and CONT.[Status] = 1
	INNER JOIN Payroll.Position POS ON POS.Id = CONT.PositionId
--WHERE A.Period=''07/2021''-- and C.NIT=''1019014458'
