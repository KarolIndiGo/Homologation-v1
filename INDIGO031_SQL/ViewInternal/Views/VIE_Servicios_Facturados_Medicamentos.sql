-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_Servicios_Facturados_Medicamentos
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VIE_Servicios_Facturados_Medicamentos] AS
----------ALTER VIEW VIE_Servicios_Facturados_Medicamentos_General
----AS
------select * from Billing.BillingGroup AS gf ON gf.Id = pr.BillingGroupId LEFT OUTER JOIN 
------SELECT * FROM Inventory.ProductGroup
--select * from dbo.ADINGRESO where NUMINGRES='3768933'

--select * from GeneralLedger.MainAccounts
--where id = 1015
SELECT  DISTINCT -- ROW_NUMBER() OVER(ORDER BY MF.Number ASC) AS Row#,
           --g.*,
		   
		   FA.AdmissionNumber, 
            FA.InvoiceNumber AS Factura,
            CASE FA.DocumentType
                WHEN 1
                THEN 'Factura EAPB con Contrato'
                WHEN 2
                THEN 'Factura EAPB Sin Contrato'
                WHEN 3
                THEN 'Factura Particular'
                WHEN 4
                THEN 'Factura Capitada'
                WHEN 5
                THEN 'Control de Capitacion'
                WHEN 6
                THEN 'Factura Basica'
                WHEN 7
                THEN 'Factura de Venta de Productos'
            END AS Tipo_Documento_Facturado, 
            IIF(MF.IPSCode = '', '900622551 - JERSALUD SAS', MF.IPSCode) AS IPS, 
            case when MF.IPSCode like '%900622551%' or MF.IPSCode='' then 'Red Interna'  else 'Red Externa' end AS Red,
            MF.Number AS Formula, 
            MF.ID AS Id_Formula, 
			CASE IPTIPODOC WHEN 1 THEN 'CC' WHEN 2 THEN 'CE' WHEN 3 THEN 'TI' WHEN 4 THEN 'RC' WHEN 5 THEN 'PA' WHEN 6 THEN 'AS' WHEN 7 THEN 'MS' WHEN 8 THEN 'NU' 
			 when 9 then  'CN' 
			 when 10 then 'CD' 
			 when 11 then 'SC' 
			 when 12 then 'PE'  
			 when 13 then 'PT' 
			 when 14 then 'DE'  
			 when 15 then 'SI' 
			 END AS TipoIdentificacion,
            MF.PatientCode AS Identificacion_Paciente, 
            MF.PatientName AS Nombre_Paciente, 
            TP.Name AS TipoProducto, 
            ISNULL(M.Code, ins.Code) AS Cod_Medicamento_Insumo, 
            ISNULL(M.Name, ins.SupplieName) AS Medicamento_Insumo, 
            P.Code AS CUM, 
            P.Name AS Producto, 
            P.CodeAlternativeTwo,
            CASE P.STATUS
                WHEN '1'
                THEN 'Activo'
                WHEN '0'
                THEN 'Inactivo'
            END AS Estado,
            CASE P.ProductControl
                WHEN '0'
                THEN 'No'
                WHEN '1'
                THEN 'Si'
            END AS [ProdControl],
            CASE ISNULL(M.HighCost, 0)
                WHEN 0
                THEN 'NO'
                WHEN 1
                THEN 'SI'
            END AS AltoCosto, 
            AL.Name AS Almacen, 
            DFA.InvoicedQuantity AS CantidadFactura, 
            DFA.TotalSalesPrice AS ValorUnitario, 
            DFA.GrandTotalSalesPrice AS ValorTotal, 
            P.ProductCost AS CostoPromedioActual, 
            DDIS.AverageCost AS CostoPromedioVenta, 
            DDIS.AverageCost * DFA.InvoicedQuantity AS CostoPromedioTotal, 
            FA.AdmissionNumber AS Ingreso, 
            FA.InvoiceDate AS FechaFactura, 
            MONTH(FA.InvoiceDate) AS MesFactura, 
            YEAR(FA.InvoiceDate) AS AñoFactura, 
            Per.FullName AS UsuarioFactura, 
            MF.CreationDate AS FechaRegistroDispensacion,
            CASE MF.IsManual
                WHEN 0
                THEN 'Automatica'
                WHEN 1
                THEN 'Manual'
            END AS TipoDispensacion, 
            MF.Date AS Fecha_Dispensacion, 
            MF.ModificationDate AS Fecha_Modificacion_Dispensacion, 
			GA.CODE AS	Cod_GrupoAtención,
            GA.Name AS Grupo_Atencion, 
			cc.contractname as Contrato,
            GF.Code AS Codigo_Grupo_Farmacologico, 
            GF.Name AS Grupo_Farmacologico, 
            P.Presentation,
            --D.Code AS Cod_Dpto, 
            D.Name AS Dpto, 
            --C.Code AS Cod_Municipo,
            C.Name AS Municipio, 
            UO.UnitName AS Unidad_Operativa, 
            G.Name AS Grupo, 
            DATEDIFF(DAY, MF.CreationDate, FA.InvoiceDate) AS DifDiasDispVSFact, 
            DATEDIFF(HOUR, MF.CreationDate, FA.InvoiceDate) AS DifHorasDispVSFact, 
            Esp.desespeci AS ProfesionOrdena, 
            dci.Code AS Codigo_DCI, 
            dci.Name AS DCI,
			CASE GA.LiquidationType
                WHEN 1
                THEN 'Evento Medicamentos'
                WHEN 2
                THEN 'Capitacion'
                WHEN 3
                THEN 'Factura Global'
                WHEN 4
                THEN 'Capitacion Global'
                WHEN 5
                THEN 'Pago Global Prospectivo - PGP'
            END AS Tipo_Liquidacion, 
			dx.CODDIAGNO as CIE10_Ingreso,
			dx.nomdiagno AS DxIngreso,
			o.CreationDate as CreacionOrdenServicio,
			AI.IFECHAING AS FechaIngreso,
			CEN.NOMCENATE AS 'Centro de Atencion',
			anu.AnnulmentDate AS [Fecha Anulacion Factura],
			Per2.Fullname AS [Usuario Anula],
			anu.DescriptionReversal AS [Descripcion Anulacion],
			--anu.ReversalReasonId AS [Razon Anulacion],
			anu.InvoiceNumber AS [Numero Factura Anulada]
			,CU.Number AS Cuenta_Venta
			,CU.NAME AS CuentaContable_Venta
			,UF.UFUDESCRI AS UnidadFuncional
				

   FROM Inventory.MedicalFormula AS MF WITH (NOLOCK)
          JOIN  Inventory.MedicalFormulaPharmaceuticalDispensing AS DIF WITH (NOLOCK) ON DIF.MedicalFormulaId = MF.Id
          JOIN  Inventory.PharmaceuticalDispensing AS DIS WITH (NOLOCK) ON DIF.PharmaceuticalDispensingId = DIS.Id
          JOIN Inventory.PharmaceuticalDispensingDetail AS DDIS WITH (NOLOCK) ON DDIS.PharmaceuticalDispensingId = DIS.Id
          JOIN Billing.ServiceOrder AS O WITH (NOLOCK) ON DDIS.PharmaceuticalDispensingId = O.EntityId
                                                                           AND o.STATUS = 1
          JOIN Billing.ServiceOrderDetail AS DO WITH (NOLOCK) ON DO.ServiceOrderId = O.Id
                                                                                  AND DDIS.ProductId = DO.ProductId
		  INNER JOIN dbo.ADINGRESO AS AI  ON AI.NUMINGRES=O.AdmissionNumber and ai.IFECHAING >= '01-01-2024 00:00:00'
		  INNER JOIN dbo.ADCENATEN AS CEN ON CEN.CODCENATE=MF.CareCenterCode
          JOIN Billing.InvoiceDetail AS DFA WITH (NOLOCK) ON DFA.ServiceOrderDetailId = DO.Id
          --JOIN Contract.CareGroup AS GA WITH (NOLOCK) ON GA.Id = DO.CareGroupId
          JOIN Billing.Invoice AS FA WITH (NOLOCK) ON DFA.InvoiceId = FA.Id AND FA.STATUS = 1 
		  JOIN Contract.CareGroup AS GA WITH (NOLOCK) ON GA.Id = FA.CareGroupId
          JOIN Inventory.InventoryProduct AS P WITH (NOLOCK) ON DO.ProductId = P.Id
          JOIN Inventory.ProductType AS TP WITH (NOLOCK) ON TP.Code = P.ProductTypeId
          LEFT JOIN Inventory.ATC AS M WITH (NOLOCK) ON P.ATCId = M.Id
		  LEFT JOIN DBO.INPACIENT AS PP WITH (NOLOCK) ON PP.IPCODPACI=MF.PatientCode
          LEFT JOIN Inventory.DCI AS dci WITH (NOLOCK) ON M.DCIId = dci.Id
          LEFT JOIN Inventory.PharmacologicalGroup AS GF WITH (NOLOCK) ON M.PharmacologicalGroupId = GF.Id
          LEFT JOIN inventory.InventorySupplie AS ins WITH (NOLOCK) ON ins.Id = P.SupplieId
          LEFT JOIN Inventory.ProductGroup AS G WITH (NOLOCK) ON G.Id = P.ProductGroupId
           LEFT JOIN Inventory.Warehouse AS AL WITH (NOLOCK) ON DDIS.WarehouseId = AL.Id
           LEFT JOIN [Security].[USER] AS U ON O.CreationUser = U.UserCode
           LEFT JOIN [Security].Person AS Per ON U.IdPerson = Per.Id
           LEFT JOIN [Security].PermissionCompany AS Perm ON Perm.IdUser = U.Id
                                                                               AND Perm.Permission = 1
                                                                               AND Perm.IdContainer = 109
           LEFT JOIN Common.OperatingUnit AS UO WITH (NOLOCK) ON UO.Id = Perm.IdOperatingUnitDefault
           LEFT JOIN Common.City AS C WITH (NOLOCK) ON C.Id = UO.IdCity
           LEFT JOIN Common.Department AS D WITH (NOLOCK) ON D.Id = C.DepartamentId
		   left outer join Contract.Contract as cc WITH (NOLOCK) on cc.id=ga.ContractId
          LEFT JOIN
     (
         SELECT FD.MedicalFormulaId, 
                fD.admissionnumber, 
                e.desespeci
      from   Inventory.MedicalFormulaDetail FD
              JOIN dbo.INPROFSAL M ON FD.HealthProfessionalCode = M.CODPROSAL
              JOIN dbo.INESPECIA E ON M.CODESPEC1 = E.CODESPECI
         GROUP BY FD.MedicalFormulaId, 
                  fD.admissionnumber, 
                  e.desespeci
     ) AS Esp ON Esp.MedicalFormulaId = MF.ID
	  LEFT OUTER JOIN 
	  dbo.INDIAGNOP AS Ing  ON Ing.numingres = o.admissionnumber AND ING.CODDIAPRI=1
          LEFT OUTER JOIN dbo.INDIAGNOS AS DX  ON DX.CODDIAGNO = Ing.CODDIAGNO

	  LEFT OUTER JOIN (
	  SELECT AdmissionNumber, AnnulmentDate, AnnulmentUser, DescriptionReversal, ReversalReasonId, InvoiceNumber
	  FROM Billing.Invoice
	   WHERE Status = '2' 
	  ) AS anu ON anu.AdmissionNumber = FA.AdmissionNumber

	  LEFT JOIN [Security].[USER] AS U2 ON anu.AnnulmentUser = U2.UserCode
           LEFT JOIN [Security].Person AS Per2 ON U2.IdPerson = Per2.Id
		   --LEFT JOIN Billing.BillingConcept AS CF  ON CUPS.BillingConceptId = CF.Id 
		   left JOIN GeneralLedger.MainAccounts AS CU  ON g.IncomeAccountId = CU.Id
		   LEFT JOIN dbo.INUNIFUNC AS UF  ON UF.UFUCODIGO = AI.UFUCODIGO
		   --LEFT JOIN (SELECT  B.ID AS IDCONCEPTO, M.Number, M.Name, B.CODE
					--FROM INDIGO031.Billing.BillingConceptAccount AS C WITH (NOLOCK)
					--INNER JOIN INDIGO031.Billing.BillingConcept AS B WITH (NOLOCK) ON B.ID=C.BillingConceptId
					--INNER JOIN INDIGO031.GeneralLedger.MainAccounts AS M WITH (NOLOCK) ON M.ID=C.EntityIncomeAccountId
					--GROUP BY B.ID, M.Number, M.Name, B.CODE) AS CCM ON CCM.IDCONCEPTO=CUPS.BillingConceptId

	  
     WHERE year(FA.InvoiceDate) >= '2024' --AND MF.IsManual=0 
	 --and FA.AdmissionNumber='198646'
	 --and FA.InvoiceDate >= DATEADD(MONTH, -4, GETDATE()) 
	 --and  fa.InvoiceNumber='JSV192133'

	 

	  --SELECT * FROM [ViewInternal].[VIE_Servicios_Facturados_Medicamentos]
	  --WHERE Ingreso='3768896'

	  --SELECT *  FROM Inventory.MedicalFormula
	  --WHERE PatientCode='8190296' AND id='1179373'--CreationDate
