-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Portfolio_CarteraXEdades
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Portfolio_CarteraXEdades]
AS
     SELECT DISTINCT
            (AR.InvoiceNumber) AS Factura, 
            TPAR.Nit AS [Nit], 
            TPAR.Name AS Tercero,
            CASE PAR.IdentificationType
                WHEN 0
                THEN 'Cédula de Ciudadanía'
                WHEN 1
                THEN 'Cédula de Extranjería'
                WHEN 2
                THEN 'Tarjeta de Identidad'
                WHEN 3
                THEN 'Registro Civil'
                WHEN 4
                THEN 'Pasporte'
                WHEN 5
                THEN 'Adulto Sin Identificación'
                WHEN 6
                THEN 'Menor Sin Identificación'
                WHEN 7
                THEN 'Nit'
            END TipoIdentificacion,

            /*TPAR.Nit AS [Nit Cliente], TPS.Nit AS SellerNit,*/

            CASE AR.AccountReceivableType
                WHEN 1
                THEN AR.AccountReceivableDate
                ELSE RADICATE.DocumentDate
            END AS [Fecha radicado], 
            DATEADD(day, AR.Term,
                            CASE AR.AccountReceivableType
                                WHEN 1
                                THEN AR.AccountReceivableDate
                                ELSE RADICATE.ConfirmDate
                            END) AS [Fecha Vencimiento],

            /*, ISNULL(RADICATE.ConfirmDate, CASE AR.AccountReceivableType WHEN 1 THEN AR.AccountReceivableDate ELSE CONVERT(datetime, '1990-01-01 00:00:00', 120) END) AS DocumentDateCalculated*/
            /*  ISNULL(RADICATE.ConfirmDate, CASE AR.AccountReceivableType WHEN 1 THEN AR.AccountReceivableDate ELSE GETDATE() END) AS expiredDateCalculated,*/

            DATEDIFF(DAY, ISNULL(RADICATE.ConfirmDate,
                                          CASE AR.AccountReceivableType
                                              WHEN 1
                                              THEN AR.AccountReceivableDate
                                              ELSE GETDATE()
                                          END), GETDATE()) AS Diferencia, 
            i.totalinvoice AS TotalFactura, 
            AR.Balance AS SaldoTotal,
            CASE AR.AccountReceivableType
                WHEN '1'
                THEN 'FacturacionBasica'
                WHEN '2'
                THEN 'FacturacionLey100'
                WHEN '3'
                THEN 'Impuestos'
                WHEN '4'
                THEN 'Pagarés'
                WHEN '5'
                THEN 'AcuerdosdePago'
                WHEN '6'
                THEN 'DocumentoPagoCuotaModeradora'
                WHEN '7'
                THEN 'FacturaProducto'
            END AS 'TipoCxC',
            CASE i.DocumentType
                WHEN '1'
                THEN 'Factura EAPB con Contrato'
                WHEN '2'
                THEN 'Factura EAPB Sin Contrato'
                WHEN '3'
                THEN 'Factura Particular'
                WHEN '4'
                THEN 'Factura Capita'
                WHEN '5'
                THEN 'Control Capitacion'
                WHEN '6'
                THEN 'Factura Basica'
                WHEN '7'
                THEN 'Factura Venta Productos'
                ELSE 'SaldoInicial'
            END AS 'TipoDocumento',
            CASE
                WHEN CAST(GETDATE() - ar.ExpiredDate AS INT) < 1
                THEN '1. Sin Vencer'
                WHEN CAST(GETDATE() - ar.ExpiredDate AS INT) > 0
                     AND CAST(GETDATE() - ar.ExpiredDate AS INT) < 31
                THEN '2. De 1 a 30 Dias'
                WHEN CAST(GETDATE() - ar.ExpiredDate AS INT) > 30
                     AND CAST(GETDATE() - ar.ExpiredDate AS INT) < 61
                THEN '3. De 31 a 60 Dias'
                WHEN CAST(GETDATE() - ar.ExpiredDate AS INT) > 60
                     AND CAST(GETDATE() - ar.ExpiredDate AS INT) < 91
                THEN '4. De 61 a 90 Dias'
                WHEN CAST(GETDATE() - ar.ExpiredDate AS INT) > 90
                     AND CAST(GETDATE() - ar.ExpiredDate AS INT) < 121
                THEN '5. De 91 a 120 Dias'
                WHEN CAST(GETDATE() - ar.ExpiredDate AS INT) > 120
                     AND CAST(GETDATE() - ar.ExpiredDate AS INT) < 181
                THEN '6. De 121 a 180 Dias'
                WHEN CAST(GETDATE() - ar.ExpiredDate AS INT) > 180
                     AND CAST(GETDATE() - ar.ExpiredDate AS INT) < 361
                THEN '7. De 181 a 360 Dias'
                WHEN CAST(GETDATE() - ar.ExpiredDate AS INT) > 360
                THEN 'Mayor a 360 Dias'
            END AS 'EdadFactura',
            CASE
                WHEN CAST(GETDATE() - ar.AccountReceivableDate AS INT) < 1
                THEN '1. Sin Vencer'
                WHEN CAST(GETDATE() - ar.AccountReceivableDate AS INT) > 0
                     AND CAST(GETDATE() - ar.AccountReceivableDate AS INT) < 31
                THEN '2. De 1 a 30 Dias'
                WHEN CAST(GETDATE() - ar.AccountReceivableDate AS INT) > 30
                     AND CAST(GETDATE() - ar.AccountReceivableDate AS INT) < 61
                THEN '3. De 31 a 60 Dias'
                WHEN CAST(GETDATE() - ar.AccountReceivableDate AS INT) > 60
                     AND CAST(GETDATE() - ar.AccountReceivableDate AS INT) < 91
                THEN '4. De 61 a 90 Dias'
                WHEN CAST(GETDATE() - ar.AccountReceivableDate AS INT) > 90
                     AND CAST(GETDATE() - ar.AccountReceivableDate AS INT) < 121
                THEN '5. De 91 a 120 Dias'
                WHEN CAST(GETDATE() - ar.AccountReceivableDate AS INT) > 120
                     AND CAST(GETDATE() - ar.AccountReceivableDate AS INT) < 181
                THEN '6. De 121 a 180 Dias'
                WHEN CAST(GETDATE() - ar.AccountReceivableDate AS INT) > 180
                     AND CAST(GETDATE() - ar.AccountReceivableDate AS INT) < 361
                THEN '7. De 181 a 360 Dias'
                WHEN CAST(GETDATE() - ar.AccountReceivableDate AS INT) > 360
                THEN 'Mayor a 360 Dias'
            END AS 'EdadCuenta',
            CASE AR.PortfolioStatus
                WHEN 1
                THEN 'Sin Radicar'
                WHEN 2
                THEN 'Radicada Sin Confirmar'
                WHEN 3
                THEN 'Radicada Entidad'
                WHEN 7
                THEN 'Certificada Parcial'
                WHEN 8
                THEN 'Certificado Total'
                WHEN 14
                THEN 'Devolucion Factura'
                WHEN 15
                THEN 'Cuenta de Dificil Recaudo'
            END Estado,

            /*AR.OpeningBalance, 1 AS AdvanceOrAccountReceivable, cg.EntityType AS Regimen, cg.Code AS CodeCareGroup, cg.Name AS NameCareGroup,*/

            MA.Number AS Cuenta,

            /*RADICATE.RadicatedConsecutive, CASE AR.AccountReceivableType WHEN 1 THEN AR.AccountReceivableDate ELSE RADICATE.ConfirmDate END AS RadicatedDate, CAST(RADICATE.CreationUser AS varchar(20)) AS RadicatedUser,*/
/*CASE MA.Number WHEN '14090103' THEN 'Contributivo' WHEN '14090304' THEN 'Subsidiado' WHEN '14090401' THEN 'Servicio IPS Privada' WHEN '14090501' THEN 'Medicina Prepagada' WHEN '14090601' THEN 'Compañias Aseguradoras' WHEN '14090701' THEN 'Particulares' WHEN '14090901' THEN 'Servicio IPS Publicas' WHEN '14091004'
            THEN 'Regimen Especial' WHEN '14091102' THEN 'Vinculados - Departamentos' WHEN '14091103' THEN 'Vinculados Municipios' WHEN '14091201' THEN 'Arl Riesgos Profesionales' WHEN '14091403' THEN 'Accidentes de Transito' WHEN '14090201' THEN 'Otras Cuentas X Cobrar' END AS RegimenCalculated, */

            AR.AccountReceivableDate AS [Fecha Factura]

     /* RADICATE.StateC, RADICATE.StateD, AR.Id AS AccountReceivableId,*/

     FROM Portfolio.AccountReceivable AS AR 
          INNER JOIN
     (
         SELECT AccountReceivableId, 
                SUM(DebitValue) AS DebitValue, 
                SUM(CreditValue) AS CreditValue, 
                SUM(TransferValue + PaymentValue + CrossingValue) AS PaymentValue
         FROM Portfolio.AccountReceivableShare
         GROUP BY AccountReceivableId
     ) AS shared ON shared.AccountReceivableId = AR.Id
          INNER JOIN Common.ThirdParty AS TPAR  ON TPAR.Id = AR.ThirdPartyId
          INNER JOIN Common.Person AS PAR  ON PAR.Id = TPAR.PersonId
          LEFT OUTER JOIN Common.Seller AS S  ON S.Id = AR.SellerId
          LEFT OUTER JOIN Common.ThirdParty AS TPS  ON TPS.Id = S.ThirdPartyId
          LEFT OUTER JOIN Billing.Invoice AS i  ON i.Id = AR.InvoiceId
          LEFT OUTER JOIN Billing.InvoiceDetailProductSales AS dps ON dps.invoiceid = i.id
          LEFT OUTER JOIN Inventory.DocumentInvoiceProductSales AS dip ON dip.id = dps.DocumentInvoiceProductSalesdetailid
          LEFT OUTER JOIN Billing.InvoiceCategories AS IC ON IC.Id = AR.InvoiceCategoryId
          LEFT OUTER JOIN Contract.CareGroup AS cg  ON cg.Id = i.CareGroupId
          LEFT OUTER JOIN GeneralLedger.MainAccounts AS MA  ON MA.Id = AR.AccountWithoutRadicateId
          LEFT OUTER JOIN .ADINGRESO AS Ing  ON i.AdmissionNumber = Ing.NUMINGRES
          LEFT OUTER JOIN Portfolio.RadicateInvoiceD AS RD  ON ar.InvoiceNumber = RD.InvoiceNumber
                                                                                 AND RD.State <> '4'
          LEFT OUTER JOIN Portfolio.RadicateInvoiceC AS RC  ON RD.RadicateInvoiceCId = RC.Id
                                                                                 AND RC.state <> '4'
          LEFT OUTER JOIN
     (
         SELECT RIC.DocumentDate, 
                RIC.ConfirmDate, 
                RIC.RadicatedConsecutive, 
                RIC.RadicatedDate, 
                RID.InvoiceNumber, 
                RIC.CreationUser, 
                RID.InvoiceDate, 
                RIC.State AS StateC, 
                RID.State AS StateD
         FROM Portfolio.RadicateInvoiceD AS RID 
              INNER JOIN Portfolio.RadicateInvoiceC AS RIC  ON RIC.Id = RID.RadicateInvoiceCId
                                                                                 AND ISNULL(RID.State, 0) = 2
                                                                                 AND RIC.State = 2
     ) AS RADICATE ON RADICATE.InvoiceNumber = AR.InvoiceNumber
     WHERE(AR.Balance <> 0)
          AND ar.AccountReceivableType NOT IN('6')
          AND ar.STATUS <> 3;

/*AND (AR.Status = 2) AND (AR.AccountReceivableType IN (1, 2)) */

