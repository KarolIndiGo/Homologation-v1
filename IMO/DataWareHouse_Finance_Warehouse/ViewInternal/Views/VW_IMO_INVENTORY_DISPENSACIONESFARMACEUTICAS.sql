-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_INVENTORY_DISPENSACIONESFARMACEUTICAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_Inventory_DispensacionesFarmaceuticas
AS

SELECT UO.UnitName AS Sede, D.Code AS Documento, 'Dispensacion' AS [Tipo documento], D.DocumentDate AS Fecha, CASE WHEN (MONTH(D .DocumentDate)) = '1' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Ene24' WHEN (MONTH(D .DocumentDate)) = '2' AND (YEAR(D .DocumentDate)) 
           = '2024' THEN 'Feb24' WHEN (MONTH(D .DocumentDate)) = '3' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Mar24' WHEN (MONTH(D .DocumentDate)) = '4' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Abr24' WHEN (MONTH(D .DocumentDate)) = '5' AND (YEAR(D .DocumentDate)) 
           = '2024' THEN 'May24' WHEN (MONTH(D .DocumentDate)) = '6' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Jun24' WHEN (MONTH(D .DocumentDate)) = '7' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Jul24' WHEN (MONTH(D .DocumentDate)) = '8' AND (YEAR(D .DocumentDate)) 
           = '2024' THEN 'Ago24' WHEN (MONTH(D .DocumentDate)) = '9' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Sep24' WHEN (MONTH(D .DocumentDate)) = '10' AND (YEAR(D .DocumentDate)) = '2024' THEN 'Oct24' WHEN (MONTH(D .DocumentDate)) = '11' THEN 'Nov24' WHEN (MONTH(D .DocumentDate)) = '12' AND 
           (YEAR(D .DocumentDate)) = '2024' THEN 'Dic24' 
		   WHEN (MONTH(D .DocumentDate)) = '1' AND (YEAR(D .DocumentDate)) = '2025' THEN 'Ene25' WHEN (MONTH(D .DocumentDate)) = '2' AND (YEAR(D .DocumentDate)) 
           = '2025' THEN 'Feb25' WHEN (MONTH(D .DocumentDate)) = '3' AND (YEAR(D .DocumentDate)) = '2025' THEN 'Mar25' WHEN (MONTH(D .DocumentDate)) = '4' AND (YEAR(D .DocumentDate)) = '2025' THEN 'Abr25' WHEN (MONTH(D .DocumentDate)) = '5' AND (YEAR(D .DocumentDate)) 
           = '2025' THEN 'May25' WHEN (MONTH(D .DocumentDate)) = '6' AND (YEAR(D .DocumentDate)) = '2025' THEN 'Jun25' WHEN (MONTH(D .DocumentDate)) = '7' AND (YEAR(D .DocumentDate)) = '2025' THEN 'Jul25' WHEN (MONTH(D .DocumentDate)) = '8' AND (YEAR(D .DocumentDate)) 
           = '2025' THEN 'Ago25' WHEN (MONTH(D .DocumentDate)) = '9' AND (YEAR(D .DocumentDate)) = '2025' THEN 'Sep25' WHEN (MONTH(D .DocumentDate)) = '10' AND (YEAR(D .DocumentDate)) = '2025' THEN 'Oct25' WHEN (MONTH(D .DocumentDate)) = '11' THEN 'Nov25' WHEN (MONTH(D .DocumentDate)) = '12' AND 
           (YEAR(D .DocumentDate)) = '2025' THEN 'Dic25'
		   END AS Mes, P.IPCODPACI AS Identificacion, P.IPNOMCOMP AS Paciente, pr.Code AS Cod_Producto, pr.Name AS Producto, pr.CodeAlternative AS [Codigo alterno], pr.CodeAlternativeTwo AS [Codigo alterno 2], sg.Code + ' - ' + sg.Name AS [Codigo Subgrupo], 
           catc.Code AS [Codigo ATC], pr.CodeCUM AS [Codigo CUM], a.Code AS CodAlmacen, a.Name AS AlmacenDespacho, CASE WHEN pr.POSProduct = '1' THEN 'POS' WHEN pr.POSProduct = '0' THEN 'No_POS' END AS TipoProducto, DI.Quantity AS CantidadSolicitada, DI.ReturnedQuantity AS CantidadDevuelta, 
           DI.Quantity - DI.ReturnedQuantity AS Cantidad, dev.Code AS Devolucion, un.Name AS Unidad_Destino, pr.Presentation AS Presentacion, I.CODDIAING AS CIE10, DX.NOMDIAGNO AS Diagnostico, 
		   DI.OrderedHealthProfessionalCode AS CodProfesional, PF.NOMMEDICO AS [Profesional Ordena], ES.DESESPECI AS Especialidad,
		   CC.NOMCENATE AS CentroAtencion, DI.AverageCost as CostoPromedio, pr.FinalProductCost AS UltimoCosto, pr. SellingPrice AS ValorVenta,
		   lote.BatchCode AS Lote, lote.ExpirationDate AS FechaVencimiento --Se agrega campos por solicitud en caso 184064
		   , DI.SalePrice as PrecioVenta, kd.PreviousCost as CostoAnterior, kd.PreviousAverageCost as CostoPromedioAnterior, kd.Value as Valor, -- Caso 261565
		   RTRIM(tp.Nit) as Nit, ea.Name AS Entidad 

FROM   [INDIGO035].[Inventory].[PharmaceuticalDispensing] AS D INNER JOIN
           [INDIGO035].[Inventory].[PharmaceuticalDispensingDetail] AS DI ON DI.PharmaceuticalDispensingId = D.Id  AND D.Status = '2' INNER JOIN
           [INDIGO035].[dbo].[ADINGRESO] AS I ON I.NUMINGRES = D.AdmissionNumber INNER JOIN
           [INDIGO035].[dbo].[INPACIENT] AS P ON P.IPCODPACI = I.IPCODPACI LEFT OUTER JOIN
           [INDIGO035].[dbo].[INDIAGNOS] AS DX ON DX.CODDIAGNO = I.CODDIAING INNER JOIN
           [INDIGO035].[dbo].[INPROFSAL] AS PF ON PF.CODPROSAL = DI.OrderedHealthProfessionalCode INNER JOIN
           [INDIGO035].[dbo].[INESPECIA] AS ES ON ES.CODESPECI = DI.OrderedProfessionalSpecialty INNER JOIN
           [INDIGO035].[Inventory].[InventoryProduct] AS pr ON pr.Id = DI.ProductId INNER JOIN
           [INDIGO035].[Inventory].[ProductSubGroup] AS sg ON sg.Id = pr.ProductSubGroupId INNER JOIN
           [INDIGO035].[Payroll].[FunctionalUnit] AS un ON un.Id = DI.FunctionalUnitId INNER JOIN
           [INDIGO035].[Inventory].[Warehouse] AS a ON a.Id = DI.WarehouseId INNER JOIN
           [INDIGO035].[Billing].[ServiceOrder] AS O ON O.EntityCode = D.Code INNER JOIN
           [INDIGO035].[Common].[OperatingUnit] AS UO ON UO.Id = D.OperatingUnitId LEFT OUTER JOIN
           [INDIGO035].[Inventory].[ATC] AS catc ON catc.Id = pr.ATCId INNER JOIN
           [INDIGO035].[Inventory].[PharmaceuticalDispensingDetailBatchSerial] AS bs ON bs.PharmaceuticalDispensingDetailId = DI.Id LEFT OUTER JOIN
           [INDIGO035].[Inventory].[PharmaceuticalDispensingDevolutionDetail] AS devd ON devd.PharmaceuticalDispensingDetailBatchSerialId = bs.Id LEFT OUTER JOIN
           [INDIGO035].[Inventory].[PharmaceuticalDispensingDevolution] AS dev ON dev.Id = devd.PharmaceuticalDispensingDevolutionId LEFT OUTER JOIN
		   [INDIGO035].[dbo].[ADCENATEN] AS CC ON CC.CODCENATE=I.CODCENATE LEFT OUTER JOIN
		   [INDIGO035].[Inventory].[PhysicalInventory] as ph ON ph.Id = bs.PhysicalInventoryId LEFT OUTER JOIN
		   [INDIGO035].[Inventory].[BatchSerial] as lote ON lote.Id = ph.BatchSerialId LEFT OUTER JOIN
		   [INDIGO035].[Inventory].[Kardex] as kd on kd.EntityId=D.Id and kd.ProductId=DI.ProductId left join
		   [INDIGO035].[Contract].[HealthAdministrator] AS ea ON ea.Id = I.GENCONENTITY left join
		   [INDIGO035].[Common].[ThirdParty] as tp on tp.Id=ea.ThirdPartyId
WHERE (D.DocumentDate >= '01/01/2024 00:00:00') AND (D.Status = '2') AND (DI.Quantity - DI.ReturnedQuantity <> '0')  --and D.Code='00001581'--AND (a.Code <> '220') --AND (D.DocumentDate <= '31/03/2024 23:59:59')
--and d.code='00008278'