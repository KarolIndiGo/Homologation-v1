-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: HDSAP_AGENDAMIENTOHCFACTURA_CALIDAD
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE PROCEDURE [Report].[HDSAP_AGENDAMIENTOHCFACTURA_CALIDAD]  
 @fechaInicial DATETIME, 
 @fechaFinal   DATETIME
AS
			SELECT F2.PatientCode, F2.FechaFactura
				INTO #F2
			FROM (SELECT DISTINCT BI.PatientCode, 
						 CAST(BI.InvoiceDate AS DATE) AS FechaFactura
				  -- CASE WHEN BI.Status=1 THEN 'Facturado' WHEN BI.Status=2 THEN 'Anulado' ELSE CAST(BI.Status AS varchar(10)) END AS EstadoFactura 
				  FROM [Billing].[Invoice] AS BI 
				  WHERE BI.InvoiceDate >= @fechaInicial
						AND BI.InvoiceDate < @fechaFinal
						AND BI.PatientCode IS NOT NULL
						AND BI.STATUS = 1
						AND EXISTS (SELECT * FROM  dbo.AGASICITA AGA WHERE AGA.FECHORAIN >= @fechaInicial AND AGA.FECHORAIN < @fechaFinal AND AGA.IPCODPACI=BI.PatientCode)
				  UNION ALL
				  SELECT DISTINCT 
						 BI.PatientCode, 
						 CAST(BI.InvoiceDate AS DATE) AS FechaFactura
				  --CASE WHEN BI.Status=1 THEN 'Facturado' WHEN BI.Status=2 THEN 'Anulado' ELSE CAST(BI.Status AS varchar(10)) END AS EstadoFactura 	 
				  FROM [Billing].[Invoice] AS BI
				  WHERE BI.InvoiceDate >= @fechaInicial
						AND BI.InvoiceDate < @fechaFinal
						AND BI.PatientCode IS NOT NULL
						AND BI.STATUS = 1
						AND EXISTS (SELECT * FROM  dbo.AGASICITA AGA 
									WHERE AGA.FECHORAIN >= @fechaInicial AND AGA.FECHORAIN < @fechaFinal 
									AND AGA.IPCODPACI=BI.PatientCode)
					) F2;


			SELECT F.InvoiceNumber AS Factura, F.InvoiceDate AS FechaFactura, ea.Code + ' - ' + ea.Name AS [EntidadAdministradora]
					 , F.PatientCode AS Identificación, CUPS.Code AS CUPS, CUPS.Description AS [Descripcion CUPS], cc.Code + '-' + cc.Name AS CentroCosto, 
                     CASE WHEN dq.PerformsHealthProfessionalCode IS NULL THEN dos.PerformsHealthProfessionalCode ELSE dq.PerformsHealthProfessionalCode END AS CodigoMedico,
                     CASE WHEN RTRIM(medqx.NOMMEDICO) IS NULL THEN med.NOMMEDICO ELSE RTRIM(medqx.NOMMEDICO) END AS NombreMedico,
                     CASE WHEN dq.TotalSalesPrice IS NULL THEN DF.GrandTotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorTotal
				INTO #F
              FROM Billing.Invoice AS F 
                   INNER JOIN Billing.InvoiceDetail AS DF  ON DF.InvoiceId = F.Id
                   LEFT JOIN Security.[User] AS u  ON u.UserCode = F.InvoicedUser
                   LEFT JOIN Security.Person AS per  ON per.Id = u.IdPerson
                   INNER JOIN dbo.ADINGRESO AS ing  ON ing.NUMINGRES = F.AdmissionNumber
                   INNER JOIN dbo.INPACIENT AS P  ON P.IPCODPACI = F.PatientCode
                   INNER JOIN Billing.ServiceOrderDetail AS dos  ON dos.Id = DF.ServiceOrderDetailId
                   INNER JOIN Common.ThirdParty AS t  ON t.Id = F.ThirdPartyId
                   INNER JOIN Contract.CareGroup AS ga  ON ga.Id = F.CareGroupId
                   LEFT JOIN Contract.HealthAdministrator AS ea  ON ea.Id = F.HealthAdministratorId
                   INNER JOIN Billing.InvoiceCategories AS cat  ON cat.Id = F.InvoiceCategoryId
                   LEFT OUTER JOIN Contract.IPSService AS ServiciosIPS  ON ServiciosIPS.Id = dos.IPSServiceId
                   LEFT OUTER JOIN Contract.SurgicalGroup AS GQ  ON ServiciosIPS.SurgicalGroupId = GQ.Id
                   LEFT OUTER JOIN Inventory.InventoryProduct AS pr  ON pr.Id = dos.ProductId
                   LEFT OUTER JOIN dbo.INPROFSAL AS med  ON med.CODPROSAL = dos.PerformsHealthProfessionalCode
                   LEFT OUTER JOIN dbo.INESPECIA AS espmed  ON espmed.CODESPECI = med.CODESPEC1
                   LEFT OUTER JOIN dbo.INDIAGNOS AS diag  ON diag.CODDIAGNO = ing.CODDIAEGR
                   LEFT OUTER JOIN dbo.HCREGEGRE AS salida  ON salida.NUMINGRES = F.AdmissionNumber
                   LEFT OUTER JOIN Billing.ServiceOrderDetailSurgical AS dq  ON dq.ServiceOrderDetailId = dos.Id
                                                                                                  AND dq.OnlyMedicalFees = 0
                   LEFT OUTER JOIN dbo.INPROFSAL AS medqx  ON medqx.CODPROSAL = dq.PerformsHealthProfessionalCode
                   LEFT OUTER JOIN dbo.INESPECIA AS espqx  ON espqx.CODESPECI = medqx.CODESPEC1
                   LEFT OUTER JOIN Contract.IPSService AS ServiciosIPSQ  ON ServiciosIPSQ.Id = dq.IPSServiceId
                   LEFT OUTER JOIN Payroll.FunctionalUnit AS UF  ON UF.Id = dos.PerformsFunctionalUnitId
                   LEFT OUTER JOIN Billing.ServiceOrder AS os  ON os.Id = dos.ServiceOrderId
                   LEFT OUTER JOIN Contract.CUPSEntity AS CUPS  ON CUPS.Id = dos.CUPSEntityId
                   LEFT OUTER JOIN Billing.BillingGroup AS gf  ON gf.Id = CUPS.BillingGroupId
                   LEFT OUTER JOIN dbo.INUBICACI AS BB  ON BB.AUUBICACI = P.AUUBICACI
                   LEFT OUTER JOIN dbo.INMUNICIP AS EE  ON EE.DEPMUNCOD = BB.DEPMUNCOD
                   LEFT OUTER JOIN Payroll.CostCenter AS cc  ON dos.CostCenterId = cc.Id
              WHERE -- (F.Status = '1') AND 
              (dos.IsDelete = 0)
              AND (F.DocumentType BETWEEN 1 AND 6)
                   AND cc.Code <> '7003' 
                   --AND  F.InvoiceDate>='20190901' AND F.InvoiceDate<'20191024'
                   AND F.InvoiceDate >= @fechaInicial
                   AND F.InvoiceDate < @fechaFinal
				   AND EXISTS (SELECT * FROM  dbo.AGASICITA AGA 
								WHERE AGA.FECHORAIN >= @fechaInicial AND AGA.FECHORAIN < @fechaFinal AND AGA.IPCODPACI=F.PatientCode);

;WITH PM
          AS (SELECT PM.IPCODPACI AS IdPcteProcMenor, 
                     CAST(PM.FECREAPRO AS DATE) AS FechaProcMenor, 
                     PM.CODSERIPS AS CodProcMenor, 
                     I.DESSERIPS AS DescripcionProcMenor, 
                     PM.CODPROSAL AS CodProfSaludProcMenor, 
                     PS.NOMMEDICO AS NombreProfSaludProcMenor, 
                     'InfPM' AS FuentePM
              FROM dbo.HCINFPROM AS PM
                   INNER JOIN dbo.INCUPSIPS AS I ON PM.CODSERIPS = I.CODSERIPS
                   INNER JOIN dbo.INPROFSAL AS PS ON PM.CODPROSAL = PS.CODPROSAL
              WHERE PM.FECREAPRO >= @fechaInicial
                    AND PM.FECREAPRO < @fechaFinal
              UNION ALL
              SELECT D.IPCODPACI AS IdPcteProcMenor, 
                     CAST(D.FECPROCES AS DATE) AS FechaProcMenor, 
                     D.CODSERIPS AS CodProcMenor, 
                     I.DESSERIPS AS DescripcionProcMenor, 
                     D.CODPROSAL AS CodProfSaludProcMenor, 
                     PS.NOMMEDICO AS NombreProfSaludProcMenor, 
                     'DocAddHC' AS FuentePM
              FROM dbo.HCDOCUMAD AS D
                   INNER JOIN dbo.INCUPSIPS AS I ON D.CODSERIPS = I.CODSERIPS
                   INNER JOIN dbo.INPROFSAL AS PS ON D.CODPROSAL = PS.CODPROSAL
              WHERE D.FECPROCES >= @fechaInicial
                    AND D.FECPROCES < @fechaFinal
                    AND D.NOMARCADJ IS NOT NULL)
          SELECT AGA.CODAUTONU AS CodAgenda, 
                 AGA.FECHORAIN AS FechaCita, 
                 AGA.CODESPECI AS CodEspecialidadAgenda, 
                 ES.DESESPECI AS EspecialidadAgenda, 
                 AGA.IPCODPACI AS IdPaciente, 
                 RTRIM(P.IPNOMCOMP) + CONCAT(' (', P.IPTELEFON + ' - ', P.IPTELMOVI, ')') AS NombrePaciente, 
                 AGA.CODPROSAL AS CodProfesionalAgenda, 
                 PS.NOMMEDICO AS ProfesionalSaludAgenda, 
                 AGA.FECHORAIN AS HoraInicioConsulta, 
				 aga.CODSERIPS CodigoServicio,
				 agac.DESACTMED DescripcionServicio,
                 --CASE WHEN AGA.CODACTMED='202' THEN COALESCE(RTRIM(AGA.CODSERIPS) + '-', '') + AGAC.DESACTMED ELSE AGAC.DESACTMED END AS ActividadMedica, 
                 AGA.FECREGSIS AS FechaRegistroAgenda, 
				 AGA.FECREGSIS AS FechaPrimeraSolicitud,
				 AGA.FECITADES AS FechaDeseada, 
				 AGA.FECHORAIN AS FechaAsignacionCita,
                 CASE AGA.CODESTCIT
                     WHEN '0'
                     THEN 'Asignada'
                     WHEN '1'
                     THEN 'Cumplida'
                     WHEN '2'
                     THEN 'Incumplida'
                     WHEN '3'
                     THEN 'PreAsignada'
                     WHEN '4'
                     THEN 'Cancelada'
                 END AS 'EstadoCita', 
                 H.FechaHC, 
                 H.NumeroAnotacionesHC,
                 CASE
                     WHEN F2.FechaFactura IS NOT NULL
                     THEN 'SI'
                     ELSE 'NO'
                 END AS Factura, 
                 F2.FechaFactura, 
                 PM.FechaProcMenor, 
                 PM.CodProcMenor, 
                 PM.DescripcionProcMenor, 
                 PM.NombreProfSaludProcMenor, 
                 P.IPFECNACI AS FechaNacimiento, 
                 dbo.Edad(CAST(P.IPFECNACI AS DATE), CAST(AGA.FECHORAIN AS DATE)) AS Edad2, 
 
                 PM.FuentePM, 
                 EN.NOMENTIDA AS EntidadPaciente, 
                 P.IPTIPOPAC AS TipoPaciente, 
                 NumFact, 
                 F.EntidadAdministradora, 
                 CUPSfact, 
                 F.[DescripcionCUPSfact], 
                 F.CentroCosto, 
                 CodMDfact, 
                 MDfact, 
                 F.ValorTotal,
                 CASE
                     WHEN CodMDfact IS NULL
                     THEN ''
                     WHEN AGA.CODPROSAL = CodMDfact
                     THEN 'IGUAL'
                     ELSE 'DIFERENTE'
                 END AS MD_AgendaVsFact,
				 P.IPDIRECCI AS Direccion,
				 MUN.MUNNOMBRE AS Municipio,
				 AGA.OBSCAUCAN AS CausaCancelacion,
				 AGA.OBSERVACI ObservacionCita
          FROM dbo.AGASICITA AS AGA 
               INNER JOIN dbo.INPACIENT AS P  ON AGA.IPCODPACI = P.IPCODPACI
               LEFT JOIN dbo.INESPECIA AS ES  ON AGA.CODESPECI = ES.CODESPECI
               LEFT JOIN dbo.INPROFSAL AS PS  ON AGA.CODPROSAL = PS.CODPROSAL
               INNER JOIN dbo.AGACTIMED AS AGAC  ON AGA.CODACTMED = AGAC.CODACTMED
               INNER JOIN dbo.INENTIDAD AS EN  ON P.CODENTIDA = EN.CODENTIDA
			   INNER JOIN dbo.INUBICACI AS UBI  ON P.AUUBICACI=UBI.AUUBICACI
			   INNER JOIN dbo.INMUNICIP AS MUN  ON UBI.DEPMUNCOD=MUN.DEPMUNCOD
               LEFT OUTER JOIN Contract.CUPSEntity AS CupsE  ON CupsE.Code = AGAC.CODSERIPS		--OJO ES LO NUEVO 18/02/2019 CODIGOS CON PUNTO
               OUTER APPLY
          (
              SELECT TOP 1 *
              FROM PM
              WHERE CupsE.RIPSCode = PM.CodProcMenor
                    AND CAST(AGA.FECHORAIN AS DATE) = PM.FechaProcMenor
                    AND AGA.IPCODPACI = PM.IdPcteProcMenor
          ) AS PM		--MODIFICADO EL 19/02/2019 CON LA FINALIDAD DE CORREGIR REGISTROS DOBLES DE AGENDAMIENTO
               OUTER APPLY
          (
              SELECT TOP 1 F2.FechaFactura
              FROM #F2 F2
              WHERE AGA.IPCODPACI = F2.PatientCode
                    AND CAST(F2.FechaFactura AS DATE) = CAST(AGA.FECHORAIN AS DATE)
          ) AS F2
               OUTER APPLY
          (
              SELECT TOP 1 CAST(HC.FECHISPAC AS DATE) AS FechaHC, 
                           COUNT(*) OVER(PARTITION BY HC.IPCODPACI, 
                                                      CAST(HC.FECHISPAC AS DATE)) AS NumeroAnotacionesHC
              FROM dbo.HCHISPACA AS HC
              WHERE AGA.IPCODPACI = HC.IPCODPACI
                    AND CAST(HC.FECHISPAC AS DATE) = CAST(AGA.FECHORAIN AS DATE)
          ) AS H
               OUTER APPLY
          (
              SELECT TOP 1 F.Factura AS NumFact, 
                           F.EntidadAdministradora, 
                           F.CUPS AS CUPSfact, 
                           F.[Descripcion CUPS] AS DescripcionCUPSfact, 
                           F.CentroCosto, 
                           F.CodigoMedico AS CodMDfact, 
                           F.NombreMedico AS MDfact, 
                           F.ValorTotal
              FROM #F F
              WHERE AGA.IPCODPACI = F.Identificación
                    AND CAST(F.FechaFactura AS DATE) = CAST(AGA.FECHORAIN AS DATE)
                    --	AND (CAST(F.FechaOrden AS DATE)=CAST(AGA.FECHORAIN AS DATE)		--24/10/2019 SE MODIFICÓ F.FechaOrden POR F.FechaFactura
                    AND (AGAC.CODSERIPS = F.CUPS
                         OR CupsE.RIPSCode = F.CUPS)
          ) AS F
          WHERE AGA.FECHORAIN >= @fechaInicial
                AND AGA.FECHORAIN < @fechaFinal;
 --               AND AGA.CODESTCIT <> '4';				--07/06/2022 Maye me solicitó dejar ver las canceladas

	DROP TABLE IF EXISTS #F;
	DROP TABLE IF EXISTS #F2;
    RETURN 0;
