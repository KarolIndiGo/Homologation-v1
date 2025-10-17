-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_VIE_AD_Payments_TrasladoCuentas
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IMO_VIE_AD_Payments_TrasladoCuentas]
AS
SELECT tc.Code AS Consecutivo, F.Code + ' - ' + F.Name AS [Unidad de radicación], source.Code + ' - ' + source.Name AS [Unidad radicación origen], target.Code + ' - ' + target.Name AS [Unidad radicación destino], T.Nit + ' - ' + T.Name AS Tercero, O.UnitCode + ' - ' + O.UnitName AS Sede, 
           CASE A.status WHEN 1 THEN 'Causado Sin Confirmar' WHEN 2 THEN 'Causado Confirmado' WHEN 3 THEN 'Anulado' END AS [Estado C x P], CASE tc.status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' WHEN 4 THEN 'Evaluado' END AS [Estado traslado], 
           tc.CreationUser AS [Usuario creación traslado], tc.CreationDate as [Fecha Crea Traslado],  tc.ConfirmationDate AS [Fecha confirmación traslado], tc.ConfirmationUser AS [usuario confirmación traslado], CASE ATD.status WHEN 1 THEN 'Pendiente por Aceptacion' WHEN 2 THEN 'Aceptada' WHEN 3 THEN 'Rechazada' WHEN 4 THEN 'Evaluado' END AS [Estado factura], 
           ATD.AcceptanceDate AS [Fecha aceptación factura], ATD.AcceptanceUser AS [Usuario acepta factura], ATD.RejectionDate AS [Fecha rechazo], ATD.RejectionUser AS [Usuario rechaza], RR.Code + ' - ' + RR.Name AS [Causa rechazo], ATD.RejectionDescription AS [Descripción rechazo], A.Code AS CxP, 
           A.CreationDate AS [Fecha CxP], A.BillNumber AS [Nro factura], A.InvoiceValue AS [Valor Factura], A.BillDate AS FechaFactura, A.CreationDate AS [Fecha Creación en el Sistema], A.NumberFiling AS Radicado, 
           CASE WHEN SecondLastName LIKE '%NVA' THEN 'Neiva' WHEN SecondLastName LIKE '%TJA' THEN 'Tunja' WHEN SecondLastName LIKE '%FLA' THEN 'Florencia' WHEN SecondLastName LIKE '%BTA' THEN 'Bogotá' WHEN SecondLastName LIKE '%PTO' THEN 'Pitalito' END AS Origen, A.Balance AS SaldoFactura, 
           A.CreationUser AS CodUsuarioCxP, P.Fullname AS UsuarioCxP, A.DocumentDate AS FechaDocumento, L.Code + ' - ' + L.Name AS LíneaDistribución
FROM   Payments.AccountPayable AS A  INNER JOIN
           Common.Supplier AS S  ON S.Id = A.IdSupplier INNER JOIN
           Common.SuppliersDistributionLines AS dl  ON dl.IdSupplier = S.Id AND A.IdSuppliersDistributionLines = dl.Id INNER JOIN
           Common.DistributionLines AS L  ON L.Id = dl.IdDistributionLine INNER JOIN
           Common.ThirdParty AS T  ON T.Id = A.IdThirdParty INNER JOIN
           Payments.FilingUnit AS F  ON F.Id = A.FilingUnitId INNER JOIN
           Common.OperatingUnit AS O  ON O.Id = A.IdOperatingUnit LEFT OUTER JOIN
           Payments.AccountPayableTransferDetail AS ATD  ON A.Id = ATD.AccountPayableId LEFT OUTER JOIN
           Payments.AccountPayableTransfer AS tc  ON tc.Id = ATD.AccountPayableTransferId LEFT OUTER JOIN
           Payments.FilingUnit AS source  ON source.Id = tc.FilingUnitSourceId LEFT OUTER JOIN
           Payments.FilingUnit AS target  ON target.Id = tc.FilingUnitTargetId LEFT OUTER JOIN
           Payments.AccountPayableRejectionReason AS RR  ON RR.Id = ATD.RejectionReasonId LEFT OUTER JOIN
           Security.[User] AS U  ON U.UserCode = A.CreationUser LEFT OUTER JOIN
           Security.Person AS P  ON U.IdPerson = P.Id
WHERE (A.Balance <> '0' AND A.STATUS <> '4' AND A.CreationDate >= '01/01/2021 00:00:00')
