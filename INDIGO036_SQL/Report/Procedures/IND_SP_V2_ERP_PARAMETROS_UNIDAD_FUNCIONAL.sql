-- Workspace: SQLServer
-- Item: INDIGO036 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_PARAMETROS_UNIDAD_FUNCIONAL
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE PROCEDURE [Report].[IND_SP_V2_ERP_PARAMETROS_UNIDAD_FUNCIONAL] 

AS

SELECT RTRIM(BO.Name) 'EMPRESA' ,FU.Code 'CODIGO UNIDAD FUNCIONAL' ,RTRIM(FU.Name) 'UNIDAD FUNCIONAL',CC.Code 'CODIGO CENTRO COSTO' ,RTRIM(CC.Name) 'CENTRO DE COSTO' ,
CPC.Code 'CODIGO CENTRO PRODUCCION',CPC.Name 'CENTRO PRODUCCION COSTO' ,ASS.Description 'ESTRUCTURA CONTABLE' ,
CASE FU.UnitType WHEN 1 THEN '1-Urgencias' WHEN 2 THEN '2-Hospitalizacion' WHEN 3 THEN '3-Apoyo Dx' WHEN 4 THEN '4-Apoyo Terapeutico' WHEN 5 THEN '5-Unidades de Cuidado Intensivo Adulto'
WHEN 6  THEN '6-Unidades de Cuidado Intermedio Adulto'  WHEN 7  THEN '7-Unidades de Cuidado Intensivo Pediatrica'  WHEN 8  THEN '8-Unidades de Cuidado Intermedio Pediatrica'  
WHEN 9  THEN '9-Unidades de Cuidado Intensivo Neonatal'  WHEN 10 THEN '10-Unidades de Cuidado Intermedio Neonatal'  WHEN 11 THEN '11-Unidades de Cuidado Basico Neonatal'  
WHEN 12 THEN '12-Unidad Renal'  WHEN 13 THEN '13-Unidad Oncologica'  WHEN 14 THEN '14-Unidad Medicina Nuclear'  WHEN 15 THEN '15-Consulta Externa'  WHEN 16 THEN '16-Unidad Mental'  
WHEN 17 THEN '17-Unidad de Quemados' WHEN 18 THEN '18-Unidad de Cuidado Paliativo'  WHEN 19 THEN '19-Cirugia'  WHEN 20 THEN '20-Laboratorio'  WHEN 21 THEN '21-Cardiologia No Invasiva'  
WHEN 22 THEN '22-Cardiologia Invasiva' WHEN 23 THEN '23-Gineco-Obstetricia' WHEN 24 THEN '24-Consulta Externa-Gineco-Obstetricia'WHEN 30 THEN '30-Otras'WHEN 31 THEN '31-Consulta Prioritaria' 
WHEN 32 THEN '32-Atención domiciliaria'WHEN 33 THEN '33-Unidad Radioterapia'WHEN 34 THEN '34-Unidad Braquiterapia'WHEN 35 THEN '35-Hemodinamia' ELSE 'Administrativa' END 'TIPO UNIDAD',
CASE FU.State WHEN 0 THEN 'INACTIVA' WHEN 1 THEN 'ACTIVA' END 'ESTADO'
FROM Payroll .FunctionalUnit FU WITH (NOLOCK)
LEFT JOIN Payroll .CostCenter AS CC WITH (NOLOCK) ON CC.Id =FU.CostCenterId 
LEFT JOIN Payroll .BranchOffice AS BO WITH (NOLOCK) ON BO.Id =FU.BranchOfficeId 
LEFT JOIN Cost.CostProductionCenter AS CPC WITH (NOLOCK) ON CPC.Id =FU.ProductionCenterId 
LEFT JOIN Payroll .AccountingStructure ASS WITH (NOLOCK) ON ASS.Id =FU.AccountingStructureId 
