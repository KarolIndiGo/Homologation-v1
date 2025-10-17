-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_AF_ActivosFijos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_AF_ActivosFijos]
AS


SELECT DISTINCT pa.AdquisitionDate
          AS FAdquisición,
       pa.Id
          AS id_activo,
		
       CASE
          WHEN l.Code LIKE 'C%' THEN 'Facatativa'
          WHEN l.Code LIKE 'B%' THEN 'Bogota'
          WHEN l.Code LIKE 'F%' THEN 'Florencia'
          WHEN l.Code LIKE 'n%' THEN 'Neiva'
          WHEN l.Code LIKE 'T%' THEN 'Tunja'
          WHEN l.Code LIKE 'P%' THEN 'Pitalito'
          WHEN l.Code LIKE 'M%' THEN 'Mocoa'
		  WHEN l.Code LIKE 'V%' THEN 'Villavicencio'
       END
          AS Sucursal,
       Ing.Code
          AS Ingreso,
       CASE Ing.Status
          WHEN '1' THEN 'Registrado'
          WHEN '2' THEN 'Confirmado'
       END
          AS Estado,
       Ing.EntryDate
          AS Fecha,
       CASE Ing.AdquisitionType
          WHEN '1' THEN 'CompraDirecta'
          WHEN '3' THEN 'Comodato'
          WHEN '4' THEN 'Donadacion'
          WHEN '5' THEN 'TraspasoBienes'
          WHEN '6' THEN 'OtroConcepto'
          WHEN '7' THEN 'LeasingFinanciero'
          WHEN '8' THEN 'Comodato Tercerizado'
          WHEN '9' THEN 'Renting Financiero'
		  when '10' then 'Renting Operativo'
       END
          AS [Tipo Adquisición],
       RTRIM (Art.Code)
          AS CodArticulo,
       RTRIM (Art.Description)
          AS [Artículo],
	
       CASE substring (tart.Code, 1, 2)
          WHEN '01' THEN 'MOBILIARIO'
          WHEN '02' THEN 'MUEBLES DE OFICINA'
          WHEN '03' THEN 'COMPUTO Y COMUNICACION'
          WHEN '04' THEN 'INDUSTRIAL'
		  WHEN '05' THEN 'MUEBLES_OFICINA'
          WHEN '06' THEN 'EQUIPO MEDICO - CIENTIFICO'
       END
          AS TipoInventario,
       pa.Plate
          AS Placa,
       mar.Name
          AS Marca,
       pa.Model
          AS Modelo,
       pa.Serie,
       CASE pa.HasOutput WHEN '0' THEN 'Activo' WHEN '1' THEN 'Inactivo' END
          AS EstadoActivo,
       RTRIM (t.Nit)
          AS [Ced Responsable],
       RTRIM (t.Name)
          AS Responsable,
       RTRIM (l.Code)
          AS [Cod Localizacion],
       RTRIM (l.Name)
          AS Localizacion,
       RTRIM (UF.Code) + ' - ' + RTRIM (UF.Name)
          AS UnidadFuncional,
       RTRIM (cc.cODE) + ' - ' + RTRIM (CC.nAME)
          AS CentroCosto,
       Ing.InvoiceDate
          AS FechaFactura,
       Ing.EntryNumber
          AS Factura,
       RTRIM (pv.Code) + ' - ' + RTRIM (pv.Name)
          AS Proveedor,
       pa.HistoricalValue
          AS VrHistorico,
		  padb.TransactionValue
          AS VrTransacciones,
       padb.DepreciatedValue
          AS VrDepreciado,
       padb.ResidualValue
          AS SaldoNeto,
       CASE DIng.RemissionSource
          WHEN '1' THEN 'Ninguna'
          WHEN '2' THEN 'OrdenCompra'
          WHEN '3' THEN 'Remision_Entrada'
       END
          AS Origen,
       rtrim (cata.Code) + ' - ' + rtrim (cata.Description)
          AS Catálogo,
       RTRIM (cue.Number) + ' - ' + RTRIM (cue.Name)
          AS Cuenta,
       RTRIM (pol.Code) + ' - ' + RTRIM (pol.Name)
          AS Poliza,
       Ing.Description
          AS Descripción,
       
       EID.WarrantyExpirationDate
          AS [Fecha vencimiento garantia],
       padb.LifeTime
          AS [VidaUtil],
       padb.DaysPendingDepreciate
          AS [DiasPendDepreciar],
       padb.DepreciatedDays
          AS [DiasDepreciados],
       l.UseTime
          AS [Tiempo Uso],
       CASE art.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END
          [Deprecia Tiempo Uso],
       DIng.IvaValue
          AS IvaItem,
       pa.NumberContractLeasing
          AS [Contrato Leasing],
       pa.InitialDateLeasing
          [Fecha Inicial Leasing],
       pa.EndDateLeasing
          AS [Fecha Final Leasing],
       CASE pa.HasOutput WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END
          AS [Tiene Salida],
       pa.OutputDate
          AS [Fecha Salida],
       CASE OU.OutputType WHEN 1 THEN 'Baja' WHEN 2 THEN 'Venta' END
          AS TipoSalida,
       CASE OU.LowType
          WHEN 0 THEN 'No Aplica'
          WHEN 1 THEN 'Perdida'
          WHEN 2 THEN 'Siniestro'
          WHEN 3 THEN 'Perdida Reposicion'
          WHEN 4 THEN 'Bienes Inservibles'
       END
          AS TipoBaja,
       CASE pa.OutputRefund WHEN 1 THEN 'SI' WHEN 0 THEN 'NO' END
          AS SalidaXDevolución
FROM FixedAsset.FixedAssetEntry AS Ing 
     INNER JOIN FixedAsset.FixedAssetEntryItem AS DIng 
        ON Ing.Id = DIng.FixedAssetEntryId AND Ing.Status <> '3'
     INNER JOIN FixedAsset.FixedAssetEntryItemDetail AS eid
        ON eid.FixedAssetEntryItemId = DIng.id
     INNER JOIN FixedAsset.FixedAssetItem AS Art 
        ON Art.Id = DIng.ItemId
     INNER JOIN FixedAsset.FixedAssetPhysicalAsset AS pa 
        ON pa.ItemId = Art.Id AND pa.plate = eid.plate
     INNER JOIN FixedAsset.FixedAssetItemType AS tart 
        ON tart.Id = Art.ItemTypeId
     INNER JOIN Common.OperatingUnit AS uo
        ON uo.Id = Ing.OperatingUnitId
     INNER JOIN Common.Supplier AS pv ON pv.Id = Ing.SupplierId
     INNER JOIN FixedAsset.FixedAssetTrademark AS mar
        ON mar.Id = pa.TrademarkId
     INNER JOIN GeneralLedger.MainAccounts AS cue 
        ON cue.Id = pa.MainAccountId AND cue.LegalBookId = '1'
     INNER JOIN FixedAsset.FixedAssetLocation AS l 
        ON l.Id = pa.LocationId
     INNER JOIN FixedAsset.FixedAssetResponsible AS res
        ON res.Id = pa.ResponsibleId /* AND pa.AdquisitionDate > '31/12/2016 00:00:00' */
     INNER JOIN Common.ThirdParty AS t 
        ON t.Id = res.ThirdPartyId
     LEFT OUTER JOIN FixedAsset.FixedAssetActiveOutputDetail AS OU
        ON OU.PhysicalAssetId = pa.Id
     LEFT OUTER JOIN FixedAsset.FixedAssetPolicy AS pol 
        ON pol.Id = pa.PolicyId
     INNER JOIN Payroll.FunctionalUnit AS UF 
        ON UF.Id = l.FunctionalUnitId
     INNER JOIN FixedAsset.FixedAssetItemCatalog AS cata 
        ON cata.id = art.ItemCatalogId
     LEFT OUTER JOIN
     FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb 
        ON padb.PhysicalAssetId = pa.id AND padb.legalbookid = '1'
     INNER JOIN Payroll.CostCenter AS cc ON cc.Id = uf.CostCenterId
--WHERE  (Ing.Status <> '3') AND pa.Status = '1' AND pa.hasoutput = '0'
UNION ALL
SELECT DISTINCT pa.AdquisitionDate
          AS FAdquisición,
       faibi.Id
          AS id_activo,
		  
       CASE
          WHEN l.Code LIKE 'C%' THEN 'Facatativa'
          WHEN l.Code LIKE 'B%' THEN 'Bogota'
          WHEN l.Code LIKE 'F%' THEN 'Florencia'
          WHEN l.Code LIKE 'n%' THEN 'Neiva'
          WHEN l.Code LIKE 'T%' THEN 'Tunja'
          WHEN l.Code LIKE 'P%' THEN 'Pitalito'
          WHEN l.Code LIKE 'M%' THEN 'Mocoa'
		  WHEN l.Code LIKE 'V%' THEN 'Villavicencio'
       END
          AS Sucursal,
       'SaldInic' + ' - ' + RTRIM (faib.Code)
          AS Ingreso,
       CASE faib.status
          WHEN '1' THEN 'Registrado'
          WHEN '2' THEN 'Confirmado'
          WHEN '3' THEN 'Anulado'
       END
          AS Estado,
       faibi.AdquisitionDate
          AS Fecha,
       CASE faibi.AdquisitionType
          WHEN '1' THEN 'CompraDirecta'
          WHEN '3' THEN 'Comodato'
          WHEN '4' THEN 'Donadacion'
          WHEN '5' THEN 'TraspasoBienes'
          WHEN '6' THEN 'OtroConcepto'
          WHEN '7' THEN 'LeasingFinanciero'
          WHEN '8' THEN 'Comodato Tercerizado'
          WHEN '9' THEN 'Renting Financiero'
		  when '10' then 'Renting Operativo'
       END
          AS [Tipo Adquisición],
       RTRIM (fai.Code)
          AS CodArticulo,
       RTRIM (fai.Description)
          AS [Artículo],
       CASE substring (ta.Code, 1, 2)
          WHEN '01' THEN 'MOBILIARIO'
          WHEN '02' THEN 'MUEBLES DE OFICINA'
          WHEN '03' THEN 'COMPUTO Y COMUNICACION'
          WHEN '04' THEN 'INDUSTRIAL'
		  WHEN '05' THEN 'MUEBLES_OFICINA'
          WHEN '06' THEN 'EQUIPO MEDICO - CIENTIFICO'
       END
          AS TipoInventario,
       faibi.Plate
          AS 'Placa',
       mar.Name
          AS Marca,
       pa.Model
          AS Modelo,
       pa.Serie,
       CASE pa.HasOutput WHEN '0' THEN 'Activo' WHEN '1' THEN 'Inactivo' END
          AS EstadoActivo,
       RTRIM (t.Nit)
          AS [Ced Responsable],
       RTRIM (t.Name)
          AS Responsable,
       RTRIM (l.Code)
          AS [Cod Localizacion],
       RTRIM (l.Name)
          AS Localizacion,
       RTRIM (UF.Code) + ' - ' + RTRIM (UF.Name)
          AS UnidadFuncional,
       RTRIM (cc.cODE) + ' - ' + RTRIM (CC.nAME)
          AS CentroCosto,
       faibi.AdquisitionDate
          AS FechaFactura,
       'N/A'
          AS Factura,
       RTRIM (pv.Code) + ' - ' + RTRIM (pv.Name)
          AS Proveedor,
       faibi.HistoricalValue
          AS VrHistorico,
		  padb.TransactionValue
          AS VrTransacciones,
       padb.DepreciatedValue
          AS VrDepreciado,
       --case  when padb.ResidualValue is null then faibi.HistoricalValue  when padb.ResidualValue =0 then faibi.HistoricalValue  else padb.ResidualValue end AS SaldoNeto,
       padb.ResidualValue
          AS SaldoNeto,
       'SaldoInicial'
          AS Origen,
       RTRIM (cata.Code) + ' - ' + RTRIM (cata.Description)
          AS Catálogo,
       'N/A'
          AS Cuenta,
       RTRIM (pol.Code) + ' - ' + RTRIM (pol.Name)
          AS Poliza,
       'SaldosIniciales'
          AS Descripción,
       
       FAIBI.WarrantyExpirationDate
          AS [Fecha vencimiento garantia],
       padb.LifeTime
          AS [VidaUtil],
       padb.DaysPendingDepreciate
          AS [DiasPendDepreciar],
       padb.DepreciatedDays
          AS [DiasDepreciados],
       l.UseTime
          AS [Tiempo Uso],
       CASE fai.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END
          [Deprecia Tiempo Uso],
       '0'
          AS IvaItem,
       pa.NumberContractLeasing
          AS [Contrato Leasing],
       pa.InitialDateLeasing
          [Fecha Inicial Leasing],
       pa.EndDateLeasing
          AS [Fecha Final Leasing],
       CASE pa.HasOutput WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END
          AS [Tiene Salida],
       pa.OutputDate
          AS [Fecha Salida],
       CASE OU.OutputType WHEN 1 THEN 'Baja' WHEN 2 THEN 'Venta' END
          AS TipoSalida,
       CASE OU.LowType
          WHEN 0 THEN 'No Aplica'
          WHEN 1 THEN 'Perdida'
          WHEN 2 THEN 'Siniestro'
          WHEN 3 THEN 'Perdida Reposicion'
          WHEN 4 THEN 'Bienes Inservibles'
       END
          AS TipoBaja,
       CASE pa.OutputRefund WHEN 1 THEN 'SI' WHEN 0 THEN 'NO' END
          AS SalidaXDevolución
FROM FixedAsset.FixedAssetInitialBalanceItem AS faibi 
     LEFT OUTER JOIN
     FixedAsset.FixedAssetInitialBalanceItemDetailBook AS faibidb
     
        ON     faibidb.FixedAssetInitialBalanceItemId = faibi.Id
           AND faibidb.LegalBookId = '1'
     INNER JOIN FixedAsset.FixedAssetPhysicalAsset AS pa
        ON faibi.Plate = pa.Plate
     INNER JOIN
     FixedAsset.FixedAssetInitialBalance AS faib 
        ON faibi.FixedAssetInitialBalanceId = faib.Id
     INNER JOIN FixedAsset.FixedAssetTrademark AS mar
        ON mar.Id = PA.TrademarkId
     LEFT OUTER JOIN FixedAsset.FixedAssetActiveOutputDetail AS OU
        ON OU.PhysicalAssetId = pa.Id
     INNER JOIN FixedAsset.FixedAssetResponsible AS res 
        ON res.Id = pa.ResponsibleId
     INNER JOIN Common.ThirdParty AS t 
        ON t.Id = res.ThirdPartyId
     INNER JOIN FixedAsset.FixedAssetLocation AS l 
        ON l.Id = pa.LocationId
     INNER JOIN Common.Supplier AS pv 
        ON pv.Id = faibi.SupplierId
     INNER JOIN FixedAsset.FixedAssetItem AS fai 
        ON faibi.ItemId = fai.Id
     LEFT OUTER JOIN FixedAsset.FixedAssetItemType AS ta 
        ON ta.Id = fai.ItemTypeId
     INNER JOIN Payroll.FunctionalUnit AS UF 
        ON UF.Id = l.FunctionalUnitId
     LEFT OUTER JOIN FixedAsset.FixedAssetPolicy AS pol 
        ON pol.Id = faibi.PolicyId
     INNER JOIN FixedAsset.FixedAssetItemCatalog AS cata 
        ON cata.Id = fai.ItemCatalogId
     LEFT OUTER JOIN
     FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb 
        ON padb.PhysicalAssetId = pa.id AND padb.legalbookid = '1'
     INNER JOIN Payroll.CostCenter AS cc ON cc.Id = uf.CostCenterId
