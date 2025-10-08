-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_JER_SUGERIDO_COMPRA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_JER_SUGERIDO_COMPRA AS

SELECT * FROM (
    SELECT 
        PROD.Sede, 
        PROD.Cod_Producto AS Cod_Producto, 
        PROD.Producto, 
        ISNULL(PROD.Cod_Med, PROD.Cod_Insumo) AS Cod_Medicamento_Insumo, 
        ISNULL(PROD.Medicamento, PROD.Insumo) AS Medicamento_Insumo,  
        PROD.Grupo,
        PROD.Dic_A, 
        PROD.Ene_V, 
        PROD.Feb_V, 
        PROD.Mar_V, 
        PROD.Abr_V, 
        PROD.May_V, 
        PROD.Jun_V, 
        PROD.Jul_V, 
        PROD.Ago_V, 
        PROD.Sep_V, 
        PROD.Oct_V, 
        PROD.Nov_V, 
        PROD.Dic_V, 
        ALMA.CostoPromedio, 
        ALMA.Ultimocosto, 
        (
            ISNULL(PROD.Ene_A, 0) + ISNULL(PROD.Feb_A, 0) + ISNULL(PROD.Mar_A, 0) + ISNULL(PROD.Abr_A, 0) + ISNULL(PROD.May_A, 0) + ISNULL(PROD.Jun_A, 0) + ISNULL(PROD.Jul_A, 0) + ISNULL(PROD.Ago_A, 0) + ISNULL(PROD.Sep_A, 0) 
            + ISNULL(PROD.Oct_A, 0) + ISNULL(PROD.Nov_A, 0) + ISNULL(PROD.Dic_A, 0) + ISNULL(PROD.Ene_V, 0) + ISNULL(PROD.Feb_V, 0) + ISNULL(PROD.Mar_V, 0) + ISNULL(PROD.Abr_V, 0) + ISNULL(PROD.May_V, 0) + ISNULL(PROD.Jun_V, 0) 
            + ISNULL(PROD.Jul_V, 0) + ISNULL(PROD.Ago_V, 0) + ISNULL(PROD.Sep_V, 0) + ISNULL(PROD.Oct_V, 0) + ISNULL(PROD.Nov_V, 0) + ISNULL(PROD.Dic_V, 0)
        ) AS RotacionTotal, 
        (
            IIF((PROD.Ene_A IS NULL), 0, 1) + IIF((PROD.Feb_A IS NULL), 0, 1) + IIF((PROD.Mar_A IS NULL), 0, 1) + IIF((PROD.Abr_A IS NULL), 0, 1) + IIF((PROD.May_A IS NULL), 0, 1) + IIF((PROD.Jun_A IS NULL), 0, 1) 
            + IIF((PROD.Jul_A IS NULL), 0, 1) + IIF((PROD.Ago_A IS NULL), 0, 1) + IIF((PROD.Sep_A IS NULL), 0, 1) + IIF((PROD.Oct_A IS NULL), 0, 1) + IIF((PROD.Nov_A IS NULL), 0, 1) + IIF((PROD.Dic_A IS NULL), 0, 1)
            + IIF((PROD.Ene_V IS NULL), 0, 1) + IIF((PROD.Feb_V IS NULL), 0, 1) + IIF((PROD.Mar_V IS NULL), 0, 1) + IIF((PROD.Abr_V IS NULL), 0, 1) + IIF((PROD.May_V IS NULL), 0, 1) + IIF((PROD.Jun_V IS NULL), 0, 1) 
            + IIF((PROD.Jul_V IS NULL), 0, 1) + IIF((PROD.Ago_V IS NULL), 0, 1) + IIF((PROD.Sep_V IS NULL), 0, 1) + IIF((PROD.Oct_V IS NULL), 0, 1) + IIF((PROD.Nov_V IS NULL), 0, 1) + IIF((PROD.Dic_V IS NULL), 0, 1)
        ) AS MesesRotados, 
        (
            ISNULL(ALMA.[TJA001], 0) + ISNULL(ALMA.[DUI001], 0) + ISNULL(ALMA.[SOG001], 0) + ISNULL(ALMA.[YPL001], 0) + ISNULL(ALMA.[CHQ001], 0) + ISNULL(ALMA.[STA001], 0) + ISNULL(ALMA.[GTQ001], 0) + ISNULL(ALMA.[GRG001], 0) 
            + ISNULL(ALMA.[MQR001], 0) + ISNULL(ALMA.[PBY001], 0) + ISNULL(ALMA.[VIN001], 0) + ISNULL(ALMA.[PTG001], 0) + ISNULL(ALMA.[RME100], 0) + ISNULL(ALMA.[MRS001], 0) + ISNULL(ALMA.[PTL001], 0) + ISNULL(ALMA.[RCA100], 0) 
            + ISNULL(ALMA.[ACB001], 0) + ISNULL(ALMA.[VCO001], 0) + ISNULL(ALMA.[ACM001], 0) + ISNULL(ALMA.[AGZ001], 0) + ISNULL(ALMA.[ACC001], 0) + ISNULL(ALMA.[SMT001], 0) + ISNULL(ALMA.[GND001], 0) + ISNULL(ALMA.[PDA001], 0) 
            + ISNULL(ALMA.[TJA100], 0) + ISNULL(ALMA.[ACA001], 0)
        ) AS TotalSaldo
    FROM 
        [DataWareHouse_Finance].[ViewInternal].[VW_V_INN_JER_SALDOALMACENES] AS ALMA
        RIGHT JOIN [DataWareHouse_Finance].[ViewInternal].[VW_V_INN_JER_CONSUMOPROMEDIO] AS PROD 
            ON ALMA.Codigo = PROD.Cod_Producto
            AND PROD.Sede = ALMA.Sede COLLATE SQL_Latin1_General_CP1_CI_AS
) AS a
WHERE a.TotalSaldo > 0