-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Detalles_Notas_Administrativa
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[Detalles_Notas_Administrativa]
AS
     SELECT DISTINCT 
            NP.ID, 
            NP.NUMINGRES AS Ingreso,
            CASE P.IPTIPODOC
                WHEN 1
                THEN 'CC'
                WHEN 2
                THEN 'CE'
                WHEN 3
                THEN 'TI'
                WHEN 4
                THEN 'RC'
                WHEN 5
                THEN 'PA'
                WHEN 6
                THEN 'AS'
                WHEN 7
                THEN 'MS'
                WHEN 8
                THEN 'NU'
            END AS Tipo_Documento_Paciente, 
            NP.IPCODPACI AS Paciente, 
            P.IPNOMCOMP AS Nombre_Paciente, 
            P.IPDIRECCI AS Direccion, 
            P.IPTELEFON AS Telefono, 
            P.IPTELMOVI AS Celular, 
            P.IPFECNACI AS Fecha_Nacimiento, 
            (CAST(DATEDIFF(dd, P.IPFECNACI, GETDATE()) / 365.25 AS INT)) AS Edad, 
            NP.FECHACREACION AS Fecha_Nota, 
            TN.NOMBRE AS Nombre_Nota, 
            --PR.NOMMEDICO AS Medico, 
            CA.NOMCENATE AS Centro_Atencion,
			US.NOMUSUARI AS USUARIO,
     (
         SELECT TVL.NOMBRE
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND
              LEFT JOIN dbo.NTVARIABLESL AS TVL ON TVL.CODIGO = ND.VALOR
                                                                     AND TVL.IDNTVARIABLE = ND.IDNTVARIABLE
         WHERE ND.IDNTVARIABLE = 2
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Tipo_Seguimiento, 
     (
         SELECT ND.VALOR
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND 
         WHERE ND.IDNTVARIABLE = 3
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Funcionario_Seguimiento, 
     (
         SELECT ND.VALOR
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND 
         WHERE ND.IDNTVARIABLE = 1
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Observaciones_Seguimiento, 
     (
         SELECT ND.VALOR
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND 
         WHERE ND.IDNTVARIABLE = 28
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS VISITA_DOMICILIARIA, 
     (
         SELECT ND.VALOR
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND 
         WHERE ND.IDNTVARIABLE = 29
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS LLAMADA_TELEFONICA, 
     (
         SELECT TVL.NOMBRE
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND 
              LEFT JOIN dbo.NTVARIABLESL AS TVL  ON TVL.CODIGO = ND.VALOR
                                                                                  AND TVL.IDNTVARIABLE = ND.IDNTVARIABLE
         WHERE ND.IDNTVARIABLE = 30
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS RESULTADO_LLAMADA_VISITA_DOCIMILIARIA, 
     (
         SELECT TVL.NOMBRE
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND 
              LEFT JOIN dbo.NTVARIABLESL AS TVL  ON TVL.CODIGO = ND.VALOR
                                                                                  AND TVL.IDNTVARIABLE = ND.IDNTVARIABLE
         WHERE ND.IDNTVARIABLE = 66
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Seguimiento_Telefonico_virtual_Educación, 
     (
         SELECT ND.VALOR
         FROM dbo.NTNOTASADMINISTRATIVASD AS ND
         WHERE ND.IDNTVARIABLE = 67
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Educacion_Realizada
     FROM dbo.NTNOTASADMINISTRATIVASC AS NP 
          INNER JOIN dbo.NTADMINISTRATIVAS AS TN  ON TN.ID = NP.IDNOTAADMINISTRATIVA
          INNER JOIN dbo.INPACIENT AS P  ON P.IPCODPACI = NP.IPCODPACI
          INNER JOIN dbo.ADCENATEN AS CA  ON CA.CODCENATE = NP.CODCENATE
          --INNER JOIN dbo.INPROFSAL AS PR  ON PR.CODPROSAL = NP.CODUSUARI
		  INNER JOIN dbo.SEGusuaru AS US ON US.CODUSUARI = NP.CODUSUARI
     WHERE TN.ID IN(1, 4); --and NP.IPCODPACI='91013619';
