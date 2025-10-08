-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_ATENCION_HC_CE_GENERAL
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_ATENCION_HC_CE_GENERAL
AS

	SELECT DISTINCT 
            i.NUMINGRES AS Ingreso, 
            ga.Code AS [Grupo Atención Ingreso], 
            ga.Name AS [Grupo Atención], 
            ea.Name AS Entidad, 

            i.IPCODPACI AS [Identificación Paciente],
			CASE p.IPTIPODOC 
				WHEN 1 THEN 'CC' 
				WHEN 2 THEN 'CE' 
				WHEN 3 THEN 'TI' 
				WHEN 4 THEN 'RC' 
				WHEN 5 THEN 'PA' 
				WHEN 6 THEN 'AS' 
				WHEN 7 THEN 'MS' 
				WHEN 8 THEN 'NU' 
				WHEN 9 THEN 'CN' 
				WHEN 10 THEN 'CD' 
				WHEN 11 THEN 'SC' 
				WHEN 12 THEN 'PE' 
			END AS TIPODOCUMENTO,
			CASE p.IPSEXOPAC 
				WHEN 1 THEN 'H' 
				WHEN 2 THEN 'M' 
			END AS SEXO,
			p.IPPRINOMB AS [PRIMER NOMBRE],
			p.IPSEGNOMB AS [SEGUNDO NOMBRE],
			p.IPPRIAPEL AS [PRIMER APELLIDO],
			p.IPSEGAPEL AS [SEGUNDO APELLIDO],
			CASE p.IPSEXOPAC
			WHEN 1
                THEN 'Masculino'
                WHEN 2
                THEN 'Femenino'
            END AS GENERO, 
            CONVERT(varchar,p.IPFECNACI,21) AS FechaNacimiento,
            DATEDIFF(year, p.IPFECNACI, i.IFECHAING) AS EdadEnAtencion, 
            M.MUNNOMBRE AS Municipio, 
            DP.nomdepart AS Dpto, 
            CAST(p.GENEXPEDITIONCITY AS VARCHAR(20)) + ' - ' + ISNULL(ci.Name, '') AS [Lugar expedición Vie], 
            i.IFECHAING AS Fecha_Ingreso, 
            i.IESTADOIN AS EstadoIngreso, 
            uf.UFUDESCRI AS Unidad_Funcional, 
            HCU.ENFACTUAL AS Enfermedad_Actual, 
            em.FECALTPAC AS [Fecha alta Médica], 
            HC.CODDIAGNO AS CIE_10, 
            CIE10.NOMDIAGNO AS Diagnóstico, 
            PROF.NOMMEDICO AS Medico, 
            ESP.DESESPECI AS Especialidad, 
            i.IOBSERVAC AS Observaciones,
            CASE i.TIPOINGRE
                WHEN 1
                THEN 'Ambulatorio'
                WHEN 2
                THEN 'Hospitalario'
            END AS TipoIngreso, 
            1 AS Cantidad, 
            EXF.TALLAPACI AS [Talla (cm)], 
            CONVERT(INT, ROUND(EXF.PESOPACIE / 1000, 0), 0) AS [Peso (kg)], 
            CONVERT(VARCHAR, EXF.TENARTSIS, 100) + '/' + CONVERT(VARCHAR, EXF.TENARTDIA, 100) AS TA, 
            EXF.NEOPERCEF AS PC, 
            EXF.NEOPERABD AS PA, 
            MHC.DESCRIPCION AS Modelo,
            CASE
                WHEN i.UFUCODIGO IN('B00001', 'B00002', 'B00003', 'B00004', 'B00005', 'B00006', 'B00007', 'B00008', 'B00017')
                THEN 'Boyaca'
                WHEN i.UFUCODIGO IN('MET001', 'MET002', 'MET003', 'MET004', 'MET005')
                THEN 'Meta'
                WHEN i.UFUCODIGO IN('YOP002')
                THEN 'Yopal'
            END AS Regional, 
            p.IPDIRECCI AS Direccion, 
            p.IPTELEFON AS Telefono, 
            p.IPTELMOVI AS Celular,
            EXF.NEOPERCEF AS 'Solo para Neonatos - Perimetro Cefalico', 
            EXF.NEOPERTOR AS 'Solo para Neonatos - Perimetro Toraxico', 
            EXF.NEOPERABD AS 'Solo para Neonatos - Perimetro Abdominal', 
            EXF.TEMPERPAC AS 'Temperatura', 
            EXF.FRECARPAC AS 'Frecuencia Cardiaca', 
            EXF.FRERESPAC AS 'Frecuencia Respiratoria', 
            EXF.REGSO2PAC AS 'Saturacion de Oxigeno', 
            EXF.PB AS 'perímetro braquial', 
            EXF.DOLOR, --DOLOR (0-1-2-3-4-5-6-7-8-9-10)
            EXF.INTERPESOPARATALLA AS 'Interpretacion de la grafica peso para la talla', 
            EXF.INTERINDICEMASACO AS 'interpretacion de la grafica indice masa corporal', 
            EXF.INTERPESOPARAEDAD AS 'interpretacion de la grafica peso para la edad', 
            EXF.INTERPERIMETROCEFA AS 'interpretacion de la grafica perimetro cefalico', 
            EXF.INTERTALLAPARAEDAD AS 'interpretacion de la grafica talla para la edad', 
            EXF.INTERALTURAUTERINA AS 'interpretacion de la grafica altura uterina', 
            EXF.INTERIMCPARALAEDAD AS 'interpretacion de la grafica IMC para la edad', 
            ANTG.NOMSEMGES AS SEMANAS_GESTACIONALES, us.UserCode+'-'+ pus.Fullname UsuarioCrea, usm.UserCode +'-'+ pusm.Fullname UsuarioModifica--, 
            --DXS.Diagnosticos, 
            --DXS.Nombre_DIAGNOSTICOS
FROM [INDIGO031].[dbo].[ADINGRESO] AS i 
INNER JOIN [INDIGO031].[dbo].[INUNIFUNC] AS uf  ON uf.UFUCODIGO = i.UFUCODIGO
INNER JOIN [INDIGO031].[Contract].[CareGroup] AS ga  ON ga.Id = i.GENCAREGROUP
INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS p  ON p.IPCODPACI = i.IPCODPACI
LEFT OUTER JOIN [INDIGO031].[Contract].[HealthAdministrator] AS ea  ON ea.Id = i.GENCONENTITY
LEFT OUTER JOIN [INDIGO031].[Common].[City] AS ci  ON ci.Id = p.GENEXPEDITIONCITY
LEFT OUTER JOIN [INDIGO031].[Security].[UserInt] as us  on us.UserCode=i.CODUSUCRE
LEFT OUTER JOIN [INDIGO031].[Security].[PersonInt] as pus  on pus.Id=us.IdPerson
LEFT OUTER JOIN [INDIGO031].[Security].[UserInt] as usm  on usm.UserCode=i.CODUSUMOD
LEFT OUTER JOIN [INDIGO031].[Security].[PersonInt] as pusm  on pusm.Id=usm.IdPerson
LEFT OUTER JOIN [INDIGO031].[dbo].[HCHISPACA] AS HC  ON HC.NUMINGRES = i.NUMINGRES AND HC.IPCODPACI = HC.IPCODPACI AND HC.TIPHISPAC = 'i'
LEFT OUTER JOIN [INDIGO031].[dbo].[HCURGING1] AS HCU  ON HCU.NUMINGRES = HC.NUMINGRES AND HCU.IPCODPACI = HC.IPCODPACI AND HCU.NUMEFOLIO = HC.NUMEFOLIO
LEFT OUTER JOIN
    (SELECT IPCODPACI, NUMINGRES, MAX(NUMEFOLIO) AS Folio
         FROM [INDIGO031].[dbo].[INDIAGNOP]  
         WHERE(CODDIAPRI = 'True')
         GROUP BY NUMINGRES, IPCODPACI
     ) AS DX ON DX.IPCODPACI = HCU.IPCODPACI
                AND DX.NUMINGRES = HCU.NUMINGRES
                AND DX.Folio = HC.NUMEFOLIO
          LEFT OUTER JOIN [INDIGO031].[dbo].[INDIAGNOS] AS CIE10  ON CIE10.CODDIAGNO = HC.CODDIAGNO
          LEFT OUTER JOIN [INDIGO031].[dbo].[HCURGEVO1] AS HCU1  ON HCU.NUMINGRES = HC.NUMINGRES
                                                                                  AND HCU1.IPCODPACI = HC.IPCODPACI
                                                                                  AND HCU1.NUMEFOLIO = HC.NUMEFOLIO
          LEFT OUTER JOIN [INDIGO031].[dbo].[HCREGEGRE] AS em  ON em.IPCODPACI = HC.IPCODPACI
                                                                                AND em.NUMINGRES = HC.NUMINGRES
          INNER JOIN [INDIGO031].[dbo].[INUBICACI] AS UB  ON p.AUUBICACI = UB.AUUBICACI
          INNER JOIN [INDIGO031].[dbo].[INMUNICIP] AS M  ON UB.DEPMUNCOD = M.DEPMUNCOD
          INNER JOIN [INDIGO031].[dbo].[INDEPARTA] AS DP  ON M.DEPCODIGO = DP.depcodigo
          INNER JOIN [INDIGO031].[dbo].[INPROFSAL] AS PROF  ON HC.CODPROSAL = PROF.CODPROSAL
          INNER JOIN [INDIGO031].[dbo].[INESPECIA] AS ESP  ON PROF.CODESPEC1 = ESP.CODESPECI
          LEFT JOIN [INDIGO031].[dbo].[HCEXFISIC] AS EXF  ON i.IPCODPACI = EXF.IPCODPACI
                                                                           AND i.NUMINGRES = EXF.NUMINGRES
          LEFT OUTER JOIN [INDIGO031].[dbo].[PRMODELOHC] AS MHC  ON HC.IDMODELOHC = MHC.ID
          LEFT OUTER JOIN [INDIGO031].[dbo].[HCANTGINE] AS ANTG  ON ANTG.NUMINGRES = HC.NUMINGRES
                                                                                  AND ANTG.NUMEFOLIO = HC.NUMEFOLIO
     WHERE i.IFECHAING >= DATEADD(MONTH, -12, GETDATE()); 

