-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_CONSULTA_CRONICOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_CONSULTA_CRONICOS
AS
SELECT CASE PA.IPTIPODOC
        WHEN 1
        THEN 'Cedula'
        WHEN 2
        THEN 'CedExtranjera'
        WHEN 3
        THEN 'TarjetaIdentidad'
        WHEN 4
        THEN 'RegistroCivil'
    END AS TipoDocumento, 
    IC.IPCODPACI AS DOCUMENTO, 
    RTRIM(LTRIM(PA.IPPRINOMB)) + ' ' + RTRIM(LTRIM(PA.IPSEGNOMB)) + ' ' + RTRIM(LTRIM(PA.IPPRIAPEL)) + ' ' + PA.IPSEGAPEL AS Paciente, 
    FECREGITE AS FechaIngreso, 
    PESOPACIE AS PesoPaciente, 
    TALLAPACI AS TallaPaciente, 
    TENARTDIA AS Diastole, 
    TENARTSIS AS Sistole
FROM [INDIGO031].[dbo].[HCEXFISIC] AS IC
INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS PA ON IC.IPCODPACI = PA.IPCODPACI;
