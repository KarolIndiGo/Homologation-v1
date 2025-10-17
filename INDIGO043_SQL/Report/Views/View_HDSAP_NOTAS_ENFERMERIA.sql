-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_NOTAS_ENFERMERIA
-- Extracted by Fabric SQL Extractor SPN v3.9.0






CREATE VIEW [Report].[View_HDSAP_NOTAS_ENFERMERIA]
AS


SELECT
    hch.IPCODPACI AS 'Documento',
    hch.NUMINGRES AS 'Ingreso',
    hch.CODPROSAL AS 'CodigoMedico',
    hch.INDICAMED AS 'Indicaciones',
    hch.DATOBJETI AS 'Objetivo', 
    UNI.UFUDESCRI AS 'UnidadFuncional',
    hch.FECHISPAC as 'FechaIngresoMedico',
    [dbo].[Fecha_Primer_Evolucion](IPCODPACI, NUMINGRES) as 'FechaNotaEnfermeria',
    DATEDIFF(MINUTE,hch.FECHISPAC, [dbo].[Fecha_Primer_Evolucion](IPCODPACI, NUMINGRES) ) AS 'Tiempo Primera Evolucion Medica vs Primera Nota Enfermeria En Minutos'
FROM 
    dbo.HCHISPACA as hch 
INNER JOIN
    dbo.INUNIFUNC AS UNI ON hch.UFUCODIGO = UNI.UFUCODIGO
WHERE 
    (hch.CONSFOLIO IS NULL) AND 
    hch.UFUCODIGO IN ('01', '0352');



