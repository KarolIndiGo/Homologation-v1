-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_SEGUIMIENTO_RECONOCIMIENTO_MES_ANTERIOR
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE [Report].[IND_SP_V2_ERP_SEGUIMIENTO_RECONOCIMIENTO_MES_ANTERIOR]
AS

SELECT RRP.*,isnull(CUPS.CODE,Ip.code) 'Cups/CodigoOld',isnull(CUPS.Description,ip.name) 'DescripcionCups/ProductoOld' ,IIF(SOD.ID IS NULL,'SI','NO') 'Detalle_Eliminado',
SOD.InvoicedQuantity 'Cantidad_Hoy', SOD.TotalSalesPrice 'Precio_Unitario_hoy',isnull(SOD.GrandTotalSalesPrice,0) 'Valor_Total_Hoy' ,SOD.SettlementType 'Incluido',
SOD.IncludeServiceOrderDetailId 'Id_Detalle_Incluido',CUPSI.CODE,CUPSI.Description
FROM REPORT.RevenueRecognitionPhoto RRP
LEFT JOIN BILLING.ServiceOrderDetail AS SOD ON RRP.ServiceOrderDetailId=sod.Id
LEFT JOIN Contract.CUPSEntity as CUPS ON CUPS.ID=RRP.CUPSEntityId
LEFT JOIN Inventory.InventoryProduct as IP on ip.id=RRP.ProductId
LEFT JOIN BILLING.ServiceOrderDetail AS SODI ON SODI.ID=SOD.IncludeServiceOrderDetailId
LEFT JOIN Contract.CUPSEntity as CUPSI ON CUPSI.ID=SODI.CUPSEntityId