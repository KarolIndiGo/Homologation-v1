-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_NOMINACOSTOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[View_HDSAP_NOMINACOSTOS]
AS


		select ct.Nit as 'Documento',
		ct.name as 'Nombres',
		ps.Name as 'cargo', 
		pg.Name'Grupo' ,
		pld.PayrollDate as 'FechaLiquidacion',
		pld.ConceptCode as 'CodigoConcepto', 
		pld.ConceptDetail as 'DetalleConcepto', 
		pld.ConceptTotalValue as 'ValorTotalConcepto', 
		pld.AccruedValue as 'TotalDevengado',
		pld.DeductedValue as 'TotalDeducido'


		from Payroll.Liquidation as pl
		join Payroll.Employee as pe on pe.Id=pl.EmployeeId
		join Common.ThirdParty as ct on ct.Id=pe.ThirdPartyId
		join Payroll.LiquidationDetail as pld on pld.PayrollId=pl.Id
		join Payroll.[Group] as pg on pg.Id=pl.GroupId
		join Payroll.Contract as pc on  pc.EmployeeId=pe.Id
		join Payroll.Position as ps on ps.Id=pc.PositionId 


		where (pg.Id<>'41') and (pg.Id <>'100') and (pc.Status='1') 
