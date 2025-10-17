-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewMedicamentosDevoluciones
-- Extracted by Fabric SQL Extractor SPN v3.9.0

/*******************************************************************************************************************
Nombre: [Report].[ViewMedicamentosDevoluciones]
Tipo:Vista
Observacion:Informe de devoluciones de indumos y medicamentos a farmacia.
Profesional: 
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico: Nilsson Galindo Lopez
Fecha:14-06-2023
Ovservaciones: Se agrega el campo de gupo farmacologico a los medicamentos, esto solicitado por medio del ticket 1043
--------------------------------------
Version 3
Persona que modifico:
Fecha:
***********************************************************************************************************************************/

CREATE VIEW [Report].[ViewMedicamentosDevoluciones] as

WITH CTE_MEDICAMENTO as (
SELECT 
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
PD.Code DOCUMENTO,CAST(PD.DocumentDate AS date) FECHA_DOCUMENTO,PD.ConfirmationDate FECHA_CONFIRMACION,CASE PD.Status WHEN 1 THEN 'REGISTRADO' WHEN 2 THEN 'CONFIRMADO'
WHEN 3 THEN 'ANULADO' END ESTADO,PD.Code DOCUMENTO_DISPENSACION,IIF(pd.AffectInventory = 0, 'NO', 'SI') AFECTA_INVENTARIOS ,PD.EntityName ORIGEN,'Resta' OPERACION,
CEN.NOMCENATE AS CENTRO_ATENCION,FU.Name AS [UNIDAD FUNCIONAL],PD.AdmissionNumber INGRESO,ING.IFECHAING as [FECHA INGRESO],PAC.IPCODPACI AS IDENTIFICACION,PAC.IPNOMCOMP AS NOMBRE_PACIENTE,
TP2.Nit NIT,HA.Name AS ENTIDAD,CG.Code + ' - ' + CG.Name AS GRUPO_ATENCION,CASE PT.Class WHEN 2 THEN 'MEDICAMENTO' WHEN 3 THEN 'INSUMO' ELSE 'OTRO' END TIPO_PRODUCTO ,
ISNULL(ATC.Code,ISS.Code ) AS CODIGO_PADRE,ISNULL(ATC.Name,ISS.SupplieName ) AS NOMBRE_PADRE,IP.Code AS CODIGO_PRODUCTO,IP.CodeCUM AS CUM,IP.CodeAlternative [CODIGO ALT1] ,IP.CodeAlternativeTwo [CODIGO ALT2],
IP.Name AS NOMBRE_PRODUCTO,
/*IN V2*/FAR.[Name] AS [GRUPO FARMACOLOGICO],/*FN V2*/
ISNULL(ATC.Weight,ATC.Volume ) DOSIS,
ISNULL(IMU.Name ,IMU2.Name ) [UNIDAD]  ,PF.Name [PRESENTACION] ,
CASE ATC.POSProduct WHEN 1 THEN 'SI' ELSE 'NO' END PRODUCTO_POS ,case when ATC.Conditioned=1 then 'SI' ELSE 'NO' END CONDICIONADO ,
CASE WHEN atc.UNIRS=1 THEN 'SI' ELSE 'NO' END UNIRS ,
WH.Code + '-' + WH.Name AS ALMACEN ,PDDBS.Quantity [CANTIDAD] ,G.Quantity   CANTIDAD_DEVUELTA,PDD.AverageCost [COSTO PROMEDIO],
cast(PDD.TotalSalesPrice as numeric ) PRECIO_UNITARIO,(PDDBS.Quantity * PDD.TotalSalesPrice)  PRECIO_TOTAL ,
CAST(pdd.ServiceDate AS date) AS FECHA_SOLICITUD,
BS .BatchCode AS LOTE ,BS.ExpirationDate AS FECHA_VENCIMIENTO, IP.HealthRegistration AS REGISTRO_SANITARIO,IP.ExpirationDate AS FECHA_VENCIMIENTO_REGISTRO,
--TP.Nit +'-'+TP.Name 
'' AS PROFESIONAL,
isnull(SOD.AuthorizationNumber,ING.IAUTORIZA)  AS AUTORIZACION,
--PER.Identification +'-'+PER.Fullname 
'' USUARIO_REGISTRO,
ISNULL(ING.CODDIAEGR + ' - ' + DX2.NOMDIAGNO , ING.CODDIAING + ' - ' + DX.NOMDIAGNO ) [DIAGNOSTICO],'DISPENSACIONES' [TIPO DOCUMENTO],
 CAST(PD.DocumentDate  AS DATE) AS 'FECHA BUSQUEDA', 
 YEAR(PD.DocumentDate ) AS 'AÑO FECHA BUSQUEDA', 
 MONTH(PD.DocumentDate ) AS 'MES AÑO FECHA BUSQUEDA',
 CASE MONTH(PD.DocumentDate )WHEN 1THEN 'ENERO'
                         WHEN 2
                         THEN 'FEBRERO'
                         WHEN 3
                         THEN 'MARZO'
                         WHEN 4
                         THEN 'ABRIL'
                         WHEN 5
                         THEN 'MAYO'
                         WHEN 6
                         THEN 'JUNIO'
                         WHEN 7
                         THEN 'JULIO'
                         WHEN 8
                         THEN 'AGOSTO'
                         WHEN 9
                         THEN 'SEPTIEMBRE'
                         WHEN 10
                         THEN 'OCTUBRE'
                         WHEN 11
                         THEN 'NOVIEMBRE'
                         WHEN 12
                         THEN 'DICIEMBRE'
                     END AS 'MES NOMBRE FECHA BUSQUEDA', 
 DAY(PD.DocumentDate ) AS 'DIA FECHA BUSQUEDA'
from Inventory .PharmaceuticalDispensing PD JOIN
dbo.ADINGRESO AS ING WITH (NOLOCK) ON ING.NUMINGRES =PD.AdmissionNumber JOIN
dbo.INPACIENT AS PAC WITH (NOLOCK) ON PAC.IPCODPACI =ING.IPCODPACI  JOIN
dbo.ADCENATEN AS CEN WITH (NOLOCK) ON CEN.CODCENATE =ING.CODCENATE JOIN
Inventory .PharmaceuticalDispensingDetail as PDD WITH (NOLOCK) ON PDD.PharmaceuticalDispensingId =PD.Id JOIN
Inventory .InventoryProduct AS IP WITH (NOLOCK) ON IP.Id =PDD.ProductId JOIN
Inventory .ProductType AS PT WITH (NOLOCK) ON PT.ID =IP.ProductTypeId  JOIN
Inventory .Warehouse AS WH WITH (NOLOCK) ON WH.Id =PDD.WarehouseId JOIN
Payroll .FunctionalUnit AS FU WITH (NOLOCK) ON FU.Id =PDD.FunctionalUnitId JOIN
Billing .ServiceOrder as SO WITH (NOLOCK) ON PD.Id =SO.EntityId and PD.AdmissionNumber =SO.AdmissionNumber AND SO.Status =1 JOIN
Billing .ServiceOrderDetail AS SOD WITH (NOLOCK) ON SO.Id =SOD.ServiceOrderId AND SOD.ProductId =PDD.ProductId AND SOD.IsDelete =0 and SOD.SupplyQuantity  =PDD.Quantity  JOIN
--INDIGOSEC .Security .[User] AS US ON US.UserCode =PD.CreationUser JOIN
--INDIGOSEC .Security .Person AS PER ON PER.ID=US.IdPerson  JOIN
Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =PDD.OrderedHealthProfessionalThirdPartyId LEFT JOIN
Inventory .ATC AS ATC WITH (NOLOCK) ON ATC.ID =IP.ATCId LEFT JOIN
Inventory .InventoryMeasurementUnit AS IMU WITH (NOLOCK) ON ATC.WeightMeasureUnit =IMU.Id  LEFT JOIN
Inventory .InventoryMeasurementUnit AS IMU2 WITH (NOLOCK) ON ATC.VolumeMeasureUnit  =IMU2.Id LEFT JOIN
Inventory .PharmaceuticalForm PF WITH (NOLOCK) ON ATC.PharmaceuticalFormId =PF.Id  LEFT JOIN
Inventory .InventorySupplie AS ISS WITH (NOLOCK) ON ISS.ID =IP.SupplieId LEFT JOIN
Contract .CareGroup AS CG WITH (NOLOCK) ON CG.Id =PDD.CareGroupId LEFT JOIN
Contract .HealthAdministrator AS HA WITH (NOLOCK) ON HA.Id =PDD.HealthAdministratorId LEFT JOIN 
Common .ThirdParty AS TP2 WITH (NOLOCK) ON TP2.Id =HA.ThirdPartyId  LEFT JOIN
Inventory.PharmaceuticalDispensingDetailBatchSerial AS PDDBS WITH (NOLOCK) ON PDD.ID= PDDBS.PharmaceuticalDispensingDetailId LEFT JOIN 
Inventory.PhysicalInventory PI WITH (NOLOCK) ON PDDBS.PhysicalInventoryId = PI.Id LEFT JOIN
Inventory .BatchSerial AS BS WITH (NOLOCK) ON BS.Id =PI.BatchSerialId LEFT JOIN
dbo.INDIAGNOS AS DX WITH (NOLOCK) ON ING.CODDIAING =DX.CODDIAGNO LEFT JOIN
dbo.INDIAGNOS AS DX2 WITH (NOLOCK) ON ING.CODDIAEGR  =DX2.CODDIAGNO LEFT JOIN
/*IN V2*/Inventory.PharmacologicalGroup FAR ON ATC.PharmacologicalGroupId=FAR.Id LEFT JOIN /*FN V2*/
(SELECT  PharmaceuticalDispensingDetailBatchSerialId, SUM(Quantity) Quantity 
FROM
Inventory.PharmaceuticalDispensingDevolutionDetail GROUP BY PharmaceuticalDispensingDetailBatchSerialId) AS G ON G.PharmaceuticalDispensingDetailBatchSerialId =  PDDBS.Id 
group by PD.Code,PD.DocumentDate,PD.ConfirmationDate, PD.Status ,pd.AffectInventory,PD.EntityName,CEN.NOMCENATE,FU.Name,PD.AdmissionNumber,ING.IFECHAING ,PAC.IPCODPACI,PAC.IPNOMCOMP,
TP2.Nit,HA.Name,CG.Code,CG.Name,PT.Class,ISNULL(ATC.Code,ISS.Code ),ISNULL(ATC.Name,ISS.SupplieName ),IP.Code,IP.CodeCUM,IP.CodeAlternative,IP.CodeAlternativeTwo,
IP.Name,ATC.POSProduct,ATC.Conditioned,atc.UNIRS,WH.Code + '-' + WH.Name,PDDBS.Quantity,G.Quantity,PDD.AverageCost,cast(PDD.TotalSalesPrice as numeric ),PDDBS.Quantity * PDD.TotalSalesPrice,CAST(pdd.ServiceDate AS date),FU.Name,
BS .BatchCode,BS.ExpirationDate, IP.HealthRegistration,IP.ExpirationDate,TP.Nit +'-'+TP.Name,isnull(SOD.AuthorizationNumber,ING.IAUTORIZA),ING.IAUTORIZA,
--PER.Identification +'-'+PER.Fullname,
SOD.InvoicedQuantity ,SOD.SupplyQuantity,
ISNULL(ING.CODDIAEGR + ' - ' + DX2.NOMDIAGNO , ING.CODDIAING + ' - ' + DX.NOMDIAGNO ),ISNULL(ATC.Weight,ATC.Volume ) ,ISNULL(IMU.Name ,IMU2.Name ),PF.Name,FAR.Name
UNION ALL
SELECT	
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
pddev.Code DOCUMENTO_DEVOLUCION,pddev.DocumentDate FECHA_DEVOLUCION,pddev.ConfirmationDate FECHA_CONFIRMACION,CASE pddev.Status WHEN 1 THEN 'REGISTRADO' WHEN 2 THEN 'CONFIRMADO' WHEN 3 THEN 'ANULADO' END ESTADO,
pd.Code DOCUMENTO_DISPENSACION,'SI' AFECTA_INVENTARIOS,pddev.EntityName ORIGEN,'Suma' OPERACION,CEN.NOMCENATE CENTRO_ATENCION,FU.Name AS [UNIDAD FUNCIONAL],pddev.AdmissionNumber INGRESO,ING.IFECHAING as [FECHA INGRESO],PAC.IPCODPACI AS IDENTIFICACION,PAC.IPNOMCOMP AS NOMBRE_PACIENTE,
TP2.Nit NIT,HA.Name AS ENTIDAD,CG.Name AS GRUPO_ATENCION,CASE PT.Class WHEN 2 THEN 'MEDICAMENTO' WHEN 3 THEN 'INSUMO' ELSE 'OTRO' END TIPO_PRODUCTO ,
ISNULL(ATC.Code,ISS.Code ) AS CODIGO_PADRE,ISNULL(ATC.Name,ISS.SupplieName ) AS NOMBRE_PADRE,IP.Code AS CODIGO_PRODUCTO,IP.CodeCUM AS CUM,IP.CodeAlternative [CODIGO ALT1] ,IP.CodeAlternativeTwo [CODIGO ALT2],
IP.Name AS NOMBRE_PRODUCTO,
/*IN V2*/FAR.[Name] AS [GRUPO FARMACOLOGICO],/*FN V2*/
ISNULL(ATC.Weight,ATC.Volume ) DOSIS,
ISNULL(IMU.Name ,IMU2.Name ) [UNIDAD]  ,PF.Name [PRESENTACION],
CASE ATC.POSProduct WHEN 1 THEN 'SI' ELSE 'NO' END PRODUCTO_POS ,case when ATC.Conditioned=1 then 'SI' ELSE 'NO' END CONDICIONADO ,
CASE WHEN atc.UNIRS=1 THEN 'SI' ELSE 'NO' END UNIRS,CONCAT(w.Code, ' - ', w.Name) ALMACEN,pdd.Quantity CANTIDAD,pddevd.Quantity CANTIDAD_DEVUELTA,pdd.AverageCost [COSTO PROMEDIO] ,
cast(PDD.TotalSalesPrice as numeric ) PRECIO_UNITARIO,pddevd.Quantity * cast(PDD.TotalSalesPrice as numeric )  PRECIO_TOTAL,CAST(pdd.ServiceDate AS date) AS FECHA_SOLICITUD,
bs.BatchCode [LOTE],bs.ExpirationDate [FECHA VENCIMIENTO],
IP.HealthRegistration AS REGISTRO_SANITARIO,IP.ExpirationDate AS FECHA_VENCIMIENTO_REGISTRO,TP.Nit +'-'+TP.Name AS PROFESIONAL,
PDD.AuthorizationNumber AS AUTORIZACION,
--PER.Identification +'-'+PER.Fullname
'' USUARIO_REGISTRO,
ISNULL(ING.CODDIAEGR + ' - ' + DX2.NOMDIAGNO , ING.CODDIAING + ' - ' + DX.NOMDIAGNO ) [DIAGNOSTICO],
'DEVOLUCIONES' [TIPO DOCUMENTO],
 CAST(pddev.DocumentDate  AS DATE) AS 'FECHA BUSQUEDA', 
 YEAR(pddev.DocumentDate ) AS 'AÑO FECHA BUSQUEDA', 
 MONTH(pddev.DocumentDate ) AS 'MES AÑO FECHA BUSQUEDA',
 CASE MONTH(pddev.DocumentDate )WHEN 1THEN 'ENERO'
                         WHEN 2
                         THEN 'FEBRERO'
                         WHEN 3
                         THEN 'MARZO'
                         WHEN 4
                         THEN 'ABRIL'
                         WHEN 5
                         THEN 'MAYO'
                         WHEN 6
                         THEN 'JUNIO'
                         WHEN 7
                         THEN 'JULIO'
                         WHEN 8
                         THEN 'AGOSTO'
                         WHEN 9
                         THEN 'SEPTIEMBRE'
                         WHEN 10
                         THEN 'OCTUBRE'
                         WHEN 11
                         THEN 'NOVIEMBRE'
                         WHEN 12
                         THEN 'DICIEMBRE'
                     END AS 'MES NOMBRE FECHA BUSQUEDA', 
 DAY(pddev.DocumentDate ) AS 'DIA FECHA BUSQUEDA'
FROM Inventory.PharmaceuticalDispensingDevolution pddev WITH (NOLOCK) 
JOIN dbo.ADINGRESO AS ING WITH (NOLOCK) ON ING.NUMINGRES =pddev.AdmissionNumber 
JOIN dbo.INPACIENT AS PAC WITH (NOLOCK) ON PAC.IPCODPACI =ING.IPCODPACI  
JOIN dbo.ADCENATEN AS CEN WITH (NOLOCK) ON CEN.CODCENATE =ING.CODCENATE
JOIN Inventory.PharmaceuticalDispensingDevolutionDetail pddevd WITH (NOLOCK) ON pddev.Id = pddevd.PharmaceuticalDispensingDevolutionId
JOIN Inventory.PharmaceuticalDispensingDetailBatchSerial pddbs WITH (NOLOCK) ON pddevd.PharmaceuticalDispensingDetailBatchSerialId = pddbs.Id
JOIN Inventory.PharmaceuticalDispensingDetail pdd WITH (NOLOCK) ON pddbs.PharmaceuticalDispensingDetailId = pdd.Id
JOIN Inventory.PharmaceuticalDispensing pd WITH (NOLOCK) ON pdd.PharmaceuticalDispensingId = pd.Id
JOIN Inventory.Warehouse w WITH (NOLOCK) ON pdd.WarehouseId = w.Id
JOIN Inventory.InventoryProduct ip WITH (NOLOCK) ON pdd.ProductId = ip.Id
JOIN Inventory .ProductType AS PT WITH (NOLOCK) ON PT.ID =IP.ProductTypeId 
--JOIN INDIGOSEC .Security .[User] AS US ON US.UserCode =pddev.CreationUser 
--JOIN INDIGOSEC .Security .Person AS PER ON PER.ID=US.IdPerson  
JOIN Payroll .FunctionalUnit AS FU WITH (NOLOCK) ON FU.Id =PDD.FunctionalUnitId
JOIN Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =PDD.OrderedHealthProfessionalThirdPartyId 
LEFT JOIN Inventory.PhysicalInventory phy WITH (NOLOCK) ON pddbs.PhysicalInventoryId = phy.Id
LEFT JOIN Inventory .ATC AS ATC WITH (NOLOCK) ON ATC.ID =IP.ATCId 
LEFT JOIN Inventory .InventoryMeasurementUnit AS IMU WITH (NOLOCK) ON ATC.WeightMeasureUnit =IMU.Id  
LEFT JOIN Inventory .InventoryMeasurementUnit AS IMU2 WITH (NOLOCK) ON ATC.VolumeMeasureUnit  =IMU2.Id
LEFT JOIN Inventory .PharmaceuticalForm PF WITH (NOLOCK) ON ATC.PharmaceuticalFormId =PF.Id 
LEFT JOIN Inventory .InventorySupplie AS ISS WITH (NOLOCK) ON ISS.ID =IP.SupplieId
LEFT JOIN Inventory.BatchSerial bs WITH (NOLOCK) ON phy.BatchSerialId = bs.Id
LEFT JOIN Contract .CareGroup AS CG WITH (NOLOCK) ON CG.Id =ING.GENCAREGROUP   --=PDD.CareGroupId 
LEFT JOIN Contract .HealthAdministrator AS HA WITH (NOLOCK) ON HA.Id =ING.GENCONENTITY  --=PDD.HealthAdministratorId 
LEFT JOIN Common .ThirdParty AS TP2 WITH (NOLOCK) ON TP2.Id =HA.ThirdPartyId 
LEFT JOIN dbo.INDIAGNOS AS DX WITH (NOLOCK) ON ING.CODDIAING =DX.CODDIAGNO 
LEFT JOIN dbo.INDIAGNOS AS DX2 WITH (NOLOCK) ON ING.CODDIAEGR  =DX2.CODDIAGNO /*IN V2*/ LEFT JOIN
Inventory.PharmacologicalGroup FAR ON ATC.PharmacologicalGroupId=FAR.Id /*FN V2*/
--WHERE CAST(pddev.DocumentDate AS DATE)  BETWEEN @FECINI AND @FECFIN 
)

SELECT 
 *,
 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM
 CTE_MEDICAMENTO
