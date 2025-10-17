-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_COMPENSAR_RADICADO
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW Report.View_HDSAP_COMPENSAR_RADICADO
AS
SELECT        PREFIJO, NUMERO_FACTURA, AUTORIZACION, CODIGO_CUPS, NOMBRE_SERVICIO, CANTIDAD, VALUNITARIO, TOTAL, COPAGO, DIAGNOSTICO_EGRESO, Tipo_Documento, NUMERO_DOC, PRIMER_APELLIDO, SEGUNDO, 
                         PNOMBRE, SNOMBRE, FECHA_INICIAL, FECHA_FINAL, CAUSA_EXTERNA, RADICADO, CAT
FROM            (SELECT        'HSPE' AS PREFIJO, SUBSTRING(FAC.InvoiceNumber, 5, 10) AS NUMERO_FACTURA, DOS.AuthorizationNumber AS AUTORIZACION, CCUPS.RIPSCode AS CODIGO_CUPS, CCUPS.Description AS NOMBRE_SERVICIO, 
                                                    DOS.InvoicedQuantity AS CANTIDAD, DOS.TotalSalesPrice AS VALUNITARIO, DOS.GrandTotalSalesPrice AS TOTAL, DOS.ThirdPartyDiscount AS COPAGO, FAC.OutputDiagnosis AS DIAGNOSTICO_EGRESO, 
                                                    CASE p.IPTIPODOC WHEN '1' THEN '1' WHEN '2' THEN '4 ' WHEN '3' THEN '3' WHEN '4' THEN '7' WHEN '5' THEN '5' WHEN '6' THEN 'AS' WHEN '7' THEN 'MS' WHEN '8' THEN 'NU' WHEN '9' THEN '9' END AS Tipo_Documento,
                                                     FAC.PatientCode AS NUMERO_DOC, P.IPPRIAPEL AS PRIMER_APELLIDO, P.IPSEGAPEL AS SEGUNDO, P.IPPRINOMB AS PNOMBRE, P.IPSEGNOMB AS SNOMBRE, FORMAT(CAST(FAC.InitialDate AS DATE), 
                                                    'yyyyMMdd') AS FECHA_INICIAL, FORMAT(CAST(FAC.OutputDate AS DATE), 'yyyyMMdd') AS FECHA_FINAL, '13' AS CAUSA_EXTERNA, RC.RadicatedConsecutive AS RADICADO, FAC.InvoiceCategoryId AS CAT
                          FROM            Portfolio.RadicateInvoiceC AS RC INNER JOIN
                                                    Portfolio.RadicateInvoiceD AS RD ON RC.Id = RD.RadicateInvoiceCId INNER JOIN
                                                    Billing.Invoice AS FAC ON RD.InvoiceNumber = FAC.InvoiceNumber INNER JOIN
                                                    Billing.InvoiceDetail AS DF ON DF.InvoiceId = FAC.Id INNER JOIN
                                                    Billing.ServiceOrderDetail AS DOS ON dos.Id = DF.ServiceOrderDetailId INNER JOIN
                                                    INPACIENT AS P ON P.IPCODPACI = FAC.PatientCode INNER JOIN
                                                    Contract.CUPSEntity AS CCUPS ON DOS.CUPSEntityId = CCUPS.Id
                          UNION ALL
                          SELECT        'HSPE' AS PREFIJO, SUBSTRING(FAC.InvoiceNumber, 5, 10) AS NUMERO_FACTURA, DOS.AuthorizationNumber AS AUTORIZACION, INV.Code AS CODIGO_CUPS, INV.Description AS NOMBRE_SERVICIO, 
                                                   DOS.InvoicedQuantity AS CANTIDAD, DOS.TotalSalesPrice AS VALUNITARIO, DOS.GrandTotalSalesPrice AS TOTAL, DOS.ThirdPartyDiscount AS COPAGO, FAC.OutputDiagnosis AS DIAGNOSTICO_EGRESO, 
                                                   CASE p.IPTIPODOC WHEN '1' THEN '1' WHEN '2' THEN '4 ' WHEN '3' THEN '3' WHEN '4' THEN '7' WHEN '5' THEN '5' WHEN '6' THEN 'AS' WHEN '7' THEN 'MS' WHEN '8' THEN 'NU' WHEN '9' THEN '9' END AS Tipo_Documento,
                                                    FAC.PatientCode AS NUMERO_DOC, P.IPPRIAPEL AS PRIMER_APELLIDO, P.IPSEGAPEL AS SEGUNDO, P.IPPRINOMB AS PNOMBRE, P.IPSEGNOMB AS SNOMBRE, FORMAT(CAST(FAC.InitialDate AS DATE), 
                                                   'yyyyMMdd') AS FECHA_INICIAL, FORMAT(CAST(FAC.OutputDate AS DATE), 'yyyyMMdd') AS FECHA_FINAL, '13' AS CAUSA_EXTERNA, RC.RadicatedConsecutive AS RADICADO, FAC.InvoiceCategoryId AS CAT
                          FROM            Portfolio.RadicateInvoiceC AS RC INNER JOIN
                                                   Portfolio.RadicateInvoiceD AS RD ON RC.Id = RD.RadicateInvoiceCId INNER JOIN
                                                   Billing.Invoice AS FAC ON RD.InvoiceNumber = FAC.InvoiceNumber INNER JOIN
                                                   billing.InvoiceDetail AS DF ON DF.InvoiceId = FAC.Id INNER JOIN
                                                   Billing.ServiceOrderDetail AS DOS ON dos.Id = DF.ServiceOrderDetailId INNER JOIN
                                                   INPACIENT AS P ON P.IPCODPACI = FAC.PatientCode INNER JOIN
                                                   Inventory.InventoryProduct AS INV ON INV.Id = DOS.ProductId) AS datos
