-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_ReglasCUPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_ReglasCUPS]
AS
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
     FROM dbo.RIASCUPS AS RC
          INNER JOIN dbo.INCUPSIPS AS I ON RC.CODSERIPS = I.CODSERIPS
          INNER JOIN dbo.RIASCUPSD AS R ON R.IDRIASCUPS = RC.ID
          INNER JOIN dbo.RIAS AS RI ON RI.ID = RC.IDRIAS;
