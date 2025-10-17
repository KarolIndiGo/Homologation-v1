-- Workspace: SQLServer
-- Item: INDIGO026 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: FQ45_V_CXP_NotasCartera2023
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[FQ45_V_CXP_NotasCartera2023]
AS
SELECT        NCXP.Id, NCXP.Code AS Nota, CASE NCXP.Status WHEN 1 THEN 'REGISTRADO' WHEN 2 THEN 'CONFIRMADO' WHEN 3 THEN 'ANULADO' END AS [Estado de Nota], NCXP.NoteDate AS [Fecha de Nota], PRO.Code AS NIT, 
                         PRO.Name AS Cliente, NCXP.Comment AS Observaciones, CASE NCXP.Nature WHEN 1 THEN 'DEBITO' WHEN 2 THEN 'CREDITO' END AS Naturaleza, NPA.AdjusmentValue AS [Valor Nota], CXP.BillNumber AS Factura, 
                         NPA.PreviousBalance AS [Valor de la Factura], NCXP.CreationUser AS CodCreacion, USU.Fullname AS [Usuario Creacion], NCXP.ConfirmationUser AS CodConfirmacion, USU.Fullname AS [Usuario Confirma]
FROM            Payments.PaymentNotes AS NCXP INNER JOIN
                         Common.Supplier AS PRO ON PRO.Id = NCXP.IdSupplier INNER JOIN
                         Payments.PaymentNotesAccountPayableAdvance AS NPA ON NPA.PaymentNoteId = NCXP.Id INNER JOIN
                         Payments.AccountPayable AS CXP ON NPA.AccountPayableId = CXP.Id INNER JOIN
                         Security.Person AS USU ON USU.Identification = NCXP.CreationUser
WHERE        (YEAR(NCXP.NoteDate) >= '2023')
						
