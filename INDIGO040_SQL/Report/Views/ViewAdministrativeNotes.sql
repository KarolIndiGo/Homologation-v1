-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewAdministrativeNotes
-- Extracted by Fabric SQL Extractor SPN v3.9.0

    /*******************************************************************************************************************
Nombre: [Report].[ViewAdministrativeNotes]
Tipo:Vista
Observacion:Notas Administrativas
Profesional: Nilsson Miguel Galindo Lopez
Fecha:05-10-2023
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:
Fecha:
Ovservaciones:
--------------------------------------
Version 3
Persona que modifico:
Observacion:
Fecha:
--------------------------------------------------------------------------------------------
--***********************************************************************************************************************************/
CREATE VIEW [Report].ViewAdministrativeNotes AS

SELECT 
NAD.ID AS [ID NOTAS],
NAD.NOMBRE AS [NOMBRE NOTA],
NTAC.ID AS [ID NTAC],
NTAC.FECHACREACION AS [FECHA REGISTRO],
NTAC.IPCODPACI AS [IDENTIFICACION],
PAC.IPNOMCOMP AS [PACIENTE],
NTAC.NUMINGRES AS [INGRESO],CASE NTAC.NOTANOFACTURABLE WHEN 1 THEN 'SI' ELSE 'NO' END AS [NOTA FACTURABLE],
GRU.NOMBRE AS [GRUPO],
ESL.ID AS [ID VARIABLE],
ESL.VARIABLE,
NTAD.VALOR,
VAL.DESCRIPCION
FROM 
dbo.NTADMINISTRATIVAS NAD INNER JOIN
dbo.NTNOTASADMINISTRATIVASC NTAC ON NAD.ID=NTAC.IDNOTAADMINISTRATIVA INNER JOIN
dbo.NTNOTASADMINISTRATIVASD NTAD ON NTAC.ID=NTAD.IDNTNOTASADMINISTRATIVASC INNER JOIN
dbo.INPACIENT PAC ON NTAC.IPCODPACI=PAC.IPCODPACI INNER JOIN
dbo.NTVARIABLES ESL ON NTAD.IDNTVARIABLE=ESL.ID INNER JOIN
dbo.NTGRUPOS GRU ON NTAD.IDGRUPO=GRU.ID LEFT JOIN
dbo.NTVARIABLESL VAL ON ESL.ID=VAL.IDNTVARIABLE AND NTAD.VALOR=VAL.CODIGO
--WHERE NAD.ID='2' AND NTAC.NUMINGRES='66031'
