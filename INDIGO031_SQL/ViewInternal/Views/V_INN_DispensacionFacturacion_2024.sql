-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_INN_DispensacionFacturacion_2024
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[V_INN_DispensacionFacturacion_2024] AS

SELECT   UO.UnitName AS Sede, D.Code AS Documento, 'Dispensacion' AS [Tipo documento], D.DocumentDate AS Fecha, CASE WHEN (MONTH(D .DocumentDate)) = '1' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Ene24' WHEN (MONTH(D .DocumentDate)) = '2' AND (YEAR(D .DocumentDate)) 
           = '2024' THEN 'Feb24' WHEN (MONTH(D .DocumentDate)) = '3' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Mar24' WHEN (MONTH(D .DocumentDate)) = '4' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Abr24' WHEN (MONTH(D .DocumentDate)) = '5' AND (YEAR(D .DocumentDate)) 
           = '2024' THEN 'May24' WHEN (MONTH(D .DocumentDate)) = '6' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Jun24' WHEN (MONTH(D .DocumentDate)) = '7' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Jul24' WHEN (MONTH(D .DocumentDate)) = '8' AND (YEAR(D .DocumentDate)) 
           = '2024' THEN 'Ago24' WHEN (MONTH(D .DocumentDate)) = '9' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Sep24' WHEN (MONTH(D .DocumentDate)) = '10' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Oct24' WHEN (MONTH(D .DocumentDate)) = '11' THEN 'Nov24' WHEN (MONTH(D .DocumentDate)) = '12' AND 
           (YEAR(D .DocumentDate)) = '2024' THEN 'Dic24' END AS Mes, P.IPCODPACI AS Identificacion, P.IPNOMCOMP AS Paciente, pr.Code AS Cod_Producto, pr.Name AS Producto, pr.CodeAlternative AS [Código alterno], pr.CodeAlternativeTwo AS [Código alterno 2], sg.Code + ' - ' + sg.Name AS [Código Subgrupo], 
           catc.Code AS [Código ATC], pr.CodeCUM AS [Código CUM], a.Code AS CodAlmacen, a.Name AS AlmacenDespacho, CASE WHEN pr.POSProduct = '1' THEN 'POS' WHEN pr.POSProduct = '0' THEN 'No_POS' END AS TipoProducto, DI.Quantity AS CantidadSolicitada, DI.ReturnedQuantity AS CantidadDevuelta, 
           DI.Quantity - DI.ReturnedQuantity AS Cantidad, /*dev.Code AS Devolucion,*/ un.Name AS Unidad_Destino, pr.Presentation AS Presentacion, /*I.CODDIAING AS CIE10, DX.NOMDIAGNO AS Diagnostico, 
		   DI.OrderedHealthProfessionalCode AS CodProfesional, PF.NOMMEDICO AS [Profesional Ordena], ES.DESESPECI AS Especialidad,*/
		   CC.NOMCENATE AS CentroAtencion, di.AverageCost as CostoPromedio, pr.FinalProductCost AS UltimoCosto, pr. SellingPrice AS ValorVenta,
		   lote.BatchCode AS Lote, lote.ExpirationDate AS FechaVencimiento 
FROM   Inventory.PharmaceuticalDispensing AS D WITH (nolock) INNER JOIN
           Inventory.PharmaceuticalDispensingDetail AS DI WITH (nolock) ON DI.PharmaceuticalDispensingId = D.Id  AND D.Status = '2' INNER JOIN
           dbo.ADINGRESO AS I WITH (nolock) ON I.NUMINGRES = D.AdmissionNumber INNER JOIN
           dbo.INPACIENT AS P WITH (nolock) ON P.IPCODPACI = I.IPCODPACI LEFT OUTER JOIN
           dbo.INDIAGNOS AS DX WITH (nolock) ON DX.CODDIAGNO = I.CODDIAING left JOIN
           dbo.INPROFSAL AS PF WITH (NOLOCK) ON PF.CODPROSAL = DI.OrderedHealthProfessionalCode left JOIN
           dbo.INESPECIA AS ES WITH (nolock) ON ES.CODESPECI = DI.OrderedProfessionalSpecialty left JOIN
           Inventory.InventoryProduct AS pr WITH (nolock) ON pr.Id = DI.ProductId left JOIN
           Inventory.ProductSubGroup AS sg WITH (nolock) ON sg.Id = pr.ProductSubGroupId left JOIN
           Payroll.FunctionalUnit AS un WITH (nolock) ON un.Id = DI.FunctionalUnitId left JOIN
           Inventory.Warehouse AS a WITH (nolock) ON a.Id = DI.WarehouseId left JOIN
           Billing.ServiceOrder AS O WITH (nolock) ON O.EntityCode = D.Code left JOIN
           Common.OperatingUnit AS UO WITH (nolock) ON UO.Id = D.OperatingUnitId LEFT OUTER JOIN
           Inventory.ATC AS catc WITH (nolock) ON catc.Id = pr.ATCId left JOIN
           Inventory.PharmaceuticalDispensingDetailBatchSerial AS bs WITH (nolock) ON bs.PharmaceuticalDispensingDetailId = DI.Id LEFT OUTER JOIN
           Inventory.PharmaceuticalDispensingDevolutionDetail AS devd WITH (nolock) ON devd.PharmaceuticalDispensingDetailBatchSerialId = bs.Id LEFT OUTER JOIN
           Inventory.PharmaceuticalDispensingDevolution AS dev WITH (nolock) ON dev.Id = devd.PharmaceuticalDispensingDevolutionId LEFT OUTER JOIN
		   dbo.ADCENATEN AS CC ON CC.CODCENATE=I.CODCENATE LEFT OUTER JOIN
		   Inventory.PhysicalInventory as ph WITH (NOLOCK) ON ph.id = bs.PhysicalInventoryId LEFT OUTER JOIN
		   Inventory.BatchSerial as lote WITH (NOLOCK) ON lote.Id = ph.BatchSerialId

WHERE (D.DocumentDate BETWEEN '01/01/2024 00:00:00' AND '31/12/2024 23:59:59') AND (D.Status = '2') AND (DI.Quantity - DI.ReturnedQuantity <> '0') 
