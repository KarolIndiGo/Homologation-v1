-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: SP_Opportunity_Laboratory
-- Extracted by Fabric SQL Extractor SPN v3.9.0




    /*******************************************************************************************************************
Nombre: [Report].[SP_Opportunity_Laboratory]
Tipo:Vista
Observacion: Oportunidad de laboratorio
Profesional: Nilsson Miguel Galindo Lopez
Fecha:03-05-2022
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha: 20-06-2023
Ovservaciones:En el estado del servicio se agrega el estado 9 para HOMI
--------------------------------------
Version 3
Persona que modifico:
Observacion:
Fecha:
----------------------------------------------------------------------------------------------------------------------------------
Version 4
Persona que modifico:
Observacion:
Fecha:
--***********************************************************************************************************************************/



CREATE PROCEDURE [Report].[SP_Opportunity_Laboratory]
	@FECINI Datetime ,
	@FECFIN Datetime 
AS
SELECT * FROM [Report].[ViewOpportunitLaboratory]
WHERE 
CAST([FECHA SOLICITUD] AS DATE) BETWEEN @FECINI AND @FECFIN
