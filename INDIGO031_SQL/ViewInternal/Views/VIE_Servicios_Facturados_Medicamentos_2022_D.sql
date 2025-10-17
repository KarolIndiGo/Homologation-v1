-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_Servicios_Facturados_Medicamentos_2022_D
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [ViewInternal].[VIE_Servicios_Facturados_Medicamentos_2022_D]
AS

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
            MF.ID AS Id_Formula, 
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
            MF.CreationDate AS FechaRegistro,
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
            --Esp.desespeci AS ProfesionOrdena, 
			'' AS ProfesionOrdena, 
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
			ccc.name as CentroCostoDispensacion,
			cccd.name as CentroCostoFacturacion,
			uf.code as CodUF,
			g.code as CodGrupo,
			case 
			ing.iestadoin when '' then 'Abierto'
			when 'F' then 'Facturado' 
		    when 'P' then 'Parcial'
		    when 'A' then 'Anulado' 
			 when 'C' then 'Cerrado'
			 end as EstadoIngreso

     FROM Inventory.MedicalFormula AS MF
          JOIN Inventory.MedicalFormulaPharmaceuticalDispensing AS DIF  ON DIF.MedicalFormulaId = MF.Id
          JOIN Inventory.PharmaceuticalDispensing AS DIS  ON DIF.PharmaceuticalDispensingId = DIS.Id
          JOIN Inventory.PharmaceuticalDispensingDetail AS DDIS  ON DDIS.PharmaceuticalDispensingId = DIS.Id
		  JOIN Payroll.FunctionalUnit as uf  on   uf.id= ddis.FunctionalUnitId
		  JOIN Payroll.costcenter as ccc    on ccc.id= uf.costcenterid
          JOIN Billing.ServiceOrder AS O  ON DDIS.PharmaceuticalDispensingId = O.EntityId
                                                                           AND o.STATUS = 1
			LEFT OUTER JOIN dbo.ADINGRESO AS ING  ON ING.NUMINGRES=O.AdmissionNumber
          JOIN Billing.ServiceOrderDetail AS DO  ON DO.ServiceOrderId = O.Id
                                                                                  AND DDIS.ProductId = DO.ProductId
		JOIN Payroll.costcenter as cccd    on cccd.id= do.costcenterid
          JOIN Billing.InvoiceDetail AS DFA  ON DFA.ServiceOrderDetailId = DO.Id
          JOIN Contract.CareGroup AS GA  ON GA.Id = DO.CareGroupId
          JOIN Billing.Invoice AS FA  ON DFA.InvoiceId = FA.Id
                                                                       AND FA.STATUS = 1
          JOIN Inventory.InventoryProduct AS P  ON DO.ProductId = P.Id
          JOIN Inventory.ProductType AS TP ON TP.Code = P.ProductTypeId
          LEFT JOIN Inventory.ATC AS M  ON P.ATCId = M.Id
          LEFT JOIN Inventory.DCI AS dci  ON M.DCIId = dci.Id
          LEFT JOIN Inventory.PharmacologicalGroup AS GF  ON M.PharmacologicalGroupId = GF.Id
          LEFT JOIN inventory.InventorySupplie AS ins ON ins.Id = P.SupplieId
          LEFT JOIN Inventory.ProductGroup AS G ON G.Id = P.ProductGroupId
          JOIN Inventory.Warehouse AS AL  ON DDIS.WarehouseId = AL.Id
          JOIN [Security].[USER] AS U ON O.CreationUser = U.UserCode
          JOIN [Security].Person AS Per ON U.IdPerson = Per.Id
          JOIN [Security].PermissionCompany AS Perm ON Perm.IdUser = U.Id
                                                                               AND Perm.Permission = 1
                                                                               AND Perm.IdContainer = 72
          JOIN Common.OperatingUnit AS UO ON UO.Id = Perm.IdOperatingUnitDefault
          JOIN Common.City AS C  ON C.Id = UO.IdCity
          JOIN Common.Department AS D  ON D.Id = C.DepartamentId
		  left outer join Contract.Contract as cc on cc.id=ga.ContractId
          LEFT JOIN
     (
         SELECT FD.MedicalFormulaId, 
                fD.admissionnumber, 
                e.desespeci
         FROM Inventory.MedicalFormulaDetail FD
              JOIN dbo.INPROFSAL M ON FD.HealthProfessionalCode = M.CODPROSAL
              JOIN dbo.INESPECIA E ON M.CODESPEC1 = E.CODESPECI
         GROUP BY FD.MedicalFormulaId, 
                  fD.admissionnumber, 
                  e.desespeci
     ) AS Esp ON Esp.MedicalFormulaId = MF.ID
     --WHERE FA.InvoiceDate >= DATEADD(MONTH, -4, GETDATE())
	 WHERE YEAR(FA.InvoiceDate)='2022' and dis.status<>3 and ing.iestadoin<>'A' 
	 --and FA.InvoiceNumber='V350349'
	 
