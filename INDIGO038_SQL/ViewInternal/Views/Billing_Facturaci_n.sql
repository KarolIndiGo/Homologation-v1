-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Billing_Facturación
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[Billing_Facturación]
AS
SELECT  

           CASE f.DocumentType WHEN '1' THEN 'Factura EAPB con Contrato' WHEN '2' THEN 'Factura EAPB Sin Contrato' WHEN '3' THEN 'Factura Particular' WHEN '4' THEN 'Factura Capita' WHEN '5' THEN 'Control Capitacion' WHEN '6' THEN 'Factura Basica' WHEN '7' THEN 'Factura Venta Productos' END AS [Tipo Documento], 
           CASE ing.ICAUSAING WHEN '11' THEN 'Cirugía programada' END AS [Causa Ingreso], ing.UFUCODIGO + ' - ' + uf.UFUDESCRI  AS [Unidad funcional], f.InvoiceNumber AS [Nro Documento], f.AdmissionNumber AS Ingreso, ing.IFECHAING AS [Fecha Ingreso], eh.FECALTPAC AS [Fecha alta médica], 
           ea.Code + ' - ' + ea.Name AS [Entidad Administradora], t.Nit, t.DigitVerification AS [Dígito verificación], t.Name AS Entidad, 
		  f.PatientCode  AS Identificación, 
		   p.IPNOMCOMP  AS NombrePaciente, 
		   
		   ga.Code + ' - ' + ga.Name AS [Grupo Atención], f.InvoiceDate AS [Fecha Factura], f.InvoiceExpirationDate AS [Fecha vencimiento], 
           f.TotalInvoice AS [Vr Factura], f.ThirdPartySalesValue AS [Vr Entidad], f.ThirdPartyDiscountValue AS [Vr. Descuento], CASE f.ResponsibleRecoveryFee WHEN '1' THEN 'Ninguno' WHEN '2' THEN 'Paciente' WHEN '3' THEN 'Tercero' END AS [Responsable Cuota Recuperacion], f.TotalPatientSalesPrice AS [Vr cuota recuperación], 
           f.PatientDiscount AS [Descuento Cuota recuperación], f.CashReceiptId AS [Recibo Caja Paciente], f.PatientPaidValue AS [Vr pagado Paciente], f.ThirdPartyAccountReceivableValue AS [Vr CxC], f.PatientAccountReceivableValue AS [Vr CxC generada a Paciente], 
           CASE f.PatientType WHEN '1' THEN 'Contributivo' WHEN '2' THEN 'Subsidiado' WHEN '3' THEN 'Vinculado' WHEN '4' THEN 'Particular' WHEN '5' THEN 'Otros' WHEN '6' THEN 'Desplazado Contributivo' WHEN '7' THEN 'Desplazado Subsidiado' WHEN '8' THEN 'Desplazado no Asegurado' END AS [Tipo Paciente], 
           f.Observation AS Observaciones, C.Name AS Categoría, CASE f.Status WHEN '1' THEN 'Facturado' WHEN '2' THEN 'Anulado' END AS Estado_Documento, f.InvoicedUser + ' - ' + per.Fullname AS Usuario, f.InvoicedDate AS Fecha,
		   f.AnnulmentUser + ' - ' + ua.Fullname AS [Usuario Anula], f.AnnulmentDate AS [Fecha anulación] --case when a.tipo in ('Accidentes_de_transito','Fosyga') then 'SOAT' else 'GENERAL' END AS 'GRUPO', glosa.ValorGlosado, saldo.Balance as SaldoCartera
FROM   Billing.Invoice AS f WITH (nolock) LEFT OUTER JOIN
           dbo.INPACIENT AS p WITH (nolock) ON p.IPCODPACI = f.PatientCode AND f.InvoiceDate >= '01/01/2023 00:00:00' LEFT OUTER JOIN
           dbo.ADINGRESO AS ing WITH (nolock) ON ing.NUMINGRES  = f.AdmissionNumber LEFT OUTER JOIN
           Contract.CareGroup AS ga WITH (nolock) ON ga.Id = f.CareGroupId LEFT OUTER JOIN
           Contract.HealthAdministrator AS ea WITH (nolock) ON ea.Id = f.HealthAdministratorId LEFT OUTER JOIN
           Common.ThirdParty AS t WITH (nolock) ON t.Id = f.ThirdPartyId LEFT OUTER JOIN
           Common.OperatingUnit AS uo WITH (nolock) ON uo.Id = f.OperatingUnitId LEFT OUTER JOIN
           Security.[User] AS u  ON u.UserCode = f.InvoicedUser LEFT OUTER JOIN
           Security.Person AS per  ON per.Id = u.IdPerson LEFT OUTER JOIN
           Security.[User] AS uc  ON uc.UserCode = f.AnnulmentUser LEFT OUTER JOIN
           Security.Person AS ua ON ua.Id = uc.IdPerson LEFT OUTER JOIN
           Billing.InvoiceCategories AS C WITH (nolock) ON C.Id = f.InvoiceCategoryId LEFT OUTER JOIN
           dbo.INUNIFUNC AS uf WITH (nolock) ON uf.UFUCODIGO = ing.UFUCODIGO LEFT OUTER JOIN
           dbo.HCREGEGRE AS eh WITH (nolock) ON eh.NUMINGRES = f.AdmissionNumber AND eh.IPCODPACI = f.PatientCode
		   --LEFT OUTER JOIN  ReportesFinancieros.[DF].[Contract_EntidadesAdministradoras] as a  WITH (nolock) on a.id=f.HealthAdministratorId
		   --left outer join ReportesFinancieros.[GD].[Glosa_EstadisticoGlosas] as glosa  WITH (nolock) on glosa.Factura=f.InvoiceNumber
--		   left join 
--(SELECT B.InvoiceId, CASE WHEN FU.code LIKE 'N%' THEN 'Neiva' WHEN FU.code LIKE 'E%' THEN 'Abner' WHEN FU.code LIKE 'F%' THEN 'Florencia'  WHEN FU.code LIKE 'T%' THEN 'Tunja' 
--		   WHEN FU.code LIKE 'P%' THEN 'Pitalito'  end as sucursal, cu.Name as cliente, cu.nit ,fu.code  + ' - ' + fu.Name as uf
--FROM Billing.BasicBilling AS B with (nolock)
--INNER JOIN Billing.BasicBillingDetail AS BD with (nolock) ON BD.BasicBillingId=B.Id
--INNER JOIN Payroll.FunctionalUnit AS FU with (nolock) ON FU.Id=BD.FunctionalUnitId
--inner join Common.Customer as cu on cu.id=b.CustomerId
----WHERE InvoiceId='2693144'
--) as copa on copa.InvoiceId=f.Id
left join ( select invoicenumber, Balance
			from Portfolio.AccountReceivable  as pc with (nolock)
			where   (PC.Status <> '3')
      AND (PC.AccountReceivableType NOT IN ( '6'))) as saldo on saldo.InvoiceNumber=f.InvoiceNumber
WHERE  (f.InvoiceDate >= '01/01/2024 00:00:00')   --and f.InvoiceNumber='NEV1156268'
--and UF.UFUCODIGO like 'E%'
 --F.AdmissionNumber='5398387'
     AND (F.DocumentType <> '5')