-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_FIAS_MEDICAMENTOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_FIAS_MEDICAMENTOS AS
SELECT DEP.depcodigo + ' - ' + DEP.nomdepart AS Departamento, 
       MUN.DEPMUNCOD + '' + MUN.MUNNOMBRE AS Municipio,
       CASE PA.IPTIPODOC
           WHEN 1
           THEN 'CC=Cedula de Ciudadania'
           WHEN 2
           THEN 'CE=Cedula de Extranjeria'
           WHEN 3
           THEN 'TI=Tarjeta de Identidad'
           WHEN 4
           THEN 'RC=Registro Civil'
           WHEN 5
           THEN 'PA=Pasporte'
           WHEN 6
           THEN 'AS=Adulto Sin Identificacion'
           WHEN 7
           THEN 'MS=Menor Sin Identificacion'
           WHEN 8
           THEN 'UN=Numero unico de identificacion personal'
       END AS 'Tipo Documento', 
       PA.IPCODPACI AS Documento, 
       FAC.[Grupo Farmacologico], 
       CONVERT(VARCHAR(20), FAC.CodeAlternativeTwo, 101) + ' - ' + FAC.Medicamento AS Medicamento, 
       DFO.RequestQuantity AS CantidadSolicitada, 
       FAC.Presentation, 
       CONVERT(VARCHAR(10), HC.FECHAORDE, 103) AS [Fecha Solicitud], 
       CONVERT(VARCHAR(10), FAC.FechaFactura, 103) AS [Fecha Entrega], 
       FAC.CantidadFactura AS 'Cantidad Entregada',
       CASE DFO.IsDeferred
           WHEN 1
           THEN '0'
           WHEN 0
           THEN DFO.PendingQuantity
       END AS 'Cantidad Pendiente', -- HC.CODCONCEC,
       '' AS 'Fecha Pendiente', 
       FAC.CUM, 
       DFO.IsDeferred AS Diferido
FROM INDIGO031.Inventory.MedicalFormula AS F
     JOIN INDIGO031.dbo.ADCENATEN CA ON F.CareCenterCode = CA.CODCENATE
     JOIN INDIGO031.dbo.INMUNICIP MUN ON CA.DEPMUNCOD = MUN.DEPMUNCOD
     JOIN INDIGO031.dbo.INDEPARTA DEP ON MUN.DEPCODIGO = DEP.depcodigo
     JOIN INDIGO031.dbo.INPACIENT PA ON PA.IPCODPACI = F.PatientCode
     JOIN INDIGO031.dbo.HCPRESCRC HC ON F.Number = HC.CODCONCEC
     JOIN INDIGO031.Inventory.MedicalFormulaDetail DFO ON DFO.MedicalFormulaId = F.Id
     JOIN
(
    SELECT M.Code, 
           P.Code AS CUM, 
           P.Name AS Producto, 
           M.Name AS Medicamento, 
           P.CodeAlternativeTwo, 
           DFA.InvoicedQuantity CantidadFactura, 
           DFA.TotalSalesPrice AS ValorUnitario, 
           DFA.GrandTotalSalesPrice AS ValorTotal, 
           FA.InvoiceNumber AS Factura, 
           FA.AdmissionNumber AS Ingreso, 
           O.PatientCode, 
           FA.InvoiceDate AS FechaFactura, 
           FA.DocumentType, 
           P.Presentation, 
           GF.Code + ' - ' + GF.Name AS [Grupo Farmacologico], 
           DIF.MedicalFormulaId
    FROM INDIGO031.Inventory.MedicalFormulaPharmaceuticalDispensing DIF
         JOIN INDIGO031.Inventory.PharmaceuticalDispensing DIS ON DIF.PharmaceuticalDispensingId = DIS.Id
         JOIN INDIGO031.Inventory.PharmaceuticalDispensingDetail DDIS ON DDIS.PharmaceuticalDispensingId = DIS.Id
         JOIN INDIGO031.Billing.ServiceOrder O ON DDIS.PharmaceuticalDispensingId = O.EntityId
                                                                       AND O.Status = 1
         JOIN INDIGO031.Billing.ServiceOrderDetail DO ON DO.ServiceOrderId = O.Id
                                                                        AND DDIS.ProductId = DO.ProductId
         JOIN INDIGO031.Billing.InvoiceDetail DFA ON DFA.ServiceOrderDetailId = DO.Id
         JOIN INDIGO031.Billing.Invoice FA ON DFA.InvoiceId = FA.Id
                                                           AND FA.Status = 1
         JOIN INDIGO031.Inventory.InventoryProduct P ON DO.ProductId = P.Id
         LEFT JOIN INDIGO031.Inventory.ATC M ON P.ATCId = M.Id
         JOIN INDIGO031.Inventory.PharmacologicalGroup GF ON M.PharmacologicalGroupId = GF.Id
) AS FAC ON DFO.ProductCode = FAC.Code
         AND F.PatientCode = FAC.PatientCode
         AND F.Id = FAC.MedicalFormulaId
WHERE F.IsManual = 0
UNION
SELECT FAC.Departamento, 
       FAC.Municipio,
       CASE PA.IPTIPODOC
           WHEN 1
           THEN 'CC=Cedula de Ciudadania'
           WHEN 2
           THEN 'CE=Cedula de Extranjeria'
           WHEN 3
           THEN 'TI=Tarjeta de Identidad'
           WHEN 4
           THEN 'RC=Registro Civil'
           WHEN 5
           THEN 'PA=Pasporte'
           WHEN 6
           THEN 'AS=Adulto Sin Identificacion'
           WHEN 7
           THEN 'MS=Menor Sin Identificacion'
           WHEN 8
           THEN 'UN=Numero unico de identificacion personal'
       END AS 'Tipo Documento', 
       PA.IPCODPACI AS Documento, 
       FAC.[Grupo Farmacologico], 
       FAC.CodeAlternativeTwo + ' - ' + FAC.Medicamento AS Medicamento, 
       DFO.RequestQuantity AS CantidadSolicitada, 
       FAC.Presentation, 
       CONVERT(VARCHAR(10), F.Date, 103) AS [Fecha Solicitud], 
       CONVERT(VARCHAR(10), FAC.FechaFactura, 103) AS [Fecha Entrega], 
       FAC.CantidadFactura AS 'Cantidad Entregada',
       CASE DFO.IsDeferred
           WHEN 1
           THEN '0'
           WHEN 0
           THEN DFO.PendingQuantity
       END AS 'Cantidad Pendiente', -- HC.CODCONCEC,
       '' AS 'Fecha Pendiente', 
       FAC.CUM, 
       DFO.IsDeferred AS Diferido
FROM INDIGO031.Inventory.MedicalFormula AS F
     JOIN INDIGO031.dbo.INPACIENT PA ON PA.IPCODPACI = F.PatientCode
     JOIN INDIGO031.Inventory.MedicalFormulaDetail DFO ON DFO.MedicalFormulaId = F.Id
     JOIN
(
    SELECT M.Code, 
           P.Code AS CUM, 
           P.Name AS Producto, 
           M.Name AS Medicamento, 
           P.CodeAlternativeTwo, 
           DFA.InvoicedQuantity CantidadFactura, 
           DFA.TotalSalesPrice AS ValorUnitario, 
           DFA.GrandTotalSalesPrice AS ValorTotal, 
           FA.InvoiceNumber AS Factura, 
           FA.AdmissionNumber AS Ingreso, 
           O.PatientCode, 
           FA.InvoiceDate AS FechaFactura, 
           FA.DocumentType, 
           P.Presentation, 
           GF.Code + ' - ' + GF.Name AS [Grupo Farmacologico], 
           DIF.MedicalFormulaId, 
           C.Code + '' + C.Name AS Municipio, 
           D.Code + ' - ' + D.Name AS Departamento
    FROM INDIGO031.Inventory.MedicalFormulaPharmaceuticalDispensing DIF
         JOIN INDIGO031.Inventory.PharmaceuticalDispensing DIS ON DIF.PharmaceuticalDispensingId = DIS.Id
         JOIN INDIGO031.Inventory.PharmaceuticalDispensingDetail DDIS ON DDIS.PharmaceuticalDispensingId = DIS.Id
         JOIN INDIGO031.Billing.ServiceOrder O ON DDIS.PharmaceuticalDispensingId = O.EntityId
                                                                       AND O.Status = 1
         JOIN INDIGO031.Billing.ServiceOrderDetail DO ON DO.ServiceOrderId = O.Id
                                                                        AND DDIS.ProductId = DO.ProductId
         JOIN INDIGO031.Billing.InvoiceDetail DFA ON DFA.ServiceOrderDetailId = DO.Id
         JOIN INDIGO031.Billing.Invoice FA ON DFA.InvoiceId = FA.Id
                                                           AND FA.Status = 1
         JOIN INDIGO031.Inventory.InventoryProduct P ON DO.ProductId = P.Id
         LEFT JOIN INDIGO031.Inventory.ATC M ON P.ATCId = M.Id
         JOIN INDIGO031.Inventory.PharmacologicalGroup GF ON M.PharmacologicalGroupId = GF.Id
         JOIN INDIGO031.Common.OperatingUnit UO ON DIS.OperatingUnitId = UO.Id
         JOIN INDIGO031.Common.City AS C ON C.Id = UO.IdCity
         JOIN INDIGO031.Common.Department AS D ON D.Id = C.DepartamentId
) AS FAC ON DFO.ProductCode = FAC.CUM
         AND F.PatientCode = FAC.PatientCode
         AND F.Id = FAC.MedicalFormulaId
WHERE F.IsManual = 1;