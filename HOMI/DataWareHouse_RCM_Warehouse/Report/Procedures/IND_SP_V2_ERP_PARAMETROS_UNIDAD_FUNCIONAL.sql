-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: IND_SP_V2_ERP_PARAMETROS_UNIDAD_FUNCIONAL
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE Report.IND_SP_V2_ERP_PARAMETROS_UNIDAD_FUNCIONAL
AS
BEGIN
SELECT
    RTRIM(INDIGO036.Payroll.BranchOffice.Name) AS 'EMPRESA',
    INDIGO036.Payroll.FunctionalUnit.Code AS 'CODIGO UNIDAD FUNCIONAL',
    RTRIM(INDIGO036.Payroll.FunctionalUnit.Name) AS 'UNIDAD FUNCIONAL',
    INDIGO036.Payroll.CostCenter.Code AS 'CODIGO CENTRO COSTO',
    RTRIM(INDIGO036.Payroll.CostCenter.Name) AS 'CENTRO DE COSTO',
    INDIGO036.Cost.CostProductionCenter.Code AS 'CODIGO CENTRO PRODUCCION',
    INDIGO036.Cost.CostProductionCenter.Name AS 'CENTRO PRODUCCION COSTO',
    INDIGO036.Payroll.AccountingStructure.Description AS 'ESTRUCTURA CONTABLE',
    CASE
        INDIGO036.Payroll.FunctionalUnit.UnitType
        WHEN 1 THEN '1-Urgencias'
        WHEN 2 THEN '2-Hospitalizacion'
        WHEN 3 THEN '3-Apoyo Dx'
        WHEN 4 THEN '4-Apoyo Terapeutico'
        WHEN 5 THEN '5-Unidades de Cuidado Intensivo Adulto'
        WHEN 6 THEN '6-Unidades de Cuidado Intermedio Adulto'
        WHEN 7 THEN '7-Unidades de Cuidado Intensivo Pediatrica'
        WHEN 8 THEN '8-Unidades de Cuidado Intermedio Pediatrica'
        WHEN 9 THEN '9-Unidades de Cuidado Intensivo Neonatal'
        WHEN 10 THEN '10-Unidades de Cuidado Intermedio Neonatal'
        WHEN 11 THEN '11-Unidades de Cuidado Basico Neonatal'
        WHEN 12 THEN '12-Unidad Renal'
        WHEN 13 THEN '13-Unidad Oncologica'
        WHEN 14 THEN '14-Unidad Medicina Nuclear'
        WHEN 15 THEN '15-Consulta Externa'
        WHEN 16 THEN '16-Unidad Mental'
        WHEN 17 THEN '17-Unidad de Quemados'
        WHEN 18 THEN '18-Unidad de Cuidado Paliativo'
        WHEN 19 THEN '19-Cirugia'
        WHEN 20 THEN '20-Laboratorio'
        WHEN 21 THEN '21-Cardiologia No Invasiva'
        WHEN 22 THEN '22-Cardiologia Invasiva'
        WHEN 23 THEN '23-Gineco-Obstetricia'
        WHEN 24 THEN '24-Consulta Externa-Gineco-Obstetricia'
        WHEN 30 THEN '30-Otras'
        WHEN 31 THEN '31-Consulta Prioritaria'
        WHEN 32 THEN '32-Atención domiciliaria'
        WHEN 33 THEN '33-Unidad Radioterapia'
        WHEN 34 THEN '34-Unidad Braquiterapia'
        WHEN 35 THEN '35-Hemodinamia'
        ELSE 'Administrativa'
    END AS 'TIPO UNIDAD',
    CASE
        INDIGO036.Payroll.FunctionalUnit.State
        WHEN 0 THEN 'INACTIVA'
        WHEN 1 THEN 'ACTIVA'
    END AS 'ESTADO'
FROM
    INDIGO036.Payroll.FunctionalUnit
    LEFT JOIN INDIGO036.Payroll.CostCenter ON INDIGO036.Payroll.CostCenter.Id = INDIGO036.Payroll.FunctionalUnit.CostCenterId
    LEFT JOIN INDIGO036.Payroll.BranchOffice ON INDIGO036.Payroll.BranchOffice.Id = INDIGO036.Payroll.FunctionalUnit.BranchOfficeId
    LEFT JOIN INDIGO036.Cost.CostProductionCenter ON INDIGO036.Cost.CostProductionCenter.Id = INDIGO036.Payroll.FunctionalUnit.ProductionCenterId
    LEFT JOIN INDIGO036.Payroll.AccountingStructure ON INDIGO036.Payroll.AccountingStructure.Id = INDIGO036.Payroll.FunctionalUnit.AccountingStructureId

END