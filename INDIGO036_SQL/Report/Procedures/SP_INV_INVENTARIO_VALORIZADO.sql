-- Workspace: SQLServer
-- Item: INDIGO036 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: SP_INV_INVENTARIO_VALORIZADO
-- Extracted by Fabric SQL Extractor SPN v3.9.0


/*******************************************************************************************************************
Nombre: [Report].[SP_INV_INVENTARIO_VALORIZADO]
Tipo:Procedimiento almacenado
Observacion: Trae el inventario fisco, vaolorizado
Profesional:
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:Nilsson Miguel Galindo Lopez
Fecha:21-03-2023
Ovservaciones:Se tiene encuenta los movimientos en el kardex que afecta el inventario.
--------------------------------------
Version 3
Persona que modifico:
Fecha:
***********************************************************************************************************************************/


CREATE PROCEDURE [Report].[SP_INV_INVENTARIO_VALORIZADO]
(
    @year int,
    @month int,
	@day int
)
AS

--declare @year int = '2023'
--declare @month int = '03'
--declare @day int = '21'

declare @dateFilter date = DATEFROMPARTS(@year, @month, @day)
--declare @dateFilter date = DATEFROMPARTS(2022, 5, 1)

set @dateFilter = DATEADD(day, -1, DATEADD(month, 1, @dateFilter))
declare @Valorization as int =1 /*    1- Costo promedio
--                                    2- costo final
--                                    3 - precio venta*/

-- se declara variable tabla
declare @tmpPhysical table(WarehouseId int, ProductId int, BatchSerialId int, Quantity int, LastIdKardex int)

--se insetan datos en la variable tabla de la tabla del kardex
insert into @tmpPhysical
SELECT k.WarehouseId ,k.ProductId ,k.BatchSerialId ,sum(iif(K.MovementType = 1, k.Quantity, k.Quantity * -1)) , max(K.Id) as LastIdKardex
FROM Inventory.Kardex K 
WHERE cast(K.CreationDate as date) <= @dateFilter /*IN V2*/ and k.AffectInventory = 1 /*FN V2*/
GROUP BY k.WarehouseId ,k.ProductId ,k.BatchSerialId;


WITH
CTE_Kardex AS
(
	SELECT
	K.Id,
	K.AverageCost,
	SUM(IIF(K.AffectInventory = 1, K.Quantity, 0)) Quantity, 
	K.[Value] AS PrecioUnitario,
	SUM(IIF(K.Quantity = 0 AND K.EntityName = 'JournalVouchers', 1, K.Quantity) * K.Value) Value
	FROM Inventory.Kardex K
	WHERE (YEAR(K.DocumentDate) <= @YEAR )
	GROUP BY K.Id, K.AffectInventory, K.EntityName, K.[Value],K.AverageCost
)

SELECT  
w.Code 'CODIGO ALMACEN',
w.Name 'ALMACEN',
ip.Code 'CODIGO PRODUCTO',
ip.Name 'NOMBRE PRODUCTO',
isnull(a.Concentration,'') 'CONCENTRACION',
CASE @Valorization
WHEN 1 then 'Costo promedio'
when 2 then 'costo final'
ELSE 'precio venta'
end 'VALORIZACION',
iif(@Valorization =1, k.AverageCost ,iif(@Valorization=2,ip.FinalProductCost,ip.SellingPrice)) 'COSTO PROMEDIO',
isnull(cast(b.ExpirationDate as VARCHAR),'') 'FECHA EXPIRACION',
--_pi.Quantity 'CANTIDAD',
--CASE @Valorization when 1 then _pi.Quantity * k.AverageCost
--				   when 2 then _pi.Quantity * ip.FinalProductCost ELSE _pi.Quantity * ip.SellingPrice END 'VALOR TOTAL',
_pi.Quantity AS [CANTIDAD],
K.PrecioUnitario AS [COSTO UNIDAD],
K.[Value] AS [VALOR TOTAL],
PG.Code 'GRUPO_ID',
PG.Name 'GRUPO',
MA.Number AS [CUENTA CONTABLE]
from 
@tmpPhysical _pi
INNER JOIN Inventory.Warehouse w on _pi.WarehouseId = w.Id
INNER JOIN Inventory.InventoryProduct ip on _pi.ProductId =  ip.Id
INNER JOIN [Inventory].[ProductGroup] PG on ip.ProductGroupId =  PG.Id
INNER JOIN Payments.AccountPayableConcepts APC ON PG.InventoryAccountPayableConceptId=APC.Id
INNER JOIN GeneralLedger.MainAccounts MA ON APC.IdAccount=MA.Id INNER JOIN 
CTE_Kardex k on k.Id = _pi.LastIdKardex
left JOIN Inventory.ATC a on ip.ATCId =a.Id
left JOIN Inventory.BatchSerial b on _pi.BatchSerialId = b.Id 
where 
_pi.Quantity <> 0 --and ip.Code in ('1211030001')
ORDER BY W.Code


--select * from @tmpPhysical where ProductId='1712'
--select * from  Inventory.InventoryProduct where Code in ('1211030001')


