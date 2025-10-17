-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewUltimoDXIngreso
-- Extracted by Fabric SQL Extractor SPN v3.9.0


/*******************************************************************************************************************
Nombre: [Report].[ViewUltimoDXIngreso]
Tipo:Vista
Observacion:Trae el ultimo Diagnostico realizado en hchispaca por ingreso, solicitado por el ing Andres cabrera unicamente para
			San Jose
Profesional:Nilsson Miguel Galindo
Fecha:12-09-2023
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:
Fecha: 
Ovservaciones:
**********************************************************************************************************************************************/
CREATE VIEW [Report].[ViewUltimoDXIngreso]
AS

SELECT TOP 100 PERCENT
ID.SIGLA AS [TIPO IDENTIFICACION],
HC.IPCODPACI AS IDENTIFICACION ,
PAC.IPNOMCOMP AS PACIENTE,
HC.NUMINGRES AS INGRESO,
HC.NUMEFOLIO AS FOLIO,
HC.CODDIAGNO AS [CODIGO DE DIAGNOSTICO],
DG.NOMDIAGNO AS [DIAGNOSTICO],
PRO.CODPROSAL AS [CODIGO PROFESIONAL],
PRO.NOMMEDICO AS [PROFESIONAL],
ES.DESESPECI AS [ESPECIALIDAD],
--ROW_NUMBER ( ) OVER (PARTITION BY HC.IPCODPACI  order by HC.NUMINGRES DESC) AS [NUMERO DE INGRESOS],
'' AS [NUMERO DE INGRESOS],
HC.FECHISPAC AS [FECHA ATENCIÓN],
CODSERIPS AS [CUPS]
FROM 
dbo.HCHISPACA HC INNER JOIN
DBO.INDIAGNOS DG ON HC.CODDIAGNO=DG.CODDIAGNO AND HC.NUMEFOLIO=(SELECT MAX(H.NUMEFOLIO) FROM dbo.HCHISPACA H WHERE HC.NUMINGRES=H.NUMINGRES)INNER JOIN
dbo.INPACIENT PAC ON HC.IPCODPACI=PAC.IPCODPACI INNER JOIN
dbo.ADTIPOIDENTIFICA ID ON PAC.IPTIPODOC=ID.CODIGO INNER JOIN
dbo.INPROFSAL PRO ON HC.CODPROSAL=PRO.CODPROSAL INNER JOIN
dbo.INESPECIA ES ON PRO.CODESPEC1=ES.CODESPECI INNER JOIN
dbo.AGASICITA CIT ON HC.NUMINGRES=CIT.NUMINGRES
ORDER BY HC.IPCODPACI
