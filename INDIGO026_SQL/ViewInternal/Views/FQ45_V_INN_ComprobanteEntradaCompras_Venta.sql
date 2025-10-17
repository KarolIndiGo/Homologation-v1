-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_ComprobanteEntradaCompras_Venta
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view [ViewInternal].[FQ45_V_INN_ComprobanteEntradaCompras_Venta] as

SELECT e.code as Comprobante, 
 cast(e.documentdate as datetime)  as [Fecha Comprobante], 
--e.documentdate as [Fecha Comprobante], 
E.Description as [Descripcion Comprobante], e.invoicenumber as [Factura Compra], 
sup.code as Nit, sup.name as Proveedor,
w.code + ' '+w.name as Almacen,p.code as CUM, p.name as Producto, 
atc.code as CodMedicamento, atc.name as Medicamento,
psg.code +'-'+psg.name as Subgrupo,
ed.quantity as CantidadComprada,
UnitValue as [Valor Compra], 
                            ed.IvaValue as IVA, ed.DiscountValue as Descuento,
							ed.totalvalue as ValorTotal,
                           cast(dips.documentdate as datetime)  as [Fecha Factura],
						    --CONVERT (DATE,dips.documentdate) as [Fecha Factura],
							dips.description as [Descripcion Factura], 
							i.invoicenumber as [Factura Venta], 
							P1.NAME AS [Producto Factura],
							atc1.code as CodMedicamentoFact, atc1.name as MedicamentoFact,
							psg1.code +'-'+psg1.name as SubgrupoFact,
							dipsd.Quantity as CantidadFactura,
							SalePrice as [Valor Venta], 
							dipsd.IvaValue as IVA2, dipsd.DiscountValue as Descuento2,  
							dipsd.totalvalue as ValorTotalVenta,
							tp.Nit 'Nit Cliente'
              , tp.Name 'Cliente', u.name as [Unidad Funcional]
FROM   Inventory.EntranceVoucher as E inner JOIN
                            Inventory.EntranceVoucherDetail AS ED  ON ED.EntranceVoucherid=E.Id inner join
                            Inventory.InventoryProduct as P  on P.id=ed.productid inner join
                            inventory.warehouse as w  on w.id=e.warehouseid left outer  join
                            Inventory.DocumentInvoiceProductSales dips  on dips.warehouseid=e.warehouseid and CONVERT (DATE,dips.documentdate)=e.documentdate left outer join
                            Inventory.DocumentInvoiceProductSalesDetail dipsd  ON dips.Id = dipsd.DocumentInvoiceProductSalesId and dipsd.productid=ed.productid inner  join
                            Billing.Invoice i  ON dips.InvoiceId = i.Id inner join
                            Common.ThirdParty tp  ON dips.ThirdPartyId = tp.Id left outer join
                            Payroll.BranchOffice bo  ON dips.BranchOfficeId = bo.Id left outer join
                            Common.City city  ON bo.CityId = city.Id left outer join
                            payroll.functionalunit as u  on u.id=dips.functionalunitid left outer JOIN
                            Inventory.InventoryProduct as P1  ON P1.ID=dipsd.productid left outer join
							Common.Supplier as sup  on sup.id=e.SupplierId left outer join 
							Inventory.ATC as atc on atc.id=p.atcid left outer join 
							Inventory.ATC as atc1 on atc1.id=p1.atcid left outer join 
							Inventory.ProductSubGroup as psg on psg.id=p.ProductSubgroupid
							left outer join 
							Inventory.ProductSubGroup as psg1 on psg1.id=p1.ProductSubgroupid
where e.documentdate>='01-01-2023' AND CONVERT (DATE,dips.documentdate)>='01-01-2023'  




