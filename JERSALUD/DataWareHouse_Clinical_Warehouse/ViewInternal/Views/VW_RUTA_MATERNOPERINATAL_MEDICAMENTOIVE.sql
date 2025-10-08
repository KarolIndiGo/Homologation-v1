-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_RUTA_MATERNOPERINATAL_MEDICAMENTOIVE
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[VW_RUTA_MATERNOPERINATAL_MEDICAMENTOIVE] as
SELECT DISTINCT  
    CASE
        WHEN CA.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017,021) THEN 'BOYACA'
        WHEN CA.CODCENATE IN(010, 011, 012, 013, 014,018) THEN 'META'
        WHEN CA.CODCENATE IN (015,016,019,020) THEN 'CASANARE'
    END AS Regional,  
    ING.IFECHAING AS FECHA_INGRESO, 
    ING.NUMINGRES AS INGRESO, 
    LTRIM(RTRIM(CA.NOMCENATE)) AS CENTRO_ATENCION, 
    U.UFUDESCRI AS UNIDAD_FUNCIONAL,
	ING.IPCODPACI AS IDENTIFICACION_PACIENTE,
    P.IPNOMCOMP AS NOMBRE_PACIENTE, 
    pr.Code AS CUPS, 
    pr.Description AS CUPS_DESCRIPCION,
	F.InvoiceNumber AS FACTURA, 
    CASE F.Status WHEN 1 THEN 'Facturado' WHEN 2 THEN 'Anulado' END AS Estado_Factura, 
    FD.InvoicedQuantity AS CANTIDAD, 
	FD.TotalSalesPrice AS VALOR_UNITARIO, 
    F.TotalInvoice AS TOTAL_FACTURA, 
	F.InvoiceDate AS FECHA_CIERRE, 
	CA.NOMCENATE AS Sede, 
    GA.Code AS Cod_Grupo_Atencion , 
    GA.Name AS Grupo_Atencion,
	/*ING.CODPROING AS [Codigo Profesional Ingreso], (SELECT NOMMEDICO FROM INDIGO031.dbo.INPROFSAL WHERE CODPROSAL=ING.CODPROING) AS Profesional_Ingreso,*/
	(SELECT NOMMEDICO 
     FROM INDIGO031.dbo.INPROFSAL 
     WHERE CODPROSAL=SOD.PerformsHealthProfessionalCode) AS Profesional_Factura,
	--CU.Number AS Cuenta, CU.Name AS CuentaContable,--,concepto facturacion
	P.IPFECNACI AS FechaNacimiento_Paciente, 
	(cast(datediff(dd,P.IPFECNACI,GETDATE()) / 365.25 as int)) as Edad,
	(SELECT TOP 1 DIAG.CODDIAGNO 
     FROM INDIGO031.dbo.INDIAGNOP AS DIAG  
     WHERE DIAG.NUMINGRES=ING.NUMINGRES AND DIAG.CODDIAPRI=1) AS DX_Principal_HC, 
	CASE WHEN DX.CODDIAGNO IS NULL THEN F.OutputDiagnosis ELSE DX.CODDIAGNO END AS DX_Cierre_Ing, 
	
	--CASE CUPS.RIPSConcept ...
	DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) AS EdadEnAtencion, 
	CASE
		WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '0' AND '5' THEN 'Primera Infancia'
		WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '6' AND '11' THEN 'Infancia'
		WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '12' AND '17' THEN 'Adolecencia'
		WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '18' AND '28' THEN 'Juventud'
		WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) BETWEEN '29' AND '59' THEN 'Adultez'
		WHEN cast(DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) as int) >= '60' THEN 'Vejez'
	END AS Ciclo_Vida,
	SOD.ServiceDate as FechaPrestacionServicio,  
    CASE WHEN IPSEXOPAC = '1' THEN 'M' WHEN IPSEXOPAC = '2' THEN 'F' END  as [Género (F/M)],
	case  
        when pr.Code in (select Codigo from INDIGO031.ViewInternal.InyectableTrimestral
						 union all 
						 select Codigo from INDIGO031.ViewInternal.[ImplantesSubderm]) then 'InyectableTrimestralSubderm' 
		when pr.Code in (select Codigo from INDIGO031.ViewInternal.InyectableTrimestral) then 'InyectableTrimestral' 
	    when pr.Code in (select Codigo from INDIGO031.ViewInternal.InyectableMensual
						 union all 
						 select Codigo from INDIGO031.ViewInternal.OralesCombinados) then 'InyectableMensualOralCombinado' 
		when pr.Code in (select Codigo from INDIGO031.ViewInternal.InyectableMensual) then 'InyectableMensual' 
		when pr.Code in (select Codigo from INDIGO031.ViewInternal.OralesCombinados) then 'OralesCombinados'
		when pr.Code in (select Codigo from INDIGO031.[ViewInternal].[OralesProgestina]) then 'OralesProgestina'
		when pr.Code in (select Codigo from INDIGO031.[ViewInternal].[OralesEmergencia]) then 'OralesEmergencia'
		when pr.Code in (select Codigo from INDIGO031.ViewInternal.DIU) then 'DIU'
		when pr.Code in (select Codigo from INDIGO031.[ViewInternal].[ImplantesSubderm]) then 'ImplantesSubderm'
		when pr.Code in (select Codigo from INDIGO031.[ViewInternal].[ParchesTransderm]) then 'ParchesTransderm'
		when pr.Code in (select Codigo from INDIGO031.[ViewInternal].[AnilloVaginal]) then 'AnilloVaginal'
	end as Indicador , 
    'Planificación' as Grupo
	--DIAG.CODDIAGNO AS DX_Principal
  FROM INDIGO031.Billing.Invoice AS F 
	   INNER JOIN INDIGO031.Billing.InvoiceDetail AS FD  ON F.Id=FD.InvoiceId /*AND F.DocumentType=5 AND F.Status=1*/
	   INNER JOIN INDIGO031.Billing.ServiceOrderDetail AS SOD  ON FD.ServiceOrderDetailId=SOD.Id
	   INNER JOIN INDIGO031.Billing.ServiceOrder AS SO  ON SOD.ServiceOrderId=SO.Id
	   INNER JOIN INDIGO031.Inventory.InventoryProduct AS pr  ON pr.Id=SOD.ProductId
	   INNER JOIN INDIGO031.Inventory.ATC AS ATC ON ATC.Id=pr.ATCId 
	   INNER JOIN INDIGO031.dbo.ADINGRESO AS ING  ON ING.NUMINGRES=SO.AdmissionNumber
	   INNER JOIN INDIGO031.Contract.CareGroup AS GA  ON GA.Id=F.CareGroupId
       INNER JOIN INDIGO031.dbo.ADCENATEN AS CA  ON CA.CODCENATE = ING.CODCENATE
	   INNER JOIN INDIGO031.dbo.INUNIFUNC AS U  ON U.UFUCODIGO = ING.UFUCODIGO
	   INNER JOIN INDIGO031.dbo.INPACIENT AS P  ON P.IPCODPACI = ING.IPCODPACI
	   LEFT JOIN INDIGO031.Common.ThirdParty AS T  on F.InvoicedUser = T.Nit
	   JOIN INDIGO031.dbo.SEGusuaru AS us  on ING.CODUSUCRE = us.CODUSUARI
	   LEFT JOIN (
            SELECT A.IPCODPACI, CODPRODUC, A.CODDIAGNO, NOMDIAGNO, A.FECINIDOS,
                   concat(MONTH(A.FECINIDOS),'/',YEAR(A.FECINIDOS)) as Fecha, tp.Nit, tp.Name
            FROM INDIGO031.dbo.HCPRESCRA AS A 
            --inner join INDIGO031.dbo.HCVIAADMI as via on via.CODVIAADM=a.CODVIAADM
            inner join INDIGO031.dbo.INDIAGNOS as dx on dx.CODDIAGNO=A.CODDIAGNO
            inner join INDIGO031.dbo.ADINGRESO as i on i.NUMINGRES=A.NUMINGRES
            inner join INDIGO031.Contract.HealthAdministrator as ha on ha.Id=i.GENCONENTITY
            inner join INDIGO031.Common.ThirdParty as tp on tp.Id=ha.ThirdPartyId
            WHERE FECINIDOS>='01-01-2025' 
       ) AS DX 
       ON DX.IPCODPACI=F.PatientCode 
      AND DX.Fecha=concat(MONTH(SO.OrderDate),'/',YEAR(SO.OrderDate)) 
      AND DX.CODPRODUC=ATC.Code
WHERE  (SOD.ServiceDate) >= '01/01/2025' 
  and pr.Code in ('20010043-34','19914260-1')  
  and IPSEXOPAC=2  
  and DATEDIFF(year, P.IPFECNACI, ING.IFECHAING) between '14' and '49' 
  and F.Status=1

