-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_V_INN_DISPENSACIONFARMACEUTICA_PACIENTE_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_V_INN_DISPENSACIONFARMACEUTICA_PACIENTE_PB AS

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
            DX.NOMDIAGNO AS DxIngreso, 
            DEP.nomdepart AS Departamento, 
            F.Number + F.PatientCode AS llave
     FROM INDIGO031.Inventory.MedicalFormula AS F 
          JOIN INDIGO031.Inventory.MedicalFormulaDetail AS MFD  ON MFD.MedicalFormulaId = F.Id
          JOIN INDIGO031.[Security].[UserInt] AS U ON F.CreationUser = U.UserCode
          JOIN INDIGO031.[Security].PersonInt AS Per ON U.IdPerson = Per.Id
          JOIN INDIGO031.[Security].PermissionCompanyInt AS Perm ON Perm.IdUser = U.Id
                                                                               AND Perm.Permission = 1
                                                                               AND Perm.IdContainer = 2002
          JOIN INDIGO031.Common.OperatingUnit AS UO  ON UO.Id = Perm.IdOperatingUnitDefault
          LEFT OUTER JOIN INDIGO031.dbo.ADINGRESO AS Ing  ON Ing.NUMINGRES = MFD.AdmissionNumber
          LEFT OUTER JOIN INDIGO031.dbo.INDIAGNOS AS DX  ON DX.CODDIAGNO = Ing.CODDIAING
          JOIN INDIGO031.dbo.INPACIENT AS P  ON P.IPCODPACI = F.PatientCode
          INNER JOIN INDIGO031.dbo.INUBICACI AS UB 
          LEFT JOIN INDIGO031.dbo.INMUNICIP AS mu 
          LEFT JOIN INDIGO031.dbo.INDEPARTA AS DEP  ON DEP.depcodigo = mu.DEPCODIGO ON mu.DEPMUNCOD = UB.DEPMUNCOD ON UB.AUUBICACI = P.AUUBICACI
     WHERE F.IsManual = 0
           AND F.CreationDate >= '01-08-2020'   and Ing.IPCODPACI<>'9999999'
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
            nomdepart AS Departamento, 
            F.Number + F.PatientCode AS llave
     FROM INDIGO031.Inventory.MedicalFormula AS F 
          JOIN INDIGO031.Inventory.MedicalFormulaDetail AS MFD  ON MFD.MedicalFormulaId = F.Id
          JOIN INDIGO031.[Security].[UserInt] AS U ON F.CreationUser = U.UserCode
          JOIN INDIGO031.[Security].PersonInt AS Per ON U.IdPerson = Per.Id
          JOIN INDIGO031.[Security].PermissionCompanyInt AS Perm ON Perm.IdUser = U.Id
                                                                               AND Perm.Permission = 1
                                                                               AND Perm.IdContainer = 2002
          JOIN INDIGO031.Common.OperatingUnit AS UO  ON UO.Id = Perm.IdOperatingUnitDefault
          LEFT OUTER JOIN INDIGO031.dbo.ADINGRESO AS Ing  ON Ing.NUMINGRES = MFD.AdmissionNumber
          LEFT OUTER JOIN INDIGO031.dbo.INDIAGNOS AS DX  ON DX.CODDIAGNO = Ing.CODDIAING
          JOIN INDIGO031.dbo.INPACIENT AS P  ON P.IPCODPACI = F.PatientCode
          INNER JOIN INDIGO031.dbo.INUBICACI AS UB 
          LEFT JOIN INDIGO031.dbo.INMUNICIP AS mu 
          LEFT JOIN INDIGO031.dbo.INDEPARTA AS DEP  ON DEP.depcodigo = mu.DEPCODIGO ON mu.DEPMUNCOD = UB.DEPMUNCOD ON UB.AUUBICACI = P.AUUBICACI
     WHERE F.IsManual = 1
           AND F.CreationDate >= '01-08-2020'   and Ing.IPCODPACI<>'9999999';