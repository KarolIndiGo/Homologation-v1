-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: MM_FACT_VentasNaturales
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[Ventas_Naturales]
AS
SELECT t.Nit, 
            t.Name AS Cliente, 
            cco.Code AS CentroCosto,
			cco.name as Centro,
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
                WHEN sc.Month = '1' and sc.Year = '2025'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Enero 2025],
            CASE
                WHEN sc.Month = '2' and sc.Year = '2025'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Febrero 2025],
            CASE
                WHEN sc.Month = '3' and sc.Year = '2025'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Marzo 2025],
            CASE
                WHEN sc.Month = '4' and sc.Year = '2025'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Abril 2025],
            CASE
                WHEN sc.Month = '5' and sc.Year = '2025'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Mayo 2025],
            CASE
                WHEN sc.Month = '6' and sc.Year = '2025'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Junio 2025],
            CASE
                WHEN sc.Month = '7' and sc.Year = '2025'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Julio 2025],
            CASE
                WHEN sc.Month = '8' and sc.Year = '2025'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Agosto 2025],
            CASE
                WHEN sc.Month = '9' and sc.Year = '2025'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Septiembre 2025],
            CASE
                WHEN sc.Month = '10' and sc.Year = '2025'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Octubre 2025],
            CASE
                WHEN sc.Month = '11' and sc.Year = '2025'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Noviembre 2025],
            CASE
                WHEN sc.Month = '12' and sc.Year = '2025'
                THEN((SUM(sc.DebitValue) - SUM(sc.CreditValue))) * -1
            END AS [Diciembre 2025],
            CASE 
			  WHEN cco.Code in ('MMD14','MMD15','MMD16','MMD22','MMD30') THEN 'NEIVA'
				WHEN cco.Code in ('MMD07','MMD08') THEN 'TUNJA'
				WHEN cco.Code = 'MMD100' THEN 'ADMINISTRATIVO'
				WHEN cco.Code = 'MMD02' THEN 'BOGOTA'
				WHEN cco.Code = 'MMD03' THEN 'FACATATIVA'
				WHEN cco.Code = 'MMD05' THEN 'SOGAMOSO'
				WHEN cco.Code = 'MMD06' THEN 'DUITAMA'
				WHEN cco.Code = 'MMD09' THEN 'VILLAVICENCIO'
				WHEN cco.Code = 'MMD10' THEN 'PUERTO LOPEZ'
				WHEN cco.Code = 'MMD11' THEN 'ACACIAS'
				WHEN cco.Code = 'MMD12' THEN 'GRANADA'
				WHEN cco.Code = 'MMD13' THEN 'CHIQUINQUIRA'
				WHEN cco.Code = 'MMD17' THEN 'GARAGOA'
				WHEN cco.Code = 'MMD18' THEN 'GUATEQUE'
				WHEN cco.Code = 'MMD19' THEN 'MONIQUIRA'
				WHEN cco.Code = 'MMD20' THEN 'SOATA'
				WHEN cco.Code = 'MMD21' THEN 'FLORENCIA'
				WHEN cco.Code = 'MMD23' THEN 'MIRAFLORES'
				WHEN cco.Code = 'MMD24' THEN 'YOPAL'
				WHEN cco.Code = 'MMD25' THEN 'SAN MARTIN'
				WHEN cco.Code = 'MMD26' THEN 'PAZ DE ARIPORO'
				WHEN cco.Code = 'MMD27' THEN 'VILLANUEVA'
				WHEN cco.Code = 'MMD28' THEN 'AGUAZUL'
				WHEN cco.Code = 'MMD29' THEN 'PUERTO GAITAN'
				ELSE 'DESCONOCIDO'
		END AS sede
     FROM GeneralLedger.GeneralLedgerBalance AS sc 
          INNER JOIN Common.ThirdParty AS t ON t.Id = sc.IdThirdParty
          LEFT OUTER JOIN Payroll.CostCenter AS cco ON cco.Id = sc.IdCostCenter
          LEFT OUTER JOIN GeneralLedger.MainAccounts AS c ON c.Id = sc.IdMainAccount
     WHERE(t.PersonType = '1')
          AND (c.LegalBookId = '1')
          AND (c.Number LIKE '41%')
     GROUP BY t.Nit, 
              t.Name, 
              cco.Code, 
			  cco.name,
              sc.Month, 
              sc.Year;
