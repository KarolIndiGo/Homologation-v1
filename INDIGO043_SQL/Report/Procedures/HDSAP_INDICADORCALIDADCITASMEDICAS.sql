-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: HDSAP_INDICADORCALIDADCITASMEDICAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0







CREATE PROCEDURE [Report].[HDSAP_INDICADORCALIDADCITASMEDICAS]  
	
	@FechaInicial AS datetime
AS

DECLARE	@FechaFinal AS datetime=DATEADD(DAY,1,EOMONTH(@FechaInicial,0));
	WITH AgD
	AS
	(

	SELECT AGA.CODESPECI AS CodEsp, MAX(ES.DESESPECI) AS Especialidad, COUNT(*) AS NumSolicAgendDirect
	FROM AGASICITA AS AGA LEFT OUTER JOIN 
		AGCITAESP AS CE ON CE.IDCITA=AGA.CODAUTONU LEFT OUTER JOIN
		INESPECIA AS ES ON AGA.CODESPECI = ES.CODESPECI
	WHERE AGA.FECHORAIN>=@FechaInicial AND  AGA.FECHORAIN<@FechaFinal AND CE.IDCITA IS NULL
		AND AGA.CODESTCIT<>4 AND AGA.CODESPECI IS NOT NULL
	GROUP BY AGA.CODESPECI
	),
	RegDemIns
	AS
	(
	--PACIENTES REGISTRADOS EN CITA EN ESPERA PARA EL MES EN ANÁLISIS
	SELECT ES.CODESPECI AS CodEsp, MAX(ES.DESESPECI) AS Especialidad, COUNT(*) AS NumSolicRegDemInsat
	FROM AGCITAESP AS CE LEFT OUTER JOIN
		INESPECIA AS ES ON CE.CODESPECI = ES.CODESPECI
	WHERE CE.FECREGSIS>=@FechaInicial AND  CE.FECREGSIS<@FechaFinal
	GROUP BY ES.CODESPECI
	),
	Denominador
	AS
	(
	SELECT COALESCE(AgD.CodEsp, RegDemIns.CodEsp) AS CodEsp,
		COALESCE(AgD.Especialidad, RegDemIns.Especialidad) AS Especialidad,
		AgD.NumSolicAgendDirect, ISNULL(RegDemIns.NumSolicRegDemInsat, 0) AS NumSolicRegDemInsat,
		ISNULL(AgD.NumSolicAgendDirect,0) + ISNULL(RegDemIns.NumSolicRegDemInsat, 0) AS TotSolDeAsig
	FROM AgD FULL OUTER JOIN
		RegDemIns ON AgD.CodEsp=RegDemIns.CodEsp
	--ORDER BY COALESCE(AgD.Especialidad, RegDemIns.Especialidad);
	),
	Numerador
	AS
	(
	SELECT ES.CODESPECI AS CodEsp, MAX(ES.DESESPECI) AS Especialidad, COUNT(*) AS NumPcteNoAsigCit
	FROM AGCITAESP AS CE LEFT OUTER JOIN
		AGASICITA AS AGA ON CE.IDCITA=AGA.CODAUTONU LEFT OUTER JOIN
		INESPECIA AS ES ON CE.CODESPECI=ES.CODESPECI
	WHERE CE.FECREGSIS>=@FechaInicial AND  CE.FECREGSIS<@FechaFinal
		AND (AGA.FECHORAIN >=@FechaFinal OR CE.IDCITA IS NULL)	--Genera confusión
	GROUP BY ES.CODESPECI
	),
	AnestesNoAsig
	AS
	(
	SELECT '021' AS CodEsp, ISNULL(COUNT(*),0) AS NumAnesNoAsig
	FROM ADRADICACIONQX AS CEE 
	join ADRADICACIONQXD AS QXD ON QXD.IDRADICACIONQX = CEE.ID
	WHERE CEE.FECHARADIC >=@FechaInicial AND  CEE.FECHARADIC<@FechaFinal
		--AND QXD.IDLISTACHEQUEOD = 5
	),
	AnestesTotSolDeAsig
	AS
	(
	SELECT '021' AS CodEsp, ISNULL(COUNT(*),0) AS TotSolDeAsig
	FROM ADRADICACIONQX AS CEE 
	WHERE CEE.FECHARADIC >=@FechaInicial AND  CEE.FECHARADIC<@FechaFinal
	)
	SELECT Denominador.CodEsp, Denominador.Especialidad, 
		CASE WHEN Denominador.CodEsp='021' THEN 0 ELSE Denominador.NumSolicAgendDirect END AS NumSolicAgendDirect,
		CASE WHEN Denominador.CodEsp='021' THEN AnestesTotSolDeAsig.TotSolDeAsig ELSE Denominador.NumSolicRegDemInsat END AS NumSolicRegDemInsat, 
		CASE WHEN Denominador.CodEsp='021' THEN AnestesTotSolDeAsig.TotSolDeAsig ELSE Denominador.TotSolDeAsig END AS [TotSolDeAsig(Den.)], 
		CASE WHEN Denominador.CodEsp='021' THEN AnestesNoAsig.NumAnesNoAsig ELSE ISNULL(Numerador.NumPcteNoAsigCit, 0) END AS [NumPcteNoAsigCit(Num.)],
		CASE WHEN Denominador.CodEsp='021' AND AnestesTotSolDeAsig.TotSolDeAsig=0 THEN 0
			WHEN Denominador.CodEsp='021' THEN 
			CAST(CAST(AnestesNoAsig.NumAnesNoAsig AS numeric(8,2))/CAST(AnestesTotSolDeAsig.TotSolDeAsig AS numeric(8,2)) AS numeric(8,2)) ELSE
			CAST(CAST(ISNULL(Numerador.NumPcteNoAsigCit,0) AS numeric(8,2))/CAST(Denominador.TotSolDeAsig AS numeric(8,2)) AS numeric(8,3)) END AS Indicador
	FROM Denominador LEFT OUTER JOIN 
		Numerador ON Denominador.CodEsp=Numerador.CodEsp LEFT OUTER JOIN
		AnestesNoAsig ON Denominador.CodEsp=AnestesNoAsig.CodEsp LEFT OUTER JOIN
		AnestesTotSolDeAsig ON Denominador.CodEsp=AnestesTotSolDeAsig.CodEsp
	ORDER BY Denominador.Especialidad
