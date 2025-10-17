-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: HSAP_RIPS_MENSAJES
-- Extracted by Fabric SQL Extractor SPN v3.9.0













CREATE PROCEDURE [Report].[HSAP_RIPS_MENSAJES]
    @StartDate DATE,      
    @EndDate DATE         
AS
BEGIN
    SET NOCOUNT ON;

	with cte_rips_detail as (
	   SELECT ElectronicsRIPSId,
           MAX(CreationDate) AS CreationDate,
		   Message, 
           path, 
		   messageCode, 
           TypeMessage
    FROM Billing.ElectronicsRIPSDetail 
    GROUP BY ElectronicsRIPSId,
	         Message, 
             path,
		     messageCode, 
             TypeMessage

	)

    SELECT DISTINCT
           i.InvoiceNumber AS Factura,
		   i.AdmissionNumber Ingreso,
		   i.PatientCode DocumentoPaciente,
           ripsd.Message AS Mensaje,
           ripsd.path AS Motivo,
		   ripsd.messageCode CodigoMensaje,
           ripsd.TypeMessage AS TipoMensaje,
		   CASE ripsd.TypeMessage 
	       WHEN '' THEN 'EXCEPCION INTERNA' 
	       ELSE ripsd.TypeMessage END AS [ESTADO RIPS],
		   p.creationdate FechaRips,
		   i.OutputDate FechaEgreso,
		   ha.Name Entidad

    FROM Billing.ElectronicsProperties p
    INNER JOIN Billing.Invoice i ON i.id = p.EntityId AND p.EntityName = 'Invoice'
    INNER JOIN Billing.ElectronicsRIPS rips ON rips.ElectronicsPropertiesId = p.id
    INNER JOIN cte_rips_detail ripsd ON  ripsd.ElectronicsRIPSId = rips.id
	INNER JOIN Contract.HealthAdministrator ha ON HA.ID = I.HealthAdministratorId
    WHERE ripsd.TypeMessage LIKE '%RECHAZADO%'
      AND p.creationdate BETWEEN @StartDate AND @EndDate
	  AND p.statusrips = 3 and i.DocumentType in (1,2) and i.Status = 1-- and i.invoicenumber = 'HSPE945831';

END;
