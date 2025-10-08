-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_V_CXC_CARTERAXEDADES
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_V_CXC_CarteraXedades
AS

SELECT Sede,
       NroFactura,
       cuenta,
       TipoCxC,
       TipoDocumento,
       FechaIngreso,
       Nit,
       GrupoAtencion,
       GrupAtención,
       FechaFactura,
       FechaVencimiento,
       FechaRadicado,
       FechaConfirmaRadicado,
       Radicado,
       FechaVencimientoR,
       ValorFactura,
       SaldoTotal,
       COALESCE ([DEUDORES CLIENTES NACIONALES], 0)
          [DEUDORES CLIENTES NACIONALES],
       COALESCE ([FACTURACION RADICADA], 0)
          [FACTURACION RADICADA],
       COALESCE ([GLOSA SUBSANABLE], 0)
          [GLOSA SUBSANABLE],
       COALESCE ([CUENTAS DE CONCILIACION], 0)
          [CUENTAS DE CONCILIACION],
       COALESCE ([COBRO JURIDICO], 0)
          [COBRO JURIDICO],
       SaldoInicial,
       EdadFactura,
       EdadRadicado,
       EstadoRadicado,
       Entidad,
       TipoPersona,
       Identificacion,
       Paciente,
       FechaEgreso,
       EstadoFactura,
       Categoria,
       FechaModificacion,
       UsuarioModificacion,
       Contrato,
       Ingreso,
       DiasCartera,
       Detalle,
	   NitPB,
	   ClientePB
FROM (SELECT uo.UnitName
                AS 'Sede',
             C.InvoiceNumber
                AS 'NroFactura',
             cuentas.Number
                AS 'cuenta',
             CASE C.AccountReceivableType
                WHEN '1' THEN 'FacturacionBasica'
                WHEN '2' THEN 'FacturacionLey100'
                WHEN '3' THEN 'Impuestos'
                WHEN '4' THEN 'Pagarés'
                WHEN '5' THEN 'AcuerdosdePago'
                WHEN '6' THEN 'DocumentoPagoCuotaModeradora'
                WHEN '7' THEN 'FacturaProducto'
             END
                AS 'TipoCxC',
             CASE F.DocumentType
                WHEN '1' THEN 'Factura EAPB con Contrato'
                WHEN '2' THEN 'Factura EAPB Sin Contrato'
                WHEN '3' THEN 'Factura Particular'
                WHEN '4' THEN 'Factura Capita'
                WHEN '5' THEN 'Control Capitacion'
                WHEN '6' THEN 'Factura Basica'
                WHEN '7' THEN 'Factura Venta Productos'
                ELSE 'SaldoInicial'
             END
                AS 'TipoDocumento',
             I.IFECHAING
                AS 'FechaIngreso',
     CASE when TE.PersonType=1 then '999' else TE.Nit end as Nit ,      
             G.Code
                AS 'GrupoAtencion',
             G.Name
                AS GrupAtención,
             (C.AccountReceivableDate)
                AS 'FechaFactura',
             C.ExpiredDate
                AS 'FechaVencimiento',
             (RC.RadicatedDate)
                AS 'FechaRadicado',
             (RC.ConfirmDate)
                AS 'FechaConfirmaRadicado',
             (RC.RadicatedConsecutive)
                AS 'Radicado',
             (DATEADD (m, 2, ((RC.ConfirmDate))))
                AS 'FechaVencimientoR',
             C.Value
                AS 'ValorFactura',
             C.Balance
                AS 'SaldoTotal',
             C1.Name
                AS 'descri',
             D.Balance,
             CASE WHEN C.OpeningBalance = 'True' THEN 'SI' ELSE 'NO' END
                AS 'SaldoInicial',
             CASE
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) < 1 THEN '1. Sin Vencer'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) > 0
                AND DATEDIFF(DAY, C.ExpiredDate, GETDATE()) < 31 THEN '2. De 1 a 30 Dias'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) > 30
                AND DATEDIFF(DAY, C.ExpiredDate, GETDATE()) < 61 THEN '3. De 31 a 60 Dias'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) > 60
                AND DATEDIFF(DAY, C.ExpiredDate, GETDATE()) < 91 THEN '4. De 61 a 90 Dias'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) > 90
                AND DATEDIFF(DAY, C.ExpiredDate, GETDATE()) < 121 THEN '5. De 91 a 120 Dias'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) > 120
                AND DATEDIFF(DAY, C.ExpiredDate, GETDATE()) < 181 THEN '6. De 121 a 180 Dias'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) > 180
                AND DATEDIFF(DAY, C.ExpiredDate, GETDATE()) < 361 THEN '7. De 181 a 360 Dias'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) > 360 THEN 'Mayor a 360 Dias'
                END AS 'EdadFactura',
             CASE
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) < 1 THEN '1. Sin Vencer'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) > 0  AND DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) < 31  THEN '2. De 1 a 30 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) > 30 AND DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) < 61  THEN '3. De 31 a 60 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) > 60 AND DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) < 91  THEN '4. De 61 a 90 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) > 90 AND DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) < 121 THEN '5. De 91 a 120 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) > 120 AND DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) < 181 THEN '6. De 121 a 180 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) > 180 AND DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) < 361 THEN '7. De 181 a 360 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) > 360 THEN 'Mayor a 360 Dias'
                END AS 'EdadRadicado',
             CASE
                WHEN RC.State = '1' THEN 'SinConfirmar'
                WHEN RC.State = 2 THEN 'Confirmado'
                WHEN RC.State = '' THEN 'P'
             END
                AS 'EstadoRadicado',
            case when TE.PersonType=1 then 'PACIENTES  PARTICULARES' else TE.Name end AS Entidad,
             CASE TE.PersonType
                WHEN '1' THEN 'Naturales'
                WHEN '2' THEN 'Juridicas'
             END
                AS 'TipoPersona',
             F.PatientCode
                AS 'Identificacion',
             P.IPNOMCOMP
                AS 'Paciente',
             F.OutputDate
                AS 'FechaEgreso',
             CASE
                WHEN C.PortfolioStatus = '1' THEN 'SINRADICAR'
                WHEN C.PortfolioStatus = '2' THEN 'RADICADA SIN CONFIRMAR'
                WHEN C.PortfolioStatus = '3' THEN 'RADICADA ENTIDAD'
                WHEN C.PortfolioStatus = '7' THEN 'CERTIFICADA_PARCIAL'
                WHEN C.PortfolioStatus = '8' THEN 'CERTIFICADA_TOTAL'
                WHEN C.PortfolioStatus = '14' THEN 'DEVOLUCION_FACTURA'
                WHEN C.PortfolioStatus = '15' THEN 'TRASLADO_COBRO_JURIDICO'
             END
                AS 'EstadoFactura',
             categ.Name
                AS [Categoria],
             RC.ModificationDate
                AS 'FechaModificacion',
             RC.ModificationUser
                AS 'UsuarioModificacion',
             rtrim (cont.Code) + ' - ' + rtrim (cont.ContractName)
                AS Contrato,
             F.AdmissionNumber
                AS Ingreso,
             DATEDIFF(DAY, RC.ConfirmDate, GETDATE())
                AS DiasCartera,
             dip.Description
                AS Detalle,
				CASE when TE.PersonType=1 then '999' else TE.Nit end as NitPB , 
case when TE.PersonType=1 then 'PARTICULARES' else TE.Name end AS ClientePB 
      FROM [INDIGO035].[Portfolio].[AccountReceivable] AS C 
           INNER JOIN
           [INDIGO035].[Portfolio].[AccountReceivableAccounting] AS D 
              ON C.Id = D.AccountReceivableId
           INNER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] C1
              ON D.MainAccountId = C1.Id
           JOIN /*[INDIGOQ].dbo.TemCuenta AS T  ON D .MainAccountId = T .Idcuenta INNER JOIN*/
                [INDIGO035].[Portfolio].[AccountReceivableShare] AS S 
              ON C.Id = S.AccountReceivableId
           INNER JOIN [INDIGO035].[Common].[ThirdParty] AS TE 
              ON C.ThirdPartyId = TE.Id
           LEFT OUTER JOIN [INDIGO035].[Billing].[Invoice] AS F 
              ON C.InvoiceNumber = F.InvoiceNumber
           LEFT OUTER JOIN
           [INDIGO035].[Portfolio].[RadicateInvoiceD] AS RD 
              ON C.InvoiceNumber = RD.InvoiceNumber AND RD.State <> '4'
           LEFT OUTER JOIN
           [INDIGO035].[Portfolio].[RadicateInvoiceC] AS RC 
              ON RD.RadicateInvoiceCId = RC.Id AND RC.State <> '4'
           LEFT OUTER JOIN [INDIGO035].[dbo].ADINGRESO AS I 
              ON F.AdmissionNumber = I.NUMINGRES
           LEFT OUTER JOIN [INDIGO035].[dbo].INPACIENT AS P 
              ON P.IPCODPACI = F.PatientCode
           LEFT OUTER JOIN [INDIGO035].[Contract].[CareGroup] AS G 
              ON F.CareGroupId = G.Id
           LEFT OUTER JOIN [INDIGO035].[Contract].[Contract] AS cont 
              ON cont.Id = G.ContractId
           LEFT OUTER JOIN
           [INDIGO035].[Contract].[ContractAccountingStructure] AS SC 
              ON SC.Id = G.ContractAccountingStructureId
           LEFT OUTER JOIN [INDIGO035].[Common].[OperatingUnit] AS uo 
              ON uo.Id = C.OperatingUnitId
           LEFT OUTER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS cuentas
              ON cuentas.Id = SC.AccountWithoutRadicateId
           LEFT OUTER JOIN [INDIGO035].[Billing].[InvoiceCategories] AS categ
              ON categ.Id = F.InvoiceCategoryId
           LEFT OUTER JOIN
           [INDIGO035].[Inventory].[DocumentInvoiceProductSales] AS dip
              ON dip.InvoiceId = F.Id
      WHERE C.Balance > 0         /*AND C.AccountReceivableType NOT IN ('6')*/
                          AND C.Status <> 3) source
     PIVOT (SUM (source.Balance)
           FOR source.descri
           IN ([DEUDORES CLIENTES NACIONALES],
               [FACTURACION RADICADA],
               [GLOSA SUBSANABLE],
               [CUENTAS DE CONCILIACION],
               [COBRO JURIDICO])) AS PIVOTABLE