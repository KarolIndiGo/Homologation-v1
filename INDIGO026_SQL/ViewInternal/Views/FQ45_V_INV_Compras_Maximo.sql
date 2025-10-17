-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INV_Compras_Maximo
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view [ViewInternal].[FQ45_V_INV_Compras_Maximo] AS

SELECT        p.Code AS [Codigo Producto], p.Name AS [Nombre Producto], gp.Name AS [Grupo Nombre], sg.Code AS [Código Subgrupo], sg.Name AS [Nombre subgrupo], cce.Code AS [Comprobante de Entrada], pr.Code AS [Nit Proveedor], 
                         pr.Name AS [Nombre Proveedor], cce.InvoiceNumber AS Factura, cce.DocumentDate AS [Fecha Max], dce_1.UnitValue AS [Vr Maximo Unitario],
al.Code as CodigoAlmacen, al.Name as Almacen -- Caso 266033

FROM            (SELECT        ec.Id, ec.EntranceVoucherId, ec.ProductId, ec.Quantity, ec.EntranceSource, ec.SourceCode, ec.PurchaseOrderDetailId, ec.ContractDetailId, ec.RemissionEntranceDetailBatchSerialId, ec.UnitValue, ec.LastValue, 
                                                    ec.SubTotalValue, ec.IvaPercentage, ec.IvaValue, ec.DiscountPercentage, ec.DiscountValue, ec.TotalValue, ec.RTFPercentage, ec.RTFValue, ec.ConsignmentInventoryRemissionDetailBatchSerialId, min.idprod, 
                                                    min.Vmanu
                          FROM            Inventory.EntranceVoucherDetail AS ec INNER JOIN
                                                        (SELECT DISTINCT dce.ProductId AS idprod, MAX(dce.UnitValue) AS Vmanu
                                                          FROM            Inventory.EntranceVoucher AS cce INNER JOIN
                                                                                    Inventory.EntranceVoucherDetail AS dce ON dce.EntranceVoucherId = cce.Id AND cce.Status = '2' AND cce.InvoiceDate  >= '2024-04-01 00:00:00'
                                                          GROUP BY dce.ProductId) AS min ON min.idprod = ec.ProductId AND min.Vmanu = ec.UnitValue) AS dce_1 LEFT OUTER JOIN
                         Inventory.EntranceVoucher AS cce ON cce.Id = dce_1.EntranceVoucherId LEFT OUTER JOIN
                         Common.Supplier AS pr ON pr.Id = cce.SupplierId LEFT OUTER JOIN
                         Security.[User] AS u ON u.UserCode = cce.CreationUser LEFT OUTER JOIN
                         Security.Person AS per ON per.Id = u.IdPerson LEFT OUTER JOIN
                         Inventory.Warehouse AS al ON al.Id = cce.WarehouseId LEFT OUTER JOIN
                         Inventory.InventoryProduct AS p ON p.Id = dce_1.ProductId LEFT OUTER JOIN
                         Inventory.ATC AS ATC ON ATC.Id = p.ATCId LEFT OUTER JOIN
                         Inventory.PharmacologicalGroup AS GF ON GF.Id = ATC.PharmacologicalGroupId LEFT OUTER JOIN
                         Inventory.ProductGroup AS gp ON gp.Id = p.ProductGroupId LEFT OUTER JOIN
                         Inventory.ProductSubGroup AS sg ON sg.Id = p.ProductSubGroupId
WHERE        cce.InvoiceDate >= '2024-04-01 00:00:00' -- Caso 266033