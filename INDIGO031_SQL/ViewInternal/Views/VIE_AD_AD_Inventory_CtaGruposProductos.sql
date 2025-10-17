-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_AD_Inventory_CtaGruposProductos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_AD_Inventory_CtaGruposProductos] as


SELECT g.code as CodGrupo, g.name as Grupo, un.code as CodUF, un.name as UnidadFuncional, m.number as NumeroCtaCosto, m.name as CuentaCosto, m1.number as NumeroCtaVenta, m1.name as CuentaVenta
FROM Inventory.ProductGroup as g 
inner join Inventory.ProductGroupFunctionalUnit as u on u.ProductGroupid=g.id
inner join GenerallEdger.MainAccounts as m on m.id=u.costaccountid
inner join GenerallEdger.MainAccounts as m1 on m1.id=u.salesaccountid
inner join  Payroll.FunctionalUnit as un on un.id=u.functionalunitid
