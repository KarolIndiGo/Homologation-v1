-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_AD_PORTFOLIO_CARTERAXEDADES
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_AD_Portfolio_CarteraXEdades
AS 
    
SELECT UO.UnitName AS Sede, 
            C.InvoiceNumber AS NroFactura, 
            CUENTAS.Number AS cuenta,
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
            case I.TIPOINGRE when 1 then 'Ambulatorio' when 2 then 'Hospitalario'  end as TipoIngreso,
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
                WHEN C.OpeningBalance = 'True'
                THEN 'SI'
                ELSE 'NO'
            END AS SaldoInicial,
            CASE
                
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) < 1 --Replaced CAST(GETDATE() - C.ExpiredDate AS INT) with DATEDIFF to avoid incompatible data types
                THEN'1. Sin Vencer'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) > 0    --CAST(GETDATE() - C.ExpiredDate AS INT) > 0
                     AND DATEDIFF(DAY, C.ExpiredDate, GETDATE()) < 31   --CAST(GETDATE() - C.ExpiredDate AS INT) < 31
                THEN '2. De 1 a 30 Dias'
                WHEN  DATEDIFF(DAY, C.ExpiredDate, GETDATE())  > 30     --CAST(GETDATE() - C.ExpiredDate AS INT) > 30
                     AND DATEDIFF(DAY, C.ExpiredDate, GETDATE()) < 61     --CAST(GETDATE() - C.ExpiredDate AS INT) < 61
                THEN '3. De 31 a 60 Dias'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) > 60          --CAST(GETDATE() - C.ExpiredDate AS INT) > 60
                     AND DATEDIFF(DAY, C.ExpiredDate, GETDATE()) < 91      --CAST(GETDATE() - C.ExpiredDate AS INT) < 91
                THEN '4. De 61 a 90 Dias'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) > 90   --CAST(GETDATE() - C.ExpiredDate AS INT) > 90
                     AND DATEDIFF(DAY, C.ExpiredDate, GETDATE()) < 121   --CAST(GETDATE() - C.ExpiredDate AS INT) < 121
                THEN '5. De 91 a 120 Dias'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) > 120       --CAST(GETDATE() - C.ExpiredDate AS INT) > 120
                     AND DATEDIFF(DAY, C.ExpiredDate, GETDATE()) < 181       --CAST(GETDATE() - C.ExpiredDate AS INT) < 181
                THEN '6. De 121 a 180 Dias'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) > 180       --CAST(GETDATE() - C.ExpiredDate AS INT) > 180
                     AND DATEDIFF(DAY, C.ExpiredDate, GETDATE()) < 361       --CAST(GETDATE() - C.ExpiredDate AS INT) < 361
                THEN '7. De 181 a 360 Dias'
                WHEN DATEDIFF(DAY, C.ExpiredDate, GETDATE()) > 360       --CAST(GETDATE() - C.ExpiredDate AS INT) > 360
                THEN 'Mayor a 360 Dias'
            END AS EdadFactura,
			--RC.ConfirmDate,
            CASE
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) < 1  --CAST(GETDATE() - RC.ConfirmDate AS INT) < 1
                THEN '1. Sin Vencer'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) > 0  --CAST(GETDATE() - RC.ConfirmDate AS INT) > 0
                     AND DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) < 31  --CAST(GETDATE() - RC.ConfirmDate AS INT) < 31
                THEN '2. De 1 a 30 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) > 30  --CAST(GETDATE() - RC.ConfirmDate AS INT) > 30
                     AND DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) < 61  --CAST(GETDATE() - RC.ConfirmDate AS INT) < 61
                THEN '3. De 31 a 60 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) > 60  --CAST(GETDATE() - RC.ConfirmDate AS INT) > 60
                     AND DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) < 91  --CAST(GETDATE() - RC.ConfirmDate AS INT) < 91
                THEN '4. De 61 a 90 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) > 90  --CAST(GETDATE() - RC.ConfirmDate AS INT) > 90
                     AND DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) < 121  --CAST(GETDATE() - RC.ConfirmDate AS INT) < 121
                THEN '5. De 91 a 120 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) > 120  --CAST(GETDATE() - RC.ConfirmDate AS INT) > 120
                     AND DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) < 181  --CAST(GETDATE() - RC.ConfirmDate AS INT) < 181
                THEN '6. De 121 a 180 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) > 180  --CAST(GETDATE() - RC.ConfirmDate AS INT) > 180
                     AND DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) < 361  --CAST(GETDATE() - RC.ConfirmDate AS INT) < 361
                THEN '7. De 181 a 360 Dias'
                WHEN DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) > 360  --CAST(GETDATE() - RC.ConfirmDate AS INT) > 360
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
            P.IPNOMCOMP AS Paciente, 
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
            CATEG.Name AS [Categoria], 
            RC.ModificationDate AS FechaModificacion, 
            RC.ModificationUser AS UsuarioModificacion, 
            RTRIM(CTR.Code) + ' - ' + RTRIM(ccd.ContractName) AS Contrato, 
            F.AdmissionNumber AS Ingreso, 
            C.Id AS IDCARTERA,
			case when pais.Name is not null then pais.Name else 'Colombia' end as Pais,
			 TE.Nit as  NitVista ,
			 TE.Name as  EntidadVista,
			 F.InitialDate as FechaIngresoFactura,
			 F.OutputDate as FechaEgresoFactura
     FROM [INDIGO035].[Portfolio].[AccountReceivable] AS C
          INNER JOIN [INDIGO035].[Common].[ThirdParty] AS TE ON C.ThirdPartyId = TE.Id
          LEFT JOIN [INDIGO035].[Common].[OperatingUnit] AS UO ON UO.Id = C.OperatingUnitId
          LEFT JOIN [INDIGO035].[Billing].[Invoice] AS F
          LEFT JOIN [INDIGO035].[Billing].[InvoiceCategories] AS CATEG ON CATEG.Id = F.InvoiceCategoryId
          LEFT JOIN [INDIGO035].[dbo].[ADINGRESO] AS I ON F.AdmissionNumber = I.NUMINGRES
		  LEFT JOIN [INDIGO035].[dbo].[HCREGEGRE] AS h ON h.NUMINGRES = I.NUMINGRES
          LEFT JOIN [INDIGO035].[dbo].[INPACIENT] AS P ON P.IPCODPACI = F.PatientCode
          LEFT JOIN [INDIGO035].[Contract].[CareGroup] AS G
          LEFT JOIN [INDIGO035].[Contract].[Contract] AS CTR ON CTR.Id = G.ContractId 
		  LEFT JOIN [INDIGO035].[Contract].[ContractDetail] as ccd  on ccd.ContractId=CTR.Id and ccd.ValidRecord=1
          LEFT JOIN [INDIGO035].[Contract].[ContractAccountingStructure] AS SC
          LEFT JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS CUENTAS ON CUENTAS.Id = SC.AccountWithoutRadicateId ON SC.Id = G.ContractAccountingStructureId ON F.CareGroupId = G.Id ON C.InvoiceNumber = F.InvoiceNumber
          LEFT JOIN [INDIGO035].[Portfolio].[RadicateInvoiceD] AS RD
          LEFT JOIN [INDIGO035].[Portfolio].[RadicateInvoiceC] AS RC ON RD.RadicateInvoiceCId = RC.Id
                                                              AND RC.State <> '4' ON C.InvoiceNumber = RD.InvoiceNumber
                                                                                     AND RD.State <> '4'
          LEFT JOIN [INDIGO035].[Portfolio].[AccountReceivableAccounting] AS ACD
          INNER JOIN [INDIGO035].[ViewInternal].[TemCuenta] AS TCV ON ACD.MainAccountId = TCV.Idcuenta
                                                             AND TCV.descri = 'SinRadicar1301' ON C.Id = ACD.AccountReceivableId
          LEFT JOIN [INDIGO035].[Portfolio].[AccountReceivableAccounting] AS ACD2
          INNER JOIN [INDIGO035].[ViewInternal].[TemCuenta] AS TCV2 ON ACD2.MainAccountId = TCV2.Idcuenta
                                                              AND TCV2.descri = 'Radicada1302' ON C.Id = ACD2.AccountReceivableId
          LEFT JOIN [INDIGO035].[Portfolio].[AccountReceivableAccounting] AS ACD3
          INNER JOIN [INDIGO035].[ViewInternal].[TemCuenta] AS TCV3 ON ACD3.MainAccountId = TCV3.Idcuenta
                                                              AND TCV3.descri = 'Glosada1303' ON C.Id = ACD3.AccountReceivableId
          LEFT JOIN [INDIGO035].[Portfolio].[AccountReceivableAccounting] AS ACD4
          INNER JOIN [INDIGO035].[ViewInternal].[TemCuenta] AS TCV4 ON ACD4.MainAccountId = TCV4.Idcuenta
                                                              AND TCV4.descri = 'PJuridico1304' ON C.Id = ACD4.AccountReceivableId
          LEFT JOIN [INDIGO035].[Portfolio].[AccountReceivableAccounting] AS ACD5
          INNER JOIN [INDIGO035].[ViewInternal].[TemCuenta] AS TCV5 ON ACD5.MainAccountId = TCV5.Idcuenta
                                                              AND TCV5.descri = 'Conciliada1305' ON C.Id = ACD5.AccountReceivableId
															   left outer join [INDIGO035].[Common].[Country] as pais on pais.Id=P.IDPAIS
		

     WHERE C.Balance > 0
           AND C.AccountReceivableType NOT IN('6')
          AND C.Status <> 3  and C.InvoiceCategoryId<>'212'
		  and F.Id not in (select h.InvoiceId
							from [INDIGO035].[Billing].[InvoiceEntityCapitated] as h 
							inner join [INDIGO035].[Contract].[CareGroup] as c on c.Id= h.CareGroupId
							inner join [INDIGO035].[Billing].[Invoice] as f on f.Id=h.InvoiceId
							where h.CareGroupId in ('0024','0023','0025','0026','0027'))

