-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_AF_ACTIVOSFIJOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VW_V_AF_ACTIVOSFIJOS]
AS
     SELECT A.Code + ' - ' + A.Description AS Activo, 
            TA.Name AS Tipo, 
            AF.Serie, 
            AF.Plate AS Placa, 
            AF.Model AS Modelo, 
            MK.Name AS Marca, 
            PRO.Name AS Proveedor, 
            CONVERT(VARCHAR(3), L.LifeTime, 101) + ' - ' + CASE L.UnitLifeTime
                                                               WHEN 1
                                                               THEN 'Años'
                                                               WHEN 2
                                                               THEN 'Meses'
                                                               WHEN 3
                                                               THEN 'Dias'
                                                           END AS VidaUtil, 
            LO.Name AS Ubicacion,
            CASE
                WHEN LO.Code LIKE 'B%'
                THEN 'Bogota'
                WHEN LO.Code LIKE 'C%'
                THEN 'Cali'
            END AS Sede, 
            CONVERT(VARCHAR(12), TER.Nit, 100) + ' - ' + TER.Name AS Responsable, 
            CAR.Name AS Cargo, 
            CONVERT(DECIMAL(19,4), A.LastCostItem, 101) AS UltimoCosto,
            CASE AF.AdquisitionType
                WHEN 1
                THEN 'Compra Directa'
                WHEN 3
                THEN 'Comodato'
                WHEN 4
                THEN 'Donadacion'
                WHEN 5
                THEN 'Traspaso de Bienes'
                WHEN 6
                THEN 'Otro Concepto'
                WHEN 7
                THEN 'Leasing Financiero'
            END AS [Tipo Compra], 
            CONVERT(DECIMAL(19,4), AF.HistoricalValue, 101) AS [Valor Historico], 
            CONVERT(DECIMAL(19,4), AF.FairValue, 101) AS [Valor Razonable],
            CASE AF.HandlesWarranty
                WHEN 1
                THEN 'SI'
                WHEN 0
                THEN 'NO'
            END AS [Maneja Garantia], 
            AF.WarrantyExpirationDate AS [Fecha Vencimiento Garantia], 
            AF.AdquisitionDate AS [Fecha Compra], 
            AF.InstallationDate AS [Fecha Instalación], 
            AF.NumberContractLeasing AS [#ContraLeasing], 
            AF.InitialDateLeasing AS [Fecha Inicio Leasing], 
            AF.EndDateLeasing AS [Fecha Final Leasing],
            CASE AF.Depreciate
                WHEN 1
                THEN 'SI'
                WHEN 0
                THEN 'NO'
            END AS Deprecia,
            CASE L.DepreciationType
                WHEN 1
                THEN 'Linea Recta'
                WHEN 2
                THEN 'Suma Digitos'
                WHEN 3
                THEN 'ReduccionSaldos'
                WHEN 4
                THEN 'UnidadesProduccion'
            END AS Metodo, 
            L.DepreciatedDays AS DiasDepreciados, 
            CONVERT(DECIMAL(19,4), L.DepreciatedValue, 101) AS VlrDepreciado, 
            L.DaysPendingDepreciate AS DiasPendientes, 
            CONVERT(DECIMAL(19,4), L.ResidualValue, 101) AS VlrPendiente,
            CASE AF.HasOutput
                WHEN 0
                THEN 'NO'
                WHEN 1
                THEN 'SI'
            END AS [Tiene Salida], 
            AF.OutputDate AS [Fecha Salida],
            CASE OU.OutputType
                WHEN 1
                THEN 'Baja'
                WHEN 2
                THEN 'Venta'
            END AS TipoSalida,
            CASE OU.LowType
                WHEN 0
                THEN 'No Aplica'
                WHEN 1
                THEN 'Perdida'
                WHEN 2
                THEN 'Siniestro'
                WHEN 3
                THEN 'Perdida Reposicion'
                WHEN 4
                THEN 'Bienes Inservibles'
            END AS TipoBaja,
            CASE AF.OutputRefund
                WHEN 1
                THEN 'SI'
                WHEN 0
                THEN 'NO'
            END AS SalidaXDevolución,
            CASE AF.HasOutput
                WHEN 0
                THEN 'Activo'
                WHEN 1
                THEN 'Inactivo'
            END AS Estado, 
            MAI.Number AS [CODIGO CUENTA], 
            MAI.Name AS CUENTA
     FROM INDIGO031.FixedAsset.FixedAssetPhysicalAsset AS AF
          INNER JOIN INDIGO031.FixedAsset.FixedAssetItem AS A ON AF.ItemId = A.Id
          LEFT JOIN INDIGO031.FixedAsset.FixedAssetPhysicalAssetDetailBook AS L ON L.PhysicalAssetId = AF.Id
                                                                                           AND L.LegalBookId = 2
          INNER JOIN INDIGO031.FixedAsset.FixedAssetItemType AS TA ON A.ItemTypeId = TA.Id
          LEFT OUTER JOIN INDIGO031.FixedAsset.FixedAssetLocation AS LO ON AF.LocationId = LO.Id
          INNER JOIN INDIGO031.FixedAsset.FixedAssetResponsible AS RE ON AF.ResponsibleId = RE.Id
          INNER JOIN INDIGO031.Common.ThirdParty AS TER ON RE.ThirdPartyId = TER.Id
          LEFT OUTER JOIN INDIGO031.FixedAsset.FixedAssetActiveOutputDetail AS OU ON OU.PhysicalAssetId = AF.Id
          INNER JOIN INDIGO031.FixedAsset.FixedAssetTrademark AS MK ON AF.TrademarkId = MK.Id
          LEFT OUTER JOIN INDIGO031.Common.Supplier AS PRO ON AF.SupplierId = PRO.Id
          LEFT OUTER JOIN INDIGO031.Payroll.Employee AS EM ON RE.ThirdPartyId = EM.ThirdPartyId
          LEFT OUTER JOIN
     (
         SELECT MAX(Id) AS Id, 
                EmployeeId, 
                PositionId
         FROM INDIGO031.Payroll.Contract
         WHERE(Status = 1)
         GROUP BY EmployeeId, 
                  PositionId
     ) AS CONT ON CONT.EmployeeId = EM.Id
          LEFT OUTER JOIN INDIGO031.Payroll.Position AS CAR ON CONT.PositionId = CAR.Id
          INNER JOIN INDIGO031.FixedAsset.FixedAssetItemCatalog AS CUC ON CUC.Id = A.ItemCatalogId
          INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS MAI ON MAI.Id = CUC.IncomeAccountId;

--select * from  FixedAsset.FixedAssetItem
--select * from FixedAsset.FixedAssetPhysicalAsset 
--select * from FixedAsset.FixedAssetPhysicalAssetDetailBook
