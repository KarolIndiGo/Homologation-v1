-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Billing_ServiciosFacturados
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VIE_AD_Billing_ServiciosFacturados] as
 SELECT  
            ING.IFECHAING AS FECHA_INGRESO, 
           
            CA.NOMCENATE AS CENTRO_ATENCION, 
            U.UFUDESCRI AS UNIDAD_FUNCIONAL,
            
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
			 FD.InvoicedQuantity*FD.TotalSalesPrice AS TOTAL,
            F.TotalInvoice AS TOTAL_FACTURA, 
            F.InvoiceDate AS FECHA_CIERRE, 
            F.InvoicedUser AS USUARIOFACT, 
            t.Name AS FUNCIONARIO, 
            CA.NOMCENATE AS Sede, 
            GA.Code AS Cod_Grupo_Atencion, 
            GA.Name AS Grupo_Atencion,
			ESP.DESESPECI AS Especialidad,
			sod.PerformsHealthProfessionalCode as CodMedico,
			bg.name as GrupoFacturacion
  
     FROM Billing.Invoice AS F
          INNER JOIN Billing.InvoiceDetail AS FD  ON F.Id = FD.InvoiceId
          INNER JOIN Billing.ServiceOrderDetail AS SOD  ON FD.ServiceOrderDetailId = SOD.Id
          INNER JOIN Billing.ServiceOrder AS SO  ON SOD.ServiceOrderId = SO.Id
          INNER JOIN Contract.CUPSEntity AS CUPS  ON CUPS.Id = SOD.CUPSEntityId
          INNER JOIN dbo.ADINGRESO AS ING  ON ING.NUMINGRES = SO.AdmissionNumber
          INNER JOIN Contract.CareGroup AS GA  ON GA.Id = SOD.CareGroupId
          INNER JOIN dbo.ADCENATEN AS CA  ON CA.CODCENATE = ING.CODCENATE
          INNER JOIN dbo.INUNIFUNC AS U  ON U.UFUCODIGO = ING.UFUCODIGO
          INNER JOIN dbo.INPACIENT AS P  ON P.IPCODPACI = ING.IPCODPACI
          LEFT JOIN Common.ThirdParty AS T  ON f.InvoicedUser = t.Nit
          LEFT JOIN DBO.INESPECIA AS ESP  ON ESP.CODESPECI=SOD.PerformsProfessionalSpecialty
         LEFT OUTER JOIN Billing.BillingGroup AS bg  ON bg.Id = cups.BillingGroupId
  
     WHERE F.STATUS =1   AND   YEAR(F.InvoiceDate) =2021 and bg.code in (19,20 ,28,11)
	 and cups.code not in ('990202','990223', '990224', '990221','990222','990205','990207','990209')
