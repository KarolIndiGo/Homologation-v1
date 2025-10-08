-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_REGLASCUPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VW_IND_REGLASCUPS] AS
     SELECT RC.CODSERIPS AS CUPS, 
            I.DESSERIPS AS Servicio, 
            RI.NOMBRE AS RIAS, 
            R.EDADMINIMA, 
            R.EDADMAXIMA,
            CASE R.UNIDADRANGO
                WHEN 1
                THEN 'Dias'
                WHEN 2
                THEN 'Meses'
                WHEN 3
                THEN 'Años'
            END AS Unidad,
            CASE R.REGLA
                WHEN 1
                THEN 'Sin Regla'
                WHEN 2
                THEN 'FRECUENCIA POR RANGO DE EDAD'
                WHEN 3
                THEN 'FRECUENCIA POR ULTIMA FECHA DE ACTUALIZACION'
                WHEN 4
                THEN 'FRECUENCIA POR PERIODO VIGENTE'
            END AS Regla, 
            R.FRECUENCIA AS 'Frecuencia', 
            R.CANTIDADPERIODO AS '1 Cada',
            CASE R.UNIDADFRECUENCIA
                WHEN 0
                THEN 'NO Aplica'
                WHEN 1
                THEN 'Año'
                WHEN 2
                THEN 'Semestre'
                WHEN 3
                THEN 'Trimestre'
                WHEN 4
                THEN 'Mes'
                WHEN 5
                THEN 'En el Año Vigente'
                WHEN 6
                THEN 'En el Semestre Vigente'
                WHEN 7
                THEN 'En el Trimestre Vigente'
                WHEN 8
                THEN 'En el Mes Vigente'
            END AS 'Frecuencia/Opciones',
            CASE R.REQUIEREORDENMED
                WHEN 0
                THEN 'SI'
                WHEN 1
                THEN 'NO'
            END AS OrdenMedica,
            CASE R.SEXO
                WHEN 0
                THEN 'Masculino'
                WHEN 1
                THEN 'Femenino'
                WHEN 2
                THEN 'Ambos'
            END AS SEXO,
            CASE R.ESTADO
                WHEN 1
                THEN 'Activo'
                WHEN 0
                THEN 'Inactivo'
            END AS Estado
     FROM INDIGO031.dbo.RIASCUPS AS RC
          INNER JOIN INDIGO031.dbo.INCUPSIPS AS I ON RC.CODSERIPS = I.CODSERIPS
          INNER JOIN INDIGO031.dbo.RIASCUPSD AS R ON R.IDRIASCUPS = RC.ID
          INNER JOIN INDIGO031.dbo.RIAS AS RI ON RI.ID = RC.IDRIAS;
