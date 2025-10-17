-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewPanoramaContratos
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[ViewPanoramaContratos] AS
SELECT DISTINCT
 CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
 CE.Code AS [CODIGO ENTIDADA CONTRATO],
 CE.Name as [ENTIDAD CONTRATO],
 HA.Code as [CODIGO ENTIDAD ADMINISTRADORA],
 HA.Name as [ENTIDAD ADMINISTRADORA],
 C.Code as [CODIGO CONTRATO],
 CD.ContractName as [NOMBRE CONTRATO],
 ContractValue as [VALOR CONTRATO],
 ExecuteValue as [VALOR EJECUTADO],
 ContractObject as [OBJETO CONTRATO],
 CD.ContractNumber as [NUMERO CONTRATO],
 case Type 
      when 1 then 'Nuevo' 
	  when 2 then 'Inclusión'
	  when 3 then 'Otro Si' 
	  when 4 then 'Adición' 
	  when 5 then 'Prorroga'
	  when 6 then 'Otro' End as [TIPO],
 cast(CD.InitialDate as date ) as [FECHA INICIAL],
 cast(Cd.EndDate as date ) as [FECHA FINAL],
 cast(CD.BillingInitialDate as date ) as [FECHA INICIAL FACTURACION],
 cast(Cd.BillingEndDate as date ) as [FECHA FINAL FACTURACION],
 case CD.Legalized when 1 then 'Si' else 'No' end as [LEGALIZADO],
 Cd.DateLegalization as [FECHA LEGALIZACION],
 cast(CD.RadicatedBillingDate AS date ) AS [FECHA RADICACION],
 cd.Observations as [OBSERVACIONES],
 CASE CD.PrintingMode 
      WHEN 1 THEN 'MANUAL' 
	  WHEN 2 THEN 'CUPS' 
	  WHEN 3 THEN 'RIPS' 
	  WHEN 4 THEN 'Descripción Relacionada' 
	  WHEN 5 THEN 'CUPS Descripción Relacionada' 
  End [MODO DE IMPRESION],
  CASE CD.TerminationControl 
       WHEN 1 THEN 'Ninguno' 
	   WHEN 2 THEN 'Fecha Termiancion' 
	   WHEN 3 THEN 'Valor Contrato' 
	   WHEN 4 THEN 'Fecha Terminacion o Valor contrato' 
  End [TERMINACION],
  case CD.NotificationValueType 
       when 1 then 'Ninguno' 
	   when 2 then '% Valor Contrato' 
	   when 3 then 'Valor Fijo' 
	   else 'N/A' End [NOTIFICACION POR VALOR],
  CD.PercentageNotification AS [% NOTIFICACION],
  cd.NotificationValue as [VALOR NOTIFICACION],
  CASE CD.NotificationTimeType 
       WHEN 1 THEN 'Ninguno' 
	   WHEN 2 THEN 'Dias Anterioridad' 
  else 'N/A' End [NOTIFICACION POR TIEMPO],
  CD.NotificationDays AS [DIAS RESTANTES],
  PercentageApplyPaymentSoon as [% APLICA PRONTO PAGO],
  CD.AgesPortfolioId [EDAD CARTERA PAGO],
  case ValidRecord when 1 then 'Si' else 'No' end [VIGENTE],
  CG.Code [CODIGO GRUPO ATENCION],
  CG.Name [GRUPO ATENCION],
  PR.Code [CODIGO TARIFA],
  PR.Name [TARIFA DE PRODUCTO],
  PT.Code [CODIGO PLANTILLA CUBRIMIENTO],
  PT.Name [PLANTILLA DE CUBRIMIENTO],
  DR.Code [CODIGO DEFINICION TARIFAS],
  DR.Name [DEFINICION DE TARIFAS],
  CGDR.InitialDate [FECHA INICIAL DEFINICION],
  CGDR.EndDate [FECHA FINAL DEFINICION],
  1 as 'CANTIDAD',
  CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM 
  Contract.Contract AS C 
  inner join Contract .HealthAdministrator AS HA ON HA.Id =C.HealthAdministratorId 
  inner join Contract .ContractEntity AS CE ON CE.Id =C.ContractEntityId 
  inner join Contract .ContractDetail as CD on CD.ContractId =C.Id
  LEFT JOIN Contract.CareGroup AS CG WITH (NOLOCK) ON C.Id =CG.ContractId
  LEFT JOIN Inventory.ProductRate AS PR WITH (NOLOCK) ON CG.ProductRateId =PR.Id
  LEFT JOIN Contract.ProcedureTemplate AS PT WITH (NOLOCK) ON PT.Id =CG.ProcedureTemplateId
  LEFT JOIN Contract.CareGroupDefinitionRate CGDR WITH (NOLOCK) ON CG.Id =CGDR.CareGroupId
  LEFT JOIN Contract .DefinitionRate AS DR WITH (NOLOCK) ON CGDR.DefinitionRateId =DR.Id
--order by C.Code
