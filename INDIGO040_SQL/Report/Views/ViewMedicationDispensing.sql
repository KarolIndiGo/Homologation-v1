-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewMedicationDispensing
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[ViewMedicationDispensing] AS

SELECT
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
PD.Code FORMULA, CAST(PD.DocumentDate AS date) 'FECHA DOCUMENTO', 
PD.ConfirmationDate 'FECHA CONFIRMACION', 
CASE PD.Status WHEN 1 THEN 'REGISTRADO' 
			   WHEN 2 THEN 'CONFIRMADO' 
			   WHEN 3 THEN 'ANULADO' END ESTADO, 
DEP.nomdepart AS 'DEPARTAMENTO', 
MUN.MUNNOMBRE AS 'MUNICIPIO', 
CEN.NOMCENATE AS [CENTRO ATENCION], 
FU.Name AS [UNIDAD FUNCIONAL], 
PD.AdmissionNumber INGRESO, 
CAST(ING.IFECHAING AS DATE) AS [FECHA INGRESO], 
PAC.IPCODPACI AS IDENTIFICACION, 
PAC.IPNOMCOMP AS [NOMBRE PACIENTE], 
TP2.Nit NIT, 
HA.Name AS ENTIDAD, 
CG.Code + ' - ' + CG.Name AS GRUPO_ATENCION, 
CASE PT.Class WHEN 2 THEN 'MEDICAMENTO' WHEN 3 THEN 'INSUMO' ELSE 'OTRO' END 'TIPO PRODUCTO', 
ISNULL(ATC.Code, ISS.Code) AS 'CODIGO PADRE', ISNULL(ATC.Name, ISS.SupplieName) AS 'NOMBRE PADRE', 
IP.Code AS 'CODIGO PRODUCTO', 
IP.CodeCUM AS CUM, 
IP.CodeAlternative 'CODIGO ALT1', 
IP.CodeAlternativeTwo 'CODIGO ALT2', 
IP.Name AS 'NOMBRE PRODUCTO', 
FAR.[Name] AS [GRUPO FARMACOLOGICO],
ISNULL(ATC.Weight, ATC.Volume) DOSIS, 
ISNULL(IMU.Name, IMU2.Name) 'UNIDAD', PF.Name [PRESENTACION], 
CASE ATC.POSProduct WHEN 1 THEN 'SI' ELSE 'NO' END 'PRODUCTO POS', 
CASE IP.ProductControl WHEN 1 THEN 'SI' ELSE 'NO' END [PRODUCTO CONTROL],
CASE WHEN ATC.Conditioned = 1 THEN 'SI' ELSE 'NO' END 'CONDICIONADO',
CASE WHEN atc.UNIRS = 1 THEN 'SI' ELSE 'NO' END 'UNIRS', WH.Code + '-' + WH.Name AS ALMACEN, PDDBS.Quantity 'CANTIDAD', G.Quantity 'CANTIDAD DEVUELTA', PDD.AverageCost 'COSTO PROMEDIO', 
cast(PDD.TotalSalesPrice AS numeric) PRECIO_UNITARIO, (PDDBS.Quantity * PDD.TotalSalesPrice) PRECIO_TOTAL, CAST(pdd.ServiceDate AS date) AS 'FECHA SOLICITUD', BS.BatchCode AS LOTE, 
BS.ExpirationDate AS 'FECHA VENCIMIENTO', IP.HealthRegistration AS 'REGISTRO SANITARIO', IP.ExpirationDate AS 'FECHA VENCIMIENTO REGISTRO', TP.Nit + '-' + TP.Name AS 'PROFESIONAL', 
isnull(SOD.AuthorizationNumber, ING.IAUTORIZA) AS 'AUTORIZACION', PER.Identification + '-' + PER.Fullname 'USUARIO REGISTRO', ISNULL(ING.CODDIAEGR, ING.CODDIAING) AS 'CIE10', isnull(DX2.NOMDIAGNO, 
DX.NOMDIAGNO) AS 'DIAGNOSTICO', 'DISPENSACIONES' 'TIPO DOCUMENTO', CAST(PD.ConfirmationDate AS date) AS 'FECHA BUSQUEDA', YEAR(PD.ConfirmationDate) AS 'AÑO FECHA BUSQUEDA', 
MONTH(PD.ConfirmationDate) AS 'MES AÑO FECHA BUSQUEDA', CASE MONTH(PD.ConfirmationDate) 
WHEN 1 THEN 'ENERO' WHEN 2 THEN 'FEBRERO' WHEN 3 THEN 'MARZO' WHEN 4 THEN 'ABRIL' WHEN 5 THEN 'MAYO' WHEN 6 THEN 'JUNIO' WHEN 7 THEN 'JULIO' WHEN 8 THEN 'AGOSTO' WHEN 9 THEN 'SEPTIEMBRE' WHEN
10 THEN 'OCTUBRE' WHEN 11 THEN 'NOVIEMBRE' WHEN 12 THEN 'DICIEMBRE' END AS 'MES NOMBRE FECHA BUSQUEDA', FORMAT(DAY(PD.ConfirmationDate), '00') AS 'DIA FECHA BUSQUEDA',
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM            
.Inventory.PharmaceuticalDispensing PD JOIN
..ADINGRESO AS ING WITH (NOLOCK) ON ING.NUMINGRES = PD.AdmissionNumber JOIN
..INPACIENT AS PAC WITH (NOLOCK) ON PAC.IPCODPACI = ING.IPCODPACI JOIN
..ADCENATEN AS CEN WITH (NOLOCK) ON CEN.CODCENATE = ING.CODCENATE JOIN
.Inventory.PharmaceuticalDispensingDetail AS PDD WITH (NOLOCK) ON PDD.PharmaceuticalDispensingId = PD.Id JOIN
.Inventory.InventoryProduct AS IP WITH (NOLOCK) ON IP.Id = PDD.ProductId JOIN
.Inventory.ProductType AS PT WITH (NOLOCK) ON PT.ID = IP.ProductTypeId JOIN
.Inventory.Warehouse AS WH WITH (NOLOCK) ON WH.Id = PDD.WarehouseId JOIN
.Payroll.FunctionalUnit AS FU WITH (NOLOCK) ON FU.Id = PDD.FunctionalUnitId JOIN
.Billing.ServiceOrder AS SO WITH (NOLOCK) ON PD.Id = SO.EntityId AND PD.AdmissionNumber = SO.AdmissionNumber AND SO.Status = 1 JOIN
.Billing.ServiceOrderDetail AS SOD WITH (NOLOCK) ON SO.Id = SOD.ServiceOrderId AND SOD.ProductId = PDD.ProductId AND SOD.IsDelete = 0 AND SOD.SupplyQuantity = PDD.Quantity JOIN
.Security.[User] AS US ON US.UserCode = PD.CreationUser JOIN
.Security.Person AS PER ON PER.ID = US.IdPerson JOIN
.Common.ThirdParty AS TP WITH (NOLOCK) ON TP.Id = PDD.OrderedHealthProfessionalThirdPartyId LEFT JOIN
.Inventory.ATC AS ATC WITH (NOLOCK) ON ATC.ID = IP.ATCId LEFT JOIN
.Inventory.PharmacologicalGroup AS FAR ON FAR.ID=ATC.PharmacologicalGroupId LEFT JOIN
.Inventory.InventoryMeasurementUnit AS IMU WITH (NOLOCK) ON ATC.WeightMeasureUnit = IMU.Id LEFT JOIN
.Inventory.InventoryMeasurementUnit AS IMU2 WITH (NOLOCK) ON ATC.VolumeMeasureUnit = IMU2.Id LEFT JOIN
.Inventory.PharmaceuticalForm PF WITH (NOLOCK) ON ATC.PharmaceuticalFormId = PF.Id LEFT JOIN
.Inventory.InventorySupplie AS ISS WITH (NOLOCK) ON ISS.ID = IP.SupplieId LEFT JOIN
.Contract.CareGroup AS CG WITH (NOLOCK) ON CG.Id = PDD.CareGroupId LEFT JOIN
.Contract.HealthAdministrator AS HA WITH (NOLOCK) ON HA.Id = PDD.HealthAdministratorId LEFT JOIN
.Common.ThirdParty AS TP2 WITH (NOLOCK) ON TP2.Id = HA.ThirdPartyId LEFT JOIN
.Inventory.PharmaceuticalDispensingDetailBatchSerial AS PDDBS WITH (NOLOCK) ON PDD.ID = PDDBS.PharmaceuticalDispensingDetailId LEFT JOIN
.Inventory.PhysicalInventory PI WITH (NOLOCK) ON PDDBS.PhysicalInventoryId = PI.Id LEFT JOIN
.Inventory.BatchSerial AS BS WITH (NOLOCK) ON BS.Id = PI.BatchSerialId LEFT JOIN
..INDIAGNOS AS DX WITH (NOLOCK) ON ING.CODDIAING = DX.CODDIAGNO LEFT JOIN
..INDIAGNOS AS DX2 WITH (NOLOCK) ON ING.CODDIAEGR = DX2.CODDIAGNO LEFT JOIN
.Contract.HealthAdministrator AS EAPB WITH (NOLOCK) ON EAPB.Id = ING.GENCONENTITY LEFT JOIN
..INUBICACI AS UB WITH (NOLOCK) ON UB.AUUBICACI = PAC.AUUBICACI LEFT JOIN
..INMUNICIP AS MUN WITH (NOLOCK) ON MUN.DEPMUNCOD = UB.DEPMUNCOD LEFT JOIN
..INDEPARTA AS DEP WITH (NOLOCK) ON DEP.depcodigo = MUN.DEPCODIGO LEFT JOIN
    (SELECT        PharmaceuticalDispensingDetailBatchSerialId, SUM(Quantity) Quantity
    FROM            .Inventory.PharmaceuticalDispensingDevolutionDetail
    GROUP BY PharmaceuticalDispensingDetailBatchSerialId) AS G ON G.PharmaceuticalDispensingDetailBatchSerialId = PDDBS.Id
WHERE 
 pd.Status = 2
GROUP BY DEP.nomdepart, MUN.MUNNOMBRE, PD.Code, PD.DocumentDate, PD.ConfirmationDate, PD.Status, pd.AffectInventory, PD.EntityName, CEN.NOMCENATE, FU.Name, PD.AdmissionNumber, ING.IFECHAING, PAC.IPCODPACI, 
                         PAC.IPNOMCOMP, TP2.Nit, HA.Name, CG.Code, CG.Name, PT.Class, ISNULL(ATC.Code, ISS.Code), ISNULL(ATC.Name, ISS.SupplieName), IP.Code, IP.CodeCUM, IP.CodeAlternative, IP.CodeAlternativeTwo, IP.Name, 
                         ATC.POSProduct, ATC.Conditioned, atc.UNIRS, WH.Code + '-' + WH.Name, PDDBS.Quantity, G.Quantity, PDD.AverageCost, cast(PDD.TotalSalesPrice AS numeric), PDDBS.Quantity * PDD.TotalSalesPrice, 
                         CAST(pdd.ServiceDate AS date), FU.Name, BS.BatchCode, BS.ExpirationDate, IP.HealthRegistration, IP.ExpirationDate, TP.Nit + '-' + TP.Name, isnull(SOD.AuthorizationNumber, ING.IAUTORIZA), ING.IAUTORIZA, 
                         PER.Identification + '-' + PER.Fullname, SOD.InvoicedQuantity, SOD.SupplyQuantity, ISNULL(ING.CODDIAEGR, ING.CODDIAING), isnull(DX2.NOMDIAGNO, DX.NOMDIAGNO), ISNULL(ATC.Weight, ATC.Volume), ISNULL(IMU.Name, 
                         IMU2.Name), PF.Name,FAR.[Name],IP.ProductControl
