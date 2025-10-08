-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_CXC_CARTERAXEDADES_INCAPACIDADES
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   VIEW ViewInternal.VW_IMO_CXC_CARTERAXEDADES_INCAPACIDADES
AS

SELECT a.*,  
c.TipoEmpleado  AS TipoEmpleado,  
 c.Cargo  as Cargo, 

Cod_CentroCosto, 
 [Centro de Costo]  AS [Centro de Costo], 
Cod_UF, 
 UnidadFuncional  AS UnidadFuncional

from (
	
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
			Observacion,
			Documento
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
                    WHEN C.OpeningBalance = 'True'
                    THEN 'SI'
                    ELSE 'NO'
                END AS 'SaldoInicial',
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
                END AS 'EdadFactura',
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
                END AS 'EdadRadicado',
                CASE
                    WHEN RC.State = '1'
                    THEN 'SinConfirmar'
                    WHEN RC.State = 2
                    THEN 'Confirmado'
                    WHEN RC.State = ''
                    THEN 'P'
                END AS 'EstadoRadicado', 
                TE.Name AS 'Entidad',
                CASE TE.PersonType
                    WHEN '1'
                    THEN 'Naturales'
                    WHEN '2'
                    THEN 'Juridicas'
                END AS 'TipoPersona', 
                F.PatientCode AS 'Identificacion', 
                P.IPNOMCOMP AS 'Paciente', 
                I.FECREGCRE AS 'FechaEgreso',
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
                F.AdmissionNumber AS Ingreso, 
                DATEDIFF(DAY, RC.ConfirmDate, GETDATE()) AS DiasCartera, --CONVERT(INT, (GETDATE() - RC.ConfirmDate), 100) AS DiasCartera,
			 C.Observations as Observacion,
			left(C.Observations, CHARINDEX('-',C.Observations)-1 ) as Documento 
         FROM [INDIGO035].[Portfolio].[AccountReceivable] AS C 
              INNER JOIN [INDIGO035].[Portfolio].[AccountReceivableAccounting] AS D  ON C.Id = D.AccountReceivableId
              INNER JOIN [INDIGO035].[ViewInternal].[TemCuenta] AS T  ON D.MainAccountId = T.Idcuenta
              INNER JOIN [INDIGO035].[Portfolio].[AccountReceivableShare] AS S  ON C.Id = S.AccountReceivableId
              INNER JOIN [INDIGO035].[Common].[ThirdParty] AS TE  ON C.ThirdPartyId = TE.Id
              LEFT OUTER JOIN [INDIGO035].[Billing].[Invoice] AS F  ON C.InvoiceNumber = F.InvoiceNumber
              LEFT OUTER JOIN [INDIGO035].[Portfolio].[RadicateInvoiceD] AS RD  ON C.InvoiceNumber = RD.InvoiceNumber
                                                                                                 AND RD.State <> '4'
              LEFT OUTER JOIN [INDIGO035].[Portfolio].[RadicateInvoiceC] AS RC  ON RD.RadicateInvoiceCId = RC.Id
                                                                                                 AND RC.State <> '4'
              LEFT OUTER JOIN [INDIGO035].[dbo].[ADINGRESO] AS I  ON F.AdmissionNumber = I.NUMINGRES
              LEFT OUTER JOIN [INDIGO035].[dbo].[INPACIENT] AS P  ON P.IPCODPACI = F.PatientCode
              LEFT OUTER JOIN [INDIGO035].[Contract].[CareGroup] AS G  ON F.CareGroupId = G.Id
              LEFT OUTER JOIN [INDIGO035].[Contract].[Contract] AS cont  ON cont.Id = G.ContractId
              LEFT OUTER JOIN [INDIGO035].[Contract].[ContractAccountingStructure] AS SC  ON SC.Id = G.ContractAccountingStructureId
              LEFT OUTER JOIN [INDIGO035].[Common].[OperatingUnit] AS uo  ON uo.Id = C.OperatingUnitId
              LEFT OUTER JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS cuentas ON cuentas.Id = SC.AccountWithoutRadicateId
              LEFT OUTER JOIN [INDIGO035].[Billing].[InvoiceCategories] AS categ ON categ.Id = F.InvoiceCategoryId
         WHERE C.Balance > 0
               AND C.AccountReceivableType NOT IN('6')
              AND C.Status <> 3 and C.InvoiceCategoryId='3'
     ) source PIVOT(SUM(source.Balance) FOR source.descri IN(SinRadicar1301, 
                                                             Radicada1302, 
                                                             Glosada1303, 
                                                             PJuridico1304, 
                                                             Conciliada1305)) AS PIVOTABLE
															 ) as a
LEFT OUTER JOIN  [DataWareHouse_Finance].[ViewInternal].[VW_V_AD_PAYROLL_NOMINACONTRATOS] as c on c.NumeroIdentificacion=a.Documento
