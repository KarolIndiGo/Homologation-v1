-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_Inventory_DispensacionesFarmaceuticas
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IMO_Inventory_DispensacionesFarmaceuticas] as

SELECT DISTINCT	UO.UnitName AS Sede, D.Code AS Documento, 'Dispensacion' AS [Tipo documento], D.DocumentDate AS Fecha, CASE WHEN (MONTH(D .DocumentDate)) = '1' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Ene24' WHEN (MONTH(D .DocumentDate)) = '2' AND (YEAR(D .DocumentDate)) 
           = '2024' THEN 'Feb24' WHEN (MONTH(D .DocumentDate)) = '3' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Mar24' WHEN (MONTH(D .DocumentDate)) = '4' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Abr24' WHEN (MONTH(D .DocumentDate)) = '5' AND (YEAR(D .DocumentDate)) 
           = '2024' THEN 'May24' WHEN (MONTH(D .DocumentDate)) = '6' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Jun24' WHEN (MONTH(D .DocumentDate)) = '7' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Jul24' WHEN (MONTH(D .DocumentDate)) = '8' AND (YEAR(D .DocumentDate)) 
           = '2024' THEN 'Ago24' WHEN (MONTH(D .DocumentDate)) = '9' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Sep24' WHEN (MONTH(D .DocumentDate)) = '10' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Oct24' WHEN (MONTH(D .DocumentDate)) = '11' THEN 'Nov24' WHEN (MONTH(D .DocumentDate)) = '12' AND 
           (YEAR(D .DocumentDate)) = '2024' THEN 'Dic24' 
		   WHEN (MONTH(D .DocumentDate)) = '1' AND (YEAR(D .DocumentDate)) = '2025' THEN 'Ene25' WHEN (MONTH(D .DocumentDate)) = '2' AND (YEAR(D .DocumentDate)) 
           = '2025' THEN 'Feb25' WHEN (MONTH(D .DocumentDate)) = '3' AND (YEAR(D .DocumentDate)) = '2025' THEN 'Mar25' WHEN (MONTH(D .DocumentDate)) = '4' AND (YEAR(D .DocumentDate)) = '2025' THEN 'Abr25' WHEN (MONTH(D .DocumentDate)) = '5' AND (YEAR(D .DocumentDate)) 
           = '2025' THEN 'May25' WHEN (MONTH(D .DocumentDate)) = '6' AND (YEAR(D .DocumentDate)) = '2025' THEN 'Jun25' WHEN (MONTH(D .DocumentDate)) = '7' AND (YEAR(D .DocumentDate)) = '2025' THEN 'Jul25' WHEN (MONTH(D .DocumentDate)) = '8' AND (YEAR(D .DocumentDate)) 
           = '2025' THEN 'Ago25' WHEN (MONTH(D .DocumentDate)) = '9' AND (YEAR(D .DocumentDate)) = '2025' THEN 'Sep25' WHEN (MONTH(D .DocumentDate)) = '10' AND (YEAR(D .DocumentDate)) = '2025' THEN 'Oct25' WHEN (MONTH(D .DocumentDate)) = '11' THEN 'Nov25' WHEN (MONTH(D .DocumentDate)) = '12' AND 
           (YEAR(D .DocumentDate)) = '2025' THEN 'Dic25'
		   END AS Mes, P.IPCODPACI AS Identificacion, P.IPNOMCOMP AS Paciente, pr.Code AS Cod_Producto, pr.Name AS Producto, pr.CodeAlternative AS [Código alterno], pr.CodeAlternativeTwo AS [Código alterno 2], sg.Code + ' - ' + sg.Name AS [Código Subgrupo], 
           catc.Code AS [Código ATC], pr.CodeCUM AS [Código CUM], a.Code AS CodAlmacen, a.Name AS AlmacenDespacho, CASE WHEN pr.POSProduct = '1' THEN 'POS' WHEN pr.POSProduct = '0' THEN 'No_POS' END AS TipoProducto, 
		   kd.Quantity AS CantidadSolicitada, DI.ReturnedQuantity AS CantidadDevuelta,  --en CantidadSolicitada se cambio d.Quantity por kd.Quantity por los lotes
           kd.Quantity - DI.ReturnedQuantity AS Cantidad,  --en Cantidad se cambio d.Quantity por kd.Quantity por los lotes
		   dev.Code AS Devolucion, un.Name AS Unidad_Destino, pr.Presentation AS Presentacion, I.CODDIAING AS CIE10, DX.NOMDIAGNO AS Diagnostico, 
		   DI.OrderedHealthProfessionalCode AS CodProfesional, PF.NOMMEDICO AS [Profesional Ordena], ES.DESESPECI AS Especialidad,
		   CC.NOMCENATE AS CentroAtencion, di.AverageCost as CostoPromedio, pr.FinalProductCost AS UltimoCosto, pr. SellingPrice AS ValorVenta,
		   lote.BatchCode AS Lote, lote.ExpirationDate AS FechaVencimiento --Se agrega campos por solicitud en caso 184064
		   , di.SalePrice as PrecioVenta, kd.PreviousCost as CostoAnterior, kd.PreviousAverageCost as CostoPromedioAnterior, kd.Value as Valor, -- Caso 261565
		   RTRIM(tp.nit) as Nit, ea.NAME AS Entidad 

FROM   Inventory.PharmaceuticalDispensing AS D WITH (nolock) INNER JOIN
           Inventory.PharmaceuticalDispensingDetail AS DI WITH (nolock) ON DI.PharmaceuticalDispensingId = D.Id  AND D.Status = '2' INNER JOIN
           dbo.ADINGRESO AS I WITH (nolock) ON I.NUMINGRES = D.AdmissionNumber INNER JOIN
           dbo.INPACIENT AS P WITH (nolock) ON P.IPCODPACI = I.IPCODPACI LEFT OUTER JOIN
           dbo.INDIAGNOS AS DX WITH (nolock) ON DX.CODDIAGNO = I.CODDIAING INNER JOIN
           dbo.INPROFSAL AS PF WITH (NOLOCK) ON PF.CODPROSAL = DI.OrderedHealthProfessionalCode INNER JOIN
           dbo.INESPECIA AS ES WITH (nolock) ON ES.CODESPECI = DI.OrderedProfessionalSpecialty INNER JOIN
           Inventory.InventoryProduct AS pr WITH (nolock) ON pr.Id = DI.ProductId INNER JOIN
           Inventory.ProductSubGroup AS sg WITH (nolock) ON sg.Id = pr.ProductSubGroupId INNER JOIN
           Payroll.FunctionalUnit AS un WITH (nolock) ON un.Id = DI.FunctionalUnitId INNER JOIN
           Inventory.Warehouse AS a WITH (nolock) ON a.Id = DI.WarehouseId INNER JOIN
           Billing.ServiceOrder AS O WITH (nolock) ON O.EntityCode = D.Code INNER JOIN
           Common.OperatingUnit AS UO WITH (nolock) ON UO.Id = D.OperatingUnitId LEFT OUTER JOIN
           Inventory.ATC AS catc WITH (nolock) ON catc.Id = pr.ATCId INNER JOIN
           Inventory.PharmaceuticalDispensingDetailBatchSerial AS bs WITH (nolock) ON bs.PharmaceuticalDispensingDetailId = DI.Id LEFT OUTER JOIN
           Inventory.PharmaceuticalDispensingDevolutionDetail AS devd WITH (nolock) ON devd.PharmaceuticalDispensingDetailBatchSerialId = bs.Id LEFT OUTER JOIN
           Inventory.PharmaceuticalDispensingDevolution AS dev WITH (nolock) ON dev.Id = devd.PharmaceuticalDispensingDevolutionId LEFT OUTER JOIN
		   dbo.ADCENATEN AS CC ON CC.CODCENATE=I.CODCENATE LEFT OUTER JOIN
		   Inventory.PhysicalInventory as ph WITH (NOLOCK) ON ph.id = bs.PhysicalInventoryId LEFT OUTER JOIN
		   Inventory.BatchSerial as lote WITH (NOLOCK) ON lote.Id = ph.BatchSerialId LEFT OUTER JOIN
		   Inventory.Kardex as kd on kd.EntityId=d.id and kd.ProductId=di.ProductId left join
		   contract.healthadministrator AS ea WITH (NOLOCK) ON ea.id = i.genconentity left join
		   common.thirdparty as tp with (nolock) on tp.id=ea.thirdpartyid
WHERE (D.DocumentDate >= '01/01/2024 00:00:00') AND (D.Status = '2') AND (DI.Quantity - DI.ReturnedQuantity <> '0')  --and D.Code='00001581'--AND (a.Code <> '220') --AND (D.DocumentDate <= '31/03/2024 23:59:59')
--and d.code='NVA019330'

--select *
--FROM   Inventory.PharmaceuticalDispensing AS D WITH (nolock) INNER JOIN
--           Inventory.PharmaceuticalDispensingDetail AS DI WITH (nolock) ON DI.PharmaceuticalDispensingId = D.Id  AND D.Status = '2' INNER JOIN
--           Inventory.InventoryProduct AS pr WITH (nolock) ON pr.Id = DI.ProductId  LEFT OUTER JOIN
--		   Inventory.Kardex as kd on kd.EntityId=d.id and kd.ProductId=di.ProductId 
--		   where d.Code='NVA019330' 
--           AND  PR.Code ='20031989-1'
