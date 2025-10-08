-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_DETALLES_NOTAS_DOMICILIARIO_FARMACIA_2SEMESTRE
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VW_DETALLES_NOTAS_DOMICILIARIO_FARMACIA_2SEMESTRE
AS
SELECT DISTINCT NP.ID,
            CASE P.IPTIPODOC
                WHEN 1 THEN 'CC'
                WHEN 2 THEN 'CE'
                WHEN 3 THEN 'TI'
                WHEN 4 THEN 'RC'
                WHEN 5 THEN 'PA'
                WHEN 6 THEN 'AS'
                WHEN 7 THEN 'MS'
                WHEN 8 THEN 'NU'
            END AS Tipo_Documento_Paciente, NP.IPCODPACI AS Paciente, P.IPNOMCOMP AS Nombre_Paciente, 
            P.IPDIRECCI AS Direccion, P.IPTELEFON AS Telefono, P.IPTELMOVI AS Celular, P.IPFECNACI AS Fecha_Nacimiento, 
            (CAST(DATEDIFF(dd, P.IPFECNACI, GETDATE()) / 365.25 AS INT)) AS Edad, 
            NP.FECHACREACION AS Fecha_Nota, TN.NOMBRE AS Nombre_Nota, US.NOMUSUARI AS Usuario, CA.NOMCENATE AS Centro_Atencion, 
     (
         SELECT TVL.NOMBRE
         FROM [INDIGO031].[dbo].[NTNOTASADMINISTRATIVASD] AS ND 
              LEFT JOIN [INDIGO031].[dbo].[NTVARIABLESL] AS TVL  ON TVL.CODIGO = ND.VALOR
                                                                                  AND TVL.IDNTVARIABLE = ND.IDNTVARIABLE
         WHERE ND.IDNTVARIABLE = 2
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Tipo_Seguimiento, 
     (
         SELECT ND.VALOR
         FROM [INDIGO031].[dbo].[NTNOTASADMINISTRATIVASD] AS ND 
         WHERE ND.IDNTVARIABLE = 1
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Observaciones_Seguimiento, 
     (
         SELECT TVL.NOMBRE
         FROM [INDIGO031].[dbo].[NTNOTASADMINISTRATIVASD] AS ND 
              LEFT JOIN [INDIGO031].[dbo].[NTVARIABLESL] AS TVL  ON TVL.CODIGO = ND.VALOR
                                                                                  AND TVL.IDNTVARIABLE = ND.IDNTVARIABLE
         WHERE ND.IDNTVARIABLE = 69
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Origen, 
     (
         SELECT ND.VALOR
         FROM [INDIGO031].[dbo].[NTNOTASADMINISTRATIVASD] AS ND 
         WHERE ND.IDNTVARIABLE = 70
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Formula, 
     (
         SELECT ND.VALOR
         FROM [INDIGO031].[dbo].[NTNOTASADMINISTRATIVASD] AS ND 
         WHERE ND.IDNTVARIABLE = 72
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Fecha_Formula, 
     (
         SELECT ND.VALOR
         FROM [INDIGO031].[dbo].[NTNOTASADMINISTRATIVASD] AS ND 
         WHERE ND.IDNTVARIABLE = 71
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Fecha_Entrega
     FROM [INDIGO031].[dbo].[NTNOTASADMINISTRATIVASC] AS NP 
          INNER JOIN [INDIGO031].[dbo].[NTADMINISTRATIVAS] AS TN  ON TN.ID = NP.IDNOTAADMINISTRATIVA
          INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS P  ON P.IPCODPACI = NP.IPCODPACI
          INNER JOIN [INDIGO031].[dbo].[ADCENATEN] AS CA  ON CA.CODCENATE = NP.CODCENATE
          INNER JOIN [INDIGO031].[dbo].[SEGusuaru] AS US  ON US.CODUSUARI = NP.CODUSUARI
     WHERE TN.ID IN(5) AND NP.FECHACREACION > '09/01/2021 00:00:00'