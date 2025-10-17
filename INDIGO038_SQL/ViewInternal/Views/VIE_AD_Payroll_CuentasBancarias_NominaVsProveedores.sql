-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Payroll_CuentasBancarias_NominaVsProveedores
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VIE_AD_Payroll_CuentasBancarias_NominaVsProveedores]
AS


SELECT *
FROM (



SELECT 

T.Nit AS Documento, T.Name AS Nombre, b.Name AS [Banco Nomina], MAX(C.BankAccountNumber) AS [Numero Cuenta Nomina], CASE c.BankAccountType WHEN 1 THEN 'Ahorro' WHEN 2 THEN 'Corriente' END AS [Tipo Cuenta Nomina], bp.Name AS [Banco Proveedores], pb.Number AS [Numero Cuenta Proveedor], 
           CASE pb.type WHEN 1 THEN 'Ahorro' WHEN 2 THEN 'Corriente' END AS [Tipo Cuenta Proveedor],   max (RetirementDate) as FechaRetiro, 
		   case c.status when 1 then 'Activo' when 2 then 'Liquidado' end as Estado,
		   case when fu.code like 'N%' then 'Neiva' when fu.code like 'T%' then 'Tunja'
				when fu.code like 'F%' then 'Florencia' when fu.code like 'P%' then 'Pitalito'
				when fu.code like 'E%' then 'Abner' when fu.code like 'M%' then 'Nacional' else fu.code end as Sucursal
FROM   Payroll.Employee AS E INNER JOIN
           Payroll.Contract AS C  ON C.EmployeeId = E.Id INNER JOIN
           Common.ThirdParty AS T  ON T.Id = E.ThirdPartyId left outer  JOIN
           Common.Supplier AS p  ON p.code = T.nit LEFT OUTER JOIN
           Common.SupplierBankAccount AS pb  ON pb.SupplierId = p.Id INNER JOIN
           Payroll.Bank AS b  ON b.Id = C.BankId LEFT OUTER JOIN
           Payroll.Bank AS bp  ON bp.Id = pb.BankId LEFT OUTER JOIN
           Common.SuppliersDistributionLines AS csd  ON csd.IdSupplier = p.Id
		   left outer join Payroll.FunctionalUnit as fu on fu.id=c.FunctionalUnitId
WHERE  c.status  in ('1')  --(C.Status = '1') AND (C.Valid = '1')  and 
--and t.nit='1081418942'
GROUP BY T.Nit,  T.Name ,  b.name,c.BankAccountType , bp.Name , pb.Number , 
          pb.type,   
		    c.status,  fu.code
union all

SELECT 

T.Nit AS Documento, T.Name AS Nombre, min(b.Name) AS [Banco Nomina], max(C.BankAccountNumber) AS [Numero Cuenta Nomina], 
CASE c.BankAccountType WHEN 1 THEN 'Ahorro' WHEN 2 THEN 'Corriente' END AS [Tipo Cuenta Nomina], bp.Name AS [Banco Proveedores], pb.Number AS [Numero Cuenta Proveedor], 
           CASE pb.type WHEN 1 THEN 'Ahorro' WHEN 2 THEN 'Corriente' END AS [Tipo Cuenta Proveedor],   max (RetirementDate) as FechaRetiro, 
		   case c.status when 1 then 'Activo' when 2 then 'Liquidado' end as Estado,
		    case when fu.code like 'N%' then 'Neiva' when fu.code like 'T%' then 'Tunja'
				when fu.code like 'F%' then 'Florencia' when fu.code like 'P%' then 'Pitalito'
				when fu.code like 'E%' then 'Abner' when fu.code like 'M%' then 'Nacional' else fu.code end as Sucursal
FROM   Payroll.Employee AS E INNER JOIN
           Payroll.Contract AS C  ON C.EmployeeId = E.Id INNER JOIN
           Common.ThirdParty AS T  ON T.Id = E.ThirdPartyId left outer  JOIN
           Common.Supplier AS p  ON p.code = T.nit LEFT OUTER JOIN
           Common.SupplierBankAccount AS pb  ON pb.SupplierId = p.Id left outer JOIN
           Payroll.Bank AS b  ON b.Id = C.BankId LEFT OUTER JOIN
           Payroll.Bank AS bp  ON bp.Id = pb.BankId LEFT OUTER JOIN
           Common.SuppliersDistributionLines AS csd  ON csd.IdSupplier = p.Id
		   left outer join Payroll.FunctionalUnit as fu on fu.id=c.FunctionalUnitId
WHERE  c.status  in ('2')  --(C.Status = '1') AND (C.Valid = '1')  and 
--and t.nit='1081418942' 
and t.nit not in (SELECT T.Nit 
											FROM   Payroll.Employee AS E INNER JOIN
												   Payroll.Contract AS C  ON C.EmployeeId = E.Id INNER JOIN
												   Common.ThirdParty AS T  ON T.Id = E.ThirdPartyId left outer  JOIN
												   Common.Supplier AS p  ON p.code = T.nit LEFT OUTER JOIN
												   Common.SupplierBankAccount AS pb  ON pb.SupplierId = p.Id INNER JOIN
												   Payroll.Bank AS b  ON b.Id = C.BankId LEFT OUTER JOIN
												   Payroll.Bank AS bp  ON bp.Id = pb.BankId LEFT OUTER JOIN
												   Common.SuppliersDistributionLines AS csd  ON csd.IdSupplier = p.Id
												    left outer join Payroll.FunctionalUnit as fu on fu.id=c.FunctionalUnitId
											WHERE  c.status  in ('1')  --(C.Status = '1') AND (C.Valid = '1')  and 
														--and t.nit='1117546701'
											GROUP BY T.Nit,  T.Name , b.Name,  c.BankAccountType , bp.Name , pb.Number , pb.type, c.status )
GROUP BY T.Nit,  T.Name , c.BankAccountType , bp.Name , pb.Number ,  
          pb.type,   
		    c.status, fu.code ) AS A

			--order by t.name

