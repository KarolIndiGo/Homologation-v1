-- Workspace: HOMI
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9e4ad354-8031-4a13-8643-33b3234761ff
-- Schema: Report
-- Object: VW_VIEWURGENCIASESTANCIAPRODUCTIVIDAD
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW Report.VW_VIEWURGENCIASESTANCIAPRODUCTIVIDAD AS 

SELECT 
    a.IPCODPACI,
    a.NUMINGRES,
    F.UFUDESCRI,
    FECHISPAC,
    CASE a.INDICAPAC 
        WHEN 1  THEN 'Trasladar a Urgencias: Solo consulta externa'
        WHEN 2  THEN 'Trasladar a Observacion Urgencias: solo Urgencias'
        WHEN 3  THEN 'Trasladar a Hospitalizacion: Dif Misma Unidad'
        WHEN 4  THEN 'Trasladar a UCI Adulto: Dif Misma Unidad'
        WHEN 5  THEN 'Trasladar a UCI Pediatrica: Dif Misma Unidad'
        WHEN 6  THEN 'Trasladar a UCI Neonatal: Dif Misma Unidad'
        WHEN 7  THEN 'Trasladar a Consulta Externa: Dif Misma Unidad'
        WHEN 8  THEN 'Trasladar a Cirugia: Dif Misma Unidad'
        WHEN 9  THEN 'Hospitalizacion en Casa'
        WHEN 10 THEN 'Referencia 11. Morgue'
        WHEN 12 THEN 'Salida'
        WHEN 13 THEN 'Continua en la Unidad'
        WHEN 14 THEN 'Paciente en Tratamiento'
        WHEN 15 THEN 'Retiro Voluntario'
        WHEN 16 THEN 'Fuga'
        WHEN 17 THEN 'Salida Parcial'
        WHEN 18 THEN 'Estancia Con la Madre'
        WHEN 19 THEN 'U.Cuidado Intermedio'
        WHEN 20 THEN 'U.Basica'
    END AS INDICACION,
    d.DESTIPEST,
    c.NOMMEDICO,
    e.DESESPECI,
    CONVERT(DATE, FECHISPAC, 34) AS FECHA_BUSQUEDA
FROM 
    INDIGO036.dbo.HCHISPACA a
LEFT JOIN 
    INDIGO036.dbo.CHREGESTA b 
    ON a.NUMINGRES = b.NUMINGRES 
    AND a.FECHISPAC BETWEEN b.FECINIEST AND b.FECFINEST
LEFT JOIN 
    INDIGO036.dbo.CHTIPESTA d 
    ON b.CODTIPEST = d.CODTIPEST
LEFT JOIN 
    INDIGO036.dbo.INPROFSAL c 
    ON a.CODPROSAL = c.CODPROSAL
LEFT JOIN 
    INDIGO036.dbo.INESPECIA e 
    ON e.CODESPECI = a.CODESPTRA
LEFT JOIN 
    INDIGO036.dbo.INUNIFUNC F 
    ON F.UFUCODIGO = a.UFUCODIGO
--WHERE CONVERT(DATE, FECHISPAC, 34) BETWEEN CONVERT(VARCHAR, '2025-06-01', 34) AND CONVERT(VARCHAR, '2025-06-02', 34)