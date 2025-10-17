-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_INN_DispensacionFarmaceutica_Paciente_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[V_INN_DispensacionFarmaceutica_Paciente_PB]
AS
     SELECT DISTINCT 
            F.Number AS Formula, 
            F.CreationDate AS FechaRegistroDispensacion, 
            F.Date AS FechaDispensacion, 
            RTRIM(F.PatientCode) AS Documento, 
            RTRIM(F.PatientName) AS Paciente, 
            MFD.ProductCode AS CodProducto, 
            MFD.ProductName AS ProductoOrdenado, 
            MFD.RequestQuantity AS CantidadSolicitada, 
            MFD.DeliveryQuantity AS CantDespachada, 
            MFD.PendingQuantity AS CantidadPendiente,
            CASE MFD.IsDeferred
                WHEN 1
                THEN 'Si'
                ELSE 'No'
            END AS ProductoDiferido,
            --ISNULL( (SELECT SUM(MFDIF.PendingQuantity) 
            --		 FROM Inventory.MedicalFormulaDetailDeferred AS MFDIF WHERE DeliveryDate <= getdate() AND MFDIF.MedicalFormulaDetailId=MFD.Id)
            --		 ,MFD.PendingQuantity) AS Cantidad_Pendiente_Real,
            --FAC.Almacen,
            --FAC.CUM, FAC.Producto, FAC.CantidadFactura,
            --FAC.ValorUnitario as VlrUnit, 
            --convert(money,FAC.ValorTotal,101) as VlrTotal, FAC.Ingreso, FAC.Factura, FAC.FechaFactura, FAC.UsuarioFactura,
            CASE F.IsManual
                WHEN 0
                THEN 'Automatica'
                WHEN 1
                THEN 'Manual'
            END AS TipoDispensacion, 
            F.FunctionalUnitName AS Unidad, 
            IIF(F.IPSCode = '', '900622551 - JERSALUD SAS', F.IPSCode) AS IPS, 
            DATEPART(YYYY, F.Date) AS Año_Dispensacion, 
            DATEPART(MM, F.Date) AS Mes_Dispensacion, 
            UO.UnitName AS Sede, 
            HealthProfessionalName AS Medico, 
            SpecialtyName AS Especialidad, 
            dx.nomdiagno AS DxIngreso, 
            NOMDEPART AS Departamento, 
            F.Number + F.PatientCode AS llave
     FROM Inventory.MedicalFormula AS F 
          JOIN Inventory.MedicalFormulaDetail AS MFD  ON MFD.MedicalFormulaId = F.Id
          JOIN [Security].[USER] AS U ON F.CreationUser = U.UserCode
          JOIN [Security].Person AS Per ON U.IdPerson = Per.Id
          JOIN [Security].PermissionCompany AS Perm ON Perm.IdUser = U.Id
                                                                               AND Perm.Permission = 1
                                                                               AND Perm.IdContainer = 2002
          JOIN Common.OperatingUnit AS UO  ON UO.Id = Perm.IdOperatingUnitDefault
          LEFT OUTER JOIN dbo.ADINGRESO AS Ing  ON Ing.numingres = mfd.admissionnumber
          LEFT OUTER JOIN dbo.INDIAGNOS AS DX  ON DX.CODDIAGNO = Ing.coddiaing
          JOIN dbo.INPACIENT AS P  ON P.IPCODPACI = F.PatientCode
          INNER JOIN dbo.INUBICACI AS UB 
          LEFT JOIN dbo.INMUNICIP AS mu 
          LEFT JOIN dbo.INDEPARTA AS DEP  ON DEP.depcodigo = mu.DEPCODIGO ON mu.DEPMUNCOD = UB.DEPMUNCOD ON UB.AUUBICACI = p.AUUBICACI
     --LEFT JOIN (
     --		SELECT M.Code, P.Code AS CUM,  DFA.InvoicedQuantity CantidadFactura, DFA.TotalSalesPrice as ValorUnitario, DFA.GrandTotalSalesPrice as ValorTotal, FA.InvoiceNumber as Factura,
     --		o.PatientCode
     --		FROM Inventory.MedicalFormulaPharmaceuticalDispensing DIF WITH (NOLOCK)
     --		JOIN Inventory.PharmaceuticalDispensing DIS WITH (NOLOCK) ON DIF.PharmaceuticalDispensingId = DIS.Id 
     --		JOIN Inventory.PharmaceuticalDispensingDetail DDIS WITH (NOLOCK) ON DDIS.PharmaceuticalDispensingId = DIS.Id
     --		JOIN Billing.ServiceOrder O WITH (NOLOCK) ON DDIS.PharmaceuticalDispensingId = O.EntityId and o.Status =1 
     --		JOIN Billing.ServiceOrderDetail DO WITH (NOLOCK) ON DO.ServiceOrderId = O.Id AND DDIS.ProductId = DO.ProductId
     --		JOIN Billing.InvoiceDetail DFA WITH (NOLOCK) ON DFA.ServiceOrderDetailId = DO.Id
     --		JOIN Billing.Invoice FA WITH (NOLOCK) ON DFA.InvoiceId = FA.Id and FA.Status =1
     --		JOIN Inventory.InventoryProduct P WITH (NOLOCK) ON DO.ProductId = P.Id
     --		JOIN Inventory.ATC M WITH (NOLOCK) ON P.ATCId = M.Id
     --		) AS FAC ON MFD.ProductCode = FAC.Code AND F.PatientCode = FAC.PatientCode
     WHERE F.IsManual = 0
           AND F.CreationDate >= '01-08-2020'   and ing.IPCODPACI<>'9999999'
     UNION
     SELECT DISTINCT 
            F.Number AS Formula, 
            F.CreationDate AS FechaRegistroDispensacion, 
            F.Date AS FechaDispensacion, 
            RTRIM(F.PatientCode) AS Documento, 
            RTRIM(F.PatientName) AS Paciente, 
            MFD.ProductCode AS CodProducto, 
            MFD.ProductName AS ProductoOrdenado, 
            MFD.RequestQuantity AS CantidadSolicitada, 
            MFD.DeliveryQuantity AS CantDespachada, 
            MFD.PendingQuantity AS CantidadPendiente,
            CASE MFD.IsDeferred
                WHEN 1
                THEN 'Si'
                ELSE 'No'
            END AS ProductoDiferido,
            --ISNULL( (SELECT SUM(MFDIF.PendingQuantity) 
            --		 FROM Inventory.MedicalFormulaDetailDeferred AS MFDIF WHERE DeliveryDate <= getdate() AND MFDIF.MedicalFormulaDetailId=MFD.Id)
            --		 ,MFD.PendingQuantity) AS Cantidad_Pendiente_Real,
            ----FAC.Almacen,
            --FAC.CUM, FAC.Producto, FAC.CantidadFactura,
            --FAC.ValorUnitario as VlrUnit, 
            --convert(money,FAC.ValorTotal,101) as VlrTotal, FAC.Ingreso, FAC.Factura, FAC.FechaFactura, FAC.UsuarioFactura,
            CASE F.IsManual
                WHEN 0
                THEN 'Automatica'
                WHEN 1
                THEN 'Manual'
            END AS TipoDispensacion, 
            F.FunctionalUnitName AS Unidad, 
            IIF(F.IPSCode = '', '900622551 - JERSALUD SAS', F.IPSCode) AS IPS, 
            DATEPART(YYYY, F.Date) AS Año_Dispensacion, 
            DATEPART(MM, F.Date) AS Mes_Dispensacion, 
            UO.UnitName AS Sede, 
            HealthProfessionalName AS Medico, 
            SpecialtyName AS Especialidad, 
            '' AS DxIngreso, 
            NOMDEPART AS Departamento, 
            F.Number + F.PatientCode AS llave
     FROM Inventory.MedicalFormula AS F 
          JOIN Inventory.MedicalFormulaDetail AS MFD  ON MFD.MedicalFormulaId = F.Id
          JOIN [Security].[USER] AS U ON F.CreationUser = U.UserCode
          JOIN [Security].Person AS Per ON U.IdPerson = Per.Id
          JOIN [Security].PermissionCompany AS Perm ON Perm.IdUser = U.Id
                                                                               AND Perm.Permission = 1
                                                                               AND Perm.IdContainer = 2002
          JOIN Common.OperatingUnit AS UO  ON UO.Id = Perm.IdOperatingUnitDefault
          LEFT OUTER JOIN dbo.ADINGRESO AS Ing  ON Ing.numingres = mfd.admissionnumber
          LEFT OUTER JOIN dbo.INDIAGNOS AS DX  ON DX.CODDIAGNO = Ing.coddiaing
          JOIN dbo.INPACIENT AS P  ON P.IPCODPACI = F.PatientCode
          INNER JOIN dbo.INUBICACI AS UB 
          LEFT JOIN dbo.INMUNICIP AS mu 
          LEFT JOIN dbo.INDEPARTA AS DEP  ON DEP.depcodigo = mu.DEPCODIGO ON mu.DEPMUNCOD = UB.DEPMUNCOD ON UB.AUUBICACI = p.AUUBICACI
     --LEFT JOIN (
     --SELECT  M.Code, P.Code AS CUM,  DFA.InvoicedQuantity CantidadFactura, DFA.TotalSalesPrice as ValorUnitario, DFA.GrandTotalSalesPrice as ValorTotal, FA.InvoiceNumber as Factura
     --, o.PatientCode
     --FROM Inventory.MedicalFormulaPharmaceuticalDispensing DIF WITH (NOLOCK)
     --JOIN Inventory.PharmaceuticalDispensing DIS WITH (NOLOCK) ON DIF.PharmaceuticalDispensingId = DIS.Id 
     --JOIN Inventory.PharmaceuticalDispensingDetail DDIS WITH (NOLOCK) ON DDIS.PharmaceuticalDispensingId = DIS.Id
     --JOIN Billing.ServiceOrder O WITH (NOLOCK) ON DDIS.PharmaceuticalDispensingId = O.EntityId and o.Status =1 
     --JOIN Billing.ServiceOrderDetail DO WITH (NOLOCK) ON DO.ServiceOrderId = O.Id AND DDIS.ProductId = DO.ProductId
     --JOIN Billing.InvoiceDetail DFA WITH (NOLOCK) ON DFA.ServiceOrderDetailId = DO.Id
     --JOIN Billing.Invoice FA WITH (NOLOCK) ON DFA.InvoiceId = FA.Id and FA.Status =1
     --			JOIN Inventory.InventoryProduct P WITH (NOLOCK) ON DO.ProductId = P.Id
     --JOIN Inventory.ATC M WITH (NOLOCK) ON P.ATCId = M.Id
     --) AS FAC ON MFD.ProductCode = FAC.CUM AND F.PatientCode = FAC.PatientCode
     WHERE F.IsManual = 1
           AND F.CreationDate >= '01-08-2020'   and ing.IPCODPACI<>'9999999';
