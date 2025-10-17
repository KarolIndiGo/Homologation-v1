-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Miomed_ConsumoPromedio antes 18-08-2022
-- Extracted by Fabric SQL Extractor SPN v3.9.1


create VIEW [ViewInternal].[Miomed_ConsumoPromedio antes 18-08-2022]
AS
SELECT Sede, Cod_Producto, Producto, Medicamento, CodSubgrupo, CodATC, ATC, CodigoCUM, TipoProducto, Ene_A, Feb_A, Mar_A, Abr_A, May_A, Jun_A, Jul_A, Ago_A, Sep_A, Oct_A, Nov_A, Dic_A, Ene_V, Feb_V, Mar_V, Abr_V, May_V, Jun_V, 
       Jul_V, Ago_V, Sep_V, Oct_V, Nov_V, Dic_V, 
	   CASE month(getdate()) 
		   WHEN '1' THEN ((ISNULL(Jul_A, 0) + ISNULL(Ago_A, 0) + ISNULL(Sep_A, 0) + ISNULL(Oct_A, 0) + ISNULL(Nov_A, 0) + ISNULL(Dic_A, 0))) / 6
		   WHEN '2' THEN ((ISNULL(Ago_A, 0) + ISNULL(Sep_A, 0) + ISNULL(Oct_A, 0) + ISNULL(Nov_A, 0) + ISNULL(Dic_A, 0) + ISNULL(Ene_V, 0))) / 6
		   WHEN '3' THEN ((ISNULL(Sep_A, 0) + ISNULL(Oct_A, 0) + ISNULL(Nov_A, 0) + ISNULL(Dic_A, 0) + ISNULL(Ene_V, 0) + ISNULL(Feb_V, 0))) / 6
		   WHEN '4' THEN ((ISNULL(Oct_A, 0) + ISNULL(Nov_A, 0) + ISNULL(Dic_A, 0) + ISNULL(Ene_V, 0) + ISNULL(Feb_V, 0) + ISNULL(Mar_V, 0))) / 6
		   WHEN '5' THEN ((ISNULL(Nov_A, 0) + ISNULL(Dic_A, 0) + ISNULL(Ene_V, 0) + ISNULL(Feb_V, 0) + ISNULL(Mar_V, 0) + ISNULL(Abr_V, 0))) / 6
		   WHEN '6' THEN ((ISNULL(Dic_A, 0) + ISNULL(Ene_V, 0) + ISNULL(Feb_V, 0) + ISNULL(Mar_V, 0) + ISNULL(Abr_V, 0) + ISNULL(May_V, 0))) / 6
		   WHEN '7' THEN ((ISNULL(Ene_V, 0) + ISNULL(Feb_V, 0) + ISNULL(Mar_V, 0) + ISNULL(Abr_V, 0) + ISNULL(May_V, 0) + ISNULL(Jun_V, 0))) / 6
		   WHEN '8' THEN ((ISNULL(Feb_V, 0) + ISNULL(Mar_V, 0) + ISNULL(Abr_V, 0) + ISNULL(May_V, 0) + ISNULL(Jun_V, 0) + ISNULL(Jul_V, 0))) / 6
		   WHEN '9' THEN ((ISNULL(Mar_V, 0) + ISNULL(Abr_V, 0) + ISNULL(May_V, 0) + ISNULL(Jun_V, 0) + ISNULL(Jul_V, 0) + ISNULL(Ago_V, 0))) / 6
		   WHEN '10' THEN ((ISNULL(Abr_V, 0) + ISNULL(May_V, 0) + ISNULL(Jun_V, 0) + ISNULL(Jul_V, 0) + ISNULL(Ago_V, 0) + ISNULL(Sep_V, 0))) / 6
		   WHEN '11' THEN ((ISNULL(May_V, 0) + ISNULL(Jun_V, 0) + ISNULL(Jul_V, 0) + ISNULL(Ago_V, 0) + ISNULL(Sep_V, 0) + ISNULL(Oct_V, 0))) / 6
		   WHEN '12' THEN ((ISNULL(Jun_V, 0) + ISNULL(Jul_V, 0) + ISNULL(Ago_V, 0) + ISNULL(Sep_V, 0) + ISNULL(Oct_V, 0) + ISNULL(Nov_V, 0))) / 6
	   END AS [Prom_Ulti_Semestre],
	   Estado, CostoPromedio
FROM   (SELECT DISTINCT UO.UnitName AS Sede, 
		CASE 
			WHEN (MONTH(D.DocumentDate)) = '1' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Ene_A' 
			WHEN (MONTH(D.DocumentDate)) = '2' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Feb_A' 
			WHEN (MONTH(D.DocumentDate)) = '3' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Mar_A' 
			WHEN (MONTH(D.DocumentDate)) = '4' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Abr_A' 
			WHEN (MONTH(D.DocumentDate)) = '5' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'May_A' 
			WHEN (MONTH(D.DocumentDate)) = '6' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Jun_A' 
			WHEN (MONTH(D.DocumentDate)) = '7' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Jul_A' 
			WHEN (MONTH(D.DocumentDate)) = '8' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Ago_A' 
			WHEN (MONTH(D.DocumentDate)) = '9' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Sep_A' 
			WHEN (MONTH(D.DocumentDate)) = '10' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Oct_A' 
			WHEN (MONTH(D.DocumentDate)) = '11' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Nov_A' 
			WHEN (MONTH(D.DocumentDate)) = '12' AND YEAR(D.DocumentDate) <> YEAR(getdate()) THEN 'Dic_A' 
			WHEN (MONTH(D.DocumentDate)) = '1' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Ene_V' 
			WHEN (MONTH(D.DocumentDate)) = '2' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Feb_V' 
			WHEN (MONTH(D.DocumentDate)) = '3' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Mar_V' 
			WHEN (MONTH(D.DocumentDate)) = '4' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Abr_V' 
			WHEN (MONTH(D.DocumentDate)) = '5' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'May_V' 
			WHEN (MONTH(D.DocumentDate)) = '6' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Jun_V' 
			WHEN (MONTH(D.DocumentDate)) = '7' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Jul_V' 
			WHEN (MONTH(D.DocumentDate)) = '8' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Ago_V' 
			WHEN (MONTH(D.DocumentDate)) = '9' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Sep_V' 
			WHEN (MONTH(D.DocumentDate)) = '10' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Oct_V' 
			WHEN (MONTH(D.DocumentDate)) = '11' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Nov_V' 
			WHEN (MONTH(D.DocumentDate)) = '12' AND YEAR(D.DocumentDate) = YEAR(getdate()) THEN 'Dic_V' 
		END AS Mes, 
       pr.Code AS Cod_Producto, pr.Name AS Producto, Med.Code + ' - ' + Med.Name AS [Medicamento], sg.Code + ' - ' + sg.Name AS [CodSubgrupo],
	   ATC.Code AS [CodATC], ATC.Name AS ATC, pr.CodeCUM AS [CodigoCUM], 
       CASE  pr.ProductTypeId 
	    WHEN '1' THEN 'Medicamento' 
	    WHEN '2' THEN 'DispositivoMedico' 
	    WHEN '3' THEN 'Elemento Consumo' 
	    WHEN '4' THEN 'Nutricion Especial' 
	    WHEN '5' THEN 'Equipo Biomedico' 
	    WHEN '6' THEN 'Insumo Laboratorio' 
	    WHEN '7' THEN 'Med VitalNO Disponible' 
	   END AS TipoProducto, 
	   sum(DI.Quantity - DI.ReturnedQuantity) AS Cantidad, 
       CASE pr.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS Estado, pr.ProductCost AS CostoPromedio
FROM   Inventory.PharmaceuticalDispensing AS D INNER JOIN
       Inventory.PharmaceuticalDispensingDetail AS DI ON DI.PharmaceuticalDispensingId = D .Id INNER JOIN
       .ADINGRESO AS I ON I.NUMINGRES = D .AdmissionNumber INNER JOIN
       .INPACIENT AS P ON P.IPCODPACI = I.IPCODPACI INNER JOIN
       Inventory.InventoryProduct AS pr ON pr.Id = DI.ProductId INNER JOIN
       Inventory.ProductSubGroup AS sg ON sg.Id = pr.ProductSubGroupId INNER JOIN
       Payroll.FunctionalUnit AS un ON un.Id = DI.FunctionalUnitId INNER JOIN
       Billing.ServiceOrder AS O ON O.EntityCode = D .Code INNER JOIN
       Common.OperatingUnit AS UO ON UO.Id = D .OperatingUnitId LEFT OUTER JOIN
       Inventory.ATC AS Med ON Med.Id = pr.ATCId LEFT OUTER JOIN
       Inventory.ATCEntity ATC ON Med.ATCEntityId = ATC.Id
WHERE  d.documentdate >= '01-01-2021'
--CONVERT(NVARCHAR(10), D.DocumentDate, 20) > CONVERT(VARCHAR(10), GETDATE() - 367, 20) 

AND D .STATUS = '2' AND DI.Quantity <> DI.ReturnedQuantity AND sg.code <> 'OSTEO001' 
		AND sg.code <> 'PROTE001'
GROUP BY UO.UnitName, (MONTH(D.DocumentDate)), YEAR(D.DocumentDate), pr.Code, pr.Name, Med.Code + ' - ' + Med.Name, sg.Code + ' - ' + sg.Name, ATC.Code, ATC.Name, pr.CodeCUM, pr.ProductTypeId, pr.Status, pr.ProductCost
UNION ALL
SELECT UO.UnitName AS Sede, CASE WHEN (MONTH(DO.DocumentDate)) = '1' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'Ene_A' WHEN (MONTH(DO.DocumentDate)) = '2' AND YEAR(DocumentDate) <> YEAR(getdate()) 
       THEN 'Feb_A' WHEN (MONTH(DO.DocumentDate)) = '3' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'Mar_A' WHEN (MONTH(DO.DocumentDate)) = '4' AND YEAR(DocumentDate) <> YEAR(getdate()) 
       THEN 'Abr_A' WHEN (MONTH(DO.DocumentDate)) = '5' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'May_A' WHEN (MONTH(DO.DocumentDate)) = '6' AND YEAR(DocumentDate) <> YEAR(getdate()) 
       THEN 'Jun_A' WHEN (MONTH(DO.DocumentDate)) = '7' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'Jul_A' WHEN (MONTH(DO.DocumentDate)) = '8' AND YEAR(DocumentDate) <> YEAR(getdate()) 
       THEN 'Ago_A' WHEN (MONTH(DO.DocumentDate)) = '9' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'Sep_A' WHEN (MONTH(DO.DocumentDate)) = '10' AND YEAR(DocumentDate) <> YEAR(getdate()) 
       THEN 'Oct_A' WHEN (MONTH(DO.DocumentDate)) = '11' AND YEAR(DocumentDate) <> YEAR(getdate()) THEN 'Nov_A' WHEN (MONTH(DO.DocumentDate)) = '12' AND YEAR(DocumentDate) <> YEAR(getdate()) 
       THEN 'Dic_A' WHEN (MONTH(DO.DocumentDate)) = '1' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'Ene_V' WHEN (MONTH(DO.DocumentDate)) = '2' AND YEAR(DocumentDate) = YEAR(getdate()) 
       THEN 'Feb_V' WHEN (MONTH(DO.DocumentDate)) = '3' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'Mar_V' WHEN (MONTH(DO.DocumentDate)) = '4' AND YEAR(DocumentDate) = YEAR(getdate()) 
       THEN 'Abr_V' WHEN (MONTH(DO.DocumentDate)) = '5' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'May_V' WHEN (MONTH(DO.DocumentDate)) = '6' AND YEAR(DocumentDate) = YEAR(getdate()) 
       THEN 'Jun_V' WHEN (MONTH(DO.DocumentDate)) = '7' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'Jul_V' WHEN (MONTH(DO.DocumentDate)) = '8' AND YEAR(DocumentDate) = YEAR(getdate()) 
       THEN 'Ago_V' WHEN (MONTH(DO.DocumentDate)) = '9' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'Sep_V' WHEN (MONTH(DO.DocumentDate)) = '10' AND YEAR(DocumentDate) = YEAR(getdate()) 
       THEN 'Oct_V' WHEN (MONTH(DO.DocumentDate)) = '11' AND YEAR(DocumentDate) = YEAR(getdate()) THEN 'Nov_V' WHEN (MONTH(DO.DocumentDate)) = '12' AND YEAR(DocumentDate) = YEAR(getdate()) 
       THEN 'Dic_V' END AS Mes, pr.Code AS Cod_Producto, pr.Name AS Producto, Med.Code + ' - ' + Med.Name AS Medicamento, sg.Code + ' - ' + sg.Name AS [Código Subgrupo], ATC.Code AS CodATC, ATC.Name AS ATC, 
       pr.CodeCUM AS [Código CUM], 
		CASE  pr.ProductTypeId WHEN '1' THEN 'Medicamento' 
WHEN  '2' THEN 'DispositivoMedico' 
WHEN  '3' THEN 'Elemento Consumo' 
WHEN  '4' THEN 'Nutricion Especial' 
WHEN  '5' THEN 'Equipo Biomedico' 
WHEN  '6' THEN 'Insumo Laboratorio' 
WHEN  '7' THEN 'Med VitalNO Disponible' 
END AS TipoProducto, sum(n.OutstandingQuantity) AS Cantidad, 
    CASE pr.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS Estado, pr.ProductCost AS CostoPromedio
FROM     Inventory.TransferOrder AS DO INNER JOIN
    Inventory.TransferOrderDetail AS DI ON DI.TransferOrderId = DO.Id INNER JOIN
    Inventory.InventoryProduct AS pr ON pr.Id = DI.ProductId INNER JOIN
    Inventory.ProductSubGroup AS sg ON sg.Id = pr.ProductSubGroupId INNER JOIN
    Inventory.Warehouse AS a ON a.Id = DO.SourceWarehouseId INNER JOIN
    Common.OperatingUnit AS UO ON UO.Id = DO.OperatingUnitId INNER JOIN
    Inventory.TransferOrderDetailBatchSerial AS N ON N .TransferOrderDetailId = DI.ID LEFT OUTER JOIN
    Inventory.ATC AS Med ON Med.Id = pr.ATCId LEFT OUTER JOIN
    Inventory.ATCEntity ATC ON Med.ATCEntityId = ATC.Id 
	--LEFT OUTER JOIN
    --[Reportes].dbo.V_INN_JER_SaldoAlmacen_CP AS infa ON infa.Codigo = pr.Code AND Infa.CodigoAlmacen = a.Code
WHERE do.documentdate >= '01-01-2021'
--CONVERT(NVARCHAR(10), DO.DocumentDate, 20) > CONVERT(VARCHAR(10), GETDATE() - 367, 20) 
	AND DO.STATUS = '2' 
	AND n.OutstandingQuantity <> '0' 
	AND DO.OrderType = '2' 
	AND sg.code <> 'OSTEO001' 
	AND sg.code <> 'PROTE001' 
	AND DO.OrderType = '2'
    GROUP BY UO.UnitName, a.id,
	(MONTH(DO.DocumentDate)),
	pr.Code, pr.Name, 
	pr.CodeAlternative, 
	pr.CodeAlternativeTwo, 
	sg.Code, 
	Med.Code + ' - ' + Med.Name, 
	ATC.Code, 
	ATC.Name, 
	CodeCUM, 
	pr.ProductTypeId,
	sg.Code + ' - ' + sg.Name, 
	pr.status, YEAR(DocumentDate),
	pr.ProductCost
--infa.CostoPromedio, 
--infa.Ultimocosto, 
--infa.Cantidad, 
--infa.Unidad
) source PIVOT (SUM(Cantidad) FOR SOURCE.Mes IN (Ene_V, Feb_V, Mar_V, Abr_V, May_V, Jun_V, Jul_V, Ago_V, Sep_V, Oct_V, 
    Nov_V, Dic_V, Ene_A, Feb_A, Mar_A, Abr_A, May_A, Jun_A, Jul_A, Ago_A, Sep_A, Oct_A, Nov_A, Dic_A)) AS pivotable
--WHERE Cod_Producto='20037237' --AND Sede='VILLAVICENCIO'
