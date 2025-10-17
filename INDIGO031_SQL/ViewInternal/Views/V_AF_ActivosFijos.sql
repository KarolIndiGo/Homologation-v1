-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_AF_ActivosFijos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[V_AF_ActivosFijos]
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
            CONVERT(MONEY, A.LastCostItem, 101) AS UltimoCosto,
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
            CONVERT(MONEY, AF.HistoricalValue, 101) AS [Valor Historico], 
            CONVERT(MONEY, AF.FairValue, 101) AS [Valor Razonable],
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
            CONVERT(MONEY, L.DepreciatedValue, 101) AS VlrDepreciado, 
            L.DaysPendingDepreciate AS DiasPendientes, 
            CONVERT(MONEY, L.ResidualValue, 101) AS VlrPendiente,
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
     FROM FixedAsset.FixedAssetPhysicalAsset AS AF
          INNER JOIN FixedAsset.FixedAssetItem AS A ON AF.ItemId = A.Id
          LEFT JOIN FixedAsset.FixedAssetPhysicalAssetDetailBook AS L ON L.PhysicalAssetId = AF.Id
                                                                                           AND L.LegalBookId = 2
          INNER JOIN FixedAsset.FixedAssetItemType AS TA ON A.ItemTypeId = TA.Id
          LEFT OUTER JOIN FixedAsset.FixedAssetLocation AS LO ON AF.LocationId = LO.Id
          INNER JOIN FixedAsset.FixedAssetResponsible AS RE ON AF.ResponsibleId = RE.Id
          INNER JOIN Common.ThirdParty AS TER ON RE.ThirdPartyId = TER.Id
          LEFT OUTER JOIN FixedAsset.FixedAssetActiveOutputDetail AS OU ON OU.PhysicalAssetId = AF.Id
          INNER JOIN FixedAsset.FixedAssetTrademark AS MK ON AF.TrademarkId = MK.Id
          LEFT OUTER JOIN Common.Supplier AS PRO ON AF.SupplierId = PRO.Id
          LEFT OUTER JOIN Payroll.Employee AS EM ON RE.ThirdPartyId = EM.ThirdPartyId
          LEFT OUTER JOIN
     (
         SELECT MAX(Id) AS Id, 
                EmployeeId, 
                PositionId
         FROM Payroll.Contract
         WHERE(STATUS = 1)
         GROUP BY EmployeeId, 
                  PositionId
     ) AS CONT ON CONT.EmployeeId = EM.Id
          LEFT OUTER JOIN Payroll.Position AS CAR ON CONT.PositionId = CAR.Id
          INNER JOIN FixedAsset.FixedAssetItemCatalog AS CUC ON CUC.Id = A.ItemCatalogId
          INNER JOIN GeneralLedger.MainAccounts AS MAI ON MAI.Id = CUC.IncomeAccountId;

--select * from  FixedAsset.FixedAssetItem
--select * from FixedAsset.FixedAssetPhysicalAsset 
--select * from FixedAsset.FixedAssetPhysicalAssetDetailBook
