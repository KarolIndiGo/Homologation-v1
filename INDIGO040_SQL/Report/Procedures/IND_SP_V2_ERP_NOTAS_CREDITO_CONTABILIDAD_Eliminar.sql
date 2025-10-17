-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_NOTAS_CREDITO_CONTABILIDAD_Eliminar
-- Extracted by Fabric SQL Extractor SPN v3.9.0


/*******************************************************************************************************************
Nombre:[Report].[IND_SP_V2_ERP_NOTAS_CREDITO_CONTABILIDAD] 
Tipo:Procedimiento Almacenado
Observacion: 
Profesional: Ing. Andres Cabrera
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:10-01-2023
Observaciones: Por solicitud del hospital San Jose, se incluyeron las notas credito en el informe, esta soliciud se
			   realizo atraves de monica, y tambien se incluyen los campos de centro de costo 
--------------------------------------
Version 3
Persona que modifico: Nelly Patricia Morales Capera
Fecha: 24/01/2023
Observaciones: En caso que la naturaleza sea CREDITO el valor se presenta en negativo por solicitud de Monica.
-------------------------------------------------
Version 4
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha: 29/01/2023
Observaciones:Se agregar el codgo y el nombre de la cuenta contable,ademas la observación se toma de la cabecera de la nota y no del detalle
			  esto provocaba se duplicaran
***********************************************************************************************************************************/

CREATE PROCEDURE [Report].[IND_SP_V2_ERP_NOTAS_CREDITO_CONTABILIDAD_Eliminar] 
@ANO AS INT,
@MES AS INT
AS

--DECLARE @ANO AS INT = 2023;
--DECLARE @MES AS INT = 12;

WITH CTE_NOTAS_CREDITO_UNICOS
AS
(
  SELECT DISTINCT  JV.Id ,JV.EntityCode,jv.Detail  ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,cast(sum(JVD.DebitValue) as numeric (20,2)) Valor_Debito,JV.CreationUser
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
  INNER JOIN GeneralLedger .MainAccounts AS MA WITH (NOLOCK) ON MA.Id =JVD.IdMainAccount
  INNER JOIN Portfolio.PortfolioNote AS PN WITH (NOLOCK) ON PN.ID=JV.EntityId AND PN.STATUS=2
  WHERE YEAR(JV.VoucherDate) = @ANO AND MONTH(JV.VoucherDate)=@MES AND JV.LegalBookId =1 AND jv.EntityName ='PortfolioNote' AND IdJournalVoucher =10
  --AND PN.CODE='001979'
  --AND (MA.Number BETWEEN '41' AND '41999999') AND PN.CODE='001979'
  --and JV.EntityCode in ('HSJS47078')
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.CreationUser,jv.Detail
),

CTE_NOTAS_DEBITO_UNICOS
AS
(
  SELECT DISTINCT  JV.Id ,JV.EntityCode,jv.Detail  ,JV.EntityId,CAST(JV.VoucherDate AS DATE) VoucherDate,cast(sum(JVD.DebitValue) as numeric (20,2)) Valor_Debito,JV.CreationUser
  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
  INNER JOIN GeneralLedger .JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
  INNER JOIN GeneralLedger .MainAccounts AS MA WITH (NOLOCK) ON MA.Id =JVD.IdMainAccount
  INNER JOIN Portfolio.PortfolioNote AS PN WITH (NOLOCK) ON PN.ID=JV.EntityId AND PN.STATUS=2
  WHERE YEAR(JV.VoucherDate) = @ANO AND MONTH(JV.VoucherDate)=@MES AND JV.LegalBookId =1 AND jv.EntityName ='PortfolioNote' AND IdJournalVoucher =11
  --AND PN.CODE='001979'
  --AND (MA.Number BETWEEN '41' AND '41999999') AND PN.CODE='001979'
  --and JV.EntityCode in ('IND161039')
  GROUP BY JV.Id ,JV.EntityCode ,JV.EntityId,CAST(JV.VoucherDate AS DATE),JV.CreationUser,jv.Detail
)

SELECT CASE OpeningBalance WHEN 1 THEN 'SI' WHEN 0 THEN 'NO' END 'SALDO INICIAL',CAST(PN.NoteDate as DATE) 'FECHA NOTA',
UNI.EntityCode 'CODIGO NOTA',CASE PN.Nature WHEN 1 THEN 'DEBITO' WHEN 2 THEN 'CREDITO' END 'NATURALEZA',
AR.InvoiceNumber 'NRO FACTURA',CASE PND.Nature WHEN 1 THEN 'DEBITO' WHEN 2 THEN 'CREDITO' END 'NATURALEZA MOVIMIENTO',PNC.CODE 'CODIGO CONCEPTO NOTA', PNC.NAME 'NOMBRE CONCEPTO NOTA',
CAST(PND.Value AS NUMERIC(20,2)) 'VALOR CONCEPTO',PNARA.AdjusmentValue 'VALOR AJUSTE' ,MA.Number 'CUENTA',MA.Name 'DESCRIPCION CUENTA',CC.code 'CODIGO CENTRO COSTO', CC.NAME 'DESCRIPCION CENTRO COSTO',
PND.Observations 'OBSERVACIONES',USU.NOMUSUARI 'USUARIO CREA'
 FROM Portfolio.PortfolioNote AS PN
  INNER JOIN CTE_NOTAS_CREDITO_UNICOS AS UNI ON UNI.EntityId = PN.Id
  INNER JOIN Portfolio.PortfolioNoteDetail AS PND ON PND.PortfolioNoteId=PN.ID
  INNER JOIN Portfolio.PortfolioNoteAccountReceivableAdvance AS PNARA ON PNARA.PortfolioNoteId=PN.ID
  INNER JOIN Portfolio.AccountReceivable AS AR ON AR.Id=PNARA.AccountReceivableId
  INNER JOIN Portfolio.PortfolioNoteConcept AS PNC ON PNC.ID=PND.PortfolioNoteConceptId
  LEFT JOIN  dbo.SEGusuaru AS USU ON USU.CODUSUARI=PN.CreationUser
  LEFT JOIN  GeneralLedger.MainAccounts AS MA ON MA.Id=PND.MainAccountId
  LEFT JOIN  Payroll.CostCenter as CC on CC.id=PND.CostCenterId
 -- WHERE AR.InvoiceNumber='HSJS47078'
--  ORDER BY UNI.EntityCode 
   
UNION ALL

SELECT CASE OpeningBalance WHEN 1 THEN 'SI' WHEN 0 THEN 'NO' END 'SALDO INICIAL',CAST(PN.NoteDate as DATE) 'FECHA NOTA',
UNI.EntityCode 'CODIGO NOTA',CASE PN.Nature WHEN 1 THEN 'DEBITO' WHEN 2 THEN 'CREDITO' END 'NATURALEZA',
AR.InvoiceNumber 'NRO FACTURA',CASE PND.Nature WHEN 1 THEN 'DEBITO' WHEN 2 THEN 'CREDITO' END 'NATURALEZA MOVIMIENTO',PNC.CODE 'CODIGO CONCEPTO NOTA', PNC.NAME 'NOMBRE CONCEPTO NOTA',
CAST(PND.Value AS NUMERIC(20,2))*-1 'VALOR CONCEPTO',PNARA.AdjusmentValue*-1 'VALOR AJUSTE' ,MA.Number 'CUENTA',MA.Name 'DESCRIPCION CUENTA',CC.code 'CODIGO CENTRO COSTO', CC.NAME 'DESCRIPCION CENTRO COSTO',
PND.Observations 'OBSERVACIONES',USU.NOMUSUARI 'USUARIO CREA'
 FROM Portfolio.PortfolioNote AS PN
  INNER JOIN CTE_NOTAS_DEBITO_UNICOS AS UNI ON UNI.EntityId = PN.Id
  INNER JOIN Portfolio.PortfolioNoteDetail AS PND ON PND.PortfolioNoteId=PN.ID
  INNER JOIN Portfolio.PortfolioNoteAccountReceivableAdvance AS PNARA ON PNARA.PortfolioNoteId=PN.ID
  INNER JOIN Portfolio.AccountReceivable AS AR ON AR.Id=PNARA.AccountReceivableId
  INNER JOIN Portfolio.PortfolioNoteConcept AS PNC ON PNC.ID=PND.PortfolioNoteConceptId
  LEFT JOIN  dbo.SEGusuaru AS USU ON USU.CODUSUARI=PN.CreationUser
  LEFT JOIN  GeneralLedger.MainAccounts AS MA ON MA.Id=PND.MainAccountId
  LEFT JOIN  Payroll.CostCenter as CC on CC.id=PND.CostCenterId
 -- WHERE AR.InvoiceNumber='HSJS47078'
  ORDER BY UNI.EntityCode

--SELECT TOP(10)* FROM  Portfolio.PortfolioNote
--SELECT TOP(10)* FROM Portfolio.PortfolioNoteDetail
--SELECT TOP(10)* FROM Portfolio.PortfolioNoteAccountReceivableAdvance






-------******LOGICA ANTERIOR------
--WITH CTE_NOTAS_UNICOS
--AS
--(
--  SELECT  
--  JV.Id,
--  JV.EntityCode,
--  jv.Detail,
--  JV.EntityId,
--  CAST(JV.VoucherDate AS DATE) VoucherDate,
--  CAST(JVD.DebitValue AS NUMERIC(20,2)) AS [VALOR DEBITO],
--  -(CAST(JVD.CreditValue AS NUMERIC(20,2))) AS [VALOR CREDITO],
--  /*IN V2*/CEN.Code AS [CODIGO CENTRO DE COSTO],
--  CEN.Name AS [CENTRO DE COSTO],
--  PER.Fullname AS [USUARIO CREACIÓN], /* FN V2*/
--  MA.Number,
--  MA.Name
--  FROM GeneralLedger.JournalVouchers JV WITH (NOLOCK)
--  INNER JOIN GeneralLedger.JournalVoucherDetails AS JVD WITH (NOLOCK) ON JVD.IdAccounting =JV.Id
--  INNER JOIN GeneralLedger.MainAccounts AS MA WITH (NOLOCK) ON MA.Id =JVD.IdMainAccount
--  INNER JOIN Portfolio.PortfolioNote AS PN WITH (NOLOCK) ON PN.ID=JV.EntityId AND PN.STATUS=2
--  INNER JOIN Payroll.CostCenter CEN ON JVD.IdCostCenter=CEN.Id
--  INNER JOIN Security.[User] US ON JV.CreationUser=US.UserCode
--  INNER JOIN Security.Person PER ON US.IdPerson=PER.Id
--  WHERE YEAR(JV.VoucherDate) = @ANO AND MONTH(JV.VoucherDate)=@MES AND JV.LegalBookId =1 AND jv.EntityName ='PortfolioNote' AND /*IN V2 IdJournalVoucher = 10*/ IdJournalVoucher in (10,11) /*FN V2*/
--  --AND PN.CODE='004030'
--  --AND (MA.Number BETWEEN '41' AND '41999999') AND PN.CODE='001979'
--  --and JV.EntityCode in ('IND161039')


--  --select * from GeneralLedger.JournalVoucherTypes where id=10
--)

--SELECT
--CASE OpeningBalance WHEN 1 THEN 'SI' WHEN 0 THEN 'NO' END 'SALDO INICIAL',UNI.EntityCode 'CODIGO NOTA',
--CASE PN.Nature WHEN 1 THEN 'DEBITO' 
--			   WHEN 2 THEN 'CREDITO' END 'NATURALEZA',
--AR.InvoiceNumber 'NRO FACTURA',
--CASE PN.NoteType WHEN 1 THEN 'Factura Total'
--				 WHEN 2 THEN 'Factura Cuota'
--				 WHEN 3 THEN 'Anticipo'
--				 WHEN 4 THEN 'Distribucion de Anticipo' ELSE CONVERT(VARCHAR,PN.NoteType) END AS [TIPO DE NOTA],
--CASE PND.Nature WHEN 1 THEN 'DEBITO' 
--				WHEN 2 THEN 'CREDITO' END 'NATURALEZA MOVIMIENTO',
--PN.CODE,
--UNI.NUMBER AS [CODIGO CUENTA CONTABLE],
--UNI.NAME AS [CUENTA CONTABLE],
----CASE PND.Nature WHEN 1 THEN SUM(CAST(PNARA.AdjusmentValue AS NUMERIC(20,2)))  
----				WHEN 2 THEN SUM(CAST(PNARA.AdjusmentValue AS NUMERIC(20,2)))*-1 END 'VALOR AJUSTADO', 
--UNI.[VALOR CREDITO],
--UNI.[VALOR DEBITO],
--PNC.CODE 'CODIGO CONCEPTO NOTA', 
--PNC.NAME 'NOMBRE CONCEPTO NOTA',
--PN.Observations AS OBSERVACIONES,
--CASE AR.AccountReceivableType WHEN 2 THEN 'Facturación Salud' ELSE 'Facturación No Salud' END AS [TIPO CUENTA POR COBRAR],
--UNI.[CODIGO CENTRO DE COSTO],UNI.[CENTRO DE COSTO],UNI.[USUARIO CREACIÓN],CAST(AR.AccountReceivableDate AS DATE) AS 'FECHA FACTURA'
-- FROM Portfolio.PortfolioNote AS PN
--  INNER JOIN CTE_NOTAS_UNICOS AS UNI ON UNI.EntityId = PN.Id
--  INNER JOIN Portfolio.PortfolioNoteDetail AS PND ON PND.PortfolioNoteId=PN.ID
--  INNER JOIN Portfolio.PortfolioNoteAccountReceivableAdvance AS PNARA ON PNARA.PortfolioNoteId=PN.ID
--  INNER JOIN Portfolio.AccountReceivable AS AR ON AR.Id=PNARA.AccountReceivableId
--  INNER JOIN Portfolio.PortfolioNoteConcept AS PNC ON PNC.ID=PND.PortfolioNoteConceptId
--  --WHERE AR.AccountReceivableType=2 --PN.CODE='000393'
--  GROUP BY 
--  OpeningBalance,UNI.EntityCode,PN.Nature,AR.InvoiceNumber,PND.Nature,PN.CODE,PNC.CODE, PNC.NAME,PN.Observations,
--  UNI.[CODIGO CENTRO DE COSTO],UNI.[CENTRO DE COSTO],UNI.[USUARIO CREACIÓN],CAST(AR.AccountReceivableDate AS DATE),UNI.NUMBER,UNI.NAME,
--  AR.AccountReceivableType,PN.NoteType,UNI.[VALOR CREDITO],UNI.[VALOR DEBITO]

