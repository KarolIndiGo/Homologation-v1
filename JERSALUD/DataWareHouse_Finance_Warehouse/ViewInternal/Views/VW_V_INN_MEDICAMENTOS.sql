-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_MEDICAMENTOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_MEDICAMENTOS AS

SELECT 
    M.Id,
    DCI.Code AS CodDCI,
    DCI.Name AS DCI,
    M.Code,
    M.Name AS Medicamento,
    M.AbbreviationName,
    VA.Code AS Via,
    VA.Name AS ViAdministracion,
    GF.Code AS Grupo,
    GF.Name AS GrupoFarmacologico,
    M.Concentration,
    NR.Code AS CodNivel,
    NR.Name AS NivelRiesgo,
    CASE M.FormulationType 
        WHEN 1 THEN 'Peso' 
        WHEN 2 THEN 'Volumen' 
        WHEN 3 THEN 'Peso-Volumen'
        WHEN 4 THEN 'UnidadAdmin' 
    END AS TipoFormula,
    M.Weight AS Peso,
    U.Name AS UnidadPeso,
    M.Volume,
    U1.Name AS UnidadVolumen,
    U2.Name AS UnidadD,
    CASE M.POSProduct 
        WHEN 1 THEN 'POS' 
        WHEN 0 THEN 'NO POS' 
    END AS Tipo,
    CASE M.AllPOSPathologies 
        WHEN 1 THEN 'SI' 
        WHEN 0 THEN 'NO' 
    END AS TodasPatalogias,
    CASE M.AutomaticCalculation 
        WHEN 1 THEN 'Si'
        WHEN 0 THEN 'No' 
    END AS 'Calculo Automatico',
    CASE M.TransferSurplusProduct 
        WHEN 1 THEN 'Si'
        WHEN 0 THEN 'No' 
    END AS TrasladaSobrante,
    CASE M.DiluentProduct 
        WHEN 1 THEN 'Si'
        WHEN 0 THEN 'No' 
    END AS Diluyente,
    CASE M.JustificationForSpecialDrugs 
        WHEN 1 THEN 'Si'
        WHEN 0 THEN 'No' 
    END AS 'Justificacion Medicamento Especial',
    CASE M.JustificationOfInputs 
        WHEN 1 THEN 'Si'
        WHEN 0 THEN 'No' 
    END AS 'Justifica Insumo/Dispositivo',
    CASE M.IndicatorDrug 
        WHEN 1 THEN 'Si'
        WHEN 0 THEN 'No' 
    END AS 'Medicamento Trazador',
    A.Code AS ATC
FROM INDIGO031.Inventory.ATC M
JOIN INDIGO031.Inventory.DCI DCI ON M.DCIId = DCI.Id AND M.Status = 1
JOIN INDIGO031.Inventory.AdministrationRoute VA ON M.AdministrationRouteId = VA.Id
JOIN INDIGO031.Inventory.PharmacologicalGroup GF ON M.PharmacologicalGroupId = GF.Id
JOIN INDIGO031.Inventory.InventoryRiskLevel NR ON M.InventoryRiskLevelId = NR.Id
LEFT JOIN INDIGO031.Inventory.InventoryMeasurementUnit U ON M.WeightMeasureUnit = U.Id
LEFT JOIN INDIGO031.Inventory.InventoryMeasurementUnit U1 ON M.VolumeMeasureUnit = U1.Id
LEFT JOIN INDIGO031.Inventory.InventoryMeasurementUnit U2 ON M.AdministrationUnitId = U2.Id
JOIN INDIGO031.Inventory.ATCEntity A ON M.ATCEntityId = A.Id