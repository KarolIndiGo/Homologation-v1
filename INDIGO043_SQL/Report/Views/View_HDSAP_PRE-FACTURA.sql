-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_PRE-FACTURA
-- Extracted by Fabric SQL Extractor SPN v3.9.0









-- =============================================
-- Author:      Miguel Angle Ruiz Vega
-- Create date: 2025-01-31 10:51:38
-- Database:    INDIGO043
-- Description: Reporte pre factura pediatria y otros
-- =============================================



CREATE VIEW [Report].[View_HDSAP_PRE-FACTURA]
AS
SELECT 
    A.PatientCode AS 'DOCUMENTO',
    F.IPNOMCOMP AS 'NOMBRE DEL PACIENTE',
    B.IFECHAING AS 'FECHA DE INGRESO',
    E.NOMUSUARI AS 'MEDICO PROFESIONAL'
FROM Billing.RevenueControl A
JOIN ADINGRESO B ON A.AdmissionNumber = B.NUMINGRES
JOIN BILLING.ServiceOrder C ON A.AdmissionNumber = C.AdmissionNumber
JOIN BILLING.ServiceOrderDetail D ON C.Id = D.ServiceOrderId
JOIN SEGusuaru E ON E.CODUSUARI = D.PerformsHealthProfessionalCode
JOIN INPACIENT F ON F.IPCODPACI = A.PatientCode
WHERE 
    B.IINGREPOR = '2'
	AND (B.IESTADOIN = 'F' OR B.IESTADOIN = ' ')
    AND E.CODUSUARI = 'ME400'
    AND CAST(B.IFECHAING AS DATE) = CAST(GETDATE() AS DATE)



