-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_FIXED_RELACIONACTIVOS_VIE
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_FIXED_RELACIONACTIVOS_VIE AS

SELECT   Ing.Id AS IdIngreso, pa.AdquisitionDate AS FAdquisición, pa.Id AS id_activo, 
			CASE WHEN l.Code LIKE 'C%' THEN 'Faca' WHEN l.Code LIKE 'B%' THEN 'Bogota' WHEN l.Code LIKE 'F%' THEN 'Florencia' WHEN l.Code LIKE 'n%' THEN 'Neiva' WHEN l.Code LIKE 'T%' THEN 'Tunja' WHEN l.Code LIKE 'P%' THEN 'Pitalito' WHEN l.Code LIKE 'M%' THEN 'Mocoa' END AS Sucursal, Ing.Code AS Ingreso, 
			CASE Ing.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' when 3 then 'Anulado' END AS Estado, Ing.EntryDate AS Fecha, 
			CASE Ing.AdquisitionType WHEN '1' THEN 'CompraDirecta' WHEN '3' THEN 'Comodato' WHEN '4' THEN 'Donadacion' WHEN '5' THEN 'TraspasoBienes' WHEN '6' THEN 'OtroConcepto' WHEN '7' THEN 'LeasingFinanciero' WHEN '8' THEN 'Comodato Tercerizado' WHEN '9' THEN 'Renting Financiero' when '10' then 'Renting Operativo' END AS [Tipo Adquisición], RTRIM(Art.Code) AS CodArticulo, 
			RTRIM(Art.Description) AS [Artículo], CASE substring(tart.Code, 1, 2) 
			WHEN '01' THEN 'BIOMEDICO' WHEN '02' THEN 'INDUSTRIAL' WHEN '03' THEN 'INFRAESTRUCTURA' WHEN '04' THEN 'MOBILIARIO' WHEN '05' THEN 'MUEBLES_OFICINA' WHEN '06' THEN 'COMPUTO_COMUNICACIONES' WHEN '07' THEN 'INSTRUMENTAL_BIOMEDICO' WHEN '08' THEN 'ACCESORIO_BIOMEDICO' WHEN '09' THEN 'MEDICO_HOSPITALARIO' WHEN '10' THEN 'PATRON'
			WHEN '11' THEN 'OTROS' WHEN '12' THEN 'VEHICULOS' END AS TipoInventario, pa.Plate AS Placa, mar.Name AS Marca, pa.Model AS Modelo, pa.Serie, CASE pa.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS EstadoActivo, RTRIM(t .Nit) + ' - ' + RTRIM(t .Name) AS Responsable, 
			RTRIM(l.Code) + ' - ' + RTRIM(l.Name) AS Localizacion, 
			RTRIM(UF.Code) AS CodUF , RTRIM(UF.Name) AS UnidadFuncional, RTRIM(cc.Code) + ' - ' + RTRIM(cc.Name) AS CentroCosto, Ing.InvoiceDate AS FechaFactura, Ing.EntryNumber AS Factura, RTRIM(pv.Code) + ' - ' + RTRIM(pv.Name) AS Proveedor, pa.HistoricalValue AS VrHistorico, padb.DepreciatedValue AS VrDepreciado, padb.ResidualValue AS SaldoNeto, 
			CASE DIng.RemissionSource WHEN '1' THEN 'Ninguna' WHEN '2' THEN 'OrdenCompra' WHEN '3' THEN 'Remision_Entrada' END AS Origen, 
			rtrim(cata.Code) + ' - ' + rtrim(cata.Description) AS Catálogo, RTRIM(cue.Number) + ' - ' + RTRIM(cue.Name) AS Cuenta, RTRIM(pol.Code) + ' - ' + RTRIM(pol.Name) AS Poliza, Ing.Description AS Descripción, 
			isnull(trans.valorizacion,0)-isnull(desv.valorizacion,0)  AS VrTransacciones, 
			EID.WarrantyExpirationDate AS [Fecha vencimiento garantia], padb.LifeTime AS [VidaUtil], padb.DaysPendingDepreciate AS [DiasPendDepreciar], padb.DepreciatedDays AS [DiasDepreciados], l.UseTime AS [Tiempo Uso], CASE Art.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END [Deprecia Tiempo Uso], 
			DIng.IvaValue AS IvaItem, pa.NumberContractLeasing AS [Contrato Leasing], pa.InitialDateLeasing[Fecha Inicial Leasing], pa.EndDateLeasing AS [Fecha Final Leasing],
			case when padb.Devaluation is not null then padb.Devaluation else desv.valorizacion end as Desvalorizacion, trans.valorizacion as Valorizacion
FROM    INDIGO031.FixedAsset.FixedAssetEntry AS Ing  INNER JOIN
			INDIGO031.FixedAsset.FixedAssetEntryItem AS DIng  ON Ing.Id = DIng.FixedAssetEntryId AND Ing.Status <> '3' INNER JOIN
			INDIGO031.FixedAsset.FixedAssetEntryItemDetail AS EID ON EID.FixedAssetEntryItemId = DIng.Id INNER JOIN
			INDIGO031.FixedAsset.FixedAssetItem AS Art  ON Art.Id = DIng.ItemId INNER JOIN
			INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa  ON pa.ItemId = Art.Id AND pa.Plate = EID.Plate INNER JOIN
			INDIGO031.FixedAsset.FixedAssetItemType AS tart  ON tart.Id = Art.ItemTypeId INNER JOIN
			INDIGO031.Common.OperatingUnit AS uo ON uo.Id = Ing.OperatingUnitId INNER JOIN
			INDIGO031.Common.Supplier AS pv ON pv.Id = Ing.SupplierId INNER JOIN
			INDIGO031.FixedAsset.FixedAssetTrademark AS mar ON mar.Id = pa.TrademarkId INNER JOIN
			INDIGO031.GeneralLedger.MainAccounts AS cue  ON cue.Id = pa.MainAccountId AND cue.LegalBookId = '1' INNER JOIN
			INDIGO031.FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId INNER JOIN
			INDIGO031.FixedAsset.FixedAssetResponsible AS res ON res.Id = pa.ResponsibleId INNER JOIN
			INDIGO031.Common.ThirdParty AS t  ON t .Id = res.ThirdPartyId LEFT OUTER JOIN
			INDIGO031.FixedAsset.FixedAssetPolicy AS pol  ON pol.Id = pa.PolicyId INNER JOIN
			INDIGO031.Payroll.FunctionalUnit AS UF  ON UF.Id = l.FunctionalUnitId INNER JOIN
			INDIGO031.FixedAsset.FixedAssetItemCatalog AS cata  ON cata.Id = Art.ItemCatalogId LEFT OUTER JOIN
			INDIGO031.FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb  ON padb.PhysicalAssetId = pa.Id AND padb.LegalBookId = '1' INNER JOIN
			INDIGO031.Payroll.CostCenter AS cc ON cc.Id = UF.CostCenterId 
			LEFT OUTER JOIN (SELECT	t.PhysicalAssetId as idactivo, sum(t.TotalValue) as valorizacion
								FROM INDIGO031.FixedAsset.FixedAssetTransactionDetail as t INNER JOIN
										INDIGO031.FixedAsset.FixedAssetTransaction as tt on tt.Id=t.FixedAssetTransactionId INNER JOIN
										INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa on pa.Id=t.PhysicalAssetId
								WHERE  TransactionType='1' and ValorizationType='1'  and tt.Status='2'
								GROUP BY t.PhysicalAssetId ) as trans on trans.idactivo=pa.Id	 
			LEFT OUTER JOIN (SELECT	t.PhysicalAssetId as idactivo, sum(t.TotalValue) as valorizacion
								FROM INDIGO031.FixedAsset.FixedAssetTransactionDetail as t INNER JOIN
										INDIGO031.FixedAsset.FixedAssetTransaction as tt on tt.Id=t.FixedAssetTransactionId INNER JOIN
										INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa on pa.Id=t.PhysicalAssetId
								WHERE  TransactionType='2' and ValorizationType='0'  and tt.Status='2'  
								GROUP BY t.PhysicalAssetId) as desv on desv.idactivo=pa.Id	  
WHERE  (Ing.Status <> '3')  AND pa.HasOutput = '0'  AND pa.Status = '1' 

UNION ALL

SELECT  ' ' AS IdIngreso, pa.AdquisitionDate AS FAdquisición, faibi.Id AS id_activo, 
           CASE WHEN l.Code LIKE 'C%' THEN 'Faca' WHEN l.Code LIKE 'B%' THEN 'Bogota' WHEN l.Code LIKE 'F%' THEN 'Florencia' WHEN l.Code LIKE 'n%' THEN 'Neiva' WHEN l.Code LIKE 'T%' THEN 'Tunja' WHEN l.Code LIKE 'P%' THEN 'Pitalito' WHEN l.Code LIKE 'M%' THEN 'Mocoa' END AS Sucursal, 'SaldInic' + ' - ' + RTRIM(faib.Code) AS Ingreso, 
           CASE faib.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, faibi.AdquisitionDate AS Fecha, 
           CASE faibi.AdquisitionType WHEN '1' THEN 'CompraDirecta' WHEN '3' THEN 'Comodato' WHEN '4' THEN 'Donadacion' WHEN '5' THEN 'TraspasoBienes' WHEN '6' THEN 'OtroConcepto' WHEN '7' THEN 'LeasingFinanciero' WHEN '8' THEN 'Comodato Tercerizado' WHEN '9' THEN 'Renting Financiero' when '10' then 'Renting Operativo' END AS [Tipo Adquisición], RTRIM(fai.Code) AS CodArticulo, 
           RTRIM(fai.Description) AS [Artículo], CASE substring(ta.Code, 1, 2) 
           WHEN '01' THEN 'BIOMEDICO' WHEN '02' THEN 'INDUSTRIAL' WHEN '03' THEN 'INFRAESTRUCTURA' WHEN '04' THEN 'MOBILIARIO' WHEN '05' THEN 'MUEBLES_OFICINA' WHEN '06' THEN 'COMPUTO_COMUNICACIONES' WHEN '07' THEN 'INSTRUMENTAL_BIOMEDICO' WHEN '08' THEN 'ACCESORIO_BIOMEDICO' WHEN '09' THEN 'MEDICO_HOSPITALARIO' WHEN '10' THEN 'PATRON'
            WHEN '11' THEN 'OTROS' WHEN '12' THEN 'VEHICULOS' END AS TipoInventario, faibi.Plate AS 'Placa', mar.Name AS Marca, pa.Model AS Modelo, pa.Serie, 
			CASE pa.HasOutput WHEN 0 THEN 'Activo' WHEN 1 THEN 'Inactivo' END AS EstadoActivo,
			RTRIM(t .Nit) + ' - ' + RTRIM(t .Name) AS Responsable, 
			RTRIM(l.Code) + ' - ' + RTRIM(l.Name) AS Localizacion, 
			RTRIM(UF.Code) AS CodUF , RTRIM(UF.Name) AS UnidadFuncional, RTRIM(cc.Code) + ' - ' + RTRIM(cc.Name) AS CentroCosto, faibi.AdquisitionDate AS FechaFactura, 'N/A' AS Factura, RTRIM(pv.Code) + ' - ' + RTRIM(pv.Name) AS Proveedor, faibi.HistoricalValue AS VrHistorico, padb.DepreciatedValue AS VrDepreciado, 
		   padb.ResidualValue  AS SaldoNeto,
		   'SaldoInicial' AS Origen, RTRIM(cata.Code) 
           + ' - ' + RTRIM(cata.Description) AS Catálogo, 'N/A' AS Cuenta, RTRIM(pol.Code) + ' - ' + RTRIM(pol.Name) AS Poliza, 'SaldosIniciales' AS Descripción,
			isnull(trans.valorizacion,0)-isnull(desv.valorizacion,0)  AS VrTransacciones, 
			faibi.WarrantyExpirationDate AS [Fecha vencimiento garantia], padb.LifeTime AS [VidaUtil], padb.DaysPendingDepreciate AS [DiasPendDepreciar], 
           padb.DepreciatedDays AS [DiasDepreciados], l.UseTime AS [Tiempo Uso], CASE fai.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END [Deprecia Tiempo Uso], '0' AS IvaItem, pa.NumberContractLeasing AS [Contrato Leasing], pa.InitialDateLeasing[Fecha Inicial Leasing], pa.EndDateLeasing AS [Fecha Final Leasing], 
		   case when padb.Devaluation is not null then padb.Devaluation else desv.valorizacion end as Desvalorizacion, trans.valorizacion as Valorizacion
FROM    INDIGO031.FixedAsset.FixedAssetInitialBalanceItem AS faibi  LEFT OUTER JOIN
           INDIGO031.FixedAsset.FixedAssetInitialBalanceItemDetailBook AS faibidb  ON faibidb.FixedAssetInitialBalanceItemId = faibi.Id AND faibidb.LegalBookId = '1' INNER JOIN
           INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa ON faibi.Plate = pa.Plate INNER JOIN
           INDIGO031.FixedAsset.FixedAssetInitialBalance AS faib  ON faibi.FixedAssetInitialBalanceId = faib.Id INNER JOIN
           INDIGO031.FixedAsset.FixedAssetTrademark AS mar ON mar.Id = pa.TrademarkId INNER JOIN
           INDIGO031.FixedAsset.FixedAssetResponsible AS res  ON res.Id = pa.ResponsibleId INNER JOIN
           INDIGO031.Common.ThirdParty AS t  ON t .Id = res.ThirdPartyId INNER JOIN
           INDIGO031.FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId INNER JOIN
           INDIGO031.Common.Supplier AS pv  ON pv.Id = faibi.SupplierId INNER JOIN
           INDIGO031.FixedAsset.FixedAssetItem AS fai  ON faibi.ItemId = fai.Id LEFT OUTER JOIN
           INDIGO031.FixedAsset.FixedAssetItemType AS ta  ON ta.Id = fai.ItemTypeId INNER JOIN
           INDIGO031.Payroll.FunctionalUnit AS UF  ON UF.Id = l.FunctionalUnitId LEFT OUTER JOIN
           INDIGO031.FixedAsset.FixedAssetPolicy AS pol  ON pol.Id = faibi.PolicyId LEFT OUTER JOIN
		   (SELECT pa.Plate AS Placa, Art.ItemCatalogId as Catalogo
				FROM    INDIGO031.FixedAsset.FixedAssetItem AS Art  INNER JOIN
					INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa  ON pa.ItemId = Art.Id ) as articulo on articulo.Placa=faibi.Plate LEFT OUTER JOIN
           INDIGO031.FixedAsset.FixedAssetItemCatalog AS cata  ON cata.Id = articulo.Catalogo LEFT OUTER JOIN
           INDIGO031.FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb  ON padb.PhysicalAssetId = pa.Id AND padb.LegalBookId = '1' INNER JOIN
           INDIGO031.Payroll.CostCenter AS cc ON cc.Id = UF.CostCenterId
		     LEFT OUTER JOIN INDIGO031.FixedAsset.FixedAssetTransactionDetail AS fatd  on fatd.PhysicalAssetId=pa.Id and fai.Description like '%lote%'
			  LEFT OUTER JOIN (SELECT	t.PhysicalAssetId as idactivo, sum(t.TotalValue) as valorizacion
								FROM INDIGO031.FixedAsset.FixedAssetTransactionDetail as t INNER JOIN
										INDIGO031.FixedAsset.FixedAssetTransaction as tt on tt.Id=t.FixedAssetTransactionId INNER JOIN
										INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa on pa.Id=t.PhysicalAssetId
								WHERE  TransactionType='1' and ValorizationType='1'  and tt.Status='2'
								GROUP BY t.PhysicalAssetId) as trans on trans.idactivo=pa.Id	
			LEFT OUTER JOIN (SELECT	t.PhysicalAssetId as idactivo, sum(t.TotalValue) as valorizacion
								FROM INDIGO031.FixedAsset.FixedAssetTransactionDetail as t INNER JOIN
										INDIGO031.FixedAsset.FixedAssetTransaction as tt on tt.Id=t.FixedAssetTransactionId INNER JOIN
										INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa on pa.Id=t.PhysicalAssetId
								WHERE  TransactionType='2' and ValorizationType='0'  and tt.Status='2'  
								GROUP BY t.PhysicalAssetId) as desv on desv.idactivo=pa.Id	
WHERE  (faib.Status <> '3') 

UNION ALL

SELECT  Ing.Id AS IdIngreso, pa.AdquisitionDate AS FAdquisición, pa.Id AS id_activo, 
           CASE WHEN l.Code LIKE 'C%' THEN 'Faca' WHEN l.Code LIKE 'B%' THEN 'Bogota' WHEN l.Code LIKE 'F%' THEN 'Florencia' WHEN l.Code LIKE 'n%' THEN 'Neiva' WHEN l.Code LIKE 'T%' THEN 'Tunja' WHEN l.Code LIKE 'P%' THEN 'Pitalito' WHEN l.Code LIKE 'M%' THEN 'Mocoa' END AS Sucursal, Ing.Code AS Ingreso, 
           CASE Ing.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado'  END AS Estado, Ing.EntryDate AS Fecha, 
           CASE Ing.AdquisitionType WHEN '1' THEN 'CompraDirecta' WHEN '3' THEN 'Comodato' WHEN '4' THEN 'Donadacion' WHEN '5' THEN 'TraspasoBienes' WHEN '6' THEN 'OtroConcepto' WHEN '7' THEN 'LeasingFinanciero' WHEN '8' THEN 'Comodato Tercerizado' WHEN '9' THEN 'Renting Financiero'  when '10' then 'Renting Operativo' END AS [Tipo Adquisición], RTRIM(Art.Code) AS CodArticulo, 
           RTRIM(Art.Description) AS [Artículo], CASE substring(tart.Code, 1, 2) 
           WHEN '01' THEN 'BIOMEDICO' WHEN '02' THEN 'INDUSTRIAL' WHEN '03' THEN 'INFRAESTRUCTURA' WHEN '04' THEN 'MOBILIARIO' WHEN '05' THEN 'MUEBLES_OFICINA' WHEN '06' THEN 'COMPUTO_COMUNICACIONES' WHEN '07' THEN 'INSTRUMENTAL_BIOMEDICO' WHEN '08' THEN 'ACCESORIO_BIOMEDICO' WHEN '09' THEN 'MEDICO_HOSPITALARIO' WHEN '10' THEN 'PATRON'
            WHEN '11' THEN 'OTROS' WHEN '12' THEN 'VEHICULOS' END AS TipoInventario, pa.Plate AS Placa, mar.Name AS Marca, pa.Model AS Modelo, pa.Serie, CASE pa.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS EstadoActivo, RTRIM(t .Nit) + ' - ' + RTRIM(t .Name) AS Responsable, 
			RTRIM(l.Code) + ' - ' + RTRIM(l.Name) AS Localizacion, 
			RTRIM(UF.Code) AS CodUF , RTRIM(UF.Name) AS UnidadFuncional, RTRIM(cc.Code) + ' - ' + RTRIM(cc.Name) AS CentroCosto, Ing.InvoiceDate AS FechaFactura, Ing.EntryNumber AS Factura, RTRIM(pv.Code) + ' - ' + RTRIM(pv.Name) AS Proveedor, pa.HistoricalValue AS VrHistorico, padb.DepreciatedValue AS VrDepreciado, padb.ResidualValue AS SaldoNeto, 
           CASE DIng.RemissionSource WHEN '1' THEN 'Ninguna' WHEN '2' THEN 'OrdenCompra' WHEN '3' THEN 'Remision_Entrada' END AS Origen, 
		   rtrim(cata.Code) + ' - ' + rtrim(cata.Description) AS Catálogo, RTRIM(cue.Number) + ' - ' + RTRIM(cue.Name) AS Cuenta, RTRIM(pol.Code) + ' - ' + RTRIM(pol.Name) AS Poliza, Ing.Description AS Descripción, 
		  isnull(trans.valorizacion,0)-isnull(desv.valorizacion,0)  AS VrTransacciones,    
		   EID.WarrantyExpirationDate AS [Fecha vencimiento garantia], padb.LifeTime AS [VidaUtil], padb.DaysPendingDepreciate AS [DiasPendDepreciar], padb.DepreciatedDays AS [DiasDepreciados], l.UseTime AS [Tiempo Uso], CASE Art.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END [Deprecia Tiempo Uso], 
           DIng.IvaValue AS IvaItem, pa.NumberContractLeasing AS [Contrato Leasing], pa.InitialDateLeasing[Fecha Inicial Leasing], pa.EndDateLeasing AS [Fecha Final Leasing],
		   case when padb.Devaluation is not null then padb.Devaluation else desv.valorizacion end as Desvalorizacion, trans.valorizacion as Valorizacion
FROM    INDIGO031.FixedAsset.FixedAssetEntry AS Ing  INNER JOIN
           INDIGO031.FixedAsset.FixedAssetEntryItem AS DIng  ON Ing.Id = DIng.FixedAssetEntryId AND Ing.Status <> '3' INNER JOIN
           INDIGO031.FixedAsset.FixedAssetEntryItemDetail AS EID  ON EID.FixedAssetEntryItemId = DIng.Id INNER JOIN
           INDIGO031.FixedAsset.FixedAssetItem AS Art  ON Art.Id = DIng.ItemId INNER JOIN
           INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa  ON pa.ItemId = Art.Id AND pa.Plate = EID.Plate INNER JOIN
           INDIGO031.FixedAsset.FixedAssetItemType AS tart  ON tart.Id = Art.ItemTypeId INNER JOIN
           INDIGO031.Common.OperatingUnit AS uo ON uo.Id = Ing.OperatingUnitId INNER JOIN
           INDIGO031.Common.Supplier AS pv ON pv.Id = Ing.SupplierId INNER JOIN
           INDIGO031.FixedAsset.FixedAssetTrademark AS mar ON mar.Id = pa.TrademarkId INNER JOIN
           INDIGO031.GeneralLedger.MainAccounts AS cue  ON cue.Id = pa.MainAccountId AND cue.LegalBookId = '1' INNER JOIN
           INDIGO031.FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId INNER JOIN
           INDIGO031.FixedAsset.FixedAssetResponsible AS res ON res.Id = pa.ResponsibleId INNER JOIN
           INDIGO031.Common.ThirdParty AS t  ON t .Id = res.ThirdPartyId LEFT OUTER JOIN
           INDIGO031.FixedAsset.FixedAssetPolicy AS pol  ON pol.Id = pa.PolicyId INNER JOIN
           INDIGO031.Payroll.FunctionalUnit AS UF  ON UF.Id = l.FunctionalUnitId INNER JOIN
           INDIGO031.FixedAsset.FixedAssetItemCatalog AS cata  ON cata.Id = Art.ItemCatalogId LEFT OUTER JOIN
           INDIGO031.FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb  ON padb.PhysicalAssetId = pa.Id AND padb.LegalBookId = '1' INNER JOIN
           INDIGO031.Payroll.CostCenter AS cc ON cc.Id = UF.CostCenterId 
		   LEFT OUTER JOIN (SELECT	t.PhysicalAssetId as idactivo, sum(t.TotalValue) as valorizacion
								FROM INDIGO031.FixedAsset.FixedAssetTransactionDetail as t INNER JOIN
										INDIGO031.FixedAsset.FixedAssetTransaction as tt on tt.Id=t.FixedAssetTransactionId INNER JOIN
										INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa on pa.Id=t.PhysicalAssetId
								WHERE  TransactionType='1' and ValorizationType='1'  and tt.Status='2'
								GROUP BY t.PhysicalAssetId ) as trans on trans.idactivo=pa.Id	 
			LEFT OUTER JOIN (SELECT	t.PhysicalAssetId as idactivo, sum(t.TotalValue) as valorizacion
								FROM INDIGO031.FixedAsset.FixedAssetTransactionDetail as t INNER JOIN
										INDIGO031.FixedAsset.FixedAssetTransaction as tt on tt.Id=t.FixedAssetTransactionId INNER JOIN
										INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa on pa.Id=t.PhysicalAssetId
								WHERE  TransactionType='2' and ValorizationType='0'  and tt.Status='2'  
								GROUP BY t.PhysicalAssetId) as desv on desv.idactivo=pa.Id	  
WHERE  (Ing.Status <> '3') AND pa.Status = '0' AND pa.HasOutput = '1'  and Ing.AdquisitionType in ('3','8')  

UNION ALL

SELECT   Ing.Id AS IdIngreso, pa.AdquisitionDate AS FAdquisición, pa.Id AS id_activo, 
           CASE WHEN l.Code LIKE 'C%' THEN 'Faca' WHEN l.Code LIKE 'B%' THEN 'Bogota' WHEN l.Code LIKE 'F%' THEN 'Florencia' WHEN l.Code LIKE 'n%' THEN 'Neiva' WHEN l.Code LIKE 'T%' THEN 'Tunja' WHEN l.Code LIKE 'P%' THEN 'Pitalito' WHEN l.Code LIKE 'M%' THEN 'Mocoa' END AS Sucursal, Ing.Code AS Ingreso, 
           CASE Ing.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado'  END AS Estado, Ing.EntryDate AS Fecha, 
           CASE Ing.AdquisitionType WHEN '1' THEN 'CompraDirecta' WHEN '3' THEN 'Comodato' WHEN '4' THEN 'Donadacion' WHEN '5' THEN 'TraspasoBienes' WHEN '6' THEN 'OtroConcepto' WHEN '7' THEN 'LeasingFinanciero' WHEN '8' THEN 'Comodato Tercerizado' WHEN '9' THEN 'Renting Financiero' when '10' then 'Renting Operativo' END AS [Tipo Adquisición], RTRIM(Art.Code) AS CodArticulo, 
           RTRIM(Art.Description) AS [Artículo], CASE substring(tart.Code, 1, 2) 
           WHEN '01' THEN 'BIOMEDICO' WHEN '02' THEN 'INDUSTRIAL' WHEN '03' THEN 'INFRAESTRUCTURA' WHEN '04' THEN 'MOBILIARIO' WHEN '05' THEN 'MUEBLES_OFICINA' WHEN '06' THEN 'COMPUTO_COMUNICACIONES' WHEN '07' THEN 'INSTRUMENTAL_BIOMEDICO' WHEN '08' THEN 'ACCESORIO_BIOMEDICO' WHEN '09' THEN 'MEDICO_HOSPITALARIO' WHEN '10' THEN 'PATRON'
            WHEN '11' THEN 'OTROS' WHEN '12' THEN 'VEHICULOS' END AS TipoInventario, pa.Plate AS Placa, mar.Name AS Marca, pa.Model AS Modelo, pa.Serie, CASE pa.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS EstadoActivo, RTRIM(t .Nit) + ' - ' + RTRIM(t .Name) AS Responsable, 
			RTRIM(l.Code) + ' - ' + RTRIM(l.Name) AS Localizacion, 
			RTRIM(UF.Code) AS CodUF , RTRIM(UF.Name) AS UnidadFuncional, RTRIM(cc.Code) + ' - ' + RTRIM(cc.Name) AS CentroCosto, Ing.InvoiceDate AS FechaFactura, Ing.EntryNumber AS Factura, RTRIM(pv.Code) + ' - ' + RTRIM(pv.Name) AS Proveedor, pa.HistoricalValue AS VrHistorico, padb.DepreciatedValue AS VrDepreciado, padb.ResidualValue AS SaldoNeto, 
           CASE DIng.RemissionSource WHEN '1' THEN 'Ninguna' WHEN '2' THEN 'OrdenCompra' WHEN '3' THEN 'Remision_Entrada' END AS Origen, 
		   rtrim(cata.Code) + ' - ' + rtrim(cata.Description) AS Catálogo, RTRIM(cue.Number) + ' - ' + RTRIM(cue.Name) AS Cuenta, RTRIM(pol.Code) + ' - ' + RTRIM(pol.Name) AS Poliza, Ing.Description AS Descripción, 
		  isnull(trans.valorizacion,0)-isnull(desv.valorizacion,0)  AS VrTransacciones,    
		   EID.WarrantyExpirationDate AS [Fecha vencimiento garantia], padb.LifeTime AS [VidaUtil], padb.DaysPendingDepreciate AS [DiasPendDepreciar], padb.DepreciatedDays AS [DiasDepreciados], l.UseTime AS [Tiempo Uso], CASE Art.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END [Deprecia Tiempo Uso], 
           DIng.IvaValue AS IvaItem, pa.NumberContractLeasing AS [Contrato Leasing], pa.InitialDateLeasing[Fecha Inicial Leasing], pa.EndDateLeasing AS [Fecha Final Leasing],
		   case when padb.Devaluation is not null then padb.Devaluation else desv.valorizacion end as Desvalorizacion, trans.valorizacion as Valorizacion
FROM    INDIGO031.FixedAsset.FixedAssetEntry AS Ing  INNER JOIN
           INDIGO031.FixedAsset.FixedAssetEntryItem AS DIng  ON Ing.Id = DIng.FixedAssetEntryId AND Ing.Status <> '3' INNER JOIN
           INDIGO031.FixedAsset.FixedAssetEntryItemDetail AS EID  ON EID.FixedAssetEntryItemId = DIng.Id INNER JOIN
           INDIGO031.FixedAsset.FixedAssetItem AS Art  ON Art.Id = DIng.ItemId INNER JOIN
           INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa  ON pa.ItemId = Art.Id AND pa.Plate = EID.Plate INNER JOIN
           INDIGO031.FixedAsset.FixedAssetItemType AS tart  ON tart.Id = Art.ItemTypeId INNER JOIN
           INDIGO031.Common.OperatingUnit AS uo ON uo.Id = Ing.OperatingUnitId INNER JOIN
           INDIGO031.Common.Supplier AS pv ON pv.Id = Ing.SupplierId INNER JOIN
           INDIGO031.FixedAsset.FixedAssetTrademark AS mar ON mar.Id = pa.TrademarkId INNER JOIN
           INDIGO031.GeneralLedger.MainAccounts AS cue  ON cue.Id = pa.MainAccountId AND cue.LegalBookId = '1' INNER JOIN
           INDIGO031.FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId INNER JOIN
           INDIGO031.FixedAsset.FixedAssetResponsible AS res ON res.Id = pa.ResponsibleId INNER JOIN
           INDIGO031.Common.ThirdParty AS t  ON t .Id = res.ThirdPartyId LEFT OUTER JOIN
           INDIGO031.FixedAsset.FixedAssetPolicy AS pol  ON pol.Id = pa.PolicyId INNER JOIN
           INDIGO031.Payroll.FunctionalUnit AS UF  ON UF.Id = l.FunctionalUnitId INNER JOIN
           INDIGO031.FixedAsset.FixedAssetItemCatalog AS cata  ON cata.Id = Art.ItemCatalogId LEFT OUTER JOIN
           INDIGO031.FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb  ON padb.PhysicalAssetId = pa.Id AND padb.LegalBookId = '1' INNER JOIN
           INDIGO031.Payroll.CostCenter AS cc ON cc.Id = UF.CostCenterId 
		   LEFT OUTER JOIN (SELECT	t.PhysicalAssetId as idactivo, sum(t.TotalValue) as valorizacion
								FROM INDIGO031.FixedAsset.FixedAssetTransactionDetail as t INNER JOIN
										INDIGO031.FixedAsset.FixedAssetTransaction as tt on tt.Id=t.FixedAssetTransactionId INNER JOIN
										INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa on pa.Id=t.PhysicalAssetId
								WHERE  TransactionType='1' and ValorizationType='1'  and tt.Status='2'
								GROUP BY t.PhysicalAssetId ) as trans on trans.idactivo=pa.Id	 
			LEFT OUTER JOIN (SELECT	t.PhysicalAssetId as idactivo, sum(t.TotalValue) as valorizacion
								FROM INDIGO031.FixedAsset.FixedAssetTransactionDetail as t INNER JOIN
										INDIGO031.FixedAsset.FixedAssetTransaction as tt on tt.Id=t.FixedAssetTransactionId INNER JOIN
										INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa on pa.Id=t.PhysicalAssetId
								WHERE  TransactionType='2' and ValorizationType='0'  and tt.Status='2'  
								GROUP BY t.PhysicalAssetId) as desv on desv.idactivo=pa.Id	  
WHERE  (Ing.Status <> '3') AND pa.Status = '1' AND pa.HasOutput = '1'  and Ing.AdquisitionType in ('3','8') 

UNION ALL

SELECT 0 AS IdIngreso, pa.AdquisitionDate AS FAdquisición, pa.Id AS id_activo, 
			CASE WHEN l.Code LIKE 'C%' THEN 'Faca' WHEN l.Code LIKE 'B%' THEN 'Bogota' WHEN l.Code LIKE 'F%' THEN 'Florencia'
			WHEN l.Code LIKE 'n%' THEN 'Neiva' WHEN l.Code LIKE 'T%' THEN 'Tunja' WHEN l.Code LIKE 'P%' THEN 'Pitalito' 
			WHEN l.Code LIKE 'M%' THEN 'Mocoa' END AS Sucursal, '' AS Ingreso, 
			''  AS Estado, '' AS Fecha, 
			''AS [Tipo Adquisición], RTRIM(Art.Code) AS CodArticulo, 
			RTRIM(Art.Description) AS [Artículo], CASE substring(tart.Code, 1, 2) 
			WHEN '01' THEN 'BIOMEDICO' WHEN '02' THEN 'INDUSTRIAL' WHEN '03' THEN 'INFRAESTRUCTURA' WHEN '04' THEN 'MOBILIARIO' 
			WHEN '05' THEN 'MUEBLES_OFICINA' WHEN '06' THEN 'COMPUTO_COMUNICACIONES' WHEN '07' THEN 'INSTRUMENTAL_BIOMEDICO' WHEN '08' THEN 'ACCESORIO_BIOMEDICO' WHEN '09' THEN 'MEDICO_HOSPITALARIO' WHEN '10' THEN 'PATRON'
			WHEN '11' THEN 'OTROS' WHEN '12' THEN 'VEHICULOS' END AS TipoInventario, pa.Plate AS Placa,
			mar.Name AS Marca, pa.Model AS Modelo, pa.Serie, 
			CASE pa.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS EstadoActivo, RTRIM(t .Nit) + ' - ' + RTRIM(t .Name) AS Responsable, 
			RTRIM(l.Code) + ' - ' + RTRIM(l.Name) AS Localizacion, 
			RTRIM(UF.Code) AS CodUF , RTRIM(UF.Name) AS UnidadFuncional, RTRIM(cc.Code) + ' - ' + RTRIM(cc.Name) AS CentroCosto,
			'' AS FechaFactura, '' AS Factura, '' AS Proveedor, pa.HistoricalValue AS VrHistorico, padb.DepreciatedValue AS VrDepreciado, padb.ResidualValue AS SaldoNeto, 
			'' AS Origen, 
			rtrim(cata.Code) + ' - ' + rtrim(cata.Description) AS Catálogo, RTRIM(cue.Number) + ' - ' + RTRIM(cue.Name) AS Cuenta, RTRIM(pol.Code) + ' - ' + RTRIM(pol.Name) AS Poliza, '0' AS Descripción, 
			isnull(trans.valorizacion,0)-isnull(desv.valorizacion,0)   AS VrTransacciones, 
			'' AS [Fecha vencimiento garantia], padb.LifeTime AS [VidaUtil], padb.DaysPendingDepreciate AS [DiasPendDepreciar], padb.DepreciatedDays AS [DiasDepreciados], l.UseTime AS [Tiempo Uso], CASE Art.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END [Deprecia Tiempo Uso], 
			0 AS IvaItem, pa.NumberContractLeasing AS [Contrato Leasing], pa.InitialDateLeasing[Fecha Inicial Leasing], pa.EndDateLeasing AS [Fecha Final Leasing],
			case when padb.Devaluation is not null then padb.Devaluation else desv.valorizacion end as Desvalorizacion, trans.valorizacion as Valorizacion
FROM INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa INNER JOIN
INDIGO031.FixedAsset.FixedAssetItem AS Art  ON pa.ItemId = Art.Id INNER JOIN
INDIGO031.FixedAsset.FixedAssetItemType AS tart  ON tart.Id = Art.ItemTypeId INNER JOIN
			INDIGO031.FixedAsset.FixedAssetTrademark AS mar ON mar.Id = pa.TrademarkId INNER JOIN
			INDIGO031.GeneralLedger.MainAccounts AS cue  ON cue.Id = pa.MainAccountId AND cue.LegalBookId = '1' INNER JOIN
			INDIGO031.FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId INNER JOIN
			INDIGO031.FixedAsset.FixedAssetResponsible AS res ON res.Id = pa.ResponsibleId INNER JOIN
			INDIGO031.Common.ThirdParty AS t  ON t .Id = res.ThirdPartyId LEFT OUTER JOIN
			INDIGO031.FixedAsset.FixedAssetPolicy AS pol  ON pol.Id = pa.PolicyId INNER JOIN
			INDIGO031.Payroll.FunctionalUnit AS UF  ON UF.Id = l.FunctionalUnitId INNER JOIN
			INDIGO031.FixedAsset.FixedAssetItemCatalog AS cata  ON cata.Id = Art.ItemCatalogId LEFT OUTER JOIN
			INDIGO031.FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb  ON padb.PhysicalAssetId = pa.Id AND padb.LegalBookId = '1' INNER JOIN
			INDIGO031.Payroll.CostCenter AS cc ON cc.Id = UF.CostCenterId 
			LEFT OUTER JOIN (SELECT	t.PhysicalAssetId as idactivo, sum(t.TotalValue) as valorizacion
								FROM INDIGO031.FixedAsset.FixedAssetTransactionDetail as t INNER JOIN
										INDIGO031.FixedAsset.FixedAssetTransaction as tt on tt.Id=t.FixedAssetTransactionId INNER JOIN
										INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa on pa.Id=t.PhysicalAssetId
								WHERE  TransactionType='1' and ValorizationType='1'  and tt.Status='2'
								GROUP BY t.PhysicalAssetId ) as trans on trans.idactivo=pa.Id	 
			LEFT OUTER JOIN (SELECT	t.PhysicalAssetId as idactivo, sum(t.TotalValue) as valorizacion
								FROM INDIGO031.FixedAsset.FixedAssetTransactionDetail as t INNER JOIN
										INDIGO031.FixedAsset.FixedAssetTransaction as tt on tt.Id=t.FixedAssetTransactionId INNER JOIN
										INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS pa on pa.Id=t.PhysicalAssetId
								WHERE  TransactionType='2' and ValorizationType='0'  and tt.Status='2'  
								GROUP BY t.PhysicalAssetId) as desv on desv.idactivo=pa.Id	  
WHERE pa.Status = '1' AND pa.HasOutput = '0'  and pa.Plate not in (SELECT Plate
												FROM INDIGO031.FixedAsset.FixedAssetEntryItemDetail)
						 AND pa.Plate not in (SELECT Plate
												FROM INDIGO031.FixedAsset.FixedAssetInitialBalanceItem AS faibi  LEFT OUTER JOIN
													 INDIGO031.FixedAsset.FixedAssetInitialBalanceItemDetailBook AS faibidb  ON faibidb.FixedAssetInitialBalanceItemId = faibi.Id AND faibidb.LegalBookId = '1' 
													 )