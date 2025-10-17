-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_GeneralLedger_ComprobantesContables2019
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_GeneralLedger_ComprobantesContables2019]
AS
     SELECT CASE
                WHEN CC.Code LIKE 'N%'
                THEN 'Neiva'
                WHEN CC.Code LIKE 'T%'
                THEN 'Tunja'
                WHEN CC.Code LIKE 'F%'
                THEN 'Florencia'
                ELSE ' '
            END AS Sede, 
            CC.Code + '-' + CC.Name AS [Centro Costo], 
            tcoco.Code AS [Tipo Comprobante], 
            tcoco.Name AS NombreComprobante, 
            coco.EntityCode AS CodDocumento,
            CASE coco.EntityName
                WHEN 'Invoice'
                THEN 'Factura'
                WHEN 'LoanMerchandise'
                THEN 'Mercancia Prestamo'
                WHEN 'PharmaceuticalDispensing'
                THEN 'Dispensación Farmaceutica'
                WHEN 'TransferOrder'
                THEN 'Orden Traslado'
                WHEN 'InventoryAdjustment'
                THEN 'Ajustes de Inventario'
                WHEN 'PharmaceuticalDispensingDevolution'
                THEN 'Devolución de Dispensación'
                WHEN 'AccountPayable'
                THEN 'Cuentas x Pagar'
                WHEN 'RemissionEntrance'
                THEN 'Remision Entrada'
                WHEN 'RemissionReclassification'
                THEN 'Reclasificación de Remision'
                ELSE coco.EntityName
            END AS Documento, 
            coco.Consecutive AS Consecutivo, 
            cuenta.Number AS cuenta, 
            cuenta.Name AS Descripción, 
            coco.VoucherDate AS [Fecha comprobante], 
            MONTH(coco.VoucherDate) AS Mes, 
            dcoco.DebitValue AS Débito, 
            dcoco.CreditValue AS Crédito, 
            coco.Detail AS [Detalle-Observaciones], 
            dcoco.RetentionRate AS [% retención], 
            T.Nit, 
            T.Name AS Tercero,
            CASE coco.STATUS
                WHEN '1'
                THEN 'Registrado'
                WHEN '2'
                THEN 'Confirmado'
                WHEN '3'
                THEN 'Anulado'
            END AS Estado,
            CASE T.PersonType
                WHEN '1'
                THEN 'Natural'
                WHEN '2'
                THEN 'Jurídico'
            END AS [Tipo Persona],
            CASE T.ContributionType
                WHEN '0'
                THEN 'Simplificado'
                WHEN '1'
                THEN 'Común'
                WHEN '2'
                THEN 'EmpresaEstatal'
                WHEN '3'
                THEN 'Gran_Contribuyente'
            END AS [Tipo Contribuyente], 
            per.Fullname AS Usuario
     FROM GeneralLedger.JournalVouchers AS coco 
          INNER JOIN GeneralLedger.JournalVoucherDetails AS dcoco  ON coco.Id = dcoco.IdAccounting
          INNER JOIN GeneralLedger.JournalVoucherTypes AS tcoco  ON coco.IdJournalVoucher = tcoco.Id
          INNER JOIN GeneralLedger.MainAccounts AS cuenta  ON cuenta.Id = dcoco.IdMainAccount
          INNER JOIN Common.ThirdParty AS T  ON T.Id = dcoco.IdThirdParty
          INNER JOIN Security.[User] AS u  ON u.UserCode = coco.CreationUser
          INNER JOIN Security.Person AS per  ON per.Id = u.IdPerson
          LEFT OUTER JOIN Payroll.CostCenter AS CC ON CC.Id = dcoco.IdCostCenter
     WHERE(coco.VoucherDate >= '01/01/2019 00:00:00')
          AND (coco.VoucherDate <= '31/01/2019 23:59:00');
