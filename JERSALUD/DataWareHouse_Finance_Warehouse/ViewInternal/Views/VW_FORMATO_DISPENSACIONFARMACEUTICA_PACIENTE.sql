-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_FORMATO_DISPENSACIONFARMACEUTICA_PACIENTE
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VW_FORMATO_DISPENSACIONFARMACEUTICA_PACIENTE
AS

SELECT 
DISTINCT
'' as  [Nombre Operador],	'' as [NIT Operador],	--'' as [Modalidad Contratacion],	'' as [Tipo de medicamento],
'' as [Nit IPS (Punto dispensación)], CEN.NOMCENATE as [Nombre IPS (Punto dispensación)], case    WHEN CEN.CODCENATE IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN CEN.CODCENATE IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN CEN.CODCENATE IN (015,016,019,020)
                THEN 'CASANARE'
              END  as	[Departamento Dispensación], SUBSTRING(CEN.NOMCENATE, LEN('Jersalud ') + 1, LEN(CEN.NOMCENATE)) as 	[Ciudad Dispensación],
'' as [Modalidad (Capita/Evento)],
	
 CASE IPTIPODOC WHEN 1 THEN 'CC' WHEN 2 THEN 'CE' WHEN 3 THEN 'TI' WHEN 4 THEN 'RC' WHEN 5 THEN 'PA' WHEN 6 THEN 'AS' WHEN 7 THEN 'MS' WHEN 8 THEN 'NU' 
			 when 9 then  'CN'  			 when 10 then 'CD' 			 when 11 then 'SC' 			 when 12 then 'PE'  			 when 13 then 'PT' 
			 when 14 then 'DE'  			 when 15 then 'SI' 	 END AS [Tipo identificacion], 
F.PatientCode as 	[Número identificacion],-- CASE WHEN IPSEXOPAC = '1' THEN 'M' WHEN IPSEXOPAC = '2' THEN 'F' END  as [Género (F/M)],
 
 pr.Code as [CUM], pr.CodeAlternative as [CODIGO ATC], pr.Description as [Descripción medicamento (Nombre generico DCI, Concentración y Forma farmacéutica)] ,


DFA.TotalSalesPrice as [Valor unitario],
hc.DESVIAADM as [Vía administración], hc.FRECUENCI as [Frecuencia], hc.VALDURFIJ as [Duracion tratamiento (En dias)], lote.BatchCode as	Lote,
 lote.ExpirationDate as [Fecha Vencimiento], 
 MFD.RequestQuantity as [Cantidad Prescrita total], MFD.RequestQuantity as 	[Cantidad Solicitada (Mes)], DeliveryQuantity as	[Cantidad entregada (Mes)],	
 DFA.TotalSalesPrice as [Valor unitario del medicamento ($)],


hc.CODDIAGNO as	[Codigo diagnostico Principal], hc.NOMDIAGNO as [Descripcion Diagnostico principal] ,
hc.FECINIDOS AS [Fecha prescripcion (fecha de la formula)],-- '' AS	[Fecha autorización entrega],
F.Date AS [Fecha Solicitud  (fecha solicitud al servicio farmaceutico)], DIS.ConfirmationDate AS [Fecha entrega],  '' as [Fecha Entrega del Pendiente],

F.Number AS [Número fórmula],
'' as [Motivo no entrega],
'' AS [Se entrego en el domicilio ?]

FROM [INDIGO031].[Inventory].[MedicalFormula] AS F
JOIN [INDIGO031].[Inventory].[MedicalFormulaDetail] AS MFD ON MFD.MedicalFormulaId=F.Id
JOIN [INDIGO031].[Inventory].[MedicalFormulaPharmaceuticalDispensing] AS DIF  ON DIF.MedicalFormulaId = F.Id
JOIN [INDIGO031].[Inventory].[ATC] AS M ON MFD.ProductCode=M.Code
JOIN [INDIGO031].[Inventory].[InventoryProduct] AS pr  ON pr.ATCId=M.Id
JOIN [INDIGO031].[Inventory].[PharmaceuticalDispensing] AS DIS  ON DIF.PharmaceuticalDispensingId = DIS.Id
JOIN [INDIGO031].[Inventory].[PharmaceuticalDispensingDetail] AS DDIS  ON DDIS.PharmaceuticalDispensingId = DIS.Id AND DDIS.ProductId=pr.Id
	  
LEFT JOIN [INDIGO031].[Inventory].[PharmaceuticalDispensingDetailBatchSerial] AS bs  ON bs.PharmaceuticalDispensingDetailId = DDIS.Id 
LEFT OUTER JOIN [INDIGO031].[Inventory].[PhysicalInventory] as ph  ON ph.Id = bs.PhysicalInventoryId 
LEFT OUTER JOIN [INDIGO031].[Inventory].[BatchSerial] as lote  ON lote.Id = ph.BatchSerialId
JOIN [INDIGO031].[dbo].[ADCENATEN] AS CEN ON CEN.CODCENATE=F.CareCenterCode

LEFT JOIN [INDIGO031].[dbo].[INPACIENT] AS pa on pa.IPCODPACI=F.PatientCode
LEFT OUTER JOIN [INDIGO031].[dbo].[INUBICACI] AS u  ON u.AUUBICACI = pa.AUUBICACI
LEFT OUTER JOIN [INDIGO031].[dbo].[INMUNICIP] AS ma  ON ma.DEPMUNCOD = u.DEPMUNCOD
LEFT OUTER JOIN [INDIGO031].[dbo].[INDEPARTA] AS DEP  ON ma.DEPCODIGO = DEP.depcodigo 

LEFT JOIN [INDIGO031].[Inventory].[DCI] AS dci ON M.DCIId=dci.Id
 left JOIN [INDIGO031].[Billing].[ServiceOrder] AS O  ON DDIS.PharmaceuticalDispensingId = O.EntityId
                                                                           AND O.Status = 1
 left JOIN [INDIGO031].[Billing].[ServiceOrderDetail] AS DO  ON DO.ServiceOrderId = O.Id
                                                                                  AND DDIS.ProductId = DO.ProductId
          JOIN [INDIGO031].[Billing].[InvoiceDetail] AS DFA  ON DFA.ServiceOrderDetailId = DO.Id
left join (
SELECT A.IPCODPACI, CODPRODUC, via.DESVIAADM, FRECUENCI, A.CODDIAGNO, NOMDIAGNO,VALDURFIJ, A.FECINIDOS,
concat(MONTH(A.FECINIDOS),'/',YEAR(A.FECINIDOS)) as Fecha, tp.Nit, tp.Name
FROM [INDIGO031].[dbo].[HCPRESCRA] AS A 
inner join [INDIGO031].[dbo].[HCVIAADMI] as via on via.CODVIAADM=A.CODVIAADM
inner join [INDIGO031].[dbo].[INDIAGNOS] as dx on dx.CODDIAGNO=A.CODDIAGNO
inner join [INDIGO031].[dbo].[ADINGRESO] as i on i.NUMINGRES=A.NUMINGRES
inner join [INDIGO031].[Contract].[HealthAdministrator] as ha on ha.Id=i.GENCONENTITY
inner join [INDIGO031].[Common].[ThirdParty] as tp on tp.Id=ha.ThirdPartyId
WHERE FECINIDOS>='11-01-2024' ) as hc on hc.IPCODPACI=F.PatientCode AND hc.Fecha=concat(MONTH(F.Date),'/',YEAR(F.Date)) AND hc.CODPRODUC=MFD.ProductCode

WHERE F.IsManual=1 AND (F.CreationDate)>='11-01-2024' --and MFD.PendingQuantity>0

