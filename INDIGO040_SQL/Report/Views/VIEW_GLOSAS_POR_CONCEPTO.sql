-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: VIEW_GLOSAS_POR_CONCEPTO
-- Extracted by Fabric SQL Extractor SPN v3.9.0



/*******************************************************************************************************************
Nombre: [Report].[VIEW_GLOSAS_POR_CONCEPTO]
Tipo:Vista
Observacion:
Profesional:
Fecha:
---------------------------------------------------------------------------
Modificaciones
__________________________________________________________________________________________________________________________________________________________________
Version 2
Persona que modifico: Amira Gil Meneses
Fecha: 23-11-2023
Observaciones: Se agrega el campo de Régimen, el estado (State=2) Confirmado para la fecha de conciliación
--------------------------------------------------------------------------------------------
Version 3
Persona que modifico: Nilsson Miguel Galindo Lopez
Fecha:28-02-2024
Observaciones: Se agrega en la condicion de la tabla Portfolio.AccountReceivable para que no traiga en la columna
			  AccountReceivableType el tipo 4, con esto se exonera los pagares ya que no lo paga una instucion.
			  Esto solicitado en el ticket 15484
--------------------------------------------------------------------------------------------
***********************************************************************************************/

CREATE VIEW [Report].[VIEW_GLOSAS_POR_CONCEPTO] AS
SELECT  
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
DG.InvoiceNumber AS 'NRO FACTURA', 
CAST(G.InvoiceDate AS DATE) AS 'FECHA FACTURA',
G.InvoiceValueEntity AS 'VALOR FACTURA',
CAR.Balance AS 'SALDO CARTERA' ,
C.Nit 'NIT', 
C.Name AS 'ENTIDAD',
CASE WHEN HA.EntityType LIKE '1' THEN 'EPS CONTRIBUTIVO' 
WHEN HA.EntityType LIKE '2' THEN 'EPS SUBSIDIADO' 
WHEN HA.EntityType LIKE '3' THEN 'ET VINCULADO MUNICIPIO'
WHEN HA.EntityType LIKE '4' THEN 'ET VINCULADOS DAPARTAMENTO' 
WHEN HA.EntityType LIKE '5' THEN 'ARL RIESGO LABORALES' 
WHEN HA.EntityType LIKE '6' THEN 'MP MEDICINA PREPAGADA'
WHEN HA.EntityType LIKE '7' THEN 'IPS PRIVADA' 
WHEN HA.EntityType LIKE '8' THEN 'IPS PUBLICA' 
WHEN HA.EntityType LIKE '9' THEN 'REGIMEN ESPECIAL'
WHEN HA.EntityType LIKE '10' THEN 'ACCIDENTE DE TRANSITO'
WHEN HA.EntityType LIKE '11' THEN 'FOSYGA' 
WHEN HA.EntityType LIKE '12' THEN 'OTROS' 
WHEN HA.EntityType IS NULL AND F.DOCUMENTTYPE LIKE '4' THEN 'N/A'
WHEN HA.EntityType IS NULL AND F.DOCUMENTTYPE LIKE '6' THEN 'N/A' END AS [TIPO REGIMEN],
CO.Code AS 'CODIGO CONCEPTO',  
CO.NameGeneral AS 'GENERAL', 
CO.NameSpecific AS 'ESPECIFICO', 
DG.RationaleGlosa AS 'COMENTARIO',
CASE WHEN DE.TypeServiceProduct = '1' THEN 'Servicio'  
     WHEN DE.TypeServiceProduct = '2' THEN 'Medicamento o Insumo' 
     END AS 'TIPO TECNOLOGIA', 
CASE WHEN DE.TypeProcedure = '1' THEN 'No quirurgico' 
     WHEN DE.TypeProcedure = '2' THEN 'Quirurgico' 
	 WHEN DE.TypeProcedure = '3' THEN 'Paquete'  
	 WHEN DE.TypeProcedure = '4' THEN 'NoAplica' 
	 END AS 'TIPO CUPS',
DE.ServiceCode AS 'CODIGO SERVICIO',  
DE.ServiceName AS 'SERVICIO',  
DE.UnitValue AS 'VALOR UNITARIO',
DE.Ammount AS 'CANTIDAD',
DG.ValueGlosado AS 'VALOR GLOSADO',
DE.MedicalCode AS 'IDENTIFICACION PROFESIONAL ORDENO',  
DE.MedicalName AS 'PROFESIONAL ORDENO',  
G.UserNameInvoice AS 'IDENTIFICACION FACTURADOR',
PER.Fullname 'FACTURADOR',
G.RadicatedNumber AS 'NRO RADICADO', 
CAST(G.RadicatedDate AS DATE) AS 'FECHA RADICADO',
GC.RadicatedConsecutive   'NRO RECEPCION OBJECION'  ,
CAST(GC.RadicatedDate AS DATE) 'FECHA RECEPCION OBJECION',  
CAST(GC.DocumentDate AS DATE) AS 'FECHA OFICIO RADICACION GLOSA',
CAST(con.FechaConciliacion AS DATE) 'FECHA CONCILIACION',
DG.ValueAcceptedIPSconciliation AS 'VALOR ACEPTADO IPS', 
DG.ValueAcceptedEAPBconciliation AS 'VALOR ACEPTADO EAPB', 
DG.ValueAcceptedIPSconciliation + DG.ValueAcceptedEAPBconciliation AS 'VALOR CONCILIADO',
DG.ValuePendingConciliation AS 'VALOR PENDIENTE DE CONCILIACION', 
SUBSTRING(DG.JustificationGlosaText,0,3000) AS 'JUSTIFICACION GLOSA', 
CAT.Name AS 'CATEGORIA',
F.PatientCode AS 'IDENTIFICACION PACIENTE', 
p.IPNOMCOMP AS 'NOMBRE PACIENTE',
DE.CostCenterCode AS 'CENTRO DE COSTO', 
DE.CostCenterName AS 'NOMBRE CENTRO DE COSTO',
CEN.NOMCENATE AS 'CENTRO DE ATENCION',
CAST(GC.RadicatedDate AS date) AS 'FECHA BUSQUEDA',
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM Glosas.GlosaMovementGlosa AS DG
          INNER JOIN Glosas.GlosaPortfolioGlosada AS G
					INNER JOIN Glosas.GlosaObjectionsReceptionD AS RG 
							INNER JOIN Glosas.GlosaObjectionsReceptionC AS GC 
									 LEFT JOIN Common.Customer AS C 
											ON GC.CustomerId = C.Id
									  ON RG.GlosaObjectionsReceptionCId = GC.Id
							ON G.Id = RG.PortfolioGlosaId
                            AND RG.State <> '4'
		  ON DG.InvoiceNumber = G.InvoiceNumber
  LEFT JOIN Security .Person PER ON PER.Identification =G.UserNameInvoice 
  LEFT JOIN Common.ConceptGlosas AS CO ON DG.CodeGlosaId = CO.Id
  LEFT JOIN Glosas.GlosaInvoiceDetail AS DE ON DG.InvoiceDetailId = DE.Id
  LEFT JOIN Billing.Invoice AS F 
  LEFT JOIN Billing.InvoiceCategories AS CAT ON CAT.Id = F.InvoiceCategoryId
  LEFT JOIN Contract.CareGroup AS GA 
  LEFT JOIN Contract.Contract AS CONT ON CONT.Id = GA.ContractId	ON F.CareGroupId = GA.Id
  LEFT JOIN Portfolio.AccountReceivable AS CAR 
  LEFT OUTER JOIN Common.ThirdParty AS T ON T.Id = CAR.ThirdPartyId AND T.PersonType = '2' ON CAR.InvoiceNumber = F.InvoiceNumber AND CAR.AccountReceivableType NOT IN (/*in v3*/4/*fn v3*/,6) ON F.InvoiceNumber = DG.InvoiceNumber
  LEFT JOIN dbo.INPACIENT AS P ON P.ipcodpaci = F.PatientCode
  LEFT OUTER JOIN (SELECT max(c.id) as ID, D.InvoiceNumber as Factura, max(c.ConciliationDate) as FechaConciliacion
									FROM Glosas.ConciliationD as d
											inner join Glosas.ConciliationC as c on c.Id=d.ConciliationCId and c.State=2
											group by d.InvoiceNumber) as con on con.Factura=dg.InvoiceNumber
  LEFT JOIN DBO.ADINGRESO AS ING ON ING.NUMINGRES =G.IngressNumber 
  LEFT JOIN DBO.ADCENATEN AS CEN ON CEN.CODCENATE =ING.CODCENATE 
  LEFT JOIN Glosas .Responsible AS RES ON RES.Id =DG.ResponsibleId
  INNER JOIN Contract .HealthAdministrator AS HA ON HA.Id =F.HealthAdministratorId 
  --WHERE DG.InvoiceNumber='FEVC3388'

