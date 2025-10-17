-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewInventarioInferido
-- Extracted by Fabric SQL Extractor SPN v3.9.0






--    /*******************************************************************************************************************
--Nombre: ViewInventarioInferido
--Tipo:Vista
--Observacion:trae el promedio del insumo por mes y el inventario actual por mes.
--Profesional: Nilsson Miguel Galindo Lopez
--Fecha:28-06-2022
-----------------------------------------------------------------------------
--Modificaciones
--_____________________________________________________________________________
--Vercion 1
--Persona que modifico: 
--Fecha:
--Ovservaciones: 
----------------------------------------
--Vercion 2
--Persona que modifico:
--Fecha:
--***********************************************************************************************************************************/

CREATE VIEW [Report].[ViewInventarioInferido]
AS
SELECT        
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
PROD.Sede, PROD.Cod_Producto, PROD.Producto, PROD.Medicamento, PROD.CodigoCUM, PROD.CodSubgrupo, PROD.TipoProducto, ALMA.Unidad, ALMA.GrupoFacturación, ALMA.ProdControl, PROD.CodATC, PROD.ATC, 
ALMA.[STOCK MINIMO],ALMA.[STOCK MAXIMO],
PROD.Ene_A, PROD.Feb_A, PROD.Mar_A, PROD.Abr_A, PROD.May_A, PROD.Jun_A, PROD.Jul_A, PROD.Ago_A, PROD.Sep_A, PROD.Oct_A, PROD.Nov_A, PROD.Dic_A, PROD.Ene_V, PROD.Feb_V, PROD.Mar_V, PROD.Abr_V, 
PROD.May_V, PROD.Jun_V, PROD.Jul_V, PROD.Ago_V, PROD.Sep_V, PROD.Oct_V, PROD.Nov_V, PROD.Dic_V, PROD.Prom_Ulti_Semestre, ALMA.CostoPromedio, ALMA.Ultimocosto, PROD.Estado, 
CASE WHEN  ALMA.[0101] > 0 THEN ALMA.[0101] END AS [0101], 
CASE WHEN  ALMA.[0102] > 0 THEN ALMA.[0102] END AS [0102], 
CASE WHEN  ALMA.[02] > 0 THEN ALMA.[02] END AS [02], 
CASE WHEN  ALMA.[0201] > 0 THEN ALMA.[0201] END AS [0201],
CASE WHEN  ALMA.[0202] > 0 THEN ALMA.[0202] END AS [0202],
CASE WHEN  ALMA.[0203] > 0 THEN ALMA.[0203] END AS [0203],
CASE WHEN  ALMA.[03] > 0 THEN ALMA.[03] END AS [03],
CASE WHEN  ALMA.[04] > 0 THEN ALMA.[04] END AS [04],
CASE WHEN  ALMA.[05] > 0 THEN ALMA.[05] END AS [05],
CASE WHEN  ALMA.[06] > 0 THEN ALMA.[06] END AS [06],
CASE WHEN  ALMA.[07] > 0 THEN ALMA.[07] END AS [07],
CASE WHEN  ALMA.[08] > 0 THEN ALMA.[08] END AS [08],
CASE WHEN  ALMA.[09] > 0 THEN ALMA.[09] END AS [09],
CASE WHEN  ALMA.[10] > 0 THEN ALMA.[10] END AS [10],
CASE WHEN  ALMA.[11] > 0 THEN ALMA.[11] END AS [11],
CASE WHEN  ALMA.[12] > 0 THEN ALMA.[12] END AS [12],
CASE WHEN  ALMA.[13] > 0 THEN ALMA.[13] END AS [13],
1 as 'CANTIDAD',
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM            
[Report].[ViewInventarioConsumoPromedio] AS PROD LEFT OUTER JOIN
[Report].[ViewInventarioSaldoAlmacenes] AS ALMA ON ALMA.Código = PROD.Cod_Producto
--where PROD.Cod_Producto='00745c'
