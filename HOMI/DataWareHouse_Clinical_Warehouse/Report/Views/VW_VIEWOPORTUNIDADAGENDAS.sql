-- Workspace: HOMI
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9e4ad354-8031-4a13-8643-33b3234761ff
-- Schema: Report
-- Object: VW_VIEWOPORTUNIDADAGENDAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW Report.VW_VIEWOPORTUNIDADAGENDAS AS 
WITH CTE_AGENDA AS (
                    SELECT
                        CAST(DB_NAME() AS VARCHAR(9)) AS [ID_COMPANY],
                        MAX(A.CODAUTONU) AS CODAUTONU,
                        C.NOMCENATE AS 'CENTRO DE ATENCION',
                        CON.DESCRICON AS 'CONSULTORIO',
                        B.DESESPECI AS 'ESPECIALIDAD',
                        E.NOMMEDICO AS 'PROFESIONAL',
                        CONVERT(VARCHAR, MIN(FECHORAIN), 23) AS 'FECHA INICIAL DE AGENDA',
                        CONVERT(VARCHAR, MIN(FECHORAIN), 20) AS 'FECHA HORA INICIAL DE AGENDA',
                        CONVERT(VARCHAR, MAX(FECHORAFI), 23) AS 'FECHA FINAL DE AGENDA',
                        CONVERT(VARCHAR, MAX(FECHORAFI), 20) AS 'FECHA HORA FINAL DE AGENDA',
                        SUM(DATEDIFF(HOUR, A.FECHORAIN, A.FECHORAFI)) AS 'HORAS DIA',
                        SUM(ISNULL(GB.HORAS, 0)) AS 'HORAS BLOQUEO',
                        SUM(ISNULL(G.CITAS, 0)) AS 'NRO DE CITAS DIAS',
                        SUM(ISNULL(GC.CITASCUMPLIDAS, 0)) AS 'CITAS CUMPLIDAS',
                        SUM(ISNULL(GI.CITASINCUMPLIDAS, 0)) AS 'CITAS INCUMPLIDAS',
                        CAST(A.FECHORAIN AS DATE) AS 'FECHA BUSQUEDA'
                    FROM
                        INDIGO036.dbo.AGAGEMEDC AS A
                        JOIN INDIGO036.dbo.INPROFSAL AS E ON A.CODPROSAL = E.CODPROSAL
                        JOIN INDIGO036.dbo.INESPECIA AS B ON A.CODESPECI = B.CODESPECI
                        JOIN INDIGO036.dbo.ADCENATEN AS C ON A.CODCENATE = C.CODCENATE
                        JOIN INDIGO036.dbo.AGCONSULT AS CON ON A.CODIGOCON = CON.CODIGOCON
                            AND C.CODCENATE = CON.CODCENATE

                        -- Horas de Bloqueo Parcial
                        LEFT JOIN (
                            SELECT
                                IDAGENDA,
                                SUM(DATEDIFF(HOUR, FECHAINIBLOQUEO, FECHAFINBLOQUEO)) AS 'HORAS'
                            FROM
                                INDIGO036.dbo.AGBLOQUEOPARCIAL
                            WHERE
                                ESTADO = 1
                            GROUP BY
                                IDAGENDA
                        ) AS GB ON GB.IDAGENDA = A.CODAUTONU

                        -- Citas Totales
                        LEFT JOIN (
                            SELECT
                                COUNT(IDAGENDA) AS CITAS,
                                IDAGENDA
                            FROM
                                INDIGO036.dbo.AGASICITA
                            WHERE
                                TIPSOLICITU = 1
                                AND CODESTCIT <> 4
                            GROUP BY
                                IDAGENDA
                        ) AS G ON G.IDAGENDA = A.CODAUTONU

                        -- Citas Asignadas
                        LEFT JOIN (
                            SELECT
                                COUNT(IDAGENDA) AS CITASASIGNADAS,
                                IDAGENDA
                            FROM
                                INDIGO036.dbo.AGASICITA
                            WHERE
                                TIPSOLICITU = 1
                                AND CODESTCIT = 0
                            GROUP BY
                                IDAGENDA
                        ) AS GA ON GA.IDAGENDA = A.CODAUTONU

                        -- Citas Cumplidas
                        LEFT JOIN (
                            SELECT
                                COUNT(IDAGENDA) AS CITASCUMPLIDAS,
                                IDAGENDA
                            FROM
                                INDIGO036.dbo.AGASICITA
                            WHERE
                                TIPSOLICITU = 1
                                AND CODESTCIT = 1
                            GROUP BY
                                IDAGENDA
                        ) AS GC ON GC.IDAGENDA = A.CODAUTONU

                        -- Citas Incumplidas
                        LEFT JOIN (
                            SELECT
                                COUNT(IDAGENDA) AS CITASINCUMPLIDAS,
                                IDAGENDA
                            FROM
                                INDIGO036.dbo.AGASICITA
                            WHERE
                                TIPSOLICITU = 1
                                AND CODESTCIT = 2
                            GROUP BY
                                IDAGENDA
                        ) AS GI ON GI.IDAGENDA = A.CODAUTONU

                    GROUP BY
                        C.NOMCENATE,
                        CON.DESCRICON,
                        B.DESESPECI,
                        E.NOMMEDICO,
                        YEAR(FECHORAIN),
                        MONTH(FECHORAIN),
                        DAY(FECHORAIN),
                        YEAR(FECHORAFI),
                        MONTH(FECHORAFI),
                        DAY(FECHORAFI),
                        CAST(A.FECHORAIN AS DATE)
                )

                -- Consulta final
                SELECT
                    *,
                    YEAR([FECHA BUSQUEDA]) AS 'AÑO FECHA BUSQUEDA',
                    MONTH([FECHA BUSQUEDA]) AS 'MES AÑO FECHA BUSQUEDA',
                    CASE
                        MONTH([FECHA BUSQUEDA])
                        WHEN 1 THEN 'ENERO'
                        WHEN 2 THEN 'FEBRERO'
                        WHEN 3 THEN 'MARZO'
                        WHEN 4 THEN 'ABRIL'
                        WHEN 5 THEN 'MAYO'
                        WHEN 6 THEN 'JUNIO'
                        WHEN 7 THEN 'JULIO'
                        WHEN 8 THEN 'AGOSTO'
                        WHEN 9 THEN 'SEPTIEMBRE'
                        WHEN 10 THEN 'OCTUBRE'
                        WHEN 11 THEN 'NOVIEMBRE'
                        WHEN 12 THEN 'DICIEMBRE'
                    END AS 'MES NOMBRE FECHA BUSQUEDA',
                    DAY([FECHA BUSQUEDA]) AS 'DIA FECHA BUSQUEDA',
                    CONVERT(
                        DATETIME,
                        GETDATE() AT TIME ZONE 'Pakistan Standard Time',
                        1
                    ) AS ULT_ACTUAL
                FROM
                    CTE_AGENDA;