-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_INN_Miomed_Sugerido_Compra
-- Extracted by Fabric SQL Extractor SPN v3.9.0




create VIEW [ViewInternal].[V_INN_Miomed_Sugerido_Compra]
--ALTER VIEW [dbo].[V_INN_JER_Inferido]
AS
     SELECT PROD.Sede, 
            PROD.Cod_Producto AS Cod_Producto, 
            PROD.Producto, 
            ISNULL(PROD.Cod_Med, PROD.Cod_Insumo) AS Cod_Medicamento_Insumo, 
            ISNULL(PROD.Medicamento, PROD.Insumo) AS Medicamento_Insumo, 
            PROD.CodigoCUM AS CUM, 
            PROD.CodSubgrupo AS SubGrupo, 
            PROD.TipoProducto, 
            PROD.GrupoFacturacion, 
            PROD.ProdControl, 
            PROD.[CodATC] AS ATC, 
            PROD.ATC AS NombreATC, 
            PROD.Abreviatura, 
            PROD.Estado, 
            PROD.AltoCosto, 
            PROD.UnidadEmpaque, 
            PROD.FactorConversion, 
            PROD.Fabricante, 
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
            prod.CostoPromedio, 
            ALMA.Ultimocosto, 
            (ISNULL(PROD.Ene_A, 0) + ISNULL(PROD.Feb_A, 0) + 
			 ISNULL(PROD.Mar_A, 0) + ISNULL(PROD.Abr_A, 0) + 
			 ISNULL(PROD.May_A, 0) + ISNULL(PROD.Jun_A, 0) + 
			 ISNULL(PROD.Jul_A, 0) + ISNULL(PROD.Ago_A, 0) + 
			 ISNULL(PROD.Sep_A, 0) + ISNULL(PROD.Oct_A, 0) + 
			 ISNULL(PROD.Nov_A, 0) + ISNULL(PROD.Dic_A, 0) + 
			 ISNULL(PROD.Ene_V, 0) + ISNULL(PROD.Feb_V, 0) + 
			 ISNULL(PROD.Mar_V, 0) + ISNULL(PROD.Abr_V, 0) + 
			 ISNULL(PROD.May_V, 0) + ISNULL(PROD.Jun_V, 0) + 
			 ISNULL(PROD.Jul_V, 0) + ISNULL(PROD.Ago_V, 0) + 
			 ISNULL(PROD.Sep_V, 0) + ISNULL(PROD.Oct_V, 0) + 
			 ISNULL(PROD.Nov_V, 0) + ISNULL(PROD.Dic_V, 0)
			) AS RotacionTotal, 
            (IIF((PROD.Ene_A IS NULL), 0, 1) + 
			 IIF((PROD.Feb_A IS NULL), 0, 1) + 
			 IIF((PROD.Mar_A IS NULL), 0, 1) + 
			 IIF((PROD.Abr_A IS NULL), 0, 1) + 
			 IIF((PROD.May_A IS NULL), 0, 1) + 
			 IIF((PROD.Jun_A IS NULL), 0, 1) + 
			 IIF((PROD.Jul_A IS NULL), 0, 1) + 
			 IIF((PROD.Ago_A IS NULL), 0, 1) + 
			 IIF((PROD.Sep_A IS NULL), 0, 1) + 
			 IIF((PROD.Oct_A IS NULL), 0, 1) + 
			 IIF((PROD.Nov_A IS NULL), 0, 1) + 
			 IIF((PROD.Dic_A IS NULL), 0, 1) + 
			 IIF((PROD.Ene_V IS NULL), 0, 1) + 
			 IIF((PROD.Feb_V IS NULL), 0, 1) + 
			 IIF((PROD.Mar_V IS NULL), 0, 1) + 
			 IIF((PROD.Abr_V IS NULL), 0, 1) + 
			 IIF((PROD.May_V IS NULL), 0, 1) + 
			 IIF((PROD.Jun_V IS NULL), 0, 1) + 
			 IIF((PROD.Jul_V IS NULL), 0, 1) + 
			 IIF((PROD.Ago_V IS NULL), 0, 1) + 
			 IIF((PROD.Sep_V IS NULL), 0, 1) + 
			 IIF((PROD.Oct_V IS NULL), 0, 1) + 
			 IIF((PROD.Nov_V IS NULL), 0, 1) + 
			 IIF((PROD.Dic_V IS NULL), 0, 1)
			) AS MesesRotados, 
            (ISNULL(ALMA.[002], 0) + 
			 ISNULL(ALMA.[003], 0) + 
			 ISNULL(ALMA.[004], 0) + 
			 ISNULL(ALMA.[005], 0) + 
			 ISNULL(ALMA.[006], 0) + 
			 ISNULL(ALMA.[007], 0) + 
			 ISNULL(ALMA.[008], 0) + 
			 ISNULL(ALMA.[009], 0) + 
			 ISNULL(ALMA.[11], 0) + 
			 ISNULL(ALMA.[010], 0) + 
			 ISNULL(ALMA.[012], 0) + 
			 ISNULL(ALMA.[013], 0) + 
			 ISNULL(ALMA.[014], 0) + 
			 ISNULL(ALMA.[015], 0) + 
			 ISNULL(ALMA.[016], 0) + 
			 ISNULL(ALMA.[17], 0) + 
			 ISNULL(ALMA.[18], 0) +
			 ISNULL(ALMA.[19], 0) +
			 ISNULL(ALMA.[20], 0) +
			 ISNULL(ALMA.[21], 0)
			) AS TotalSaldo
     FROM
     ViewInternal.V_INN_Miomed_SaldoAlmacenes AS ALMA
     RIGHT JOIN ViewInternal.V_INN_Miomed_ConsumoPromedio AS PROD ON ALMA.Codigo = PROD.Cod_Producto
                                                     AND PROD.Sede = ALMA.Sede COLLATE SQL_Latin1_General_CP1_CI_AS;
--WHERE PROD.Cod_Producto='20105885-01' --AND PROD.Sede='ACACIAS'
