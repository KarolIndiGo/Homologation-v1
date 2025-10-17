-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_USUARIO_ORDEN_SERVICIO
-- Extracted by Fabric SQL Extractor SPN v3.9.0



-- =============================================
-- Author:      Miguel Angle Ruiz Vega
-- Create date: 2025-01-31 10:51:38
-- Database:    INDIGO043
-- Description: Reporte Cuentas Medicas Trazabilidad
-- =============================================



CREATE VIEW [Report].[View_HDSAP_USUARIO_ORDEN_SERVICIO]
AS




		SELECT 

		A.PatientCode AS 'DOCUMENTO IDENTIDAD', 
		B.IPNOMCOMP AS 'NOMBRE PACIENTE',
		A.Code AS 'CODIGO DE LA ORDEN DEL SERVICIO',
		A.AdmissionNumber AS 'NUMERO DE INGRESO', 
		CASE A.Status
		WHEN 1 THEN 'Registrado'
		WHEN 2 THEN 'Facturado'
		WHEN 3 THEN 'Anulado' end 'ESTADO DE INGRESO', 
		C.IFECHAING  AS 'FECHA DE INGRESO', 
		D.NOMENTIDA AS 'ENTIDAD SALUD', 
		A.CreationUser AS 'COD USUARIO CREA',
		E.NOMUSUARI AS 'NOMBRE FACTURADOR',
		FORMAT(A.OrderDate, 'dd/MM/yy HH:mm') AS 'FECHA DE ORDEN DE SERVICIO'

		FROM Billing.ServiceOrder A
		JOIN INPACIENT B ON B.IPCODPACI = A.PatientCode
		JOIN ADINGRESO C ON C.NUMINGRES = A.AdmissionNumber
		JOIN INENTIDAD D ON D.CODENTIDA = C.CODENTIDA
		JOIN SEGusuaru E ON E.CODUSUARI = A.CreationUser
 

  

