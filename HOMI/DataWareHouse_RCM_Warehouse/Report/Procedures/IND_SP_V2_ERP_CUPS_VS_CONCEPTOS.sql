-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: IND_SP_V2_ERP_CUPS_VS_CONCEPTOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE Report.IND_SP_V2_ERP_CUPS_VS_CONCEPTOS
AS
BEGIN
WITH CTE_CUPS AS (
  SELECT
    CUPS.Code AS CUPS,
    CUPS.Description AS DESCRIPCION,
    CUPS.RIPSCode AS [CODIGO RIPS],
    CG.Code AS [CODIGO GRUPO],
    CG.Name AS [NOMBRE GRUPO],
    CSG.Code AS [CODIGO SUB GRUPO],
    CSG.Name AS [SUB GRUPO],
    CASE
      WHEN CUPS.RIPSConcept = 01 THEN '01 - Consultas'
      WHEN CUPS.RIPSConcept = 02 THEN '02 - Procedimientos de diagnósticos'
      WHEN CUPS.RIPSConcept = 03 THEN '03 - Procedimientos terapéuticos no quirúrgicos'
      WHEN CUPS.RIPSConcept = 04 THEN '04 - Procedimientos terapéuticos quirúrgicos'
      WHEN CUPS.RIPSConcept = 05 THEN '05 - Procedimientos de promoción y prevención'
      WHEN CUPS.RIPSConcept = 06 THEN '06 - Estancias'
      WHEN CUPS.RIPSConcept = 07 THEN '07 - Honorarios'
      WHEN CUPS.RIPSConcept = 08 THEN '08 - Derechos de sala'
      WHEN CUPS.RIPSConcept = 09 THEN '09 - Materiales e insumos'
      WHEN CUPS.RIPSConcept = 10 THEN '10 - Banco de sangre'
      WHEN CUPS.RIPSConcept = 11 THEN '11 - Prótesis y órtesis'
      WHEN CUPS.RIPSConcept = 12 THEN '12 - Medicamentos POS'
      WHEN CUPS.RIPSConcept = 13 THEN '13 - Medicamentos no POS'
      WHEN CUPS.RIPSConcept = 14 THEN '14 - Traslado de pacientes'
    END AS [CONCEPTO RIPS],
    CASE
      WHEN CUPS.ServiceType = 1 THEN 'Laboratorios'
      WHEN CUPS.ServiceType = 2 THEN 'Patologias'
      WHEN CUPS.ServiceType = 3 THEN 'Imagenes Diagnosticas'
      WHEN CUPS.ServiceType = 4 THEN 'Procedimeintos no Qx'
      WHEN CUPS.ServiceType = 5 THEN 'Procedimientos Qx'
      WHEN CUPS.ServiceType = 6 THEN 'Interconsultas'
      WHEN CUPS.ServiceType = 7 THEN 'Ninguno'
      WHEN CUPS.ServiceType = 8 THEN 'Consulta Externa'
    END AS [TIPO SERVICIO],
    BG.Code AS [CODIGO GRUPO FACTURACION],
    BG.Name AS [GRUPO FACTURACION],
    BC.Code AS [CODIGO CONCEPTO FACTURACION],
    BC.Name AS [CONCEPTO DE FACTURACION],
    BC.Id AS ID_CF,
    CD.Code AS [CODIGO DESCRI REALACIONADA],
    CD.Name AS [DESCRIPCION RELACIONADA],
    BGR.Name AS [GRUPO DESCRI RELACIONADA],
    BCR.Code AS [COD CONCEPTO FACTURACION RELACIONADA],
    BCR.Name AS [CONCEPTO DE FACTURACION RELACIONADA],
    DESCR.BillingConceptId AS ID_CFR
  FROM
    INDIGO036.Contract.CUPSEntity CUPS
    INNER JOIN INDIGO036.Contract.CupsSubgroup CSG ON CSG.Id = CUPS.CUPSSubGroupId
    INNER JOIN INDIGO036.Contract.CupsGroup AS CG ON CG.Id = CSG.CupsGroupId
    INNER JOIN INDIGO036.Billing.BillingGroup BG ON BG.Id = CUPS.BillingGroupId
    INNER JOIN INDIGO036.Billing.BillingConcept AS BC ON BC.Id = CUPS.BillingConceptId
    LEFT JOIN INDIGO036.Contract.CUPSEntityContractDescriptions AS DESCR ON DESCR.CUPSEntityId = CUPS.Id
    LEFT JOIN INDIGO036.Contract.ContractDescriptions AS CD ON CD.Id = DESCR.ContractDescriptionId
    LEFT JOIN INDIGO036.Billing.BillingGroup BGR ON BGR.Id = DESCR.BillingGroupId
    LEFT JOIN INDIGO036.Billing.BillingConcept AS BCR ON BCR.Id = DESCR.BillingConceptId
),
CTE_CONCEPTOS AS (
  SELECT
    *
  FROM
    (
      SELECT
        BC.Id AS ID_CON,
        BC.Code AS [CODIGO],
        BC.Name AS [NOMBRE CONCEPTO],
        CASE
          WHEN BC.ConceptType = 1 THEN 'Facturación Básica'
          WHEN BC.ConceptType = 2 THEN 'Facturacion Salud'
        END AS [TIPO CONCEPTO],
        CASE
          WHEN BC.ObtainCostCenter = 1 THEN 'Unidad Funcional del Paciente'
          WHEN BC.ObtainCostCenter = 2 THEN 'Centro de Costo Específico'
          WHEN BC.ObtainCostCenter = 3 THEN 'Centro de Costo por Sucursal y Unidad Funcional'
          ELSE ''
        END AS [OBTENER CENTRO COSTO],
        IIF(BC.ObtainCostCenter = 2, CC.Code, '') AS [CODIGO CC],
        IIF(BC.ObtainCostCenter = 2, CC.Name, '') AS [CENTRO COSTO],
        CASE
          WHEN BC.AccountingType = 1 THEN 'Cuenta Unica de Ingreso'
          WHEN BC.AccountingType = 2 THEN 'Cuenta por Tipo de Unidad'
          ELSE ''
        END AS [TIPO CONTABILIZACION],
        IIF(
          BC.AccountingType = 1,
          MA.Number,
          IIF(BC.ConceptType = 1, MA.Number, '')
        ) AS [CUENTA ENTIDAD],
        IIF(
          BC.AccountingType = 1,
          MA.Name,
          IIF(BC.ConceptType = 1, MA.Name, '')
        ) AS [CUENTA INGRESO ENTIDAD],
        IIF(
          BC.AccountingType = 1,
          MA2.Number,
          IIF(BC.ConceptType = 1, MA2.Number, '')
        ) AS [CUENTA PARTICULAR],
        IIF(
          BC.AccountingType = 1,
          MA2.Name,
          IIF(BC.ConceptType = 1, MA2.Name, '')
        ) AS [CUENTA INGRESO PARTICULAR],
        IIF(
          BC.AccountingType = 1,
          MA3.Number,
          IIF(BC.ConceptType = 1, MA3.Number, '')
        ) AS [CUENTA RECONOCIMIENTO],
        IIF(
          BC.AccountingType = 1,
          MA3.Name,
          IIF(BC.ConceptType = 1, MA3.Name, '')
        ) AS [CUENTA INGRESO RECONOCIMIENTO],
        IIF(
          BC.AccountingType = 1,
          MA4.Number,
          IIF(BC.ConceptType = 1, MA4.Number, '')
        ) AS [CUENTA HONORARIOS],
        IIF(
          BC.AccountingType = 1,
          MA4.Name,
          IIF(BC.ConceptType = 1, MA4.Name, '')
        ) AS [CUENTA GASTO HONORARIO],
        IIF(
          BC.AccountingType = 1,
          MA9.Number,
          IIF(BC.ConceptType = 1, MA9.Number, '')
        ) AS [CUENTA DESCUENTO],
        IIF(
          BC.AccountingType = 1,
          MA9.Name,
          IIF(BC.ConceptType = 1, MA9.Name, '')
        ) AS [CUENTA PARA DESCUENTO],
        CASE
          WHEN BCA.UnitType = 1 THEN 'URGENCIAS'
          WHEN BCA.UnitType = 2 THEN 'HOSPITALIZACION'
          WHEN BCA.UnitType = 3 THEN 'QUIROFANO'
          WHEN BCA.UnitType = 4 THEN 'CONSULTA EXTERNA'
        END AS [TIPO UNIDAD],
        MA5.Number + '-' + 'IE' + '/' + MA6.Number + '-' + 'IP' + '/' + MA8.Number + '-' + 'GH' + '/' + MA7.Number + '-' + 'RI' AS [CUENTA INGRESO UF]
      FROM
        INDIGO036.Billing.BillingConcept BC
        LEFT JOIN INDIGO036.Payroll.CostCenter AS CC ON CC.Id = BC.ObtainCostCenter
        LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA ON MA.Id = BC.EntityIncomeAccountId
        LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA2 ON MA2.Id = BC.IndividualIncomeAccountId
        LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA3 ON MA3.Id = BC.IncomeRecognitionPendingBillingMainAccountId
        LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA4 ON MA4.Id = BC.FeesExpensesAccountId
        LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA9 ON MA9.Id = BC.DiscountAccountId
        LEFT JOIN INDIGO036.Billing.BillingConceptAccount AS BCA ON BCA.BillingConceptId = BC.Id
        LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA5 ON MA5.Id = BCA.EntityIncomeAccountId
        LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA6 ON MA6.Id = BCA.IndividualIncomeAccountId
        LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA7 ON MA7.Id = BCA.IncomeRecognitionMainAccountId
        LEFT JOIN INDIGO036.GeneralLedger.MainAccounts MA8 ON MA8.Id = BCA.FeesExpensesAccountId
    ) AS SourceTable
    PIVOT (
      MAX([CUENTA INGRESO UF]) FOR [TIPO UNIDAD] IN (
        [URGENCIAS],
        [HOSPITALIZACION],
        [QUIROFANO],
        [CONSULTA EXTERNA]
      )
    ) AS PVTTABLE
)
SELECT
  CUPS.CUPS,
  CUPS.DESCRIPCION,
  CUPS.[CODIGO RIPS],
  CUPS.[CODIGO GRUPO],
  CUPS.[NOMBRE GRUPO],
  CUPS.[CODIGO SUB GRUPO],
  CUPS.[SUB GRUPO],
  CUPS.[CONCEPTO RIPS],
  CUPS.[TIPO SERVICIO],
  CUPS.[CODIGO GRUPO FACTURACION],
  CUPS.[GRUPO FACTURACION],
  CUPS.[CODIGO CONCEPTO FACTURACION],
  CUPS.[CONCEPTO DE FACTURACION],
  CON.[TIPO CONCEPTO],
  CON.[OBTENER CENTRO COSTO],
  CON.[CENTRO COSTO],
  CON.[TIPO CONTABILIZACION],
  CON.[CUENTA ENTIDAD],
  CON.[CUENTA INGRESO ENTIDAD],
  CON.[CUENTA PARTICULAR],
  CON.[CUENTA INGRESO PARTICULAR],
  CON.[CUENTA RECONOCIMIENTO],
  CON.[CUENTA INGRESO RECONOCIMIENTO],
  CON.[CUENTA HONORARIOS],
  CON.[CUENTA GASTO HONORARIO],
  CON.[CUENTA DESCUENTO],
  CON.[CUENTA PARA DESCUENTO],
  CON.URGENCIAS,
  CON.HOSPITALIZACION,
  CON.QUIROFANO,
  CON.[CONSULTA EXTERNA],
  CUPS.[CODIGO DESCRI REALACIONADA],
  CUPS.[DESCRIPCION RELACIONADA],
  CUPS.[GRUPO DESCRI RELACIONADA],
  CUPS.[COD CONCEPTO FACTURACION RELACIONADA],
  CUPS.[CONCEPTO DE FACTURACION RELACIONADA],
  CONR.[OBTENER CENTRO COSTO] AS [OBTENER CENTRO COSTO R],
  CONR.[CENTRO COSTO] AS [CENTRO COSTO R],
  CONR.[TIPO CONTABILIZACION] AS [TIPO CONTABILIZACION R],
  CONR.[CUENTA ENTIDAD] AS [CUENTA ENTIDAD R],
  CONR.[CUENTA INGRESO ENTIDAD] AS [CUENTA INGRESO ENTIDAD R],
  CONR.[CUENTA PARTICULAR] AS [CUENTA PARTICULAR R],
  CONR.[CUENTA INGRESO PARTICULAR] AS [CUENTA INGRESO PARTICULAR R],
  CONR.[CUENTA RECONOCIMIENTO] AS [CUENTA RECONOCIMIENTO R],
  CONR.[CUENTA INGRESO RECONOCIMIENTO] AS [CUENTA INGRESO RECONOCIMIENTO R],
  CONR.[CUENTA HONORARIOS] AS [CUENTA HONORARIOS R],
  CONR.[CUENTA GASTO HONORARIO] AS [CUENTA GASTO HONORARIO R],
  CONR.URGENCIAS AS [URGENCIAS R],
  CONR.HOSPITALIZACION AS [HOSPITALIZACION R],
  CONR.QUIROFANO AS [QUIROFANO R],
  CONR.[CONSULTA EXTERNA] AS [CONSULTA EXTERNA R]
FROM
  CTE_CUPS CUPS
  LEFT JOIN CTE_CONCEPTOS AS CON ON CUPS.ID_CF = CON.ID_CON
  LEFT JOIN CTE_CONCEPTOS AS CONR ON CUPS.ID_CFR = CONR.ID_CON
END