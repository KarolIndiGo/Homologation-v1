-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_FACT_CUPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_FACT_CUPS
AS
     SELECT SC.Code AS CUPS, 
            SC.Description AS Servicio, 
            C.Code + ' - ' + C.Name AS Concepto, 
            CU.Number + ' - ' + CU.Name AS CuentaContable, 
            SG.Name AS SubGrupo,
            CASE ServiceType
                WHEN 1
                THEN 'Laboratorios'
                WHEN 2
                THEN 'Patologias'
                WHEN 3
                THEN 'Imagenes Diagnosticas'
                WHEN 4
                THEN 'Procedimeintos no Qx'
                WHEN 5
                THEN 'Procedimientos Qx'
                WHEN 6
                THEN 'Interconsultas'
                WHEN 7
                THEN 'Ninguno'
                WHEN 8
                THEN 'Consulta Externa'
            END AS TipoServicio,
            CASE SC.Status
                WHEN 1
                THEN 'Activo'
                WHEN 2
                THEN 'Inactivo'
            END AS Estado
     FROM INDIGO031.Contract.CUPSEntity AS SC
          INNER JOIN INDIGO031.Billing.BillingConcept AS C ON SC.BillingConceptId = C.Id
          INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS CU ON C.EntityIncomeAccountId = CU.Id
          INNER JOIN INDIGO031.Contract.CupsSubgroup AS SG ON SC.CUPSSubGroupId = SG.Id;