-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_RADICACIONVSCIRUGIA
-- Extracted by Fabric SQL Extractor SPN v3.9.0




/*******************************************************************************************************************
Nombre: RADICACION VS CIRUGIA
Tipo:Vista
Observacion: RADICACION VS CIRUGIA
Profesional: Milton Urbano Bolañoz
Fecha:15-08-2025 (Modificació) _ Estado, Cups
-----------------------------------------------------------------*/




CREATE VIEW [Report].[View_HDSAP_RADICACIONVSCIRUGIA]
AS

SELECT DISTINCT
    ra.NUMRADICACION AS ConsecutivoRadicación, 
    RA.FECHACONFIRMACION AS FechaConfirmacion,
	ra.FECHARADIC FechaRadicacion,
    qx.FECHORFIN AS FechaCirugia,
    DATEDIFF(day, ra.FECHACONFIRMACION,qx.FECHORFIN) AS 'Dias Confirmacion Radicación VS Cirugia',
	DATEDIFF(MINUTE, ra.FECHACONFIRMACION,qx.FECHORFIN) AS 'Minutos Confirmacion Radicación VS Cirugia',
    ra.IPCODPACI AS DocumentoPaciente,	  
    pac.IPNOMCOMP AS NombrePaciente,
    ine.DESESPECI AS Especialidad,
    pro.NOMMEDICO AS Especialista,
	qx.NUMINGRES Ingreso,
	N.NOMENTIDA	Entidad

FROM ADRADICACIONQX RA
LEFT JOIN HCQXINFOR qx ON qx.IPCODPACI = ra.IPCODPACI AND qx.CODSERIPS = ra.QXPRINCIPAL  -- Asegura que sea el mismo procedimiento (Radicado, Cirugia) 
JOIN ADRADICACIONQXD RAD ON RAD.IDRADICACIONQX = RA.ID
JOIN INPACIENT pac ON pac.IPCODPACI = ra.IPCODPACI
JOIN INENTIDAD n ON n.CODENTIDA = pac.CODENTIDA
JOIN INESPECIA ine ON ine.CODESPECI = ra.CODESPECI
JOIN INPROFSAL pro ON pro.CODPROSAL = ra.CODPROSAL
WHERE ra.estado IN (1, 2) --- Estado de la Radicacion (1-Radicado 2-Confirmado)
---and ra.IPCODPACI = '12143666'


