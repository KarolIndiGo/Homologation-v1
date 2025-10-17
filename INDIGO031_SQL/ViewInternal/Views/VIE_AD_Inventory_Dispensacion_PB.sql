-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_AD_Inventory_Dispensacion_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VIE_AD_Inventory_Dispensacion_PB] as

SELECT 
DISTINCT mf.id,
            IIF(MF.IPSCode = '', '900622551 - JERSALUD SAS', MF.IPSCode) AS IPS,
			case when MF.IPSCode like '%900622551%' or MF.IPSCode='' then 'Red Interna'  else 'Red Externa' end AS Red,
            MF.Number AS Formula, 
            MF.ID AS Id_Formula, 
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
            
            Esp.desespeci AS Especialidad,
			ESP.HealthProfessionalNit as CodMedico,
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

			op.unitname as sede,
			CASE WHEN OP.ID IN (8,9,10,11,12,13,14,15,24) THEN 'Boyaca'
     WHEN OP.ID IN (16,17,18,19,20) THEN 'Meta'
	 WHEN OP.ID IN (22,27) THEN 'Yopal' end as Regional
     FROM Inventory.MedicalFormula AS MF
          JOIN Inventory.MedicalFormulaPharmaceuticalDispensing AS DIF  ON DIF.MedicalFormulaId = MF.Id
          JOIN Inventory.PharmaceuticalDispensing AS DIS  ON DIF.PharmaceuticalDispensingId = DIS.Id
		  jOIN Common.OperatingUnit as op on op.Id=dis.Operatingunitid 
          JOIN Inventory.PharmaceuticalDispensingDetail AS DDIS  ON DDIS.PharmaceuticalDispensingId = DIS.Id
          JOIN Billing.ServiceOrder AS O  ON DDIS.PharmaceuticalDispensingId = O.EntityId
                                                                           AND o.STATUS = 1
          JOIN Billing.ServiceOrderDetail AS DO  ON DO.ServiceOrderId = O.Id
                                                                                  AND DDIS.ProductId = DO.ProductId
          JOIN Billing.InvoiceDetail AS DFA  ON DFA.ServiceOrderDetailId = DO.Id 
		  JOIN Billing.Invoice AS INV ON INV.ID=DFA.InvoiceId AND INV.Status=1
		
          JOIN Contract.CareGroup AS GA  ON GA.Id = DO.CareGroupId
		  LEFT OUTER JOIN DBO.ADINGRESO AS ING  ON ING.NUMINGRES=O.AdmissionNumber
          
          JOIN Inventory.InventoryProduct AS P  ON DO.ProductId = P.Id
          JOIN Inventory.ProductType AS TP ON TP.Code = P.ProductTypeId
          LEFT JOIN Inventory.ATC AS M  ON P.ATCId = M.Id
          LEFT JOIN Inventory.DCI AS dci  ON M.DCIId = dci.Id
          LEFT JOIN Inventory.PharmacologicalGroup AS GF  ON M.PharmacologicalGroupId = GF.Id
          LEFT JOIN inventory.InventorySupplie AS ins ON ins.Id = P.SupplieId
          LEFT JOIN Inventory.ProductGroup AS G ON G.Id = P.ProductGroupId
		      LEFT JOIN
     (
         SELECT FD.MedicalFormulaId, 
                fD.admissionnumber, 
                CASE WHEN e.desespeci IS NULL THEN E1.desespeci ELSE E.desespeci END AS desespeci,
				FD.HealthProfessionalNit --, 
			--	fd.DeliveryQuantity
         FROM Inventory.MedicalFormulaDetail FD 
		 JOIN Inventory.MedicalFormula AS F ON F.ID=FD.MedicalFormulaId
              LEFT JOIN dbo.INPROFSAL M ON FD.HealthProfessionalNit = M.CODPROSAL
              LEFT JOIN dbo.INESPECIA E ON M.CODESPEC1 = E.CODESPECI
			   LEFT JOIN dbo.INESPECIA E1 ON E1.CODESPECI= substring(F.number,1,3) 
			  WHERE YEAR(F.CREATIONDATE)>='2022' 
         GROUP BY FD.MedicalFormulaId, 
                  fD.admissionnumber, 
                  e.desespeci,
				  E1.desespeci,
				  FD.HealthProfessionalNit--, 
				--fd.DeliveryQuantity 
				) AS Esp ON Esp.MedicalFormulaId = MF.ID
          
          
  
     WHERE   dis.status<>3 and ing.iestadoin<>'A' and (mf.creationdate)>='01-01-2022' 
	-- and MF.ID ='487904'
