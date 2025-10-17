-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_INN_JER_SaldoAlmacenes
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[V_INN_JER_SaldoAlmacenes]
AS
     --select * from Inventory.Warehouse
     SELECT *
     FROM
     (
         SELECT PR.Id AS IDPr,
                --al.id as IdAlmacen,
                CASE al.id
                    WHEN '18'
                    THEN 'TUNJA'
                    WHEN '19'
                    THEN 'DUITAMA'
                    WHEN '20'
                    THEN 'SOGAMOSO'
                    WHEN '21'
                    THEN 'CHIQUINQUIRA'
                    WHEN '22'
                    THEN 'GUATEQUE'
                    WHEN '23'
                    THEN 'GARAGOA'
                    WHEN '24'
                    THEN 'SOATA'
                    WHEN '25'
                    THEN 'MONIQUIRA'
                    WHEN '26'
                    THEN 'VILLAVICENCIO'
                    WHEN '27'
                    THEN 'ACACIAS'
                    WHEN '28'
                    THEN 'GRANADA'
                    WHEN '29'
                    THEN 'PUERTO LOPEZ'
                    WHEN '30'
                    THEN 'PUERTO GAITAN'
                    WHEN '31'
                    THEN 'YOPAL'
                    WHEN '32'
                    THEN 'TUNJA'
                    WHEN '34'
                    THEN 'PUERTO BOYACA'
                    WHEN '35'
                    THEN 'VILLAVICENCIO'
                    WHEN '36'
                    THEN 'VILLAVICENCIO'
                    WHEN '37'
                    THEN 'YOPAL'
                    WHEN '3'
                    THEN 'BOGOTA'
                END AS Sede, 
                pr.Code AS Codigo, 
                pr.Name AS Producto, 
                TP.Name AS [TipoProducto], 
                Med.Code AS [Cod Med], 
                Med.Name AS Medicamento, 
                ins.Code AS Cod_Insumo, 
                ins.SupplieName AS Insumo,

/*CASE  pr.ProductTypeId 
	     WHEN '1' THEN 'Medicamento' 
	     WHEN '2' THEN 'DispositivoMedico' 
	     WHEN '3' THEN 'Elemento Consumo' 
	     WHEN '4' THEN 'Nutricion Especial' 
	     WHEN '5' THEN 'Equipo Biomedico' 
	     WHEN '6' THEN 'Insumo Laboratorio' 
	     WHEN '7' THEN 'Med VitalNO Disponible' 
	    END AS TipoProducto,*/

                pr.Abbreviation AS Abreviatura, 
                ATC.Code AS ATC, 
                ATC.Name AS NombreATC, 
                pr.CodeCUM AS CUM, 
                pr.CodeAlternativeTwo AS [CodigoAlterno2], 
                sg.Name AS SubGrupo, 
                ue.Name AS UnidadEmpaque, 
                ue.Abbreviation AS FactorConversion, 
                gf.Name AS [GrupoFacturacion],
                CASE pr.ProductControl
                    WHEN '0'
                    THEN 'No'
                    WHEN '1'
                    THEN 'Si'
                END AS [ProdControl], 
                pr.ProductCost AS CostoPromedio, 
                pr.FinalProductCost AS Ultimocosto,
                CASE pr.ProductWithPriceControl
                    WHEN 0
                    THEN ''
                    WHEN 1
                    THEN 'SI'
                END AS Regulado,
                CASE pr.STATUS
                    WHEN '1'
                    THEN 'Activo'
                    WHEN '0'
                    THEN 'Inactivo'
                END AS Estado, 
                inf.Quantity AS Cantidad, 
                al.Code AS CodAlmacen,
                CASE Med.HighCost
                    WHEN 0
                    THEN 'NO'
                    WHEN 1
                    THEN 'SI'
                END AS AltoCosto, 
                F.Name AS Fabricante
         FROM Inventory.InventoryProduct AS pr
              LEFT OUTER JOIN Inventory.PhysicalInventory AS inf ON inf.ProductId = pr.Id
              LEFT OUTER JOIN Inventory.Warehouse AS al ON al.Id = inf.WarehouseId
              LEFT OUTER JOIN Inventory.ATC AS Med ON Med.Id = pr.ATCId
              LEFT OUTER JOIN inventory.InventorySupplie AS ins ON ins.Id = pr.SupplieId
              LEFT JOIN Inventory.ProductSubGroup AS sg ON sg.Id = pr.ProductSubGroupId
              LEFT OUTER JOIN Inventory.PackagingUnit AS ue ON ue.Id = pr.PackagingUnitId
              LEFT OUTER JOIN Billing.BillingGroup AS gf ON gf.Id = pr.BillingGroupId
              LEFT JOIN Inventory.ATCEntity ATC ON Med.ATCEntityId = ATC.Id
              JOIN Inventory.ProductType TP ON PR.ProductTypeId = TP.Id
              INNER JOIN Inventory.Manufacturer AS F ON F.Id = pr.ManufacturerId
         WHERE al.code IN('PTG001','CHQ001','YPL001','RME100','MRS001','MQR001','PTL001','GRG001','RCA100','STA001','ACB001','TJA001','VCO001','ACM001','VIN001','AGZ001','ACC001','SMT001','GTQ001',
'GND001','DUI001','PDA001','PBY001','TJA100','ACA001','SOG001')
              AND INF.Quantity > 0
     ) source PIVOT(SUM(Cantidad) FOR source.CodAlmacen IN(
														   [PTG001],
[CHQ001],
[YPL001],
[RME100],
[MRS001],
[MQR001],
[PTL001],
[GRG001],
[RCA100],
[STA001],
[ACB001],
[TJA001],
[VCO001],
[ACM001],
[VIN001],
[AGZ001],
[ACC001],
[SMT001],
[GTQ001],
[GND001],
[DUI001],
[PDA001],
[PBY001],
[TJA100],
[ACA001],
[SOG001])) AS pivotable;
--where Codigo='20105885-01'
