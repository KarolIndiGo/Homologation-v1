-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_INN_Activos_Fijos_Saldos_Iniciales
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_INN_Activos_Fijos_Saldos_Iniciales]
AS
SELECT fib.Code
          AS [Codigo],
       fib.DocumentDate
          AS [Fecha del Documento],
       CASE fib.Status
          WHEN '1' THEN 'Sin Confimar'
          WHEN '2' THEN 'Confirmado'
          WHEN '3' THEN 'Anulado'
       END
          AS [Estado],
       fibi.Id
          AS [id Activo],
       fi.Code
          AS [Codigo Item],
       fi.[Description]
          AS [Item],
       CASE fit.ParentId
          WHEN 1 THEN 'MOBILIARIO'
          WHEN 2 THEN 'MUEBLES DE OFICINA'
          WHEN 3 THEN 'COMPUTO Y COMUNICACION'
          WHEN 4 THEN 'INDUSTRIAL'
          WHEN 5 THEN 'EQUIPO MEDICO CIENTIFICO'
       END
          AS [Tipo  Inventario],
       (SELECT name
        FROM FixedAsset.FixedAssetTrademark
        WHERE FixedAsset.FixedAssetTrademark.id = fibi.TrademarkId)
          AS [Marca],
       fibi.Model
          AS [Modelo],
       fibi.Serie
          AS [# De Serie],
       fibi.Plate
          AS [# De Placa],
       fibi.AdquisitionDate
          AS [Fecha Adquisicion],
       CASE fibi.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END
          AS [Estado Activo],
       CASE fibi.AdquisitionType
          WHEN '1' THEN 'CompraDirecta'
          WHEN '3' THEN 'Comodato'
          WHEN '4' THEN 'Donadacion'
          WHEN '5' THEN 'TraspasoBienes'
          WHEN '6' THEN 'OtroConcepto'
          WHEN '7' THEN 'LeasingFinanciero'
          WHEN '8' THEN 'Comodato Tercerizado'
          WHEN '9' THEN 'Renting Financiero'
       END
          AS [Tipo Adquisición],
       fl.Code
          [Codigo Localizacion],
       fl.[Name]
          AS [Localizacion],
       (SELECT nit
        FROM Common.ThirdParty
        WHERE Common.ThirdParty.Id = fr.ThirdPartyId)
          AS [Identificacion Responsable],
       (SELECT name
        FROM Common.ThirdParty
        WHERE Common.ThirdParty.Id = fr.ThirdPartyId)
          AS [Responsable],
       RTRIM (fu.Code) + ' - ' + RTRIM (fu.Name)
          AS [Unidad Funcional],
       RTRIM (cc.cODE) + ' - ' + RTRIM (cc.nAME)
          AS [Centro De Costo],
       RTRIM (sup.Code) + ' - ' + RTRIM (sup.Name)
          AS [Proveedor],
       fibi.HistoricalValue
          AS [Valor Historico],
       fpad.DepreciatedValue
          AS [Valor Depreciado],
       fpad.ResidualValue
          AS [Saldo Neto],
       'Saldo Inicial'
          AS [Modulo],
       RTRIM (fac.Code) + ' - ' + RTRIM (fac.Description)
          AS Catálogo,
       PER.Fullname
          AS [Usuario Creación],
       PER1.Fullname
          AS [Usuario Confirmación]
FROM FixedAsset.FixedAssetInitialBalance fib
     INNER JOIN FixedAsset.FixedAssetInitialBalanceItem fibi
        ON fib.Id = fibi.FixedAssetInitialBalanceId
     INNER JOIN FixedAsset.FixedAssetItem fi ON fi.Id = fibi.ItemId
     INNER JOIN FixedAsset.FixedAssetItemType fit ON fit.Id = fi.ItemTypeId
     INNER JOIN FixedAsset.FixedAssetLocation fl ON fl.Id = fibi.LocationId
     INNER JOIN Payroll.FunctionalUnit fu ON fu.id = fl.FunctionalUnitId
     INNER JOIN Payroll.CostCenter cc ON cc.Id = fu.CostCenterId
     INNER JOIN Common.Supplier sup ON sup.Id = fibi.SupplierId
     INNER JOIN FixedAsset.FixedAssetResponsible fr
        ON fr.Id = fibi.ResponsibleId
     INNER JOIN FixedAsset.FixedAssetInitialBalanceItemDetailBook fpad
        ON fpad.FixedAssetInitialBalanceItemId =
           fibi.Id
     INNER JOIN FixedAsset.FixedAssetItemCatalog fac
        ON fac.Id = fi.ItemCatalogId
     LEFT JOIN [Security].[Person] PER
        ON fib.CreationUser = PER.Identification
     LEFT JOIN [Security].[Person] PER1
        ON fib.ConfirmationUser = PER1.Identification
