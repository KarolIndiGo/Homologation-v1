-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Formato_DispensacionFarmaceutica_Paciente
-- Extracted by Fabric SQL Extractor SPN v3.9.0


--/****** Object:  View [ViewInternal].[V_INN_DispensacionFarmaceutica_Paciente_2024]    Script Date: 30/11/2024 9:13:47 p. m. ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

CREATE VIEW [ViewInternal].[Formato_DispensacionFarmaceutica_Paciente] AS

--SELECT f.*
----cen.codcenate,
----F.Number AS Formula,F.CreationDate AS FechaRegistroDispensacion,F.Date AS FechaDispensacion,RTRIM(F.PatientCode) AS Documento,
----RTRIM(F.PatientName) AS Paciente,MFD.ProductCode AS CodProducto,MFD.ProductName AS ProductoOrdenado,dci.Name AS DCI,
----MFD.RequestQuantity AS CantidadSolicitada,MFD.DeliveryQuantity AS CantDespachada,MFD.PendingQuantity AS CantidadPendiente,
----CASE MFD.IsDeferred WHEN 1 THEN 'Si' ELSE 'No' END AS ProductoDiferido,
----ISNULL((SELECT SUM(MFDIF.PendingQuantity)
----FROM Inventory.MedicalFormulaDetailDeferred AS MFDIF
----WHERE DeliveryDate<=GETDATE()
----AND MFDIF.MedicalFormulaDetailId=MFD.Id
----),MFD.PendingQuantity) AS Cantidad_Pendiente_Real,
----(SELECT COUNT(SQ.MedicalFormulaDetailId)
----FROM Inventory.MedicalFormulaDetailDeferred AS SQ
----WHERE SQ.MedicalFormulaDetailId=MFD.Id
----GROUP BY SQ.MedicalFormulaDetailId) AS 'Cantidad de Entregas',
----DIF.FirstDeliveryDate AS[Fecha 1ra Entrega],
----DIF.DeliveryQuantityDeferred AS [Cantidad a Diferir],
----DIF.[1er Despacho],
----DIF.[2do Despacho],
----DIF.[3er Despacho],
----DIF.[4to Despacho],
----DIF.[5to Despacho],
----DIF.[6to Despacho],
----DIF.Periodicity AS [Periodicidad (dias)],
----CASE F.IsManual WHEN 0 THEN 'Automatica' WHEN 1 THEN 'Manual' END AS TipoDispensacion,
----F.FunctionalUnitName AS Unidad,
----IIF(F.IPSCode='','900622551 - JERSALUD SAS',F.IPSCode) AS IPS,
----DATEPART(YYYY,F.CreationDate) AS Año_Dispensacion,
----DATEPART(MM,F.CreationDate) AS Mes_Dispensacion,
----ltrim(rtrim(SUBSTRING(CEN.NOMCENATE,9,20)))as Sede,
----Per.Identification + ' ' + Per.Fullname AS Nombre_Usuario_Crea_Dispensacion,
----CASE
----                WHEN cen.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
----                THEN 'Boyaca'
----                WHEN cen.codcenate IN(010, 011, 012, 013, 014,018)
----                THEN 'Meta'
----                WHEN cen.codcenate IN (015,016,019,020)
----                THEN 'Casanare'
----				WHEN cen.codcenate IN (001)
----                THEN 'Bogota'
----            END AS Dpto,
------D.Name AS Dpto,
------C.Name AS Municipio,
----pa.IPTELEFON AS TelFijo,
----pa.IPTELMOVI AS TelMovil
--FROM Inventory.MedicalFormula AS F
--JOIN Inventory.MedicalFormulaDetail AS MFD ON MFD.MedicalFormulaId=F.Id
--JOIN [Security].[USER] AS U ON F.CreationUser=U.UserCode
--JOIN [Security].Person AS Per ON U.IdPerson=Per.Id
--JOIN DBO.ADCENATEN AS CEN ON CEN.CODCENATE=F.CareCenterCode
----JOIN [Security].PermissionCompany AS Perm ON Perm.IdUser=U.Id AND Perm.Permission=1 AND Perm.IdContainer=2002
----JOIN Common.OperatingUnit AS UO ON UO.Id=Perm.IdOperatingUnitDefault
----JOIN Common.City AS C ON C.Id=UO.IdCity
----JOIN Common.Department AS D ON D.Id=C.DepartamentId
--LEFT JOIN dbo.INPACIENT AS pa on pa.ipcodpaci=f.patientcode
--LEFT JOIN Inventory.ATC AS M ON MFD.ProductCode=M.Code
--LEFT JOIN Inventory.DCI AS dci ON M.DCIId=dci.Id
--LEFT JOIN (SELECT * FROM (SELECT MedicalFormulaDetailId,
--FirstDeliveryDate,
--DeliveryQuantityDeferred,
--CASE Number
--WHEN 1 THEN '1er Despacho'
--WHEN 2 THEN '2do Despacho'
--WHEN 3 THEN '3er Despacho'
--WHEN 4 THEN '4to Despacho'
--WHEN 5 THEN '5to Despacho'
--WHEN 6 THEN '6to Despacho'
--END AS Periodo,
--PendingQuantity,
--Periodicity
--FROM Inventory.MedicalFormulaDetailDeferred
--) AS SourceTable PIVOT(AVG(PendingQuantity) FOR Periodo IN([1er Despacho],[2do Despacho],[3er Despacho],[4to Despacho],[5to Despacho],[6to Despacho])) AS PivotTable) AS DIF ON DIF.MedicalFormulaDetailId=MFD.Id
--WHERE F.IsManual=0 AND (F.CreationDate)>='11-01-2024' --and MFD.PendingQuantity>0
-------------------------------
--UNION
-------------------------------
SELECT 
DISTINCT
'' as  [Nombre Operador],	'' as [NIT Operador],	--'' as [Modalidad Contratacion],	'' as [Tipo de medicamento],
'' as [Nit IPS (Punto dispensación)], cen.NOMCENATE as [Nombre IPS (Punto dispensación)], case    WHEN cen.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN cen.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN cen.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
              END  as	[Departamento Dispensación], SUBSTRING(cen.NOMCENATE, LEN('Jersalud ') + 1, LEN(cen.NOMCENATE)) as 	[Ciudad Dispensación],
'' as [Modalidad (Capita/Evento)],
--hc.Nit as [Nit IPS Origen del Paciente],	hc.Name as [Nombre IPS Origen del Paciente],	
--f.PatientName as [Nombres y Apellidos], 	
 CASE IPTIPODOC WHEN 1 THEN 'CC' WHEN 2 THEN 'CE' WHEN 3 THEN 'TI' WHEN 4 THEN 'RC' WHEN 5 THEN 'PA' WHEN 6 THEN 'AS' WHEN 7 THEN 'MS' WHEN 8 THEN 'NU' 
			 when 9 then  'CN'  			 when 10 then 'CD' 			 when 11 then 'SC' 			 when 12 then 'PE'  			 when 13 then 'PT' 
			 when 14 then 'DE'  			 when 15 then 'SI' 	 END AS [Tipo identificacion], 
f.PatientCode as 	[Número identificacion],-- CASE WHEN IPSEXOPAC = '1' THEN 'M' WHEN IPSEXOPAC = '2' THEN 'F' END  as [Género (F/M)],
--YEAR(f.date) - YEAR(IPFECNACI) as [EDAD (En años)],	IPDIRECCI AS [Dirección del paciente], 
-- ma.MUNNOMBRE as Ciudad, DEP.nomdepart as	Departamento, IPTELEFON +'-'+ IPTELMOVI  as	Teléfono,	 
 pr.Code as [CUM], pr.CodeAlternative as [CODIGO ATC], pr.Description as [Descripción medicamento (Nombre generico DCI, Concentración y Forma farmacéutica)] ,
 
-- ISNULL((SELECT SUM(MFDIF.PendingQuantity)
--FROM Inventory.MedicalFormulaDetailDeferred AS MFDIF
--WHERE DeliveryDate <= GETDATE()
--AND MFDIF.MedicalFormulaDetailId=MFD.Id),MFD.PendingQuantity)  as [Cantidad Pendiente (Mes)], 

DFA.TotalSalesPrice as [Valor unitario],
HC.DESVIAADM as [Vía administración], HC.FRECUENCI as [Frecuencia], HC.VALDURFIJ as [Duracion tratamiento (En dias)], lote.BatchCode as	Lote,
 lote.ExpirationDate as [Fecha Vencimiento], 
 mfd.RequestQuantity as [Cantidad Prescrita total], mfd.RequestQuantity as 	[Cantidad Solicitada (Mes)], DeliveryQuantity as	[Cantidad entregada (Mes)],	
 DFA.TotalSalesPrice as [Valor unitario del medicamento ($)],

--DFA.GrandTotalSalesPrice as [Valor total del medicamento ($)],
HC.CODDIAGNO as	[Codigo diagnostico Principal], HC.NOMDIAGNO as [Descripcion Diagnostico principal] ,
HC.FECINIDOS AS [Fecha prescripcion (fecha de la formula)],-- '' AS	[Fecha autorización entrega],
F.Date AS [Fecha Solicitud  (fecha solicitud al servicio farmaceutico)], DIS.ConfirmationDate AS [Fecha entrega],  '' as [Fecha Entrega del Pendiente],
--'' AS	[Número de autorización (si aplica)], 
F.Number AS [Número fórmula],-- '' AS	[Autoriza entrega a domicilio?],
'' as [Motivo no entrega],
'' AS [Se entrego en el domicilio ?]--, 
--CASE WHEN MFD.IsDeferred=1 THEN 'E. PENDIENTE' ELSE 'E. FORMULA' END AS [¿El registro corresponde  a una entrega de formula o a entrega de un pendiente ?]            








--cen.codcenate,
--F.Number AS Formula,F.CreationDate AS FechaRegistroDispensacion,F.Date AS FechaDispensacion,RTRIM(F.PatientCode) AS Documento,RTRIM(F.PatientName),
--MFD.ProductCode AS CodProducto,MFD.ProductName AS ProductoOrdenado,dci.Name AS DCI,MFD.RequestQuantity AS CantidadSolicitada,MFD.DeliveryQuantity AS CantDespachada,
--MFD.PendingQuantity AS CantidadPendiente,CASE MFD.IsDeferred WHEN 1 THEN 'Si' ELSE 'No' END AS ProductoDiferido,
--ISNULL((SELECT SUM(MFDIF.PendingQuantity)
--FROM Inventory.MedicalFormulaDetailDeferred AS MFDIF
--WHERE DeliveryDate <= GETDATE()
--AND MFDIF.MedicalFormulaDetailId=MFD.Id),MFD.PendingQuantity) AS Cantidad_Pendiente_Real,
--(SELECT COUNT(SQ.MedicalFormulaDetailId)
--FROM Inventory.MedicalFormulaDetailDeferred AS SQ
--WHERE SQ.MedicalFormulaDetailId=MFD.Id
--GROUP BY SQ.MedicalFormulaDetailId) AS [Cantidad de Entregas],
--DIF.FirstDeliveryDate AS [Fecha 1ra Entrega],
--DIF.DeliveryQuantityDeferred AS [Cantidad a Diferir],
--DIF.[1er Despacho],
--DIF.[2do Despacho],
--DIF.[3er Despacho],
--DIF.[4to Despacho],
--DIF.[5to Despacho],
--DIF.[6to Despacho],
--DIF.Periodicity AS [Periodicidad (dias)],
--CASE F.IsManual WHEN 0 THEN 'Automatica' WHEN 1 THEN 'Manual' END AS TipoDispensacion,F.FunctionalUnitName AS Unidad,
--IIF(F.IPSCode='','900622551 - JERSALUD SAS',F.IPSCode) AS IPS,
--DATEPART(YYYY,F.CreationDate) AS Año_Dispensacion,
--DATEPART(MM,F.CreationDate) AS Mes_Dispensacion,
--ltrim(rtrim(SUBSTRING(CEN.NOMCENATE,9,20)))as Sede,
--Per.Identification+ ' ' +Per.Fullname AS Nombre_Usuario_Crea_Dispensacion,--D.Name AS Dpto,C.Name AS Municipio--,
--CASE
--                WHEN cen.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
--                THEN 'Boyaca'
--                WHEN cen.codcenate IN(010, 011, 012, 013, 014,018)
--                THEN 'Meta'
--                WHEN cen.codcenate IN (015,016,019,020)
--                THEN 'Casanare'
--				WHEN cen.codcenate IN (001)
--                THEN 'Bogota'
--            END AS Dpto,
--pa.IPTELEFON AS TelFijo,
--pa.IPTELMOVI AS TelMovil
FROM Inventory.MedicalFormula AS F
JOIN Inventory.MedicalFormulaDetail AS MFD ON MFD.MedicalFormulaId=F.Id
JOIN Inventory.MedicalFormulaPharmaceuticalDispensing AS DIF  ON DIF.MedicalFormulaId = F.Id
JOIN Inventory.ATC AS M ON MFD.ProductCode=M.Code
JOIN Inventory.InventoryProduct AS pr WITH (nolock) ON pr.ATCId=M.ID 
JOIN Inventory.PharmaceuticalDispensing AS DIS  ON DIF.PharmaceuticalDispensingId = DIS.Id
JOIN Inventory.PharmaceuticalDispensingDetail AS DDIS  ON DDIS.PharmaceuticalDispensingId = DIS.Id AND DDIS.ProductId=PR.ID
--------------		  
		LEFT JOIN  Inventory.PharmaceuticalDispensingDetailBatchSerial AS bs WITH (nolock) ON bs.PharmaceuticalDispensingDetailId = DDIS.Id LEFT OUTER JOIN
		  Inventory.PhysicalInventory as ph WITH (NOLOCK) ON ph.id = bs.PhysicalInventoryId LEFT OUTER JOIN
		   Inventory.BatchSerial as lote WITH (NOLOCK) ON lote.Id = ph.BatchSerialId
JOIN DBO.ADCENATEN AS CEN ON CEN.CODCENATE=F.CareCenterCode
----------------JOIN [Security].PermissionCompany AS Perm ON Perm.IdUser=U.Id AND Perm.Permission=1 AND Perm.IdContainer=72
----------------JOIN Common.OperatingUnit AS UO ON UO.Id=Perm.IdOperatingUnitDefault
----------------JOIN Common.City AS C ON C.Id=UO.IdCity
----------------JOIN Common.Department AS D ON D.Id=C.DepartamentId
LEFT JOIN dbo.INPACIENT AS pa on pa.ipcodpaci=f.patientcode
LEFT OUTER JOIN INUBICACI AS u WITH (nolock) ON u.AUUBICACI = Pa.AUUBICACI
LEFT OUTER JOIN INMUNICIP AS ma WITH (nolock) ON ma.DEPMUNCOD = u.DEPMUNCOD
LEFT OUTER JOIN INDEPARTA AS DEP WITH (nolock) ON ma.DEPCODIGO = DEP.depcodigo 

LEFT JOIN Inventory.DCI AS dci ON M.DCIId=dci.Id
 left JOIN Billing.ServiceOrder AS O  ON DDIS.PharmaceuticalDispensingId = O.EntityId
                                                                           AND o.STATUS = 1
 left JOIN Billing.ServiceOrderDetail AS DO  ON DO.ServiceOrderId = O.Id
                                                                                  AND DDIS.ProductId = DO.ProductId
          JOIN Billing.InvoiceDetail AS DFA  ON DFA.ServiceOrderDetailId = DO.Id
left join (
SELECT a.IPCODPACI, CODPRODUC, via.DESVIAADM, FRECUENCI, a.CODDIAGNO, NOMDIAGNO,VALDURFIJ, a.FECINIDOS,
concat(MONTH(a.FECINIDOS),'/',YEAR(a.FECINIDOS)) as Fecha, tp.nit, tp.Name
FROM DBO.HCPRESCRA AS A 
inner join dbo.HCVIAADMI as via on via.CODVIAADM=a.CODVIAADM
inner join dbo.INDIAGNOS as dx on dx.CODDIAGNO=a.CODDIAGNO
inner join dbo.ADINGRESO as i on i.NUMINGRES=a.NUMINGRES
inner join Contract.HealthAdministrator as ha on ha.id=i.GENCONENTITY
inner join Common.ThirdParty as tp on tp.id=ha.ThirdPartyId
WHERE FECINIDOS>='11-01-2024' ) as hc on hc.IPCODPACI=F.PatientCode AND HC.Fecha=concat(MONTH(F.DATE),'/',YEAR(F.Date)) AND HC.CODPRODUC=MFD.ProductCode
--LEFT JOIN (SELECT * FROM (SELECT MedicalFormulaDetailId,FirstDeliveryDate,DeliveryQuantityDeferred,
--CASE Number
--WHEN 1 THEN '1er Despacho'
--WHEN 2 THEN '2do Despacho'
--WHEN 3 THEN '3er Despacho'
--WHEN 4 THEN '4to Despacho'
--WHEN 5 THEN '5to Despacho'
--WHEN 6 THEN '6to Despacho'
--END AS Periodo,
--PendingQuantity,
--Periodicity
--FROM Inventory.MedicalFormulaDetailDeferred
--) AS SourceTable PIVOT(AVG(PendingQuantity) FOR Periodo IN([1er Despacho],
--[2do Despacho],
--[3er Despacho],
--[4to Despacho],
--[5to Despacho],
--[6to Despacho])) AS PivotTable
--) AS DIF ON DIF.MedicalFormulaDetailId=MFD.Id
WHERE F.IsManual=1 AND (F.CreationDate)>='11-01-2024' --and MFD.PendingQuantity>0
--and f.PatientCode='1050604504'
