-- Workspace: SQLServer
-- Item: INDIGO022 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Fixed_RelaciónActivos_Vie
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Fixed_RelaciónActivos_Vie] AS
SELECT   Ing.id AS IdIngreso, pa.AdquisitionDate AS FAdquisición, pa.Id AS id_activo, 
			CASE WHEN l.Code LIKE 'C%' THEN 'Faca' WHEN l.Code LIKE 'B%' THEN 'Bogota' WHEN l.Code LIKE 'F%' THEN 'Florencia' WHEN l.Code LIKE 'n%' THEN 'Neiva' WHEN l.Code LIKE 'T%' THEN 'Tunja' WHEN l.Code LIKE 'P%' THEN 'Pitalito' WHEN l.Code LIKE 'M%' THEN 'Mocoa' END AS Sucursal, Ing.Code AS Ingreso, 
			CASE Ing.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' when 3 then 'Anulado' END AS Estado, Ing.EntryDate AS Fecha, 
			CASE Ing.AdquisitionType WHEN '1' THEN 'CompraDirecta' WHEN '3' THEN 'Comodato' WHEN '4' THEN 'Donadacion' WHEN '5' THEN 'TraspasoBienes' WHEN '6' THEN 'OtroConcepto' WHEN '7' THEN 'LeasingFinanciero' WHEN '8' THEN 'Comodato Tercerizado' WHEN '9' THEN 'Renting Financiero' when '10' then 'Renting Operativo' END AS [Tipo Adquisición], RTRIM(Art.Code) AS CodArticulo, 
			RTRIM(Art.Description) AS [Artículo], CASE substring(tart.Code, 1, 2) 
			WHEN '01' THEN 'BIOMEDICO' WHEN '02' THEN 'INDUSTRIAL' WHEN '03' THEN 'INFRAESTRUCTURA' WHEN '04' THEN 'MOBILIARIO' WHEN '05' THEN 'MUEBLES_OFICINA' WHEN '06' THEN 'COMPUTO_COMUNICACIONES' WHEN '07' THEN 'INSTRUMENTAL_BIOMEDICO' WHEN '08' THEN 'ACCESORIO_BIOMEDICO' WHEN '09' THEN 'MEDICO_HOSPITALARIO' WHEN '10' THEN 'PATRON'
			WHEN '11' THEN 'OTROS' WHEN '12' THEN 'VEHICULOS' END AS TipoInventario, pa.Plate AS Placa, mar.Name AS Marca, pa.Model AS Modelo, pa.Serie, CASE pa.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS EstadoActivo, RTRIM(t .Nit) + ' - ' + RTRIM(t .Name) AS Responsable, 
			RTRIM(l.Code) + ' - ' + RTRIM(l.Name) AS Localizacion, 
			RTRIM(UF.Code) AS CodUF , RTRIM(UF.Name) AS UnidadFuncional, RTRIM(cc.cODE) + ' - ' + RTRIM(CC.nAME) AS CentroCosto, Ing.InvoiceDate AS FechaFactura, Ing.EntryNumber AS Factura, RTRIM(pv.Code) + ' - ' + RTRIM(pv.Name) AS Proveedor, pa.HistoricalValue AS VrHistorico, padb.DepreciatedValue AS VrDepreciado, padb.ResidualValue AS SaldoNeto, 
			CASE DIng.RemissionSource WHEN '1' THEN 'Ninguna' WHEN '2' THEN 'OrdenCompra' WHEN '3' THEN 'Remision_Entrada' END AS Origen, 
			rtrim(cata.Code) + ' - ' + rtrim(cata.Description) AS Catálogo, RTRIM(cue.Number) + ' - ' + RTRIM(cue.Name) AS Cuenta, RTRIM(pol.Code) + ' - ' + RTRIM(pol.Name) AS Poliza, Ing.Description AS Descripción, 
          
			-- padb.TransactionValue 
		  
			isnull(trans.valorizacion,0)-isnull(desv.valorizacion,0)  AS VrTransacciones, 
		   
			EID.WarrantyExpirationDate AS [Fecha vencimiento garantia], padb.LifeTime AS [VidaUtil], padb.DaysPendingDepreciate AS [DiasPendDepreciar], padb.DepreciatedDays AS [DiasDepreciados], l.UseTime AS [Tiempo Uso], CASE art.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END [Deprecia Tiempo Uso], 
			DIng.IvaValue AS IvaItem, pa.NumberContractLeasing AS [Contrato Leasing], pa.InitialDateLeasing[Fecha Inicial Leasing], pa.EndDateLeasing AS [Fecha Final Leasing],
			case when padb.Devaluation is not null then padb.Devaluation else desv.valorizacion end as Desvalorizacion, trans.valorizacion as Valorizacion
FROM    FixedAsset.FixedAssetEntry AS Ing  INNER JOIN
			FixedAsset.FixedAssetEntryItem AS DIng  ON Ing.Id = DIng.FixedAssetEntryId AND Ing.Status <> '3' INNER JOIN
			FixedAsset.FixedAssetEntryItemDetail AS eid ON eid.FixedAssetEntryItemId = DIng.id INNER JOIN
			FixedAsset.FixedAssetItem AS Art  ON Art.Id = DIng.ItemId INNER JOIN
			FixedAsset.FixedAssetPhysicalAsset AS pa  ON pa.ItemId = Art.Id AND pa.plate = eid.plate INNER JOIN
			FixedAsset.FixedAssetItemType AS tart  ON tart.Id = Art.ItemTypeId INNER JOIN
			Common.OperatingUnit AS uo ON uo.Id = Ing.OperatingUnitId INNER JOIN
			Common.Supplier AS pv ON pv.Id = Ing.SupplierId INNER JOIN
			FixedAsset.FixedAssetTrademark AS mar ON mar.Id = pa.TrademarkId INNER JOIN
			GeneralLedger.MainAccounts AS cue  ON cue.Id = pa.MainAccountId AND cue.LegalBookId = '1' INNER JOIN
			.FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId INNER JOIN
			FixedAsset.FixedAssetResponsible AS res ON res.Id = pa.ResponsibleId /* AND pa.AdquisitionDate > '31/12/2016 00:00:00' */ INNER JOIN
			Common.ThirdParty AS t  ON t .Id = res.ThirdPartyId LEFT OUTER JOIN
			FixedAsset.FixedAssetPolicy AS pol  ON pol.Id = pa.PolicyId INNER JOIN
			Payroll.FunctionalUnit AS UF  ON UF.Id = l.FunctionalUnitId INNER JOIN
			FixedAsset.FixedAssetItemCatalog AS cata  ON cata.id = art.ItemCatalogId LEFT OUTER JOIN
			FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb  ON padb.PhysicalAssetId = pa.id AND padb.legalbookid = '1' INNER JOIN
			Payroll.CostCenter AS cc ON cc.Id = uf.CostCenterId 
			left outer join (select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='1' and ValorizationType='1'  and tt.status='2'
								group by t.PhysicalAssetId ) as trans on trans.idactivo=pa.id	 
								left outer join 	(select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='2' and ValorizationType='0'  and tt.status='2'  
								group by t.PhysicalAssetId) as desv on desv.idactivo=pa.id	  
WHERE  (Ing.Status <> '3')  AND pa.hasoutput = '0'  AND pa.Status = '1' --and pa.Plate ='017009'

UNION ALL


SELECT  ' ' AS IdIngreso, pa.AdquisitionDate AS FAdquisición, faibi.Id AS id_activo, 
           CASE WHEN l.Code LIKE 'C%' THEN 'Faca' WHEN l.Code LIKE 'B%' THEN 'Bogota' WHEN l.Code LIKE 'F%' THEN 'Florencia' WHEN l.Code LIKE 'n%' THEN 'Neiva' WHEN l.Code LIKE 'T%' THEN 'Tunja' WHEN l.Code LIKE 'P%' THEN 'Pitalito' WHEN l.Code LIKE 'M%' THEN 'Mocoa' END AS Sucursal, 'SaldInic' + ' - ' + RTRIM(faib.Code) AS Ingreso, 
           CASE faib.status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, faibi.AdquisitionDate AS Fecha, 
           CASE faibi.AdquisitionType WHEN '1' THEN 'CompraDirecta' WHEN '3' THEN 'Comodato' WHEN '4' THEN 'Donadacion' WHEN '5' THEN 'TraspasoBienes' WHEN '6' THEN 'OtroConcepto' WHEN '7' THEN 'LeasingFinanciero' WHEN '8' THEN 'Comodato Tercerizado' WHEN '9' THEN 'Renting Financiero' when '10' then 'Renting Operativo' END AS [Tipo Adquisición], RTRIM(fai.Code) AS CodArticulo, 
           RTRIM(fai.Description) AS [Artículo], CASE substring(ta.Code, 1, 2) 
           WHEN '01' THEN 'BIOMEDICO' WHEN '02' THEN 'INDUSTRIAL' WHEN '03' THEN 'INFRAESTRUCTURA' WHEN '04' THEN 'MOBILIARIO' WHEN '05' THEN 'MUEBLES_OFICINA' WHEN '06' THEN 'COMPUTO_COMUNICACIONES' WHEN '07' THEN 'INSTRUMENTAL_BIOMEDICO' WHEN '08' THEN 'ACCESORIO_BIOMEDICO' WHEN '09' THEN 'MEDICO_HOSPITALARIO' WHEN '10' THEN 'PATRON'
            WHEN '11' THEN 'OTROS' WHEN '12' THEN 'VEHICULOS' END AS TipoInventario, faibi.Plate AS 'Placa', mar.Name AS Marca, pa.Model AS Modelo, pa.Serie, 
			--CASE faibi.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS EstadoActivo, 
			CASE pa.HasOutput WHEN 0 THEN 'Activo' WHEN 1 THEN 'Inactivo' END AS EstadoActivo,
			RTRIM(t .Nit) + ' - ' + RTRIM(t .Name) AS Responsable, 
			RTRIM(l.Code) + ' - ' + RTRIM(l.Name) AS Localizacion, 
			RTRIM(UF.Code) AS CodUF , RTRIM(UF.Name) AS UnidadFuncional, RTRIM(cc.cODE) + ' - ' + RTRIM(CC.nAME) AS CentroCosto, faibi.AdquisitionDate AS FechaFactura, 'N/A' AS Factura, RTRIM(pv.Code) + ' - ' + RTRIM(pv.Name) AS Proveedor, faibi.HistoricalValue AS VrHistorico, padb.DepreciatedValue AS VrDepreciado, 
		  
		  --case  when padb.ResidualValue is null then faibi.HistoricalValue  when padb.ResidualValue =0 then faibi.HistoricalValue  else padb.ResidualValue end AS SaldoNeto,
		   padb.ResidualValue  AS SaldoNeto,
		   'SaldoInicial' AS Origen, RTRIM(cata.Code) 
           + ' - ' + RTRIM(cata.Description) AS Catálogo, 'N/A' AS Cuenta, RTRIM(pol.Code) + ' - ' + RTRIM(pol.Name) AS Poliza, 'SaldosIniciales' AS Descripción,
		   -- case when  padb.TransactionValue is not null then padb.TransactionValue else fatd.Value end AS VrTransacciones, 
			isnull(trans.valorizacion,0)-isnull(desv.valorizacion,0)  AS VrTransacciones, 

			FAIBI.WarrantyExpirationDate AS [Fecha vencimiento garantia], padb.LifeTime AS [VidaUtil], padb.DaysPendingDepreciate AS [DiasPendDepreciar], 
           padb.DepreciatedDays AS [DiasDepreciados], l.UseTime AS [Tiempo Uso], CASE fai.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END [Deprecia Tiempo Uso], '0' AS IvaItem, pa.NumberContractLeasing AS [Contrato Leasing], pa.InitialDateLeasing[Fecha Inicial Leasing], pa.EndDateLeasing AS [Fecha Final Leasing], 
		   case when padb.Devaluation is not null then padb.Devaluation else desv.valorizacion end as Desvalorizacion, trans.valorizacion as Valorizacion
FROM    FixedAsset.FixedAssetInitialBalanceItem AS faibi  LEFT OUTER JOIN
           FixedAsset.FixedAssetInitialBalanceItemDetailBook AS faibidb  ON faibidb.FixedAssetInitialBalanceItemId = faibi.Id AND faibidb.LegalBookId = '1' INNER JOIN
           FixedAsset.FixedAssetPhysicalAsset AS pa ON faibi.Plate = pa.Plate INNER JOIN
           FixedAsset.FixedAssetInitialBalance AS faib  ON faibi.FixedAssetInitialBalanceId = faib.Id INNER JOIN
           FixedAsset.FixedAssetTrademark AS mar ON mar.Id = PA.TrademarkId INNER JOIN
           FixedAsset.FixedAssetResponsible AS res  ON res.Id = pa.ResponsibleId INNER JOIN
           Common.ThirdParty AS t  ON t .Id = res.ThirdPartyId INNER JOIN
           .FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId INNER JOIN
           Common.Supplier AS pv  ON pv.Id = faibi.SupplierId INNER JOIN
           FixedAsset.FixedAssetItem AS fai  ON faibi.ItemId = fai.Id LEFT OUTER JOIN
           FixedAsset.FixedAssetItemType AS ta  ON ta.Id = fai.ItemTypeId INNER JOIN
           Payroll.FunctionalUnit AS UF  ON UF.Id = l.FunctionalUnitId LEFT OUTER JOIN
           FixedAsset.FixedAssetPolicy AS pol  ON pol.Id = faibi.PolicyId LEFT OUTER JOIN
		   (SELECT PA.PLATE AS Placa, art.ItemCatalogId as Catalogo
				FROM    FixedAsset.FixedAssetItem AS Art  INNER JOIN
					FixedAsset.FixedAssetPhysicalAsset AS pa  ON pa.ItemId = Art.Id ) as articulo on articulo.placa=faibi.plate left outer join

           FixedAsset.FixedAssetItemCatalog AS cata  ON cata.Id = articulo.catalogo LEFT OUTER JOIN
           FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb  ON padb.PhysicalAssetId = pa.id AND padb.legalbookid = '1' INNER JOIN
            Payroll.CostCenter AS cc ON cc.Id = uf.CostCenterId
		     LEFT OUTER JOIN FixedAsset.FixedAssetTransactionDetail AS fatd  on fatd.PhysicalAssetId=pa.id and fai.Description like '%lote%'
			  left outer join (select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='1' and ValorizationType='1'  and tt.status='2'
								group by t.PhysicalAssetId) as trans on trans.idactivo=pa.id	
			left outer join 	(select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='2' and ValorizationType='0'  and tt.status='2'  
								group by t.PhysicalAssetId) as desv on desv.idactivo=pa.id	
WHERE  (faib.Status <> '3') --and   faibi.Plate ='15TL01'

UNION ALL


SELECT  Ing.id AS IdIngreso, pa.AdquisitionDate AS FAdquisición, pa.Id AS id_activo, 
           CASE WHEN l.Code LIKE 'C%' THEN 'Faca' WHEN l.Code LIKE 'B%' THEN 'Bogota' WHEN l.Code LIKE 'F%' THEN 'Florencia' WHEN l.Code LIKE 'n%' THEN 'Neiva' WHEN l.Code LIKE 'T%' THEN 'Tunja' WHEN l.Code LIKE 'P%' THEN 'Pitalito' WHEN l.Code LIKE 'M%' THEN 'Mocoa' END AS Sucursal, Ing.Code AS Ingreso, 
           CASE Ing.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado'  END AS Estado, Ing.EntryDate AS Fecha, 
           CASE Ing.AdquisitionType WHEN '1' THEN 'CompraDirecta' WHEN '3' THEN 'Comodato' WHEN '4' THEN 'Donadacion' WHEN '5' THEN 'TraspasoBienes' WHEN '6' THEN 'OtroConcepto' WHEN '7' THEN 'LeasingFinanciero' WHEN '8' THEN 'Comodato Tercerizado' WHEN '9' THEN 'Renting Financiero'  when '10' then 'Renting Operativo' END AS [Tipo Adquisición], RTRIM(Art.Code) AS CodArticulo, 
           RTRIM(Art.Description) AS [Artículo], CASE substring(tart.Code, 1, 2) 
           WHEN '01' THEN 'BIOMEDICO' WHEN '02' THEN 'INDUSTRIAL' WHEN '03' THEN 'INFRAESTRUCTURA' WHEN '04' THEN 'MOBILIARIO' WHEN '05' THEN 'MUEBLES_OFICINA' WHEN '06' THEN 'COMPUTO_COMUNICACIONES' WHEN '07' THEN 'INSTRUMENTAL_BIOMEDICO' WHEN '08' THEN 'ACCESORIO_BIOMEDICO' WHEN '09' THEN 'MEDICO_HOSPITALARIO' WHEN '10' THEN 'PATRON'
            WHEN '11' THEN 'OTROS' WHEN '12' THEN 'VEHICULOS' END AS TipoInventario, pa.Plate AS Placa, mar.Name AS Marca, pa.Model AS Modelo, pa.Serie, CASE pa.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS EstadoActivo, RTRIM(t .Nit) + ' - ' + RTRIM(t .Name) AS Responsable, 
			RTRIM(l.Code) + ' - ' + RTRIM(l.Name) AS Localizacion, 
			RTRIM(UF.Code) AS CodUF , RTRIM(UF.Name) AS UnidadFuncional, RTRIM(cc.cODE) + ' - ' + RTRIM(CC.nAME) AS CentroCosto, Ing.InvoiceDate AS FechaFactura, Ing.EntryNumber AS Factura, RTRIM(pv.Code) + ' - ' + RTRIM(pv.Name) AS Proveedor, pa.HistoricalValue AS VrHistorico, padb.DepreciatedValue AS VrDepreciado, padb.ResidualValue AS SaldoNeto, 
           CASE DIng.RemissionSource WHEN '1' THEN 'Ninguna' WHEN '2' THEN 'OrdenCompra' WHEN '3' THEN 'Remision_Entrada' END AS Origen, 
		   rtrim(cata.Code) + ' - ' + rtrim(cata.Description) AS Catálogo, RTRIM(cue.Number) + ' - ' + RTRIM(cue.Name) AS Cuenta, RTRIM(pol.Code) + ' - ' + RTRIM(pol.Name) AS Poliza, Ing.Description AS Descripción, 
		  -- padb.TransactionValue 
		  isnull(trans.valorizacion,0)-isnull(desv.valorizacion,0)  AS VrTransacciones,    
		   EID.WarrantyExpirationDate AS [Fecha vencimiento garantia], padb.LifeTime AS [VidaUtil], padb.DaysPendingDepreciate AS [DiasPendDepreciar], padb.DepreciatedDays AS [DiasDepreciados], l.UseTime AS [Tiempo Uso], CASE art.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END [Deprecia Tiempo Uso], 
           DIng.IvaValue AS IvaItem, pa.NumberContractLeasing AS [Contrato Leasing], pa.InitialDateLeasing[Fecha Inicial Leasing], pa.EndDateLeasing AS [Fecha Final Leasing],
		   case when padb.Devaluation is not null then padb.Devaluation else desv.valorizacion end as Desvalorizacion, trans.valorizacion as Valorizacion
FROM    FixedAsset.FixedAssetEntry AS Ing  INNER JOIN
           FixedAsset.FixedAssetEntryItem AS DIng  ON Ing.Id = DIng.FixedAssetEntryId AND Ing.Status <> '3' INNER JOIN
           FixedAsset.FixedAssetEntryItemDetail AS eid  ON eid.FixedAssetEntryItemId = DIng.id INNER JOIN
           FixedAsset.FixedAssetItem AS Art  ON Art.Id = DIng.ItemId INNER JOIN
           FixedAsset.FixedAssetPhysicalAsset AS pa  ON pa.ItemId = Art.Id AND pa.plate = eid.plate INNER JOIN
           FixedAsset.FixedAssetItemType AS tart  ON tart.Id = Art.ItemTypeId INNER JOIN
           Common.OperatingUnit AS uo ON uo.Id = Ing.OperatingUnitId INNER JOIN
           Common.Supplier AS pv ON pv.Id = Ing.SupplierId INNER JOIN
           FixedAsset.FixedAssetTrademark AS mar ON mar.Id = pa.TrademarkId INNER JOIN
           GeneralLedger.MainAccounts AS cue  ON cue.Id = pa.MainAccountId AND cue.LegalBookId = '1' INNER JOIN
            .FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId INNER JOIN
           FixedAsset.FixedAssetResponsible AS res ON res.Id = pa.ResponsibleId /* AND pa.AdquisitionDate > '31/12/2016 00:00:00' */ INNER JOIN
           Common.ThirdParty AS t  ON t .Id = res.ThirdPartyId LEFT OUTER JOIN
           FixedAsset.FixedAssetPolicy AS pol  ON pol.Id = pa.PolicyId INNER JOIN
           Payroll.FunctionalUnit AS UF  ON UF.Id = l.FunctionalUnitId INNER JOIN
           FixedAsset.FixedAssetItemCatalog AS cata  ON cata.id = art.ItemCatalogId LEFT OUTER JOIN
           FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb  ON padb.PhysicalAssetId = pa.id AND padb.legalbookid = '1' INNER JOIN
           Payroll.CostCenter AS cc ON cc.Id = uf.CostCenterId 
		   left outer join (select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='1' and ValorizationType='1'  and tt.status='2'
								group by t.PhysicalAssetId ) as trans on trans.idactivo=pa.id	 
								left outer join 	(select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='2' and ValorizationType='0'  and tt.status='2'  
								group by t.PhysicalAssetId) as desv on desv.idactivo=pa.id	  
WHERE  (Ing.Status <> '3') AND pa.Status = '0' AND pa.hasoutput = '1'  and Ing.AdquisitionType in ('3','8')  --and   pa.Plate  ='017009'


union all

SELECT   Ing.id AS IdIngreso, pa.AdquisitionDate AS FAdquisición, pa.Id AS id_activo, 
           CASE WHEN l.Code LIKE 'C%' THEN 'Faca' WHEN l.Code LIKE 'B%' THEN 'Bogota' WHEN l.Code LIKE 'F%' THEN 'Florencia' WHEN l.Code LIKE 'n%' THEN 'Neiva' WHEN l.Code LIKE 'T%' THEN 'Tunja' WHEN l.Code LIKE 'P%' THEN 'Pitalito' WHEN l.Code LIKE 'M%' THEN 'Mocoa' END AS Sucursal, Ing.Code AS Ingreso, 
           CASE Ing.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado'  END AS Estado, Ing.EntryDate AS Fecha, 
           CASE Ing.AdquisitionType WHEN '1' THEN 'CompraDirecta' WHEN '3' THEN 'Comodato' WHEN '4' THEN 'Donadacion' WHEN '5' THEN 'TraspasoBienes' WHEN '6' THEN 'OtroConcepto' WHEN '7' THEN 'LeasingFinanciero' WHEN '8' THEN 'Comodato Tercerizado' WHEN '9' THEN 'Renting Financiero' when '10' then 'Renting Operativo' END AS [Tipo Adquisición], RTRIM(Art.Code) AS CodArticulo, 
           RTRIM(Art.Description) AS [Artículo], CASE substring(tart.Code, 1, 2) 
           WHEN '01' THEN 'BIOMEDICO' WHEN '02' THEN 'INDUSTRIAL' WHEN '03' THEN 'INFRAESTRUCTURA' WHEN '04' THEN 'MOBILIARIO' WHEN '05' THEN 'MUEBLES_OFICINA' WHEN '06' THEN 'COMPUTO_COMUNICACIONES' WHEN '07' THEN 'INSTRUMENTAL_BIOMEDICO' WHEN '08' THEN 'ACCESORIO_BIOMEDICO' WHEN '09' THEN 'MEDICO_HOSPITALARIO' WHEN '10' THEN 'PATRON'
            WHEN '11' THEN 'OTROS' WHEN '12' THEN 'VEHICULOS' END AS TipoInventario, pa.Plate AS Placa, mar.Name AS Marca, pa.Model AS Modelo, pa.Serie, CASE pa.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS EstadoActivo, RTRIM(t .Nit) + ' - ' + RTRIM(t .Name) AS Responsable, 
			RTRIM(l.Code) + ' - ' + RTRIM(l.Name) AS Localizacion, 
			RTRIM(UF.Code) AS CodUF , RTRIM(UF.Name) AS UnidadFuncional, RTRIM(cc.cODE) + ' - ' + RTRIM(CC.nAME) AS CentroCosto, Ing.InvoiceDate AS FechaFactura, Ing.EntryNumber AS Factura, RTRIM(pv.Code) + ' - ' + RTRIM(pv.Name) AS Proveedor, pa.HistoricalValue AS VrHistorico, padb.DepreciatedValue AS VrDepreciado, padb.ResidualValue AS SaldoNeto, 
           CASE DIng.RemissionSource WHEN '1' THEN 'Ninguna' WHEN '2' THEN 'OrdenCompra' WHEN '3' THEN 'Remision_Entrada' END AS Origen, 
		   rtrim(cata.Code) + ' - ' + rtrim(cata.Description) AS Catálogo, RTRIM(cue.Number) + ' - ' + RTRIM(cue.Name) AS Cuenta, RTRIM(pol.Code) + ' - ' + RTRIM(pol.Name) AS Poliza, Ing.Description AS Descripción, 
		  -- padb.TransactionValue 
		  isnull(trans.valorizacion,0)-isnull(desv.valorizacion,0)  AS VrTransacciones,    
		   EID.WarrantyExpirationDate AS [Fecha vencimiento garantia], padb.LifeTime AS [VidaUtil], padb.DaysPendingDepreciate AS [DiasPendDepreciar], padb.DepreciatedDays AS [DiasDepreciados], l.UseTime AS [Tiempo Uso], CASE art.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END [Deprecia Tiempo Uso], 
           DIng.IvaValue AS IvaItem, pa.NumberContractLeasing AS [Contrato Leasing], pa.InitialDateLeasing[Fecha Inicial Leasing], pa.EndDateLeasing AS [Fecha Final Leasing],
		   case when padb.Devaluation is not null then padb.Devaluation else desv.valorizacion end as Desvalorizacion, trans.valorizacion as Valorizacion
FROM    FixedAsset.FixedAssetEntry AS Ing  INNER JOIN
           FixedAsset.FixedAssetEntryItem AS DIng  ON Ing.Id = DIng.FixedAssetEntryId AND Ing.Status <> '3' INNER JOIN
           FixedAsset.FixedAssetEntryItemDetail AS eid  ON eid.FixedAssetEntryItemId = DIng.id INNER JOIN
           FixedAsset.FixedAssetItem AS Art  ON Art.Id = DIng.ItemId INNER JOIN
           FixedAsset.FixedAssetPhysicalAsset AS pa  ON pa.ItemId = Art.Id AND pa.plate = eid.plate INNER JOIN
           FixedAsset.FixedAssetItemType AS tart  ON tart.Id = Art.ItemTypeId INNER JOIN
           Common.OperatingUnit AS uo ON uo.Id = Ing.OperatingUnitId INNER JOIN
           Common.Supplier AS pv ON pv.Id = Ing.SupplierId INNER JOIN
           FixedAsset.FixedAssetTrademark AS mar ON mar.Id = pa.TrademarkId INNER JOIN
           GeneralLedger.MainAccounts AS cue  ON cue.Id = pa.MainAccountId AND cue.LegalBookId = '1' INNER JOIN
           FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId INNER JOIN
           FixedAsset.FixedAssetResponsible AS res ON res.Id = pa.ResponsibleId /* AND pa.AdquisitionDate > '31/12/2016 00:00:00' */ INNER JOIN
           Common.ThirdParty AS t  ON t .Id = res.ThirdPartyId LEFT OUTER JOIN
           FixedAsset.FixedAssetPolicy AS pol  ON pol.Id = pa.PolicyId INNER JOIN
           Payroll.FunctionalUnit AS UF  ON UF.Id = l.FunctionalUnitId INNER JOIN
           FixedAsset.FixedAssetItemCatalog AS cata  ON cata.id = art.ItemCatalogId LEFT OUTER JOIN
           FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb  ON padb.PhysicalAssetId = pa.id AND padb.legalbookid = '1' INNER JOIN
            .Payroll.CostCenter AS cc ON cc.Id = uf.CostCenterId 
		   left outer join (select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='1' and ValorizationType='1'  and tt.status='2'
								group by t.PhysicalAssetId ) as trans on trans.idactivo=pa.id	 
								left outer join 	(select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='2' and ValorizationType='0'  and tt.status='2'  
								group by t.PhysicalAssetId) as desv on desv.idactivo=pa.id	  
WHERE  (Ing.Status <> '3') AND pa.Status = '1' AND pa.hasoutput = '1'  and Ing.AdquisitionType in ('3','8') --and   pa.Plate  ='017009'

union all

select 0 AS IdIngreso, pa.AdquisitionDate AS FAdquisición, pa.Id AS id_activo, 
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
			RTRIM(UF.Code) AS CodUF , RTRIM(UF.Name) AS UnidadFuncional, RTRIM(cc.cODE) + ' - ' + RTRIM(CC.nAME) AS CentroCosto,
			'' AS FechaFactura, '' AS Factura, '' AS Proveedor, pa.HistoricalValue AS VrHistorico, padb.DepreciatedValue AS VrDepreciado, padb.ResidualValue AS SaldoNeto, 
			'' AS Origen, 
			rtrim(cata.Code) + ' - ' + rtrim(cata.Description) AS Catálogo, RTRIM(cue.Number) + ' - ' + RTRIM(cue.Name) AS Cuenta, RTRIM(pol.Code) + ' - ' + RTRIM(pol.Name) AS Poliza, '0' AS Descripción, 
          
			-- padb.TransactionValue 
		  
			isnull(trans.valorizacion,0)-isnull(desv.valorizacion,0)   AS VrTransacciones, 
		   
			'' AS [Fecha vencimiento garantia], padb.LifeTime AS [VidaUtil], padb.DaysPendingDepreciate AS [DiasPendDepreciar], padb.DepreciatedDays AS [DiasDepreciados], l.UseTime AS [Tiempo Uso], CASE art.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END [Deprecia Tiempo Uso], 
			0 AS IvaItem, pa.NumberContractLeasing AS [Contrato Leasing], pa.InitialDateLeasing[Fecha Inicial Leasing], pa.EndDateLeasing AS [Fecha Final Leasing],
			case when padb.Devaluation is not null then padb.Devaluation else desv.valorizacion end as Desvalorizacion, trans.valorizacion as Valorizacion
from FixedAsset.FixedAssetPhysicalAsset AS pa INNER JOIN
FixedAsset.FixedAssetItem AS Art  ON pa.ItemId = Art.Id INNER JOIN
FixedAsset.FixedAssetItemType AS tart  ON tart.Id = Art.ItemTypeId INNER JOIN
			--Common.OperatingUnit AS uo ON uo.Id = Ing.OperatingUnitId INNER JOIN
			--Common.Supplier AS pv ON pv.Id = Ing.SupplierId INNER JOIN
			FixedAsset.FixedAssetTrademark AS mar ON mar.Id = pa.TrademarkId INNER JOIN
			GeneralLedger.MainAccounts AS cue  ON cue.Id = pa.MainAccountId AND cue.LegalBookId = '1' INNER JOIN
			.FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId INNER JOIN
			FixedAsset.FixedAssetResponsible AS res ON res.Id = pa.ResponsibleId /* AND pa.AdquisitionDate > '31/12/2016 00:00:00' */ INNER JOIN
			Common.ThirdParty AS t  ON t .Id = res.ThirdPartyId LEFT OUTER JOIN
			FixedAsset.FixedAssetPolicy AS pol  ON pol.Id = pa.PolicyId INNER JOIN
			Payroll.FunctionalUnit AS UF  ON UF.Id = l.FunctionalUnitId INNER JOIN
			FixedAsset.FixedAssetItemCatalog AS cata  ON cata.id = art.ItemCatalogId LEFT OUTER JOIN
			FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb  ON padb.PhysicalAssetId = pa.id AND padb.legalbookid = '1' INNER JOIN
			Payroll.CostCenter AS cc ON cc.Id = uf.CostCenterId 
			left outer join (select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='1' and ValorizationType='1'  and tt.status='2'
								group by t.PhysicalAssetId ) as trans on trans.idactivo=pa.id	 
								left outer join 	(select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='2' and ValorizationType='0'  and tt.status='2'  
								group by t.PhysicalAssetId) as desv on desv.idactivo=pa.id	  
where pa.Status = '1' AND pa.hasoutput = '0'  and pa.plate not in (select plate
												from FixedAsset.FixedAssetEntryItemDetail)
						 and pa.plate not in (select plate
												from FixedAsset.FixedAssetInitialBalanceItem AS faibi  LEFT OUTER JOIN
													 FixedAsset.FixedAssetInitialBalanceItemDetailBook AS faibidb  ON faibidb.FixedAssetInitialBalanceItemId = faibi.Id AND faibidb.LegalBookId = '1' 
													 )

