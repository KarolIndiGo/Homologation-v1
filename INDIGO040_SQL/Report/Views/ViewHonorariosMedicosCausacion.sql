-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewHonorariosMedicosCausacion
-- Extracted by Fabric SQL Extractor SPN v3.9.0












/*******************************************************************************************************************
Nombre: [Report].[ViewHonorariosMedicosCausacion]
Tipo:Vista
Observacion:Causación de honorarios medicos con su respectivo estado.
Profesional:
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:Nilsson Miguel Galindo
Fecha:24-10-2023
Observaciones:Se agregan campos y se reajusta la vista, esto solicitado por Sordos y ciegos
--------------------------------------
Version 3
Persona que modifico:Nilsson Miguel Galindo Lopez
Fecha: 27-11-2023
Observaciones: Se agregan la lectura del profesional para el instituto de ciegos y sordos.
--------------------------------------
Version 4
Persona que modifico:Nilsson Miguel Galindo Lopez
Fecha: 13-12-2023
Observaciones: Se agrega el campo del grupo de atención.
***********************************************************************************************************************************/

CREATE VIEW [Report].[ViewHonorariosMedicosCausacion] AS

WITH
CTE_LECTURA AS
(
SELECT 
A.GENSERVICEORDER,A.MEDREALEC AS [CODIGO PROFESIONAL LECTURA],PRO.NOMMEDICO AS [PROFESIONAL LECTURA],A.FECHLECT AS [FECHA LECTURA], 
PRO1.CODPROSAL AS [CODIGO PROFESIONAL TOMA EXAMEN], PRO1.NOMMEDICO AS [PROFESIONAL TOMA EXAMEN]
,A.IPCODPACI,A.AUTO,A.NUMINGRES
FROM 
dbo.AMBORDIMA A INNER JOIN
DBO.INPROFSAL PRO ON A.MEDREALEC=PRO.CODPROSAL
INNER JOIN DBO.INPROFSAL PRO1 ON PRO1.CODUSUARI = A.USURECEXA
GROUP BY A.GENSERVICEORDER,A.MEDREALEC,PRO.NOMMEDICO,A.FECHLECT,PRO1.CODPROSAL, PRO1.NOMMEDICO,A.IPCODPACI,A.AUTO,A.NUMINGRES
UNION ALL
SELECT 
A.GENSERVICEORDER,A.MEDREALEC AS [CODIGO PROFESIONAL LECTURA],PRO.NOMMEDICO AS [PROFESIONAL LECTURA],A.FECHLECT AS [FECHA LECTURA], 
PRO1.CODPROSAL AS [CODIGO PROFESIONAL TOMA EXAMEN], PRO1.NOMMEDICO AS [PROFESIONAL TOMA EXAMEN]
,A.IPCODPACI,A.AUTO,A.NUMINGRES
FROM 
DBO.HCORDIMAG A INNER JOIN
DBO.INPROFSAL PRO ON A.MEDREALEC=PRO.CODPROSAL
INNER JOIN DBO.INPROFSAL PRO1 ON PRO1.CODUSUARI = A.USURECEXA
GROUP BY A.GENSERVICEORDER,A.MEDREALEC,PRO.NOMMEDICO,A.FECHLECT,PRO1.CODPROSAL, PRO1.NOMMEDICO,A.IPCODPACI,A.AUTO,A.NUMINGRES
),

CTE_HONORARIOS AS
(
	SELECT DISTINCT
	HON.HealthProfessionalCode,
	HON.ThirdPartyId,
	HON.CausationDate,
	HON.AdmissionNumber,
	HON.PatientCode,
	HON.AmountPayable,
	CASE HON.[Status] WHEN 1 THEN 'Causado' 
					  WHEN 2 THEN 'Liquidado' 
					  WHEN 3 THEN 'Confirmado'
					  WHEN 4 THEN 'Anulado' END AS ESTADO,
	HON.ServiceOrderDetailSurgicalId,
	F.InvoiceNumber, 
	F.InvoiceDate, 
	F.HealthAdministratorId,
	F.CareGroupId,
	DF.GrandTotalSalesPrice,
	DS.CUPSEntityId,
	MCO.SupplierId,
	MCO.ContractName,
	RTRIM(LEC.[CODIGO PROFESIONAL LECTURA])+' - '+LEC.[PROFESIONAL LECTURA] AS [PROFESIONAL LECTURA],
	LEC.[FECHA LECTURA],
	RTRIM(LEC.[CODIGO PROFESIONAL TOMA EXAMEN])+' - '+LEC.[PROFESIONAL TOMA EXAMEN] AS [PROFESIONAL TOMA EXAMEN],
	TER.Nit, 
	TER.[Name],
	PAC.IPNOMCOMP AS PACIENTE,
	DS.CUPSEntityContractDescriptionId,
	OD.Code AS [CODIGO ORDEN DE SERVICIO],
	OD.OrderDate AS [FECHA DE LA ORDEN DE SRVICIO],
	CC.Code AS [CODIGO CENTRO DE COSTO],
	CC.Name AS [CENTRO DE COSTO],
	CASE F.Status WHEN 1 THEN 'FACTURADO' ELSE 'ANULADO' END AS [ESTADO FACTURA]
	FROM
	MedicalFees.MedicalFeesCausation AS HON INNER JOIN 
	MedicalFees.MedicalFeesContract AS MCO ON HON.MedicalFeesContractId = MCO.Id AND HON.Status <> 4 INNER JOIN
	Billing.InvoiceDetail AS DF ON HON.InvoiceDetailId = DF.Id INNER JOIN
	Billing.Invoice AS F ON DF.InvoiceId=F.Id AND F.Status=1 INNER JOIN
	Billing.ServiceOrderDetail AS DS ON HON.ServiceOrderDetailId=DS.Id INNER JOIN
	Billing.ServiceOrder OD ON DS.ServiceOrderId=OD.Id
	INNER JOIN Common.ThirdParty AS TER ON HON.ThirdPartyId =TER.Id 
	INNER JOIN Payroll.CostCenter CC ON DS.CostCenterId=CC.ID
	INNER JOIN dbo.INPACIENT PAC ON HON.PatientCode=PAC.IPCODPACI
	LEFT JOIN CTE_LECTURA LEC ON DS.ServiceOrderId=LEC.GENSERVICEORDER 
	--LEFT JOIN CTE_ANESTESIA ANE ON DS.ServiceOrderId=ANE.ServiceOrderDetailId
UNION ALL
	SELECT DISTINCT
	HON.PerformsHealthProfessionalCode AS HealthProfessionalCode,
	TER.ID AS ThirdPartyId,
	NULL AS CausationDate,
	HON.AdmissionNumber,
	HON.PatientCode,
	NULL AS AmountPayable,
	'Pendiente por causar' AS ESTADO,
	'' AS ServiceOrderDetailSurgicalId,
	F.InvoiceNumber, 
	F.InvoiceDate, 
	F.HealthAdministratorId,
	F.CareGroupId,
	DF.GrandTotalSalesPrice,
	DS.CUPSEntityId,
	NULL AS SupplierId,
	CON.ContractName AS ContractName,
	RTRIM(LEC.[CODIGO PROFESIONAL LECTURA])+' - '+LEC.[PROFESIONAL LECTURA] AS [PROFESIONAL LECTURA],
	LEC.[FECHA LECTURA],
	RTRIM(LEC.[CODIGO PROFESIONAL TOMA EXAMEN])+' - '+LEC.[PROFESIONAL TOMA EXAMEN] AS [PROFESIONAL TOMA EXAMEN],
	TER.Nit, 
	TER.[Name],
	HON.PatientName AS PACIENTE,
	DS.CUPSEntityContractDescriptionId,
	OD.Code AS [CODIGO ORDEN DE SERVICIO],
	OD.OrderDate AS [FECHA DE LA ORDEN DE SERVICIO],
	CC.Code AS [CODIGO CENTRO DE COSTO],
	CC.Name AS [CENTRO DE COSTO],
	CASE F.Status WHEN 1 THEN 'FACTURADO' ELSE 'ANULADO' END AS [ESTADO FACTURA]
	FROM
	MedicalFees.CausationPending HON INNER JOIN
	Common.ThirdParty TER ON HON.PerformsHealthProfessionalCode=TER.Nit INNER JOIN
	Billing.Invoice F ON HON.InvoiceNumber=F.InvoiceNumber AND F.STATUS=1 INNER JOIN
	Billing.InvoiceDetail AS DF ON F.ID=DF.InvoiceId AND HON.InvoiceDate=DF.ServiceDate INNER JOIN
	Billing.ServiceOrderDetail AS DS ON DF.ServiceOrderDetailId=DS.Id
	INNER JOIN Billing.ServiceOrder OD ON DS.ServiceOrderId=OD.Id
	INNER JOIN Payroll.CostCenter CC ON DS.CostCenterId=CC.ID
	LEFT JOIN CTE_LECTURA LEC ON DS.ServiceOrderId=LEC.GENSERVICEORDER
	LEFT JOIN MedicalFees.HealthProfessionalContract PCON ON HON.PerformsHealthProfessionalCode=PCON.HealthProfessionalCode
	LEFT JOIN MedicalFees.MedicalFeesContract CON ON PCON.MedicalFeesContractId=CON.Id
	--LEFT JOIN CTE_ANESTESIA ANE ON DS.ServiceOrderId=ANE.ServiceOrderDetailId
)

SELECT 
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, 
HON.PatientCode AS [IDENTIFICACIÓN PACIENTE], 
HON.PACIENTE,
HA.Name AS [ENTIDAD ADMINISTRADORA],
GRU.Name AS [GRUPO DE ATENCIÓN],
HON.AdmissionNumber AS INGRESO, 
HON.InvoiceNumber AS FACTURA, 
HON.InvoiceDate AS [FECHA FACTURA], 
HON.[CODIGO ORDEN DE SERVICIO],
HON.[FECHA DE LA ORDEN DE SRVICIO],
SI.Code AS [CÓDIGO DEL SERVICIO], 
SI.Description AS SERVICIO, 
CSG.[Name] AS [SUBGRUPO SERVICIO],
CD.Code+' - '+CD.Name AS [DESCRIPCION RELACIONADA],
PROF.CODPROSAL AS MÉDICO, 
CASE PROF.TIPPROFES WHEN 1 THEN 'Medico General' 
					WHEN 2 THEN 'Medico Especialista' 
					WHEN 3 THEN 'Enfermera' 
					WHEN 4 THEN 'Auxiliar Enfermeria' 
					WHEN 5 THEN 'Odontologo General' 
					WHEN 6 THEN 'Odontologo Especialista'
					WHEN 7 THEN 'Nutricionista' 
					WHEN 8 THEN 'Higienista' 
					WHEN 9 THEN 'Psicologo' 
					WHEN 10 THEN 'Trabajadora Social' 
					WHEN 11 THEN 'PromotorSaneamiento' 
					WHEN 12 THEN 'IngSanitario' 
					WHEN 13 THEN 'Medico Veterinario'
					WHEN 14 THEN 'Ing Alimento' 
					WHEN 15 THEN 'Auxiliar Bacteriologo' 
					WHEN 16 THEN 'Terapeuta' 
					WHEN 17 THEN 'Optometra' 
					WHEN 18 THEN 'Quimico Farmaceutico' 
					WHEN 19 THEN 'Radiologo' 
					WHEN 20 THEN 'Tecnologo Radiologo'
					WHEN 21 THEN 'Instrumentador' 
					WHEN 22 THEN 'Auxiliar Patologia' 
					WHEN 25 THEN 'Bacteriologo(a)' 
					WHEN 26 THEN 'Patólogo(a)' END AS PROFESIÓN, 
ES.DESESPECI AS ESPECIALIDAD,
HON.Nit AS [NIT MEDICO], 
HON.Name AS TERCERO, 
P.Code AS [NIT ENTIDAD], 
HON.ESTADO,
HON.[CODIGO CENTRO DE COSTO],
HON.[CENTRO DE COSTO],
IPS.Code+' - '+IPS.Name AS [SERVICIO IPS],
HON.CausationDate AS [FECHA CAUSACIÓN], 
HON.ContractName AS [ENTIDAD CONTRATO/AGREMIACION],
HON.[PROFESIONAL LECTURA],
HON.[FECHA LECTURA],
HON.[PROFESIONAL TOMA EXAMEN],
HON.AmountPayable AS [VALOR CAUSADO], 
HON.GrandTotalSalesPrice AS [VALOR FACTURADO],
HON.[ESTADO FACTURA],
ING.IESTADOIN AS [ESTADO DEL INGRESO],
1 as CANTIDAD,
CAST(HON.InvoiceDate AS date) AS [FECHA BUSQUEDA],
YEAR(HON.InvoiceDate) AS [AÑO FECHA BUSQUEDA],
MONTH(HON.InvoiceDate) AS [MES FECHA BUSQUEDA],
CASE MONTH(HON.InvoiceDate) WHEN 1 THEN 'ENERO'
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
							WHEN 12 THEN 'DICIEMBRE' END AS [MES NOMBRE FECHA BUSQUEDA], 
FORMAT(DAY(HON.InvoiceDate), '00') AS 'DIA FECHA BUSQUEDA',
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM 
CTE_HONORARIOS AS HON
INNER JOIN dbo.INPROFSAL AS PROF ON HON.HealthProfessionalCode = PROF.CODPROSAL
INNER JOIN dbo.INESPECIA AS ES ON PROF.CODESPEC1=ES.CODESPECI 
INNER JOIN Contract.CUPSEntity AS SI ON HON.CUPSEntityId = SI.Id 
INNER JOIN Contract.CupsSubgroup AS CSG ON CSG.Id =SI .CUPSSubGroupId 
INNER JOIN Contract.CupsGroup AS CGR ON CGR.Id =CSG.CupsGroupId 
INNER JOIN Contract.HealthAdministrator HA ON HON.HealthAdministratorId=HA.ID
INNER JOIN dbo.ADINGRESO ING ON HON.AdmissionNumber=ING.NUMINGRES
LEFT JOIN Contract.CareGroup GRU ON HON.CareGroupId=GRU.Id 
LEFT JOIN Common.Supplier AS P ON HON.SupplierId = P.Id 
LEFT JOIN Contract.CUPSEntityContractDescriptions CUPD ON HON.CUPSEntityContractDescriptionId=CUPD.ID 
LEFT JOIN Contract.ContractDescriptions CD ON CUPD.ContractDescriptionId=CD.Id 
LEFT JOIN Billing.ServiceOrderDetailSurgical QX ON HON.ServiceOrderDetailSurgicalId=QX.Id 
LEFT JOIN Contract.IPSService IPS ON QX.IPSServiceId=IPS.Id
--WHERE HON.AdmissionNumber='66334' and si.Code='903859'


--cuenta contable con su codigo
--centro de costo
