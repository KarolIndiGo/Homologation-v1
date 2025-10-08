-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_SERVICIOS_FACTURADOS_MEDICAMENTOS_2021
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_SERVICIOS_FACTURADOS_MEDICAMENTOS_2021
AS
--select * from Billing.BillingGroup AS gf ON gf.Id = pr.BillingGroupId LEFT OUTER JOIN 
--SELECT * FROM Inventory.ProductGroup
SELECT DISTINCT-- ROW_NUMBER() OVER(ORDER BY MF.Number ASC) AS Row#,
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
            IIF(MF.IPSCode = '900622551 - JERSALUD SAS', 'Red Interna', 'Red Externa') AS Red, 
            MF.Number AS Formula, 
            MF.Id AS Id_Formula, 
            MF.PatientCode AS Identificacion_Paciente, 
            MF.PatientName AS Nombre_Paciente, 
            TP.Name AS TipoProducto, 
            ISNULL(M.Code, ins.Code) AS Cod_Medicamento_Insumo, 
            ISNULL(M.Name, ins.SupplieName) AS Medicamento_Insumo, 
            P.Code AS CUM, 
            P.Name AS Producto, 
            P.CodeAlternativeTwo,
            CASE P.Status
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
            Per.Fullname AS UsuarioFactura, 
            MF.CreationDate AS FechaRegistro,
            CASE MF.IsManual
                WHEN 0
                THEN 'Automatica'
                WHEN 1
                THEN 'Manual'
            END AS TipoDispensacion, 
            MF.Date AS Fecha_Dispensacion, 
            MF.ModificationDate AS Fecha_Modificacion_Dispensacion, 
            GA.Name AS Grupo_Atencion, 
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
            Esp.DESESPECI AS ProfesionOrdena, 
            dci.Code AS Codigo_DCI, 
            dci.Name AS DCI,
			CASE GA.LiquidationType
                WHEN 1
                THEN 'Pago por Servicios'
                WHEN 2
                THEN 'Capitacion'
                WHEN 3
                THEN 'Factura Global'
                WHEN 4
                THEN 'Capitacion Global'
                WHEN 5
                THEN 'Pago Global Prospectivo - PGP'
            END AS Tipo_Liquidacion
     FROM INDIGO031.Inventory.MedicalFormula AS MF
          JOIN INDIGO031.Inventory.MedicalFormulaPharmaceuticalDispensing AS DIF  ON DIF.MedicalFormulaId = MF.Id
          JOIN INDIGO031.Inventory.PharmaceuticalDispensing AS DIS  ON DIF.PharmaceuticalDispensingId = DIS.Id
          JOIN INDIGO031.Inventory.PharmaceuticalDispensingDetail AS DDIS  ON DDIS.PharmaceuticalDispensingId = DIS.Id
          JOIN INDIGO031.Billing.ServiceOrder AS O  ON DDIS.PharmaceuticalDispensingId = O.EntityId
                                                                           AND O.Status = 1
          JOIN INDIGO031.Billing.ServiceOrderDetail AS DO  ON DO.ServiceOrderId = O.Id
                                                                                  AND DDIS.ProductId = DO.ProductId
          JOIN INDIGO031.Billing.InvoiceDetail AS DFA  ON DFA.ServiceOrderDetailId = DO.Id
          JOIN INDIGO031.Contract.CareGroup AS GA  ON GA.Id = DO.CareGroupId
          JOIN INDIGO031.Billing.Invoice AS FA  ON DFA.InvoiceId = FA.Id
                                                                       AND FA.Status = 1
          JOIN INDIGO031.Inventory.InventoryProduct AS P  ON DO.ProductId = P.Id
          JOIN INDIGO031.Inventory.ProductType AS TP ON TP.Code = P.ProductTypeId
          LEFT JOIN INDIGO031.Inventory.ATC AS M  ON P.ATCId = M.Id
          LEFT JOIN INDIGO031.Inventory.DCI AS dci  ON M.DCIId = dci.Id
          LEFT JOIN INDIGO031.Inventory.PharmacologicalGroup AS GF  ON M.PharmacologicalGroupId = GF.Id
          LEFT JOIN INDIGO031.Inventory.InventorySupplie AS ins ON ins.Id = P.SupplieId
          LEFT JOIN INDIGO031.Inventory.ProductGroup AS G ON G.Id = P.ProductGroupId
          JOIN INDIGO031.Inventory.Warehouse AS AL  ON DDIS.WarehouseId = AL.Id
          JOIN INDIGO031.[Security].[UserInt] AS U ON O.CreationUser = U.UserCode
          JOIN INDIGO031.[Security].PersonInt AS Per ON U.IdPerson = Per.Id
          JOIN INDIGO031.[Security].PermissionCompanyInt AS Perm ON Perm.IdUser = U.Id
                                                                               AND Perm.Permission = 1
                                                                               AND Perm.IdContainer = 72
          JOIN INDIGO031.Common.OperatingUnit AS UO ON UO.Id = Perm.IdOperatingUnitDefault
          JOIN INDIGO031.Common.City AS C  ON C.Id = UO.IdCity
          JOIN INDIGO031.Common.Department AS D  ON D.Id = C.DepartamentId
          LEFT JOIN
     (
         SELECT FD.MedicalFormulaId, 
                FD.AdmissionNumber, 
                E.DESESPECI
         FROM INDIGO031.Inventory.MedicalFormulaDetail FD
              JOIN INDIGO031.dbo.INPROFSAL M ON FD.HealthProfessionalCode = M.CODPROSAL
              JOIN INDIGO031.dbo.INESPECIA E ON M.CODESPEC1 = E.CODESPECI
         GROUP BY FD.MedicalFormulaId, 
                  FD.AdmissionNumber, 
                  E.DESESPECI
     ) AS Esp ON Esp.MedicalFormulaId = MF.Id
     --WHERE FA.InvoiceDate >= DATEADD(MONTH, -4, GETDATE())
	 WHERE YEAR(FA.InvoiceDate)='2021'