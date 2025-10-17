-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: SP_InterConsultationRequestsInfectologia
-- Extracted by Fabric SQL Extractor SPN v3.9.0



/*******************************************************************************************************************
Nombre: [Report].[SP_InterConsultationRequestsInfectologia]
Tipo:PROCEDIMIENTO ALMACENADO
Observacion:Procedimiento almacennado que llama la vista de interconsultas, este sp se realiza a peticion de san jose
			por bajos recursos en el software la consulta sea lo mas lijera posible en este caso solo funciona pra terapias.
Profesional:
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:
Fecha:
Observaciones:
--------------------------------------
_________________________________________________________________________
Version 3
Persona que modifico:
Observación:
Fecha:
***********************************************************************************************************************************/
CREATE PROCEDURE [Report].[SP_InterConsultationRequestsInfectologia]
@FECINI DATE,
@FECFIN DATE
AS

--DECLARE @FECINI DATE='2023-10-01'
--DECLARE @FECFIN DATE='2023-10-31'

select * from 
[Report].[ViewInterConsultationRequests] 
WHERE [DESCRIPCION SERVICIO] LIKE '%infectologia%' AND [FECHA BUSQUEDA] BETWEEN @FECINI AND @FECFIN
