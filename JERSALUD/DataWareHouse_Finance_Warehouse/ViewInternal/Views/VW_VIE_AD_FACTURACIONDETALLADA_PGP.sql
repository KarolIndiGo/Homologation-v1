-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_FACTURACIONDETALLADA_PGP
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_FACTURACIONDETALLADA_PGP AS
SELECT 
    uo.UnitName AS Reginal,
    cat.Name AS Categoría,
    ing.IFECHAING AS [Fecha de atención],
    ing.IFECHAING AS [Fecha Reporte],
    CONVERT(varchar, ing.IFECHAING, 8) AS [Hora de consulta o examen],
    CASE 
        WHEN p.IPTIPODOC = '1' THEN 'CC'
        WHEN p.IPTIPODOC = '2' THEN 'CE'
        WHEN p.IPTIPODOC = '3' THEN 'TI'
        WHEN p.IPTIPODOC = '4' THEN 'RC'
        WHEN p.IPTIPODOC = '5' THEN 'PA'
        WHEN p.IPTIPODOC = '6' THEN 'AS'
        WHEN p.IPTIPODOC = '7' THEN 'MS'
    END AS [Tipo ID],
    F.PatientCode AS [Numero Id],
    p.IPPRINOMB AS [Primer nombre],
    p.IPSEGNOMB AS [Segundo nombre],
    p.IPPRIAPEL AS [Primer apellido],
    p.IPSEGAPEL AS [Segundo apellido],
    CASE IPSEXOPAC
        WHEN 1 THEN 'Masculino'
        WHEN 2 THEN 'Femenino'
    END AS Sexo,
    p.IPFECNACI AS FechaNacimiento,
    CASE IPTIPOAFI
        WHEN 0 THEN 'NO APLICA'
        WHEN 1 THEN 'Cotizante'
        WHEN 2 THEN 'Beneficiario'
        WHEN 3 THEN 'Adicional'
        WHEN 4 THEN 'Jub/Retirado'
        WHEN 5 THEN 'Pensionado'
    END AS [Tipo de Usuario],
    CASE dos.RecordType
        WHEN '1' THEN 'Servicios'
        WHEN '2' THEN 'Medicamentos'
    END AS [Servicios/Medicamentos],
    CASE
        WHEN pr.Code IS NULL THEN ServiciosIPS.Code
        ELSE pr.Code
    END AS Código,
    CASE
        WHEN pr.Name IS NULL THEN ServiciosIPS.Name
        ELSE pr.Name
    END AS Descripción,
    dos.InvoicedQuantity AS Cantidad,
    ing.IFECHAING AS [Fecha de Ingreso],
    CASE
        WHEN espmed.DESESPECI IS NULL THEN espqx.DESESPECI
        ELSE espmed.DESESPECI
    END AS Especialidad,
    CASE HC.INDICAPAC
        WHEN 9 THEN 'Hospitalizacion en Casa'
        WHEN 10 THEN 'Referencia'
        WHEN 11 THEN 'Morgue'
        WHEN 12 THEN 'Salida'
    END AS [Tipo de Egreso],
    CASE ing.ITIPORIES
        WHEN '1' THEN 'Enfermedad General'
        WHEN '2' THEN 'SOAT'
        WHEN '3' THEN 'Catastrofe'
    END AS Origen,
    ing.CODDIAEGR AS [Código Diagnostico Ppal],
    diag.NOMDIAGNO AS [Nombre Diagnóstico Ppal],
    '' AS [Fecha Diagnistico],
    ing.CODDIAEGR AS [Código diagnóstico 2],
    diage.NOMDIAGNO AS [Nombre diagnóstico 2],
    F.InvoiceNumber AS [Nro Factura],
    '' AS [Valor a Facturar],
    cat.Name AS Observaciones,
    F.AdmissionNumber AS Ingreso,
    F.TotalInvoice AS [Total Registro],
    RTRIM(UF.Code) AS [Unidad Funcional],
    per.Fullname AS Usuario,
    CASE
        WHEN dq.TotalSalesPrice IS NULL THEN dos.TotalSalesPrice
        ELSE dq.TotalSalesPrice
    END AS ValorUnitario,
    CASE
        WHEN dq.TotalSalesPrice IS NULL THEN DF.GrandTotalSalesPrice
        ELSE dq.TotalSalesPrice
    END AS ValorTotal,
    F.InvoiceDate AS [Fecha Registro],
    CASE ing.TIPOINGRE
        WHEN 1 THEN 'Ambulatorio'
        WHEN 2 THEN 'Hospitalario'
    END AS TipoIngreso,
    CASE
        WHEN espmed.DESESPECI IS NULL THEN pe.IdentificationType
        ELSE pem.IdentificationType
    END AS [Tipo Identificacion Medico Orden],
    CASE
        WHEN espmed.DESESPECI IS NULL THEN pe.Identification
        ELSE pem.Identification
    END AS [Identificacion Medico Orden],
    CASE
        WHEN espmed.DESESPECI IS NULL THEN medqx.CODPROSAL
        ELSE med.CODPROSAL
    END AS [Cod Medico Orden],
    CASE
        WHEN espmed.DESESPECI IS NULL THEN medqx.NOMMEDICO
        ELSE med.NOMMEDICO
    END AS [Medico Orden],
    sg.Name AS GrupoMedicamento
FROM
    INDIGO031.Billing.Invoice AS F
    INNER JOIN INDIGO031.Billing.RevenueControlDetail AS Brcd ON F.RevenueControlDetailId = Brcd.Id
    INNER JOIN INDIGO031.Billing.InvoiceDetail AS DF ON DF.InvoiceId = F.Id
    INNER JOIN INDIGO031.dbo.ADINGRESO AS ing ON ing.NUMINGRES = F.AdmissionNumber AND F.InvoiceDate >= '01/01/2021 00:00:00'
    INNER JOIN INDIGO031.Billing.ServiceOrderDetail AS dos ON dos.Id = DF.ServiceOrderDetailId
    INNER JOIN INDIGO031.dbo.INPACIENT AS p ON p.IPCODPACI = F.PatientCode
    INNER JOIN INDIGO031.Common.ThirdParty AS t ON t.Id = F.ThirdPartyId
    INNER JOIN INDIGO031.Common.OperatingUnit AS uo ON uo.Id = F.OperatingUnitId
    INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS CC ON CC.Id = dos.IncomeMainAccountId
    INNER JOIN INDIGO031.Payroll.CostCenter AS CCo ON dos.CostCenterId = CCo.Id
    LEFT OUTER JOIN INDIGO031.Contract.CareGroup AS ga ON ga.Id = F.CareGroupId
    LEFT OUTER JOIN INDIGO031.Contract.HealthAdministrator AS ea ON ea.Id = F.HealthAdministratorId
    LEFT OUTER JOIN INDIGO031.Security.[UserInt] AS u ON u.UserCode = F.InvoicedUser
    LEFT OUTER JOIN INDIGO031.Security.PersonInt AS per ON per.Id = u.IdPerson
    LEFT OUTER JOIN INDIGO031.Security.[UserInt] AS ui ON ui.UserCode = ing.CODUSUCRE
    LEFT OUTER JOIN INDIGO031.Security.PersonInt AS peri ON peri.Id = ui.IdPerson
    LEFT OUTER JOIN INDIGO031.Billing.InvoiceCategories AS cat ON cat.Id = F.InvoiceCategoryId
    LEFT OUTER JOIN INDIGO031.Contract.IPSService AS ServiciosIPS ON ServiciosIPS.Id = dos.IPSServiceId
    LEFT OUTER JOIN INDIGO031.Inventory.InventoryProduct AS pr ON pr.Id = dos.ProductId
    LEFT OUTER JOIN INDIGO031.Inventory.ProductGroup AS sg ON sg.Id = pr.ProductGroupId
    LEFT OUTER JOIN INDIGO031.dbo.INPROFSAL AS med ON med.CODPROSAL = dos.PerformsHealthProfessionalCode
    LEFT OUTER JOIN INDIGO031.dbo.INESPECIA AS espmed ON espmed.CODESPECI = med.CODESPEC1
    LEFT OUTER JOIN INDIGO031.dbo.INDIAGNOS AS diag ON diag.CODDIAGNO = ing.CODDIAEGR
    LEFT OUTER JOIN INDIGO031.dbo.INDIAGNOS AS diage ON diage.CODDIAGNO = ing.CODDIAEGR
    LEFT OUTER JOIN INDIGO031.dbo.HCREGEGRE AS salida ON salida.NUMINGRES = F.AdmissionNumber
    LEFT OUTER JOIN INDIGO031.Billing.ServiceOrderDetailSurgical AS dq ON dq.ServiceOrderDetailId = dos.Id AND dq.OnlyMedicalFees = '0'
    LEFT OUTER JOIN INDIGO031.dbo.INPROFSAL AS medqx ON medqx.CODPROSAL = dq.PerformsHealthProfessionalCode
    LEFT OUTER JOIN INDIGO031.dbo.INESPECIA AS espqx ON espqx.CODESPECI = medqx.CODESPEC1
    LEFT OUTER JOIN INDIGO031.Contract.IPSService AS ServiciosIPSQ ON ServiciosIPSQ.Id = dq.IPSServiceId
    LEFT OUTER JOIN INDIGO031.Payroll.FunctionalUnit AS UF ON UF.Id = dos.PerformsFunctionalUnitId
    LEFT OUTER JOIN INDIGO031.Contract.CUPSEntity AS CUPS ON CUPS.Id = dos.CUPSEntityId
    LEFT OUTER JOIN INDIGO031.Billing.BillingGroup AS gf ON gf.Id = CUPS.BillingGroupId
    INNER JOIN INDIGO031.dbo.INUBICACI AS ubi ON ubi.AUUBICACI = p.AUUBICACI
    LEFT OUTER JOIN INDIGO031.dbo.INMUNICIP AS m ON m.DEPMUNCOD = ubi.DEPMUNCOD
    LEFT OUTER JOIN INDIGO031.dbo.INDEPARTA AS DEP ON m.DEPCODIGO = DEP.depcodigo
    LEFT OUTER JOIN INDIGO031.dbo.ADNIVELES AS E ON E.NIVCODIGO = p.NIVCODIGO
    LEFT OUTER JOIN INDIGO031.dbo.HCHISPACA AS HC ON HC.NUMINGRES = salida.NUMINGRES AND HC.NUMEFOLIO = salida.NUMEFOLIO
    LEFT OUTER JOIN (
        SELECT UserCode, Identification, 'CC' AS IdentificationType
        FROM INDIGO031.Security.[UserInt] AS u
        INNER JOIN INDIGO031.Security.PersonInt AS p ON p.Id = u.IdPerson
    ) AS pe ON pe.UserCode = medqx.CODUSUARI
    LEFT OUTER JOIN (
        SELECT UserCode, Identification, 'CC' AS IdentificationType
        FROM INDIGO031.Security.[UserInt] AS u
        INNER JOIN INDIGO031.Security.PersonInt AS p ON p.Id = u.IdPerson
    ) AS pem ON pem.UserCode = med.CODUSUARI
WHERE
    (F.Status = '1')
    AND (dos.IsDelete = '0')
    AND (F.DocumentType = '5')
    AND (F.RevenueControlDetailId IS NOT NULL)
    AND (F.InvoiceDate >= '01/07/2021 00:00:00' AND dos.RecordType = 2 AND cat.Code = '010' AND F.HealthAdministratorId = 72)