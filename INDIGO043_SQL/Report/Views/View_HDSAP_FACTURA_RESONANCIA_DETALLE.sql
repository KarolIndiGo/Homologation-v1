-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_FACTURA_RESONANCIA_DETALLE
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_FACTURA_RESONANCIA_DETALLE]
AS



SELECT DISTINCT
    A.InvoiceDate AS 'FECHA DE FACTURA',
    A.PatientCode AS 'DOCUMENTO DEL PACIENTE',
    B.IPNOMCOMP AS 'NOMBRE DEL PACIENTE',
    A.AdmissionNumber AS 'INGRESO',
    A.InvoiceNumber AS 'FACTURA',
    COALESCE(I.Code, H.Code) AS 'CODIGO',
    H.Description AS 'DESCRIPCIÓN CUPS',
    I.Name AS 'DESCRIPCIÓN PRODUCTO',
    CASE D.TIPOINGRE
        WHEN 1 THEN 'Ambulatorio'
        WHEN 2 THEN 'Hospitalario'
    END AS 'TIPO DE INGRESO',
    HI.NOMENTIDA AS 'ENTIDAD',
    G.TotalSalesPrice AS 'VALOR'
FROM Billing.Invoice A
JOIN Billing.ServiceOrder F            ON F.AdmissionNumber = A.AdmissionNumber 
JOIN Billing.ServiceOrderDetail G      ON F.Id = G.ServiceOrderId           
LEFT JOIN Inventory.InventoryProduct I ON G.ProductId = I.Id
LEFT JOIN Contract.CUPSEntity H        ON H.Id = G.CUPSEntityId
JOIN INPACIENT B                       ON A.PatientCode = B.IPCODPACI
JOIN INENTIDAD HI                      ON HI.CODENTIDA = B.CODENTIDA
JOIN ADINGRESO D                       ON D.NUMINGRES = A.AdmissionNumber
JOIN Payroll.FunctionalUnit C          ON C.Id = G.PerformsFunctionalUnitId
 
WHERE A.Status = '1'
AND (C.CODE = 65 OR H.Code IN (
    '883410', '883411', '883450', '883451', '883540', '883541', '883550', '883551', '937200', 'C198812', 'C198813', 'C198814', 'C198815', 'C198816', 'C198817', 'C198818', 'C198819', 'C198820', 'C198821', 'C198822', '31301', '31302', '31303', '31304', '31305', '31306', '31307', '883302', '883304', '883306', '883322', '883545', '883590', '883701', '883900', '883901', '883910', 'C198801', 'C198802', 'C198803', 'C198804', 'C198805', 'C198806', 'C198807', 'C198808', 'C198809', 'C198810', 'C198811', 'C198823', '883101', '883102', '883103', '883104', '883105', '883106', '883107', '883108', '883109', '883110', '883111', '883210', '883211', '883220', '883221', '883230', '883231', '883233', '883234', '883235', '883301', '883321', '883323', '883325', '883341', '883351', '883390', '883401', '883430', '883434', '883435', '883436', '883440', '883441', '883442', '883443', '883511', '883512', '883521', '883522', '883560', '883902', '883903', '883904', '883905', '883908', '883909', '883911', '883912', '883232', '883324', '39153', '883112', '883236', '883913'
))

