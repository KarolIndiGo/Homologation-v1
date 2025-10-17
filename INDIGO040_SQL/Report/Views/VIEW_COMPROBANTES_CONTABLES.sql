-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: VIEW_COMPROBANTES_CONTABLES
-- Extracted by Fabric SQL Extractor SPN v3.9.0






--/****** Object:  View [Report].[VIEW_COMPROBANTES_CONTABLES]    Script Date: 28/02/2023 2:26:28 p. m. ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


CREATE VIEW [Report].[VIEW_COMPROBANTES_CONTABLES] AS

select --TOP 100
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
ISNULL(BO.Name,'N/A') [SEDE],JV.Consecutive as [NUMERO COMPROBANTE],JVT.Code + ' - ' + JVT.Name [TIPO COMPROBANTE] ,JV.VoucherDate [FECHA COMPROBANTE] , 
case JV.Status when 1 then 'Registrado' when 2 then 'Confirmado' when 3 then 'Anulado' end [ESTADO] ,
JV.EntityCode [DOCUMENTO ORIGEN] ,JV.EntityName [ORIGEN],MA.Number [CUENTA CONTABLE],MA.Name [DESCRIPCION CUENTA],TP.Nit [NIT],TP.Name [TERCERO] ,
CC.Code AS [CODIGO CENTRO COSTO],CC.Name [CENTRO DE COSTO],JVD.DebitValue [VALOR DEBITO] ,JVD.CreditValue [VALOR CREDITO],JVD.Detail [DETALLE],
jv.creationuser AS [CODIGO USUARIO QUE CREO],
pcre.fullname AS [USUARIO QUE CREO],
JV.ConfirmationUser [CODIGO USUARIO QUE CONFIRMO], 
PER.Fullname [USUARIO QUE CONFIRMO],
JV.ConfirmationDate [FECHA CONFIRMACION],
1 as 'CANTIDAD',
  CAST(JV.ConfirmationDate AS date) AS 'FECHA BUSQUEDA',
  YEAR(JV.ConfirmationDate) AS 'AÑO BUSQUEDA',
  MONTH(JV.ConfirmationDate) AS 'MES BUSQUEDA',
  CONCAT(FORMAT(MONTH(JV.ConfirmationDate), '00') ,' - ', 
	   CASE MONTH(JV.ConfirmationDate) 
	    WHEN 1 THEN 'ENERO'
   	    WHEN 2 THEN 'FEBRERO'
	    WHEN 3 THEN 'MARZO'
	    WHEN 4 THEN 'ABRIL'
	    WHEN 5 THEN 'MAYO'
	    WHEN 6 THEN 'JUNIO'
	    WHEN 7 THEN 'JULIO'
	    WHEN 8 THEN 'AGOSTO'
	    WHEN 9 THEN 'SEPTIEMBRE'
	    WHEN 10 THEN 'OCTUBRE'
	    WHEN 11 THEN 'NOVIEMBRE'
	    WHEN 12 THEN 'DICIEMBRE' END) 'MES NOMBRE BUSQUEDA',
 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
from GeneralLedger .JournalVouchers JV 
JOIN GeneralLedger .JournalVoucherTypes AS JVT  ON JVT.Id =JV.IdJournalVoucher 
JOIN GeneralLedger .JournalVoucherDetails AS JVD  ON JV.Id =JVD.IdAccounting 
JOIN GeneralLedger .MainAccounts as MA  ON MA.Id =JVD.IdMainAccount 
LEFT JOIN Security .[User] AS USU  ON USU.UserCode =JV.ConfirmationUser 
LEFT JOIN Security .Person AS PER  ON PER.Id =USU.IdPerson 
LEFT JOIN Security .[User] AS ucre  ON jv.creationuser = ucre.usercode
LEFT JOIN Security .Person AS pcre  ON ucre.idperson = pcre.id
LEFT JOIN Common .ThirdParty AS TP  ON TP.Id =JVD.IdThirdParty 
LEFT JOIN Payroll .CostCenter AS CC  ON CC.Id =JVD.IdCostCenter 
LEFT JOIN Payroll .FunctionalUnit FU  ON FU.CostCenterId =CC.Id 
LEFT JOIN Payroll .BranchOffice BO   ON BO.Id  =FU.BranchOfficeId
WHERE
 CAST(JV.ConfirmationDate AS DATE) = CAST(DATEADD(d,-1,GETDATE()) AS DATE)
