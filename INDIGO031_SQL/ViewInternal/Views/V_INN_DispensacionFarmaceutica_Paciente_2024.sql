-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_INN_DispensacionFarmaceutica_Paciente_2024
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[V_INN_DispensacionFarmaceutica_Paciente_2024] AS

SELECT DISTINCT cen.codcenate,
F.Number AS Formula,F.CreationDate AS FechaRegistroDispensacion,F.Date AS FechaDispensacion,RTRIM(F.PatientCode) AS Documento,
RTRIM(F.PatientName) AS Paciente,MFD.ProductCode AS CodProducto,MFD.ProductName AS ProductoOrdenado,dci.Name AS DCI,
MFD.RequestQuantity AS CantidadSolicitada,MFD.DeliveryQuantity AS CantDespachada,MFD.PendingQuantity AS CantidadPendiente,
CASE MFD.IsDeferred WHEN 1 THEN 'Si' ELSE 'No' END AS ProductoDiferido,
ISNULL((SELECT SUM(MFDIF.PendingQuantity)
FROM Inventory.MedicalFormulaDetailDeferred AS MFDIF
WHERE DeliveryDate<=GETDATE()
AND MFDIF.MedicalFormulaDetailId=MFD.Id
),MFD.PendingQuantity) AS Cantidad_Pendiente_Real,
(SELECT COUNT(SQ.MedicalFormulaDetailId)
FROM Inventory.MedicalFormulaDetailDeferred AS SQ
WHERE SQ.MedicalFormulaDetailId=MFD.Id
GROUP BY SQ.MedicalFormulaDetailId) AS 'Cantidad de Entregas',
DIF.FirstDeliveryDate AS[Fecha 1ra Entrega],
DIF.DeliveryQuantityDeferred AS [Cantidad a Diferir],
DIF.[1er Despacho],
DIF.[2do Despacho],
DIF.[3er Despacho],
DIF.[4to Despacho],
DIF.[5to Despacho],
DIF.[6to Despacho],
DIF.Periodicity AS [Periodicidad (dias)],
CASE F.IsManual WHEN 0 THEN 'Automatica' WHEN 1 THEN 'Manual' END AS TipoDispensacion,
F.FunctionalUnitName AS Unidad,
IIF(F.IPSCode='','900622551 - JERSALUD SAS',F.IPSCode) AS IPS,
DATEPART(YYYY,F.CreationDate) AS Año_Dispensacion,
DATEPART(MM,F.CreationDate) AS Mes_Dispensacion,
ltrim(rtrim(SUBSTRING(CEN.NOMCENATE,9,20)))as Sede,
Per.Identification + ' ' + Per.Fullname AS Nombre_Usuario_Crea_Dispensacion,
CASE
                WHEN cen.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'Boyaca'
                WHEN cen.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'Meta'
                WHEN cen.codcenate IN (015,016,019,020)
                THEN 'Casanare'
				WHEN cen.codcenate IN (001)
                THEN 'Bogota'
            END AS Dpto,
--D.Name AS Dpto,
--C.Name AS Municipio,
pa.IPTELEFON AS TelFijo,
pa.IPTELMOVI AS TelMovil
FROM Inventory.MedicalFormula AS F
JOIN Inventory.MedicalFormulaDetail AS MFD ON MFD.MedicalFormulaId=F.Id
JOIN [Security].[USER] AS U ON F.CreationUser=U.UserCode
JOIN [Security].Person AS Per ON U.IdPerson=Per.Id
JOIN DBO.ADCENATEN AS CEN ON CEN.CODCENATE=F.CareCenterCode
--JOIN [Security].PermissionCompany AS Perm ON Perm.IdUser=U.Id AND Perm.Permission=1 AND Perm.IdContainer=2002
--JOIN Common.OperatingUnit AS UO ON UO.Id=Perm.IdOperatingUnitDefault
--JOIN Common.City AS C ON C.Id=UO.IdCity
--JOIN Common.Department AS D ON D.Id=C.DepartamentId
LEFT JOIN dbo.INPACIENT AS pa on pa.ipcodpaci=f.patientcode
LEFT JOIN Inventory.ATC AS M ON MFD.ProductCode=M.Code
LEFT JOIN Inventory.DCI AS dci ON M.DCIId=dci.Id
LEFT JOIN (SELECT * FROM (SELECT MedicalFormulaDetailId,
FirstDeliveryDate,
DeliveryQuantityDeferred,
CASE Number
WHEN 1 THEN '1er Despacho'
WHEN 2 THEN '2do Despacho'
WHEN 3 THEN '3er Despacho'
WHEN 4 THEN '4to Despacho'
WHEN 5 THEN '5to Despacho'
WHEN 6 THEN '6to Despacho'
END AS Periodo,
PendingQuantity,
Periodicity
FROM Inventory.MedicalFormulaDetailDeferred
) AS SourceTable PIVOT(AVG(PendingQuantity) FOR Periodo IN([1er Despacho],[2do Despacho],[3er Despacho],[4to Despacho],[5to Despacho],[6to Despacho])) AS PivotTable) AS DIF ON DIF.MedicalFormulaDetailId=MFD.Id
WHERE F.IsManual=0 AND DATEPART(YYYY,F.CreationDate)>='2024' and MFD.PendingQuantity>0
-------------------------------
UNION
-------------------------------
SELECT DISTINCT cen.codcenate,
F.Number AS Formula,F.CreationDate AS FechaRegistroDispensacion,F.Date AS FechaDispensacion,RTRIM(F.PatientCode) AS Documento,RTRIM(F.PatientName),
MFD.ProductCode AS CodProducto,MFD.ProductName AS ProductoOrdenado,dci.Name AS DCI,MFD.RequestQuantity AS CantidadSolicitada,MFD.DeliveryQuantity AS CantDespachada,
MFD.PendingQuantity AS CantidadPendiente,CASE MFD.IsDeferred WHEN 1 THEN 'Si' ELSE 'No' END AS ProductoDiferido,
ISNULL((SELECT SUM(MFDIF.PendingQuantity)
FROM Inventory.MedicalFormulaDetailDeferred AS MFDIF
WHERE DeliveryDate <= GETDATE()
AND MFDIF.MedicalFormulaDetailId=MFD.Id),MFD.PendingQuantity) AS Cantidad_Pendiente_Real,
(SELECT COUNT(SQ.MedicalFormulaDetailId)
FROM Inventory.MedicalFormulaDetailDeferred AS SQ
WHERE SQ.MedicalFormulaDetailId=MFD.Id
GROUP BY SQ.MedicalFormulaDetailId) AS [Cantidad de Entregas],
DIF.FirstDeliveryDate AS [Fecha 1ra Entrega],
DIF.DeliveryQuantityDeferred AS [Cantidad a Diferir],
DIF.[1er Despacho],
DIF.[2do Despacho],
DIF.[3er Despacho],
DIF.[4to Despacho],
DIF.[5to Despacho],
DIF.[6to Despacho],
DIF.Periodicity AS [Periodicidad (dias)],
CASE F.IsManual WHEN 0 THEN 'Automatica' WHEN 1 THEN 'Manual' END AS TipoDispensacion,F.FunctionalUnitName AS Unidad,
IIF(F.IPSCode='','900622551 - JERSALUD SAS',F.IPSCode) AS IPS,
DATEPART(YYYY,F.CreationDate) AS Año_Dispensacion,
DATEPART(MM,F.CreationDate) AS Mes_Dispensacion,
ltrim(rtrim(SUBSTRING(CEN.NOMCENATE,9,20)))as Sede,
Per.Identification+ ' ' +Per.Fullname AS Nombre_Usuario_Crea_Dispensacion,--D.Name AS Dpto,C.Name AS Municipio--,
CASE
                WHEN cen.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'Boyaca'
                WHEN cen.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'Meta'
                WHEN cen.codcenate IN (015,016,019,020)
                THEN 'Casanare'
				WHEN cen.codcenate IN (001)
                THEN 'Bogota'
            END AS Dpto,
pa.IPTELEFON AS TelFijo,
pa.IPTELMOVI AS TelMovil
FROM Inventory.MedicalFormula AS F
JOIN Inventory.MedicalFormulaDetail AS MFD ON MFD.MedicalFormulaId=F.Id
JOIN [Security].[USER] AS U ON F.CreationUser=U.UserCode
JOIN [Security].Person AS Per ON U.IdPerson=Per.Id
JOIN DBO.ADCENATEN AS CEN ON CEN.CODCENATE=F.CareCenterCode
--JOIN [Security].PermissionCompany AS Perm ON Perm.IdUser=U.Id AND Perm.Permission=1 AND Perm.IdContainer=72
--JOIN Common.OperatingUnit AS UO ON UO.Id=Perm.IdOperatingUnitDefault
--JOIN Common.City AS C ON C.Id=UO.IdCity
--JOIN Common.Department AS D ON D.Id=C.DepartamentId
LEFT JOIN dbo.INPACIENT AS pa on pa.ipcodpaci=f.patientcode
LEFT JOIN Inventory.ATC AS M ON MFD.ProductCode=M.Code
LEFT JOIN Inventory.DCI AS dci ON M.DCIId=dci.Id
LEFT JOIN (SELECT * FROM (SELECT MedicalFormulaDetailId,FirstDeliveryDate,DeliveryQuantityDeferred,
CASE Number
WHEN 1 THEN '1er Despacho'
WHEN 2 THEN '2do Despacho'
WHEN 3 THEN '3er Despacho'
WHEN 4 THEN '4to Despacho'
WHEN 5 THEN '5to Despacho'
WHEN 6 THEN '6to Despacho'
END AS Periodo,
PendingQuantity,
Periodicity
FROM Inventory.MedicalFormulaDetailDeferred
) AS SourceTable PIVOT(AVG(PendingQuantity) FOR Periodo IN([1er Despacho],
[2do Despacho],
[3er Despacho],
[4to Despacho],
[5to Despacho],
[6to Despacho])) AS PivotTable
) AS DIF ON DIF.MedicalFormulaDetailId=MFD.Id
WHERE F.IsManual=1 AND DATEPART(YYYY,F.CreationDate)>='2024' and MFD.PendingQuantity>0

