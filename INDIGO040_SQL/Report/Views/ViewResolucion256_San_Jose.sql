-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewResolucion256_San_Jose
-- Extracted by Fabric SQL Extractor SPN v3.9.0



/*******************************************************************************************************************
Nombre: [Report].[ViewResolucion256_Tipo4_San_Jose]
Tipo:Vista
Observacion:Resolución 256 tipo 4, este informe es proicional, mientras entra el modulo de agendamiento a funcionar.
Profesional:Nilsson Miguel Galindo Lopez
Fecha:25-01-2023
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 1
Persona que modifico:
Fecha:
Observaciones:
--------------------------------------------------------------------------------------
Version 2
Persona que modifico:
Fecha:
Ovservaciones:		  
_______________________________________________________________________________________________________________________

**********************************************************************************************************************/
CREATE VIEW [Report].[ViewResolucion256_San_Jose] AS 


SELECT 
0 AS [0],
ROW_NUMBER ( )   
OVER (order by INF.FECHORINI DESC) AS [1],
DOC.SIGLA AS [2],
INF.IPCODPACI AS [3],
CONVERT(DATE,PAC.IPFECNACI,(201)) AS [4],
CASE PAC.IPSEXOPAC WHEN 1 THEN 'H'
				   WHEN 2 THEN 'M' ELSE 'I' END AS [5],
PAC.IPPRIAPEL AS [6],
PAC.IPSEGAPEL AS [7],
PAC.IPPRINOMB AS [8],
PAC.IPSEGNOMB AS [9],
ENT.HealthEntityCode AS [10],
UBI.DEPMUNCOD AS [11],
PRO.CODSERIPS AS [12],
CONVERT(DATE,RAD.FECHARADIC,201) AS [13],
CONVERT(DATE,INF.FECHORINI,201) AS [14],
1 AS [15],
'' AS [16],
'' AS [17]
FROM dbo.HCQXINFOR INF
INNER JOIN DBO.HCQXREALI PRO ON INF.NUMINGRES=PRO.NUMINGRES AND INF.NUMEFOLIO=PRO.NUMEFOLIO
INNER JOIN dbo.INPACIENT PAC ON INF.IPCODPACI=PAC.IPCODPACI
INNER JOIN dbo.ADTIPOIDENTIFICA DOC ON PAC.IPTIPODOC=DOC.CODIGO
INNER JOIN Contract.HealthAdministrator ENT ON PAC.CODENTIDA=ENT.Code
LEFT JOIN dbo.INUBICACI UBI ON PAC.AUUBICACI=UBI.AUUBICACI
LEFT JOIN dbo.AGEPROGQX PR ON INF.IPCODPACI=PR.IPCODPACI AND INF.CODSERIPS=PR.CODSERIPS AND CAST(INF.FECHORINI AS DATE)=CAST(PR.FECHORAIN AS DATE)
LEFT JOIN dbo.ADRADICACIONQX RAD ON PR.IDRADICACIONQX=RAD.ID AND RAD.ESTADO!=3
WHERE PRO.CODSERIPS BETWEEN '010101' AND '869700'
