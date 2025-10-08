-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_FACT_VENTASNATURALES
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_FACT_VENTASNATURALES
AS
     SELECT t.Nit, 
            t.Name AS Cliente, 
            cco.Code AS CentroCosto,
			cco.Name as Centro,
            CASE
                WHEN sc.Month = '1'
                     AND sc.Year = '2024'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Enero 2024],
            CASE
                WHEN sc.Month = '2'
                     AND sc.Year = '2024'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Febrero 2024],
            CASE
                WHEN sc.Month = '3'
                     AND sc.Year = '2024'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Marzo 2024],
            CASE
                WHEN sc.Month = '4'
                     AND sc.Year = '2024'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Abril 2024],
            CASE
                WHEN sc.Month = '5'
                     AND sc.Year = '2024'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Mayo 2024],
            CASE
                WHEN sc.Month = '6'
                     AND sc.Year = '2024'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Junio 2024],
            CASE
                WHEN sc.Month = '7'
                     AND sc.Year = '2024'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Julio 2024],
            CASE
                WHEN sc.Month = '8'
                     AND sc.Year = '2024'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Agosto 2024],
            CASE
                WHEN sc.Month = '9'
                     AND sc.Year = '2024'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Septiembre 2024],
            CASE
                WHEN sc.Month = '10'
                     AND sc.Year = '2024'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Octubre 2024],
            CASE
                WHEN sc.Month = '11'
                     AND sc.Year = '2024'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Noviembre 2024],
            CASE
                WHEN sc.Month = '12'
                     AND sc.Year = '2024'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Diciembre 2024],
            CASE
                WHEN cco.Code LIKE 'BOG%'
                THEN 'BOGOTA'
                WHEN cco.Code LIKE 'TAM%'
                THEN 'BOGOTA'
                WHEN cco.Code LIKE 'B0%'
                THEN 'BOYACA'
				  WHEN cco.Code LIKE 'MSO%'
                THEN 'BOYACA'
				  WHEN cco.Code LIKE 'MMO%'
                THEN 'BOYACA'
				 WHEN cco.Code LIKE 'MPB%'
                THEN 'BOYACA'
                WHEN cco.Code LIKE 'MET%'
                THEN 'META'
				 WHEN cco.Code LIKE 'MGR%'
                THEN 'META'
				 WHEN cco.Code LIKE 'MVI%'
                THEN 'META'
				WHEN cco.Code LIKE 'MEM%'
                THEN 'META'
					WHEN cco.Code LIKE 'MAC%'
                THEN 'META'
				
                WHEN cco.Code LIKE 'YOP%'
				   THEN 'CASANARE'
				    WHEN cco.Code LIKE 'MYO%'
				   THEN 'CASANARE'
				    WHEN cco.Code LIKE 'CEM%'
				   THEN 'CASANARE'
				    WHEN cco.Code LIKE 'CAS%'
				   THEN 'CASANARE'
				WHEN cco.Code LIKE 'BOY%'
                THEN 'BOYACA'
				WHEN cco.Code LIKE 'MCH%'
                THEN 'BOYACA'
				WHEN cco.Code LIKE 'MDU%'
                THEN 'BOYACA'
			 WHEN cco.Code LIKE 'BEM%'
			 THEN 'BOYACA'
             WHEN cco.Code LIKE 'MTU%'
			 THEN 'BOYACA'
			  WHEN cco.Code LIKE 'MST%'
			 THEN 'BOYACA'
			   WHEN cco.Code LIKE 'MAA%'
			 THEN 'CASANARE'
			 	   WHEN cco.Code LIKE 'MGU%'
			 THEN 'BOYACA'
			 	 	   WHEN cco.Code LIKE 'MPG%'
			 THEN 'META'
            	   WHEN cco.Code LIKE 'MSM%'
			 THEN 'META'
			  	   WHEN cco.Code LIKE 'MBN%'
			 THEN 'CASANARE'
			 	   WHEN cco.Code LIKE 'MPL%'
			 THEN 'META'
			 	   WHEN cco.Code LIKE 'MGA%'
			 THEN 'BOYACA'
			    WHEN cco.Code LIKE 'MMF%'
			 THEN 'BOYACA'
			 	    WHEN cco.Code LIKE 'MPA%'
			 THEN 'CASANARE'
			   WHEN cco.Code LIKE 'MVN%'
			 THEN 'CASANARE'
            END AS Sede
     FROM INDIGO031.GeneralLedger.GeneralLedgerBalance AS sc 
          INNER JOIN INDIGO031.Common.ThirdParty AS t ON t.Id = sc.IdThirdParty
          LEFT OUTER JOIN INDIGO031.Payroll.CostCenter AS cco ON cco.Id = sc.IdCostCenter
          LEFT OUTER JOIN INDIGO031.GeneralLedger.MainAccounts AS c ON c.Id = sc.IdMainAccount
     WHERE(t.PersonType = '1')
          AND (c.LegalBookId = '2')
          AND (c.Number LIKE '41%')
     GROUP BY t.Nit, 
              t.Name, 
              cco.Code, 
			  cco.Name,
              sc.Month, 
              sc.Year;