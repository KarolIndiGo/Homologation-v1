-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_INN_JER_Inferido
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[V_INN_JER_Inferido]
AS
     SELECT DISTINCT 
            ALMA.Sede, 
            ALMA.Codigo AS Cod_Producto, 
            ALMA.Producto, 
            ISNULL(ALMA.[Cod Med], ALMA.Cod_Insumo) AS Cod_Medicamento_Insumo, 
            ISNULL(ALMA.Medicamento, ALMA.Insumo) AS Medicamento_Insumo, 
            ALMA.CUM, 
            ALMA.SubGrupo, 
            ALMA.TipoProducto, 
            ALMA.UnidadEmpaque, 
            ALMA.GrupoFacturacion, 
            ALMA.ProdControl, 
            ALMA.ATC, 
            ALMA.NombreATC, 
            ALMA.Abreviatura, 
            PROD.Ene_A, 
            PROD.Feb_A, 
            PROD.Mar_A, 
            PROD.Abr_A, 
            PROD.May_A, 
            PROD.Jun_A, 
            PROD.Jul_A, 
            PROD.Ago_A, 
            PROD.Sep_A, 
            PROD.Oct_A, 
            PROD.Nov_A, 
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
            PROD.Prom_Ulti_Semestre, 
            ALMA.CostoPromedio, 
            ALMA.Ultimocosto, 
            ALMA.Estado, 
            ALMA.AltoCosto,
            CASE
                WHEN ALMA.Sede = 'TUNJA'
                     AND ALMA.[TU01] > 0
                THEN ALMA.[TU01]
            END AS [TJA-TU01],
            CASE
                WHEN ALMA.Sede = 'DUITAMA'
                     AND ALMA.[DU01] > 0
                THEN ALMA.[DU01]
            END AS [DUI-DU01],
            CASE
                WHEN ALMA.Sede = 'SOGAMOSO'
                     AND ALMA.[SO01] > 0
                THEN ALMA.[SO01]
            END AS [SOG-SO01],
            CASE
                WHEN ALMA.Sede = 'CHIQUINQUIRA'
                     AND ALMA.[CH01] > 0
                THEN ALMA.[CH01]
            END AS [CHI-CH01],
            CASE
                WHEN ALMA.Sede = 'SOATA'
                     AND ALMA.[ST01] > 0
                THEN ALMA.[ST01]
            END AS [SOA-ST01],
            CASE
                WHEN ALMA.Sede = 'GUATEQUE'
                     AND ALMA.[GU01] > 0
                THEN ALMA.[GU01]
            END AS [GUA-GU01],
            CASE
                WHEN ALMA.Sede = 'GARAGOA'
                     AND ALMA.[GA01] > 0
                THEN ALMA.[GA01]
            END AS [GAR-GA01],
            CASE
                WHEN ALMA.Sede = 'MONIQUIRA'
                     AND ALMA.[MO01] > 0
                THEN ALMA.[MO01]
            END AS [MON-MO01],
            CASE
                WHEN ALMA.Sede = 'VILLAVICENCIO'
                     AND ALMA.[VI01] > 0
                THEN ALMA.[VI01]
            END AS [VIL-VI01],
            CASE
                WHEN ALMA.Sede = 'GRANADA'
                     AND ALMA.[GR01] > 0
                THEN ALMA.[GR01]
            END AS [GRA-GR01],
            CASE
                WHEN ALMA.Sede = 'ACACIAS'
                     AND ALMA.[AC01] > 0
                THEN ALMA.[AC01]
            END AS [ACA-AC01],
            CASE
                WHEN ALMA.Sede = 'PUERTO LOPEZ'
                     AND ALMA.[PL01] > 0
                THEN ALMA.[PL01]
            END AS [PLO-PL01],
            CASE
                WHEN ALMA.Sede = 'PUERTO GAITAN'
                     AND ALMA.[PG01] > 0
                THEN ALMA.[PG01]
            END AS [PGA-PG01],
            CASE
                WHEN ALMA.Sede = 'YOPAL'
                     AND ALMA.[YO01] > 0
                THEN ALMA.[YO01]
            END AS [YOP-YO01],
            CASE
                WHEN ALMA.Sede = 'PUERTO BOYACA'
                     AND ALMA.[PB01] > 0
                THEN ALMA.[PB01]
            END AS [PBO-PB01],
            CASE
                WHEN ALMA.Sede = 'TUNJA'
                     AND ALMA.[010] > 0
                THEN ALMA.[010]
            END AS [AltoCostoBoyaca],
            CASE
                WHEN ALMA.Sede = 'VILLAVICENCIO'
                     AND ALMA.[VI02] > 0
                THEN ALMA.[VI02]
            END AS [BodegaVillavicencio],
            CASE
                WHEN ALMA.Sede = 'VILLAVICENCIO'
                     AND ALMA.[012] > 0
                THEN ALMA.[012]
            END AS [AltoCostoMeta],
            CASE
                WHEN ALMA.Sede = 'YOPAL'
                     AND ALMA.[013] > 0
                THEN ALMA.[013]
            END AS [AltoCostoCasanare]
     FROM --V_INN_JER_ConsumoPromedio AS PROD LEFT JOIN
     --V_INN_JER_SaldoAlmacenes AS ALMA ON ALMA.Codigo = PROD.Cod_Producto AND PROD.IdAlmacen=ALMA.IdAlmacen
     V_INN_JER_SaldoAlmacenes AS ALMA
     LEFT JOIN V_INN_JER_ConsumoPromedio AS PROD ON ALMA.Codigo = PROD.Cod_Producto
                                                    AND PROD.Sede = ALMA.Sede COLLATE SQL_Latin1_General_CP1_CI_AS;
--WHERE PROD.Cod_Producto='20037237' --AND PROD.Sede='ACACIAS'
