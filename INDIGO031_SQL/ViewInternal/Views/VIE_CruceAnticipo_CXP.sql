-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_CruceAnticipo_CXP
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_CruceAnticipo_CXP]
AS

/*
select * from Payments.PaymentTransfer where Code in ('0847','0945')
select * from Payments.PaymentTransferDetail where PaymentTransferId=1846
select * from Payments.PaymentTransferOtherConcept where PaymentTransferId=1944
select * from Payments.AccountPayable where Id =11037
select * from Common.ThirdParty 
select * from Payments.AdvancePayments 
*/

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
            CASE PT.STATUS
                WHEN '1'
                THEN 'Registrado'
                WHEN '2'
                THEN 'Confirmado'
                WHEN '3'
                THEN 'Anulado'
            END AS Estado, 
            AP.BillNumber AS Factura, 
            PTD.Value AS Valor_Cruce
     FROM Payments.PaymentTransfer AS PT
          LEFT JOIN Payments.PaymentTransferDetail AS PTD ON PTD.PaymentTransferId = PT.Id
          INNER JOIN Common.ThirdParty AS TP ON TP.Id = pt.ThirdPartyId
          LEFT JOIN Payments.AccountPayable AS AP ON AP.Id = PTD.AccountPayableId;
--where PT.Code in ('0847','0945')
