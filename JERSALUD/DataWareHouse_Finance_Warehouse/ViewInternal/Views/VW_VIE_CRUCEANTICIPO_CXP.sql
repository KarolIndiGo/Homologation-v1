-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_CRUCEANTICIPO_CXP
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_CRUCEANTICIPO_CXP
AS
     SELECT PT.Code, 
            PT.DocumentDate, 
            TP.Name AS Proveedor, 
            PT.Observations,
            CASE PT.TransferType
                WHEN '1'
                THEN 'Mismo Preveedor'
                WHEN '2'
                THEN 'Diferente Proveedor'
            END AS Tipo_Transferencia,
            CASE PT.Status
                WHEN '1'
                THEN 'Registrado'
                WHEN '2'
                THEN 'Confirmado'
                WHEN '3'
                THEN 'Anulado'
            END AS Estado, 
            AP.BillNumber AS Factura, 
            PTD.Value AS Valor_Cruce
     FROM INDIGO031.Payments.PaymentTransfer AS PT
          LEFT JOIN INDIGO031.Payments.PaymentTransferDetail AS PTD ON PTD.PaymentTransferId = PT.Id
          INNER JOIN INDIGO031.Common.ThirdParty AS TP ON TP.Id = PT.ThirdPartyId
          LEFT JOIN INDIGO031.Payments.AccountPayable AS AP ON AP.Id = PTD.AccountPayableId;