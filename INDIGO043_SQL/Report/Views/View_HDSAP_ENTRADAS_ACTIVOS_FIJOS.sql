-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_ENTRADAS_ACTIVOS_FIJOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0



-- =============================================
-- Author:      Miguel Angle Ruiz Vega
-- Create date: 2025-02-03 10:51:38
-- Database:    INDIGO043
-- Description: Reporte ACTIVOS FIJOS
-- =============================================
				


CREATE VIEW [Report].[View_HDSAP_ENTRADAS_ACTIVOS_FIJOS]
AS

SELECT 
		A.Code AS 'CODIGO COMPROBANTE DE ENTRADA',
		CONCAT (T.Nit, '-', C.Name) as 'Provedor',
		A.Description AS 'DESCRIPCION DEL COMPROBANTE DE ENTRADA',
		CASE A.STATUS
		WHEN 1 THEN 'REGISTRADO'
		WHEN 2 THEN 'CONFIRMADO'
		WHEN 3 THEN 'ANULADO' END ESTADO,
		E.Plate AS 'PLACA',
		D.Description AS 'DESCRIPCION DE ARTICULOS',
		B.Quantity AS 'CANTIDAD ARTICULOS',
		B.UnitValue AS 'valor Unitario del producto',
		B.SubTotalValue AS 'SUBTOTAL ARTICULOS',
		B.IvaPercentage AS 'IVA %',
		B.TotalValue AS 'VALOR TOTAL DE ARTICULOS'
FROM FixedAsset.FixedAssetEntry A
	JOIN FixedAsset.FixedAssetEntryItem B			ON B.FixedAssetEntryId = A.Id
	JOIN FixedAsset.FixedAssetItem D				ON B.ItemId = D.Id
	JOIN Common.Supplier C 							ON C.Id = A.SupplierId
	JOIN Common.ThirdParty T 						ON T.Id = C.IdThirdParty
	JOIN FixedAsset.FixedAssetEntryItemDetail E		ON E.FixedAssetEntryItemId = B.Id
  

