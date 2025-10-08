-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_CITASMEDICAS_CONTACTCENTER
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_CITASMEDICAS_CONTACTCENTER
AS
select 
    RTRIM(PrimerNombre) + ' '+ RTRIM(PrimerApellido) as NOMBRE
    , '' as APELLIDO
    , '' as TIPO_
    , ROW_NUMBER() OVER(ORDER BY Identificacion DESC) as Id
    , '' as EDAD
    , '' as [SEXO PACIENTE]
    , '' as PAIS
    , '' as DEPARTAMENTO
    , '' as CIUDAD
    , '' as ZONA
    , '' as DIRECCION_
    , CentroAtencion as OPT1
    ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((rtrim(FORMAT ([Fecha de Cita], 'dddd, dd, MMMM ','es-es')) +'.'), 'á', 'a'), 'é','e'), 'í', 'i'), 'ó', 'o'), 'ú','u'),',','.')  as OPT2
    ,case 
        when rtrim(Especialidad)  is null then rtrim(SUBSTRING(Actividad, 1, 10)) 
        else rtrim(Especialidad) end as OPT3
    ,rtrim(right(convert(varchar(32),[Fecha de Cita] ,100),8)) as OPT4
    , 'https://forms.office.com/r/LPJ0SyLy6v' as OPT5
    , '' as OPT6
    , '' as OPT7
    , '' as OPT8
    , '' as OPT9
    , '' as OPT10
    , '' as OPT11
    , '' as OPT12
    , RTRIM('9'+Celular) AS TEL1
    ,[Fecha de Cita] AS FECHACITA
    , *
from [DataWareHouse_Clinical].[ViewInternal].[VW_IND_CITASMEDICAS]
where [Fecha de Cita] >= '07-01-2022' and Estado='Asignada' and LEN(Celular) = '10'
