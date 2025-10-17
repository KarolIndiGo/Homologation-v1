-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: HDSAP_COSTOSINASISTENCIAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE PROCEDURE [Report].[HDSAP_COSTOSINASISTENCIAS]  
    @FechaIni AS datetime,
	@FechaFin AS datetime
AS
WITH CTE
AS
(
SELECT AGA.CODESPECI AS CodEspecialidadAgenda,ES.DESESPECI AS EspecialidadAgenda, 
	AGAC.DESACTMED AS ActividadMedica, AGAC.CODSERIPS AS CodActivMedica, 
	CASE AGA.CODESTCIT WHEN 0 THEN 'Asignada' WHEN 1 THEN 'Cumplida'
	WHEN 2 THEN 'Incumplida' WHEN 3 THEN 'PreAsignada'	WHEN 4 THEN 'Cancelada' END AS 'EstadoCita',
	COUNT(*) AS Cuenta
FROM dbo.AGASICITA AS AGA 
		INNER JOIN dbo.INPACIENT AS P ON AGA.IPCODPACI=P.IPCODPACI
		INNER JOIN dbo.INESPECIA AS ES ON AGA.CODESPECI=ES.CODESPECI
		INNER JOIN dbo.INPROFSAL AS PS ON AGA.CODPROSAL = PS.CODPROSAL
		INNER JOIN dbo.AGACTIMED AS AGAC ON AGA.CODACTMED = AGAC.CODACTMED
		INNER JOIN dbo.INENTIDAD AS EN ON P.CODENTIDA=EN.CODENTIDA
		LEFT OUTER JOIN Contract.CUPSEntity AS CupsE on CupsE.Code=AGAC.CODSERIPS		--OJO ES LO NUEVO 18/02/2019 CODIGOS CON PUNTO
		OUTER APPLY (SELECT TOP 1 CAST(HC.FECHISPAC AS date) AS FechaHC, 
					COUNT(*) OVER(PARTITION BY HC.IPCODPACI,CAST(HC.FECHISPAC AS date)) AS NumeroAnotacionesHC 
					FROM dbo.HCHISPACA AS HC 
					WHERE AGA.IPCODPACI=HC.IPCODPACI AND CAST(HC.FECHISPAC AS date)=CAST(AGA.FECHORAIN AS date) 
					) AS H

	WHERE AGA.FECHORAIN>=@FechaIni AND AGA.FECHORAIN<@FechaFin AND AGA.CODESTCIT<>4
		AND AGA.CODESPECI<>'154' AND AGA.CODESPECI<>'002'
	GROUP BY AGA.CODESPECI, ES.DESESPECI, AGAC.DESACTMED, AGAC.CODSERIPS, AGA.CODESTCIT
),
CTE2
AS
(
SELECT CodEspecialidadAgenda, EspecialidadAgenda, ActividadMedica, CodActivMedica,
	CASE WHEN EstadoCita='Cumplida' THEN Cuenta ELSE 0 END AS Cumplida,
	CASE WHEN EstadoCita='Incumplida' THEN Cuenta ELSE 0 END AS Incumplida
FROM CTE
),
CTE3
AS
(
SELECT  CodEspecialidadAgenda, EspecialidadAgenda, ActividadMedica, CodActivMedica, 
	SUM(Cumplida) AS Cumplida, SUM(Incumplida) AS Incumplida,
	SUM(Cumplida) + SUM(Incumplida) AS TotalActividad
FROM CTE2
GROUP BY  CodEspecialidadAgenda, EspecialidadAgenda, ActividadMedica, CodActivMedica
),
F
AS
(
SELECT  CUPS.Code AS CUPS, dos.InvoicedQuantity AS Cantidad, 
		CASE WHEN dq.TotalSalesPrice IS NULL THEN DF.GrandTotalSalesPrice ELSE dq.TotalSalesPrice END AS ValorTotal,
		DATENAME(MONTH,F.InvoiceDate) AS MesFactura
FROM Billing.Invoice AS F  INNER JOIN
                         Billing.InvoiceDetail AS DF  ON DF.InvoiceId = F.Id INNER JOIN
                         Security.[User] AS u  ON u.UserCode = F.InvoicedUser INNER JOIN
                         Security.Person AS per  ON per.Id = u.IdPerson INNER JOIN
                         dbo.ADINGRESO AS ing  ON ing.NUMINGRES = F.AdmissionNumber INNER JOIN
                         dbo.INPACIENT AS P  ON P.IPCODPACI = F.PatientCode INNER JOIN
                         Billing.ServiceOrderDetail AS dos  ON dos.Id = DF.ServiceOrderDetailId INNER JOIN
                         Common.ThirdParty AS t  ON t.Id = F.ThirdPartyId INNER JOIN
                         Contract.CareGroup AS ga  ON ga.Id = F.CareGroupId left JOIN
                         Contract.HealthAdministrator AS ea  ON ea.Id = F.HealthAdministratorId INNER JOIN
                         Billing.InvoiceCategories AS cat  ON cat.Id = F.InvoiceCategoryId LEFT OUTER JOIN
                         Contract.IPSService AS ServiciosIPS  ON ServiciosIPS.Id = dos.IPSServiceId LEFT OUTER JOIN
                         Contract.SurgicalGroup AS GQ  ON ServiciosIPS.SurgicalGroupId = GQ.Id LEFT OUTER JOIN
                         Inventory.InventoryProduct AS pr  ON pr.Id = dos.ProductId LEFT OUTER JOIN
                         dbo.INPROFSAL AS med  ON med.CODPROSAL = dos.PerformsHealthProfessionalCode LEFT OUTER JOIN
                         dbo.INESPECIA AS espmed  ON espmed.CODESPECI = med.CODESPEC1 LEFT OUTER JOIN
                         dbo.INDIAGNOS AS diag  ON diag.CODDIAGNO = ing.CODDIAEGR LEFT OUTER JOIN
                         dbo.HCREGEGRE AS salida  ON salida.NUMINGRES = F.AdmissionNumber LEFT OUTER JOIN
                         Billing.ServiceOrderDetailSurgical AS dq  ON dq.ServiceOrderDetailId = dos.Id AND dq.OnlyMedicalFees = '0' LEFT OUTER JOIN
                         dbo.INPROFSAL AS medqx  ON medqx.CODPROSAL = dq.PerformsHealthProfessionalCode LEFT OUTER JOIN
                         dbo.INESPECIA AS espqx  ON espqx.CODESPECI = medqx.CODESPEC1 LEFT OUTER JOIN
                         Contract.IPSService AS ServiciosIPSQ  ON ServiciosIPSQ.Id = dq.IPSServiceId LEFT OUTER JOIN
                         Payroll.FunctionalUnit AS UF  ON UF.Id = dos.PerformsFunctionalUnitId LEFT OUTER JOIN
                         Billing.ServiceOrder AS os  ON os.Id = dos.ServiceOrderId LEFT OUTER JOIN
                         Contract.CUPSEntity AS CUPS  ON CUPS.Id = dos.CUPSEntityId LEFT OUTER JOIN
                         Billing.BillingGroup AS gf  ON gf.Id = CUPS.BillingGroupId LEFT OUTER JOIN
                         dbo.INUBICACI AS BB  ON BB.AUUBICACI = P.AUUBICACI LEFT OUTER JOIN
                         dbo.INMUNICIP AS EE  ON EE.DEPMUNCOD = BB.DEPMUNCOD LEFT OUTER JOIN
                         Payroll.CostCenter AS cc  ON dos.CostCenterId = cc.Id
WHERE  (F.Status = '1') AND (ing.CODCENATE = '001') AND (dos.IsDelete = '0') AND (dos.IsDelete = '0') 
		AND (F.DocumentType IN ('1', '2', '3', '4', '5', '6', '7'))
		AND cc.Code IN ('2001','2002','3002','3003','3004') AND F.InvoiceDate>=@FechaIni AND F.InvoiceDate<@FechaFin 
),
F2
AS
(
SELECT RTRIM([CUPS]) AS CUPS, CAST(SUM(ValorTotal)/SUM(Cantidad) AS numeric(12,0)) AS ValorPromedio
FROM F
WHERE ValorTotal>0
GROUP BY CUPS
)
SELECT CAST(ROW_NUMBER() OVER(ORDER BY CodEspecialidadAgenda, ActividadMedica) AS int) AS Cons, 
	CodEspecialidadAgenda AS CodEsp, EspecialidadAgenda, ActividadMedica, CodActivMedica, 
	Cumplida, Incumplida, TotalActividad, 
	CAST(CAST(Incumplida AS numeric(12,1))/CAST(TotalActividad AS numeric(12,1)) AS numeric(3,2)) AS PorcInasis,
	CAST((SUM(Incumplida) OVER(PARTITION BY CodEspecialidadAgenda) * 1.0)/(SUM(Cumplida+Incumplida) 
		OVER(PARTITION BY CodEspecialidadAgenda) * 1.0) AS numeric(3,2)) AS PorcInasEsp,
	Incumplida * F2.ValorPromedio AS FactPerdidaAct,
	SUM(Incumplida * F2.ValorPromedio) OVER(PARTITION BY CodEspecialidadAgenda) AS FactPerdEsp,
	SUM(Incumplida * F2.ValorPromedio) OVER() AS FactPerdTot
FROM CTE3 AS C LEFT OUTER JOIN F2 ON C.CodActivMedica=F2.CUPS
ORDER BY CodEspecialidadAgenda, ActividadMedica;
