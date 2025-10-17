-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_Billing_FacturaciónAnulada
-- Extracted by Fabric SQL Extractor SPN v3.9.0




create VIEW [ViewInternal].[IMO_Billing_FacturaciónAnulada]
AS
SELECT 
                  CASE f.DocumentType WHEN '1' THEN 'Factura EAPB con Contrato' WHEN '2' THEN 'Factura EAPB Sin Contrato' WHEN '3' THEN 'Factura Particular' WHEN '4' THEN 'Factura Capita' WHEN '5' THEN 'Control Capitacion' WHEN '6' THEN 'Factura Basica'
                   WHEN '7' THEN 'Factura Venta Productos' END AS [Tipo Documento], CASE ing.ICAUSAING WHEN '11' THEN 'Cirugía programada' END AS [Causa Ingreso], ing.UFUCODIGO + ' - ' + uf.UFUDESCRI AS [Unidad funcional], 
                  f.InvoiceNumber AS [Nro Documento], f.AdmissionNumber AS Ingreso, ea.Code + ' - ' + ea.Name AS [Entidad Administradora], t.Nit, t.DigitVerification AS [Dígito verificación], t.Name AS Entidad, f.PatientCode AS Identificación, 
                  p.IPNOMCOMP AS NombrePaciente, ga.Code + ' - ' + ga.Name AS [Grupo Atención], f.InvoiceDate AS [Fecha Factura], f.InvoiceExpirationDate AS [Fecha vencimiento], f.TotalInvoice AS [Vr Factura], f.ThirdPartySalesValue AS [Vr Entidad], 
                  f.ThirdPartyDiscountValue AS [Vr. Descuento], f.TotalPatientSalesPrice AS [Vr cuota recuperación], f.PatientDiscount AS [Descuento Cuota recuperación], f.CashReceiptId AS [Recibo Caja Paciente], 
                  f.PatientPaidValue AS [Vr pagado Paciente], f.ThirdPartyAccountReceivableValue AS [Vr CxC], f.PatientAccountReceivableValue AS [Vr CxC generada a Paciente], 
                  CASE f.PatientType WHEN '1' THEN 'Contributivo' WHEN '2' THEN 'Subsidiado' WHEN '3' THEN 'Vinculado' WHEN '4' THEN 'Particular' WHEN '5' THEN 'Otros' WHEN '6' THEN 'Desplazado Contributivo' WHEN '7' THEN 'Desplazado Subsidiado'
                   WHEN '8' THEN 'Desplazado no Asegurado' END AS [Tipo Paciente], f.Observation AS Observaciones, C.Name AS Categoría, CASE f.Status WHEN '1' THEN 'Facturado' WHEN '2' THEN 'Anulado' END AS Estado_Documento, 
                  f.InvoicedUser + ' - ' + per.Fullname AS Usuario, f.InvoicedDate AS Fecha, f.AnnulmentUser + ' - ' + ua.Fullname AS [Usuario Anula], f.AnnulmentDate AS [Fecha anulación], f.ReversalReasonId AS [Cód Causa Anulación], 
                  rv.Name AS [Causa Anulación], f.DescriptionReversal AS [Descripción Causa de anulación], ing.IFECHAING as FechaIngreso
FROM     Billing.Invoice AS f WITH (nolock) LEFT OUTER JOIN
                  dbo.INPACIENT AS p WITH (nolock) ON p.IPCODPACI = f.PatientCode LEFT OUTER JOIN
                  dbo.ADINGRESO AS ing WITH (nolock) ON ing.NUMINGRES = f.AdmissionNumber LEFT OUTER JOIN
                  Contract.CareGroup AS ga WITH (nolock) ON ga.Id = f.CareGroupId LEFT OUTER JOIN
                  Contract.HealthAdministrator AS ea WITH (nolock) ON ea.Id = f.HealthAdministratorId LEFT OUTER JOIN
                  Common.ThirdParty AS t WITH (nolock) ON t.Id = f.ThirdPartyId LEFT OUTER JOIN
                  Common.OperatingUnit AS uo WITH (nolock) ON uo.Id = f.OperatingUnitId LEFT OUTER JOIN
                  Security.[User] AS u  ON u.UserCode = f.InvoicedUser LEFT OUTER JOIN
                  Security.Person AS per  ON per.Id = u.IdPerson LEFT OUTER JOIN
                  Security.[User] AS uc  ON uc.UserCode = f.AnnulmentUser LEFT OUTER JOIN
                  Security.Person AS ua  ON ua.Id = uc.IdPerson LEFT OUTER JOIN
                  Billing.InvoiceCategories AS C WITH (nolock) ON C.Id = f.InvoiceCategoryId LEFT OUTER JOIN
                  dbo.INUNIFUNC AS uf WITH (nolock) ON uf.UFUCODIGO = ing.UFUCODIGO LEFT OUTER JOIN
                  Billing.BillingReversalReason AS rv ON rv.Id = f.ReversalReasonId
WHERE  (f.Status = '2')  and f.InvoiceDate>='01-01-2023'