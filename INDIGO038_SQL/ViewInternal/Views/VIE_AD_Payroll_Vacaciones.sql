-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Payroll_Vacaciones
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [ViewInternal].[VIE_AD_Payroll_Vacaciones]
AS


SELECT        tp.Nit AS Documento, tp.Name AS Empleado, l.CreationDate AS [Fecha Liquidación], l.VacationDays AS [Dias Vacaciones], l.TakenDays AS [Dias Tomados], l.InitialDatePeriod AS [Fecha Inicial Periodo Vacaciones], 
                         l.EndDatePeriod AS [Fecha Final Periodo Vacaciones], v.VacationStartDate AS [Fecha inicial Disfrute], v.VacationEndDate AS [Fecha Final Disfrute], fu.Code AS CodUFuncional, fu.Name AS UnidadFuncional, 
                         cc.Code AS CodCentroCosto, cc.Name AS CentroCosto, 
						 case v.State when 1 then 'Esperando Pago'
									  when 2 then 'Pagadas'
									  when 3 then 'Aplazadas' end AS Estado, 
						 case v.TypeVacation when 1 then 'Compensar' 
											 when 2 then 'Disfrutar' 
											 when 3 then 'Permiso con cargo a vacaciones' end AS Tipo, l.PendingDays AS [Dias Pendientes], --vd.Accrued as ValorConcepto,
											 v.vacationvalue as ValorVacaciones, vs.valor as AporteSalud, vp.valor as AportePension
FROM            Payroll.Employee AS e INNER JOIN
                         Payroll.VacationPeriod AS l ON l.EmployeeId = e.Id INNER JOIN
                         Payroll.Vacation AS v ON v.VacationPeriodId = l.Id INNER JOIN
                         Common.ThirdParty AS tp ON tp.Id = e.ThirdPartyId LEFT OUTER JOIN
                         Payroll.Contract AS co  ON co.Id = l.ContractId LEFT OUTER JOIN
                         Payroll.Position AS ca  ON ca.Id = co.PositionId LEFT OUTER JOIN
                         Payroll.FunctionalUnit AS fu  ON fu.Id = co.FunctionalUnitId LEFT OUTER JOIN
                         Payroll.ContractType AS ct  ON co.ContractTypeId = ct.Id LEFT OUTER JOIN
                         Payroll.CostCenter AS cc  ON fu.CostCenterId = cc.Id LEFT OUTER JOIN
						(select	idvacation, accrued+deducted as valor
							from Payroll.VacationDetail 
									where description='Aporte Salud') as vs on vs.idvacation=v.id LEFT OUTER JOIN
						(select	idvacation, accrued+deducted as valor
							from Payroll.VacationDetail 
									where description='Aporte Pensión') as vp on vp.idvacation=v.id 
--WHERE   tp.nit='1117546407'
