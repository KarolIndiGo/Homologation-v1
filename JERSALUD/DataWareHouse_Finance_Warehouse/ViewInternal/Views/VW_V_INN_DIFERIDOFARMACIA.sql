-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_DIFERIDOFARMACIA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_DIFERIDOFARMACIA AS

SELECT MF.Number AS Formula, 
       P.IPCODPACI AS Documento,
       CASE P.IPTIPODOC
           WHEN 1 THEN 'CC'
           WHEN 2 THEN 'Cedula de Extranjeria'
           WHEN 3 THEN 'Tarjeta de Identidad'
           WHEN 4 THEN 'Registro Civil'
           WHEN 5 THEN 'Pasporte'
           WHEN 6 THEN 'Adulto Sin Identificacion'
           WHEN 7 THEN 'Menor Sin Identificacion'
           WHEN 8 THEN 'Numero unico de identificacion personal'
       END AS 'Tipo Documento', 
       MF.PatientName AS Paciente, 
       MF.CreationDate AS FechaRegistro, 
       LTRIM(RTRIM(MFD.ProductCode)) + ' - ' + LTRIM(RTRIM(MFD.ProductName)) AS Producto, 
       'Automatica' AS TipoDispensacion, 
       MFD.RequestQuantity AS 'Cantidad Solicitada', 
       MFD.DeliveryQuantity AS 'Cantidad Entrega', 
       MFD.PendingQuantity AS 'Cantidad Pendiente', 
       DIF.FirstDeliveryDate AS [Fecha 1ra Entrega], 
       DIF.DeliveryQuantityDeferred AS [Cantidad a Diferir], 
       DIF.[1er Despacho], 
       DIF.[2do Despacho], 
       DIF.[3er Despacho], 
       DIF.[4to Despacho], 
       DIF.[5to Despacho], 
       DIF.[6to Despacho], 
       DIF.Periodicity AS [Periodicidad (dias)], 
       LTRIM(RTRIM(MFD.HealthProfessionalName)) + ' - ' + LTRIM(RTRIM(MFD.SpecialtyName)) AS 'Medico/Entidad', 
       P.IPDIRECCI AS Direccion, 
       P.IPTELEFON AS 'Tel Fijo', 
       P.IPTELMOVI AS 'Movil', 
       LTRIM(RTRIM(MF.CreationUser)) + ' - ' + LTRIM(RTRIM(UP.FirstName)) + ' ' + LTRIM(RTRIM(UP.FirstLastName)) AS Funcionario, 
       UO.UnitName AS Sede
FROM INDIGO031.Inventory.MedicalFormula AS MF
     INNER JOIN INDIGO031.Inventory.MedicalFormulaDetail AS MFD ON MFD.MedicalFormulaId = MF.Id
                                                                AND MF.IsManual = 0
     INNER JOIN INDIGO031.dbo.INPACIENT AS P ON P.IPCODPACI = MF.PatientCode
     INNER JOIN INDIGO031.Security.UserInt AS U ON U.UserCode = MF.CreationUser
     INNER JOIN INDIGO031.Security.PersonInt AS UP ON UP.Id = U.IdPerson
     INNER JOIN INDIGO031.Security.PermissionCompanyInt AS PER ON PER.IdUser = U.Id
                                                           AND PER.Permission = 1
                                                           AND PER.IdContainer = 2002
     INNER JOIN INDIGO031.Common.OperatingUnit AS UO ON UO.Id = PER.IdOperatingUnitDefault
     JOIN
(
    SELECT *
    FROM
    (
        SELECT MedicalFormulaDetailId, 
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
    ) AS SourceTable PIVOT(AVG(PendingQuantity) FOR Periodo IN([1er Despacho], 
                                                               [2do Despacho], 
                                                               [3er Despacho], 
                                                               [4to Despacho], 
                                                               [5to Despacho], 
                                                               [6to Despacho])) AS PivotTable
) AS DIF ON DIF.MedicalFormulaDetailId = MFD.Id
WHERE MFD.IsDeferred = 1
UNION
SELECT MF.Number AS Formula, 
       P.IPCODPACI AS Documento,
       CASE P.IPTIPODOC
           WHEN 1 THEN 'CC'
           WHEN 2 THEN 'Cedula de Extranjeria'
           WHEN 3 THEN 'Tarjeta de Identidad'
           WHEN 4 THEN 'Registro Civil'
           WHEN 5 THEN 'Pasporte'
           WHEN 6 THEN 'Adulto Sin Identificacion'
           WHEN 7 THEN 'Menor Sin Identificacion'
           WHEN 8 THEN 'Numero unico de identificacion personal'
       END AS 'Tipo Documento', 
       MF.PatientName AS Paciente, 
       MF.CreationDate AS FechaRegistro, 
       LTRIM(RTRIM(M.Code)) + ' - ' + LTRIM(RTRIM(M.Name)) AS Producto, 
       'Manual' AS TipoDispensacion, 
       MFD.RequestQuantity AS 'Cantidad Solicitada', 
       MFD.DeliveryQuantity AS 'Cantidad Entrega', 
       MFD.PendingQuantity AS 'Cantidad Pendiente', 
       DIF.FirstDeliveryDate AS [Fecha 1ra Entrega], 
       DIF.DeliveryQuantityDeferred AS [Cantidad a Diferir], 
       DIF.[1er Despacho], 
       DIF.[2do Despacho], 
       DIF.[3er Despacho], 
       DIF.[4to Despacho], 
       DIF.[5to Despacho], 
       DIF.[6to Despacho], 
       DIF.Periodicity AS [Periodicidad (dias)], 
       LTRIM(RTRIM(IPS.CODIGOIPS)) + ' - ' + LTRIM(RTRIM(IPS.DSCRIPIPS)) AS 'Medico/Entidad', 
       P.IPDIRECCI AS Direccion, 
       P.IPTELEFON AS 'Tel Fijo', 
       P.IPTELMOVI AS 'Movil', 
       LTRIM(RTRIM(MF.CreationUser)) + ' - ' + LTRIM(RTRIM(UP.FirstName)) + ' ' + LTRIM(RTRIM(UP.FirstLastName)) AS Funcionario, 
       UO.UnitName AS Sede
FROM INDIGO031.Inventory.MedicalFormula AS MF
     INNER JOIN INDIGO031.Inventory.MedicalFormulaDetail AS MFD ON MFD.MedicalFormulaId = MF.Id
                                                                AND MF.IsManual = 1
     INNER JOIN INDIGO031.dbo.INPACIENT AS P ON P.IPCODPACI = MF.PatientCode
     INNER JOIN INDIGO031.Security.UserInt AS U ON U.UserCode = MF.CreationUser
     INNER JOIN INDIGO031.Security.PersonInt AS UP ON UP.Id = U.IdPerson
     INNER JOIN INDIGO031.Security.PermissionCompanyInt AS PER ON PER.IdUser = U.Id
                                                           AND PER.Permission = 1
                                                           AND PER.IdContainer = 2002
     INNER JOIN INDIGO031.Common.OperatingUnit AS UO ON UO.Id = PER.IdOperatingUnitDefault
     LEFT JOIN INDIGO031.dbo.ADCONTIPS AS IPS ON LTRIM(RTRIM(MF.IPSCode)) = LTRIM(RTRIM(IPS.CODIGOIPS)) + ' - ' + LTRIM(RTRIM(IPS.DSCRIPIPS))
     JOIN INDIGO031.Inventory.InventoryProduct Pr ON MFD.ProductCode = Pr.Code
     JOIN INDIGO031.Inventory.ATC M ON Pr.ATCId = M.Id
     JOIN
(
    SELECT *
    FROM
    (
        SELECT MedicalFormulaDetailId, 
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
    ) AS SourceTable PIVOT(AVG(PendingQuantity) FOR Periodo IN([1er Despacho], 
                                                               [2do Despacho], 
                                                               [3er Despacho], 
                                                               [4to Despacho], 
                                                               [5to Despacho], 
                                                               [6to Despacho])) AS PivotTable
) AS DIF ON DIF.MedicalFormulaDetailId = MFD.Id
WHERE MFD.IsDeferred = 1;