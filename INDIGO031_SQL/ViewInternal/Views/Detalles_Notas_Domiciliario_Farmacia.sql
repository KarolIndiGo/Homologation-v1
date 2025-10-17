-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Detalles_Notas_Domiciliario_Farmacia
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[Detalles_Notas_Domiciliario_Farmacia]
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
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND 
              LEFT JOIN dbo.NTVARIABLESL AS TVL  ON TVL.CODIGO = ND.VALOR
                                                                                  AND TVL.IDNTVARIABLE = ND.IDNTVARIABLE
         WHERE ND.IDNTVARIABLE = 2
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Tipo_Seguimiento, 
     (
         SELECT ND.VALOR
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND 
         WHERE ND.IDNTVARIABLE = 1
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Observaciones_Seguimiento, 
     (
         SELECT TVL.NOMBRE
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND 
              LEFT JOIN dbo.NTVARIABLESL AS TVL  ON TVL.CODIGO = ND.VALOR
                                                                                  AND TVL.IDNTVARIABLE = ND.IDNTVARIABLE
         WHERE ND.IDNTVARIABLE = 69
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Origen, 
     (
         SELECT ND.VALOR
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND 
         WHERE ND.IDNTVARIABLE = 70
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Formula, 
     (
         SELECT ND.VALOR
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND 
         WHERE ND.IDNTVARIABLE = 72
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Fecha_Formula, 
     (
         SELECT ND.VALOR
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND 
         WHERE ND.IDNTVARIABLE = 71
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Fecha_Entrega
     FROM dbo.NTNOTASADMINISTRATIVASC AS NP 
          INNER JOIN dbo.NTADMINISTRATIVAS AS TN  ON TN.ID = NP.IDNOTAADMINISTRATIVA
          INNER JOIN dbo.INPACIENT AS P  ON P.IPCODPACI = NP.IPCODPACI
          INNER JOIN dbo.ADCENATEN AS CA  ON CA.CODCENATE = NP.CODCENATE
          INNER JOIN dbo.SEGusuaru AS US  ON US.CODUSUARI = NP.CODUSUARI
     WHERE TN.ID IN(5) AND NP.FECHACREACION > '01/01/2021 00:00:00'
