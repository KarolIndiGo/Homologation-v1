-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_CXC_CARTERAXEDADES
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VW_V_CXC_CARTERAXEDADES] 
AS

--SELECT COUNT(*) FROM [ViewInternal].[VW_CXC_CARTERAXEDADES]

SELECT   
    ejemplo.Sede, 
    ejemplo.NroFactura, 
    NCV.CUV,
    CASE WHEN ejemplo.cuenta IS NULL THEN nuevo.cuenta ELSE ejemplo.cuenta END AS cuenta,
    ejemplo.TipoCxC, 
    ejemplo.TipoDocumento, 
    CASE WHEN ejemplo.FechaIngreso IS NULL THEN nuevo.FechaIngreso ELSE ejemplo.FechaIngreso END AS FechaIngreso,
    ejemplo.Nit, 
    CASE WHEN ejemplo.GrupoAtencion IS NULL THEN nuevo.GrupoAtencion ELSE ejemplo.GrupAtención END AS GrupoAtencíon,
    ejemplo.FechaFactura, 
    ejemplo.FechaVencimiento, 
    CASE WHEN ejemplo.FechaRadicado IS NULL THEN nuevo.FechaRadicado ELSE ejemplo.FechaRadicado END AS FechaRadicado,
    CASE WHEN ejemplo.FechaConfirmaRadicado IS NULL THEN nuevo.FechaConfirmaRadicado ELSE ejemplo.FechaConfirmaRadicado END AS FechaConfirmaRadicado,
    CASE WHEN ejemplo.Radicado IS NULL THEN nuevo.Radicado ELSE ejemplo.Radicado END AS Radicado,
    CASE WHEN ejemplo.FechaVencimientoR IS NULL THEN nuevo.FechaVencimientoR ELSE ejemplo.FechaVencimientoR END AS FechaVencimientoR,
    ejemplo.ValorFactura, 
    ejemplo.SaldoTotal, 
    ejemplo.SinRadicar1301, 
    ejemplo.Radicada1302, 
    ejemplo.Glosada1303, 
    ejemplo.PJuridico1304, 
    ejemplo.Conciliada1305, 
    ejemplo.SaldoInicial, 
    ejemplo.EdadFactura, 
    CASE WHEN ejemplo.EdadRadicado IS NULL THEN nuevo.EdadRadicado ELSE ejemplo.EdadRadicado END AS EdadRadicado,
    CASE WHEN ejemplo.EstadoRadicado IS NULL THEN nuevo.EstadoRadicado ELSE ejemplo.EstadoRadicado END AS EstadoRadicado,
    ejemplo.Entidad, 
    ejemplo.TipoPersona, 
    CASE ejemplo.IPTIPODOC
         WHEN 1  THEN 'CC - Cédula de Ciudadanía'
         WHEN 2  THEN 'CE - Cédula de Extranjería'
         WHEN 3  THEN 'TI - Tarjeta de Identidad'
         WHEN 4  THEN 'RC - Registro Civil'
         WHEN 5  THEN 'PA - Pasaporte'
         WHEN 6  THEN 'AS - Adulto Sin Identificación'
         WHEN 7  THEN 'MS - Menor Sin Identificación'
         WHEN 8  THEN 'NU - Número Único de Identificación Personal'
         WHEN 9  THEN 'CN - Certificado de Nacido Vivo'
         WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)'
         WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
         WHEN 12 THEN 'PE - Permiso Especial de Permanencia (Aplica para extranjeros)'
         WHEN 13 THEN 'PT - Permiso Temporal de Permanencia'
         WHEN 14 THEN 'DE - Documento Extranjero'
         WHEN 15 THEN 'SI - Sin Identificación'
         ELSE 'No Definido'
    END AS TipoDocumentoNombre,
    CASE WHEN ejemplo.Identificacion IS NULL THEN nuevo.Identificacion ELSE ejemplo.Identificacion END AS Identificacion,
    CASE WHEN ejemplo.Paciente IS NULL THEN nuevo.Paciente ELSE ejemplo.Paciente END AS Paciente,
    CASE WHEN ejemplo.FechaEgreso IS NULL THEN nuevo.FechaEgreso ELSE ejemplo.FechaEgreso END AS FechaEgreso,
    ejemplo.EstadoFactura, 
    CASE WHEN ejemplo.Categoria IS NULL THEN nuevo.Categoria ELSE ejemplo.Categoria END AS Categoria,
    CASE WHEN ejemplo.FechaModificacion IS NULL THEN nuevo.FechaModificacion ELSE ejemplo.FechaModificacion END AS FechaModificacion,
    CASE WHEN ejemplo.UsuarioModificacion IS NULL THEN nuevo.UsuarioModificacion ELSE ejemplo.UsuarioModificacion END AS UsuarioModificacion,
    CASE WHEN ejemplo.Contrato IS NULL THEN nuevo.Contrato ELSE ejemplo.Contrato END AS Contrato,
    CASE WHEN ejemplo.Ingreso IS NULL THEN nuevo.Ingreso ELSE ejemplo.Ingreso END AS Ingreso,
    CASE WHEN ejemplo.DiasCartera IS NULL THEN nuevo.DiasCartera ELSE ejemplo.DiasCartera END AS DiasCartera, 
    CASE WHEN Ajuste IS NULL THEN 'No' ELSE 'Si' END AS TieneNota, 
    ABS(Ajuste) AS ValorNota
FROM
(
    SELECT 
        Sede, 
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
        COALESCE(SinRadicar1301, 0) SinRadicar1301, 
        COALESCE(Radicada1302, 0) Radicada1302, 
        COALESCE(Glosada1303, 0) Glosada1303, 
        COALESCE(PJuridico1304, 0) PJuridico1304, 
        COALESCE(Conciliada1305, 0) Conciliada1305, 
        SaldoInicial, 
        EdadFactura, 
        EdadRadicado, 
        EstadoRadicado, 
        Entidad, 
        TipoPersona, 
        IPTIPODOC,
        Identificacion, 
        Paciente, 
        FechaEgreso, 
        EstadoFactura, 
        Categoria, 
        FechaModificacion, 
        UsuarioModificacion, 
        Contrato, 
        Ingreso, 
        DiasCartera
    FROM
    (
        SELECT 
            uo.UnitName AS 'Sede', 
            C.InvoiceNumber AS 'NroFactura', 
            cuentas.Number AS 'cuenta',
            CASE C.AccountReceivableType
                WHEN '1' THEN 'FacturacionBasica'
                WHEN '2' THEN 'FacturacionLey100'
                WHEN '3' THEN 'Impuestos'
                WHEN '4' THEN 'Pagarés'
                WHEN '5' THEN 'AcuerdosdePago'
                WHEN '6' THEN 'DocumentoPagoCuotaModeradora'
                WHEN '7' THEN 'FacturaProducto'
            END AS 'TipoCxC',
            CASE F.DocumentType
                WHEN '1' THEN 'Factura EAPB con Contrato'
                WHEN '2' THEN 'Factura EAPB Sin Contrato'
                WHEN '3' THEN 'Factura Particular'
                WHEN '4' THEN 'Factura Capita'
                WHEN '5' THEN 'Control Capitacion'
                WHEN '6' THEN 'Factura Basica'
                WHEN '7' THEN 'Factura Venta Productos'
                ELSE 'SaldoInicial'
            END AS 'TipoDocumento', 
            I.IFECHAING AS 'FechaIngreso', 
            TE.Nit AS 'Nit', 
            G.Code AS 'GrupoAtencion', 
            G.Name AS GrupAtención, 
            C.AccountReceivableDate AS 'FechaFactura', 
            C.ExpiredDate AS 'FechaVencimiento', 
            RC.RadicatedDate AS 'FechaRadicado', 
            RC.ConfirmDate AS 'FechaConfirmaRadicado', 
            RC.RadicatedConsecutive AS 'Radicado', 
            DATEADD(m, 2, RC.ConfirmDate) AS 'FechaVencimientoR', 
            C.Value AS 'ValorFactura', 
            C.Balance AS 'SaldoTotal', 
            T.descri AS 'descri', 
            D.Balance,
            CASE WHEN C.OpeningBalance = 'True' THEN 'SI' ELSE 'NO' END AS 'SaldoInicial',

            -- 🔹 EdadFactura corregido
            CASE
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) < 1 THEN '1. Sin Vencer'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) BETWEEN 1 AND 30 THEN '2. De 1 a 30 Dias'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) BETWEEN 31 AND 60 THEN '3. De 31 a 60 Dias'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) BETWEEN 61 AND 90 THEN '4. De 61 a 90 Dias'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) BETWEEN 91 AND 120 THEN '5. De 91 a 120 Dias'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) BETWEEN 121 AND 180 THEN '6. De 121 a 180 Dias'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) BETWEEN 181 AND 360 THEN '7. De 181 a 360 Dias'
                ELSE 'Mayor a 360 Dias'
            END AS 'EdadFactura',

            -- 🔹 EdadRadicado corregido
            CASE
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) < 1 THEN '1. Sin Vencer'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) BETWEEN 1 AND 30 THEN '2. De 1 a 30 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) BETWEEN 31 AND 60 THEN '3. De 31 a 60 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) BETWEEN 61 AND 90 THEN '4. De 61 a 90 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) BETWEEN 91 AND 120 THEN '5. De 91 a 120 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) BETWEEN 121 AND 180 THEN '6. De 121 a 180 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) BETWEEN 181 AND 360 THEN '7. De 181 a 360 Dias'
                ELSE 'Mayor a 360 Dias'
            END AS 'EdadRadicado',

            CASE
                WHEN RC.State = '1' THEN 'SinConfirmar'
                WHEN RC.State = 2 THEN 'Confirmado'
                WHEN RC.State = '' THEN 'P'
            END AS 'EstadoRadicado', 

            TE.Name AS 'Entidad',
            CASE TE.PersonType WHEN '1' THEN 'Naturales' WHEN '2' THEN 'Juridicas' END AS 'TipoPersona', 
            P.IPTIPODOC,
            F.PatientCode AS 'Identificacion', 
            P.IPNOMCOMP AS 'Paciente', 
            I.FECREGCRE AS 'FechaEgreso',
            CASE
                WHEN C.PortfolioStatus = '1' THEN 'SINRADICAR'
                WHEN C.PortfolioStatus = '2' THEN 'RADICADA SIN CONFIRMAR'
                WHEN C.PortfolioStatus = '3' THEN 'RADICADA ENTIDAD'
                WHEN C.PortfolioStatus = '7' THEN 'CERTIFICADA_PARCIAL'
                WHEN C.PortfolioStatus = '8' THEN 'CERTIFICADA_TOTAL'
                WHEN C.PortfolioStatus = '14' THEN 'DEVOLUCION_FACTURA'
                WHEN C.PortfolioStatus = '15' THEN 'TRASLADO_COBRO_JURIDICO'
            END AS 'EstadoFactura', 
            categ.Name AS [Categoria], 
            RC.ModificationDate AS 'FechaModificacion', 
            RC.ModificationUser AS 'UsuarioModificacion', 
            RTRIM(cont.Code) + ' - ' + RTRIM(cont.ContractName) AS Contrato, 
            F.AdmissionNumber AS Ingreso, 

            -- 🔹 DiasCartera corregido
            DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) AS DiasCartera

        FROM INDIGO031.Portfolio.AccountReceivable AS C 
        INNER JOIN INDIGO031.Portfolio.AccountReceivableAccounting AS D  ON C.Id = D.AccountReceivableId
        INNER JOIN INDIGO031.ViewInternal.TemCuenta AS T  ON D.MainAccountId = T.Idcuenta
        INNER JOIN INDIGO031.Portfolio.AccountReceivableShare AS S  ON C.Id = S.AccountReceivableId
        INNER JOIN INDIGO031.Common.ThirdParty AS TE  ON C.ThirdPartyId = TE.Id
        LEFT OUTER JOIN INDIGO031.Billing.Invoice AS F  ON C.InvoiceNumber = F.InvoiceNumber
        LEFT OUTER JOIN INDIGO031.Portfolio.RadicateInvoiceD AS RD  ON C.InvoiceNumber = RD.InvoiceNumber AND RD.State <> '4'
        LEFT OUTER JOIN INDIGO031.Portfolio.RadicateInvoiceC AS RC  ON RD.RadicateInvoiceCId = RC.Id AND RC.State <> '4'
        LEFT OUTER JOIN INDIGO031.dbo.ADINGRESO AS I  ON F.AdmissionNumber = I.NUMINGRES
        LEFT OUTER JOIN INDIGO031.dbo.INPACIENT AS P  ON P.IPCODPACI = F.PatientCode
        LEFT OUTER JOIN INDIGO031.Contract.CareGroup AS G  ON F.CareGroupId = G.Id
        LEFT OUTER JOIN INDIGO031.Contract.Contract AS cont  ON cont.Id = G.ContractId
        LEFT OUTER JOIN INDIGO031.Contract.ContractAccountingStructure AS SC  ON SC.Id = G.ContractAccountingStructureId
        LEFT OUTER JOIN INDIGO031.Common.OperatingUnit AS uo  ON uo.Id = C.OperatingUnitId
        LEFT OUTER JOIN INDIGO031.GeneralLedger.MainAccounts AS cuentas ON cuentas.Id = SC.AccountWithoutRadicateId
        LEFT OUTER JOIN INDIGO031.Billing.InvoiceCategories AS categ ON categ.Id = F.InvoiceCategoryId
        WHERE C.AccountReceivableType NOT IN('6')
          AND C.Status <> 3
    ) source 
    PIVOT (SUM(source.Balance) FOR source.descri IN(SinRadicar1301, Radicada1302, Glosada1303, PJuridico1304, Conciliada1305)) AS PIVOTABLE
) AS ejemplo 
LEFT JOIN INDIGO031.ViewInternal.V_CXC_CarteraxEdades_025 AS nuevo ON ejemplo.NroFactura = nuevo.NroFactura
LEFT JOIN (
    SELECT NroFactura, CUV
    FROM ViewInternal.VW_BILLING_TRAZABILIDADRIPS_GRAL
    WHERE EstadoRIPS = 'Validado'
    GROUP BY NroFactura, CUV
) AS NCV ON ejemplo.NroFactura = NCV.NroFactura
LEFT JOIN (
    SELECT Factura, Ajuste
    FROM ViewInternal.VW_PORTFOLIO_NOTASCARTERA_ENTIDAD
) AS nf ON nf.Factura = ejemplo.NroFactura

