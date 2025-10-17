-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_TRASLADO_CONSUMO
-- Extracted by Fabric SQL Extractor SPN v3.9.0







-- =============================================
-- Author:      Miguel Angle Ruiz Vega
-- Create date: 2025-01-31 10:51:38
-- Database:    INDIGO043
-- Description: Reporte Cuentas Medicas Trazabilidad
-- =============================================



CREATE VIEW [Report].[View_HDSAP_TRASLADO_CONSUMO]
AS
SELECT pro.code 'CODIGO PRODUCTO',
       pro.Name 'NOMBRE PRODUCTO',
	   td.Quantity 'CANTIDAD',
	   T.DocumentDate 'FECHA',
	   w.Name 'ALMACEN ORIGEN',
	   W.Code 'CODIGO ALMACEN',
	   F.Name 'UNIDAD FUNCIONAL',
	   F.CODE 'CODIGO UNIDAD FUNCIONAL'


from Inventory.TransferOrder T
join Inventory.TransferOrderDetail td on td.TransferOrderId = t.id
join inventory.InventoryProduct pro on pro.id = td.ProductId
JOIN INVENTORY.Warehouse w on w.id = t.SourceWarehouseId
JOIN PAYROLL.FunctionalUnit F ON F.ID = T.TargetFunctionalUnitId
where t.OrderType = 2



