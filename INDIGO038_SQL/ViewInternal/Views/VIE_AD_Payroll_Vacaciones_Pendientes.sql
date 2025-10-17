-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Payroll_Vacaciones_Pendientes
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [ViewInternal].[VIE_AD_Payroll_Vacaciones_Pendientes] as

SELECT	 

CedulaEmpleado  AS Documento, NombreEmpleado AS Empleado,  DiasVacaciones AS [Dias Vacaciones], DiasPendientes AS [Dias Pendientes], 
		DiasTomados AS [Dias Tomados],FechaInicioEmpleado AS [Fecha Inicial Periodo Vacaciones], FechaFinEmpleado AS [Fecha Final Periodo Vacaciones],
		  fu.Code AS CodUFuncional, fu.Name AS UnidadFuncional--, 
  --                       cc.Code AS CodCentroCosto, cc.Name AS CentroCosto, 
		--case  when  cc.Code like 'N%' then 'Neiva'
		--	  when  cc.Code like 'T%' then 'Tunja'
		--	  when  cc.Code like 'F%' then 'Florencia'
		--	  when  cc.Code like 'P%' then 'Pitalito'
		--	  when cc.code like 'E%' then 'Abner' else 'Nacional'
		--	   end as Sucursal, e.id
FROM   Temp_VacacionesPendientes AS T INNER JOIN
		Common.ThirdParty AS tp ON TP.NIT=T.CedulaEmpleado LEFT OUTER JOIN
		Payroll.Employee AS e ON tp.Id = e.ThirdPartyId LEFT OUTER JOIN 
	 --   --Payroll.VacationPeriod AS l ON l.EmployeeId = e.Id AND Pendingdays>0 AND T.FechaInicioEmpleado<>L.InitialDatePeriod LEFT OUTER JOIN
                      Payroll.Contract AS co  ON co.employeeid = e.id and co.Status='1' and co.Valid ='true'  LEFT OUTER JOIN
                         Payroll.Position AS ca  ON ca.Id = co.PositionId LEFT OUTER JOIN
                         Payroll.FunctionalUnit AS fu  ON fu.Id = co.FunctionalUnitId LEFT OUTER JOIN
                         Payroll.ContractType AS ct  ON co.ContractTypeId = ct.Id LEFT OUTER JOIN
                         .Payroll.CostCenter AS cc  ON fu.CostCenterId = cc.Id 
						 
	inner join  (select EmployeeId, PendingDays, InitialDatePeriod
							from Payroll.VacationPeriod
								where PendingDays>0) as pen on pen.InitialDatePeriod=t.FechaInicioEmpleado and pen.EmployeeId=e.id				 
	
WHERE   --.FechaInicioEmpleado<>L.InitialDatePeriod  --and 
T.FechaFinEmpleado<getdate() 

and e.id in (select employeeid
							from payroll.contract
							 where valid='1')   



