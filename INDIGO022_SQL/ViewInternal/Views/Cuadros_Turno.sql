-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Cuadros_Turno
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[Cuadros_Turno]  AS

SELECT 	C.NIT 'Documento',c.Name 'NombreEmpleado', FU.Name as UnidadFuncional, POS.Name AS Cargo, A.Period AS Periodo, CASE C.state WHEN 1 THEN 'Activo' ELSE 'Inactivo' END AS ESTADO,
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D01) AS 'D01',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D01) AS 'D01H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D02) AS 'D02',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D02) AS 'D02H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D03) AS 'D03',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D03) AS 'D03H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D04) AS 'D04',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D04) AS 'D04H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D05) AS 'D05',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D05) AS 'D05H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D06) AS 'D06',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D06) AS 'D06H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D07) AS 'D07',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D07) AS 'D07H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D08) AS 'D08',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D08) AS 'D08H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D09) AS 'D09',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D09) AS 'D09H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D10) AS 'D10',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D10) AS 'D10H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D11) AS 'D11',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D11) AS 'D11H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D12) AS 'D12',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D12) AS 'D12H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D13) AS 'D13',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D13) AS 'D13H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D14) AS 'D14',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D14) AS 'D14H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D15) AS 'D15',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D15) AS 'D15H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D16) AS 'D16',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D16) AS 'D16H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D17) AS 'D17',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D17) AS 'D17H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D18) AS 'D18',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D18) AS 'D18H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D19) AS 'D19',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D19) AS 'D19H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D20) AS 'D20',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D20) AS 'D20H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D21) AS 'D21',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D21) AS 'D21H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D22) AS 'D22',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D22) AS 'D22H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D23) AS 'D23',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D23) AS 'D23H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D24) AS 'D24',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D24) AS 'D24H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D25) AS 'D25',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D25) AS 'D25H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D26) AS 'D26',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D26) AS 'D26H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D27) AS 'D27',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D27) AS 'D27H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D28) AS 'D28',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D28) AS 'D28H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D29) AS 'D29',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D29) AS 'D29H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D30) AS 'D30',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D30) AS 'D30H',
		(select T.letter from Payroll.ScheduleDetail AS T where T.Id=A.D31) AS 'D31',
		(select T.TotalNumberHours from Payroll.ScheduleDetail AS T where T.Id=A.D31) AS 'D31H',
		A.TotalHour 'Horas'
FROM 
	payroll.SCHEDULE A 
	INNER JOIN Payroll.Employee B ON A.EmployeeId = B.Id 
	INNER JOIN Common.ThirdParty C ON B.ThirdPartyId = C.Id 
	INNER JOIN Payroll.FunctionalUnit FU ON FU.Id = A.FunctionalUnitId
	INNER JOIN Payroll.[Contract] CONT ON CONT.EmployeeId = B.Id AND CONT.Valid = 1 and CONT.[Status] = 1
	INNER JOIN Payroll.Position POS ON POS.Id = CONT.PositionId
