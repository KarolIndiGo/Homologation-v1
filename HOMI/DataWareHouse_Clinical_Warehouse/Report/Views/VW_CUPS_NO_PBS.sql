-- Workspace: HOMI
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9e4ad354-8031-4a13-8643-33b3234761ff
-- Schema: Report
-- Object: VW_CUPS_NO_PBS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW Report.VW_CUPS_NO_PBS
AS 

WITH CTE_W AS (
    SELECT
        A.IPCODPACI AS IDENTICACION,
        D.IPNOMCOMP AS PACIENTE,
        A.NUMINGRES AS INGRESO,
        A.CODPROSAL AS IDENTIFICACION_MEDICO,
        A.FECORDMED AS FECHA_ORDEN,
        A.CODSERIPS AS CUPS,
        B.Description AS DESCRIPCION,
        CASE
            A.ESTSERIPS
            WHEN 1 THEN 'Ordenado'
            WHEN 2 THEN 'Completado'
            WHEN 3 THEN 'Interpretado'
            WHEN 4 THEN 'Sin Interfaz'
            WHEN 5 THEN 'Anulado'
        END AS ESTADO,
        C.UFUDESCRI AS UFN,
        E.IFECHAING AS FECHA_INGRESO,
        CASE
            E.TIPOINGRE
            WHEN 1 THEN 'Ambulatorio'
            WHEN 2 THEN 'Hospitalario'
        END AS TIPO_INGRESO,
        CASE
            E.TIPOINGRE
            WHEN 2 THEN F.FECEGRESO
            WHEN 1 THEN E.IFECHAING
        END AS FECHA_EGRESO,
        G.Name AS EPS,
        TRIM(E.IAUTORIZA) AS NUMERO_AUTORIZACION,
        A.TraceabilityPaperworkId AS TRAMITE_AUTORIZACION
    FROM
        [INDIGO036].[dbo].[HCORDPRON] A
        LEFT JOIN [INDIGO036].[Contract].[CUPSEntity] B ON A.CODSERIPS = B.Code
        LEFT JOIN [INDIGO036].[dbo].[INUNIFUNC] C ON A.UFUCODIGO = C.UFUCODIGO
        LEFT JOIN [INDIGO036].[dbo].[INPACIENT] D ON A.IPCODPACI = D.IPCODPACI
        LEFT JOIN [INDIGO036].[dbo].[ADINGRESO] E ON A.NUMINGRES = E.NUMINGRES
        LEFT JOIN [INDIGO036].[dbo].[CHREGEGRE] F ON A.NUMINGRES = F.NUMINGRES
        LEFT JOIN [INDIGO036].[Contract].[CareGroup] G ON E.CODENTIDA = G.Code
    WHERE
        CONVERT(DATE, A.FECORDMED, 34) >= CONVERT(VARCHAR, '2024-01-01', 34)
        AND B.FinancedResourceUPC = 0
        AND E.TIPOINGRE = 2
    UNION
    SELECT
        A.IPCODPACI,
        D.IPNOMCOMP,
        A.NUMINGRES,
        A.CODPROSAL,
        A.FECORDMED,
        A.CODSERIPS,
        B.Description,
        CASE
            A.ESTSERIPS
            WHEN 1 THEN 'Solicitado '
            WHEN 2 THEN 'Sala Programada '
            WHEN 3 THEN 'Cancelado '
            WHEN 4 THEN 'Resultado Revisado '
            WHEN 5 THEN 'Anulado'
            WHEN 6 THEN 'Programado no realizado'
        END AS ESTADO,
        C.UFUDESCRI,
        E.IFECHAING,
        CASE
            E.TIPOINGRE
            WHEN 1 THEN 'Ambulatorio'
            WHEN 2 THEN 'Hospitalario'
        END AS TIPO_INGRESO,
        CASE
            E.TIPOINGRE
            WHEN 2 THEN F.FECEGRESO
            WHEN 1 THEN E.IFECHAING
        END AS FECHA_EGRESO,
        G.Name,
        TRIM(E.IAUTORIZA) AS NUMERO_AUTORIZACION,
        A.TraceabilityPaperworkId AS TRAMITE_AUTORIZACION
    FROM
        [INDIGO036].[dbo].[HCORDPROQ] A
        LEFT JOIN [INDIGO036].[Contract].[CUPSEntity] B ON A.CODSERIPS = B.Code
        LEFT JOIN [INDIGO036].[dbo].[INUNIFUNC] C ON A.UFUCODIGO = C.UFUCODIGO
        LEFT JOIN [INDIGO036].[dbo].[INPACIENT] D ON A.IPCODPACI = D.IPCODPACI
        LEFT JOIN [INDIGO036].[dbo].[ADINGRESO] E ON A.NUMINGRES = E.NUMINGRES
        LEFT JOIN [INDIGO036].[dbo].[CHREGEGRE] F ON A.NUMINGRES = F.NUMINGRES
        LEFT JOIN [INDIGO036].[Contract].[CareGroup] G ON E.CODENTIDA = G.Code
    WHERE
        CONVERT(DATE, A.FECORDMED, 34) >= CONVERT(VARCHAR, '2024-01-01', 34)
        AND B.FinancedResourceUPC = 0
        AND E.TIPOINGRE = 2
    UNION
    SELECT
        A.IPCODPACI,
        D.IPNOMCOMP,
        A.NUMINGRES,
        A.CODPROSAL,
        A.FECORDMED,
        A.CODSERIPS,
        B.Description,
        CASE
            A.ESTSERIPS
            WHEN 1 THEN 'Solicitado '
            WHEN 2 THEN 'Muestra Recolectada'
            WHEN 3 THEN 'Resultado Entregado  '
            WHEN 4 THEN 'Examen Interpretado'
            WHEN 5 THEN 'Remitido '
            WHEN 6 THEN 'Anulado '
            WHEN 7 THEN 'Extramural'
        END AS ESTADO,
        C.UFUDESCRI,
        E.IFECHAING,
        CASE
            E.TIPOINGRE
            WHEN 1 THEN 'Ambulatorio'
            WHEN 2 THEN 'Hospitalario'
        END AS TIPO_INGRESO,
        CASE
            E.TIPOINGRE
            WHEN 2 THEN F.FECEGRESO
            WHEN 1 THEN E.IFECHAING
        END AS FECHA_EGRESO,
        G.Name,
        TRIM(E.IAUTORIZA) AS NUMERO_AUTORIZACION,
        A.TraceabilityPaperworkId AS TRAMITE_AUTORIZACION
    FROM
        [INDIGO036].[dbo].[HCORDPATO] A
        LEFT JOIN [INDIGO036].[Contract].[CUPSEntity] B ON A.CODSERIPS = B.Code
        LEFT JOIN [INDIGO036].[dbo].[INUNIFUNC] C ON A.UFUCODIGO = C.UFUCODIGO
        LEFT JOIN [INDIGO036].[dbo].[INPACIENT] D ON A.IPCODPACI = D.IPCODPACI
        LEFT JOIN [INDIGO036].[dbo].[ADINGRESO] E ON A.NUMINGRES = E.NUMINGRES
        LEFT JOIN [INDIGO036].[dbo].[CHREGEGRE] F ON A.NUMINGRES = F.NUMINGRES
        LEFT JOIN [INDIGO036].[Contract].[CareGroup] G ON E.CODENTIDA = G.Code
    WHERE
        CONVERT(DATE, A.FECORDMED, 34) >= CONVERT(VARCHAR, '2024-01-01', 34)
        AND B.FinancedResourceUPC = 0
        AND E.TIPOINGRE = 2
    UNION
    SELECT
        A.IPCODPACI,
        D.IPNOMCOMP,
        A.NUMINGRES,
        A.CODPROSAL,
        A.FECORDMED,
        A.CODSERIPS,
        B.Description,
        CASE
            A.ESTSERIPS
            WHEN 1 THEN 'Solicitado '
            WHEN 2 THEN 'Muestra Recolectada'
            WHEN 3 THEN 'Resultado Entregado  '
            WHEN 4 THEN 'Examen Interpretado'
            WHEN 5 THEN 'Remitido '
            WHEN 6 THEN 'Anulado '
            WHEN 7 THEN 'Extramural'
            WHEN 8 THEN 'Muestra Recolectada Parcialmente'
        END AS ESTADO,
        C.UFUDESCRI,
        E.IFECHAING,
        CASE
            E.TIPOINGRE
            WHEN 1 THEN 'Ambulatorio'
            WHEN 2 THEN 'Hospitalario'
        END AS TIPO_INGRESO,
        CASE
            E.TIPOINGRE
            WHEN 2 THEN F.FECEGRESO
            WHEN 1 THEN E.IFECHAING
        END AS FECHA_EGRESO,
        G.Name,
        TRIM(E.IAUTORIZA) AS NUMERO_AUTORIZACION,
        A.TraceabilityPaperworkId AS TRAMITE_AUTORIZACION
    FROM
        [INDIGO036].[dbo].[HCORDLABO] A
        LEFT JOIN [INDIGO036].[Contract].[CUPSEntity] B ON A.CODSERIPS = B.Code
        LEFT JOIN [INDIGO036].[dbo].[INUNIFUNC] C ON A.UFUCODIGO = C.UFUCODIGO
        LEFT JOIN [INDIGO036].[dbo].[INPACIENT] D ON A.IPCODPACI = D.IPCODPACI
        LEFT JOIN [INDIGO036].[dbo].[ADINGRESO] E ON A.NUMINGRES = E.NUMINGRES
        LEFT JOIN [INDIGO036].[dbo].[CHREGEGRE] F ON A.NUMINGRES = F.NUMINGRES
        LEFT JOIN [INDIGO036].[Contract].[CareGroup] G ON E.CODENTIDA = G.Code
    WHERE
        CONVERT(DATE, A.FECORDMED, 34) >= CONVERT(VARCHAR, '2024-01-01', 34)
        AND B.FinancedResourceUPC = 0
        AND E.TIPOINGRE = 2
    UNION
    SELECT
        A.IPCODPACI,
        D.IPNOMCOMP,
        A.NUMINGRES,
        A.CODPROSAL,
        A.FECORDMED,
        A.CODSERIPS,
        B.Description,
        CASE
            A.ESTSERIPS
            WHEN 1 THEN 'Solicitado '
            WHEN 2 THEN 'Estudio Realizado'
            WHEN 3 THEN 'Imagen Procesada'
            WHEN 4 THEN 'Estudio Interpretado'
            WHEN 5 THEN 'Remitido '
            WHEN 6 THEN 'Anulado '
            WHEN 7 THEN 'Extramural'
        END AS ESTADO,
        C.UFUDESCRI,
        E.IFECHAING,
        CASE
            E.TIPOINGRE
            WHEN 1 THEN 'Ambulatorio'
            WHEN 2 THEN 'Hospitalario'
        END AS TIPO_INGRESO,
        CASE
            E.TIPOINGRE
            WHEN 2 THEN F.FECEGRESO
            WHEN 1 THEN E.IFECHAING
        END AS FECHA_EGRESO,
        G.Name,
        TRIM(E.IAUTORIZA) AS NUMERO_AUTORIZACION,
        A.TraceabilityPaperworkId AS TRAMITE_AUTORIZACION
    FROM
        [INDIGO036].[dbo].[HCORDIMAG] A
        LEFT JOIN [INDIGO036].[Contract].[CUPSEntity] B ON A.CODSERIPS = B.Code
        LEFT JOIN [INDIGO036].[dbo].[INUNIFUNC] C ON A.UFUCODIGO = C.UFUCODIGO
        LEFT JOIN [INDIGO036].[dbo].[INPACIENT] D ON A.IPCODPACI = D.IPCODPACI
        LEFT JOIN [INDIGO036].[dbo].[ADINGRESO] E ON A.NUMINGRES = E.NUMINGRES
        LEFT JOIN [INDIGO036].[dbo].[CHREGEGRE] F ON A.NUMINGRES = F.NUMINGRES
        LEFT JOIN [INDIGO036].[Contract].[CareGroup] G ON E.CODENTIDA = G.Code
    WHERE
        CONVERT(DATE, A.FECORDMED, 34) >= CONVERT(VARCHAR, '2024-01-01', 34)
        AND B.FinancedResourceUPC = 0
        AND E.TIPOINGRE = 2
)
SELECT
    W.*,
    CASE
        T.PROESTADO
        WHEN 1 THEN 'Pendiente por Autorizar'
        WHEN 2 THEN 'Autorizado'
        WHEN 3 THEN 'No Autorizado'
        WHEN 4 THEN 'Autorizado con Aval'
    END AS ESTADO_AUTORIZACION
FROM CTE_W W
LEFT JOIN [INDIGO036].[dbo].[ADAUTOSER] T ON TRIM(T.NUMINGRES) = TRIM(W.INGRESO)
    AND TRIM(T.CODSERIPS) = TRIM(W.CUPS)