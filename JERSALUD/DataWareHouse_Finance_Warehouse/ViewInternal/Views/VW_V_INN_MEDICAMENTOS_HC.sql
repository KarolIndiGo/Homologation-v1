-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_MEDICAMENTOS_HC
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_MEDICAMENTOS_HC AS

SELECT M.Code, 
            M.Name AS Medicamento, 
            DCI.Code AS CodDCI, 
            DCI.Name AS DCI, 
            ATC.Code AS CodATC, 
            ATC.Name AS ATC, 
            M.Presentations AS Presentacion, 
            '' AS Forma, 
            V.Name AS Via, 
            G.Name AS GrupoFarmaco, 
            M.Concentration,
            CASE M.FormulationType
                WHEN 1
                THEN 'Peso'
                WHEN 2
                THEN 'Volumnen'
                WHEN 3
                THEN 'Peso/Volumen'
                WHEN 4
                THEN 'Unidad'
            END AS TipoFormulacion, 
            Volumen = CONVERT(CHAR(12), M.Volume) + ' ' + CONVERT(CHAR(12), U.[Name]), 
            Peso = CONVERT(CHAR(12), M.[Weight]) + ' ' + CONVERT(CHAR(12), U1.[Name]), 
            U2.[Name] AS Unidad,
            CASE M.AutomaticCalculation
                WHEN 1
                THEN 'SI'
                WHEN 0
                THEN 'NO'
            END AS Calculo, 
            'Vie' AS Indigo
     FROM INDIGO031.Inventory.ATC M
          JOIN INDIGO031.Inventory.AdministrationRoute V ON M.AdministrationRouteId = V.Id
                                                                    AND M.Status = 1
          JOIN INDIGO031.Inventory.PharmacologicalGroup G ON M.PharmacologicalGroupId = G.Id
          LEFT JOIN INDIGO031.Inventory.InventoryMeasurementUnit U ON M.VolumeMeasureUnit = U.Id
          LEFT JOIN INDIGO031.Inventory.InventoryMeasurementUnit U1 ON M.WeightMeasureUnit = U1.Id
          LEFT JOIN INDIGO031.Inventory.InventoryMeasurementUnit U2 ON M.AdministrationUnitId = U2.Id
          JOIN INDIGO031.Inventory.DCI ON M.DCIId = DCI.Id
          JOIN INDIGO031.Inventory.ATCEntity ATC ON M.ATCEntityId = ATC.Id
     UNION
     SELECT P.CODPRODUC AS Code, 
            P.DESPRODUC AS MEDICAMENTO, 
            DCI.CODDCIMED AS CodDCI, 
            DCI.DESDCIMED AS DCI, 
            '' AS CodATC, 
            '' AS ATC, 
            P.PRESENMED AS Presentacion, 
            F.DESFORMED AS Forma, 
            V.DESVIAADM AS Via, 
            G.DESGRUFAR AS Grupo, 
            P.CONCENMED AS Concentration,
            CASE P.TIPFORMED
                WHEN 1
                THEN 'Peso'
                WHEN 2
                THEN 'Volumnen'
                WHEN 3
                THEN 'Peso/Volumen'
                WHEN 4
                THEN 'Unidad'
            END AS TipoFormulacion, 
            CONVERT(CHAR(12), P.VOLTOTMED) + '' + CONVERT(CHAR(12), U.DESUNIMED) AS Volumen, 
            CONVERT(CHAR(12), P.PESTOTMED) + '' + CONVERT(CHAR(12), U1.DESUNIMED) AS Peso, 
            U2.DESUNIMED AS Unidad,
            CASE P.CALCANAUT
                WHEN 1
                THEN 'SI'
                WHEN 0
                THEN 'NO'
            END AS Calculo, 
            'Crystal' AS Indigo
     FROM INDIGO031.dbo.IHLISTPRO P
          JOIN INDIGO031.dbo.HCVIAADMI V ON P.CODVIAADM = V.CODVIAADM
                                                    AND P.TIPPRODUC <> 2
                                                    AND P.PROESTADO = 1
          JOIN INDIGO031.dbo.IHGRUFARM G ON P.CODGRUFAR = G.CODGRUFAR
          JOIN INDIGO031.dbo.IHFORMEDI F ON P.CODFORMED = F.CODFORMED
          LEFT JOIN INDIGO031.dbo.INUNIMEDI U ON P.CODUNIVOL = U.CODUNIMED
          LEFT JOIN INDIGO031.dbo.INUNIMEDI U1 ON P.CODUNIPES = U1.CODUNIMED
          LEFT JOIN INDIGO031.dbo.INUNIMEDI U2 ON P.CODUNIADM = U2.CODUNIMED
          JOIN INDIGO031.dbo.IHDCIMEDI DCI ON P.CODDCIMED = DCI.CODDCIMED;