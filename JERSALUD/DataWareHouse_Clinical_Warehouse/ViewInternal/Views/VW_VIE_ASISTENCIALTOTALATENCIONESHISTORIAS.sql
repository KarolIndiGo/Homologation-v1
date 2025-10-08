-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_VIE_ASISTENCIALTOTALATENCIONESHISTORIAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_ASISTENCIALTOTALATENCIONESHISTORIAS
AS
     SELECT DISTINCT TOP (100) PERCENT i.NUMINGRES AS Ingreso, 
                                       ga.Code AS [Grupo Atención Ingreso], 
                                       ga.Name AS [Grupo Atención], 
                                       ea.Name AS Entidad, 
                                       i.IPCODPACI AS [Identificación Paciente], 
                                       p.IPNOMCOMP AS [Nombre Paciente], 
                                       CONVERT(VARCHAR(10), p.IPFECNACI, 101) AS FechaNacimiento, 
                                       DATEDIFF(year, p.IPFECNACI, i.IFECHAING) AS EdadEnAtencion, 
                                       M.MUNNOMBRE AS Municipio, 
                                       DP.nomdepart AS Dpto, 
                                       CAST(p.GENEXPEDITIONCITY AS VARCHAR(20)) + ' - ' + ISNULL(ci.Name, '') AS [Lugar expedición Vie], 
                                       i.IFECHAING AS Fecha_Ingreso, 
                                       i.IESTADOIN AS Estado, 
                                       uf.UFUDESCRI AS Unidad_Funcional, 
                                       HCU.ENFACTUAL AS Enfermedad_Actual, 
                                       em.FECALTPAC AS [Fecha alta Médica], 
                                       HC.CODDIAGNO AS CIE_10, 
                                       CIE10.NOMDIAGNO AS Diagnóstico, 
                                       PROF.NOMMEDICO AS Medico, 
                                       ESP.DESESPECI AS Especialidad, 
                                       D.UFUDESCRI AS UnidadActual, 
                                       i.IOBSERVAC AS Observaciones,
                                       CASE i.TIPOINGRE
                                           WHEN 1
                                           THEN 'Ambulatorio'
                                           WHEN 2
                                           THEN 'Hospitalario'
                                       END AS TipoIngreso, 
                                       1 AS Cantidad
     FROM INDIGO031.dbo.ADINGRESO AS i 
          INNER JOIN INDIGO031.dbo.INUNIFUNC AS uf  ON uf.UFUCODIGO = i.UFUCODIGO
          INNER JOIN INDIGO031.Contract.CareGroup AS ga  ON ga.Id = i.GENCAREGROUP
          INNER JOIN INDIGO031.dbo.INPACIENT AS p  ON p.IPCODPACI = i.IPCODPACI
          LEFT OUTER JOIN INDIGO031.Contract.HealthAdministrator AS ea  ON ea.Id = i.GENCONENTITY
          LEFT OUTER JOIN INDIGO031.Common.City AS ci ON ci.Id = p.GENEXPEDITIONCITY
          LEFT OUTER JOIN INDIGO031.dbo.SEGusuaru AS uu ON uu.CODUSUARI = i.CODUSUMOD
          LEFT OUTER JOIN INDIGO031.dbo.HCHISPACA AS HC  ON HC.NUMINGRES = i.NUMINGRES
                                                                                AND HC.IPCODPACI = HC.IPCODPACI
                                                                                AND HC.TIPHISPAC = 'i'
          LEFT OUTER JOIN INDIGO031.dbo.HCURGING1 AS HCU  ON HCU.NUMINGRES = HC.NUMINGRES
                                                                                 AND HCU.IPCODPACI = HC.IPCODPACI
                                                                                 AND HCU.NUMEFOLIO = HC.NUMEFOLIO
          LEFT OUTER JOIN
     (
         SELECT IPCODPACI, 
                NUMINGRES, 
                MAX(NUMEFOLIO) AS Folio
         FROM INDIGO031.dbo.INDIAGNOP
         WHERE(CODDIAPRI = 'True')
         GROUP BY NUMINGRES, 
                  IPCODPACI
     ) AS DX ON DX.IPCODPACI = HCU.IPCODPACI
                AND DX.NUMINGRES = HCU.NUMINGRES
                AND DX.Folio = HC.NUMEFOLIO
          LEFT OUTER JOIN INDIGO031.dbo.INDIAGNOS AS CIE10 ON CIE10.CODDIAGNO = HC.CODDIAGNO
          LEFT OUTER JOIN INDIGO031.dbo.HCURGEVO1 AS HCU1 ON HCU.NUMINGRES = HC.NUMINGRES
                                                                     AND HCU1.IPCODPACI = HC.IPCODPACI
                                                                     AND HCU1.NUMEFOLIO = HC.NUMEFOLIO
          LEFT OUTER JOIN INDIGO031.dbo.ADINGRESO AS I2 ON I2.NUMINGRES = i.NUMINGRES
          LEFT OUTER JOIN INDIGO031.dbo.INUNIFUNC AS D ON I2.UFUAACTHOS = D.UFUCODIGO
          LEFT OUTER JOIN INDIGO031.dbo.HCREGEGRE AS em ON em.IPCODPACI = HC.IPCODPACI
                                                                   AND em.NUMINGRES = HC.NUMINGRES
          LEFT OUTER JOIN INDIGO031.dbo.SEGusuaru AS u ON u.CODUSUARI = i.CODUSUCRE
          INNER JOIN INDIGO031.dbo.INUBICACI AS UB ON p.AUUBICACI = UB.AUUBICACI
          INNER JOIN INDIGO031.dbo.INMUNICIP AS M ON UB.DEPMUNCOD = M.DEPMUNCOD
          INNER JOIN INDIGO031.dbo.INDEPARTA AS DP ON M.DEPCODIGO = DP.depcodigo
          INNER JOIN INDIGO031.dbo.INPROFSAL AS PROF ON HC.CODPROSAL = PROF.CODPROSAL
          INNER JOIN INDIGO031.dbo.INESPECIA AS ESP ON PROF.CODESPEC1 = ESP.CODESPECI
     WHERE(i.UFUCODIGO IN('B00001', 'B00002', 'B00003', 'B00004', 'B00005', 'B00006', 'B00007', 'B00008'))
          AND (i.IPCODPACI NOT IN('1234567', '12345678'))
     AND (em.FECALTPAC IS NOT NULL)
     ORDER BY Ingreso;