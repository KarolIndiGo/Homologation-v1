-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: DocumentosCargados
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[DocumentosCargados]
AS
select * from
(
select c.NOMCENATE as CentroAtencion, d.IPCODPACI AS Paciente, d.NUMINGRES AS ingreso, d.CODPROSAL, d.CODESPECI, d.FECPROCES AS FechaCargue, d.OBSERDOCU AS Observaciones, d.CODUSUARI AS Usuario,
d.TIPODOCUM, 
CASE d.TIPODOCUM
	WHEN 2 THEN 'Laboratorio'
	WHEN 3 THEN 'Imagenologia'
	WHEN 4 THEN 'Patologias'
	WHEN 5 THEN 'Decreto_3047'
	WHEN 6 THEN 'Plantillas_Documentos'
	WHEN 7 THEN 'Consentimiento_Informado'
	WHEN 8 THEN 'Resultados_Examenes_Sitio'
	WHEN 9 THEN 'Lectura_Imagenes'
	WHEN 10 THEN 'Solicitudes'
	WHEN 11 THEN 'FacturasDeVenta'
	WHEN 98 THEN 'OtrosProcedimientos'
	WHEN 99 THEN 'Referencia'
END AS Tipo_Documento, 'Ingreso' AS Tipo_Archivo
from dbo.HCDOCUMAD AS d
INNER JOIN dbo.ADCENATEN AS c ON c.CODCENATE=d.CODCENATE
--where d.FECPROCES BETWEEN '2023-08-01'  AND '2023-08-31'
UNION ALL
select c.NOMCENATE as CentroAtencion, d.IPCODPACI AS Paciente, d.NUMINGRES AS ingreso, '' AS CODPROSAL, '' AS CODESPECI, d.FECREGDOC AS FechaCargue, d.DESDOCALM AS Observaciones, d.CODUSUARI AS Usuario,
d.TIPODOCUM,
t.DESCATEGO AS Tipo_Documento,
CASE d.TIPARCPAC
	WHEN 1 THEN 'Paciente'
	WHEN 2 THEN 'Ingreso'
END AS Tipo_Archivo
from dbo.INPACIDOC as d
INNER JOIN dbo.ADCENATEN AS c ON c.CODCENATE=d.CODCENATE
LEFT JOIN dbo.HCCATDOCU AS t ON t.CODCATEGO=d.TIPODOCUM
) as C
WHERE DATEPART(YYYY,FechaCargue)>='2023'
