-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_TRAZABILIDAD_AUTORIZACIONES
-- Extracted by Fabric SQL Extractor SPN v3.9.0







-- =============================================
-- Author:      Miguel Angle Ruiz Vega
-- Create date: 2025-01-31 10:51:38
-- Database:    INDIGO043
-- Description: Reporte Cuentas Medicas Trazabilidad
-- =============================================



CREATE VIEW [Report].[View_HDSAP_TRAZABILIDAD_AUTORIZACIONES]
AS

SELECT I.IFECHAING 'FECHA INGRESO',
       I.NUMINGRES 'NUMERO INGRESO',
	   I.FECHEGRESO 'FECHA EGRESO',
	   PAC.IPCODPACI 'DOCUMENTO',
	   PAC.IPNOMCOMP 'NOMBRE PACIENTE',
	   INE.NOMENTIDA 'ENTIDAD',
	   CASE HA.EntityType  WHEN '1'  THEN 'EPS Contributivo'
					WHEN '2'  THEN 'EPS Subsidiado'
					WHEN '3'  THEN 'ET Vinculados Municipios'
					WHEN '4'  THEN 'ET Vinculados Departamentos'
					WHEN '5'  THEN 'ARL Riesgos Laborales'
					WHEN '6'  THEN 'MP Medicina Prepagada'
					WHEN '7'  THEN 'IPS Privada'
					WHEN '8'  THEN 'IPS Publica'
					WHEN '9'  THEN 'Regimen Especial'
					WHEN '10' THEN 'Accidentes de transito'
					WHEN '11' THEN 'Fosyga'
					WHEN '12' THEN 'Otros' 
					WHEN '13' THEN 'Aseguradoras' END AS REGIMEN,
	  CUPS.Code 'CODIGO CUPS',
	  CUPS.Description 'NOMBRE CUPS',
	  CASE AD.PROESTADO
	    WHEN 1 THEN 'Pendiente Solicitud'
		WHEN 2 THEN 'Solicitado'
		WHEN 3 THEN 'Autorizado'
		WHEN 4 THEN 'Anulado'
		WHEN 5 THEN 'No Autorizado'
		END 'ESTADO AUTORIZACION'

FROM ADAUTOSER AD
JOIN INPACIENT PAC ON PAC.IPCODPACI = AD.IPCODPACI
JOIN ADINGRESO I ON I.NUMINGRES = AD.NUMINGRES
JOIN INENTIDAD INE ON INE.CODENTIDA = I.CODENTIDA
JOIN Contract.CUPSEntity CUPS ON CUPS.CODE = AD.CODSERIPS
JOIN Contract.HealthAdministrator HA ON AD.CODENTIDA= HA.Code AND (AD.SOLEXTRAM!='1' OR AD.SOLEXTRAM IS NULL)


