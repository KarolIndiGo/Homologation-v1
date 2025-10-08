-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_DISPENSACIONFARMACEUTICA_PACIENTE_2023
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_DISPENSACIONFARMACEUTICA_PACIENTE_2023 AS

SELECT DISTINCT 
F.Number AS Formula,F.CreationDate AS FechaRegistroDispensacion,F.Date AS FechaDispensacion,RTRIM(F.PatientCode) AS Documento,
RTRIM(F.PatientName) AS Paciente,MFD.ProductCode AS CodProducto,MFD.ProductName AS ProductoOrdenado,dci.Name AS DCI,
MFD.RequestQuantity AS CantidadSolicitada,MFD.DeliveryQuantity AS CantDespachada,MFD.PendingQuantity AS CantidadPendiente,
CASE MFD.IsDeferred WHEN 1 THEN 'Si' ELSE 'No' END AS ProductoDiferido,
ISNULL((SELECT SUM(MFDIF.PendingQuantity)
FROM INDIGO031.Inventory.MedicalFormulaDetailDeferred AS MFDIF
WHERE DeliveryDate<=GETDATE()
AND MFDIF.MedicalFormulaDetailId=MFD.Id
),MFD.PendingQuantity) AS Cantidad_Pendiente_Real,
(SELECT COUNT(SQ.MedicalFormulaDetailId)
FROM INDIGO031.Inventory.MedicalFormulaDetailDeferred AS SQ
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
                WHEN CEN.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017)
                THEN 'Boyaca'
                WHEN CEN.CODCENATE IN(010, 011, 012, 013, 014)
                THEN 'Meta'
                WHEN CEN.CODCENATE IN (015,016)
                THEN 'Casanare'
            END AS Dpto,
--D.Name AS Dpto,
--C.Name AS Municipio,
pa.IPTELEFON AS TelFijo,
pa.IPTELMOVI AS TelMovil
FROM INDIGO031.Inventory.MedicalFormula AS F
JOIN INDIGO031.Inventory.MedicalFormulaDetail AS MFD ON MFD.MedicalFormulaId=F.Id
JOIN INDIGO031.[Security].[UserInt] AS U ON F.CreationUser=U.UserCode
JOIN INDIGO031.[Security].PersonInt AS Per ON U.IdPerson=Per.Id
JOIN INDIGO031.dbo.ADCENATEN AS CEN ON CEN.CODCENATE=F.CareCenterCode
LEFT JOIN INDIGO031.dbo.INPACIENT AS pa on pa.IPCODPACI= F.PatientCode
LEFT JOIN INDIGO031.Inventory.ATC AS M ON MFD.ProductCode=M.Code
LEFT JOIN INDIGO031.Inventory.DCI AS dci ON M.DCIId=dci.Id
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
FROM INDIGO031.Inventory.MedicalFormulaDetailDeferred
) AS SourceTable PIVOT(AVG(PendingQuantity) FOR Periodo IN([1er Despacho],[2do Despacho],[3er Despacho],[4to Despacho],[5to Despacho],[6to Despacho])) AS PivotTable) AS DIF ON DIF.MedicalFormulaDetailId=MFD.Id
WHERE F.IsManual=0 AND DATEPART(YYYY,F.CreationDate)>='2023'
-------------------------------
UNION
-------------------------------
SELECT DISTINCT 
F.Number AS Formula,F.CreationDate AS FechaRegistroDispensacion,F.Date AS FechaDispensacion,RTRIM(F.PatientCode) AS Documento,RTRIM(F.PatientName),
MFD.ProductCode AS CodProducto,MFD.ProductName AS ProductoOrdenado,dci.Name AS DCI,MFD.RequestQuantity AS CantidadSolicitada,MFD.DeliveryQuantity AS CantDespachada,
MFD.PendingQuantity AS CantidadPendiente,CASE MFD.IsDeferred WHEN 1 THEN 'Si' ELSE 'No' END AS ProductoDiferido,
ISNULL((SELECT SUM(MFDIF.PendingQuantity)
FROM INDIGO031.Inventory.MedicalFormulaDetailDeferred AS MFDIF
WHERE DeliveryDate <= GETDATE()
AND MFDIF.MedicalFormulaDetailId=MFD.Id),MFD.PendingQuantity) AS Cantidad_Pendiente_Real,
(SELECT COUNT(SQ.MedicalFormulaDetailId)
FROM INDIGO031.Inventory.MedicalFormulaDetailDeferred AS SQ
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
                WHEN CEN.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017)
                THEN 'Boyaca'
                WHEN CEN.CODCENATE IN(010, 011, 012, 013, 014)
                THEN 'Meta'
                WHEN CEN.CODCENATE IN (015,016)
                THEN 'Casanare'
            END AS Dpto,
pa.IPTELEFON AS TelFijo,
pa.IPTELMOVI AS TelMovil
FROM INDIGO031.Inventory.MedicalFormula AS F
JOIN INDIGO031.Inventory.MedicalFormulaDetail AS MFD ON MFD.MedicalFormulaId=F.Id
JOIN INDIGO031.[Security].[UserInt] AS U ON F.CreationUser=U.UserCode
JOIN INDIGO031.[Security].PersonInt AS Per ON U.IdPerson=Per.Id
JOIN INDIGO031.dbo.ADCENATEN AS CEN ON CEN.CODCENATE=F.CareCenterCode
LEFT JOIN INDIGO031.dbo.INPACIENT AS pa on pa.IPCODPACI=F.PatientCode
LEFT JOIN INDIGO031.Inventory.ATC AS M ON MFD.ProductCode=M.Code
LEFT JOIN INDIGO031.Inventory.DCI AS dci ON M.DCIId=dci.Id
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
FROM INDIGO031.Inventory.MedicalFormulaDetailDeferred
) AS SourceTable PIVOT(AVG(PendingQuantity) FOR Periodo IN([1er Despacho],
[2do Despacho],
[3er Despacho],
[4to Despacho],
[5to Despacho],
[6to Despacho])) AS PivotTable
) AS DIF ON DIF.MedicalFormulaDetailId=MFD.Id
WHERE F.IsManual=1 AND DATEPART(YYYY,F.CreationDate)>='2023'