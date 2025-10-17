-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_256IMAGENES
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_256IMAGENES]
AS

				SELECT        
				ad.NUMINGRES AS Ingreso,
				'TIPO DE IDENTIFICACION' = CASE pa.IPTIPODOC
				WHEN '1' THEN 'CC'
				WHEN '2' THEN 'CE'
				WHEN '3' THEN 'TI'
				WHEN '4' THEN 'RC'
				WHEN '5' THEN 'Pasporte'
				WHEN '6' THEN 'AS'
				ELSE 'MS'
				END,
				ad.IPCODPACI AS IDENTIFICACION,
				CAST( pa.IPFECNACI AS DATE )  AS 'FECHA DE NACIMIENTO',
				 'SEXO PACIENTE'= CASE PA.IPSEXOPAC
						 WHEN '1' THEN 'H'
						 WHEN '2' THEN 'M'
						 ELSE 'INDEFINIDO'
					  END,
				pa.IPPRIAPEL AS 'PRIMER APELLIDO',
				pa.IPSEGAPEL as 'SEGUNDO APELLIDO',
				pa.IPPRINOMB as 'PRIMER NOMBRE',
				pa.IPSEGNOMB as 'SEGUNDO NOMBRE',
				ha.Code + ' - ' + cg.Name AS EntidadAdministradora,
				ha.Name AS NOMBRE,
				ce.Code AS CodigoServicio, 
				ce.Description AS NombreServicio,
				CAST(sod.ServiceDate AS DATE) AS FECHASERVICIO
FROM            Billing.Invoice AS i INNER JOIN
                         Billing.InvoiceDetail AS id ON id.InvoiceId = i.Id INNER JOIN
                         ADINGRESO AS ad ON ad.NUMINGRES = i.AdmissionNumber INNER JOIN
                         INPACIENT AS pa ON ad.IPCODPACI = pa.IPCODPACI INNER JOIN
                         Billing.ServiceOrderDetail AS sod ON sod.Id = id.ServiceOrderDetailId INNER JOIN
                         Contract.CareGroup AS cg ON cg.Id = i.CareGroupId INNER JOIN
                         Contract.CUPSEntity AS ce ON ce.Id = sod.CUPSEntityId INNER JOIN
                         Payroll.FunctionalUnit AS fu ON fu.Id = sod.PerformsFunctionalUnitId INNER JOIN
                         Payroll.CostCenter AS cc ON cc.Id = sod.CostCenterId INNER JOIN
                         Security.[User] AS u ON u.UserCode = i.InvoicedUser LEFT OUTER JOIN
                         Contract.HealthAdministrator AS ha ON ha.Id = i.HealthAdministratorId
						 
WHERE        (i.Status = 1)
  

