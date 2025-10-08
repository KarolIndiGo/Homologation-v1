-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_AD_INVENTORY_DISPENSACION_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_AD_INVENTORY_DISPENSACION_PB as

SELECT 
DISTINCT MF.Id,
            IIF(MF.IPSCode = '', '900622551 - JERSALUD SAS', MF.IPSCode) AS IPS,
			case when MF.IPSCode like '%900622551%' or MF.IPSCode='' then 'Red Interna'  else 'Red Externa' end AS Red,
            MF.Number AS Formula, 
            MF.Id AS Id_Formula, 
            MF.PatientCode AS Identificacion_Paciente, 
			--DFA.invoiceid,
             
            TP.Name AS TipoProducto, 
            ISNULL(M.Code, ins.Code) AS Cod_Medicamento_Insumo, 
            ISNULL(M.Name, ins.SupplieName) AS Medicamento_Insumo, 
            P.Code AS CUM, 
            P.Name AS Producto, 
            P.CodeAlternativeTwo,
            
            DFA.InvoicedQuantity AS CantidadFactura, 
			--Esp.DeliveryQuantity AS CantidadFactura,
			
            DFA.TotalSalesPrice AS ValorUnitario, 
            DFA.GrandTotalSalesPrice AS ValorTotal, 
            P.ProductCost AS CostoPromedioActual, 
            DDIS.AverageCost AS CostoPromedioVenta, 
            DDIS.AverageCost * DFA.InvoicedQuantity AS CostoPromedioTotal, 
           --  DDIS.AverageCost * Esp.DeliveryQuantity AS CostoPromedioTotal, 
			--	Esp.DeliveryQuantity,
            MF.CreationDate AS FechaRegistro,
            CASE MF.IsManual
                WHEN 0
                THEN 'Automatica'
                WHEN 1
                THEN 'Manual'
            END AS TipoDispensacion, 
            MF.Date AS Fecha_Dispensacion, 
            
            GA.Name AS Grupo_Atencion, 
            GF.Code AS Codigo_Grupo_Farmacologico, 
            GF.Name AS Grupo_Farmacologico, 
            P.Presentation,
           
            G.Name AS Grupo, 
            
            Esp.DESESPECI AS Especialidad,
			Esp.HealthProfessionalNit as CodMedico,
			MF.FunctionalUnidCode,
			--CASE WHEN MF.FunctionalUnidCode = 'B00009' THEN 'TUNJA'
			--	 WHEN MF.FunctionalUnidCode = 'B00010' THEN 'DUITAMA'
			--	 WHEN MF.FunctionalUnidCode = 'B00011' THEN 'SOGAMOSO'
			--	 WHEN MF.FunctionalUnidCode = 'B00012' THEN 'CHIQUINQUIRA'
			--	 WHEN MF.FunctionalUnidCode = 'B00013' THEN 'GARAGOA'
			--	 WHEN MF.FunctionalUnidCode = 'B00014' THEN 'GUATEQUE'
			--	 WHEN MF.FunctionalUnidCode = 'B00015' THEN 'SOATA'
			--	 WHEN MF.FunctionalUnidCode = 'B00016' THEN 'MONIQUIRA'
			--	 WHEN MF.FunctionalUnidCode = 'CAS004' THEN 'VILLANUEVA'
			--	 WHEN MF.FunctionalUnidCode = 'MET006' THEN 'VILLAVICENCIO'
			--	 WHEN MF.FunctionalUnidCode = 'MET007' THEN 'ACACIAS'
			--	 WHEN MF.FunctionalUnidCode = 'MET008' THEN 'GRANADA'
			--	 WHEN MF.FunctionalUnidCode = 'MET009' THEN 'PUERTO LOPEZ'
			--	 WHEN MF.FunctionalUnidCode = 'MET010' THEN 'PUERTO GAITAN'
			--	 WHEN MF.FunctionalUnidCode = 'YOP002' THEN 'YOPAL' END AS Sede

			op.UnitName as sede,
			CASE WHEN op.Id IN (8,9,10,11,12,13,14,15,24) THEN 'Boyaca'
     WHEN op.Id IN (16,17,18,19,20) THEN 'Meta'
	 WHEN op.Id IN (22,27) THEN 'Yopal' end as Regional
     FROM INDIGO031.Inventory.MedicalFormula AS MF
          JOIN INDIGO031.Inventory.MedicalFormulaPharmaceuticalDispensing AS DIF  ON DIF.MedicalFormulaId = MF.Id
          JOIN INDIGO031.Inventory.PharmaceuticalDispensing AS DIS  ON DIF.PharmaceuticalDispensingId = DIS.Id
		  jOIN INDIGO031.Common.OperatingUnit as op on op.Id=DIS.OperatingUnitId 
          JOIN INDIGO031.Inventory.PharmaceuticalDispensingDetail AS DDIS  ON DDIS.PharmaceuticalDispensingId = DIS.Id
          JOIN INDIGO031.Billing.ServiceOrder AS O  ON DDIS.PharmaceuticalDispensingId = O.EntityId
                                                                           AND O.Status = 1
          JOIN INDIGO031.Billing.ServiceOrderDetail AS DO  ON DO.ServiceOrderId = O.Id
                                                                                  AND DDIS.ProductId = DO.ProductId
          JOIN INDIGO031.Billing.InvoiceDetail AS DFA  ON DFA.ServiceOrderDetailId = DO.Id 
		  JOIN INDIGO031.Billing.Invoice AS INV ON INV.Id=DFA.InvoiceId AND INV.Status=1
		
          JOIN INDIGO031.Contract.CareGroup AS GA  ON GA.Id = DO.CareGroupId
		  LEFT OUTER JOIN INDIGO031.dbo.ADINGRESO AS ING  ON ING.NUMINGRES=O.AdmissionNumber
          
          JOIN INDIGO031.Inventory.InventoryProduct AS P  ON DO.ProductId = P.Id
          JOIN INDIGO031.Inventory.ProductType AS TP ON TP.Code = P.ProductTypeId
          LEFT JOIN INDIGO031.Inventory.ATC AS M  ON P.ATCId = M.Id
          LEFT JOIN INDIGO031.Inventory.DCI AS dci  ON M.DCIId = dci.Id
          LEFT JOIN INDIGO031.Inventory.PharmacologicalGroup AS GF  ON M.PharmacologicalGroupId = GF.Id
          LEFT JOIN INDIGO031.Inventory.InventorySupplie AS ins ON ins.Id = P.SupplieId
          LEFT JOIN INDIGO031.Inventory.ProductGroup AS G ON G.Id = P.ProductGroupId
		      LEFT JOIN
     (
         SELECT FD.MedicalFormulaId, 
                FD.AdmissionNumber, 
                CASE WHEN E.DESESPECI IS NULL THEN E1.DESESPECI ELSE E.DESESPECI END AS DESESPECI,
				FD.HealthProfessionalNit --, 
			--	fd.DeliveryQuantity
         FROM INDIGO031.Inventory.MedicalFormulaDetail FD 
		 JOIN INDIGO031.Inventory.MedicalFormula AS F ON F.Id=FD.MedicalFormulaId
              LEFT JOIN INDIGO031.dbo.INPROFSAL M ON FD.HealthProfessionalNit = M.CODPROSAL
              LEFT JOIN INDIGO031.dbo.INESPECIA E ON M.CODESPEC1 = E.CODESPECI
			   LEFT JOIN INDIGO031.dbo.INESPECIA E1 ON E1.CODESPECI= substring(F.Number,1,3) 
			  WHERE YEAR(F.CreationDate)>='2022' 
         GROUP BY FD.MedicalFormulaId, 
                  FD.AdmissionNumber, 
                  E.DESESPECI,
				  E1.DESESPECI,
				  FD.HealthProfessionalNit--, 
				--fd.DeliveryQuantity 
				) AS Esp ON Esp.MedicalFormulaId = MF.Id
          
          
  
     WHERE   DIS.Status<>3 and ING.IESTADOIN<>'A' and (MF.CreationDate)>='01-01-2022' 
	-- and MF.Id ='487904'