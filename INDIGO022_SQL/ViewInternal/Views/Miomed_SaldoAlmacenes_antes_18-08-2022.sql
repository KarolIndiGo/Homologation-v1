-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Miomed_SaldoAlmacenes antes 18-08-2022
-- Extracted by Fabric SQL Extractor SPN v3.9.1



create VIEW [ViewInternal].[Miomed_SaldoAlmacenes antes 18-08-2022]
AS
SELECT * FROM
		(
		SELECT PR.Id AS IDPr,
		--al.id as IdAlmacen,
		CASE  al.id 
			WHEN '1' THEN 'BOGOTA RED HUMANA'
			WHEN '2' THEN 'BOGOTA RED HUMANA'
			WHEN '3' THEN 'FACATATIVA'
			WHEN '4' THEN 'FACATATIVA'
			WHEN '5' THEN 'TUNJA - MEDILASER'
			WHEN '6' THEN 'DUITAMA - JERSALUD'
			WHEN '7' THEN 'SOGAMOSO - JERSALUD'
			WHEN '8' THEN 'TUNJA - JERSALUD'
			WHEN '9' THEN 'VILLAVICENCIO - JERSALUD'
			WHEN '10' THEN 'ACACIAS - JERSALUD'
			WHEN '11' THEN 'PUERTO LOPEZ - JERSALUD'
			WHEN '12' THEN 'GRANADA - JERSALUD'
			WHEN '13' THEN 'NEIVA - MEDILASER LA TOMA'
			WHEN '14' THEN 'CHIQUINQUIRA - JERSALUD'
			WHEN '15' THEN 'NEIVA - SEDE ABNER LOZANO'
			WHEN '16' THEN 'NEIVA - MEDILASER PRINCIPAL'
			WHEN '17' THEN 'GARAGOA - JERSALUD'
			WHEN '18' THEN 'GUATEQUE - JERSALUD'
			WHEN '19' THEN 'MONIQUIRA - JERSALUD'
			WHEN '20' THEN 'SOATA - JERSALUD'
			WHEN '21' THEN 'FLORENCIA - MEDILASER'
			--WHEN '1' THEN 'CASTELLANA ALMACEN PRINCIPAL'
			--WHEN '2' THEN 'OPERACION CASTELLANA'
			--WHEN '3' THEN 'OPERACION FACATATIVA'
			--WHEN '4' THEN 'FACATIVA ALMACEN'
			--WHEN '5' THEN 'Almacen Tunja'
			--WHEN '6' THEN 'Almacen Duitama '
			--WHEN '7' THEN 'Almacen Sogamoso'
			--WHEN '8' THEN 'TUNJA - JERSALUD'
			--WHEN '9' THEN 'VILLAVICENCIO - JERSALUD'
			--WHEN '10' THEN 'ACACIAS - JERSALUD'
			--WHEN '11' THEN 'PUERTO LOPEZ - JERSALUD'
			--WHEN '12' THEN 'GRANADA - JERSALUD'
			--WHEN '13' THEN 'NEIVA MEDILASER LA TOMA'
			--WHEN '14' THEN 'CHIQUINQUIRA'
			--WHEN '15' THEN 'SEDE ABNER LOZANO NEIVA'
			--WHEN '16' THEN 'NEIVA - MEDILASER PRINCIPAL'
			--WHEN '17' THEN 'GARAGOA - JERSALUD'
			--WHEN '18' THEN 'GUATEQUE - JERSALUD'
			--WHEN '19' THEN 'MONIQUIRA - JERSALUD'
			--WHEN '20' THEN 'SOATA - JERSALUD'
			--WHEN '21' THEN 'FLORENCIA MEDILASER'
		END AS Sede,
		pr.Code AS Codigo, pr.Name AS Producto, TP.Name AS [TipoProducto], Med.Code AS [Cod Med], 
		Med.Name AS Medicamento, 
		ins.Code AS Cod_Insumo, ins.SupplieName AS Insumo, 
		pr.Abbreviation AS Abreviatura,
		ATC.Code AS ATC, ATC.Name AS NombreATC, pr.CodeCUM AS CUM, 
        pr.CodeAlternativeTwo AS [CodigoAlterno2], sg.Name AS SubGrupo, ue.Abbreviation AS Unidad, 
		gf.Name AS [GrupoFacturacion], CASE pr.ProductControl WHEN '0' THEN 'No' WHEN '1' THEN 'Si' END AS [ProdControl], 
        pr.ProductCost AS CostoPromedio, pr.FinalProductCost AS Ultimocosto, 
		CASE pr.ProductWithPriceControl WHEN 0 THEN '' WHEN 1 THEN 'SI' END AS Regulado, 
        CASE pr.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS Estado, inf.Quantity AS Cantidad, al.Code AS CodAlmacen,
		CASE Med.HighCost WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END AS AltoCosto
FROM	Inventory.InventoryProduct AS pr LEFT OUTER JOIN
        Inventory.PhysicalInventory AS inf ON inf.ProductId = pr.Id LEFT OUTER JOIN
        Inventory.Warehouse AS al ON al.Id = inf.WarehouseId LEFT OUTER JOIN
        Inventory.ATC AS Med ON Med.Id = pr.ATCId LEFT OUTER JOIN
		inventory.InventorySupplie AS ins ON ins.Id=pr.SupplieId LEFT JOIN
        Inventory.ProductSubGroup AS sg ON sg.Id = pr.ProductSubGroupId LEFT OUTER JOIN
        Inventory.PackagingUnit AS ue ON ue.Id = pr.PackagingUnitId LEFT OUTER JOIN
        Billing.BillingGroup AS gf ON gf.Id = pr.BillingGroupId LEFT JOIN
        Inventory.ATCEntity ATC ON Med.ATCEntityId = ATC.Id JOIN
        Inventory.ProductType TP ON PR.ProductTypeId = TP.Id
WHERE al.code IN (
'001',
'002',
'003',
'004',
'005',
'006',
'007',
'008',
'009',
'11',
'010',
'012',
'013',
'014',
'015',
'016',
'17',
'18',
'19',
'20',
'21'
)
 and  INF.Quantity > 0 ) 
 source PIVOT (
	sum(Cantidad) FOR source.CodAlmacen IN (
		[001],
		[002],
		[003],
		[004],
		[005],
		[006],
		[007],
		[008],
		[009],
		[11],
		[010],
		[012],
		[013],
		[014],
		[015],
		[016],
		[17],
		[18],
		[19],
		[20],
		[21]
		)
	) 
	AS pivotable
 --where Codigo='20037237'
