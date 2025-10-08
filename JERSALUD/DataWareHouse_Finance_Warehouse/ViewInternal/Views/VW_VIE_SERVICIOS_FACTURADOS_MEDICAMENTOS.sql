-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_SERVICIOS_FACTURADOS_MEDICAMENTOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_SERVICIOS_FACTURADOS_MEDICAMENTOS 
AS

SELECT  DISTINCT
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
            MF.Id AS Id_Formula, 
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
            MF.CreationDate AS FechaRegistroDispensacion,
            CASE MF.IsManual
                WHEN 0
                THEN 'Automatica'
                WHEN 1
                THEN 'Manual'
            END AS TipoDispensacion, 
            MF.Date AS Fecha_Dispensacion, 
            MF.ModificationDate AS Fecha_Modificacion_Dispensacion, 
			GA.Code AS	Cod_GrupoAtención,
            GA.Name AS Grupo_Atencion, 
			cc.ContractName as Contrato,
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
			DX.CODDIAGNO as CIE10_Ingreso,
			DX.NOMDIAGNO AS DxIngreso,
			O.CreationDate as CreacionOrdenServicio,
			AI.IFECHAING AS FechaIngreso,
			CEN.NOMCENATE AS 'Centro de Atencion',
			anu.AnnulmentDate AS [Fecha Anulacion Factura],
			Per2.Fullname AS [Usuario Anula],
			anu.DescriptionReversal AS [Descripcion Anulacion],
			--anu.ReversalReasonId AS [Razon Anulacion],
			anu.InvoiceNumber AS [Numero Factura Anulada]
			,CU.Number AS Cuenta_Venta
			,CU.Name AS CuentaContable_Venta
			,UF.UFUDESCRI AS UnidadFuncional
				
FROM INDIGO031.Inventory.MedicalFormula AS MF 
JOIN INDIGO031.Inventory.MedicalFormulaPharmaceuticalDispensing AS DIF  ON DIF.MedicalFormulaId = MF.Id
JOIN INDIGO031.Inventory.PharmaceuticalDispensing AS DIS  ON DIF.PharmaceuticalDispensingId = DIS.Id
JOIN INDIGO031.Inventory.PharmaceuticalDispensingDetail AS DDIS  ON DDIS.PharmaceuticalDispensingId = DIS.Id
JOIN INDIGO031.Billing.ServiceOrder AS O  ON DDIS.PharmaceuticalDispensingId = O.EntityId AND O.Status = 1
JOIN INDIGO031.Billing.ServiceOrderDetail AS DO  ON DO.ServiceOrderId = O.Id AND DDIS.ProductId = DO.ProductId
INNER JOIN INDIGO031.dbo.ADINGRESO AS AI  ON AI.NUMINGRES=O.AdmissionNumber and AI.IFECHAING >= '01-01-2024 00:00:00'
INNER JOIN INDIGO031.dbo.ADCENATEN AS CEN ON CEN.CODCENATE=MF.CareCenterCode
JOIN INDIGO031.Billing.InvoiceDetail AS DFA  ON DFA.ServiceOrderDetailId = DO.Id
JOIN INDIGO031.Billing.Invoice AS FA  ON DFA.InvoiceId = FA.Id AND FA.Status = 1 
JOIN INDIGO031.Contract.CareGroup AS GA  ON GA.Id = FA.CareGroupId
JOIN INDIGO031.Inventory.InventoryProduct AS P  ON DO.ProductId = P.Id
JOIN INDIGO031.Inventory.ProductType AS TP  ON TP.Code = P.ProductTypeId
LEFT JOIN INDIGO031.Inventory.ATC AS M  ON P.ATCId = M.Id
LEFT JOIN INDIGO031.dbo.INPACIENT AS PP  ON PP.IPCODPACI=MF.PatientCode
LEFT JOIN INDIGO031.Inventory.DCI AS dci  ON M.DCIId = dci.Id
LEFT JOIN INDIGO031.Inventory.PharmacologicalGroup AS GF  ON M.PharmacologicalGroupId = GF.Id
LEFT JOIN INDIGO031.Inventory.InventorySupplie AS ins  ON ins.Id = P.SupplieId
LEFT JOIN INDIGO031.Inventory.ProductGroup AS G  ON G.Id = P.ProductGroupId
LEFT JOIN INDIGO031.Inventory.Warehouse AS AL  ON DDIS.WarehouseId = AL.Id
LEFT JOIN INDIGO031.[Security].[UserInt] AS U ON O.CreationUser = U.UserCode
LEFT JOIN INDIGO031.[Security].PersonInt AS Per ON U.IdPerson = Per.Id
LEFT JOIN INDIGO031.[Security].PermissionCompanyInt AS Perm ON Perm.IdUser = U.Id AND Perm.Permission = 1 AND Perm.IdContainer = 109
LEFT JOIN INDIGO031.Common.OperatingUnit AS UO  ON UO.Id = Perm.IdOperatingUnitDefault
LEFT JOIN INDIGO031.Common.City AS C  ON C.Id = UO.IdCity
LEFT JOIN INDIGO031.Common.Department AS D  ON D.Id = C.DepartamentId
left outer join INDIGO031.Contract.Contract as cc  on cc.Id=GA.ContractId
LEFT JOIN
(
SELECT FD.MedicalFormulaId, 
    FD.AdmissionNumber, 
    E.DESESPECI
from INDIGO031.Inventory.MedicalFormulaDetail FD
    JOIN INDIGO031.dbo.INPROFSAL M ON FD.HealthProfessionalCode = M.CODPROSAL
    JOIN INDIGO031.dbo.INESPECIA E ON M.CODESPEC1 = E.CODESPECI
GROUP BY FD.MedicalFormulaId, 
        FD.AdmissionNumber, 
        E.DESESPECI
) AS Esp ON Esp.MedicalFormulaId = MF.Id
LEFT OUTER JOIN INDIGO031.dbo.INDIAGNOP AS Ing  ON Ing.NUMINGRES = O.AdmissionNumber AND Ing.CODDIAPRI=1
LEFT OUTER JOIN INDIGO031.dbo.INDIAGNOS AS DX  ON DX.CODDIAGNO = Ing.CODDIAGNO
LEFT OUTER JOIN (
    SELECT AdmissionNumber, AnnulmentDate, AnnulmentUser, DescriptionReversal, ReversalReasonId, InvoiceNumber
    FROM INDIGO031.Billing.Invoice
    WHERE Status = '2' 
) AS anu ON anu.AdmissionNumber = FA.AdmissionNumber
LEFT JOIN INDIGO031.[Security].[UserInt] AS U2 ON anu.AnnulmentUser = U2.UserCode
LEFT JOIN INDIGO031.[Security].PersonInt AS Per2 ON U2.IdPerson = Per2.Id
left JOIN INDIGO031.GeneralLedger.MainAccounts AS CU  ON G.IncomeAccountId = CU.Id
LEFT JOIN INDIGO031.dbo.INUNIFUNC AS UF  ON UF.UFUCODIGO = AI.UFUCODIGO

WHERE year(FA.InvoiceDate) >= '2024' --AND MF.IsManual=0 
