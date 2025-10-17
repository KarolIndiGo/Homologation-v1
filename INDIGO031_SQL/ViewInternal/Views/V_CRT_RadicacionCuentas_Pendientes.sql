-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_CRT_RadicacionCuentas_Pendientes
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[V_CRT_RadicacionCuentas_Pendientes]
AS
     SELECT TOP (100) PERCENT uo.UnitName AS Sede, 
                              PC.InvoiceNumber AS Nro_Factura,
                              CASE AccountReceivableType
                                  WHEN '1'
                                  THEN 'Facturación Básica'
                                  WHEN '2'
                                  THEN 'Facturación Ley 100'
                                  WHEN '3'
                                  THEN 'Impuestos'
                                  WHEN '4'
                                  THEN 'Pagarés'
                                  WHEN '5'
                                  THEN 'Acuerdos de Pago'
                                  WHEN '6'
                                  THEN 'Documento de Pago a Cuota Moderadora'
                                  WHEN '7'
                                  THEN 'Factura de Producto'
                              END AS [Tipo CxC], 
                              ing.NUMINGRES AS Ingreso, 
                              ea.HealthEntityCode AS Entidad_Administradora, 
                              t.Nit, 
                              t.DigitVerification AS [Dígito verificación], 
                              t.Name AS Entidad, 
                              f.PatientCode AS Identificación, 
                              p.IPNOMCOMP AS NombrePaciente, 
                              ga.Code + ' - ' + ga.Name AS [Grupo Atención], 
                              PC.AccountReceivableDate AS [Fecha Factura], 
                              f.InvoiceExpirationDate AS [Fecha vencimiento], 
                              PC.Value AS Vr_Factura, 
                              PC.Balance AS [Saldo Total],
                              CASE PC.PortfolioStatus
                                  WHEN '1'
                                  THEN 'SIN RADICAR'
                                  WHEN '2'
                                  THEN 'RADICADA SIN CONFIRMAR'
                                  WHEN '3'
                                  THEN 'RADICADA ENTIDAD'
                                  WHEN '7'
                                  THEN 'CERTIFICADA_PARCIAL'
                                  WHEN '8'
                                  THEN 'CERTIFICADA_TOTAL'
                                  WHEN '14'
                                  THEN 'DEVOLUCION_FACTURA'
                                  WHEN '15'
                                  THEN 'TRASLADO COBRO JURÍDICO CONFIRMADO'
                              END AS Estado_Factura_Cartera, 
                              cr.RadicatedConsecutive AS [Nro Radicado], 
                              cr.ConfirmDate AS [Fecha confirmación], 
                              PC.Observations AS [Origen Factura], 
                              uc.NOMUSUARI AS Usuario, 
                              cr.RadicatedDate AS [Fecha Radicado], 
                              f.STATUS AS [Estado factura],
                              CASE
                                  WHEN F.InvoiceNumber LIKE ''
                                  THEN 'Bogota'
                                  WHEN F.InvoiceNumber LIKE 'JT%'
                                  THEN 'Boyaca'
                                  WHEN F.InvoiceNumber LIKE 'JV%'
                                  THEN 'Meta'
                                  WHEN F.InvoiceNumber LIKE 'JY%'
                                  THEN 'Yopal'
                              END AS Regional
     FROM Portfolio.AccountReceivable AS PC 
          LEFT OUTER JOIN Billing.Invoice AS f ON PC.InvoiceId = f.Id
                                                                    AND f.STATUS <> '2'
          LEFT OUTER JOIN Contract.HealthAdministrator AS ea ON ea.Id = f.HealthAdministratorId
          LEFT OUTER JOIN Portfolio.RadicateInvoiceD AS dr ON dr.InvoiceNumber = PC.InvoiceNumber
                                                                                AND dr.State <> '4'
          LEFT OUTER JOIN Portfolio.RadicateInvoiceC AS cr ON cr.Id = dr.RadicateInvoiceCId
                                                                                AND cr.State <> '4'
          LEFT OUTER JOIN dbo.INPACIENT AS p ON p.IPCODPACI = f.PatientCode
          LEFT OUTER JOIN dbo.ADINGRESO AS ing ON ing.NUMINGRES = f.AdmissionNumber
          LEFT OUTER JOIN Contract.CareGroup AS ga ON ga.Id = f.CareGroupId
                                                                        AND ga.CareGroupType <> '3'
          LEFT OUTER JOIN Common.ThirdParty AS t ON t.Id = PC.ThirdPartyId
          LEFT OUTER JOIN Common.OperatingUnit AS uo ON uo.Id = PC.OperatingUnitId
          LEFT OUTER JOIN dbo.SEGusuaru AS uc ON uc.CODUSUARI = PC.CreationUser
     WHERE
           (PC.AccountReceivableType = '2')
          AND (PC.SellerId IS NULL)
          AND (PC.AccountReceivableDate >= '20180101')
          AND (PC.Balance > 0)
--and ing.NUMINGRES='C03C9429A9'

