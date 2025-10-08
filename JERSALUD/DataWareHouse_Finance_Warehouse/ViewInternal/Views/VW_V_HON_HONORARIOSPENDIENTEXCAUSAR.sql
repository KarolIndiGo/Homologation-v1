-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_HON_HONORARIOSPENDIENTEXCAUSAR
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_HON_HONORARIOSPENDIENTEXCAUSAR AS

SELECT uo.UnitName AS Sucursal,
    CASE F.DocumentType
        WHEN '1'
        THEN 'Factura EAPB con Contrato'
        WHEN '2'
        THEN 'Factura EAPB Sin Contrato'
        WHEN '3'
        THEN 'Factura Particular'
        WHEN '4'
        THEN 'Factura Capitada '
        WHEN '5'
        THEN 'Control de Capitacion'
        WHEN '6'
        THEN 'Factura Basica'
        WHEN '7'
        THEN 'Factura de Venta de Productos'
    END AS [Tipo de documento], 
    cat.Name AS Categoría, 
    F.InvoiceNumber AS [Nro Factura/Registro], 
    F.AdmissionNumber AS Ingreso, 
    ing.IFECHAING AS [Fecha ingreso], 
    F.PatientCode AS Identificación, 
    p.IPNOMCOMP AS Paciente, 
    ga.Name AS [Grupo de Atención], 
    F.TotalInvoice AS [Total Factura/Registro], 
    F.InvoiceDate AS [Fecha Factura/Registro], 
    dos.InvoicedQuantity AS Cantidad,
    CASE
        WHEN dq.TotalSalesPrice IS NULL
        THEN dos.TotalSalesPrice
        ELSE dq.TotalSalesPrice
    END AS ValorUnitario,
    CASE
        WHEN dq.TotalSalesPrice IS NULL
        THEN DF.GrandTotalSalesPrice
        ELSE dq.TotalSalesPrice
    END AS ValorTotal, 
    t.Nit, 
    ea.Code + ' - ' + ea.Name AS [Entidad Administradora],
    CASE dos.RecordType
        WHEN '1'
        THEN 'Servicios'
        WHEN '2'
        THEN 'Medicamentos'
    END AS [Servicios/Medicamentos], 
    ServiciosIPS.Code AS CodServ, 
    ServiciosIPS.Name AS Servicio,
    CASE dos.Presentation
        WHEN '1'
        THEN 'No Quirúrgico'
        WHEN '2'
        THEN 'Quirúrgico'
        WHEN '3'
        THEN 'Paquete'
    END AS [Presentación Servicio], 
    ServiciosIPSQ.Code AS Subcodigo, 
    ServiciosIPSQ.Name AS Subnombre,
    CASE
        WHEN dq.PerformsHealthProfessionalCode IS NULL
        THEN dos.PerformsHealthProfessionalCode
        ELSE dq.PerformsHealthProfessionalCode
    END AS CodigoMèdico,
    CASE
        WHEN RTRIM(medqx.NOMMEDICO) IS NULL
        THEN med.NOMMEDICO
        ELSE RTRIM(medqx.NOMMEDICO)
    END AS NombreMedico, 
    UF.Name AS [Descripción Unidad Funcional], 
    salida.FECALTPAC AS [Fecha Alta médica], 
    ing.CODDIAEGR AS CIE10, 
    diag.NOMDIAGNO AS Diagnóstico,
    CASE
        WHEN espmed.DESESPECI IS NULL
        THEN espqx.DESESPECI
        ELSE espmed.DESESPECI
    END AS Especialidad, 
    per.Fullname AS Usuario, 
    dos.IsPackage AS Paquete, 
    dos.Packaging AS Incluído, 
    CP.ContractName AS ContratoMedico
FROM INDIGO031.Billing.Invoice AS F 
    INNER JOIN INDIGO031.Billing.InvoiceDetail AS DF  ON DF.InvoiceId = F.Id
    INNER JOIN INDIGO031.dbo.ADINGRESO AS ing  ON (ing.NUMINGRES ) = F.AdmissionNumber
    INNER JOIN INDIGO031.Billing.ServiceOrderDetail AS dos  ON dos.Id = DF.ServiceOrderDetailId
                                                                                   AND dos.RecordType = 1
    INNER JOIN INDIGO031.dbo.INPACIENT AS p  ON p.IPCODPACI = F.PatientCode
    INNER JOIN INDIGO031.Common.ThirdParty AS t  ON t.Id = F.ThirdPartyId
    INNER JOIN INDIGO031.Common.OperatingUnit AS uo  ON uo.Id = F.OperatingUnitId
    INNER JOIN INDIGO031.Contract.CareGroup AS ga  ON ga.Id = F.CareGroupId
    LEFT OUTER JOIN INDIGO031.Contract.HealthAdministrator AS ea  ON ea.Id = F.HealthAdministratorId
    LEFT OUTER JOIN INDIGO031.Security.UserInt AS u ON u.UserCode = F.InvoicedUser
    LEFT OUTER JOIN INDIGO031.Security.PersonInt AS per ON per.Id = u.IdPerson
    LEFT OUTER JOIN INDIGO031.Billing.InvoiceCategories AS cat  ON cat.Id = F.InvoiceCategoryId
    LEFT OUTER JOIN INDIGO031.Contract.IPSService AS ServiciosIPS  ON ServiciosIPS.Id = dos.IPSServiceId
    LEFT OUTER JOIN INDIGO031.dbo.INPROFSAL AS med  ON med.CODPROSAL = dos.PerformsHealthProfessionalCode
    LEFT OUTER JOIN INDIGO031.dbo.INESPECIA AS espmed  ON espmed.CODESPECI = med.CODESPEC1
    LEFT OUTER JOIN INDIGO031.dbo.INDIAGNOS AS diag  ON diag.CODDIAGNO = ing.CODDIAEGR
    LEFT OUTER JOIN INDIGO031.dbo.HCREGEGRE AS salida  ON (salida.NUMINGRES ) = F.AdmissionNumber
    LEFT OUTER JOIN INDIGO031.Billing.ServiceOrderDetailSurgical AS dq  ON dq.ServiceOrderDetailId = dos.Id
                                                                                                   AND dq.OnlyMedicalFees = '0'
                                                                                                   AND dq.TotalSalesPrice > 0
    LEFT OUTER JOIN INDIGO031.dbo.INPROFSAL AS medqx  ON medqx.CODPROSAL = dq.PerformsHealthProfessionalCode
    LEFT OUTER JOIN INDIGO031.dbo.INESPECIA AS espqx  ON espqx.CODESPECI = medqx.CODESPEC1
    LEFT OUTER JOIN INDIGO031.Contract.IPSService AS ServiciosIPSQ  ON ServiciosIPSQ.Id = dq.IPSServiceId
                                                                                             AND ServiciosIPSQ.ServiceClass IN(1, 2, 3, 4)
    LEFT OUTER JOIN INDIGO031.Payroll.FunctionalUnit AS UF  ON UF.Id = dos.PerformsFunctionalUnitId
    INNER JOIN INDIGO031.MedicalFees.HealthProfessionalContract AS cm ON med.CODPROSAL = cm.HealthProfessionalCode
                                                                                   AND cm.LiquidateDefault = 1
    INNER JOIN INDIGO031.MedicalFees.MedicalFeesContract AS CP ON cm.MedicalFeesContractId = CP.Id
WHERE(F.Status = '1')
    AND (DF.Id NOT IN
(
    SELECT InvoiceDetailId
    FROM INDIGO031.MedicalFees.MedicalFeesCausation
    WHERE(Status <> 4)
))
    AND (F.InvoiceDate >= '2025-01-01')