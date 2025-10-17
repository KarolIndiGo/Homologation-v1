-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE45_AD_Inventory_Medicamentos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE45_AD_Inventory_Medicamentos]
AS
SELECT atc.code
          AS [Código],
       atc.name
          AS Nombre,
       dci.code
          AS [Código DCI],
       dci.name
          AS [DCI],
       atce.code
          AS [Código ATC],
       atce.name
          AS ATC,
       pg.code + '-' + pg.name
          AS [Grupo Farmacologico],
       atc.abbreviationname
          AS [Abreviación],
       ar.code + '-' + ar.name
          AS [Vía de Administración],
       atc.Presentations
          AS Presentación,
       CASE atc.productNPT WHEN 0 THEN 'No' WHEN 1 THEN 'Si' END
          AS [Producto NPT],
       atc.Concentration
          AS Concentración,
       rl.code + '-' + rl.name
          AS [Nivel de Riesgo],
       atc.StabilityMinimumHours
          AS [Horas minimas Estabilidad],
       atc.StabilityMaximumHours
          AS [Horas maximas Estabilidad],
       CASE atc.PosProduct WHEN 0 THEN 'No' WHEN 1 THEN 'Si' END
          AS [Producto POS],
       CASE atc.AllPOSPathologies WHEN 0 THEN 'No' WHEN 1 THEN 'Si' END
          AS [Totas las Patologias],
       bg.name
          AS GrupoNoPos,
       CASE atc.formulationtype
          WHEN 1 THEN 'Peso'
          WHEN 2 THEN 'Volumen'
          WHEN 3 THEN 'Peso - Volumen'
          WHEN 4 THEN 'Unidad de administración'
       END
          AS [Tipo Fórmula],
       atc.Weight
          AS [Peso],
       mup.name
          AS [Unidad Peso],
       atc.volume
          AS [Volume],
       muv.name
          AS [Unidad Volumen],
       mua.name
          AS [Unidad Administración],
       ''
          AS [Forma Farmaceutica],
       CASE automaticcalculation WHEN 0 THEN 'No' WHEN 1 THEN 'Si' END
          AS [Cálculo Automatico],
       CASE TransferSurplusProduct WHEN 0 THEN 'No' WHEN 1 THEN 'Si' END
          AS [Real. Traslado Sobrante],
       CASE DiluentProduct WHEN 0 THEN 'No' WHEN 1 THEN 'Si' END
          AS [Funciona como Diluyente],
       CASE justificationforSpecialDrugs
          WHEN 0 THEN 'No'
          WHEN 1 THEN 'Si'
       END
          AS [Justifica Medicamentos Especiales],
       CASE JustificationOfInputs WHEN 0 THEN 'No' WHEN 1 THEN 'Si' END
          AS [Justificacion insumos/dispositivos],
       CASE IndicatorDrug WHEN 0 THEN 'No' WHEN 1 THEN 'Si' END
          AS [Medicamento Trazador],
       CASE atc.status WHEN 0 THEN 'Inactivo' WHEN 1 THEN 'Activo' END
          AS Estado,
       atc.creationuser + '-' + p.fullname
          AS [Usuario Crea],
       atc.creationDate
          AS [Fecha Creación],
       atc.modificationuser + '-' + pm.fullname
          AS [Usuario Modifica],
       atc.modificationdate
          AS [Fecha Modificación],
       atc.id
          AS ID
FROM Inventory.ATC AS atc
     LEFT OUTER JOIN Inventory.DCI AS dci 
        ON dci.id = atc.dciid
     LEFT OUTER JOIN Inventory.AdministrationRoute AS ar 
        ON ar.id = atc.AdministrationRouteid
     LEFT OUTER JOIN Inventory.PharmacologicalGroup AS pg 
        ON pg.id = atc.PharmacologicalGroupid
     LEFT OUTER JOIN Inventory.InventoryRiskLevel AS rl 
        ON rl.id = atc.InventoryRiskLevelid
     LEFT OUTER JOIN
     Inventory.InventoryMeasurementUnit AS mup 
        ON mup.id = atc.WeightMeasureUnit
     LEFT OUTER JOIN
     Inventory.InventoryMeasurementUnit AS muv 
        ON muv.id = atc.VolumeMeasureUnit
     LEFT OUTER JOIN
     Inventory.InventoryMeasurementUnit AS mua 
        ON mua.id = atc.AdministrationUnitid
     LEFT OUTER JOIN Inventory.ATCEntity AS atce 
        ON atce.id = atc.atcentityid
     LEFT OUTER JOIN Billing.BillingGroup AS bg 
        ON bg.id = atc.BillingGroupNoPosId
     LEFT OUTER JOIN Security.[User] AS u 
        ON u.usercode = atc.creationuser
     LEFT OUTER JOIN Security.person AS p 
        ON p.id = u.idperson
     LEFT OUTER JOIN Security.[User] AS um 
        ON um.usercode = atc.modificationuser
     LEFT OUTER JOIN Security.person AS pm 
        ON pm.id = um.idperson
