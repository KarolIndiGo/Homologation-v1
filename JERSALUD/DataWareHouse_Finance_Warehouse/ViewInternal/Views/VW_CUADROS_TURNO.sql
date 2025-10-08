-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_CUADROS_TURNO
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VW_CUADROS_TURNO
AS

SELECT 	C.Nit 'Documento',C.Name 'NombreEmpleado', FU.Name as UnidadFuncional, POS.Name AS Cargo, A.Period AS Periodo, CASE C.State WHEN 1 THEN 'Activo' ELSE 'Inactivo' END AS ESTADO,
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D01) AS 'D01',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D02) AS 'D02',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D03) AS 'D03',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D04) AS 'D04',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D05) AS 'D05',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D06) AS 'D06',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D07) AS 'D07',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D08) AS 'D08',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D09) AS 'D09',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D10) AS 'D10',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D11) AS 'D11',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D12) AS 'D12',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D13) AS 'D13',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D14) AS 'D14',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D15) AS 'D15',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D16) AS 'D16',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D17) AS 'D17',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D18) AS 'D18',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D19) AS 'D19',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D20) AS 'D20',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D21) AS 'D21',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D22) AS 'D22',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D23) AS 'D23',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D24) AS 'D24',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D25) AS 'D25',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D26) AS 'D26',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D27) AS 'D27',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D28) AS 'D28',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D29) AS 'D29',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D30) AS 'D30',
		(select T.Letter from [INDIGO031].[Payroll].[ScheduleDetail] AS T where T.Id=A.D31) AS 'D31',
		
		A.TotalHour 'Horas'
FROM
	[INDIGO031].[Payroll].[Schedule] A 
	INNER JOIN [INDIGO031].[Payroll].[Employee] B ON A.EmployeeId = B.Id 
	INNER JOIN [INDIGO031].[Common].[ThirdParty] C ON B.ThirdPartyId = C.Id 
	INNER JOIN [INDIGO031].[Payroll].[FunctionalUnit] FU ON FU.Id = A.FunctionalUnitId
	INNER JOIN [INDIGO031].[Payroll].[Contract] CONT ON CONT.EmployeeId = B.Id AND CONT.Valid = 1 and CONT.[Status] = 1
	INNER JOIN [INDIGO031].[Payroll].[Position] POS ON POS.Id = CONT.PositionId
