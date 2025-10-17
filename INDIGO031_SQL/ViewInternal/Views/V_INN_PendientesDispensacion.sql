-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: V_INN_PendientesDispensacion
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[V_INN_PendientesDispensacion]
AS
     --select * from Inventory.MedicalFormula AS MF WHERE MF.Number in ('245031')
     SELECT MF.Number AS Formula, 
            P.IPCODPACI AS Documento,
            CASE P.IPTIPODOC
                WHEN 1
                THEN 'Cedula de Ciudadania'
                WHEN 2
                THEN 'Cedula de Extranjeria'
                WHEN 3
                THEN 'Tarjeta de Identidad'
                WHEN 4
                THEN 'Registro Civil'
                WHEN 5
                THEN 'Pasporte'
                WHEN 6
                THEN 'Adulto Sin Identificacion'
                WHEN 7
                THEN 'Menor Sin Identificacion'
                WHEN 8
                THEN 'Numero unico de identificacion personal'
            END AS 'Tipo Documento', 
            MF.PatientName AS Paciente, 
            MF.CreationDate AS FechaRegistro, 
            LTRIM(RTRIM(MFD.ProductCode)) + ' - ' + LTRIM(RTRIM(MFD.ProductName)) AS Producto, 
            'Automatica' AS TipoDispensacion, 
            MFD.RequestQuantity AS 'Cantidad Solicitada', 
            MFD.DeliveryQuantity AS 'Cantidad Entrega', 
            MFD.PendingQuantity AS 'Cantidad Pendiente', 
            DATEDIFF(DAY, MF.CreationDate, GETDATE()) AS DiasPendiente, 
            LTRIM(RTRIM(MFD.HealthProfessionalName)) + ' - ' + LTRIM(RTRIM(MFD.SpecialtyName)) AS 'Medico/Entidad', 
            P.IPDIRECCI AS Direccion, 
            P.IPTELEFON AS 'Tel Fijo', 
            P.IPTELMOVI AS 'Movil', 
            LTRIM(RTRIM(MF.CreationUser)) + ' - ' + LTRIM(RTRIM(UP.FirstName)) + ' ' + LTRIM(RTRIM(UP.FirstLastName)) AS Funcionario, 
            UO.UnitName AS Sede,
            CASE
                WHEN UO.Id IN(8, 9, 10, 11, 12, 13, 14, 15)
                THEN 'Boyaca'
                WHEN UO.Id IN(16, 17, 18, 19, 20)
                THEN 'Meta'
                WHEN UO.Id = 22
                THEN 'Casanare'
            END AS Regional, 
            MF.IPSCode AS IPS
     FROM Inventory.MedicalFormula AS MF
          INNER JOIN Inventory.MedicalFormulaDetail AS MFD ON MFD.MedicalFormulaId = MF.Id
                                                                                AND MF.IsManual = 0
          INNER JOIN dbo.INPACIENT AS P ON P.IPCODPACI = MF.PatientCode
          INNER JOIN [Security].[USER] AS U ON U.UserCode = MF.CreationUser
          INNER JOIN [Security].[Person] AS UP ON UP.Id = U.IdPerson
          INNER JOIN [Security].PermissionCompany AS PER ON PER.IdUser = U.Id
                                                                                    AND PER.Permission = 1
                                                                                    AND PER.IdContainer = 2002
          INNER JOIN Common.OperatingUnit AS UO ON UO.Id = PER.IdOperatingUnitDefault
     WHERE MFD.PendingQuantity > 0
           AND MFD.IsDeferred = 0 --and MF.Number in ('245031','1133883220201109') -- 
     UNION
     SELECT MF.Number AS Formula, 
            P.IPCODPACI AS Documento,
            CASE P.IPTIPODOC
                WHEN 1
                THEN 'Cedula de Ciudadania'
                WHEN 2
                THEN 'Cedula de Extranjeria'
                WHEN 3
                THEN 'Tarjeta de Identidad'
                WHEN 4
                THEN 'Registro Civil'
                WHEN 5
                THEN 'Pasporte'
                WHEN 6
                THEN 'Adulto Sin Identificacion'
                WHEN 7
                THEN 'Menor Sin Identificacion'
                WHEN 8
                THEN 'Numero unico de identificacion personal'
            END AS 'Tipo Documento', 
            MF.PatientName AS Paciente, 
            MF.CreationDate AS FechaRegistro, 
            LTRIM(RTRIM(M.Code)) + ' - ' + LTRIM(RTRIM(M.Name)) AS Producto, 
            'Manual' AS TipoDispensacion, 
            MFD.RequestQuantity AS 'Cantidad Solicitada', 
            MFD.DeliveryQuantity AS 'Cantidad Entrega', 
            MFD.PendingQuantity AS 'Cantidad Pendiente', 
            DATEDIFF(DAY, MF.CreationDate, GETDATE()) AS DiasPendiente, 
            LTRIM(RTRIM(IPS.CODIGOIPS)) + ' - ' + LTRIM(RTRIM(IPS.DSCRIPIPS)) AS 'Medico/Entidad', 
            P.IPDIRECCI AS Direccion, 
            P.IPTELEFON AS 'Tel Fijo', 
            P.IPTELMOVI AS 'Movil', 
            LTRIM(RTRIM(MF.CreationUser)) + ' - ' + LTRIM(RTRIM(UP.FirstName)) + ' ' + LTRIM(RTRIM(UP.FirstLastName)) AS Funcionario, 
            UO.UnitName AS Sede,
            CASE
                WHEN UO.Id IN(8, 9, 10, 11, 12, 13, 14, 15)
                THEN 'Boyaca'
                WHEN UO.Id IN(16, 17, 18, 19, 20)
                THEN 'Meta'
                WHEN UO.Id = 22
                THEN 'Casanare'
            END AS Regional, 
            MF.IPSCode AS IPS
     FROM Inventory.MedicalFormula AS MF
          INNER JOIN Inventory.MedicalFormulaDetail AS MFD ON MFD.MedicalFormulaId = MF.Id
                                                                                AND MF.IsManual = 1
          INNER JOIN dbo.INPACIENT AS P ON P.IPCODPACI = MF.PatientCode
          INNER JOIN [Security].[USER] AS U ON U.UserCode = MF.CreationUser
          INNER JOIN [Security].[Person] AS UP ON UP.Id = U.IdPerson
          INNER JOIN [Security].PermissionCompany AS PER ON PER.IdUser = U.Id
                                                                                    AND PER.Permission = 1
                                                                                    AND PER.IdContainer = 2002
          INNER JOIN Common.OperatingUnit AS UO ON UO.Id = PER.IdOperatingUnitDefault
          LEFT JOIN dbo.ADCONTIPS AS IPS ON LTRIM(RTRIM(MF.IPSCode)) = LTRIM(RTRIM(IPS.CODIGOIPS)) + ' - ' + LTRIM(RTRIM(IPS.DSCRIPIPS))
          JOIN Inventory.InventoryProduct Pr ON MFD.ProductCode = Pr.Code
          JOIN Inventory.ATC M ON Pr.ATCId = M.Id
     WHERE MFD.PendingQuantity > 0
           AND MFD.IsDeferred = 0;
--and MF.Number in ('245031','1133883220201109')
