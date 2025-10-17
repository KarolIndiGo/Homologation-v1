-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_FACT_CUPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_FACT_CUPS]
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
            CASE SC.STATUS
                WHEN 1
                THEN 'Activo'
                WHEN 2
                THEN 'Inactivo'
            END AS Estado
     FROM Contract.CUPSEntity AS SC
          INNER JOIN Billing.BillingConcept AS C ON SC.BillingConceptId = C.Id
          INNER JOIN GeneralLedger.MainAccounts AS CU ON C.EntityIncomeAccountId = CU.Id
          INNER JOIN Contract.CupsSubgroup AS SG ON SC.CUPSSubGroupId = SG.Id;
