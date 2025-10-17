-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_ControlServiciosAmbulatorios
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_ControlServiciosAmbulatorios]
AS
     SELECT uo.UnitName AS Sede, 
            F.InvoiceNumber AS [Nro Registro], 
            F.AdmissionNumber AS Ingreso, 
            ing.IAUTORIZA AS Autorizacion, 
            m.MUNNOMBRE AS MunicipioProcedencia, 
            DEP.nomdepart AS Departamento,
            CASE ing.TIPOINGRE
                WHEN '1'
                THEN 'Ambulatorio'
                WHEN '2'
                THEN 'Hospitalario'
            END AS TipoIngreso, 
            ing.IFECHAING AS [Fecha ingreso], 
            F.PatientCode AS Identificación,
            CASE
                WHEN P.IPTIPODOC = '1'
                THEN 'CC'
                WHEN p.IPTIPODOC = '2'
                THEN 'CE'
                WHEN p.IPTIPODOC = '3'
                THEN 'TI'
                WHEN p.IPTIPODOC = '4'
                THEN 'RC'
                WHEN p.IPTIPODOC = '5'
                THEN 'PA'
                WHEN p.IPTIPODOC = '6'
                THEN 'AS'
                WHEN p.IPTIPODOC = '7'
                THEN 'MS'
            END AS TipoIdentificacion, 
            p.IPNOMCOMP AS Paciente, 
            p.IPPRINOMB AS [Primer nombre], 
            p.IPSEGNOMB AS [Segundo nombre], 
            p.IPPRIAPEL AS [Primer apellido], 
            p.IPSEGAPEL AS [Segundo apellido], 
            ga.Name AS [Grupo de Atención], 
            F.InvoiceDate AS [Fecha Registro],
            CASE MONTH(F.InvoiceDate)
                WHEN '1'
                THEN 'Enero'
                WHEN '2'
                THEN 'Febrero'
                WHEN '7'
                THEN 'Julio'
                WHEN '8'
                THEN 'Agosto'
                WHEN '9'
                THEN 'Septiembre'
                WHEN '10'
                THEN 'Octubre'
                WHEN '11'
                THEN 'Noviembre'
                WHEN '12'
                THEN 'Diciembre'
            END AS Mes,
            CASE MONTH(F.InvoiceDate)
                WHEN '1'
                THEN 'Enero'
                WHEN '2'
                THEN 'Febrero'
                WHEN '7'
                THEN '7.Jul'
                WHEN '8'
                THEN '8.Ago'
                WHEN '9'
                THEN '9.Sept'
                WHEN '10'
                THEN '10.Oct'
                WHEN '11'
                THEN '11.Nov'
                WHEN '12'
                THEN '12.Dic'
            END AS [Mes.], 
            dos.InvoicedQuantity AS Cantidad, 
            t.Nit, 
            ea.Code + ' - ' + ea.Name AS [Entidad Administradora],
            CASE dos.RecordType
                WHEN '1'
                THEN 'Servicios'
                WHEN '2'
                THEN 'Medicamentos'
            END AS [Servicios/Medicamentos],
            CASE
                WHEN pr.Code IS NULL
                THEN ServiciosIPS.Code
                ELSE pr.Code
            END AS Código,
            CASE
                WHEN pr.Name IS NULL
                THEN ServiciosIPS.Name
                ELSE pr.Name
            END AS Descripción, 
            CUPS.Code AS [Código del servicio prestado], 
            CUPS.Description AS [Nombre del servicio prestado],
            CASE dos.Presentation
                WHEN '1'
                THEN 'No Quirúrgico'
                WHEN '2'
                THEN 'Quirúrgico'
                WHEN '3'
                THEN 'Paquete'
            END AS [Presentación Servicio], 
            ServiciosIPSQ.Code AS Subcodigo, 
            ServiciosIPSQ.Name AS Subnombre,
            CASE
                WHEN dq.PerformsHealthProfessionalCode IS NULL
                THEN dos.PerformsHealthProfessionalCode
                ELSE dq.PerformsHealthProfessionalCode
            END AS CodigoQX,
            CASE
                WHEN RTRIM(medqx.NOMMEDICO) IS NULL
                THEN med.NOMMEDICO
                ELSE RTRIM(medqx.NOMMEDICO)
            END AS NombreMedico,
            CASE
                WHEN espmed.DESESPECI IS NULL
                THEN espqx.DESESPECI
                ELSE espmed.DESESPECI
            END AS Especialidad, 
            RTRIM(UF.Code) + ' - ' + RTRIM(UF.Name) AS [Descripción Unidad Funcional], 
            salida.FECALTPAC AS [Fecha Alta médica], 
            ing.CODDIAEGR AS CIE10, 
            diag.NOMDIAGNO AS Diagnóstico, 
            per.Fullname AS Usuario, 
            ing.UFUAACTHOS AS UnidadActual, 
            DATEDIFF(day, ing.IFECHAING, ing.FECHEGRESO) AS Dias, 
            p.IPFECNACI AS FechaNacimiento,
            CASE IPSEXOPAC
                WHEN 1
                THEN 'Masculino'
                WHEN 2
                THEN 'Femenino'
            END AS Sexo,
            CASE IPTIPOAFI
                WHEN 0
                THEN 'NO APLICA'
                WHEN 1
                THEN 'Cotizante'
                WHEN 2
                THEN 'Beneficiario'
                WHEN 3
                THEN 'Adicional'
                WHEN 4
                THEN 'Jub/Retirado'
                WHEN 5
                THEN 'Pensionado'
            END AS TipoAfiliacion,
            CASE CAPACIPAG
                WHEN 0
                THEN 'No Aplica'
                WHEN 1
                THEN 'Si'
                WHEN 2
                THEN 'No'
                WHEN 3
                THEN 'Desplazado'
            END AS CapacidadPago, 
            E.NIVDESCRI AS Nivel, 
            peri.Fullname AS UsuarioIngreso,
            CASE p.estadopac
                WHEN '1'
                THEN 'Activo'
                WHEN '0'
                THEN 'Inactivo'
            END AS EstadoPaciente, 
            CUPS.Code, 
            CUPS.Description,
            CASE ing.itipories
                WHEN '1'
                THEN 'Enfermedad General'
                WHEN '2'
                THEN 'SOAT'
                WHEN '3'
                THEN 'Catastrofe'
            END AS Origen, 
            ing.CODDIAEGR AS [Código diagnóstico 2], 
            diage.NOMDIAGNO AS [Nombre diagnóstico 2], 
            CAST(DATEPART(hh, ing.IFECHAING) AS CHAR(2)) + ':' + CAST(DATEPART(mi, ing.IFECHAING) AS CHAR(2)) AS [Hora de consulta o examen]
     FROM Billing.Invoice AS F 
          INNER JOIN Billing.RevenueControlDetail AS Brcd  ON F.RevenueControlDetailId = Brcd.Id
          INNER JOIN Billing.InvoiceDetail AS DF  ON DF.InvoiceId = F.Id
          INNER JOIN dbo.ADINGRESO AS ing  ON CAST(ing.NUMINGRES AS INT) = F.AdmissionNumber
          INNER JOIN Billing.ServiceOrderDetail AS dos  ON dos.Id = DF.ServiceOrderDetailId
          INNER JOIN dbo.INPACIENT AS p  ON p.IPCODPACI = F.PatientCode
          INNER JOIN Common.ThirdParty AS t  ON t.Id = F.ThirdPartyId
          INNER JOIN Common.OperatingUnit AS uo  ON uo.Id = F.OperatingUnitId
          INNER JOIN GeneralLedger.MainAccounts AS CC  ON CC.Id = dos.IncomeMainAccountId
          INNER JOIN Payroll.CostCenter AS CCo  ON dos.CostCenterId = CCo.Id
          LEFT OUTER JOIN Contract.CareGroup AS ga  ON ga.Id = F.CareGroupId
          LEFT OUTER JOIN Contract.HealthAdministrator AS ea  ON ea.Id = F.HealthAdministratorId
          LEFT OUTER JOIN [Security].[User] AS u ON u.UserCode = F.InvoicedUser
          LEFT OUTER JOIN [Security].Person AS per ON per.Id = u.IdPerson
          LEFT OUTER JOIN [Security].[User] AS ui ON ui.UserCode = ing.CODUSUCRE
          LEFT OUTER JOIN [Security].Person AS peri ON peri.Id = ui.IdPerson
          LEFT OUTER JOIN Billing.InvoiceCategories AS cat  ON cat.Id = F.InvoiceCategoryId
          LEFT OUTER JOIN Contract.IPSService AS ServiciosIPS  ON ServiciosIPS.Id = dos.IPSServiceId
          LEFT OUTER JOIN Inventory.InventoryProduct AS pr  ON pr.Id = dos.ProductId
          LEFT OUTER JOIN dbo.INPROFSAL AS med  ON med.CODPROSAL = dos.PerformsHealthProfessionalCode
          LEFT OUTER JOIN dbo.INESPECIA AS espmed  ON espmed.CODESPECI = med.CODESPEC1
          LEFT OUTER JOIN dbo.INDIAGNOS AS diag  ON diag.CODDIAGNO = ing.CODDIAEGR
          LEFT OUTER JOIN dbo.INDIAGNOS AS diage  ON diage.CODDIAGNO = ing.CODDIAEGR
          LEFT OUTER JOIN dbo.HCREGEGRE AS salida  ON CAST(salida.NUMINGRES AS INT) = F.AdmissionNumber
          LEFT OUTER JOIN Billing.ServiceOrderDetailSurgical AS dq  ON dq.ServiceOrderDetailId = dos.Id
                                                                                                     AND dq.OnlyMedicalFees = '0'
          LEFT OUTER JOIN dbo.INPROFSAL AS medqx  ON medqx.CODPROSAL = dq.PerformsHealthProfessionalCode
          LEFT OUTER JOIN dbo.INESPECIA AS espqx  ON espqx.CODESPECI = medqx.CODESPEC1
          LEFT OUTER JOIN Contract.IPSService AS ServiciosIPSQ  ON ServiciosIPSQ.Id = dq.IPSServiceId
          LEFT OUTER JOIN Payroll.FunctionalUnit AS UF  ON UF.Id = dos.PerformsFunctionalUnitId
          LEFT OUTER JOIN Contract.CUPSEntity AS CUPS  ON CUPS.Id = dos.CUPSEntityId
          LEFT OUTER JOIN Billing.BillingGroup AS gf  ON gf.Id = CUPS.BillingGroupId
          INNER JOIN dbo.INUBICACI AS ubi  ON ubi.AUUBICACI = p.AUUBICACI
          LEFT OUTER JOIN dbo.INMUNICIP AS m  ON m.DEPMUNCOD = ubi.DEPMUNCOD
          LEFT OUTER JOIN dbo.INDEPARTA AS DEP  ON m.DEPCODIGO = DEP.depcodigo
          LEFT OUTER JOIN dbo.ADNIVELES AS E  ON E.NIVCODIGO = p.NIVCODIGO
     WHERE(F.STATUS = '1')
          AND (dos.IsDelete = '0')
          AND (F.OperatingUnitId IN('8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20'))
          AND (F.RevenueControlDetailId IS NOT NULL);
