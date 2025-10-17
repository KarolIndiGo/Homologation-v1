-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN__RemisionesSinCruzar
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view [ViewInternal].[FQ45_V_INN__RemisionesSinCruzar] as

SELECT CASE WHEN AL.CostCenterId IN ('21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '67', '68', '70', '75', '83', '84', '85', '86', '87', '88', '89', '114', '115', '116', '117', '118', '119', '120', '122', '123') THEN 'Neiva' WHEN AL.CostCenterId IN ('45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', 
           '59', '60', '61', '62', '63', '64', '65', '69', '71', '74', '98', '99', '100', '101', '102', '103', '104', '107', '108', '109', '110', '121') THEN 'Tunja' WHEN AL.CostCenterId IN ('1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '72', '73', '76', '91', '92', '93', '94', '95', '96', '97', '111', '112', '113') THEN 'Florencia' WHEN AL.CostCenterId IN ('44', 
           '105', '106') THEN 'Pitalito' ELSE 'NA' END AS Sede, cr.Code AS [Còd Remisión], cr.RemissionDate AS [Fecha Remisión], PR.Code AS [Còdigo Proveedor], PR.Name AS Proveedor, AL.Code AS [Còdigo Almacèn], AL.Name AS Almacèn, cr.RemissionNumber AS [Nùmero Remisiòn], cr.Description AS Descripciòn, cr.Value AS [Vr Remisiòn], 
           cr.IvaValue AS Iva, cr.TotalValue AS [Vr Total], CASE cr.Status WHEN '1' THEN 'registrada' WHEN '2' THEN 'confirmada' WHEN '3' THEN 'anulada' END AS Estado_Remisiòn, CASE cr.ProductStatus WHEN '1' THEN 'Sin_Movmientos' WHEN '2' THEN 'Parcial' WHEN '3' THEN 'Total' END AS estado_productos, pd.Code AS [Còd Producto], 
           pd.Name AS Producto, DR.Quantity AS Cantidad, DR.TotalValue AS Total, pd.ProductCost AS [Costo Promedio], Pen.OutstandingQuantity AS Pendiente_Cruzar, p.Fullname AS Usuario
FROM   Inventory.RemissionEntrance AS cr  INNER JOIN
           Common.OperatingUnit AS uo  ON uo.Id = cr.OperatingUnitId INNER JOIN
           Common.Supplier AS PR  ON PR.Id = cr.SupplierId INNER JOIN
           Inventory.Warehouse AS AL  ON AL.Id = cr.WarehouseId INNER JOIN
           Inventory.RemissionEntranceDetail AS DR  ON DR.RemissionEntranceId = cr.Id INNER JOIN
           Inventory.InventoryProduct AS pd  ON pd.Id = DR.ProductId INNER JOIN
           Security.[User] AS U  ON U.UserCode = cr.CreationUser INNER JOIN
           Security.Person AS p  ON p.Id = U.IdPerson LEFT OUTER JOIN
           Inventory.RemissionEntranceDetailBatchSerial AS Pen ON Pen.RemissionEntranceDetailId = DR.Id
WHERE (Pen.OutstandingQuantity > '0') AND (cr.Status <> '3')
