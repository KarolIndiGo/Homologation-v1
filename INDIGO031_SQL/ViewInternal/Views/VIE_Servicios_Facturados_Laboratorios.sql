-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_Servicios_Facturados_Laboratorios
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_Servicios_Facturados_Laboratorios] AS

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
            CASE F.STATUS
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
            t.Name AS FUNCIONARIO, 
            CA.NOMCENATE AS Sede, 
            GA.Code AS Cod_Grupo_Atencion, 
            GA.Name AS Grupo_Atencion

/*
    /*ING.CODPROING AS [Codigo Profesional Ingreso], (SELECT NOMMEDICO FROM dbo.INPROFSAL WHERE CODPROSAL=ING.CODPROING) AS Profesional_Ingreso,*/  
   (SELECT NOMMEDICO FROM dbo.INPROFSAL WHERE CODPROSAL=SOD.PerformsHealthProfessionalCode) AS Profesional_Factura,  
    CASE F.DocumentType WHEN 1 THEN 'Factura EAPB con Contrato' WHEN 2 THEN 'Factura EAPB Sin Contrato' WHEN 3 THEN 'Factura Particular' WHEN 4 THEN 'Factura Capitada' WHEN 5 THEN 'Control de Capitacion' WHEN 6 THEN 'Factura Basica' WHEN 7 THEN 'Factura de Venta de Productos' END AS TIPO_DOCUMENTO_FACTURADO,  CU.Number AS Cuenta, CU.Name AS CuentaContable,--,concepto facturacion 
    (SELECT TOP 1 DIAG.CODDIAGNO FROM dbo.INDIAGNOP AS DIAG  WHERE DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1)*/

     --DIAG.CODDIAGNO AS DX_Principal  
     FROM Billing.Invoice AS F
          INNER JOIN Billing.InvoiceDetail AS FD  ON F.Id = FD.InvoiceId

          /*AND F.DocumentType=5 AND F.Status=1*/

          INNER JOIN Billing.ServiceOrderDetail AS SOD  ON FD.ServiceOrderDetailId = SOD.Id
          INNER JOIN Billing.ServiceOrder AS SO  ON SOD.ServiceOrderId = SO.Id
          INNER JOIN Contract.CUPSEntity AS CUPS  ON CUPS.Id = SOD.CUPSEntityId
          INNER JOIN dbo.ADINGRESO AS ING  ON ING.NUMINGRES = SO.AdmissionNumber
          INNER JOIN Contract.CareGroup AS GA  ON GA.Id = SOD.CareGroupId
          INNER JOIN dbo.ADCENATEN AS CA  ON CA.CODCENATE = ING.CODCENATE
          INNER JOIN dbo.INUNIFUNC AS U  ON U.UFUCODIGO = ING.UFUCODIGO
          INNER JOIN dbo.INPACIENT AS P  ON P.IPCODPACI = ING.IPCODPACI
          LEFT JOIN Common.ThirdParty AS T  ON f.InvoicedUser = t.Nit
          JOIN dbo.SEGusuaru AS us  ON ing.CODUSUCRE = us.CODUSUARI
          INNER JOIN Billing.BillingConcept AS CF  ON CUPS.BillingConceptId = CF.Id
          INNER JOIN GeneralLedger.MainAccounts AS CU  ON CF.EntityIncomeAccountId = CU.Id   
     --LEFT JOIN dbo.INDIAGNOP AS DIAG ON DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1  
     --INNER JOIN dbo.INDIAGNOS AS   
     WHERE
	 --(GA.Code = 'BOG045'
          -- OR GA.Code = 'BOG091'
          -- OR GA.Code = 'BOG134'
          -- OR GA.Code = 'BOG135'
          -- OR GA.Code = 'BOG136'
          -- OR GA.Code = 'BOG059'
          -- OR GA.Code = 'BOG066'
          -- OR GA.Code = 'BOG141'
          -- OR GA.Code = 'BOG142')
          --AND 
		  --ING.IFECHAING >= DATEADD(MONTH, -2, GETDATE());
ING.IFECHAING >= '01-01-2025 00:00:00'


