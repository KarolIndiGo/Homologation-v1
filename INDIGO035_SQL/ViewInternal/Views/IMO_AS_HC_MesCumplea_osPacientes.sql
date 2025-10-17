-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_AS_HC_MesCumpleañosPacientes
-- Extracted by Fabric SQL Extractor SPN v3.9.0



create VIEW [ViewInternal].[IMO_AS_HC_MesCumpleañosPacientes]
AS
SELECT i.IFECHAING as FechaIngreso, i.NUMINGRES as Ingreso, i.IPCODPACI AS Identificacion, IPNOMCOMP AS Paciente, 
IPFECNACI AS FechaNacimiento, MONTH(IPFECNACI) AS MesCumpleaños, U.UFUDESCRI AS UnidadFuncional
FROM   dbo.ADINGRESO as i  
inner join dbo.INPACIENT AS P on p.IPCODPACI=i.IPCODPACI
inner join dbo.INUNIFUNC AS U ON U.UFUCODIGO=I.UFUCODIGO
where i.IPCODPACI <> '0123456789'
