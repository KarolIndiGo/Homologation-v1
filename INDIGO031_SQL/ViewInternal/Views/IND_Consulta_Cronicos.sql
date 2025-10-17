-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_Consulta_Cronicos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_Consulta_Cronicos]
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
     FROM dbo.HCEXFISIC AS ic
          INNER JOIN dbo.INPACIENT AS PA ON IC.IPCODPACI = PA.IPCODPACI;
