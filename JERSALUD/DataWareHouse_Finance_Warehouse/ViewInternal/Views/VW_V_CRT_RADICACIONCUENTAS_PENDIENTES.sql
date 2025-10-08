-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_CRT_RADICACIONCUENTAS_PENDIENTES
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VW_V_CRT_RADICACIONCUENTAS_PENDIENTES] AS
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
                              f.Status AS [Estado factura],
                              CASE
                                  WHEN f.InvoiceNumber LIKE ''
                                  THEN 'Bogota'
                                  WHEN f.InvoiceNumber LIKE 'JT%'
                                  THEN 'Boyaca'
                                  WHEN f.InvoiceNumber LIKE 'JV%'
                                  THEN 'Meta'
                                  WHEN f.InvoiceNumber LIKE 'JY%'
                                  THEN 'Yopal'
                              END AS Regional
     FROM INDIGO031.Portfolio.AccountReceivable AS PC 
          LEFT OUTER JOIN INDIGO031.Billing.Invoice AS f ON PC.InvoiceId = f.Id
                                                                    AND f.Status <> '2'
          LEFT OUTER JOIN INDIGO031.Contract.HealthAdministrator AS ea ON ea.Id = f.HealthAdministratorId
          LEFT OUTER JOIN INDIGO031.Portfolio.RadicateInvoiceD AS dr ON dr.InvoiceNumber = PC.InvoiceNumber
                                                                                AND dr.State <> '4'
          LEFT OUTER JOIN INDIGO031.Portfolio.RadicateInvoiceC AS cr ON cr.Id = dr.RadicateInvoiceCId
                                                                                AND cr.State <> '4'
          LEFT OUTER JOIN INDIGO031.dbo.INPACIENT AS p ON p.IPCODPACI = f.PatientCode
          LEFT OUTER JOIN INDIGO031.dbo.ADINGRESO AS ing ON ing.NUMINGRES = f.AdmissionNumber
          LEFT OUTER JOIN INDIGO031.Contract.CareGroup AS ga ON ga.Id = f.CareGroupId
                                                                        AND ga.CareGroupType <> '3'
          LEFT OUTER JOIN INDIGO031.Common.ThirdParty AS t ON t.Id = PC.ThirdPartyId
          LEFT OUTER JOIN INDIGO031.Common.OperatingUnit AS uo ON uo.Id = PC.OperatingUnitId
          LEFT OUTER JOIN INDIGO031.dbo.SEGusuaru AS uc ON uc.CODUSUARI = PC.CreationUser
     WHERE
           (PC.AccountReceivableType = '2')
          AND (PC.SellerId IS NULL)
          AND (PC.AccountReceivableDate >= '20180101')
          AND (PC.Balance > 0)
--and ing.NUMINGRES='C03C9429A9'

