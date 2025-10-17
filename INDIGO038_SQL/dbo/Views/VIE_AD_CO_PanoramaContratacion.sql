-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: dbo
-- Object: VIE_AD_CO_PanoramaContratacion
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [dbo].[VIE_AD_CO_PanoramaContratacion]
AS
SELECT        TOP (200) Id, ContractEntityId, HealthAdministratorId, Code, ContractName, ContractNumber, ContractValue, ExecuteValue, InitialDate, EndDate, Legalized, 
                         DateLegalization, Observations, ContractObject, PrintingMode, TerminationControl, NotificationValueType, PercentageNotification, NotificationValue, 
                         NotificationTimeType, NotificationDays, Status, CreationUser, CreationDate, ModificationUser, ModificationDate, InForceUser, InForceDate, SuspendedUser, 
                         SuspendedDate, FinishedUser, FinishedDate
FROM            Contract.Contract


