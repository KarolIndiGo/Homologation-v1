-- Workspace: HOMI
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9e4ad354-8031-4a13-8643-33b3234761ff
-- Schema: Report
-- Object: SP_URGENCIASESCALAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE PROCEDURE Report.SP_URGENCIASESCALAS
@FECHAINICIA AS DATE,
@FECHAFINAL AS DATE,
@IDNOTAADMINISTRATIVA AS INT
AS
--DECLARE @FECFIN as date = '" & Parametros{1}[Valor] & "';

--DECLARE @FECINI AS DATE = '2025-08-01';
--DECLARE @FECFIN AS DATE = '2025-08-31';

SELECT
    A.IPCODPACI IDENTIFICACION,
    A.NUMINGRES INGRESO,
    DATEDIFF(YEAR, p.IPFECNACI, A.FECHAREGISTRO) EDAD,
    F.Name EPS,
    A.FECHAREGISTRO,
    CASE
        A.TIPOESCALA
        WHEN 0 THEN 'NoAplica '
        WHEN 1 THEN 'EscalaCAGE'
        WHEN 2 THEN 'EscalaAPGAR_Familiar'
        WHEN 3 THEN 'EscalaEDPS'
        WHEN 4 THEN 'EscalaBiopsicosocial'
        WHEN 5 THEN 'EscalaTamizajeViolenciaDomestica'
        WHEN 6 THEN 'EscalaRiesgoFramingham	'
        WHEN 7 THEN 'EscalaMorisky'
        WHEN 8 THEN 'TestFINDRISC'
        WHEN 9 THEN 'TestMiniMental'
        WHEN 10 THEN 'TestDependenciaNicotina'
        WHEN 11 THEN 'EscalaTannerDesarrolloMamarioMujer'
        WHEN 12 THEN 'EscalaTannerDesarrolloVelloPubianoMujer'
        WHEN 13 THEN 'EscalaTannerDesarrolloGenitalHombre'
        WHEN 14 THEN 'EscalaTannerDesarrolloVelloPubianoHombre'
        WHEN 15 THEN 'EscalaWagner'
        WHEN 16 THEN 'EscalaModificadaDisnea'
        WHEN 17 THEN 'EscalaCAT_COPD_AssessmentTest'
        WHEN 18 THEN 'Exacerbaciones'
        WHEN 19 THEN 'ClasificacionEPOC'
        WHEN 20 THEN 'Guarda Detalle - TestGoodenough'
        WHEN 21 THEN 'GOLD_EPOC'
        WHEN 22 THEN 'EscalaAbreviadaDesarrollo'
        WHEN 23 THEN 'Guarda Detalle - EscalaTISS_28'
        WHEN 24 THEN 'Escala_Branden'
        WHEN 25 THEN 'Escala_ApacheII'
        WHEN 26 THEN 'Escala_Karnosfky'
        WHEN 27 THEN 'Escala_Ecog'
        WHEN 28 THEN 'Escala_Nems'
        WHEN 29 THEN 'Escala_Glasgow_Mayor5Anos'
        WHEN 30 THEN 'Se guarda en otra tabla - Escala_Glasgow_de1a5Anos'
        WHEN 31 THEN 'Se guarda en otra tabla - Escala_Glasgow_Menor1Ano'
        WHEN 32 THEN 'Se guarda en otra tabla - Escala_SOFA'
        WHEN 33 THEN 'Escala_Charlson'
        WHEN 34 THEN 'Escala_SAPS3'
        WHEN 35 THEN 'Escala_Barthel'
        WHEN 36 THEN 'Escala_Morse'
        WHEN 37 THEN 'Escala_Macdems'
        WHEN 38 THEN 'Escala_NSRAS'
        WHEN 39 THEN 'Escala_MSTS'
        WHEN 40 THEN 'Escala_Person'
        WHEN 41 THEN 'Escala_beck'
        WHEN 42 THEN 'Escala_Zarit'
        WHEN 43 THEN 'Escala_RQC'
        WHEN 44 THEN 'Escala_BacterianaSilness'
        WHEN 45 THEN 'Escala_VALE'
        WHEN 46 THEN 'Se guarda en otra tabla - EscalaRASS'
        WHEN 47 THEN 'EscalaDown'
        WHEN 48 THEN 'EscalaNorton'
        WHEN 49 THEN 'EscalaVass'
        WHEN 50 THEN 'EscalaNutricion'
        WHEN 51 THEN 'EscalaSQR'
        WHEN 52 THEN 'Guarda detalle - EscalaM_CHAT'
        WHEN 53 THEN 'EscalaWHOOLEY'
        WHEN 54 THEN 'EscalaAUDIT'
        WHEN 55 THEN 'EscalaLindaFried'
        WHEN 56 THEN 'EscalaLawton_Brody'
        WHEN 57 THEN 'EscalaGAD'
        WHEN 58 THEN 'EscalaMNA'
        WHEN 59 THEN 'EscalaMNASimplificada'
        WHEN 60 THEN 'EscalaAssist'
        WHEN 61 THEN 'EscalaNews'
        WHEN 62 THEN 'EscalaCHA2DS2_VASc'
        WHEN 63 THEN 'EscalaCRUSADE'
        WHEN 64 THEN 'EscalaHAS-BLED'
        WHEN 65 THEN 'EscalaHEMORR2HAGES'
        WHEN 66 THEN 'EscalaEUROSCOREII'
        WHEN 67 THEN 'EscalaNYHA'
        WHEN 68 THEN 'EscalaKILLIP'
        WHEN 69 THEN 'EscalaPADUA'
        WHEN 70 THEN 'EscalaCAPRINI'
        WHEN 71 THEN 'EscalaMUST'
        WHEN 72 THEN 'Escala_STRONG_KIDS'
        WHEN 73 THEN 'Escala_VGSDEN (Valoracion Global Subjetiva del Estado Nutricional)'
        WHEN 74 THEN 'Escala_TIMI_CEST'
        WHEN 75 THEN 'Escala_WELLS_TVP'
        WHEN 76 THEN 'Escala_WELLS_TEP'
        WHEN 77 THEN 'Escala_NPC'
        WHEN 78 THEN 'Escala_GRACE'
        WHEN 79 THEN 'Escala_TIMI_SEST'
        WHEN 80 THEN 'Escala_ANTHONISEN'
        WHEN 81 THEN 'Escala_DAS28'
        WHEN 82 THEN 'EscalaMRS'
        WHEN 83 THEN 'EscalaHAQ'
        WHEN 84 THEN 'EscalaASPECT'
        WHEN 85 THEN 'EscalaAbreviadaDesarrolloV3'
        WHEN 86 THEN 'EscalaIndiceOLeary'
        WHEN 87 THEN 'EscalaNIHSS'
        WHEN 88 THEN 'EscalaHumptyDumpty'
        WHEN 89 THEN 'EscalaRiesgoEnfermedadesPotencialTransmisibles'
        WHEN 90 THEN 'Escala_PIPP_R'
        WHEN 91 THEN 'Escala_FLACC'
    END TIPO_ESCALA,
    A.RESULTADODECIMAL,
    G.TEXTOPREGUNTA PREGUNTA,
    G.TEXTOITEMSELECCIONADO RESPUESTA,
    G.VALORITEMSELECCIONADO VALOR_ITEM,
    B.NOMMEDICO PROFESIONAL,
    C.DESESPECI ESPECIALIDAD,
    D.UFUDESCRI
FROM
    INDIGO036.dbo.HCESCALAS A
    LEFT JOIN INDIGO036.dbo.INPROFSAL B ON A.CODPROSAL = B.CODPROSAL
    LEFT JOIN INDIGO036.dbo.INESPECIA C ON B.CODESPEC1 = C.CODESPECI
    LEFT JOIN INDIGO036.dbo.INUNIFUNC D ON A.UFUCODIGO = D.UFUCODIGO
    LEFT JOIN INDIGO036.dbo.ADINGRESO E ON A.NUMINGRES = E.NUMINGRES
    LEFT JOIN INDIGO036.Contract.CareGroup F ON E.CODENTIDA = F.Code
    LEFT JOIN INDIGO036.dbo.HCESCALASRESULTITEMS G ON A.ID = G.IDHCESCALAS
    LEFT JOIN INDIGO036.dbo.INPACIENT p ON A.IPCODPACI = p.IPCODPACI
WHERE
    A.FECHAREGISTRO BETWEEN @FECHAINICIA
    AND @FECHAFINAL
    AND A.TIPOESCALA = @IDNOTAADMINISTRATIVA