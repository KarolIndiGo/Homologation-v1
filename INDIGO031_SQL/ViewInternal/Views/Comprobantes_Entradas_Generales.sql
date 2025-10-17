-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Comprobantes_Entradas_Generales
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [ViewInternal].[Comprobantes_Entradas_Generales]
AS
     --SELECT * FROM Inventory.EntranceVoucherDetail WHERE EntranceVoucherId=5165
     SELECT 
	 CE.Code AS Comprobante, 
            CE.DocumentDate AS Fecha_Recibido, 
            P.Code AS Codigo, 
            P.Name AS Articulo_Descripcion, 
            P.Presentation AS Forma_Farmaceutica, 
            M.Concentration AS Concentracion, 
            BS.BatchCode AS lote, 
            BS.ExpirationDate AS Fecha_Vencimiento, 
            UE.Name AS Presentacion_Comercial, 
            P.HealthRegistration AS Registro_Sanitario_Invima, 
            CEL.Quantity AS Cantidad_Recibido, 
            PRO.Name AS Proveedor, 
            F.Name AS Marca_Fabricante, 
            NR.Name AS Clasificacion_Riesto_Dispositivos_Medicos, 
            CE.InvoiceNumber AS Factura, 
            CED.SourceCode AS Orden_Compra,
            CASE CE.STATUS
                WHEN 1
                THEN 'registrado'
                WHEN 2
                THEN 'confirmado'
                WHEN 3
                THEN 'anulado'
            END AS ESTADO_COMPROBANTE, 
            ISNULL(M.Code, ins.Code) AS Cod_Medicamento_Insumo, 
            ISNULL(M.Name, ins.SupplieName) AS Medicamento_Insumo,
            CASE P.STATUS
                WHEN '1'
                THEN 'Activo'
                WHEN '0'
                THEN 'Inactivo'
            END AS Estado, 
            P.ProductCost AS CostoPromedioActual, 
            CED.UnitValue AS ValorUnitario, 
            CED.UnitValue*CEL.Quantity AS ValorTotal,
            CASE P.ProductControl
                WHEN '0'
                THEN 'No'
                WHEN '1'
                THEN 'Si'
            END AS [ProdControl],
            CASE ISNULL(M.HighCost, 0)
                WHEN 0
                THEN 'NO'
                WHEN 1
                THEN 'SI'
            END AS AltoCosto, 
            AL.Name AS Almacen, 
            G.Name AS Grupo, 
            TP.Name AS TipoProducto, 
            MONTH(CE.DocumentDate) AS Mes_Recibido, 
            YEAR(CE.DocumentDate) AS Año_Recibido, 
            PRO.Code AS CodigoProveedor,
            CASE P.POSPRODUCT
                WHEN 1
                THEN 'Si'
                WHEN 0
                THEN 'No'
            END AS ProductoPos,
			deV.code as Devolucion, DEV.TotalValue as ValorDevolucion,
		   case when dev.TotalValue is null then CED.TotalValue else CED.TotalValue-CED.TotalValue end as TotalFinal
     FROM Inventory.EntranceVoucher AS CE WITH (NOLOCK)
          INNER JOIN Inventory.EntranceVoucherDetail AS CED  WITH (NOLOCK) ON CED.EntranceVoucherId = CE.Id
          INNER JOIN Inventory.EntranceVoucherDetailBatchSerial CEL  WITH (NOLOCK) ON CEL.EntranceVoucherDetailId = CED.Id
       LEFT JOIN Inventory.BatchSerial AS BS  WITH (NOLOCK) ON BS.Id = CEL.BatchSerialId
          INNER JOIN Inventory.InventoryProduct AS P  WITH (NOLOCK) ON P.Id = CED.ProductId
          INNER JOIN Inventory.ProductType AS TP WITH (NOLOCK) ON TP.Code = P.ProductTypeId
          LEFT JOIN Inventory.ATC AS M WITH (NOLOCK) ON P.ATCId = M.Id
          LEFT JOIN Inventory.PharmacologicalGroup AS GF  WITH (NOLOCK) ON M.PharmacologicalGroupId = GF.Id
          LEFT JOIN inventory.InventorySupplie AS ins WITH (NOLOCK) ON ins.Id = P.SupplieId
          LEFT JOIN Inventory.ProductGroup AS G WITH (NOLOCK) ON G.Id = P.ProductGroupId
          INNER JOIN Inventory.Warehouse AS AL WITH (NOLOCK) ON CE.WarehouseId = AL.Id
          INNER JOIN Common.Supplier AS PRO WITH (NOLOCK) ON PRO.Id = CE.SupplierId
          INNER JOIN Inventory.PackagingUnit AS UE WITH (NOLOCK) ON UE.Id = P.PackagingUnitId
          INNER JOIN Inventory.Manufacturer AS F WITH (NOLOCK) ON F.Id = P.ManufacturerId
          INNER JOIN Inventory.InventoryRiskLevel AS NR WITH (NOLOCK) ON NR.Id = P.InventoryRiskLevelId
		  left outer JOIN	 (SELECT p.code AS CODPRO, p.name AS PRO, max(e.code) as Code, sum(ed.TotalValue) as TotalValue
								FROM Inventory.EntranceVoucher as e WITH (NOLOCK)
								inner join Inventory.EntranceVoucherDetail as ed WITH (NOLOCK) on ed.EntranceVoucherId=e.id 
								inner join Inventory.EntranceVoucherDetailBatchSerial as db WITH (NOLOCK) on db.EntranceVoucherDetailId=ed.id
								left outer join Inventory.EntranceVoucherDevolutionDetail as edd WITH (NOLOCK) on edd.EntranceVoucherDetailBatchSerialId=db.id
								left outer join Inventory.EntranceVoucherDevolution as de WITH (NOLOCK) on de.id=edd.EntranceVoucherDevolutionId
								left outer join Inventory.InventoryProduct as p WITH (NOLOCK) on p.id=ed.ProductId
								where  edd.Quantity>0
								group by p.code, p.name) AS DEV ON DEV.CODPRO=P.Code AND DEV.CODE=CE.CODE
     WHERE year(CE.DocumentDate) between '2023' and '2026'  --and  CE.InvoiceNumber='ZD-219092' and P.Code='20029235-10'
