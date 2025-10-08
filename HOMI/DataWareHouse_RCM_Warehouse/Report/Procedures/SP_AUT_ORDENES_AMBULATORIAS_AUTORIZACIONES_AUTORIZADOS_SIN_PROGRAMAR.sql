-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: SP_AUT_ORDENES_AMBULATORIAS_AUTORIZACIONES_AUTORIZADOS_SIN_PROGRAMAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE Report.SP_AUT_ORDENES_AMBULATORIAS_AUTORIZACIONES_AUTORIZADOS_SIN_PROGRAMAR
 @FechaInicial as DATETIME,
 @FechaFinal as DATETIME
AS
                WITH

                CTE_ORDENES AS
                (
                    SELECT 'HCORDIMAG' EntityName, h.AUTO EntityId, h.CANSERIPS Quantity, h.OBSSERIPS Observations
                    FROM [INDIGO036].[dbo].[HCORDIMAG] h
                    WHERE cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal
                    UNION ALL
                    SELECT 'HCORDLABO' EntityName, h.AUTO EntityId, h.CANSERIPS Quantity, h.CODSERIPS Observations
                    FROM [INDIGO036].[dbo].[HCORDLABO] h
                    WHERE h.MANEXTPRO = 1 AND NOT (h.ESTSERIPS IN ('6')) and cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal
                    UNION ALL
                    SELECT 'HCORDPATO' EntityName, h.AUTO EntityId, h.CANSERIPS Quantity, h.OBSSERIPS Observations
                    FROM [INDIGO036].[dbo].[HCORDPATO] h
                    WHERE cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal
                    UNION ALL
                    SELECT 'HCORDINTE' EntityName, h.AUTO EntityId, h.CANSERIPS Quantity, h.OBSSERIPS Observations
                    FROM [INDIGO036].[dbo].[HCORDINTE] h
                    WHERE cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal
                    UNION ALL
                    SELECT 'HCORDPRON' EntityName, h.AUTO EntityId, h.CANSERIPS Quantity, h.OBSSERIPS Observations
                    FROM [INDIGO036].[dbo].[HCORDPRON] h
                    WHERE cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal
                    UNION ALL
                    SELECT 'HCORDPROQ' EntityName, h.AUTO EntityId, h.CANSERIPS Quantity, h.OBSSERIPS Observations
                    FROM [INDIGO036].[dbo].[HCORDPROQ] h
                    WHERE cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal
                    UNION ALL
                    SELECT 'HCORHEMCO' EntityName, h.ID EntityId, hd.Quantity Quantity, '' Observations
                    FROM [INDIGO036].[dbo].[ADINGRESO] ing
                    INNER JOIN [INDIGO036].[dbo].[HCORHEMCO] h ON ing.NUMINGRES = h.NUMINGRES
                    INNER JOIN (
                        SELECT hd.HCORHEMCOID,
                            hd.CODSERIPS,
                            hd.TraceabilityPaperworkId,
                            hd.TraceabilityPaperworkEventsId,
                            hd.IDDESCRIPCIONRELACIONADA,
                            COUNT(1) Quantity
                        FROM [INDIGO036].[dbo].[HCORHEMSER] AS hd
                        WHERE hd.ESTADO NOT IN (3)
                        GROUP BY hd.HCORHEMCOID, hd.CODSERIPS, hd.TraceabilityPaperworkId, hd.TraceabilityPaperworkEventsId, hd.IDDESCRIPCIONRELACIONADA
                    ) hd ON h.ID = hd.HCORHEMCOID
                    WHERE cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal
                    UNION ALL
                    SELECT 'HCDESCOEX' EntityName, h.AUTO EntityId, 1 Quantity, hc.INDICAMED Observations
                    FROM [INDIGO036].[dbo].[HCHISPACA] AS hc
                    INNER JOIN [INDIGO036].[dbo].[HCDESCOEX] AS h ON hc.NUMINGRES = h.NUMINGRES AND hc.NUMEFOLIO = h.NUMEFOLIO
                    WHERE cast(hc.FECHISPAC as date) between @FechaInicial and @FechaFinal
                ),

                CTE_AUTORIZACIONES_AMBULATORIAS_RADICADAS AS
                (
                    select TP.Id,
                        RTRIM(ha.Name) 'ENTIDAD',
                        CG.Code 'CODIGO GRUPO',
                        RTRIM(CG.Name) 'GRUPO DE ATENCION',
                        CASE PAC.IPTIPODOC
                                WHEN '1' THEN 'CEDULA DE CIUDADANIA'
                                WHEN '2' THEN 'CEDULA DE EXTRANJERIA'
                                WHEN '3' THEN 'TARJETA DE IDENTIDAD'
                                WHEN '4' THEN 'REGISTRO CIVIL'
                                WHEN '5' THEN 'PASAPORTE'
                                WHEN '6' THEN 'ADULTO SIN IDENTIFICACION'
                                WHEN '7' THEN 'MENOR SIN IDENTIFICACION'
                                WHEN '8' THEN 'NUMERO UNICO DE IDENTIFICACION'
                                WHEN '9' THEN 'CERTIFICADO NACIDO VIVO'
                                WHEN '10' THEN 'CARNET DIPLOMATICO'
                                WHEN '11' THEN 'SALVOCONDUCTO'
                                WHEN '12' THEN 'PERMISO ESPECIAL DE PERMANENCIA'
                                ELSE 'N/A'
                        END AS 'TIPO IDENTIFICACION',
                        TP.PatientCode 'IDENTIFICACION',
                        PAC.IPNOMCOMP 'PACIENTE',
                        PAC.IPTELEFON 'TELEFONO',
                        PAC.IPTELMOVI 'CELULAR',
                        PAC.IPDIRECCI 'DIRECCION',
                        TP.AdmissionNumber 'INGRESO',
                        TP.Folio 'FOLIO',
                        CASE CUPS.ServiceType
                                WHEN 1 THEN 'Laboratorios'
                                WHEN 2 THEN 'Patologias'
                                WHEN 3 THEN 'Imagenes Diagnosticas'
                                WHEN 4 THEN 'Procedimientos no Qx'
                                WHEN 5 THEN 'Procedimientos Qx'
                                WHEN 6 THEN 'Interconsultas'
                                WHEN 7 THEN 'Ninguno'
                                WHEN 8 THEN 'Consulta Externa'
                                WHEN 9 THEN 'HEMOCOMPONENTES'
                        END 'TIPO SERVICIO',
                        TP.ServiceCode 'CODIGO CUPS ORDENADO',
                        CUPS.Description 'DESCRIPCION CUPS ORDENADO',
                        cd.Name 'DESCRIPCION RELACIONADA',
                        TP.RequestQuantity 'CANTIDAD ORDENADA',
                        TP.RequestDate 'FECHA ORDEN',
                        'AUTORIZADO' 'ESTADO',
                        CASE TP.Status
                                WHEN 5 THEN 'AUTORIZADO'
                                WHEN 6 THEN 'AUTORIZADO EN ENTREGA'
                                WHEN 7 THEN 'AUTORIZADO ENTREGADO'
                                WHEN 8 THEN 'AUTORIZADO AGENDADO'
                                WHEN 9 THEN 'AUTORIZADO EJECUTADO'
                                WHEN 10 THEN 'AUTORIZADO FACTURADO'
                                WHEN 14 THEN 'AUTORIZADO REMITIDO'
                                WHEN 15 THEN 'AUTORIZADO CON COTIZACION'
                        END 'ESTADO DETALLADO',
                        CASE TPE.ReportType
                                WHEN 1 THEN 'Llamada Telefónica'
                                WHEN 2 THEN 'Envío Físico'
                                WHEN 3 THEN 'Registro Página Web'
                                WHEN 4 THEN 'Correo Electrónico'
                                WHEN 5 THEN 'Tramita Paciente'
                        END 'TIPO REPORTE',
                        CASE TPE.Status
                                WHEN 1 THEN 'Pendiente por Autorizar'
                                WHEN 2 THEN 'Autorizado'
                                WHEN 3 THEN 'No Autorizado'
                                WHEN 4 THEN 'Autorizado con Aval'
                        END 'ESTADO EVENTO',
                        IIF(TP.AdmissionNumber IS NULL, TP.DocumentDate,
                            IIF(TPE.ReportType = '5', TPE.CreationDate, ISNULL(TPE.RegistrationDate, ISNULL(TPE.SendDate, ISNULL(TPE.InitialTime, ISNULL(TPE.CreationDate, TP.DocumentDate))))))
                        'FECHA RADICADO',
                        TPE.RadicateNumber 'NUMERO RADICADO',
                        USU.NOMUSUARI 'USUARIO CREO',
                        TPE.AuthorizationNumber 'NUMERO AUTORIZACION',
                        TPE.AuthorizedQuantity 'CANTIDAD AUTRIZADA',
                        TPE.AuthorizationDate 'FECHA AUTORIZACION',
                        TPE.AuthorizationExpiredDate 'FECHA EXPIRACION AUTORIZACION',
                        PRO.NOMMEDICO 'PROFESIONAL',
                        ESP.DESESPECI 'ESPECIALIDAD',
                        ISNULL(ING.CODDIAING, ING.CODDIAEGR) 'CIE10',
                        DIA.NOMDIAGNO 'DIAGNOSTICO',
                        ORD.Observations as OBSERVACIONES
                    from [INDIGO036].[Authorization].[TraceabilityPaperwork] TP
                    INNER JOIN INDIGO036.Contract.CUPSEntity AS CUPS ON CUPS.Code = TP.ServiceCode
                    INNER JOIN [INDIGO036].[dbo].[INPACIENT] AS PAC ON PAC.IPCODPACI = TP.PatientCode
                    INNER JOIN [INDIGO036].[dbo].[INPROFSAL] AS PRO ON PRO.CODPROSAL = TP.ProfessionalCode
                    INNER JOIN [INDIGO036].[dbo].[INESPECIA] AS ESP ON ESP.CODESPECI = PRO.CODESPEC1
                    LEFT JOIN  [INDIGO036].[dbo].[ADINGRESO] AS ING ON ING.NUMINGRES = TP.AdmissionNumber
                    LEFT JOIN INDIGO036.Contract.HealthAdministrator ha on ha.Id = TP.HealthAdministratorId
                    LEFT JOIN INDIGO036.Contract.CareGroup AS CG ON CG.Id = TP.CareGroupId
                    LEFT JOIN [INDIGO036].[Authorization].[TraceabilityPaperworkEvents] AS TPE ON TPE.TraceabilityPaperworkId = TP.Id
                    LEFT JOIN [INDIGO036].[dbo].[SEGusuaru] AS USU ON USU.CODUSUARI = TPE.CreationUser
                    LEFT JOIN [INDIGO036].[dbo].[INDIAGNOS] AS DIA ON DIA.CODDIAGNO = ISNULL(ING.CODDIAING, ING.CODDIAEGR)
                    LEFT JOIN INDIGO036.Contract.ContractDescriptions cd ON TP.ContractDescriptionId = cd.Id
                    LEFT JOIN CTE_ORDENES ORD ON TP.EntityName = ORD.EntityName AND TP.EntityId = ORD.EntityId
                    where TP.Type = 1 and TP.Status in (5,6,7,8,10,14,15) AND TPE.Status NOT IN (1,3)
                ),

                CTE_DATOS_UNICOS_ORDENES AS
                (
                    SELECT DISTINCT AUT.IDENTIFICACION, AUT.INGRESO, AUT.[CODIGO CUPS ORDENADO]
                    FROM CTE_AUTORIZACIONES_AMBULATORIAS_RADICADAS AUT
                ),

                CTE_PROGRAMACION_AGENDAMIENTOS AS
                (
                    SELECT DISTINCT CIT.IPCODPACI 'IDENTIFICACION',
                        ACT.CODSERIPS 'CUPS',
                        IPS.DESSERIPS 'DESCRIPCION CUPS',
                        CAST(CIT.FECHORAIN AS DATE) 'FECHA BUSQUEDA',
                        case CIT.CODESTCIT when 0 then 'PROGRAMADA' WHEN 1 THEN 'CUMPLIDA' END 'ESTADO DE CITA'
                    FROM [INDIGO036].[dbo].[AGASICITA] AS CIT
                    INNER JOIN CTE_DATOS_UNICOS_ORDENES AS ORD ON ORD.IDENTIFICACION = CIT.IPCODPACI
                    INNER JOIN [INDIGO036].[dbo].[AGACTIMED] AS ACT ON ACT.CODACTMED = CIT.CODACTMED
                    INNER JOIN [INDIGO036].[dbo].[INCUPSIPS] IPS ON IPS.CODSERIPS = ACT.CODSERIPS
                    WHERE CIT.CODESTCIT in ('0','1')
                ),

                CTE_PROGRAMACION_AGENDAMIENTOS_CIRUGIAS AS
                (
                    SELECT DISTINCT AGE.IPCODPACI 'IDENTIFICACION',
                        AGE.CODSERIPS 'CUPS',
                        IPS.DESSERIPS 'DESCRIPCION CUPS',
                        CAST(AGE.FECHORAIN AS DATE) 'FECHA BUSQUEDA',
                        'PROGRAMADO' 'ESTADO CITA'
                    FROM [INDIGO036].[dbo].[AGEPROGQX] AS AGE
                    INNER JOIN [INDIGO036].[dbo].[INCUPSIPS] IPS ON IPS.CODSERIPS = AGE.CODSERIPS
                    INNER JOIN CTE_DATOS_UNICOS_ORDENES AS ORD ON ORD.IDENTIFICACION = AGE.IPCODPACI
                ),

                CTE_FACTURA_UNICA AS
                (
                    SELECT DISTINCT F.Id, F.InvoiceNumber, F.AdmissionNumber, F.PatientCode
                    FROM INDIGO036.Billing.Invoice AS F
                    INNER JOIN CTE_DATOS_UNICOS_ORDENES AS UNI ON UNI.IDENTIFICACION = F.PatientCode
                    WHERE DocumentType NOT IN (5,6) AND F.Status = 1
                ),

                CTE_DETALLE_FACTURA AS
                (
                    SELECT DISTINCT F.PatientCode,
                        CUPS.Code 'CUPS',
                        CUPS.Description 'DESCRIPCION CUPS',
                        MIN(CAST(F.InvoiceDate AS DATE)) 'FECHA FACTURA',
                        CASE ING.TIPOINGRE WHEN 1 THEN 'AMBULATORIO' WHEN 2 THEN 'HOSPITALARIO' END 'TIPO INGRESO'
                    FROM INDIGO036.Billing.Invoice AS F
                    INNER JOIN CTE_FACTURA_UNICA AS FCAB ON FCAB.Id = F.Id
                    INNER JOIN INDIGO036.Billing.InvoiceDetail AS ID ON ID.InvoiceId = F.Id
                    INNER JOIN INDIGO036.Billing.ServiceOrderDetail AS SOD ON SOD.Id = ID.ServiceOrderDetailId
                    INNER JOIN INDIGO036.Billing.ServiceOrder AS SO ON SO.Id = SOD.ServiceOrderId
                    INNER JOIN INDIGO036.Contract.CUPSEntity AS CUPS ON CUPS.Id = SOD.CUPSEntityId
                    INNER JOIN [INDIGO036].[dbo].[ADINGRESO] AS ING ON ING.NUMINGRES = F.AdmissionNumber
                    WHERE SOD.RecordType = 1
                    GROUP BY F.PatientCode, CUPS.Code, CUPS.Description, ING.TIPOINGRE
                )

                SELECT DISTINCT AUT.*,
                    IIF(ISNULL(AGE.CUPS, CIR.CUPS) IS NULL, 'NO', 'SI') 'PROGRAMADO AGENDAMIENTO',
                    ISNULL(AGE.CUPS, CIR.CUPS) 'CODIGO CUPS PROGRAMADO',
                    ISNULL(AGE.[DESCRIPCION CUPS], CIR.[DESCRIPCION CUPS]) 'CUPS PROGRAMADO',
                    IIF(FAC.[TIPO INGRESO] = 'HOSPITALARIO', 'NO', IIF(FAC.CUPS IS NULL, 'NO', 'SI')) 'CUPS FACTURADO',
                    FAC.[FECHA FACTURA],
                    FAC.[TIPO INGRESO]
                FROM CTE_AUTORIZACIONES_AMBULATORIAS_RADICADAS AUT
                LEFT JOIN CTE_PROGRAMACION_AGENDAMIENTOS AS AGE ON AUT.IDENTIFICACION = AGE.IDENTIFICACION AND AUT.[CODIGO CUPS ORDENADO] = AGE.CUPS AND AGE.[FECHA BUSQUEDA] >= AUT.[FECHA ORDEN]
                LEFT JOIN CTE_PROGRAMACION_AGENDAMIENTOS_CIRUGIAS AS CIR ON AUT.IDENTIFICACION = CIR.IDENTIFICACION AND AUT.[CODIGO CUPS ORDENADO] = CIR.CUPS AND CIR.[FECHA BUSQUEDA] >= AUT.[FECHA ORDEN]
                LEFT JOIN CTE_DETALLE_FACTURA AS FAC ON FAC.PatientCode = AUT.IDENTIFICACION AND FAC.CUPS = AUT.[CODIGO CUPS ORDENADO] AND FAC.[FECHA FACTURA] >= AUT.[FECHA ORDEN]
                where cast(AUT.[FECHA ORDEN] as date) between @FechaInicial and @FechaFinal
                ORDER BY AUT.Id, AUT.[FECHA RADICADO]