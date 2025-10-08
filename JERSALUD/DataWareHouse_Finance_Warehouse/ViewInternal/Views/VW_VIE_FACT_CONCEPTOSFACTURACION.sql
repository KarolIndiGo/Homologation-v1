-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_FACT_CONCEPTOSFACTURACION
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_FACT_CONCEPTOSFACTURACION
AS
     SELECT C.Code, 
            C.Name AS Concepto,
            CASE C.AccountingType
                WHEN 1
                THEN 'Cuenta Unica de Ingreso'
                WHEN 2
                THEN 'Cuenta por Tipo de Unidad'
            END AS TipoContabilizacion, 
            CU.Number AS CuentaIngreso, 
            CU.Name AS Ingreso, 
            CU1.Number AS Particular, 
            CU1.Name AS IngresoParticular, 
            CU2.Number AS NDescuento, 
            CU2.Name AS Descuento, 
            CU3.Number AS CuentaHonorario, 
            CU3.Name AS Honorarios, 
            CU4.Number AS CuentaNIFF, 
            CU4.Name AS NIIF,
            CASE C.Status
                WHEN 1
                THEN 'Activo'
                WHEN 0
                THEN 'Inactivo'
            END AS Estado
     FROM INDIGO031.Billing.BillingConcept AS C
          INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS CU ON C.EntityIncomeAccountId = CU.Id
          INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS CU1 ON C.IndividualIncomeAccountId = CU1.Id
          INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS CU2 ON C.DiscountAccountId = CU2.Id
          INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS CU3 ON C.FeesExpensesAccountId = CU3.Id
          LEFT OUTER JOIN INDIGO031.GeneralLedger.MainAccounts AS CU4 ON C.IncomeRecognitionPendingBillingMainAccountId = CU4.Id;