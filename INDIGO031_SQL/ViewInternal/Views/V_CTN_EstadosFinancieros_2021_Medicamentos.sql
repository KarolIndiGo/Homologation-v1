-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_CTN_EstadosFinancieros_2021_Medicamentos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

--select * from GeneralLedger.MainAccountClasses
--SELECT * FROM GeneralLedger.GeneralLedgerBalance
--select * from GeneralLedger.MainAccounts where LegalBookId = 2 and IdAccountLevel = 6 and Number like '4250250501'
--select * from Payroll.CostCenter WHERE [Name] LIKE '%MEDICAMENTOS%'
--SELECT * FROM GeneralLedger.MainAccountS

CREATE VIEW [ViewInternal].[V_CTN_EstadosFinancieros_2021_Medicamentos]
AS
SELECT { fn CONCAT(CASE WHEN C.IdAccountLevel = 6 THEN C.Number END, CC.Code) } AS Llave, 
			 CASE WHEN C.IdAccountLevel = 6 THEN C.Number END AS SubAuxiliar, 
			 CASE WHEN C.IdAccountLevel = 6 THEN C.Name END AS Nombre_SubAuxiliar, 
			 cl.Code AS Clase, 
             cl.Name AS NombreClase, 
			 CASE WHEN C4.IdAccountLevel = 2 THEN C4.Number END AS Grupo, 
			 CASE WHEN C4.IdAccountLevel = 2 THEN C4.Name END AS NombreGrupo, 
			 CASE WHEN C3.IdAccountLevel = 3 THEN C3.Number END AS Cuenta, 
             CASE WHEN C3.IdAccountLevel = 3 THEN C3.Name END AS NombreCuenta, 
			 CASE WHEN C2.IdAccountLevel = 4 THEN C2.Number END AS SubGrupo, 
			 CASE WHEN C2.IdAccountLevel = 4 THEN C2.Name END AS NombreSubGrupo, 
			 T.Nit, T.Name AS Tercero, 
			 CC.Code AS CC, 
             CC.Name AS CentroCosto, CASE B.[Month] WHEN 1 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Enero, CASE B.[Month] WHEN 2 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Febrero, 
             CASE B.[Month] WHEN 3 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Marzo, CASE B.[Month] WHEN 4 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Abril, 
             CASE B.[Month] WHEN 5 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Mayo, CASE B.[Month] WHEN 6 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Junio, 
             CASE B.[Month] WHEN 7 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Julio, CASE B.[Month] WHEN 8 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Agosto, 
             CASE B.[Month] WHEN 9 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Septiembre, CASE B.[Month] WHEN 10 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Octubre, 
             CASE B.[Month] WHEN 11 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Noviembre, CASE B.[Month] WHEN 12 THEN CONVERT(MONEY, SUM(B.CreditValue) - SUM(B.DebitValue), 0) ELSE '0' END AS Diciembre, PO.Name AS Cargos
FROM   GeneralLedger.GeneralLedgerBalance AS B 
	   INNER JOIN GeneralLedger.MainAccounts AS C ON B.IdMainAccount = C.Id AND B.Year = '2021'
	   INNER JOIN GeneralLedger.MainAccountClasses AS cl ON C.IdAccountClass = cl.Id AND C.LegalBookId = 2 AND cl.Code BETWEEN '4' AND '6' 
	   LEFT JOIN GeneralLedger.MainAccounts AS C1 ON C.IdParent = C1.Id AND C1.LegalBookId = 2
	   LEFT JOIN GeneralLedger.MainAccounts AS C2 ON C1.IdParent = C2.Id AND C2.LegalBookId = 2
	   LEFT JOIN GeneralLedger.MainAccounts AS C3 ON C2.IdParent = C3.Id AND C3.LegalBookId = 2
	   LEFT JOIN GeneralLedger.MainAccounts AS C4 ON C3.IdParent = C4.Id AND C4.LegalBookId = 2
	   INNER JOIN Common.ThirdParty AS T ON B.IdThirdParty = T.Id 
	   INNER JOIN Payroll.CostCenter AS CC ON B.IdCostCenter = CC.Id
	   LEFT OUTER JOIN Payroll.Employee AS E ON E.ThirdPartyId = T.Id
	   LEFT OUTER JOIN Payroll.Contract AS CONT ON CONT.EmployeeId = E.Id AND CONT.Status = 1
	   LEFT OUTER JOIN Payroll.Position AS PO ON PO.Id = CONT.PositionId
WHERE (CC.Name LIKE '%MEDICAMENTOS%' OR
	  CC.Code = 'BOG100') OR
	  C.Number like '611001%' --CUENTA CONTABLE DE DISPENSACION DE MEDICAMENTOS
GROUP BY C.IdAccountLevel, cl.Code, cl.Name, C3.IdAccountLevel, C2.IdAccountLevel, C1.IdAccountLevel, C4.IdAccountLevel, C.Name, C3.Name, C2.Name, C1.Name, T.Nit, T.Name, CC.Code, CC.Name, C.Number, C1.Number, C2.Number, C3.Number,
		 C4.Name, C4.Number, B.Month, PO.Name
