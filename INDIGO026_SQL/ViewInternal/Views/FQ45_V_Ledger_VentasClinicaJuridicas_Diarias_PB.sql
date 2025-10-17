-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_Ledger_VentasClinicaJuridicas_Diarias_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE view [ViewInternal].[FQ45_V_Ledger_VentasClinicaJuridicas_Diarias_PB]
AS


SELECT CASE WHEN CC.Code LIKE 'N%' THEN 'Neiva'  WHEN CC.Code LIKE 'E%' THEN 'Abner' WHEN CC.Code LIKE 'P%' THEN 'Pitalito' WHEN CC.Code LIKE 'T%' THEN 'Tunja' WHEN CC.Code LIKE 'F%' THEN 'Florencia' ELSE ' ' END AS Sede, CC.Code , CC.Name AS [Centro Costo], tcoco.Code AS [Tipo Comprobante], 
tcoco.Name AS NombreComprobante, coco.EntityCode AS CodDocumento, 
           CASE coco.EntityName WHEN 'Invoice' THEN 'Factura' WHEN 'LoanMerchandise' THEN 'Mercancia Prestamo' WHEN 'PharmaceuticalDispensing' THEN 'Dispensación Farmaceutica' WHEN 'TransferOrder' THEN 'Orden Traslado' WHEN 'InventoryAdjustment' THEN 'Ajustes de Inventario' WHEN 'PharmaceuticalDispensingDevolution' THEN
            'Devolución de Dispensación' WHEN 'AccountPayable' THEN 'Cuentas x Pagar' WHEN 'RemissionEntrance' THEN 'Remision Entrada' WHEN 'RemissionReclassification' THEN 'Reclasificación de Remision' ELSE coco.EntityName END AS Documento, 
			 cuenta.Number AS cuenta, 
           coco.VoucherDate AS [Fecha comprobante], MONTH(coco.VoucherDate) AS Mes, 
		   --dcoco.DebitValue AS Débito, dcoco.CreditValue AS Crédito, 
		    T.Nit, T.Name AS Tercero,
		   ((SUM(dcoco.DebitValue) - SUM(dcoco.CreditValue))) * - 1 as Valor, datename(weekday,coco.VoucherDate) as DiaSemana
FROM   GeneralLedger.JournalVouchers AS coco  INNER JOIN
           GeneralLedger.JournalVoucherDetails AS dcoco  ON coco.Id = dcoco.IdAccounting INNER JOIN
           GeneralLedger.JournalVoucherTypes AS tcoco  ON coco.IdJournalVoucher = tcoco.Id INNER JOIN
           GeneralLedger.MainAccounts AS cuenta  ON cuenta.Id = dcoco.IdMainAccount INNER JOIN
           Common.ThirdParty AS T  ON T.Id = dcoco.IdThirdParty INNER JOIN      
          Payroll.CostCenter AS cc ON CC.Id = dcoco.IdCostCenter
WHERE  (cuenta.Number  like '41%') AND (cuenta.Number NOT IN ('4101080602', '4101080603', '4101080612')) AND (t .PersonType = '2') 
and (coco.VoucherDate >= '01-01-2020') --and (month(coco.VoucherDate) >= month(getdate())-2) 
and coco.Status ='2'  and tcoco.Code<>'21' and cuenta.LegalBookId='1' and tcoco.Code<>'0015'
group by CC.Code, CC.Name, tcoco.Name, coco.EntityCode , coco.EntityName, cuenta.Number,  coco.VoucherDate , tcoco.Code, T.Nit, T.Name
