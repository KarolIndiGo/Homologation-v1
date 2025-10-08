-- Workspace: HOMI
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9e4ad354-8031-4a13-8643-33b3234761ff
-- Schema: Report
-- Object: SP_AUT_ORDENES_AMBULATORIAS_AUTORIZACIONES
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE PROCEDURE [Report].[SP_AUT_ORDENES_AMBULATORIAS_AUTORIZACIONES]
 @FechaInicial as DATETIME,
 @FechaFinal as DATETIME
AS
WITH CTE_ORDENES AS
    (
        SELECT	
            'HCORDIMAG' EntityName,
            h.AUTO EntityId,		
            h.CODCENATE CareCenterCode, 
            h.UFUCODIGO FunctionalUnitCode,
            h.NUMINGRES AdmissionNumber,
            h.NUMEFOLIO Folio,
            h.IPCODPACI PatientCode,
            h.FECORDMED RequestDate, 
            h.CODPROSAL ProfessionalCode,
            h.CANSERIPS Quantity,
            1 Type,
            ce.Id ItemId,
            ce.Code ItemCode,
            h.CODSERIPS ItemCodeOriginal,
            ce.Description ItemName,
            cecd.Id ContractDescriptionId,
            cd.Id DescriptionId,
            CONCAT(cd.Code, ' - ', cd.Name) DescriptionCodeName,
            h.OBSSERIPS Observations,
            ESP.DESESPECI 'ESPECIALIDAD',
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
                WHEN '13' THEN 'PERMISO TEMPORAL DE PERMANENCIA'
                WHEN '14' THEN 'DOCUMENTO EXTRANJERO'
                WHEN '15' THEN 'SIN IDENTIFICACION'  
            END AS 'TIPO IDENTIFICACION',
            PRO.NOMMEDICO 'PROFESIONAL'
        FROM INDIGO036.dbo.HCORDIMAG h
        INNER JOIN INDIGO036.Contract.CUPSEntity ce ON h.CODSERIPS = ce.Code
        INNER JOIN INDIGO036.dbo.INPROFSAL AS PRO ON PRO.CODPROSAL = h.CODPROSAL 
        INNER JOIN INDIGO036.dbo.INESPECIA AS ESP ON ESP.CODESPECI = PRO.CODESPEC1 
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = h.IPCODPACI 
        LEFT JOIN INDIGO036.Contract.CUPSEntityContractDescriptions cecd ON ce.Id = cecd.CUPSEntityId AND h.IDDESCRIPCIONRELACIONADA = cecd.Id
        LEFT JOIN INDIGO036.Contract.ContractDescriptions cd ON cecd.ContractDescriptionId = cd.Id
        WHERE h.MANEXTPRO = 1 AND NOT (h.ESTSERIPS IN ('6')) and cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal

        UNION ALL

        SELECT	
            'HCORDLABO' EntityName,
            h.AUTO EntityId,
            h.CODCENATE CareCenterCode,
            h.UFUCODIGO FunctionalUnitCode,
            h.NUMINGRES AdmissionNumber,
            h.NUMEFOLIO Folio,
            h.IPCODPACI PatientCode,
            h.FECORDMED RequestDate,
            h.CODPROSAL ProfessionalCode,
            h.CANSERIPS Quantity,
            1 Type,
            ce.Id ItemId,
            ce.Code ItemCode,
            h.CODSERIPS ItemCodeOriginal,
            ce.Description ItemName,
            cecd.Id ContractDescriptionId,
            cd.Id DescriptionId,
            CONCAT(cd.Code, ' - ', cd.Name) DescriptionCodeName,
            h.OBSSERIPS Observations,
            ESP.DESESPECI 'ESPECIALIDAD',
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
                WHEN '13' THEN 'PERMISO TEMPORAL DE PERMANENCIA'
                WHEN '14' THEN 'DOCUMENTO EXTRANJERO'
                WHEN '15' THEN 'SIN IDENTIFICACION'  
            END AS 'TIPO IDENTIFICACION',
            PRO.NOMMEDICO 'PROFESIONAL'
        FROM INDIGO036.dbo.HCORDLABO h
        INNER JOIN INDIGO036.Contract.CUPSEntity ce ON h.CODSERIPS = ce.Code
        INNER JOIN INDIGO036.dbo.INPROFSAL AS PRO ON PRO.CODPROSAL = h.CODPROSAL 
        INNER JOIN INDIGO036.dbo.INESPECIA AS ESP ON ESP.CODESPECI = PRO.CODESPEC1 
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = h.IPCODPACI
        LEFT JOIN INDIGO036.Contract.CUPSEntityContractDescriptions cecd ON ce.Id = cecd.CUPSEntityId AND h.IDDESCRIPCIONRELACIONADA = cecd.Id
        LEFT JOIN INDIGO036.Contract.ContractDescriptions cd ON cecd.ContractDescriptionId = cd.Id
        WHERE h.MANEXTPRO = 1 AND NOT (h.ESTSERIPS IN ('6')) and cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal

        UNION ALL

        SELECT	
            'HCORDPATO' EntityName,
            h.AUTO EntityId,
            h.CODCENATE CareCenterCode,
            h.UFUCODIGO FunctionalUnitCode,
            h.NUMINGRES AdmissionNumber,
            h.NUMEFOLIO Folio,
            h.IPCODPACI PatientCode,
            h.FECORDMED RequestDate,
            h.CODPROSAL ProfessionalCode,
            h.CANSERIPS Quantity,
            1 Type,
            ce.Id ItemId,
            ce.Code ItemCode,
            h.CODSERIPS ItemCodeOriginal,
            ce.Description ItemName,
            cecd.Id ContractDescriptionId,
            cd.Id DescriptionId,
            CONCAT(cd.Code, ' - ', cd.Name) DescriptionCodeName,
            h.OBSSERIPS Observations,
            ESP.DESESPECI 'ESPECIALIDAD',
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
                WHEN '13' THEN 'PERMISO TEMPORAL DE PERMANENCIA'
                WHEN '14' THEN 'DOCUMENTO EXTRANJERO'
                WHEN '15' THEN 'SIN IDENTIFICACION'  
            END AS 'TIPO IDENTIFICACION',
            PRO.NOMMEDICO 'PROFESIONAL'
        FROM INDIGO036.dbo.HCORDPATO AS h
        INNER JOIN INDIGO036.Contract.CUPSEntity ce ON h.CODSERIPS = ce.Code
        INNER JOIN INDIGO036.dbo.INPROFSAL AS PRO ON PRO.CODPROSAL = h.CODPROSAL 
        INNER JOIN INDIGO036.dbo.INESPECIA AS ESP ON ESP.CODESPECI = PRO.CODESPEC1
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = h.IPCODPACI
        LEFT JOIN INDIGO036.Contract.CUPSEntityContractDescriptions cecd ON ce.Id = cecd.CUPSEntityId AND h.IDDESCRIPCIONRELACIONADA = cecd.Id
        LEFT JOIN INDIGO036.Contract.ContractDescriptions cd ON cecd.ContractDescriptionId = cd.Id
        WHERE h.MANEXTPRO = 1 AND NOT (h.ESTSERIPS IN ('6')) and cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal

        UNION ALL

        SELECT	
            'HCORDINTE' EntityName,
            h.AUTO EntityId,
            h.CODCENATE CareCenterCode,
            h.UFUCODIGO FunctionalUnitCode,
            h.NUMINGRES AdmissionNumber,
            h.NUMEFOLIO Folio,
            h.IPCODPACI PatientCode,
            h.FECORDMED RequestDate,
            h.CODPROSAL ProfessionalCode,
            h.CANSERIPS Quantity,
            1 Type,
            ce.Id ItemId,
            ce.Code ItemCode,
            h.CODSERIPS ItemCodeOriginal,
            ce.Description ItemName,
            cecd.Id ContractDescriptionId,
            cd.Id DescriptionId,
            CONCAT(cd.Code, ' - ', cd.Name) DescriptionCodeName,
            h.OBSSERIPS Observations,
            ESP.DESESPECI 'ESPECIALIDAD',
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
                WHEN '13' THEN 'PERMISO TEMPORAL DE PERMANENCIA'
                WHEN '14' THEN 'DOCUMENTO EXTRANJERO'
                WHEN '15' THEN 'SIN IDENTIFICACION'  
            END AS 'TIPO IDENTIFICACION',
            PRO.NOMMEDICO 'PROFESIONAL'
        FROM INDIGO036.dbo.HCORDINTE h
        INNER JOIN INDIGO036.Contract.CUPSEntity ce ON h.CODSERIPS = ce.Code
        INNER JOIN INDIGO036.dbo.INPROFSAL AS PRO ON PRO.CODPROSAL = h.CODPROSAL 
        INNER JOIN INDIGO036.dbo.INESPECIA AS ESP ON ESP.CODESPECI = PRO.CODESPEC1
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = h.IPCODPACI
        LEFT JOIN INDIGO036.Contract.CUPSEntityContractDescriptions cecd ON ce.Id = cecd.CUPSEntityId AND h.IDDESCRIPCIONRELACIONADA = cecd.Id
        LEFT JOIN INDIGO036.Contract.ContractDescriptions cd ON cecd.ContractDescriptionId = cd.Id
        WHERE h.MANEXTPRO = 1 AND NOT (h.ESTSERIPS IN ('5')) and cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal

        UNION ALL

        SELECT	
            'HCORDPRON' EntityName,
            h.AUTO EntityId,
            h.CODCENATE CareCenterCode,
            h.UFUCODIGO FunctionalUnitCode,
            h.NUMINGRES AdmissionNumber,
            h.NUMEFOLIO Folio,
            h.IPCODPACI PatientCode,
            h.FECORDMED RequestDate,
            h.CODPROSAL ProfessionalCode,
            h.CANSERIPS Quantity,
            1 Type,
            ce.Id ItemId,
            ce.Code ItemCode,
            h.CODSERIPS ItemCodeOriginal,
            ce.Description ItemName,
            cecd.Id ContractDescriptionId,
            cd.Id DescriptionId,
            CONCAT(cd.Code, ' - ', cd.Name) DescriptionCodeName,
            h.OBSSERIPS Observations,
            ESP.DESESPECI 'ESPECIALIDAD',
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
                WHEN '13' THEN 'PERMISO TEMPORAL DE PERMANENCIA'
                WHEN '14' THEN 'DOCUMENTO EXTRANJERO'
                WHEN '15' THEN 'SIN IDENTIFICACION'  
            END AS 'TIPO IDENTIFICACION',
            PRO.NOMMEDICO 'PROFESIONAL'
        FROM INDIGO036.dbo.HCORDPRON h
        INNER JOIN INDIGO036.Contract.CUPSEntity ce ON h.CODSERIPS = ce.Code
        INNER JOIN INDIGO036.dbo.INPROFSAL AS PRO ON PRO.CODPROSAL = h.CODPROSAL 
        INNER JOIN INDIGO036.dbo.INESPECIA AS ESP ON ESP.CODESPECI = PRO.CODESPEC1
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = h.IPCODPACI
        LEFT JOIN INDIGO036.Contract.CUPSEntityContractDescriptions cecd ON ce.Id = cecd.CUPSEntityId AND h.IDDESCRIPCIONRELACIONADA = cecd.Id
        LEFT JOIN INDIGO036.Contract.ContractDescriptions cd ON cecd.ContractDescriptionId = cd.Id
        WHERE h.MANEXTPRO = 1 AND NOT (h.ESTSERIPS IN ('5')) and cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal

        UNION ALL

        SELECT	
            'HCORDPROQ' EntityName,
            h.AUTO EntityId,
            h.CODCENATE CareCenterCode,
            h.UFUCODIGO FunctionalUnitCode,
            h.NUMINGRES AdmissionNumber,
            h.NUMEFOLIO Folio,
            h.IPCODPACI PatientCode,
            h.FECORDMED RequestDate,
            h.CODPROSAL ProfessionalCode,
            h.CANSERIPS Quantity,
            1 Type,
            ce.Id ItemId,
            ce.Code ItemCode,
            h.CODSERIPS ItemCodeOriginal,
            ce.Description ItemName,
            cecd.Id ContractDescriptionId,
            cd.Id DescriptionId,
            CONCAT(cd.Code, ' - ', cd.Name) DescriptionCodeName,
            h.OBSSERIPS Observations,
            ESP.DESESPECI 'ESPECIALIDAD',
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
                WHEN '13' THEN 'PERMISO TEMPORAL DE PERMANENCIA'
                WHEN '14' THEN 'DOCUMENTO EXTRANJERO'
                WHEN '15' THEN 'SIN IDENTIFICACION'  
            END AS 'TIPO IDENTIFICACION',
            PRO.NOMMEDICO 'PROFESIONAL'
        FROM INDIGO036.dbo.HCORDPROQ h
        INNER JOIN INDIGO036.Contract.CUPSEntity ce ON h.CODSERIPS = ce.Code
        INNER JOIN INDIGO036.dbo.INPROFSAL AS PRO ON PRO.CODPROSAL = h.CODPROSAL 
        INNER JOIN INDIGO036.dbo.INESPECIA AS ESP ON ESP.CODESPECI = PRO.CODESPEC1
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = h.IPCODPACI
        LEFT JOIN INDIGO036.Contract.CUPSEntityContractDescriptions cecd ON ce.Id = cecd.CUPSEntityId AND h.IDDESCRIPCIONRELACIONADA = cecd.Id
        LEFT JOIN INDIGO036.Contract.ContractDescriptions cd ON cecd.ContractDescriptionId = cd.Id
        WHERE h.MANEXTPRO = 1 AND NOT (h.ESTSERIPS IN ('3')) and cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal

        UNION ALL

        SELECT 
            'HCORHEMCO' EntityName,
            h.ID EntityId,
            h.CODCENATE CareCenterCode,
            ING.UFUCODIGO FunctionalUnitCode,
            h.NUMINGRES AdmissionNumber,
            h.NUMEFOLIO Folio,
            h.IPCODPACI PatientCode,
            h.FECORDMED RequestDate,
            '' ProfessionalCode,
            hd.Quantity Quantity,
            1 Type,
            ce.Id ItemId,
            ce.Code ItemCode,
            hd.CODSERIPS ItemCodeOriginal,
            ce.Description ItemName,
            cecd.Id ContractDescriptionId,
            cd.Id DescriptionId,
            CONCAT(cd.Code, ' - ', cd.Name) DescriptionCodeName,
            '' Observations,
            'ESPECIALIDAD' 'ESPECIALIDAD',
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
                WHEN '13' THEN 'PERMISO TEMPORAL DE PERMANENCIA'
                WHEN '14' THEN 'DOCUMENTO EXTRANJERO'
                WHEN '15' THEN 'SIN IDENTIFICACION'  
            END AS 'TIPO IDENTIFICACION',
            PRO.NOMMEDICO 'PROFESIONAL'
        FROM INDIGO036.dbo.ADINGRESO ING
        INNER JOIN INDIGO036.dbo.HCORHEMCO h ON ING.NUMINGRES = h.NUMINGRES
        INNER JOIN (
            SELECT	
                hd.HCORHEMCOID, 
                hd.CODSERIPS, 
                hd.TraceabilityPaperworkId, 
                hd.TraceabilityPaperworkEventsId, 
                hd.IDDESCRIPCIONRELACIONADA,
                COUNT(1) Quantity
            FROM INDIGO036.dbo.HCORHEMSER hd
            WHERE hd.ESTADO NOT IN (3)
            GROUP BY hd.HCORHEMCOID, hd.CODSERIPS, hd.TraceabilityPaperworkId, hd.TraceabilityPaperworkEventsId, hd.IDDESCRIPCIONRELACIONADA
        ) hd ON h.ID = hd.HCORHEMCOID
        INNER JOIN INDIGO036.Contract.CUPSEntity ce ON hd.CODSERIPS = ce.Code
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = h.IPCODPACI
        LEFT JOIN INDIGO036.dbo.HCHISPACA AS HIS ON HIS.NUMEFOLIO = h.NUMEFOLIO AND HIS.IPCODPACI = h.IPCODPACI AND HIS.NUMINGRES = h.NUMINGRES 
        LEFT JOIN INDIGO036.dbo.INPROFSAL AS PRO ON PRO.CODPROSAL = HIS.CODPROSAL 
        LEFT JOIN INDIGO036.Contract.CUPSEntityContractDescriptions cecd ON ce.Id = cecd.CUPSEntityId AND hd.IDDESCRIPCIONRELACIONADA = cecd.Id
        LEFT JOIN INDIGO036.Contract.ContractDescriptions cd ON cecd.ContractDescriptionId = cd.Id
        WHERE h.MANEXTPRO = 1 and cast(h.FECORDMED as date) between @FechaInicial and @FechaFinal

        UNION ALL

        SELECT	
            'HCDESCOEX' EntityName,
            h.AUTO EntityId,
            h.CODCENATE CareCenterCode,
            h.UFUCODIGO FunctionalUnitCode,
            h.NUMINGRES AdmissionNumber,
            h.NUMEFOLIO Folio,
            h.IPCODPACI PatientCode,
            HC.FECHISPAC RequestDate,
            HC.CODPROSAL ProfessionalCode,
            1 Quantity,
            1 Type,
            ce.Id ItemId,
            ce.Code ItemCode,
            h.CODSERIPS ItemCodeOriginal,
            ce.Description ItemName,
            cecd.Id ContractDescriptionId,
            cd.Id DescriptionId,
            CONCAT(cd.Code, ' - ', cd.Name) DescriptionCodeName,
            HC.INDICAMED Observations,
            ESP.DESESPECI 'ESPECIALIDAD',
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
                WHEN '13' THEN 'PERMISO TEMPORAL DE PERMANENCIA'
                WHEN '14' THEN 'DOCUMENTO EXTRANJERO'
                WHEN '15' THEN 'SIN IDENTIFICACION'  
            END AS 'TIPO IDENTIFICACION',
            PRO.NOMMEDICO 'PROFESIONAL'
        FROM INDIGO036.dbo.HCHISPACA HC
        INNER JOIN INDIGO036.dbo.HCDESCOEX h ON HC.NUMINGRES = h.NUMINGRES AND HC.NUMEFOLIO = h.NUMEFOLIO
        INNER JOIN INDIGO036.Contract.CUPSEntity ce ON h.CODSERIPS = ce.Code
        INNER JOIN INDIGO036.dbo.INPROFSAL AS PRO ON PRO.CODPROSAL = HC.CODPROSAL 
        INNER JOIN INDIGO036.dbo.INESPECIA AS ESP ON ESP.CODESPECI = PRO.CODESPEC1
        INNER JOIN INDIGO036.dbo.INPACIENT AS PAC ON PAC.IPCODPACI = h.IPCODPACI
        LEFT JOIN INDIGO036.Contract.CUPSEntityContractDescriptions cecd ON ce.Id = cecd.CUPSEntityId AND h.IDDESCRIPCIONRELACIONADA = cecd.Id
        LEFT JOIN INDIGO036.Contract.ContractDescriptions cd ON cecd.ContractDescriptionId = cd.Id
        WHERE cast(HC.FECHISPAC as date) between @FechaInicial and @FechaFinal
    ),
    CTE_GESTION_AUTORIZACIONES AS
    (
        SELECT 
            TP.AdmissionNumber,
            TP.ServiceCode,
            TP.EntityId,
            TP.EntityName,
            TP.PatientCode,
            TP.RequestDate,
            TP.RequestQuantity,
            TP.CancellationReasonsId,
            TP.CancellationReasonsObservations,
            TP.PreviousStatus,
            TP.Status,
            TP.CareGroupId,
            TP.HealthAdministratorId,
            TP.FunctionalUnitTargetId,
            TP.AcceptanceStatus,
            TP.ServiceId,
            TP.ContractDescriptionId 
        FROM INDIGO036.[Authorization].TraceabilityPaperwork TP
        WHERE TP.Type = 1
    ),
    CTE_PORTAFOLIO AS
    (
        SELECT 
            csa.Id,
            apcc.CareCenterCode,
            1 Type,
            apce.CUPSEntityId ItemId,
            apce.ContractDescriptionId DescriptionId,
            apce.AuthorizationGroupId
        FROM INDIGO036.[Authorization].AuthorizationPortfolioCareCenter apcc
        INNER JOIN INDIGO036.[Authorization].AuthorizationPortfolio ap ON apcc.AuthorizationPortfolioId = ap.Id
        INNER JOIN INDIGO036.[Authorization].AuthorizationPortfolioCUPSEntity apce ON ap.Id = apce.AuthorizationPortfolioId
        INNER JOIN INDIGO036.[Authorization].ConfigurationServicesAmbulatory csa ON apce.Id = csa.AuthorizationPortfolioCUPSEntityId
        WHERE ap.Status = 1
    ),
    CTE_RELACION AS
    (
        SELECT 
            ORD.*,
            AUT.PreviousStatus,
            AUT.Status AS ESTADO_AUTORIZACION,

            -- Reemplazo de IIF por CASE
            CASE 
                WHEN POR.Id IS NULL THEN 0 
                ELSE ISNULL(csae.SusceptibleAuthorization, 1) 
            END AS Authorized,

            fu.UFUDESCRI AS FunctionalUnitName,
            cg.Id AS CareGroupId, 
            cg.Code AS CareGroupCode, 
            cg.Name AS CareGroupName,
            ha.Id AS HealthAdministratorId, 
            ha.Code AS HealthAdministratorCode, 
            ha.Name AS HealthAdministratorName,

            RTRIM(LTRIM(P.IPNOMCOMP)) AS PatientName,
            P.IPDIRECCI AS PatientAddress,
            P.IPTELMOVI,
            P.IPTELEFON AS PatientPhone,

            -- Reemplazo de dbo.Edad por cálculo directo de edad
            DATEDIFF(YEAR, P.IPFECNACI, HC.FECHISPAC) - 
                CASE 
                    WHEN MONTH(HC.FECHISPAC) < MONTH(P.IPFECNACI) OR 
                        (MONTH(HC.FECHISPAC) = MONTH(P.IPFECNACI) AND DAY(HC.FECHISPAC) < DAY(P.IPFECNACI))
                    THEN 1 ELSE 0
                END AS PatientAge,

            P.IPFECNACI,
            HC.FECHISPAC,

            -- Clasificación TIPO SERVICIO
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
                ELSE 'OTROS'
            END AS TipoServicio,
            CASE ING.IESTADOIN 
                WHEN '' THEN 'ABIERTO' 
                WHEN 'F' THEN 'FACTURADO' 
                WHEN 'A' THEN 'ANULADO' 
                WHEN 'C' THEN 'CERRADO' 
                WHEN 'P' THEN 'FACTURADO PARCIAL' 
            END 'ESTADO INGRESO ATENCION',
            HC.CODDIAGNO 'CIE10', 
            DIA.NOMDIAGNO 'DIAGNOSTICO'
        FROM CTE_ORDENES ORD
        INNER JOIN INDIGO036.dbo.ADCENATEN cc ON ORD.CareCenterCode = cc.CODCENATE
        INNER JOIN INDIGO036.dbo.INUNIFUNC fu ON ORD.FunctionalUnitCode = fu.UFUCODIGO
        INNER JOIN INDIGO036.dbo.ADINGRESO ING ON ORD.AdmissionNumber = ING.NUMINGRES
        INNER JOIN INDIGO036.Contract.CareGroup cg ON ING.GENCAREGROUP = cg.Id
        INNER JOIN INDIGO036.Contract.HealthAdministrator ha ON ING.GENCONENTITY = ha.Id
        INNER JOIN INDIGO036.dbo.INPACIENT P ON ORD.PatientCode = P.IPCODPACI
        INNER JOIN INDIGO036.Contract.CUPSEntity AS CUPS ON CUPS.Code = ORD.ItemCodeOriginal 
        LEFT JOIN INDIGO036.Contract.ProcedureCups ptc ON ORD.Type = 1 AND cg.ProcedureTemplateId = ptc.ProceduresTemplateId AND ORD.ItemId = ptc.CupsId AND ISNULL(ORD.ContractDescriptionId, 0) = ISNULL(ptc.CUPSEntityContractDescriptionId, 0)
        LEFT JOIN CTE_GESTION_AUTORIZACIONES AS AUT ON ORD.EntityId = AUT.EntityId AND ORD.EntityName = AUT.EntityName  AND ORD.ItemCodeOriginal = AUT.ServiceCode
        LEFT JOIN CTE_PORTAFOLIO AS POR ON POR.CareCenterCode = ORD.CareCenterCode AND  ORD.ItemId = POR.ItemId AND ISNULL(ORD.DescriptionId, 0) = ISNULL(POR.DescriptionId, 0)
        LEFT JOIN INDIGO036.[Authorization].AuthorizationGroup ag on ag.Id = POR.AuthorizationGroupId
        LEFT JOIN INDIGO036.[Authorization].ConfigurationServicesAmbulatoryExceptions csae ON POR.Id = csae.ConfigurationServicesAmbulatoryId AND cg.Id = csae.CareGroupId
        LEFT JOIN INDIGO036.[Authorization].ManagementMedicalOrder mmo ON ORD.EntityName = mmo.EntityName AND ORD.EntityId = mmo.EntityId AND ORD.ItemCodeOriginal = mmo.ItemCode
        LEFT JOIN INDIGO036.dbo.HCHISPACA HC ON ORD.Folio = HC.NUMEFOLIO AND ORD.PatientCode = HC.IPCODPACI
        LEFT JOIN INDIGO036.dbo.INPROFSAL prof on prof.CODPROSAL = ORD.ProfessionalCode
        LEFT JOIN INDIGO036.dbo.INDIAGNOS AS DIA ON DIA.CODDIAGNO = HC.CODDIAGNO 
    ),
    CTE_DATOS_UNICOS_ORDENES AS
    (
        SELECT DISTINCT 
            AUT.PatientCode AS IDENTIFICACION,
            AUT.AdmissionNumber AS INGRESO,
            AUT.ItemCodeOriginal AS CUPS
        FROM CTE_RELACION AUT
        WHERE ESTADO_AUTORIZACION IS NULL
    ),
    CTE_PROGRAMACION_AGENDAMIENTOS AS
    (
        SELECT DISTINCT 
            CIT.IPCODPACI AS IDENTIFICACION,
            ACT.CODSERIPS AS CUPS, 
            IPS.DESSERIPS AS DESCRIPCION_CUPS,
            CAST(CIT.FECHORAIN AS DATE) AS FECHA_BUSQUEDA,
            CASE CIT.CODESTCIT 
                WHEN 0 THEN 'PROGRAMADA' 
                WHEN 1 THEN 'CUMPLIDA' 
            END AS ESTADO_CITA
        FROM INDIGO036.dbo.AGASICITA AS CIT
        INNER JOIN CTE_ORDENES AS ORD ON ORD.PatientCode = CIT.IPCODPACI 
        INNER JOIN INDIGO036.dbo.AGACTIMED AS ACT ON ACT.CODACTMED = CIT.CODACTMED 
        INNER JOIN INDIGO036.dbo.INCUPSIPS IPS ON IPS.CODSERIPS = ACT.CODSERIPS
        WHERE CIT.CODESTCIT IN ('0', '1')
    ),
    CTE_PROGRAMACION_AGENDAMIENTOS_CIRUGIAS AS
    (
        SELECT DISTINCT 
            AGE.IPCODPACI AS IDENTIFICACION,
            AGE.CODSERIPS AS CUPS, 
            IPS.DESSERIPS AS DESCRIPCION_CUPS,
            CAST(AGE.FECHORAIN AS DATE) AS FECHA_BUSQUEDA,
            'PROGRAMADO' AS ESTADO_CITA
        FROM INDIGO036.dbo.AGEPROGQX AGE
        INNER JOIN INDIGO036.dbo.INCUPSIPS IPS ON IPS.CODSERIPS = AGE.CODSERIPS
        INNER JOIN CTE_ORDENES AS ORD ON ORD.PatientCode = AGE.IPCODPACI 
    ),
    CTE_FACTURA_UNICA AS
    (
        SELECT DISTINCT 
            F.Id,
            F.InvoiceNumber,
            F.AdmissionNumber,
            F.PatientCode
        FROM INDIGO036.Billing.Invoice AS F
        INNER JOIN CTE_DATOS_UNICOS_ORDENES AS UNI ON UNI.IDENTIFICACION = F.PatientCode 
        WHERE F.DocumentType NOT IN (5, 6) AND F.Status = 1
    ),
    CTE_DETALLE_FACTURA AS
    (
        SELECT DISTINCT 
            F.PatientCode,
            CUPS.Code AS CUPS,
            CUPS.Description AS DESCRIPCION_CUPS,
            MIN(CAST(F.InvoiceDate AS DATE)) AS FECHA_FACTURA   
        FROM INDIGO036.Billing.Invoice AS F
        INNER JOIN CTE_FACTURA_UNICA AS FCAB ON FCAB.Id = F.Id
        INNER JOIN INDIGO036.Billing.InvoiceDetail AS ID ON ID.InvoiceId = F.Id 
        INNER JOIN INDIGO036.Billing.ServiceOrderDetail AS SOD ON SOD.Id = ID.ServiceOrderDetailId 
        INNER JOIN INDIGO036.Billing.ServiceOrder AS SO ON SO.Id = SOD.ServiceOrderId 
        INNER JOIN INDIGO036.Contract.CUPSEntity AS CUPS ON CUPS.Id = SOD.CUPSEntityId
        WHERE SOD.RecordType = 1
        GROUP BY F.PatientCode, CUPS.Code, CUPS.Description
    )
    SELECT DISTINCT 
        AUT.RequestDate AS FECHA_ORDEN,
        AUT.[TIPO IDENTIFICACION],
        AUT.PatientCode AS IDENTIFICACION,
        AUT.PatientName AS PACIENTE,
        AUT.AdmissionNumber AS INGRESO,
        AUT.[TipoServicio],
        'ORDENADO' AS ESTADO,
        AUT.PatientPhone AS TELEFONO,
        AUT.IPTELMOVI AS CELULAR,
        AUT.PatientAddress AS DIRECCION,
        AUT.ItemCodeOriginal AS CUPS,
        AUT.ItemName AS DESCRIPCION_CUPS,
        AUT.DescriptionCodeName AS DESCRIPCION_RELACIONADA,
        CASE AUT.Authorized WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END AS SUSCEPTIBLE_AUTORIZACION,
        AUT.FunctionalUnitName AS UNIDAD_FUNCIONAL,
        AUT.HealthAdministratorName AS ENTIDAD,
        AUT.CareGroupCode AS CODIGO_GRUPO_ATENCION,
        AUT.CareGroupName AS GRUPO_ATENCION,
        AUT.[ESTADO INGRESO ATENCION],
        CASE WHEN ISNULL(AGE.CUPS, CIR.CUPS) IS NULL THEN 'NO' ELSE 'SI' END AS PROGRAMADO_AGENDAMIENTO,
        ISNULL(AGE.CUPS, CIR.CUPS) AS CUPS_PROGRAMADO,
        ISNULL(AGE.DESCRIPCION_CUPS, CIR.DESCRIPCION_CUPS) AS CUPS_PROGRAMADO_DESCRIPCION,
        ISNULL(AGE.FECHA_BUSQUEDA, CIR.FECHA_BUSQUEDA) AS FECHA_PROGRAMADA, 
        ISNULL(AGE.ESTADO_CITA, CIR.ESTADO_CITA) AS ESTADO_CITA,
        CASE WHEN FAC.CUPS IS NULL THEN 'NO' ELSE 'SI' END AS CUPS_FACTURADO,
        FAC.FECHA_FACTURA,
        AUT.ESPECIALIDAD,
        AUT.Quantity AS CANTIDAD,
        AUT.PROFESIONAL,
        AUT.CIE10,
        AUT.DIAGNOSTICO,
        AUT.Observations AS OBSERVACION
    FROM CTE_RELACION AUT
    LEFT JOIN CTE_PROGRAMACION_AGENDAMIENTOS AS AGE 
        ON AUT.PatientCode = AGE.IDENTIFICACION 
        AND AUT.ItemCodeOriginal = AGE.CUPS 
        AND AGE.FECHA_BUSQUEDA >= AUT.RequestDate 
    LEFT JOIN CTE_PROGRAMACION_AGENDAMIENTOS_CIRUGIAS AS CIR 
        ON AUT.PatientCode = CIR.IDENTIFICACION 
        AND AUT.ItemCodeOriginal = CIR.CUPS 
        AND CIR.FECHA_BUSQUEDA >= AUT.RequestDate 
    LEFT JOIN CTE_DETALLE_FACTURA AS FAC 
        ON FAC.PatientCode = AUT.PatientCode 
        AND FAC.CUPS = AUT.ItemCodeOriginal 
        AND FAC.FECHA_FACTURA >= AUT.RequestDate
    WHERE ESTADO_AUTORIZACION IS NULL
    ORDER BY AUT.RequestDate DESC;