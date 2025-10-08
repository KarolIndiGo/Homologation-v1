-- Workspace: IMO
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 45d58e75-d0a4-4f2b-bd10-65e2dfeda219
-- Schema: ViewInternal
-- Object: VW_IMO_AS_HC_MESCUMPLEAÑOSPACIENTES
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE  VIEW ViewInternal.IMO_AS_HC_MesCumpleañosPacientes
AS 

SELECT i.IFECHAING as FechaIngreso, i.NUMINGRES as Ingreso, i.IPCODPACI AS Identificacion, P.IPNOMCOMP AS Paciente, 
IPFECNACI AS FechaNacimiento, MONTH(IPFECNACI) AS MesCumpleaños, U.UFUDESCRI AS UnidadFuncional
FROM   [INDIGO035].[dbo].[ADINGRESO] as i  
inner join [INDIGO035].[dbo].[INPACIENT] AS P on P.IPCODPACI=i.IPCODPACI
inner join [INDIGO035].[dbo].[INUNIFUNC] AS U ON U.UFUCODIGO=i.UFUCODIGO
where i.IPCODPACI <> '0123456789'