-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_PRODUCTIVIDAD_DETALLADA_CONTABILIZADA
-- Extracted by Fabric SQL Extractor SPN v3.9.0












/**********************************************************************************************************************************
Nombre:[Report].[IND_SP_V2_ERP_PRODUCTIVIDAD_DETALLADA_CONTABILIZADA] 
Tipo:Procedimiento Almacenado
Observacion: Destallado de productividad, funciona a partir del mes de marzo del 2023
Profesional: Ing. Andres Cabrera
Fecha: 19-05-2023
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:24-05-2023
Observaciones: Se ajusta el procedimiento almacenado para que en el @TBL_FACTURADOS_UNICOS llame por palabra clave FACTURA DE VENTA y no por ID, para que funcione en,
			  mas instituciones.
--------------------------------------
Version 3
Persona que modifico:Nilsson Miguel Galindo Lopez
Fecha:18-07-2024
Observaciones: Se ajusta la consulta numero 5 de reconocimiento contabilizado para que reconosca el nit del tercero ya que tenia error
cuando el tercero era 999 esto solicitado por el hospital San Jose en el ticket 19188
--------------------------------------
Version 4
Persona que modifico:Nilsson Miguel Galindo Lopez
Fecha:22-07-2024
Observaciones: Se ajusta la logica de la consulta de facturación basica @TBL_FACTURA_BASICA_UNICOS, para conocer la diferencia entre factura basica y copago
			  esto solicitado por el hospital San Jose en el ticket 19300
***********************************************************************************************************************************/

CREATE PROCEDURE [Report].[IND_SP_V2_ERP_PRODUCTIVIDAD_DETALLADA_CONTABILIZADA] 
@ANO AS INT,
@MES AS INT
AS



--DECLARE @ANO AS INT = 2024;
--DECLARE @MES AS INT = 7;

--set @ANO=2024
--set @MES=12

--SE VALIDA QUE CLIENTE ES PARA ASI SACAR EL ID DE LA CUENTA
DECLARE @ID_COMPANY VARCHAR(9)=(CAST(DB_NAME() AS VARCHAR(9)));
DECLARE @TIPOFACTURA INT,@TIPOANULACION INT,@RECONOCIMIENTO INT, @TIPOFACTURABASICA INT
IF @ID_COMPANY='INDIGO036' BEGIN SET @TIPOFACTURA=116 SET @TIPOANULACION=14 SET @RECONOCIMIENTO=53 END --HOMI
IF @ID_COMPANY='INDIGO039' BEGIN SET @TIPOFACTURA=50 SET @TIPOANULACION=51 SET @RECONOCIMIENTO=55 END --SIEGOS Y SORDOS
IF @ID_COMPANY='INDIGO040' BEGIN SET @TIPOFACTURA=29 SET @TIPOANULACION=30 SET @RECONOCIMIENTO=92 SET @TIPOFACTURABASICA=90 END--HOSPITAL SAN JOSE
IF @ID_COMPANY='INDIGO640' BEGIN SET @TIPOFACTURA=29 SET @TIPOANULACION=30 SET @RECONOCIMIENTO=92 SET @TIPOFACTURABASICA=90 END--HOSPITAL SAN JOSE
IF @ID_COMPANY='INDIGO041' BEGIN SET @TIPOFACTURA=68 SET @TIPOANULACION=69 SET @RECONOCIMIENTO=73 END; --SAN FRANCISCO
IF @ID_COMPANY='INDIGO043' BEGIN SET @TIPOFACTURA=27 SET @TIPOANULACION=26 SET @RECONOCIMIENTO=46 END; --SAN ANTONIO DE PITALITO


/**************************************************************************************************************************
------------------SE DECLARAN LAS VARIABLES TABLA
***************************************************************************************************************************/

DECLARE @TBL_FACTURADOS_UNICOS AS TABLE (   [CODIGO COMPROBANTE] [varchar](20) NOT NULL,
											[COMPROBANTE CONTABLE] [varchar](500) NULL,
											[CONSECUTIVO CONTABLE] [bigint] NOT NULL,
											[EntityCode] [varchar](20) NULL,
											[EntityId] [int] NULL,
											[VoucherDate] [date] NULL,
											[Valor_Credito] [numeric](18, 0) NULL,
											[AdmissionNumber] [char](10) NULL,
											[InvoiceNumber] [VARCHAR] (20) NULL)

DECLARE @TBL_ANULADOS_UNICOS AS TABLE(  	[CODIGO COMPROBANTE] [varchar](20) NOT NULL,
											[COMPROBANTE CONTABLE] [varchar](500) NULL,
											[CONSECUTIVO CONTABLE] [bigint] NOT NULL,
											[EntityCode] [varchar](20) NULL,
											[EntityId] [int] NULL,
											[VoucherDate] [date] NULL,
											[Valor_Credito] [numeric](18, 0) NULL,
											[AdmissionNumber] [char](10) NULL);

DECLARE @TBL_RECONOCIMIENTO_UNICOS AS TABLE  ([CODIGO COMPROBANTE] [varchar](20) NOT NULL,
											  [COMPROBANTE CONTABLE] [varchar](500) NULL,
											  [CONSECUTIVO CONTABLE] [bigint] NOT NULL,
											  [EntityCode] [varchar](20) NULL,
											  [EntityId] [int] NULL,
											  [id] [int] NOT NULL,
											  [VoucherDate] [date] NULL,
											  [Valor_Credito] [numeric](18, 0) NULL);

DECLARE @TBL_CAPITA_FACTURADA AS TABLE(	[CODIGO COMPROBANTE] [varchar](20) NOT NULL,
										[COMPROBANTE CONTABLE] [varchar](500) NULL,
										[CONSECUTIVO CONTABLE] [bigint] NOT NULL,
										[EntityCode] [varchar](20) NULL,
										[EntityId] [int] NULL,
										[VoucherDate] [date] NULL,
										[Valor_Credito] [decimal](38, 5) NULL,
										[CreationUser] [varchar](20) NOT NULL,
										[Number] [varchar](50) NOT NULL,
										[Name] [varchar](300) NOT NULL);

DECLARE @TBL_ANULADOS_UNICOS_CAPITA AS TABLE([CODIGO COMPROBANTE] [varchar](20) NOT NULL,
                                             [COMPROBANTE CONTABLE] [varchar](500) NULL,
											 [CONSECUTIVO CONTABLE] [bigint] NOT NULL,
											 [EntityCode] [varchar](20) NULL,
											 [EntityId] [int] NULL,
											 [VoucherDate] [date] NULL,
											 [Valor_Credito] [decimal](38, 5) NULL,
											 [CreationUser] [varchar](20) NOT NULL,
											 [Number] [varchar](50) NOT NULL,
											 [Name] [varchar](300) NOT NULL);

DECLARE @TBL_NO_FACTURABLES_UNICOS AS TABLE ([ID] [int] NOT NULL,
                                             [AdmissionNumber] [char](10) NULL,
											 [PatientCode] [varchar](25) NULL,
											 [HealthAdministratorId] [int] NULL,
											 [ThirdPartyId] [int] NOT NULL,
											 [CareGroupId] [int] NULL,
											 [InvoiceNumber] [varchar](20) NOT NULL,
											 [InvoicedDate] [datetime] NOT NULL,
											 [TotalInvoice] [numeric](18, 0) NULL);

DECLARE @TBL_FACTURA_BASICA_UNICOS AS TABLE ([CODIGO COMPROBANTE] [varchar](20) NOT NULL,
											 [COMPROBANTE CONTABLE] [varchar](500) NULL,
											 [CONSECUTIVO CONTABLE] [bigint] NOT NULL,
											 [EntityCode] [varchar](20) NULL,
											 [EntityId] [int] NULL,
											 [id] [int] NOT NULL,
											 [VoucherDate] [date] NULL,
											 [Valor_Credito] [numeric](18, 0) NULL,
											 [CreationUser] [varchar](20) NOT NULL);

DECLARE @TBL_ALTA_MEDICA_FACTURADOS AS TABLE(INGRESO CHAR(10),
											 IDENTIFICACION VARCHAR(25),
											 [FECHA ALTA MEDICA] DATETIME);

DECLARE @TBL_BILLING AS TABLE(	[ID_COMPANY] [varchar](9) NULL,
								[TIPO DOCUMENTO] [varchar](28) NOT NULL,
								[CODIGO COMPROBANTE] [varchar](20) NOT NULL,
								[COMPROBANTE CONTABLE] [varchar](500) NULL,
								[CONSECUTIVO CONTABLE] [bigint] NOT NULL,
								[IDDETALLE] [int] NULL,
								[ESTADO] [varchar](14) NOT NULL,
								[AÑO] [int] NULL,
								[MES] [int] NULL,
								[DIA] [int] NULL,
								[NIT] [varchar](25) NOT NULL,
								[ENTIDAD] [varchar](300) NOT NULL,
								[CODIGO GRUPO ATENCION] [varchar](20) NOT NULL,
								[GRUPO ATENCION] [varchar](100) NOT NULL,
								[IDENTIFICACION] [varchar](25) NULL,
								[PACIENTE] [varchar](250) NULL,
								[INGRESO] [varchar](10) NULL,
								[FECHA INGRESO] [date] NULL,
								[FECHA EGRESO] [date] NULL,
								[NRO FACTURA] [varchar](20) NULL,
								[FECHA FACTURA] [date] NULL,
								[TOTAL FACTURA] [numeric](20, 2) NOT NULL,
								[VALOR COPAGO/CUOTA FACTURA] [numeric](20, 2) NOT NULL,
								[NRO FACTURA COPAGO/CUOTA FACTURA] VARCHAR(20),
								[TIPO REGISTRO] [varchar](30) NULL,
								[TIPO SERVICIO] [varchar](21) NOT NULL,
								[PRESENTACION] [varchar](13) NOT NULL,
								[CODIGO CONCEPTO/GRUPO] [varchar](20) NULL,
								[NOMBRE CONCEPTO/GRUPO] [varchar](100) NULL,
								[CATERGORIA FACTURA] [varchar](100) NULL,
								[FECHA SERVICIO] [datetime] NULL,
								[CUPS/PRODUCTO] [varchar](20) NULL,
								[DESCRIPCION] [varchar](300) NULL,
								[CODIGO DETALLE QX] [varchar](20) NOT NULL,
								[DESCRIPCION DETALLE QX] [varchar](60) NULL,
								[DECRIPCION RELACIONADA] [varchar](250) NULL,
								[CANTIDAD] [int] NULL,
								[VALOR SERVICIO] [numeric](22, 2) NULL,
								[COSTO SERVICIO] [numeric](22, 2) NULL,
								[VALOR UNITARIO] [numeric](22, 2) NULL,
								[TARIFA IVA] [varchar](200) NULL,
								[VALOR IVA] [numeric](20, 2) NULL,
								[VALOR COPAGO/CUOTA] [numeric](20, 2) NOT NULL,
								[VALOR TOTAL] [numeric](22, 2) NULL,
								[ES PAQUETE] [varchar](2) NULL,
								[INCLUIDO EN PAQUETE] [varchar](2) NULL,
								[CODIGO PAQUETE] [varchar](20) NULL,
								[NOMBRE PAQUETE] [varchar](300) NULL,
								[TIPO LIQUIDACION] [varchar](44) NOT NULL,
								[CUPS QUE INCLUYE] [varchar](20) NULL,
								[NOMBRE CUPS QUE INCLUYE] [varchar](300) NULL,
								[IDENTIFICACION PROFESIONAL] [varchar](20) NULL,
								[PROFESIONAL] [varchar](60) NULL,
								[ESPECIALIDAD] [varchar](60) NULL,
								[CODIGO UNIDAD SOLICITO] [varchar](20) NOT NULL,
								[UNIDAD SOLICITO] [varchar](50) NOT NULL,
								[CODIGO CC CONTABILIZO] [varchar](20) NOT NULL,
								[CENTRO COSTO CONTABILIZO] [varchar](200) NOT NULL,
								[NRO CUENTA CONTABILIZO] [varchar](50) NULL,
								[CUENTA CONTABILIZO] [varchar](300) NULL,
								[FECHA ANULACION] [date] NULL,
								[AGREMIACION] [varchar](100) NULL,
								[USUARIO] [char](60) NULL,
								[USUARIO CREO ORDEN] [char](60) NULL,
								[FECHA ORDEN] [date] NULL,
								[TIPO INGRESO] [varchar](20) NULL,
								[ULT_ACTUAL] [datetime] NULL);

DECLARE @TBL_ALTA_MEDICA_ANULADOS AS TABLE(INGRESO CHAR(10),
										   IDENTIFICACION VARCHAR(25),
										   [FECHA ALTA MEDICA] DATETIME);

/**********************************************************************************************************************
----------SE INSERTAN LOS DATOS EN LAS VARIABLES TABLA---------------
**********************************************************************************************************************/

---------------------------------SE INSERTAN LOS DATOS DE FACTURACION UNICOS EN CUALQUIER ESTADO--------------------------- 
   INSERT INTO @TBL_FACTURADOS_UNICOS
	SELECT DISTINCT
	 JVT.Code 'CODIGO COMPROBANTE', 
	 JVT.Description 'COMPROBANTE CONTABLE',
	 JV.Consecutive 'CONSECUTIVO CONTABLE',
	 JV.EntityCode,
	 JV.EntityId,
	 CAST(JV.VoucherDate AS DATE) VoucherDate,
	 CAST(sum(JVD.CreditValue) as numeric) Valor_Credito,
	 F.AdmissionNumber,FAC.InvoiceNumber
	FROM 
	 GeneralLedger.JournalVouchers JV WITH (NOLOCK)
	 INNER JOIN GeneralLedger.JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
	 INNER JOIN GeneralLedger.JournalVoucherTypes JVT WITH (NOLOCK) ON JVT.Id = JV.IdJournalVoucher
	 INNER JOIN Billing.Invoice AS F WITH (NOLOCK) ON F.Id =JV.EntityId
	 LEFT JOIN Billing.InvoiceCopay IC ON F.Id=IC.InvoiceId
	 LEFT JOIN Billing.BasicBilling B ON IC.BasicBillingId=B.Id
	 LEFT JOIN Billing.Invoice FAC ON B.InvoiceId=FAC.Id
	WHERE 
	 YEAR(JV.VoucherDate) = @ANO AND 
	 MONTH(JV.VoucherDate)= @MES AND 
	 JV.LegalBookId =1 AND 
	 jv.EntityName ='Invoice' AND 
	 F.DocumentType <> 5 AND 
	 JV.IdJournalVoucher = @TIPOFACTURA
	GROUP BY JVT.Code, JV.Consecutive, JVT.Description, JV.EntityCode, JV.EntityId,CAST(JV.VoucherDate AS DATE),F.AdmissionNumber,FAC.InvoiceNumber

----------------------------------SE INSERTAN LOS DATOS DE ANULACION------------------------------------------
   INSERT INTO @TBL_ANULADOS_UNICOS
    SELECT DISTINCT 
	 JVT.Code 'CODIGO COMPROBANTE', 
	 JVT.Description 'COMPROBANTE CONTABLE',
	 JV.Consecutive 'CONSECUTIVO CONTABLE',
	 JV.EntityCode,
	 JV.EntityId,
	 CAST (JV.VoucherDate AS DATE) VoucherDate,
	 CAST (SUM(JVD.CreditValue) AS NUMERIC) Valor_Credito,
	 F.AdmissionNumber
	FROM 
	 GeneralLedger.JournalVouchers JV WITH (NOLOCK)
	 INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
	 INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.Id =JV.IdJournalVoucher
	 LEFT JOIN Billing .Invoice AS F WITH (NOLOCK) ON F.Id =JV.EntityId
	WHERE 
	 YEAR(JV.VoucherDate) = @ANO AND 
	 MONTH(JV.VoucherDate)=@MES AND 
	 JV.LegalBookId = 1 AND 
	 jv.EntityName ='Invoice' AND 
	 F.DocumentType <> 5 AND 
	 IdJournalVoucher = @TIPOANULACION
    GROUP BY 
   	 JVT.Code,
	 JV.Consecutive,
	 JVT.Description, 
	 JV.EntityCode,
	 JV.EntityId,
	 CAST(JV.VoucherDate AS DATE),
	 F.AdmissionNumber

----------------------------------SE INSERTAN LOS DATOS DE RECONICIMIENTO UNICOS------------------------------------------
  INSERT INTO @TBL_RECONOCIMIENTO_UNICOS
  SELECT DISTINCT  
   JVT.Code 'CODIGO COMPROBANTE', 
   JVT.Description 'COMPROBANTE CONTABLE',
   JV.Consecutive 'CONSECUTIVO CONTABLE',
   JV.EntityCode,
   JV.EntityId,
   jv.id,
   CAST(JV.VoucherDate AS DATE) VoucherDate,
   CAST(sum(JVD.CreditValue) AS NUMERIC) Valor_Credito
  FROM 
   GeneralLedger.JournalVouchers JV WITH (NOLOCK)
   INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
   INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.Id =JV.IdJournalVoucher
   INNER JOIN Billing.RevenueRecognition AS RR WITH (NOLOCK) ON JV.EntityId=RR.ID
  WHERE 
   YEAR(JV.VoucherDate) = @ANO AND 
   MONTH(JV.VoucherDate)=@MES AND 
   JV.LegalBookId = 1 AND 
   jv.EntityName = 'RevenueRecognition' AND 
   IdJournalVoucher = @RECONOCIMIENTO
  GROUP BY 
   JVT.Code,JV.Consecutive,
   JVT.Description,
   JV.EntityCode,
   JV.EntityId,
   CAST(JV.VoucherDate AS DATE),
   jv.id;

---------------------------------SE INSERTAN LOS DATOS DE NO FACTURABLES UNICOS------------------------------------------

 INSERT INTO @TBL_NO_FACTURABLES_UNICOS
  SELECT DISTINCT  
   I.ID,
   I.AdmissionNumber,
   I.PatientCode,
   I.HealthAdministratorId,
   I.ThirdPartyId,
   I.CareGroupId,
   I.InvoiceNumber,
   I.InvoicedDate,
   CAST(I.TotalInvoice AS NUMERIC) TotalInvoice
  FROM 
   Billing.Invoice I WITH (NOLOCK)
  WHERE 
   I.DocumentType = 5 AND 
   I.Status =1 AND  
   YEAR(I.InvoiceDate)=@ANO AND 
   MONTH(I.InvoiceDate)=@MES


----------------------------------SE INSERTAN LOS DATOS DE FACTURACION CAPITA------------------------------------------
   INSERT INTO @TBL_CAPITA_FACTURADA
    SELECT DISTINCT  
	 JVT.Code 'CODIGO COMPROBANTE', 
	 JVT.Description 'COMPROBANTE CONTABLE',
	 JV.Consecutive 'CONSECUTIVO CONTABLE',
	 JV.EntityCode,
	 JV.EntityId,
	 CAST(JV.VoucherDate AS DATE) VoucherDate,
	 CAST(sum(JVD.CreditValue) AS NUMERIC) Valor_Credito,
	 JV.CreationUser,
	 MA.Number,
	 MA.Name 
	FROM 
	 GeneralLedger.JournalVouchers JV WITH (NOLOCK)
	 INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
	 INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.Id =JV.IdJournalVoucher
	 INNER JOIN GeneralLedger .MainAccounts AS MA WITH (NOLOCK) ON MA.Id =JVD.IdMainAccount 
	WHERE 
	 YEAR(JV.VoucherDate) = @ANO AND 
	 MONTH(JV.VoucherDate)=@MES AND 
	 JV.LegalBookId =1   AND 
	 jv.EntityName ='InvoiceEntityCapitated' AND 
	 IdJournalVoucher = @TIPOFACTURA AND 
	 MA.Number BETWEEN '41000000' AND '41999999'
    GROUP BY 
	 JVT.Code,
	 JV.Consecutive,
	 JVT.Description,
	 JV.EntityCode,
	 JV.EntityId,
	 CAST(JV.VoucherDate AS DATE),
	 JV.CreationUser,
	 MA.Number,
	 MA.Name ;

----------------------------------SE INSERTAN LOS DATOS DE ANULACION DE CAPITA------------------------------------------
   INSERT INTO @TBL_ANULADOS_UNICOS_CAPITA
    SELECT DISTINCT  
	 JVT.Code 'CODIGO COMPROBANTE', 
	 JVT.Description 'COMPROBANTE CONTABLE',
	 JV.Consecutive 'CONSECUTIVO CONTABLE',
	 JV.EntityCode,
	 JV.EntityId,
	 CAST(JV.VoucherDate AS DATE) VoucherDate,
	 CAST(sum(JVD.CreditValue) AS NUMERIC) Valor_Credito,
	 JV.CreationUser,
	 MA.Number,
	 MA.Name 
	    FROM 
     GeneralLedger.JournalVouchers JV WITH (NOLOCK)
	 INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
	 INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.Id =JV.IdJournalVoucher
	 INNER JOIN GeneralLedger .MainAccounts AS MA WITH (NOLOCK) ON MA.Id =JVD.IdMainAccount 
	WHERE 
	 YEAR(JV.VoucherDate) = @ANO AND 
	 MONTH(JV.VoucherDate)=@MES AND 
	 JV.LegalBookId =1 AND 
	 jv.EntityName ='InvoiceEntityCapitated' AND
 	 MA.Number BETWEEN '41000000' AND '41999999' AND
	 IdJournalVoucher= @TIPOANULACION
    GROUP BY 
	 JVT.Code,
	 JV.Consecutive,
	 JVT.Description,
	 JV.EntityCode,
	 JV.EntityId,
	 CAST(JV.VoucherDate AS DATE),
	 JV.CreationUser,
	 MA.Number,
	 MA.Name;

----------------------------------SE INSERTAN LOS DATOS DE FACTURA BASICA------------------------------------------
   INSERT INTO @TBL_FACTURA_BASICA_UNICOS
    SELECT DISTINCT 
     JVT.Code 'CODIGO COMPROBANTE', 
	 JVT.Description 'COMPROBANTE CONTABLE',
	 JV.Consecutive 'CONSECUTIVO CONTABLE',
	 JV.EntityCode,JV.EntityId,
	 jv.id,
	 CAST(JV.VoucherDate AS DATE) VoucherDate,
	 CAST(sum(JVD.CreditValue) AS NUMERIC) Valor_Credito,
	 JV.CreationUser
	FROM 
	 GeneralLedger.JournalVouchers JV WITH (NOLOCK)
	 INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
	 INNER JOIN GeneralLedger .JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.Id =JV.IdJournalVoucher
	 INNER JOIN Billing.BasicBilling AS BB WITH (NOLOCK) ON BB.ID = JV.EntityId 
	WHERE  
	 YEAR(JV.VoucherDate)=@ANO AND 
	 MONTH(JV.VoucherDate)=@MES AND 
	 JV.LegalBookId = 1 AND 
	 jv.EntityName ='BasicBilling' AND 
	 IdJournalVoucher = @TIPOFACTURABASICA AND BB.ThirdPartyEntityCopayId IS NULL
   GROUP BY JV.Id, JV.EntityCode,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.CreationUser ,JVT.Code,JVT.Description,JV.Consecutive
   --IN V4
   UNION ALL
    SELECT DISTINCT 
     JVT.Code 'CODIGO COMPROBANTE', 
	 'FACTURA COPAGO O CUOTA MODERADORA' AS 'COMPROBANTE CONTABLE',
	 JV.Consecutive 'CONSECUTIVO CONTABLE',
	 JV.EntityCode,
	 JV.EntityId,
	 jv.id,
	 CAST(JV.VoucherDate AS DATE) VoucherDate,
	 CAST(sum(JVD.CreditValue) AS NUMERIC) Valor_Credito,
	 JV.CreationUser
	FROM 
	 GeneralLedger.JournalVouchers JV WITH (NOLOCK)
	 INNER JOIN GeneralLedger.JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
	 INNER JOIN GeneralLedger.JournalVoucherTypes AS JVT WITH (NOLOCK) ON JVT.Id =JV.IdJournalVoucher
	 INNER JOIN Billing.BasicBilling AS BB WITH (NOLOCK) ON BB.ID = JV.EntityId 
	WHERE  
	 YEAR(JV.VoucherDate) = @ANO AND 
	 MONTH(JV.VoucherDate)=@MES AND 
	 JV.LegalBookId = 1 AND 
	 jv.EntityName ='BasicBilling' AND 
	 IdJournalVoucher = @TIPOFACTURABASICA AND BB.ThirdPartyEntityCopayId IS NOT NULL
   GROUP BY JV.Id, JV.EntityCode,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.CreationUser ,JVT.Code,JVT.Description,JV.Consecutive
   --FN V4
   
   ;

----------------------------------SE INSERTAN LOS DATOS CON FACTURA Y ALTA MEDICA------------------------------------------
   INSERT INTO @TBL_ALTA_MEDICA_FACTURADOS
	SELECT 
	 EGR.NUMINGRES 'INGRESO',
	 EGR.IPCODPACI 'IDENTIFICACION',
	 EGR.FECALTPAC 'FECHA ALTA MEDICA'  
	FROM 
	 HCREGEGRE EGR WITH (NOLOCK)
	 INNER JOIN (SELECT EGR.NUMINGRES 'INGRESO' ,EGR.IPCODPACI 'IDENTIFICACION' ,MAX(EGR.FECALTPAC) 'FECHA ALTA MEDICA' 
	             FROM DBO.HCREGEGRE EGR WITH (NOLOCK) INNER JOIN @TBL_FACTURADOS_UNICOS AS ING  ON EGR.NUMINGRES=ING.AdmissionNumber 
				 GROUP BY EGR.NUMINGRES,EGR.IPCODPACI)  AS G ON G.INGRESO=EGR.NUMINGRES AND G.[FECHA ALTA MEDICA]=EGR.FECALTPAC;

/********************************************************************************************************************
----------------------------SE INSERTAN LOS DATOS DE LAS CONSULTAS PRINCIPALES-------------------------------------
*********************************************************************************************************************/

--------------------------------1 SE INSERTAN TODOS LOS SERVICIOS CON ESTADO FACTURADO----------------------------------------------
 INSERT INTO @TBL_BILLING
  SELECT 
   CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
   'FACTURA SALUD' [TIPO DOCUMENTO],
   UNI.[CODIGO COMPROBANTE],
   UNI.[COMPROBANTE CONTABLE],
   UNI.[CONSECUTIVO CONTABLE],
   ISNULL(ids.Id ,sod.Id) IDDETALLE,
   'FACTURADO' AS ESTADO,
   YEAR(UNI.VoucherDate) AS AÑO,
   MONTH(UNI.VoucherDate) AS MES, 
   DAY(UNI.VoucherDate) AS DIA,
   TP.Nit AS NIT,
   TP.Name AS ENTIDAD,
   CG.Code AS [CODIGO GRUPO ATENCION],
   CG.Name AS [GRUPO ATENCION],
   I.PatientCode AS IDENTIFICACION,
   RTRIM(PAC.IPNOMCOMP) AS PACIENTE,
   I.AdmissionNumber AS INGRESO,
   CAST(ING.IFECHAING AS DATE) AS [FECHA INGRESO],
   CASE WHEN ING.TIPOINGRE =1 THEN CAST(ING.IFECHAING AS DATE)  ELSE  CAST(ALT.[FECHA ALTA MEDICA] AS DATE) END AS [FECHA EGRESO],
   I.InvoiceNumber AS [NRO FACTURA],
   CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA],
   I.TotalInvoice AS [TOTAL FACTURA],
   I.TotalPatientSalesPrice 'VALOR COPAGO/CUOTA FACTURA',------*****SE ADICIONO*******--------
   UNI.InvoiceNumber AS [NRO FACTURA COPAGO/CUOTA FACTURA],
   CASE SOD.RecordType WHEN 1 THEN 'SERVICIOS' 
 					   WHEN 2 THEN 'PRODUCTOS' END AS [TIPO REGISTRO],
   CASE CUPS.ServiceType WHEN 1 then 'Laboratorios'
					     WHEN 2 then 'Patologias'
					     WHEN 3 then 'Imagenes Diagnosticas'
					     WHEN 4 then 'Procedimeintos no Qx'
					     WHEN 5 then 'Procedimientos Qx'
					     WHEN 6 then 'Interconsultas'
					     WHEN 7 then 'Ninguno'
					     WHEN 8 then 'Consulta Externa' ELSE 'Otro' END AS [TIPO SERVICIO],
   CASE SOD.Presentation WHEN 1 THEN 'NO QUIRURGICO' 
					     WHEN 2 THEN 'QUIRURGICO'  
					     WHEN 3 THEN 'PAQUETE' ELSE 'NO QUIRURGICO' END AS PRESENTACION, 
   ISNULL (PG.Code, BCT.Code) 'CODIGO CONCEPTO/GRUPO',
   ISNULL (PG.Name, BCT.Name) 'NOMBRE CONCEPTO/GRUPO',
   ICT.Name 'CATERGORIA FACTURA', 
   SOD.ServiceDate  AS [FECHA SERVICIO], 
   ISNULL(CUPS.Code,IPR.Code) AS [CUPS/PRODUCTO],
   ISNULL(CUPS.Description,IPR.Description ) AS DESCRIPCION, 
   ISNULL(IPS.Code, 'N/A') AS 'CODIGO DETALLE QX', SUBSTRING(ISNULL(RTRIM(IPS.Name), 'N/A'),1,60) AS 'DESCRIPCION DETALLE QX', 
   CD.Name 'DECRIPCION RELACIONADA',ISNULL(IDS.InvoicedQuantity,ID.InvoicedQuantity) 'CANTIDAD',
   ISNULL(IDS.RateManualSalePrice,SOD.RateManualSalePrice) 'VALOR SERVICIO',SOD.CostValue 'COSTO SERVICIO',
   ISNULL(IDS.RateManualSalePrice,ID.TotalSalesPrice) 'VALOR UNITARIO',
   '' 'TARIFA IVA', 
   0 'VALOR IVA',
   ID.SubTotalPatientSalesPrice 'VALOR COPAGO/CUOTA', ------*****SE ADICIONO*******--------
   ISNULL(IDS.TotalSalesPrice,ID.GrandTotalSalesPrice+Id.ThirdPartyDiscount) 'VALOR TOTAL',
   CASE SOD.IsPackage WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'ES PAQUETE',CASE SOD.Packaging WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'INCLUIDO EN PAQUETE',
   CUPSP.Code 'CODIGO PAQUETE',CUPSP.Description 'NOMBRE PAQUETE',CASE SOD.SettlementType WHEN 1 THEN 'Por manual de tarifas' WHEN 2 THEN '% otro servicio cargado' 
   WHEN 3 THEN '100% incluido en otro servicio (No se cobra)' when 4 then '% del mismo servicio' else 'otro' end 'TIPO LIQUIDACION', CUPSI.Code 'CUPS QUE INCLUYE',
   CUPSI.Description 'NOMBRE CUPS QUE INCLUYE', ISNULL(IDS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,ISNULL(TPT.Nit,SOD.PerformsHealthProfessionalCode))) 'IDENTIFICACION PROFESIONAL',
   RTRIM(ISNULL(MEDQX.NOMMEDICO,ISNULL(MED.NOMMEDICO,TPT.Name))) 'PROFESIONAL', ISNULL(ESPQX.DESESPECI,ESPMED.DESESPECI) 'ESPECIALIDAD',
   FU.Code 'CODIGO UNIDAD SOLICITO' ,FU.Name 'UNIDAD SOLICITO',
   COST.CODE 'CODIGO CC CONTABILIZO',
   COST.Name 'CENTRO COSTO CONTABILIZO',
   MA.Number 'NRO CUENTA CONTABILIZO',
   MA.Name 'CUENTA CONTABILIZO',NULL 'FECHA ANULACION',
   MFC.ContractName 'AGREMIACION',
   SU.NOMUSUARI 'USUARIO',
   ISNULL(SUSO.NOMUSUARI,'INDIGOBOT') 'USUARIO CREO ORDEN',
   CAST(SO.CreationDate AS DATE) 'FECHA ORDEN',
   '' [TIPO INGRESO],
   CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
 FROM Billing.Invoice AS I WITH (NOLOCK)
  INNER JOIN @TBL_FACTURADOS_UNICOS AS UNI ON UNI.EntityId =I.Id 
  INNER JOIN Billing.InvoiceDetail AS ID WITH (NOLOCK) ON ID.InvoiceId =I.Id 
  INNER JOIN Billing.ServiceOrderDetail AS SOD WITH (NOLOCK) ON SOD.Id =ID.ServiceOrderDetailId
  INNER JOIN Billing .ServiceOrder AS SO WITH (NOLOCK) ON SO.Id =SOD.ServiceOrderId 
  INNER JOIN Payroll.FunctionalUnit AS FU WITH (NOLOCK) ON FU.Id = SOD.PerformsFunctionalUnitId
  INNER JOIN Payroll.CostCenter AS COST WITH (NOLOCK) ON COST.Id =SOD.CostCenterId
  INNER JOIN dbo.ADINGRESO AS ING WITH (NOLOCK) ON ING.NUMINGRES =I.AdmissionNumber 
  INNER JOIN Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =I.ThirdPartyId 
  INNER JOIN Contract .CareGroup AS CG WITH (NOLOCK) ON CG.Id =I.CareGroupId 
  INNER JOIN dbo.INPACIENT AS PAC WITH (NOLOCK) ON PAC.IPCODPACI =I.PatientCode
  LEFT JOIN Contract.CUPSEntity AS CUPS WITH (NOLOCK) ON CUPS.Id = SOD.CUPSEntityId
  LEFT JOIN Billing.BillingConcept AS BCT WITH (NOLOCK) ON CUPS.BillingConceptId = BCT.Id
  LEFT JOIN Inventory.InventoryProduct AS IPR WITH (NOLOCK) ON IPR.Id = SOD.ProductId
  LEFT JOIN GeneralLedger.GeneralLedgerIVA GLI WITH (NOLOCK) ON GLI.Id = IPR.IVAId
  LEFT JOIN Inventory.ProductGroup PG WITH (NOLOCK) ON PG.Id = IPR.ProductGroupId
  LEFT JOIN Contract .CUPSEntityContractDescriptions AS DESCR WITH (NOLOCK) ON DESCR.Id  =SOD.CUPSEntityContractDescriptionId  AND SOD.CUPSEntityId=DESCR.CUPSEntityId 
  LEFT JOIN Contract .ContractDescriptions AS CD WITH (NOLOCK) ON CD.ID=DESCR.ContractDescriptionId
  LEFT JOIN Billing .ServiceOrderDetail AS SODP WITH (NOLOCK) ON SODP.Id =SOD.PackageServiceOrderDetailId 
  LEFT JOIN Contract.CUPSEntity AS CUPSP WITH (NOLOCK) ON CUPSP.Id = SODP.CUPSEntityId
  LEFT JOIN Billing .ServiceOrderDetail AS SODI WITH (NOLOCK) ON SODI.Id =SOD.IncludeServiceOrderDetailId 
  LEFT JOIN Contract.CUPSEntity AS CUPSI WITH (NOLOCK) ON CUPSI.Id = SODI.CUPSEntityId
  LEFT JOIN dbo.INPROFSAL AS MED WITH (NOLOCK) ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPMED WITH (NOLOCK) ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty 
  LEFT JOIN Common.ThirdParty AS TPT WITH (NOLOCK) ON TPT.Id =SOD.PerformsHealthProfessionalThirdPartyId 
  LEFT JOIN Billing .InvoiceDetailSurgical AS IDS WITH (NOLOCK) ON IDS.InvoiceDetailId =ID.Id AND IDS.OnlyMedicalFees = '0'
  LEFT JOIN Contract .IPSService AS IPS WITH (NOLOCK) ON IPS.Id =IDS.IPSServiceId 
  LEFT JOIN dbo.INPROFSAL AS MEDQX WITH (NOLOCK) ON MEDQX.CODPROSAL = IDS.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPQX WITH (NOLOCK) ON ESPQX.CODESPECI = MEDQX.CODESPEC1
  LEFT JOIN @TBL_ALTA_MEDICA_FACTURADOS AS ALT ON ALT.INGRESO =I.AdmissionNumber 
  LEFT JOIN GeneralLedger .MainAccounts AS MA WITH (NOLOCK) ON MA.Id =ISNULL(IDS.IncomeMainAccountId,SOD.IncomeMainAccountId)
  LEFT JOIN MedicalFees.HealthProfessionalContract HPC WITH (NOLOCK)  ON HPC.HealthProfessionalCode =  ISNULL(IDS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,TPT.Nit)) AND HPC.LiquidateDefault = 1
  LEFT JOIN MedicalFees.MedicalFeesContract MFC WITH (NOLOCK) ON MFC.Id = HPC.MedicalFeesContractId
  LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = i.InvoicedUser
  LEFT JOIN DBO.SEGusuaru SUSO WITH (NOLOCK) ON SUSO.CODUSUARI = SO.CreationUser 
  LEFT JOIN Billing.InvoiceCategories ICT WITH (NOLOCK)  ON ICT.Id = I.InvoiceCategoryId;

----------------------------------------------------2 ANULADOS----------------------------------------------------------------
  INSERT INTO @TBL_BILLING
   SELECT 
   CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
   'FACTURA SALUD ANULADAS' [TIPO DOCUMENTO],
   UNI.[CODIGO COMPROBANTE],
   UNI.[COMPROBANTE CONTABLE],
   UNI.[CONSECUTIVO CONTABLE],
   isnull(ids.Id ,sod.Id) IDDETALLE,
   'ANULADOS' AS 'ESTADO',
   YEAR(UNI.VoucherDate) 'AÑO',
   MONTH(UNI.VoucherDate) 'MES', 
   DAY(UNI.VoucherDate) 'DIA',
   TP.Nit 'NIT',TP.Name 'ENTIDAD',
   CG.Code 'CODIGO GRUPO ATENCION',
   CG.Name 'GRUPO ATENCION',I.PatientCode 'IDENTIFICACION',RTRIM(PAC.IPNOMCOMP) 'PACIENTE',I.AdmissionNumber 'INGRESO',CAST(ING.IFECHAING AS DATE) 'FECHA INGRESO',
   CASE WHEN ING.TIPOINGRE =1 THEN CAST(ING.IFECHAING AS DATE)  ELSE  CAST(ALT.[FECHA ALTA MEDICA] AS DATE) END  'FECHA EGRESO',
   I.InvoiceNumber 'NRO FACTURA',
   CAST(I.InvoiceDate AS DATE) 'FECHA FACTURA',
   I.TotalInvoice 'TOTAL FACTURA',
   I.TotalPatientSalesPrice 'VALOR COPAGO/CUOTA FACTURA',------*****SE ADICIONO*******--------
   NULL AS [NRO FACTURA COPAGO/CUOTA FACTURA],
   CASE SOD.RecordType WHEN 1 THEN 'SERVICIOS' WHEN 2 THEN 'PRODUCTOS' END 'TIPO REGISTRO',
   CASE CUPS.ServiceType WHEN 1 then 'Laboratorios'WHEN 2 then 'Patologias'WHEN 3 then 'Imagenes Diagnosticas'WHEN 4 then 'Procedimeintos no Qx'WHEN 5 then 'Procedimientos Qx'
   WHEN 6 then 'Interconsultas'WHEN 7 then 'Ninguno'WHEN 8 then 'Consulta Externa' ELSE 'Otro' end 'TIPO SERVICIO',
   CASE SOD.Presentation WHEN 1 THEN 'NO QUIRURGICO' WHEN 2 THEN 'QUIRURGICO' WHEN 3 THEN 'PAQUETE' ELSE 'NO QUIRURGICO' END 'PRESENTACION',
   ISNULL (PG.Code, BCT.Code) 'CODIGO CONCEPTO/GRUPO',
   ISNULL (PG.Name, BCT.Name) 'NOMBRE CONCEPTO/GRUPO',
   ICT.Name 'CATERGORIA FACTURA', 
   SOD.ServiceDate  AS 'FECHA SERVICIO',
   ISNULL(CUPS.Code,IPR.Code)'CUPS/PRODUCTO',ISNULL(CUPS.Description,IPR.Description )'DESCRIPCION',ISNULL(IPS.Code, 'N/A') AS 'CODIGO DETALLE QX', SUBSTRING(ISNULL(RTRIM(IPS.Name), 'N/A'),1,60) AS 'DESCRIPCION DETALLE QX', 
   CD.Name 'DECRIPCION RELACIONADA',(ISNULL(IDS.InvoicedQuantity,ID.InvoicedQuantity))*-1 'CANTIDAD',(ISNULL(IDS.RateManualSalePrice,SOD.RateManualSalePrice))*-1 'VALOR SERVICIO',SOD.CostValue*-1 'COSTO SERVICIO',
   (ISNULL(IDS.RateManualSalePrice,ID.TotalSalesPrice))*-1 'VALOR UNITARIO',
   '' 'TARIFA IVA',
   0 'VALOR IVA',
   ID.SubTotalPatientSalesPrice 'VALOR COPAGO/CUOTA', ------*****SE ADICIONO*******--------
   (ISNULL(IDS.TotalSalesPrice,ID.GrandTotalSalesPrice))*-1 'VALOR TOTAL',
   CASE SOD.IsPackage WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'ES PAQUETE',CASE SOD.Packaging WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'INCLUIDO EN PAQUETE',
   CUPSP.Code 'CODIGO PAQUETE',CUPSP.Description 'NOMBRE PAQUETE',CASE SOD.SettlementType WHEN 1 THEN 'Por manual de tarifas' WHEN 2 THEN '% otro servicio cargado' 
   WHEN 3 THEN '100% incluido en otro servicio (No se cobra)' when 4 then '% del mismo servicio' else 'otro' end 'TIPO LIQUIDACION', CUPSI.Code 'CUPS QUE INCLUYE',
   CUPSI.Description 'NOMBRE CUPS QUE INCLUYE', ISNULL(IDS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,TPT.Nit))'IDENTIFICACION PROFESIONAL',
   RTRIM(ISNULL(MEDQX.NOMMEDICO,ISNULL(MED.NOMMEDICO,TPT.Name))) 'PROFESIONAL',ISNULL(ESPQX.DESESPECI,ESPMED.DESESPECI) 'ESPECIALIDAD',
   FU.Code 'CODIGO UNIDAD SOLICITO' ,FU.Name 'UNIDAD SOLICITO',COST.CODE 'CODIGO CC CONTABILIZO',COST.Name 'CENTRO COSTO CONTABILIZO',MA.Number 'NRO CUENTA CONTABILIZO',
   MA.Name 'CUENTA CONTABILIZO',
   CAST(I.AnnulmentDate AS DATE) 'FECHA ANULACION',
   MFC.ContractName 'AGREMIACION',
   SU.NOMUSUARI 'USUARIO',
   ISNULL(SUSO.NOMUSUARI,'INDIGOBOT') 'USUARIO CREO ORDEN',
   CAST(SO.CreationDate AS DATE) 'FECHA ORDEN',
   '' [TIPO INGRESO],
    CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
  FROM Billing.Invoice AS I WITH (NOLOCK)
   INNER JOIN @TBL_ANULADOS_UNICOS AS UNI  ON UNI.EntityId =I.Id 
   INNER JOIN Billing .InvoiceDetail AS ID WITH (NOLOCK) ON ID.InvoiceId =I.Id 
   INNER JOIN Billing .ServiceOrderDetail AS SOD WITH (NOLOCK)  ON SOD.Id =ID.ServiceOrderDetailId
   INNER JOIN Billing .ServiceOrder AS SO WITH (NOLOCK) ON SO.Id =SOD.ServiceOrderId
   INNER JOIN Payroll.FunctionalUnit AS FU WITH (NOLOCK) ON FU.Id = SOD.PerformsFunctionalUnitId
   INNER JOIN Payroll.CostCenter AS COST WITH (NOLOCK) ON COST.Id =SOD.CostCenterId
   INNER JOIN DBO.ADINGRESO AS ING WITH (NOLOCK) ON ING.NUMINGRES =I.AdmissionNumber 
   INNER JOIN Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =I.ThirdPartyId 
   INNER JOIN Contract .CareGroup AS CG WITH (NOLOCK)  ON CG.Id =I.CareGroupId 
   INNER JOIN DBO.INPACIENT AS PAC WITH (NOLOCK) ON PAC.IPCODPACI =I.PatientCode
   LEFT JOIN Contract.CUPSEntity AS CUPS WITH (NOLOCK) ON CUPS.Id = SOD.CUPSEntityId
   LEFT JOIN Billing.BillingConcept AS BCT WITH (NOLOCK) ON CUPS.BillingConceptId = BCT.Id
   LEFT JOIN Inventory.InventoryProduct AS IPR WITH (NOLOCK) ON IPR.Id = SOD.ProductId
   LEFT JOIN GeneralLedger.GeneralLedgerIVA GLI WITH (NOLOCK) ON GLI.Id = IPR.IVAId
   LEFT JOIN Inventory.ProductGroup PG WITH (NOLOCK) ON PG.Id = IPR.ProductGroupId
   LEFT JOIN Contract .CUPSEntityContractDescriptions AS DESCR WITH (NOLOCK) ON DESCR.Id  =SOD.CUPSEntityContractDescriptionId  AND SOD.CUPSEntityId=DESCR.CUPSEntityId 
   LEFT JOIN Contract .ContractDescriptions AS CD WITH (NOLOCK) ON CD.ID=DESCR.ContractDescriptionId
   LEFT JOIN Billing .ServiceOrderDetail AS SODP WITH (NOLOCK) ON SODP.Id =SOD.PackageServiceOrderDetailId 
   LEFT JOIN Contract.CUPSEntity AS CUPSP WITH (NOLOCK) ON CUPSP.Id = SODP.CUPSEntityId
   LEFT JOIN Billing .ServiceOrderDetail AS SODI WITH (NOLOCK) ON SODI.Id =SOD.IncludeServiceOrderDetailId 
   LEFT JOIN Contract.CUPSEntity AS CUPSI WITH (NOLOCK) ON CUPSI.Id = SODI.CUPSEntityId
   LEFT JOIN dbo.INPROFSAL AS MED WITH (NOLOCK) ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
   LEFT JOIN dbo.INESPECIA AS ESPMED WITH (NOLOCK) ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty 
   LEFT JOIN Common.ThirdParty AS TPT WITH (NOLOCK) ON TPT.Id =SOD.PerformsHealthProfessionalThirdPartyId 
   LEFT JOIN Billing .InvoiceDetailSurgical AS IDS WITH (NOLOCK) ON IDS.InvoiceDetailId =ID.Id AND IDS.OnlyMedicalFees = '0'
   LEFT JOIN Contract .IPSService AS IPS WITH (NOLOCK)  ON IPS.Id =IDS.IPSServiceId 
   LEFT JOIN dbo.INPROFSAL AS MEDQX WITH (NOLOCK)  ON MEDQX.CODPROSAL = IDS.PerformsHealthProfessionalCode
   LEFT JOIN dbo.INESPECIA AS ESPQX WITH (NOLOCK) ON ESPQX.CODESPECI = MEDQX.CODESPEC1
   --LEFT JOIN @TBL_CONCEPTOS_FACTURACION AS CONQX  ON CONQX.ID_CON =ISNULL(IDS.BillingConceptId,ISNULL(DESCR.BillingConceptId,SOD.BillingConceptId))
   LEFT JOIN @TBL_ALTA_MEDICA_ANULADOS AS ALT  ON ALT.INGRESO =I.AdmissionNumber 
   LEFT JOIN GeneralLedger .MainAccounts AS MA WITH (NOLOCK) ON MA.Id =ISNULL(IDS.IncomeMainAccountId,SOD.IncomeMainAccountId)
   LEFT JOIN MedicalFees.HealthProfessionalContract HPC WITH (NOLOCK) ON HPC.HealthProfessionalCode =  ISNULL(IDS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,TPT.Nit)) AND HPC.LiquidateDefault = 1
   LEFT JOIN MedicalFees.MedicalFeesContract MFC WITH (NOLOCK) ON MFC.Id = HPC.MedicalFeesContractId
   LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = i.InvoicedUser
   LEFT JOIN DBO.SEGusuaru SUSO WITH (NOLOCK) ON SUSO.CODUSUARI = SO.CreationUser 
   LEFT JOIN Billing.InvoiceCategories ICT WITH (NOLOCK)  ON ICT.Id = I.InvoiceCategoryId;
   
-----------------------3 FACTURACION CAPITADA -----------------------------------------------------------------------

 INSERT INTO @TBL_BILLING
  SELECT 
	CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
	'FACTURA SALUD PGP' [TIPO DOCUMENTO],
	UNI.[CODIGO COMPROBANTE],
    UNI.[COMPROBANTE CONTABLE],
	UNI.[CONSECUTIVO CONTABLE],
	IEC.Id  IDDETALLE,
	'FACTURADO' AS ESTADO,
	YEAR(UNI.VoucherDate) AS AÑO,
	MONTH(UNI.VoucherDate) AS MES, 
	DAY(UNI.VoucherDate) AS DIA,
	TP.Nit AS NIT,
	TP.Name AS ENTIDAD,
	CG.Code AS [CODIGO GRUPO ATENCION],
	CG.Name AS [GRUPO ATENCION],
	'' AS IDENTIFICACION,
	'' AS PACIENTE,
	'' AS INGRESO,
	IEC.DocumentDate   AS [FECHA INGRESO],
	IEC.DocumentDate   AS [FECHA EGRESO],
	I.InvoiceNumber AS [NRO FACTURA],
	CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA],
	I.TotalInvoice AS [TOTAL FACTURA], 
	0 'VALOR COPAGO/CUOTA FACTURA',
	NULL AS [NRO FACTURA COPAGO/CUOTA FACTURA],
	'PGP - CAPITA' AS [TIPO REGISTRO],
	'PGP - CAPITA' AS [TIPO SERVICIO],
	'PGP - CAPITA' AS PRESENTACION, 
	'PGP - CAPITA' AS [CODIGO CONCEPTO/GRUPO],
	'PGP - CAPITA' AS [NOMBRE CONCEPTO/GRUPO],
	'PGP - CAPITA' AS [CATERGORIA FACTURA],
	IEC.DocumentDate  AS [FECHA SERVICIO], 
	'' AS [CUPS/PRODUCTO],
	'' AS DESCRIPCION, 
	'' AS 'CODIGO DETALLE QX', '' AS 'DESCRIPCION DETALLE QX', 
	'' 'DECRIPCION RELACIONADA','1' 'CANTIDAD',IEC.TotalValue 'VALOR SERVICIO',0 'COSTO SERVICIO',
	IEC.TotalValue  'VALOR UNITARIO',
	'' [TARIFA IVA],
	I.ValueTax [VALOR IVA],
	0 'VALOR COPAGO/CUOTA', ------*****SE ADICIONO*******--------
    IEC.TotalValue 'VALOR TOTAL',
	'' 'ES PAQUETE',
	'' 'INCLUIDO EN PAQUETE',
	'' 'CODIGO PAQUETE','' 'NOMBRE PAQUETE','PGP - CAPITA' 'TIPO LIQUIDACION', '' 'CUPS QUE INCLUYE',
	'' 'NOMBRE CUPS QUE INCLUYE', '' 'IDENTIFICACION PROFESIONAL',
	'' 'PROFESIONAL', '' 'ESPECIALIDAD',
	'' 'CODIGO UNIDAD SOLICITO' ,'' 'UNIDAD SOLICITO',
	'' 'CODIGO CC CONTABILIZO',
	'' 'CENTRO COSTO CONTABILIZO',
	UNI.Number 'NRO CUENTA CONTABILIZO',
	UNI.Name 'CUENTA CONTABILIZO',NULL 'FECHA ANULACION',
	'' 'AGREMIACION',
	SU.NOMUSUARI 'USUARIO',
	ISNULL(SUSO.NOMUSUARI,'INDIGOBOT') 'USUARIO CREO ORDEN',
	CAST(IEC.CreationDate AS DATE) 'FECHA ORDEN',
	'' [TIPO INGRESO],
    CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM 
 Billing.InvoiceEntityCapitated AS IEC WITH (NOLOCK)
 INNER JOIN @TBL_CAPITA_FACTURADA AS UNI ON UNI.EntityId =IEC.Id 
 INNER JOIN Billing.Invoice AS I WITH (NOLOCK) ON IEC.InvoiceId =I.Id 
 INNER JOIN Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =I.ThirdPartyId
 INNER JOIN Contract .CareGroup AS CG WITH (NOLOCK) ON CG.Id =I.CareGroupId
 LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = i.InvoicedUser
 LEFT JOIN DBO.SEGusuaru SUSO WITH (NOLOCK) ON SUSO.CODUSUARI = IEC.CreationUser;

----------------------------------------------------4 ANULADOS CAPITA----------------------------------------------------------------
 INSERT INTO @TBL_BILLING
  SELECT
   CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
   'FACTURA SALUD PGP ANULADAS' [TIPO DOCUMENTO],
   UNI.[CODIGO COMPROBANTE],
   UNI.[COMPROBANTE CONTABLE],
   UNI.[CONSECUTIVO CONTABLE],
   IEC.Id  IDDETALLE,
   'FACTURADO' AS ESTADO,
   YEAR(UNI.VoucherDate) AS AÑO,
   MONTH(UNI.VoucherDate) AS MES, 
   DAY(UNI.VoucherDate) AS DIA,
   TP.Nit AS NIT,
   TP.Name AS ENTIDAD,
   CG.Code AS [CODIGO GRUPO ATENCION],
   CG.Name AS [GRUPO ATENCION],
   '' AS IDENTIFICACION,
   '' AS PACIENTE,
   '' AS INGRESO,
   IEC.DocumentDate   AS [FECHA INGRESO],
   IEC.DocumentDate  AS [FECHA EGRESO],
   I.InvoiceNumber AS [NRO FACTURA],
   CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA],
   I.TotalInvoice*-1 AS [TOTAL FACTURA], 
   0 'VALOR COPAGO/CUOTA FACTURA', ------*****SE ADICIONO*******--------
   NULL AS [NRO FACTURA COPAGO/CUOTA FACTURA],
   'PGP - CAPITA' AS [TIPO REGISTRO],
   'PGP - CAPITA' AS [TIPO SERVICIO],
   'PGP - CAPITA' AS PRESENTACION,
   'PGP - CAPITA' AS [CODIGO CONCEPTO/GRUPO],
   'PGP - CAPITA' AS [NOMBRE CONCEPTO/GRUPO],
   'PGP - CAPITA' AS [CATERGORIA FACTURA],	
   IEC.DocumentDate AS [FECHA SERVICIO],
   '' AS [CUPS/PRODUCTO],
   '' AS DESCRIPCION, 
   '' AS 'CODIGO DETALLE QX', '' AS 'DESCRIPCION DETALLE QX', 
   '' 'DECRIPCION RELACIONADA','1' 'CANTIDAD',IEC.TotalValue*-1 'VALOR SERVICIO',0 'COSTO SERVICIO',
   IEC.TotalValue*-1  'VALOR UNITARIO',
   '' [TARIFA IVA],
	I.ValueTax [VALOR IVA],
	0 'VALOR COPAGO/CUOTA', ------*****SE ADICIONO*******--------
    IEC.TotalValue*-1 'VALOR TOTAL',
   '' 'ES PAQUETE',
   '' 'INCLUIDO EN PAQUETE',
   '' 'CODIGO PAQUETE','' 'NOMBRE PAQUETE','PGP - CAPITA' 'TIPO LIQUIDACION', '' 'CUPS QUE INCLUYE',
   '' 'NOMBRE CUPS QUE INCLUYE', '' 'IDENTIFICACION PROFESIONAL',
   '' 'PROFESIONAL', '' 'ESPECIALIDAD',
   '' 'CODIGO UNIDAD SOLICITO' ,'' 'UNIDAD SOLICITO',
   '' 'CODIGO CC CONTABILIZO',
   '' 'CENTRO COSTO CONTABILIZO',
   UNI.Number 'NRO CUENTA CONTABILIZO',
   UNI.Name 'CUENTA CONTABILIZO',NULL 'FECHA ANULACION',
   '' 'AGREMIACION',
   	SU.NOMUSUARI 'USUARIO',
	ISNULL(SUSO.NOMUSUARI,'INDIGOBOT') 'USUARIO CREO ORDEN',
	CAST(IEC.CreationDate AS DATE) 'FECHA ORDEN',
	'' [TIPO INGRESO],
     CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
 FROM 
  Billing.InvoiceEntityCapitated AS IEC WITH (NOLOCK)
  INNER JOIN @TBL_ANULADOS_UNICOS_CAPITA AS UNI  ON UNI.EntityId =IEC.Id 
  INNER JOIN Billing .Invoice AS I WITH (NOLOCK) ON IEC.InvoiceId =I.Id 
  INNER JOIN Common .ThirdParty AS TP WITH (NOLOCK)  ON TP.Id =I.ThirdPartyId
  INNER JOIN Contract .CareGroup AS CG WITH (NOLOCK) ON CG.Id =I.CareGroupId
  LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = i.InvoicedUser
  LEFT JOIN DBO.SEGusuaru SUSO WITH (NOLOCK) ON SUSO.CODUSUARI = IEC.CreationUser;


-----------------------5 RECONOCIMIENTO CONTABILIZADO-----------------------------------------------------------------------

 INSERT INTO @TBL_BILLING
  SELECT
   CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
   'RECONOCIMIENTO CONTABILIZADO' [TIPO DOCUMENTO],
   UNI.[CODIGO COMPROBANTE],
   UNI.[COMPROBANTE CONTABLE],
   UNI.[CONSECUTIVO CONTABLE],
   sod.Id IDDETALLE,
   'RECONOCIMIENTO' AS ESTADO,
   YEAR(UNI.VoucherDate) AS AÑO,
   MONTH(UNI.VoucherDate) AS MES, 
   DAY(UNI.VoucherDate) AS DIA,
   ISNULL(TP.Nit,'N/A') 'NIT',
   ISNULL(TP.Name, 'N/A') AS ENTIDAD,
   CG.Code AS [CODIGO GRUPO ATENCION],
   CG.Name AS [GRUPO ATENCION],
   PAC.IPCODPACI AS IDENTIFICACION,
   RTRIM(PAC.IPNOMCOMP) AS PACIENTE,
   ING.NUMINGRES AS INGRESO,
   CAST(ING.IFECHAING AS DATE) AS [FECHA INGRESO],
   G2.[FECHA ALTA MEDICA] 'FECHA EGRESO',
   'N/A' AS [NRO FACTURA],
   NULL AS [FECHA FACTURA],
   0 AS [TOTAL FACTURA], 
   0 'VALOR COPAGO/CUOTA FACTURA',------*****SE ADICIONO*******--------
   NULL AS [NRO FACTURA COPAGO/CUOTA FACTURA],
   CASE SOD.RecordType 
        WHEN 1 THEN 'SERVICIOS' 
		WHEN 2 THEN 'PRODUCTOS' END AS [TIPO REGISTRO],
   CASE CUPS.ServiceType 
        WHEN 1 then 'Laboratorios'
		WHEN 2 then 'Patologias'
		WHEN 3 then 'Imagenes Diagnosticas'
		WHEN 4 then 'Procedimeintos no Qx'
		WHEN 5 then 'Procedimientos Qx'
		WHEN 6 then 'Interconsultas'
		WHEN 7 then 'Ninguno'
		WHEN 8 then 'Consulta Externa' 
		ELSE 'Otro' END AS [TIPO SERVICIO],
   CASE SOD.Presentation 
        WHEN 1 THEN 'NO QUIRURGICO' 
		WHEN 2 THEN 'QUIRURGICO'  
		WHEN 3 THEN 'PAQUETE' 
		ELSE 'NO QUIRURGICO' END AS PRESENTACION,
   ISNULL (PG.Code, BCT.Code) 'CODIGO CONCEPTO/GRUPO',
   ISNULL (PG.Name, BCT.Name) 'NOMBRE CONCEPTO/GRUPO',
   'N/A' 'CATERGORIA FACTURA', 
   SOD.ServiceDate AS [FECHA SERVICIO],
   ISNULL(CUPS.Code,IPR.Code) AS [CUPS/PRODUCTO],
   ISNULL(CUPS.Description,IPR.Description ) AS DESCRIPCION, 
   '' 'CODIGO DETALLE QX',
   '' AS 'DESCRIPCION DETALLE QX',
   CD.Name 'DECRIPCION RELACIONADA',
   RRD.InvoicedQuantity 'CANTIDAD',
   RRD.RateManualSalePrice 'VALOR SERVICIO',
   SOD.CostValue 'COSTO SERVICIO', 
   SOD.TotalSalesPrice 'VALOR UNITARIO',
   GLI.Name 'TARIFA IVA', 
   SOD.TaxValue 'VALOR IVA',
   0 'VALOR COPAGO/CUOTA', ------*****SE ADICIONO*******--------
   cast(RRD.GrandTotalSalesPrice AS numeric) 'VALOR TOTAL',
   CASE SOD.IsPackage 
        WHEN 0 THEN 'NO' 
		WHEN 1 THEN 'SI' END 'ES PAQUETE',
   CASE SOD.Packaging 
        WHEN 0 THEN 'NO' 
		WHEN 1 THEN 'SI' END 'INCLUIDO EN PAQUETE',
   CUPSP.Code 'CODIGO PAQUETE',
   CUPSP.Description 'NOMBRE PAQUETE',	
   CASE SOD.SettlementType 
        WHEN 1 THEN 'Por manual de tarifas' 
		WHEN 2 THEN '% otro servicio cargado' 
		WHEN 3 THEN '100% incluido en otro servicio (No se cobra)' 
		when 4 then '% del mismo servicio' 
		else 'otro' end 'TIPO LIQUIDACION', 
   CUPSI.Code 'CUPS QUE INCLUYE',
   CUPSI.Description 'NOMBRE CUPS QUE INCLUYE',
   ISNULL(MED.CODPROSAL,ISNULL(TPT.Nit,SOD.PerformsHealthProfessionalCode))'IDENTIFICACION PROFESIONAL',
   RTRIM(ISNULL(MED.NOMMEDICO,TPT.Name)) 'PROFESIONAL',
   ESPMED.DESESPECI 'ESPECIALIDAD',
   FU.Code 'CODIGO UNIDAD SOLICITO',
   FU.Name 'UNIDAD SOLICITO',
   COST.CODE 'CODIGO CC CONTABILIZO',
   COST.Name 'CENTRO COSTO CONTABILIZO',
   MA.Number 'NRO CUENTA CONTABILIZO',
   MA.Name 'CUENTA CONTABILIZO',
   NULL 'FECHA ANULACION',
   MFC.ContractName 'AGREMIACION',
   SU.NOMUSUARI 'USUARIO',
   ISNULL(SUSO.NOMUSUARI,'INDIGOBOT') 'USUARIO CREO ORDEN',
   CAST(SO.CreationDate AS DATE) 'FECHA ORDEN',
   '' [TIPO INGRESO],
   CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
  FROM 
 Billing.RevenueRecognition AS RR WITH (NOLOCK)
   INNER JOIN @TBL_RECONOCIMIENTO_UNICOS AS UNI ON UNI.EntityId = RR.id
   INNER JOIN Billing.RevenueRecognitionDetail AS RRD WITH (NOLOCK) ON RRD.RevenueRecognitionId = RR.Id 
   INNER JOIN Contract.CareGroup AS CG WITH (NOLOCK) ON CG.Id =RR.CareGroupId 
   INNER JOIN Payroll.FunctionalUnit AS FU WITH (NOLOCK) ON FU.Id = RRD.PerformsFunctionalUnitId
   INNER JOIN Payroll.CostCenter AS COST WITH (NOLOCK) ON COST.Id =RRD.CostCenterId
/*IN V3*/LEFT JOIN Billing .RevenueControlDetail AS RCD WITH (NOLOCK) ON RCD.Id =RRD.RevenueControlDetailId --FN V3
   LEFT JOIN Contract .Contract AS CON WITH (NOLOCK)  ON CON.Id =CG.ContractId 
   LEFT JOIN Contract.HealthAdministrator AS HA WITH (NOLOCK) ON HA.Id =CON.HealthAdministratorId 
   LEFT JOIN Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =ISNULL(HA.ThirdPartyId,rcd.ThirdPartyId)
   LEFT JOIN Billing .ServiceOrderDetail AS SOD WITH (NOLOCK) ON SOD.Id =RRD.ServiceOrderDetailId 
   LEFT JOIN Billing .ServiceOrder AS SO WITH (NOLOCK) ON SO.Id =SOD.ServiceOrderId
   --IN V3 LEFT JOIN Billing .RevenueControlDetail AS RCD WITH (NOLOCK) ON RCD.Id =RRD.RevenueControlDetailId fn v3 
   LEFT JOIN Billing .RevenueControl AS RC WITH (NOLOCK) ON RC.Id =RCD.RevenueControlId
   LEFT JOIN DBO.ADINGRESO AS ING WITH (NOLOCK) ON ING.NUMINGRES =ISNULL(RRD.AdmissionNumber,ISNULL(SO.AdmissionNumber,RC.AdmissionNumber))
   LEFT JOIN DBO.INPACIENT AS PAC WITH (NOLOCK) ON PAC.IPCODPACI =ISNULL(ING.IPCODPACI,ISNULL(SO.PatientCode,RC.PatientCode))
   LEFT JOIN Contract.CUPSEntity AS CUPS WITH (NOLOCK) ON CUPS.Id = ISNULL(SOD.CUPSEntityId,RRD.CUPSEntityId)
   LEFT JOIN Inventory.InventoryProduct AS IPR WITH (NOLOCK) ON IPR.Id = ISNULL(SOD.ProductId,RRD.ProductId)
   LEFT JOIN Billing.BillingConcept AS BCT WITH (NOLOCK) ON CUPS.BillingConceptId = BCT.Id
   LEFT JOIN Inventory.ProductGroup PG WITH (NOLOCK) ON PG.Id = IPR.ProductGroupId
   LEFT JOIN GeneralLedger.GeneralLedgerIVA GLI WITH (NOLOCK) ON GLI.Id = IPR.IVAId
   LEFT JOIN Contract .CUPSEntityContractDescriptions AS DESCR WITH (NOLOCK) ON DESCR.Id  =SOD.CUPSEntityContractDescriptionId  AND SOD.CUPSEntityId=DESCR.CUPSEntityId 
   LEFT JOIN Contract .ContractDescriptions AS CD WITH (NOLOCK) ON CD.ID=DESCR.ContractDescriptionId
   LEFT JOIN Billing .ServiceOrderDetail AS SODP WITH (NOLOCK) ON SODP.Id =SOD.PackageServiceOrderDetailId 
   LEFT JOIN Contract.CUPSEntity AS CUPSP WITH (NOLOCK) ON CUPSP.Id = ISNULL(SODP.CUPSEntityId,RRD.CUPSEntityId)
   LEFT JOIN Billing .ServiceOrderDetail AS SODI WITH (NOLOCK) ON SODI.Id =SOD.IncludeServiceOrderDetailId 
   LEFT JOIN Contract.CUPSEntity AS CUPSI WITH (NOLOCK) ON CUPSI.Id = ISNULL(SODI.CUPSEntityId,RRD.CUPSEntityId)
   LEFT JOIN dbo.INPROFSAL AS MED WITH (NOLOCK) ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
   LEFT JOIN dbo.INESPECIA AS ESPMED WITH (NOLOCK) ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty 
   LEFT JOIN Common.ThirdParty AS TPT WITH (NOLOCK) ON TPT.Id =SOD.PerformsHealthProfessionalThirdPartyId 
   LEFT JOIN GeneralLedger .MainAccounts AS MA WITH (NOLOCK) ON MA.Id =RRD.IncomeRecognitionMainAccountId 
   LEFT JOIN MedicalFees.HealthProfessionalContract HPC WITH (NOLOCK) ON HPC.HealthProfessionalCode =  ISNULL(MED.CODPROSAL,ISNULL(TPT.Nit,SOD.PerformsHealthProfessionalCode)) AND HPC.LiquidateDefault = 1
   LEFT JOIN MedicalFees.MedicalFeesContract MFC WITH (NOLOCK) ON MFC.Id = HPC.MedicalFeesContractId
   LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = ING.CODUSUCRE
   LEFT JOIN DBO.SEGusuaru SUSO WITH (NOLOCK) ON SUSO.CODUSUARI = SO.CreationUser
   LEFT JOIN @TBL_ALTA_MEDICA_FACTURADOS AS G2 ON G2.INGRESO =ING.NUMINGRES

 
-------------------------------------------------------- 6 NO FACTURABLES---------------------------------------------------------------
 INSERT INTO @TBL_BILLING
  SELECT 
   CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
   'REGISTROS DE SERVICIOS' [TIPO DOCUMENTO],
   '' [CODIGO COMPROBANTE],
   '' [COMPROBANTE CONTABLE],
   '' [CONSECUTIVO CONTABLE],
   ISNULL(ids.Id ,sod.Id) IDDETALLE,
   'FACTURADO' AS ESTADO,
   YEAR(UNI.InvoicedDate) AS AÑO,
   MONTH(UNI.InvoicedDate) AS MES, 
   DAY(UNI.InvoicedDate) AS DIA,
   TP.Nit AS NIT,
   TP.Name AS ENTIDAD,
   CG.Code AS [CODIGO GRUPO ATENCION],
   CG.Name AS [GRUPO ATENCION],
   I.PatientCode AS IDENTIFICACION,
   RTRIM(PAC.IPNOMCOMP) AS PACIENTE,
   I.AdmissionNumber AS INGRESO,
   CAST(ING.IFECHAING AS DATE) AS [FECHA INGRESO],
   CASE WHEN ING.TIPOINGRE =1 THEN CAST(ING.IFECHAING AS DATE)  ELSE  CAST(ALT.[FECHA ALTA MEDICA] AS DATE) END AS [FECHA EGRESO],
   I.InvoiceNumber AS [NRO FACTURA],
   CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA],
   I.TotalInvoice AS [TOTAL FACTURA], 
   I.TotalPatientSalesPrice 'VALOR COPAGO/CUOTA FACTURA',------*****SE ADICIONO*******--------
   NULL AS [NRO FACTURA COPAGO/CUOTA FACTURA],
   CASE SOD.RecordType WHEN 1 THEN 'SERVICIOS' 
					   WHEN 2 THEN 'PRODUCTOS' END AS [TIPO REGISTRO],
   CASE CUPS.ServiceType WHEN 1 then 'Laboratorios'
					     WHEN 2 then 'Patologias'
					     WHEN 3 then 'Imagenes Diagnosticas'
					     WHEN 4 then 'Procedimeintos no Qx'
					     WHEN 5 then 'Procedimientos Qx'
					     WHEN 6 then 'Interconsultas'
					     WHEN 7 then 'Ninguno'
					     WHEN 8 then 'Consulta Externa' ELSE 'Otro' END AS [TIPO SERVICIO],
   CASE SOD.Presentation WHEN 1 THEN 'NO QUIRURGICO' 
					     WHEN 2 THEN 'QUIRURGICO'  
					     WHEN 3 THEN 'PAQUETE' ELSE 'NO QUIRURGICO' END AS PRESENTACION, 
   ISNULL (PG.Code, BCT.Code) 'CODIGO CONCEPTO/GRUPO',
   ISNULL (PG.Name, BCT.Name) 'NOMBRE CONCEPTO/GRUPO',
   ICT.Name 'CATERGORIA FACTURA', 
   SOD.ServiceDate  AS [FECHA SERVICIO],
   ISNULL(CUPS.Code,IPR.Code) AS [CUPS/PRODUCTO],
   ISNULL(CUPS.Description,IPR.Description ) AS DESCRIPCION, 
   ISNULL(IPS.Code, 'N/A') AS 'CODIGO DETALLE QX', SUBSTRING(ISNULL(RTRIM(IPS.Name), 'N/A'),1,60) AS 'DESCRIPCION DETALLE QX', 
   CD.Name 'DECRIPCION RELACIONADA',ISNULL(IDS.InvoicedQuantity,ID.InvoicedQuantity) 'CANTIDAD',
   ISNULL(IDS.RateManualSalePrice,SOD.RateManualSalePrice) 'VALOR SERVICIO',SOD.CostValue 'COSTO SERVICIO',
   ISNULL(IDS.RateManualSalePrice,ID.TotalSalesPrice) 'VALOR UNITARIO',
   GLI.Name 'TARIFA IVA',
   SOD.TaxValue 'VALOR IVA',
   ID.SubTotalPatientSalesPrice 'VALOR COPAGO/CUOTA', ------*****SE ADICIONO*******--------
   ISNULL(IDS.TotalSalesPrice,ID.GrandTotalSalesPrice+Id.ThirdPartyDiscount) 'VALOR TOTAL',
   CASE SOD.IsPackage WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'ES PAQUETE',CASE SOD.Packaging WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END 'INCLUIDO EN PAQUETE',
   CUPSP.Code 'CODIGO PAQUETE',CUPSP.Description 'NOMBRE PAQUETE',CASE SOD.SettlementType WHEN 1 THEN 'Por manual de tarifas' WHEN 2 THEN '% otro servicio cargado' 
   WHEN 3 THEN '100% incluido en otro servicio (No se cobra)' when 4 then '% del mismo servicio' else 'otro' end 'TIPO LIQUIDACION', CUPSI.Code 'CUPS QUE INCLUYE',
   CUPSI.Description 'NOMBRE CUPS QUE INCLUYE', ISNULL(IDS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,ISNULL(TPT.Nit,SOD.PerformsHealthProfessionalCode))) 'IDENTIFICACION PROFESIONAL',
   RTRIM(ISNULL(MEDQX.NOMMEDICO,ISNULL(MED.NOMMEDICO,TPT.Name))) 'PROFESIONAL', ISNULL(ESPQX.DESESPECI,ESPMED.DESESPECI) 'ESPECIALIDAD',
   FU.Code 'CODIGO UNIDAD SOLICITO' ,FU.Name 'UNIDAD SOLICITO',
   COST.CODE 'CODIGO CC CONTABILIZO',
   COST.Name 'CENTRO COSTO CONTABILIZO',
   MA.Number 'NRO CUENTA CONTABILIZO',
   MA.Name 'CUENTA CONTABILIZO',NULL 'FECHA ANULACION',
   MFC.ContractName 'AGREMIACION',
   SU.NOMUSUARI 'USUARIO',
   ISNULL(SUSO.NOMUSUARI,'INDIGOBOT') 'USUARIO CREO ORDEN',
   CAST(SO.CreationDate AS DATE) 'FECHA ORDEN',
   '' [TIPO INGRESO],
   CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
 FROM 
  Billing.Invoice AS I WITH (NOLOCK)
  INNER JOIN @TBL_NO_FACTURABLES_UNICOS AS UNI ON UNI.ID =I.Id 
  INNER JOIN Billing.InvoiceDetail AS ID WITH (NOLOCK) ON ID.InvoiceId =I.Id 
  INNER JOIN Billing.ServiceOrderDetail AS SOD WITH (NOLOCK) ON SOD.Id =ID.ServiceOrderDetailId
  INNER JOIN Billing .ServiceOrder AS SO WITH (NOLOCK) ON SO.Id =SOD.ServiceOrderId 
  INNER JOIN Payroll.FunctionalUnit AS FU WITH (NOLOCK) ON FU.Id = SOD.PerformsFunctionalUnitId
  INNER JOIN Payroll.CostCenter AS COST WITH (NOLOCK) ON COST.Id =SOD.CostCenterId
  INNER JOIN dbo.ADINGRESO AS ING  ON ING.NUMINGRES =I.AdmissionNumber 
  INNER JOIN Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =I.ThirdPartyId 
  INNER JOIN Contract .CareGroup AS CG WITH (NOLOCK) ON CG.Id =I.CareGroupId 
  INNER JOIN dbo.INPACIENT AS PAC WITH (NOLOCK) ON PAC.IPCODPACI =I.PatientCode
  LEFT JOIN Contract.CUPSEntity AS CUPS WITH (NOLOCK) ON CUPS.Id = SOD.CUPSEntityId
  LEFT JOIN Billing.BillingConcept AS BCT WITH (NOLOCK) ON CUPS.BillingConceptId = BCT.Id
  LEFT JOIN Inventory.InventoryProduct AS IPR WITH (NOLOCK) ON IPR.Id = SOD.ProductId
  LEFT JOIN GeneralLedger.GeneralLedgerIVA GLI WITH (NOLOCK) ON GLI.Id = IPR.IVAId
  LEFT JOIN Inventory.ProductGroup PG WITH (NOLOCK) ON PG.Id = IPR.ProductGroupId
  LEFT JOIN Contract .CUPSEntityContractDescriptions AS DESCR WITH (NOLOCK) ON DESCR.Id  =SOD.CUPSEntityContractDescriptionId  AND SOD.CUPSEntityId=DESCR.CUPSEntityId 
  LEFT JOIN Contract .ContractDescriptions AS CD WITH (NOLOCK) ON CD.ID=DESCR.ContractDescriptionId
  LEFT JOIN Billing .ServiceOrderDetail AS SODP WITH (NOLOCK) ON SODP.Id =SOD.PackageServiceOrderDetailId 
  LEFT JOIN Contract.CUPSEntity AS CUPSP WITH (NOLOCK) ON CUPSP.Id = SODP.CUPSEntityId
  LEFT JOIN Billing .ServiceOrderDetail AS SODI WITH (NOLOCK) ON SODI.Id =SOD.IncludeServiceOrderDetailId 
  LEFT JOIN Contract.CUPSEntity AS CUPSI WITH (NOLOCK) ON CUPSI.Id = SODI.CUPSEntityId
  LEFT JOIN dbo.INPROFSAL AS MED WITH (NOLOCK) ON MED.CODPROSAL = SOD.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPMED WITH (NOLOCK) ON ESPMED.CODESPECI = SOD.PerformsProfessionalSpecialty 
  LEFT JOIN Common.ThirdParty AS TPT WITH (NOLOCK) ON TPT.Id =SOD.PerformsHealthProfessionalThirdPartyId 
  LEFT JOIN Billing .InvoiceDetailSurgical AS IDS WITH (NOLOCK) ON IDS.InvoiceDetailId =ID.Id AND IDS.OnlyMedicalFees = '0'
  LEFT JOIN Contract .IPSService AS IPS WITH (NOLOCK)  ON IPS.Id =IDS.IPSServiceId 
  LEFT JOIN dbo.INPROFSAL AS MEDQX WITH (NOLOCK) ON MEDQX.CODPROSAL = IDS.PerformsHealthProfessionalCode
  LEFT JOIN dbo.INESPECIA AS ESPQX WITH (NOLOCK) ON ESPQX.CODESPECI = MEDQX.CODESPEC1
  LEFT JOIN @TBL_ALTA_MEDICA_FACTURADOS AS ALT ON ALT.INGRESO =I.AdmissionNumber 
  LEFT JOIN GeneralLedger .MainAccounts AS MA WITH (NOLOCK) ON MA.Id =ISNULL(IDS.IncomeMainAccountId,SOD.IncomeMainAccountId)
  LEFT JOIN MedicalFees.HealthProfessionalContract HPC WITH (NOLOCK)  ON HPC.HealthProfessionalCode =  ISNULL(IDS.PerformsHealthProfessionalCode,ISNULL(MED.CODPROSAL,TPT.Nit)) AND HPC.LiquidateDefault = 1
  LEFT JOIN MedicalFees.MedicalFeesContract MFC WITH (NOLOCK) ON MFC.Id = HPC.MedicalFeesContractId
  LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = i.InvoicedUser
  LEFT JOIN DBO.SEGusuaru SUSO WITH (NOLOCK) ON SUSO.CODUSUARI = SO.CreationUser
  LEFT JOIN Billing.InvoiceCategories ICT WITH (NOLOCK) ON ICT.Id = I.InvoiceCategoryId

-------------------------------------------------------- 7 FACTURA BASICA---------------------------------------------------------------
 INSERT INTO @TBL_BILLING
  SELECT
  CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
   'FACTURA NO SALUD' [TIPO DOCUMENTO],
   UNI.[CODIGO COMPROBANTE],
   UNI.[COMPROBANTE CONTABLE],
   UNI.[CONSECUTIVO CONTABLE],
   BBD.ID IDDETALLE,
   'FACTURADO' AS ESTADO,
   YEAR(UNI.VoucherDate) AS AÑO,
   MONTH(UNI.VoucherDate) AS MES, 
   DAY(UNI.VoucherDate) AS DIA,
   TP.Nit AS NIT,
   TP.Name AS ENTIDAD,
   '' AS [CODIGO GRUPO ATENCION],
   '' AS [GRUPO ATENCION],
   '' AS IDENTIFICACION,
   '' AS PACIENTE,
   '' AS INGRESO,
   NULL AS [FECHA INGRESO],
   NULL [FECHA EGRESO],
   I.InvoiceNumber AS [NRO FACTURA],
   CAST(I.InvoiceDate AS DATE) AS [FECHA FACTURA],
   I.TotalInvoice AS [TOTAL FACTURA], 
   I.TotalPatientSalesPrice 'VALOR COPAGO/CUOTA FACTURA',------*****SE ADICIONO*******--------
   NULL AS [NRO FACTURA COPAGO/CUOTA FACTURA],
   CASE BBD.DetailType WHEN 1 THEN 'PRODUCTOS' 
					   WHEN 2 THEN 'SERVICIOS' 
					   WHEN 3 THEN 'ACTIVOS FIJOS' 
					   WHEN 4 THEN 'PARTES DE ACTIVOS FIJOS' END AS [TIPO REGISTRO],
   CASE BBD.DetailType WHEN 1 THEN 'PRODUCTOS' 
					   WHEN 2 THEN 'SERVICIOS' 
					   WHEN 3 THEN 'ACTIVOS FIJOS' 
					   WHEN 4 THEN 'PARTES DE ACTIVOS FIJOS' END AS [TIPO SERVICIO],
   '' AS PRESENTACION, 
   BCT.Code  'CODIGO CONCEPTO/GRUPO',
   BCT.Name  'NOMBRE CONCEPTO/GRUPO',
   'FACTURACION BASICA' 'CATERGORIA FACTURA', 
   BB.DocumentDate AS [FECHA SERVICIO],
   '' AS [CUPS/PRODUCTO],
   '' AS DESCRIPCION, 
   '' 'CODIGO DETALLE QX', '' AS 'DESCRIPCION DETALLE QX', 
   '' 'DECRIPCION RELACIONADA',BBD.Quantity 'CANTIDAD',
   CAST(BBD.Price AS NUMERIC) 'VALOR SERVICIO',0 'COSTO SERVICIO',
   CAST(BBD.Price AS NUMERIC) 'VALOR UNITARIO',
   '' 'TARIFA IVA',
   BB.ValueIVA 'VALOR IVA',
   0 'VALOR COPAGO/CUOTA', ------*****SE ADICIONO*******--------
   CAST(BBD.Value AS numeric )+CAST(BB.ValueIVA AS NUMERIC) 'VALOR TOTAL',
   '' 'ES PAQUETE','' 'INCLUIDO EN PAQUETE',
   '' 'CODIGO PAQUETE','' 'NOMBRE PAQUETE','' 'TIPO LIQUIDACION', '' 'CUPS QUE INCLUYE',
   '' 'NOMBRE CUPS QUE INCLUYE', '' 'IDENTIFICACION PROFESIONAL',
   '' 'PROFESIONAL', '' 'ESPECIALIDAD',
   FU.Code 'CODIGO UNIDAD SOLICITO' ,FU.Name 'UNIDAD SOLICITO',
   '' 'CODIGO CC CONTABILIZO',
   '' 'CENTRO COSTO CONTABILIZO',
   '' 'NRO CUENTA CONTABILIZO',
   '' 'CUENTA CONTABILIZO',NULL 'FECHA ANULACION',
   '' 'AGREMIACION',
   SU.NOMUSUARI 'USUARIO',
   ISNULL(SUSO.NOMUSUARI,'INDIGOBOT') 'USUARIO CREO ORDEN',
   CAST(BB.CreationDate AS DATE) 'FECHA ORDEN',
   '' [TIPO INGRESO],
   CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
  FROM 
   Billing.BasicBilling AS BB WITH (NOLOCK)
   INNER JOIN @TBL_FACTURA_BASICA_UNICOS AS UNI  ON UNI.EntityId =BB.Id 
   INNER JOIN Billing.Invoice AS I WITH (NOLOCK)  ON I.Id =BB.InvoiceId
   INNER JOIN Billing.BasicBillingDetail BBD WITH (NOLOCK) ON BB.Id =BBD.BasicBillingId 
   INNER JOIN Common .ThirdParty AS TP WITH (NOLOCK) ON TP.Id =I.ThirdPartyId	
   INNER JOIN Payroll .FunctionalUnit AS FU WITH (NOLOCK) ON FU.Id =BBD.FunctionalUnitId 
   LEFT JOIN Billing.BillingConcept AS BCT WITH (NOLOCK) ON BBD.BillingConceptId  = BCT.Id
   LEFT JOIN DBO.SEGusuaru SU WITH (NOLOCK) ON SU.CODUSUARI = i.InvoicedUser
   LEFT JOIN DBO.SEGusuaru SUSO WITH (NOLOCK) ON SUSO.CODUSUARI = BB.CreationUser

-------------------------------------------------------- PRESENTACION DE DATOS CONSOLIDADOS---------------------------------------------------------------
select * from @TBL_BILLING
