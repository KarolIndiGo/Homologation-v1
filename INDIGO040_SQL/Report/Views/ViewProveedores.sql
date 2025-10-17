-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewProveedores
-- Extracted by Fabric SQL Extractor SPN v3.9.0



/*******************************************************************************************************************
Nombre: [Report].[ViewProveedores]
Tipo:Vista
Observacion:Proveedores
Profesional: Nilsson Miguel Galindo Lopez
Fecha:22-03-2024
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 1
Persona que modifico:
Fecha:
Ovservaciones:
------------------------------------------------------------------------------------------
Version 2
Persona que modifico:
Fecha:
Observaciones: 
***********************************************************************************************************************************/

CREATE VIEW [Report].[ViewProveedores]
AS

WITH

CTE_CUENTAS_BANCARIAS AS
(
	SELECT 
	ROW_NUMBER ( )   
	OVER (PARTITION BY SupplierId  order by SupplierId DESC) 'NUMERO',
	SupplierId,
	CB.Number,
	BAN.Name,
	CASE CB.Type WHEN 1 THEN 'Ahorro' ELSE 'Corriente' END AS TIPO
	FROM
	Common.SupplierBankAccount CB INNER JOIN
	Payroll.Bank BAN ON CB.BankId=BAN.Id
)


SELECT --TOP 100
CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY,
ISNULL(PRO.Code,TER.Nit) AS [CODIGO],
TER.Name AS NOMBRE,
TER.Nit AS NIT,
TER.DigitVerification AS [DIGITO DE VERIFICACION],
CASE TER.PersonType WHEN 1 THEN 'Natural' ELSE 'Jurídico' END AS [TIPO DE PERSONA],
CASE TER.RetentionType WHEN 0 THEN 'Ninguna' 
					   WHEN 1 THEN 'Exento de retencion'
					   WHEN 2 THEN 'Hace Retencion'
					   WHEN 3 THEN 'Autoretenedor' END AS [TIPO RETENCIÓN],
CASE TER.ContributionType WHEN 0 THEN 'No responsable de Iva'
						  WHEN 1 THEN 'Responsables de Iva'
						  WHEN 2 THEN 'Empresa estatal'
						  WHEN 3 THEN 'Gran Contribuyente'
						  WHEN 4 THEN 'Regimen Simple'
						  WHEN 5 THEN 'Exento' END AS [TIPO CONTRUBYENTE],
CASE TER.StateEnterpriseType WHEN 0 THEN 'No Aplica'
							 WHEN 1 THEN 'Municipal'
							 WHEN 2 THEN 'Departamental'
							 WHEN 3 THEN 'Distrital' END AS [EMPRESA ESTATAL],
CASE TER.Ica WHEN 1 THEN 'SI' ELSE 'NO' END AS [MANEJA ICA],
CI.Name AS [CIUDAD DEL PROVEEDOR],
DIR.Addresss AS DIRECCION,
EMA.Email AS EMAIL,
CASE EMA.Type WHEN 1 THEN 'Notificaciones varias'
              WHEN 2 THEN 'Notificación Facturación Electrónica'END AS [TIPO NOTIFICACION],
TEL.Phone AS TELEFONO,
IIF(PRO.ID IS NULL,'NO','SI') AS PROVEEDOR,
IIF(PAC.ID IS NULL,'NO','SI') AS PACIENTE,
IIF(CLI.ID IS NULL,'NO','SI') AS CLIENTE,
IIF(PE.ID IS NULL,'NO','SI') AS [TALENTO HUMANO],
CB.TIPO AS [TIPO DE CUENTA UNO],
CB.Number AS [NUMERO DE CUENTA BANCARIA UNO],
CB.Name AS [BANCO UNO],
CBA.TIPO AS [TIPO DE CUENTA DOS],
CBA.Number AS [NUMERO DE CUENTA BANCARIA DOS],
CBA.Name AS [BANCO DOS],
TER.CreationDate AS [FECHA DE CREACION],
 1 as 'CANTIDAD',
CAST(TER.CreationDate AS date) AS [FECHA BUSQUEDA],
YEAR(TER.CreationDate) AS [AÑO BUSQUEDA],
MONTH(TER.CreationDate) AS [MES BUSQUEDA],
CONCAT(FORMAT(MONTH(TER.CreationDate), '00') ,' - ', CASE MONTH(TER.CreationDate) WHEN 1 THEN 'ENERO'
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
																				  WHEN 12 THEN 'DICIEMBRE' END) [MES NOMBRE BUSQUEDA],
CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM 
Common.ThirdParty TER
LEFT JOIN Common.Supplier PRO ON ter.Id=PRO.IdThirdParty
LEFT JOIN dbo.INPACIENT PAC on TER.NIT=pac.IPCODPACI
LEFT JOIN Common.Customer CLI ON TER.Nit = CLI.Nit
LEFT JOIN Payroll.Employee PE ON TER.Id =PE.ThirdPartyId
LEFT JOIN CTE_CUENTAS_BANCARIAS CB ON PRO.ID=CB.SupplierId AND CB.NUMERO=1
LEFT JOIN Common.City CI ON PRO.IdCity=CI.Id
LEFT JOIN CTE_CUENTAS_BANCARIAS CBA ON PRO.ID=CBA.SupplierId AND CBA.NUMERO=2
LEFT JOIN Common.Email EMA ON TER.PersonId=EMA.IdPerson AND EMA.ID=(SELECT MAX(E.ID) FROM Common.Email E WHERE TER.PersonId=E.IdPerson)
LEFT JOIN Common.Phone TEL ON TER.PersonId=TEL.IdPerson AND TEL.ID=(SELECT MAX(E.ID) FROM Common.Phone E WHERE TER.PersonId=E.IdPerson)
LEFT JOIN Common.Address DIR ON TER.PersonId=DIR.IdPerson AND DIR.Id=(SELECT MAX(E.ID) FROM Common.Address E WHERE TER.PersonId=E.IdPerson)
--where pro.code='830089496'


--SELECT TOP 100 * FROM Common.Supplier where Code='830089496'
--SELECT TOP 100 * FROM Common.ThirdParty where id=142
--SELECT * FROM Common.Address where  IdPerson=142
--SELECT * FROM Common.Address
