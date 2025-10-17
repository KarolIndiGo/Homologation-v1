-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewInventarioAjuste
-- Extracted by Fabric SQL Extractor SPN v3.9.0





/*******************************************************************************************************************
Nombre: ViewInventarioAjuste
Tipo:Vista
Observacion:Ajuste de inventario
Profesional: Nilsson Miguel Galindo Lopez
Fecha:29-06-2022
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Vercion 1
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:28-05-2024
Ovservaciones: ahora en la union con la tabla Inventory.AdjustmentConcept, es un left join
--------------------------------------
Vercion 2
Persona que modifico:
Fecha:
***********************************************************************************************************************************/

CREATE VIEW [Report].[ViewInventarioAjuste] AS

SELECT        
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
 CASE A.OperatingUnitId WHEN 1 THEN 'Bogota' END AS Sede, 
 A.DocumentDate AS Fecha, 
 A.Code AS Documento, 
 CASE A.AdjustmentType WHEN 1 THEN 'Entrada' 
					  WHEN 2 THEN 'Salida' END AS Tipo, 
 B.Code AS CodAlm, 
 B.Name AS Almacen, 
 C.Code AS [Codigo de Concepto], 
 C.Name AS Concepto,
 P.Code AS [Codidogo de Producto], 
 P.Name AS Producto, 
 DA.Quantity AS Cantidad, 
 DA.UnitValue AS [Valor Unitario], 
 DA.Quantity * DA.UnitValue AS [Valor Total], 
 P.ProductCost AS [Costo Promedio], 
 A.Description AS Detalle, 
 U.UserCode+'-'+U1.Fullname AS [Usuario Creacion Ajuste],
 CAST(A.DocumentDate  AS date) AS 'FECHA BUSQUEDA',
 YEAR(A.DocumentDate) AS 'AÑO BUSQUEDA',
 MONTH(A.DocumentDate) AS 'MES BUSQUEDA',
 CONCAT(FORMAT(MONTH(A.DocumentDate), '00') ,' - ', 
	    CASE MONTH(A.DocumentDate) 
	     WHEN 1 THEN 'ENERO'
   	     WHEN 2 THEN 'FEBRERO'
	     WHEN 3 THEN 'MARZO'
	     WHEN 4 THEN 'ABRIL'
	     WHEN 5 THEN 'MAYO'
	     WHEN 6 THEN 'JUNIO'
	     WHEN 7 THEN 'JULIO'
	     WHEN 8 THEN 'AGOSTO'
	     WHEN 9 THEN 'SEPTIEMBRE'
	     WHEN 10 THEN 'OCTUBRE'
	     WHEN 11 THEN 'NOVIEMBRE'
	     WHEN 12 THEN 'DICIEMBRE' END) 'MES NOMBRE BUSQUEDA',
 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM            
Inventory.InventoryAdjustment AS A 
INNER JOIN Inventory.InventoryAdjustmentDetail AS DA ON DA.InventoryAdjustmentId = A.Id AND A.Status = 2 
INNER JOIN Inventory.Warehouse AS B ON A.WarehouseId = B.Id 
LEFT JOIN Inventory.AdjustmentConcept AS C ON ISNULL(A.AdjustmentConceptId,DA.AdjustmentConceptId) = C.Id 
LEFT JOIN Inventory.InventoryProduct AS P ON DA.ProductId = P.Id 
LEFT JOIN Security.[User] AS U ON A.CreationUser = U.UserCode 
LEFT JOIN Security.Person AS U1 ON U.IdPerson = U1.Id

