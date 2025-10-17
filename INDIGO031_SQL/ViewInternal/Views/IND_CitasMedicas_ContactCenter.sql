-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_CitasMedicas_ContactCenter
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_CitasMedicas_ContactCenter] as
select RTRIM(PrimerNombre) + ' '+ RTRIM(PrimerApellido) as NOMBRE, '' as APELLIDO,'' as TIPO_, ROW_NUMBER() OVER(ORDER BY IDENTIFICACION DESC) as ID
, '' as    EDAD, '' as   [SEXO PACIENTE], '' as    PAIS,'' as DEPARTAMENTO,'' as CIUDAD, '' as ZONA, '' as DIRECCION_,
 CentroAtencion as OPT1,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((rtrim(FORMAT ([FECHA DE CITA], 'dddd, dd, MMMM ','es-es')) +'.'), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u'),',','.')  as OPT2,
case when rtrim(ESPECIALIDAD)  is null then rtrim(SUBSTRING(Actividad, 1, 10)) else rtrim(ESPECIALIDAD) end as OPT3,
rtrim(right(convert(varchar(32),[FECHA DE CITA] ,100),8)) as OPT4, 'https://forms.office.com/r/LPJ0SyLy6v' as OPT5, '' as OPT6, '' as OPT7, '' as OPT8, '' as OPT9, '' as OPT10, '' as OPT11, '' as OPT12,
RTRIM('9'+celular) AS TEL1,[FECHA DE CITA] AS FECHACITA,*
from ViewInternal.IND_CitasMedicas
where [FECHA DE CITA] >= '07-01-2022' 
and Estado='Asignada' and LEN(celular) = '10'
