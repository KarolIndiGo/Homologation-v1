-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_CXP_EstadoRadicacion
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_CXP_EstadoRadicacion]
AS
SELECT APT.Code AS [Codigo Oficio Traslado],
       APT.CreationDate AS [Fecha de Oficio],
       AP.Code AS [Cuentas por Pagar],
       T.[Name] AS [Tercero],
       T.Nit + '-' + T.DigitVerification AS NIT,
       AP.BillNumber AS Factura,
       EV.Code AS [Comprobante de Entrada],
       EV.TotalValue AS [Total CxP],
       IW.Code + ' - ' + IW.[Name] AS [Almacen],
       CASE APT.Status
          WHEN 1 THEN 'Registrado'
          WHEN 2 THEN 'Confirmado'
          WHEN 3 THEN 'Anulado'
          WHEN 4 THEN 'Evaluado'
       END AS [Estado Oficio],
       CASE APTD.Status
          WHEN 1 THEN 'Pendiente por Aceptacion'
          WHEN 2 THEN 'Aceptada'
          WHEN 3 THEN 'Rechazada'
          WHEN 4 THEN 'Anulada'
       END AS [Estado de Registro],
       PER.Fullname AS [Usuario Creacion]
FROM Payments.AccountPayableTransfer APT
     INNER JOIN Payments.AccountPayableTransferDetail APTD
        ON APT.Id = APTD.AccountPayableTransferId
     INNER JOIN Payments.AccountPayable AP
        ON AP.Id = APTD.AccountPayableId
     LEFT JOIN Common.ThirdParty T ON T.Id = AP.IdThirdParty
     LEFT JOIN Inventory.EntranceVoucher EV ON EV.Code = AP.EntityCode
     LEFT JOIN Inventory.Warehouse IW ON IW.Id = EV.WarehouseId
     LEFT JOIN [Security].[Person] PER
        ON APT.CreationUser = PER.Identification
