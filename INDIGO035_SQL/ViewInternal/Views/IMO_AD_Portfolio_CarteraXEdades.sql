-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_AD_Portfolio_CarteraXEdades
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[IMO_AD_Portfolio_CarteraXEdades]
AS
     
SELECT uo.UnitName AS Sede, 
            C.InvoiceNumber AS NroFactura, 
            cuentas.Number AS cuenta,
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
            END AS TipoCxC,
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
            END AS TipoDocumento, 
            I.IFECHAING AS FechaIngreso, 
			I.FECREGCRE AS FechaCreaIngreso, 
            case i.TIPOINGRE when 1 then 'Ambulatorio' when 2 then 'Hospitalario'  end as TipoIngreso,
			CASE when TE.PersonType=1 then '999' else TE.Nit end as Nit , 
			
			
			--TE.Nit AS Nit, 
            G.Code AS GrupoAtencion, 
            G.Name AS GrupAtención, 
            (C.AccountReceivableDate) AS FechaFactura, 
            C.ExpiredDate AS FechaVencimiento, 
             (RC.ConfirmDate)  AS FechaRadicado, 
            (RD.RadicatedNumber) AS Radicado, 
             RC.ConfirmDate  AS FechaVencimientoR, 
            C.Value AS ValorFactura, 
            C.Balance AS SaldoTotal, 
            COALESCE(ACD.Balance, 0) AS SinRadicar1301, 
            COALESCE(ACD2.Balance, 0) AS Radicada1302, 
            COALESCE(ACD3.Balance, 0) AS Glosada1303, 
            COALESCE(ACD4.Balance, 0) AS PJuridico1304, 
            COALESCE(ACD5.Balance, 0) AS Conciliada1305,
            CASE
                WHEN c.OpeningBalance = 'True'
                THEN 'SI'
                ELSE 'NO'
            END AS SaldoInicial,
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
            END AS EdadFactura,
			--RC.ConfirmDate,
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
            END AS EdadRadicado,
            CASE
                WHEN RC.State = '1'
                THEN 'SinConfirmar'
                WHEN RC.State = '2'
                THEN 'Confirmado'
                WHEN RC.State IS NULL
                THEN 'Pendiente'
            END AS EstadoRadicado, 
            
			case when TE.PersonType=1 then 'PACIENTES  PARTICULARES' else TE.Name end AS Entidad,
			--te.Name AS Entidad,
            CASE TE.PersonType
                WHEN '1'
                THEN 'Naturales'
                WHEN '2'
                THEN 'Juridicas'
            END AS TipoPersona, 
            CASE WHEN P.IPTIPODOC = '1' THEN 'Cedula de Ciudadania' WHEN P.IPTIPODOC = '2' THEN 'Cedula de Extranjeria' WHEN P.IPTIPODOC = '3' THEN 'Tarjeta de Identidad' WHEN P.IPTIPODOC = '4' THEN 'Registro Civil' WHEN P.IPTIPODOC = '5' THEN 'Pasaporte' WHEN P.IPTIPODOC = '6' THEN 'Adulto sin Identificacion' WHEN
            P.IPTIPODOC = '7' THEN 'Menor sin Identificacion' WHEN P.IPTIPODOC = '8' THEN 'Numero Unico de Identificación Personal' WHEN P.IPTIPODOC = '9' THEN 'Certificado Nacido Vivo' WHEN P.IPTIPODOC = '10' THEN 'Carnet Diplomatico' WHEN P.IPTIPODOC = '12' THEN 'Permiso Especial de Permanencia' END AS Tipo_DocumentoPaciente, 
			F.PatientCode AS Identificacion, 
            p.IPNOMCOMP AS Paciente, 
            h.FECALTPAC AS FechaEgreso,
            CASE
                WHEN C.PortfolioStatus = '1'
                THEN 'SIN RADICAR'
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
            END AS EstadoFactura, 
            categ.Name AS [Categoria], 
            RC.ModificationDate AS FechaModificacion, 
            RC.ModificationUser AS UsuarioModificacion, 
            RTRIM(ctr.Code) + ' - ' + RTRIM(ccd.ContractName) AS Contrato, 
            f.admissionnumber AS Ingreso, 
            C.ID AS IDCARTERA,
			case when pais.name is not null then pais.name else 'Colombia' end as Pais,
			 TE.Nit as  NitVista ,
			 TE.name as  EntidadVista,
			 f.InitialDate as FechaIngresoFactura,
			 f.OutputDate as FechaEgresoFactura
     FROM Portfolio.AccountReceivable AS C
          INNER JOIN Common.ThirdParty AS TE ON C.ThirdPartyId = TE.Id
          LEFT JOIN Common.OperatingUnit AS UO ON UO.Id = C.OperatingUnitId
          LEFT JOIN Billing.Invoice AS F
          LEFT JOIN Billing.InvoiceCategories AS CATEG ON CATEG.id = F.InvoiceCategoryId
          LEFT JOIN dbo.ADINGRESO AS I ON F.AdmissionNumber = I.NUMINGRES
		  LEFT JOIN dbo.HCREGEGRE AS h ON h.NUMINGRES = I.NUMINGRES
          LEFT JOIN dbo.INPACIENT AS P ON P.ipcodpaci = F.PatientCode
          LEFT JOIN Contract.CareGroup AS G
          LEFT JOIN Contract.contract AS CTR ON CTR.id = g.ContractId 
		  LEFT JOIN [Contract].[ContractDetail] as ccd  on ccd.ContractId=ctr.id and CCD.ValidRecord=1
          LEFT JOIN Contract.ContractAccountingStructure AS SC
          LEFT JOIN GeneralLedger.MainAccounts AS CUENTAS ON CUENTAS.id = SC.AccountWithoutRadicateId ON SC.id = G.ContractAccountingStructureId ON F.CareGroupId = G.Id ON C.InvoiceNumber = F.InvoiceNumber
          LEFT JOIN Portfolio.RadicateInvoiceD AS RD
          LEFT JOIN Portfolio.RadicateInvoiceC AS RC ON RD.RadicateInvoiceCId = RC.Id
                                                              AND RC.State <> '4' ON C.InvoiceNumber = RD.InvoiceNumber
                                                                                     AND RD.State <> '4'
          LEFT JOIN Portfolio.AccountReceivableAccounting AS ACD
          INNER JOIN ViewInternal.TemCuenta AS TCV ON ACD.MainAccountId = TCV.Idcuenta
                                                             AND TCV.Descri = 'SinRadicar1301' ON C.Id = ACD.AccountReceivableId
          LEFT JOIN Portfolio.AccountReceivableAccounting AS ACD2
          INNER JOIN ViewInternal.TemCuenta AS TCV2 ON ACD2.MainAccountId = TCV2.Idcuenta
                                                              AND TCV2.Descri = 'Radicada1302' ON C.Id = ACD2.AccountReceivableId
          LEFT JOIN Portfolio.AccountReceivableAccounting AS ACD3
          INNER JOIN ViewInternal.TemCuenta AS TCV3 ON ACD3.MainAccountId = TCV3.Idcuenta
                                                              AND TCV3.Descri = 'Glosada1303' ON C.Id = ACD3.AccountReceivableId
          LEFT JOIN Portfolio.AccountReceivableAccounting AS ACD4
          INNER JOIN ViewInternal.TemCuenta AS TCV4 ON ACD4.MainAccountId = TCV4.Idcuenta
                                                              AND TCV4.Descri = 'PJuridico1304' ON C.Id = ACD4.AccountReceivableId
          LEFT JOIN Portfolio.AccountReceivableAccounting AS ACD5
          INNER JOIN ViewInternal.TemCuenta AS TCV5 ON ACD5.MainAccountId = TCV5.Idcuenta
                                                              AND TCV5.Descri = 'Conciliada1305' ON C.Id = ACD5.AccountReceivableId
															   left outer join common.country as pais on pais.id=p.idpais
		

     WHERE C.Balance > 0
           AND C.AccountReceivableType NOT IN('6')
          AND C.STATUS <> 3  and c.InvoiceCategoryId<>'212'
		  and F.id not in (select h.InvoiceId
							from Billing.InvoiceEntityCapitated as h 
							inner join Contract.CareGroup as c on c.id= h.CareGroupId
							inner join Billing.Invoice as f on f.id=h.InvoiceId
							where h.CareGroupId in ('0024','0023','0025','0026','0027'))

