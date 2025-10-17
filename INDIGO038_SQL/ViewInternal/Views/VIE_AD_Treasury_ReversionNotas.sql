-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Treasury_ReversionNotas
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VIE_AD_Treasury_ReversionNotas]
AS
SELECT CASE N .NoteType WHEN 3 THEN 'Anulación de Comprobante de Egreso' WHEN 4 THEN 'Anulación de Recibo de caja' when 5 then 'Reversión de Consignación' END AS TipoNota, N.Code AS Nota, N.Description AS DescripcionNota, RTRIM(U.CODUSUARI) + ' - ' + U.NOMUSUARI AS UsuarioReversa, N.NoteDate AS FechaReversion, 
           CASE WHEN N .CashReceiptId IS NOT NULL THEN C.CODE 
				WHEN N .CashReceiptId IS NULL and v.code is null then co.code else  v.Code  END AS DocumentoReversado, 
		   CASE WHEN N .CashReceiptId IS NOT NULL THEN C.Value
				WHEN N .CashReceiptId IS NULL and v.code is null then co.value else V.Value END AS [Valor Documento Reversado], 
		   CASE WHEN N .CashReceiptId IS NOT NULL THEN c.CreationDate 
				WHEN N .CashReceiptId IS NULL and v.code is null then co.creationdate ELSE V.CreationDate END AS [Fecha Documento], 
		   CASE WHEN N .CashReceiptId IS NOT NULL THEN u1.NOMUSUARI 
				WHEN N .CashReceiptId IS NULL and v.code is null then u3.nomusuari ELSE U2.NOMUSUARI END AS [Usuario Documento], 
		   CASE n.Status WHEN 1 THEN 'Registrado' WHEN 2 THEN 'Confirmado' WHEN 3 THEN 'Anulado' END AS EstadoNota
FROM   .Treasury.TreasuryNote AS N  LEFT OUTER JOIN
           .Treasury.CashReceipts AS C  ON C.Id = N.CashReceiptId LEFT OUTER JOIN
           .Treasury.VoucherTransaction AS V  ON V.Id = N.VoucherTransactionId LEFT OUTER JOIN
           ..dbo.SEGusuaru AS U  ON U.CODUSUARI = N.CreationUser LEFT OUTER JOIN
           ..dbo.SEGusuaru AS U1  ON U1.CODUSUARI = C.CreationUser LEFT OUTER JOIN
           ..dbo.SEGusuaru AS U2  ON U2.CODUSUARI = V.CreationUser LEFT OUTER JOIN
		   .Treasury.Consignment AS CO  ON CO.ID=N.ConsignmentId left outer join
		   ..dbo.SEGusuaru AS U3  ON U3.CODUSUARI = co.CreationUser 
WHERE (N.NoteType IN ('3', '4','5'))
