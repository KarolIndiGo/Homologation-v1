-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: SP_HIS_ORDENAMIENTOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE [Report].[SP_HIS_ORDENAMIENTOS]
	@FECINI Datetime ,
	@FECFIN Datetime 
AS

--DECLARE	@FECINI Datetime ='2022-07-01';
--DECLARE	@FECFIN Datetime ='2022-07-31';

SELECT 
 [FECHA ORDEN], 
 [IDENTIFICACION], 
 [NOMBRES], 
 [INGRESO],
 [UNIDAD], 
 [CAMA], 
 [ENTIDAD], 
 [OBSERVACION], 
 [DESCRIPCION_ESP], 
 [TipoExamen], 
 [FOLIO], 
 [CODIGORIPS], 
 [DES_RIPS], 
 [CANTIDAD], 
 [OBSERVACION_RIPS]
 FROM
     (
         ----IMAGENES--
         SELECT DISTINCT 
                A.FECORDMED AS [FECHA ORDEN], 
                p.IPCODPACI AS [IDENTIFICACION], 
                P.IPNOMCOMP AS [NOMBRES], 
                U.UFUDESCRI AS [UNIDAD], 
                I.NUMINGRES AS [INGRESO], 
                C.DESCCAMAS AS [CAMA], 
                E.NOMENTIDA AS [ENTIDAD], 
                I.IOBSERVAC AS [OBSERVACION], 
                A.CODPROSAL, 
                es.DESESPECI AS [DESCRIPCION_ESP], 
                SG.DESSUBIPS AS [TipoExamen], 
                A.NUMEFOLIO AS [FOLIO], 
                RTRIM(B.CODSERIPS) AS [CODIGORIPS], 
                RTRIM(DESSERIPS) AS [DES_RIPS], 
                A.CANSERIPS AS [CANTIDAD], 
                A.OBSSERIPS [OBSERVACION_RIPS], 
                a.ESTSERIPS
         FROM dbo.HCORDIMAG A
              INNER JOIN dbo.INCUPSIPS B ON A.CODSERIPS = B.CODSERIPS
              INNER JOIN dbo.INCUPSSUB SG ON SG.CODGRUSUB = B.CODGRUSUB
              INNER JOIN dbo.ADINGRESO I ON I.NUMINGRES = A.NUMINGRES
              INNER JOIN dbo.INPACIENT P ON P.IPCODPACI = i.IPCODPACI
              INNER JOIN dbo.INPROFSAL pr ON A.CODPROSAL = pr.CODPROSAL
              INNER JOIN dbo.INESPECIA es ON pr.CODESPEC1 = es.CODESPECI
              INNER JOIN dbo.INENTIDAD E ON E.CODENTIDA = I.CODENTIDA
              LEFT JOIN dbo.CHREGESTA CH ON CH.NUMINGRES = I.NUMINGRES
                                                      AND CH.REGESTADO = '1'
              LEFT JOIN dbo.CHCAMASHO C ON C.CODICAMAS = CH.CODICAMAS
              LEFT JOIN dbo.INUNIFUNC AS U ON U.UFUCODIGO = A.UFUCODIGO
              LEFT JOIN dbo.ADCONFSER S ON S.CODSERIPS = A.CODSERIPS
              LEFT JOIN dbo.ADAUTOSER ss ON SS.IPCODPACI = a.IPCODPACI
                                                                   AND SS.NUMINGRES = A.NUMINGRES
                                                                   AND SS.CODSERIPS = A.CODSERIPS
                                                                   AND SS.NUMEFOLIO = A.NUMEFOLIO

         UNION ALL

         ------PATOLOGIAS--
         SELECT DISTINCT 
                A.FECORDMED AS [FECHA ORDEN], 
                p.IPCODPACI AS [identificacion], 
                P.IPNOMCOMP AS [NOMBRES], 
                U.UFUDESCRI AS [UNIDAD],  
                I.NUMINGRES AS [INGRESO], 
                C.DESCCAMAS AS [CAMA], 
                E.NOMENTIDA AS [ENTIDAD], 
                I.IOBSERVAC AS [OBSERVACION], 
                A.CODPROSAL, 
                es.DESESPECI AS [DESCRIPCION_ESP], 
                SG.DESSUBIPS AS [TipoExamen], 
                A.NUMEFOLIO AS [FOLIO], 
                RTRIM(B.CODSERIPS) AS [CODIGORIPS], 
                RTRIM(DESSERIPS) AS [DES_RIPS], 
                A.CANSERIPS AS [CANTIDAD], 
                A.OBSSERIPS [OBSERVACION_RIPS], 
                a.ESTSERIPS
         FROM dbo.HCORDPATO A
              INNER JOIN dbo.INCUPSIPS B ON A.CODSERIPS = B.CODSERIPS
              INNER JOIN dbo.INCUPSSUB SG ON SG.CODGRUSUB = B.CODGRUSUB
              INNER JOIN dbo.ADINGRESO I ON I.NUMINGRES = A.NUMINGRES
              INNER JOIN dbo.INPACIENT P ON P.IPCODPACI = i.IPCODPACI
              INNER JOIN dbo.INPROFSAL pr ON A.CODPROSAL = pr.CODPROSAL
              INNER JOIN dbo.INESPECIA es ON pr.CODESPEC1 = es.CODESPECI
              INNER JOIN dbo.INENTIDAD E ON E.CODENTIDA = I.CODENTIDA
              LEFT JOIN dbo.CHREGESTA CH ON CH.NUMINGRES = I.NUMINGRES
                                                      AND CH.REGESTADO = '1'
              LEFT JOIN dbo.CHCAMASHO C ON C.CODICAMAS = CH.CODICAMAS
              LEFT JOIN dbo.INUNIFUNC AS U ON U.UFUCODIGO = A.UFUCODIGO
              LEFT JOIN dbo.ADCONFSER S ON S.CODSERIPS = A.CODSERIPS
              LEFT JOIN dbo.ADAUTOSER ss ON SS.IPCODPACI = a.IPCODPACI
                                                                   AND SS.NUMINGRES = A.NUMINGRES
                                                                   AND SS.CODSERIPS = A.CODSERIPS
                                                                   AND SS.NUMEFOLIO = A.NUMEFOLIO
         UNION ALL
         ------PROCEDIMIENTO NQ--
         SELECT DISTINCT 
                A.FECORDMED AS [FECHA ORDEN], 
                p.IPCODPACI AS [identificacion], 
                P.IPNOMCOMP AS [NOMBRES], 
                U.UFUDESCRI AS [UNIDAD], 
                I.NUMINGRES AS [INGRESO], 
                C.DESCCAMAS AS [CAMA], 
                E.NOMENTIDA AS [ENTIDAD], 
                I.IOBSERVAC AS [OBSERVACION], 
                A.CODPROSAL, 
                es.DESESPECI AS [DESCRIPCION_ESP], 
                SG.DESSUBIPS AS [TipoExamen], 
                A.NUMEFOLIO AS [FOLIO], 
                RTRIM(B.CODSERIPS) AS [CODIGORIPS], 
                RTRIM(DESSERIPS) AS [DES_RIPS], 
                A.CANSERIPS AS [CANTIDAD], 
                A.OBSSERIPS [OBSERVACION_RIPS], 
                a.ESTSERIPS
         FROM dbo.HCORDPRON A
              INNER JOIN dbo.INCUPSIPS B ON A.CODSERIPS = B.CODSERIPS
              INNER JOIN dbo.INCUPSSUB SG ON SG.CODGRUSUB = B.CODGRUSUB
              INNER JOIN dbo.ADINGRESO I ON I.NUMINGRES = A.NUMINGRES
              INNER JOIN dbo.INPACIENT P ON P.IPCODPACI = i.IPCODPACI
              INNER JOIN dbo.INPROFSAL pr ON A.CODPROSAL = pr.CODPROSAL
              INNER JOIN dbo.INESPECIA es ON pr.CODESPEC1 = es.CODESPECI
              INNER JOIN dbo.INENTIDAD E ON E.CODENTIDA = I.CODENTIDA
              LEFT JOIN dbo.CHREGESTA CH ON CH.NUMINGRES = I.NUMINGRES
                                                      AND CH.REGESTADO = '1'
              LEFT JOIN dbo.CHCAMASHO C ON C.CODICAMAS = CH.CODICAMAS
              LEFT JOIN dbo.INUNIFUNC AS U ON U.UFUCODIGO = A.UFUCODIGO
              LEFT JOIN dbo.ADCONFSER S ON S.CODSERIPS = A.CODSERIPS
              LEFT JOIN dbo.ADAUTOSER ss ON SS.IPCODPACI = a.IPCODPACI
                                                                   AND SS.NUMINGRES = A.NUMINGRES
                                                                   AND SS.CODSERIPS = A.CODSERIPS
                                                                   AND SS.NUMEFOLIO = A.NUMEFOLIO
         UNION ALL
         ----PROCEDIMIENTOS Q--
         SELECT DISTINCT 
                A.FECORDMED AS [FECHA ORDEN], 
                p.IPCODPACI AS [identificacion], 
                P.IPNOMCOMP AS [NOMBRES], 
                U.UFUDESCRI AS [UNIDAD], 
                I.NUMINGRES AS [INGRESO], 
                C.DESCCAMAS AS [CAMA], 
                E.NOMENTIDA AS [ENTIDAD], 
                I.IOBSERVAC AS [OBSERVACION], 
                A.CODPROSAL, 
                es.DESESPECI AS [DESCRIPCION_ESP], 
                SG.DESSUBIPS AS [TipoExamen], 
                A.NUMEFOLIO AS [FOLIO], 
                RTRIM(B.CODSERIPS) AS [CODIGORIPS], 
                RTRIM(DESSERIPS) AS [DES_RIPS], 
                A.CANSERIPS AS [CANTIDAD], 
                A.OBSSERIPS [OBSERVACION_RIPS], 
                a.ESTSERIPS
         FROM dbo.HCORDPROQ A
              INNER JOIN dbo.INCUPSIPS B ON A.CODSERIPS = B.CODSERIPS
              INNER JOIN dbo.INCUPSSUB SG ON SG.CODGRUSUB = B.CODGRUSUB
              INNER JOIN dbo.ADINGRESO I ON I.NUMINGRES = A.NUMINGRES
              INNER JOIN dbo.INPACIENT P ON P.IPCODPACI = i.IPCODPACI
              INNER JOIN dbo.INPROFSAL pr ON A.CODPROSAL = pr.CODPROSAL
              INNER JOIN dbo.INESPECIA es ON pr.CODESPEC1 = es.CODESPECI
              INNER JOIN dbo.INENTIDAD E ON E.CODENTIDA = I.CODENTIDA
              LEFT JOIN dbo.CHREGESTA CH ON CH.NUMINGRES = I.NUMINGRES
                                                      AND CH.REGESTADO = '1'
              LEFT JOIN dbo.CHCAMASHO C ON C.CODICAMAS = CH.CODICAMAS
              LEFT JOIN dbo.INUNIFUNC AS U ON U.UFUCODIGO = A.UFUCODIGO
              LEFT JOIN dbo.ADCONFSER S ON S.CODSERIPS = A.CODSERIPS
              LEFT JOIN dbo.ADAUTOSER ss ON SS.IPCODPACI = a.IPCODPACI
                                                                   AND SS.NUMINGRES = A.NUMINGRES
                                                                   AND SS.CODSERIPS = A.CODSERIPS
                                                                   AND SS.NUMEFOLIO = A.NUMEFOLIO
	) as TOTAL_ORDENAMIENTO
WHERE
 [FECHA ORDEN] BETWEEN @FECINI AND 	@FECFIN 