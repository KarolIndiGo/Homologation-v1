-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_INGRESOSABIERTOSAUTORIZACIONES
-- Extracted by Fabric SQL Extractor SPN v3.9.0








CREATE VIEW [Report].[View_HDSAP_INGRESOSABIERTOSAUTORIZACIONES]
AS
        SELECT ADINGRESO.IPCODPACI AS [DOC PACIENTE], 
            INPACIENT.IPNOMCOMP AS [NOMBRE PACIENTE], 
            ADINGRESO.NUMINGRES AS INGRESO,
            CASE
                WHEN ADINGRESO.IESTADOIN = ' '
                THEN 'No Facturado'
                WHEN ADINGRESO.IESTADOIN = 'F'
                THEN 'Facturado'
                WHEN ADINGRESO.IESTADOIN = 'A'
                THEN 'Anulado'
            END AS [ESTADO INGRESO], 
            ADINGRESO.IFECHAING AS FECHAINGRESO, 
            ADINGRESO.CODUSUCRE AS [COD USUARIO CREA], 
            SEGusuaru_2.NOMUSUARI AS [USUARIO CREA], 
            UF.UFUDESCRI AS [UNIDAD FUNCIONAL], 
            ADINGRESO.FECREGCRE AS [FEC CREACION INGRESO], 
            ADINGRESO.CODUSUMOD AS [COD USUARIO MODIFICA], 
            SEGusuaru_1.NOMUSUARI AS [USUARIO MODIFICA], 
            ADINGRESO.FECREGMOD AS [FECHA MODIFICACION], 
            ADINGRESO.CODUSUANU AS [COD USUARIO ANULA], 
            SEGusuaru.NOMUSUARI AS [USUARIO ANULA], 
            ADINGRESO.FECREGANU AS [FECHA ANULACION], 
            ADINGRESO.IJUSTIFIC AS [JUSTIFICACION ANULACION],
            CASE
                WHEN ADINGRESO.IINGREPOR = '1'
                THEN 'URGENCIAS'
                WHEN ADINGRESO.IINGREPOR = '2'
                THEN 'CONSULTA EXTERNA'
                WHEN ADINGRESO.IINGREPOR = '3'
                THEN 'NACIDO HOSPITAL'
                WHEN ADINGRESO.IINGREPOR = '4'
                THEN 'REMITIDO'
                WHEN ADINGRESO.IINGREPOR = '5'
                THEN 'HOSPITALIZACION URGENCIAS'
            END AS [INGRESA POR], 
            ADINGRESO.IOBSERVAC AS Observaciones, 
            INENTIDAD.NOMENTIDA,
            CASE ADINGRESO.ICAUSAING
                WHEN 1
                THEN 'Heridos en combate'
                WHEN 2
                THEN 'Enfermedad profesional'
                WHEN 3
                THEN 'Enfermedad general adulto'
                WHEN 4
                THEN 'Enfermedad general pediatria'
                WHEN 5
                THEN 'Odontología'
                WHEN 6
                THEN 'Accidente de transito'
                WHEN 7
                THEN 'Catastrofe/Fisalud'
                WHEN 8
                THEN 'Quemados'
                WHEN 9
                THEN 'Maternidad'
                WHEN 10
                THEN 'Accidente Laboral'
                WHEN 11
                THEN 'Cirugia Programada'
            END AS [CAUSAINGRESO]
     FROM ADINGRESO
          INNER JOIN INPACIENT ON ADINGRESO.IPCODPACI = INPACIENT.IPCODPACI
          INNER JOIN INENTIDAD ON ADINGRESO.CODENTIDA = INENTIDAD.CODENTIDA
          LEFT OUTER JOIN SEGusuaru ON ADINGRESO.CODUSUANU = SEGusuaru.CODUSUARI
          LEFT OUTER JOIN SEGusuaru AS SEGusuaru_2 ON ADINGRESO.CODUSUCRE = SEGusuaru_2.CODUSUARI
          LEFT OUTER JOIN SEGusuaru AS SEGusuaru_1 ON ADINGRESO.CODUSUMOD = SEGusuaru_1.CODUSUARI
          LEFT OUTER JOIN INUNIFUNC AS UF ON ADINGRESO.UFUCODIGO = UF.UFUCODIGO
    -- WHERE(ADINGRESO.IESTADOIN = '  ');

