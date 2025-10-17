-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_CXC_CarteraxEdades
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE view [ViewInternal].[V_CXC_CarteraxEdades] as
 SELECT   ejemplo.Sede, 
            ejemplo.NroFactura, 
			--NCV.CUV,
           CASE
		   WHEN ejemplo.cuenta is null then nuevo.cuenta else ejemplo.cuenta end as cuenta,
            ejemplo.TipoCxC, 
            ejemplo.TipoDocumento, 
            CASE
			WHEN ejemplo.FechaIngreso is null then nuevo.fechaingreso else ejemplo.FechaIngreso end as FechaIngreso,
            ejemplo.Nit, 
			CASE
            WHEN  ejemplo.GrupoAtencion is null then nuevo.GrupoAtencion else ejemplo.GrupAtención end as GrupoAtencíon,
            --ejemplo.GrupAtención, 
            ejemplo.FechaFactura, 
            ejemplo.FechaVencimiento, 
			CASE
            WHEN ejemplo.FechaRadicado is null then nuevo.FechaRadicado  else ejemplo.FechaRadicado end as FechaRadicado,
            CASE
			WHEN ejemplo.FechaConfirmaRadicado is null then nuevo.FechaConfirmaRadicado else ejemplo.FechaConfirmaRadicado end as FechaConfirmaRadicado,
            CASE
			WHEN ejemplo.Radicado is null then nuevo.Radicado else ejemplo.Radicado end as Radicado,
			CASE
            WHEN ejemplo.FechaVencimientoR is null then nuevo.FechaVencimientoR else ejemplo.FechaVencimientoR end as FechaVencimientoR,
            ejemplo.ValorFactura, 
            ejemplo.SaldoTotal, 
            ejemplo.SinRadicar1301, 
            ejemplo.Radicada1302, 
            ejemplo.Glosada1303, 
            ejemplo.PJuridico1304, 
            ejemplo.Conciliada1305, 
            ejemplo.SaldoInicial, 
            ejemplo.EdadFactura, 
			CASE
            WHEN ejemplo.EdadRadicado is null then nuevo.EdadRadicado else ejemplo.EdadRadicado end as EdadRadicado,
			CASE
            WHEN ejemplo.EstadoRadicado is null then nuevo.EstadoRadicado else ejemplo.EstadoRadicado end as EstadoRadicado,
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
			CASE
            WHEN ejemplo.Identificacion is null then nuevo.Identificacion else ejemplo.Identificacion end as Identificacion,
			CASE
            WHEN ejemplo.Paciente is null then nuevo.Paciente else ejemplo.Paciente end as Paciente,
			CASE
            WHEN ejemplo.FechaEgreso is null then nuevo.FechaEgreso else ejemplo.FechaEgreso end as FechaEgreso,
            ejemplo.EstadoFactura, 
			CASE
            WHEN ejemplo.Categoria is null then nuevo.Categoria else ejemplo.Categoria end as Categoria,
            CASE
			WHEN ejemplo.FechaModificacion is null then nuevo.FechaModificacion else ejemplo.FechaModificacion end as FechaModificacion,
			CASE
            WHEN ejemplo.UsuarioModificacion is null then nuevo.UsuarioModificacion else ejemplo.UsuarioModificacion end as UsuarioModificacion,
			CASE
            WHEN ejemplo.Contrato is null then nuevo.Contrato else ejemplo.Contrato end as Contrato,
			CASE
            WHEN ejemplo.Ingreso is null then nuevo.Ingreso else ejemplo.Ingreso end as Ingreso,
			CASE
            WHEN ejemplo.DiasCartera is null then nuevo.DiasCartera else ejemplo.DiasCartera end as DiasCartera, 
			case when Ajuste is null then 'No' when Ajuste is not null then 'Si' end as TieneNota, abs(Ajuste) as ValorNota
			

            
     FROM
	 (	 
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
         SELECT uo.UnitName AS 'Sede', 
                C.InvoiceNumber AS 'NroFactura', 
                cuentas.Number AS 'cuenta',
                CASE C.AccountReceivableType
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
                CASE F.DocumentType
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
                I.IFECHAING AS 'FechaIngreso', 
                TE.Nit AS 'Nit', 
                G.Code AS 'GrupoAtencion', 
                G.Name AS GrupAtención, 
                (C.AccountReceivableDate) AS 'FechaFactura', 
                C.ExpiredDate AS 'FechaVencimiento', 
                (RC.RadicatedDate) AS 'FechaRadicado', 
                (RC.ConfirmDate) AS 'FechaConfirmaRadicado', 
                (RC.RadicatedConsecutive) AS 'Radicado', 
                (DATEADD(m, 2, ((RC.ConfirmDate)))) AS 'FechaVencimientoR', 
                C.Value AS 'ValorFactura', 
                C.Balance AS 'SaldoTotal', 
                T.descri AS 'descri', 
                D.Balance,
                CASE
                    WHEN c.OpeningBalance = 'True'
                    THEN 'SI'
                    ELSE 'NO'
                END AS 'SaldoInicial',
                CASE
                    WHEN CAST(GETDATE() - C.ExpiredDate AS INT) < 1
                    THEN '1. Sin Vencer'
                    WHEN CAST(GETDATE() - C.ExpiredDate AS INT) > 0
                         AND CAST(GETDATE() - C.ExpiredDate AS INT) < 31
                    THEN '2. De 1 a 30 Dias'
                    WHEN CAST(GETDATE() - C.ExpiredDate AS INT) > 30
                         AND CAST(GETDATE() - C.ExpiredDate AS INT) < 61
                    THEN '3. De 31 a 60 Dias'
                    WHEN CAST(GETDATE() - C.ExpiredDate AS INT) > 60
                         AND CAST(GETDATE() - C.ExpiredDate AS INT) < 91
                    THEN '4. De 61 a 90 Dias'
                    WHEN CAST(GETDATE() - C.ExpiredDate AS INT) > 90
                         AND CAST(GETDATE() - C.ExpiredDate AS INT) < 121
                    THEN '5. De 91 a 120 Dias'
                    WHEN CAST(GETDATE() - C.ExpiredDate AS INT) > 120
                         AND CAST(GETDATE() - C.ExpiredDate AS INT) < 181
                    THEN '6. De 121 a 180 Dias'
                    WHEN CAST(GETDATE() - C.ExpiredDate AS INT) > 180
                         AND CAST(GETDATE() - C.ExpiredDate AS INT) < 361
                    THEN '7. De 181 a 360 Dias'
                    WHEN CAST(GETDATE() - C.ExpiredDate AS INT) > 360
                    THEN 'Mayor a 360 Dias'
                END AS 'EdadFactura',
                CASE
                    WHEN CAST(GETDATE() - RC.ConfirmDate AS INT) < 1
                    THEN '1. Sin Vencer'
                    WHEN CAST(GETDATE() - RC.ConfirmDate AS INT) > 0
                         AND CAST(GETDATE() - RC.ConfirmDate AS INT) < 31
                    THEN '2. De 1 a 30 Dias'
                    WHEN CAST(GETDATE() - RC.ConfirmDate AS INT) > 30
                         AND CAST(GETDATE() - RC.ConfirmDate AS INT) < 61
                    THEN '3. De 31 a 60 Dias'
                    WHEN CAST(GETDATE() - RC.ConfirmDate AS INT) > 60
                         AND CAST(GETDATE() - RC.ConfirmDate AS INT) < 91
                    THEN '4. De 61 a 90 Dias'
                    WHEN CAST(GETDATE() - RC.ConfirmDate AS INT) > 90
                         AND CAST(GETDATE() - RC.ConfirmDate AS INT) < 121
                    THEN '5. De 91 a 120 Dias'
                    WHEN CAST(GETDATE() - RC.ConfirmDate AS INT) > 120
                         AND CAST(GETDATE() - RC.ConfirmDate AS INT) < 181
                    THEN '6. De 121 a 180 Dias'
                    WHEN CAST(GETDATE() - RC.ConfirmDate AS INT) > 180
                         AND CAST(GETDATE() - RC.ConfirmDate AS INT) < 361
                    THEN '7. De 181 a 360 Dias'
                    WHEN CAST(GETDATE() - RC.ConfirmDate AS INT) > 360
                    THEN 'Mayor a 360 Dias'
                END AS 'EdadRadicado',
                CASE
                    WHEN RC.State = '1'
                    THEN 'SinConfirmar'
                    WHEN RC.State = 2
                    THEN 'Confirmado'
                    WHEN RC.State = ''
                    THEN 'P'
                END AS 'EstadoRadicado', 
                te.Name AS 'Entidad',
                CASE TE.PersonType
                    WHEN '1'
                    THEN 'Naturales'
                    WHEN '2'
                    THEN 'Juridicas'
                END AS 'TipoPersona', 
				p.IPTIPODOC,
                F.PatientCode AS 'Identificacion', 
                p.IPNOMCOMP AS 'Paciente', 
                i.FECREGCRE AS 'FechaEgreso',
                CASE
                    WHEN C.PortfolioStatus = '1'
                    THEN 'SINRADICAR'
                    WHEN C.PortfolioStatus = '2'
                    THEN 'RADICADA SIN CONFIRMAR'
                    WHEN C.PortfolioStatus = '3'
                    THEN 'RADICADA ENTIDAD'
                    WHEN C.PortfolioStatus = '7'
                    THEN 'CERTIFICADA_PARCIAL'
                    WHEN C.PortfolioStatus = '8'
                    THEN 'CERTIFICADA_TOTAL'
                    WHEN C.PortfolioStatus = '14'
                    THEN 'DEVOLUCION_FACTURA'
                    WHEN C.PortfolioStatus = '15'
                    THEN 'TRASLADO_COBRO_JURIDICO'
                END AS 'EstadoFactura', 
                categ.Name AS [Categoria], 
                RC.ModificationDate AS 'FechaModificacion', 
                RC.ModificationUser AS 'UsuarioModificacion', 
                RTRIM(cont.Code) + ' - ' + RTRIM(cont.ContractName) AS Contrato, 
                f.admissionnumber AS Ingreso, 
                CONVERT(INT, (GETDATE() - RC.ConfirmDate), 100) AS DiasCartera
				
         FROM Portfolio.AccountReceivable AS C 
              INNER JOIN Portfolio.AccountReceivableAccounting AS D  ON C.Id = D.AccountReceivableId
              INNER JOIN ViewInternal.TemCuenta AS T  ON D.MainAccountId = T.Idcuenta
              INNER JOIN Portfolio.AccountReceivableShare AS S  ON C.Id = S.AccountReceivableId
              INNER JOIN Common.ThirdParty AS TE  ON C.ThirdPartyId = TE.Id
              LEFT OUTER JOIN Billing.Invoice AS F  ON C.InvoiceNumber = F.InvoiceNumber
              LEFT OUTER JOIN Portfolio.RadicateInvoiceD AS RD  ON C.InvoiceNumber = RD.InvoiceNumber
                                                                                                 AND RD.State <> '4'
              LEFT OUTER JOIN Portfolio.RadicateInvoiceC AS RC  ON RD.RadicateInvoiceCId = RC.Id
                                                                                                 AND RC.state <> '4'
              LEFT OUTER JOIN dbo.ADINGRESO AS I  ON F.AdmissionNumber = I.NUMINGRES
              LEFT OUTER JOIN dbo.INPACIENT AS P  ON P.ipcodpaci = f.PatientCode
              LEFT OUTER JOIN Contract.CareGroup AS G  ON F.CareGroupId = G.Id
              LEFT OUTER JOIN contract.contract AS cont  ON cont.id = g.ContractId
              LEFT OUTER JOIN cONTRACT.ContractAccountingStructure AS SC  ON sc.id = G.ContractAccountingStructureId
              LEFT OUTER JOIN Common.OperatingUnit AS uo  ON uo.Id = C.OperatingUnitId
              LEFT OUTER JOIN GeneralLedger.MainAccounts AS cuentas ON cuentas.id = sc.AccountWithoutRadicateId
              LEFT OUTER JOIN Billing.InvoiceCategories AS categ ON categ.id = F.InvoiceCategoryId
         WHERE --C.Balance > 0 AND 
		 C.AccountReceivableType NOT IN('6')
              AND C.STATUS <> 3
     ) source PIVOT(SUM(SOURCE.Balance) FOR source.descri IN(SinRadicar1301, 
                                                             Radicada1302, 
                                                             Glosada1303, 
                                                             PJuridico1304, 
                                                             Conciliada1305)) AS PIVOTABLE

	)AS ejemplo left JOIN  ViewInternal.V_CXC_CarteraxEdades_025 AS nuevo on ejemplo.NroFactura = nuevo.NroFactura

--LEFT JOIN (
--    SELECT NroFactura, CUV
--    FROM ViewInternal.Billing_TrazabilidadRIPS_Gral  -- se agrega CUV por caso 290902
--    WHERE EstadoRIPS = 'Validado'
--    GROUP BY NroFactura, CUV
--) AS NCV ON ejemplo.NroFactura = NCV.NroFactura
LEFT JOIN (SELECT Factura, Ajuste
			FROM [ViewInternal].[Portfolio_NotasCartera_Entidad] WITH (NOLOCK)) as nf on nf.Factura=ejemplo.NroFactura



	--where ejemplo.NroFactura='JST154064'
