-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_FACTURA_PEDIATRIA
-- Extracted by Fabric SQL Extractor SPN v3.9.0










CREATE VIEW [Report].[View_HDSAP_FACTURA_PEDIATRIA]
AS

SELECT I.InvoiceNumber Factura,
       i.InvoiceDate FechaFactura,
       pac.IPCODPACI DocumentoPaciente,
	   CAST(
    DATEDIFF(YEAR, pac.IPFECNACI, GETDATE()) 
    - CASE 
        WHEN MONTH(GETDATE()) < MONTH(pac.IPFECNACI) 
             OR (MONTH(GETDATE()) = MONTH(pac.IPFECNACI) AND DAY(GETDATE()) < DAY(pac.IPFECNACI)) 
        THEN 1 
        ELSE 0 
        END AS VARCHAR
) + ' años' AS EdadPaciente,
	   pac.IPNOMCOMP NombreCompleto,
	   PRO.NOMMEDICO Medico


FROM Billing.Invoice I
JOIN Billing.ServiceOrder S ON S.AdmissionNumber = I.AdmissionNumber
JOIN Billing.ServiceOrderDetail SOD ON SOD.ServiceOrderId = S.ID
JOIN INPROFSAL PRO ON PRO.CODPROSAL = SOD.PerformsHealthProfessionalCode
JOIN INPACIENT PAC ON PAC.IPCODPACI = I.PatientCode
--WHERE pac.IPCODPACI = '83258347'




