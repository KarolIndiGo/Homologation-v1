-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_SERVICIOS_FACTURADOS_LABORATORIOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_SERVICIOS_FACTURADOS_LABORATORIOS

AS

SELECT DISTINCT 
        ING.IFECHAING AS FECHA_INGRESO, 
        us.NOMUSUARI AS UsuarioIngreso, 
        CA.NOMCENATE AS CENTRO_ATENCION, 
        U.UFUDESCRI AS UNIDAD_FUNCIONAL,
        CASE P.IPTIPODOC
            WHEN 1
            THEN 'CC'
            WHEN 2
            THEN 'CE'
            WHEN 3
            THEN 'TI'
            WHEN 4
            THEN 'RC'
            WHEN 5
            THEN 'PA'
            WHEN 6
            THEN 'AS'
            WHEN 7
            THEN 'MS'
            WHEN 8
            THEN 'NU'
        END AS TIPO_DOCUMENTO_PACIENTE, 
        ING.IPCODPACI AS IDENTIFICACION_PACIENTE, 
        P.IPNOMCOMP AS NOMBRE_PACIENTE, 
        CUPS.Code AS CUPS, 
        CUPS.Description AS CUPS_DESCRIPCION, 
        F.InvoiceNumber AS FACTURA,
        CASE F.Status
            WHEN 1
            THEN 'Facturado'
            WHEN 2
            THEN 'Anulado'
        END AS Estado_Factura, 
        FD.InvoicedQuantity AS CANTIDAD, 
        FD.TotalSalesPrice AS VALOR_UNITARIO, 
        F.TotalInvoice AS TOTAL_FACTURA, 
        F.InvoiceDate AS FECHA_CIERRE, 
        F.InvoicedUser AS USUARIOFACT, 
        T.Name AS FUNCIONARIO, 
        CA.NOMCENATE AS Sede, 
        GA.Code AS Cod_Grupo_Atencion, 
        GA.Name AS Grupo_Atencion
/*ING.CODPROING AS [Codigo Profesional Ingreso], (SELECT NOMMEDICO FROM dbo.INPROFSAL WHERE CODPROSAL=ING.CODPROING) AS Profesional_Ingreso,*/ 
/*(SELECT NOMMEDICO FROM dbo.INPROFSAL WHERE CODPROSAL=SOD.PerformsHealthProfessionalCode) AS Profesional_Factura,  
    CASE F.DocumentType WHEN 1 THEN 'Factura EAPB con Contrato' WHEN 2 THEN 'Factura EAPB Sin Contrato' WHEN 3 THEN 'Factura Particular' WHEN 4 THEN 'Factura Capitada' WHEN 5 THEN 'Control de Capitacion' WHEN 6 THEN 'Factura Basica' WHEN 7 THEN 'Factura de Venta de Productos' END AS TIPO_DOCUMENTO_FACTURADO,  CU.Number AS Cuenta, CU.Name AS CuentaContable,--,concepto facturacion 
    (SELECT TOP 1 DIAG.CODDIAGNO FROM dbo.INDIAGNOP AS DIAG  WHERE DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1)*/


FROM INDIGO031.Billing.Invoice AS F
INNER JOIN INDIGO031.Billing.InvoiceDetail AS FD  ON F.Id = FD.InvoiceId
INNER JOIN INDIGO031.Billing.ServiceOrderDetail AS SOD  ON FD.ServiceOrderDetailId = SOD.Id
INNER JOIN INDIGO031.Billing.ServiceOrder AS SO  ON SOD.ServiceOrderId = SO.Id
INNER JOIN INDIGO031.Contract.CUPSEntity AS CUPS  ON CUPS.Id = SOD.CUPSEntityId
INNER JOIN INDIGO031.dbo.ADINGRESO AS ING  ON ING.NUMINGRES = SO.AdmissionNumber
INNER JOIN INDIGO031.Contract.CareGroup AS GA  ON GA.Id = SOD.CareGroupId
INNER JOIN INDIGO031.dbo.ADCENATEN AS CA  ON CA.CODCENATE = ING.CODCENATE
INNER JOIN INDIGO031.dbo.INUNIFUNC AS U  ON U.UFUCODIGO = ING.UFUCODIGO
INNER JOIN INDIGO031.dbo.INPACIENT AS P  ON P.IPCODPACI = ING.IPCODPACI
LEFT JOIN INDIGO031.Common.ThirdParty AS T  ON F.InvoicedUser = T.Nit
JOIN INDIGO031.dbo.SEGusuaru AS us  ON ING.CODUSUCRE = us.CODUSUARI
INNER JOIN INDIGO031.Billing.BillingConcept AS CF  ON CUPS.BillingConceptId = CF.Id
INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS CU  ON CF.EntityIncomeAccountId = CU.Id   
  
WHERE ING.IFECHAING >= '01-01-2025 00:00:00'

