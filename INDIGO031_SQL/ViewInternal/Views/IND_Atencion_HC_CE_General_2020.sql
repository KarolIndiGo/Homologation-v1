-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_Atencion_HC_CE_General_2020
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[IND_Atencion_HC_CE_General_2020]   
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
 p.IPNOMCOMP AS [Nombre Paciente],     
 CONVERT(VARCHAR(10), p.IPFECNACI, 101) AS FechaNacimiento,     
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
  WHEN I.UFUCODIGO IN('B00001', 'B00002', 'B00003', 'B00004', 'B00005', 'B00006', 'B00007', 'B00008', 'B00017')    
  THEN 'Boyaca'    
  WHEN I.UFUCODIGO IN('MET001', 'MET002', 'MET003', 'MET004', 'MET005')    
  THEN 'Meta'    
  WHEN I.UFUCODIGO IN('YOP002')    
  THEN 'Yopal'    
 END AS Regional,     
 P.IPDIRECCI AS Direccion,     
 P.IPTELEFON AS Telefono,     
 P.IPTELMOVI AS Celular,     
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
 ANTG.NOMSEMGES AS SEMANAS_GESTACIONALES,     
 DXS.DIAGNOSTICOS,     
 DXS.NOMBRE_DIAGNOSTICOS, us.UserCode+'-'+ pus.Fullname UsuarioCrea, usm.UserCode +'-'+ pusm.Fullname UsuarioModifica    
FROM dbo.ADINGRESO AS i     
INNER JOIN dbo.INUNIFUNC AS uf  ON uf.UFUCODIGO = i.UFUCODIGO    
INNER JOIN Contract.CareGroup AS ga  ON ga.Id = i.GENCAREGROUP    
INNER JOIN dbo.INPACIENT AS p  ON p.IPCODPACI = i.IPCODPACI    
LEFT OUTER JOIN Contract.HealthAdministrator AS ea  ON ea.Id = i.GENCONENTITY    
LEFT OUTER JOIN Common.City AS ci  ON ci.Id = p.GENEXPEDITIONCITY 
LEFT OUTER JOIN Security.[User] as us  on us.UserCode=i.CODUSUCRE
		  LEFT OUTER JOIN Security.[Person] as pus  on pus.Id=us.IdPerson
		  LEFT OUTER JOIN Security.[User] as usm  on usm.UserCode=i.CODUSUMOD
		  LEFT OUTER JOIN Security.[Person] as pusm  on pusm.Id=usm.IdPerson
LEFT OUTER JOIN dbo.SEGusuaru AS uu  ON uu.CODUSUARI = i.CODUSUMOD    
LEFT OUTER JOIN dbo.HCHISPACA AS HC  ON HC.NUMINGRES = i.NUMINGRES AND HC.IPCODPACI = HC.IPCODPACI AND HC.TIPHISPAC = 'i'    
LEFT OUTER JOIN dbo.HCURGING1 AS HCU  ON HCU.NUMINGRES = HC.NUMINGRES AND HCU.IPCODPACI = HC.IPCODPACI AND HCU.NUMEFOLIO = HC.NUMEFOLIO    
LEFT OUTER JOIN (SELECT IPCODPACI, NUMINGRES, MAX(NUMEFOLIO) AS Folio    
    FROM dbo.INDIAGNOP      
    WHERE(CODDIAPRI = 'True')    
    GROUP BY NUMINGRES, IPCODPACI    
  ) AS DX ON DX.IPCODPACI = HCU.IPCODPACI AND DX.NUMINGRES = HCU.NUMINGRES AND DX.Folio = HC.NUMEFOLIO    
LEFT OUTER JOIN dbo.INDIAGNOS AS CIE10  ON CIE10.CODDIAGNO = HC.CODDIAGNO    
LEFT OUTER JOIN dbo.HCURGEVO1 AS HCU1  ON HCU.NUMINGRES = HC.NUMINGRES    
                  AND HCU1.IPCODPACI = HC.IPCODPACI    
                  AND HCU1.NUMEFOLIO = HC.NUMEFOLIO    
LEFT OUTER JOIN dbo.ADINGRESO AS I2  ON I2.NUMINGRES = i.NUMINGRES    
LEFT OUTER JOIN dbo.INUNIFUNC AS D  ON I2.UFUAACTHOS = D.UFUCODIGO    
LEFT OUTER JOIN dbo.HCREGEGRE AS em  ON em.IPCODPACI = HC.IPCODPACI    
                 AND em.NUMINGRES = HC.NUMINGRES    
LEFT OUTER JOIN dbo.SEGusuaru AS u  ON u.CODUSUARI = i.CODUSUCRE    
INNER JOIN dbo.INUBICACI AS UB  ON p.AUUBICACI = UB.AUUBICACI    
INNER JOIN dbo.INMUNICIP AS M  ON UB.DEPMUNCOD = M.DEPMUNCOD    
INNER JOIN dbo.INDEPARTA AS DP  ON M.DEPCODIGO = DP.depcodigo    
INNER JOIN dbo.INPROFSAL AS PROF  ON HC.CODPROSAL = PROF.CODPROSAL    
INNER JOIN dbo.INESPECIA AS ESP  ON PROF.CODESPEC1 = ESP.CODESPECI    
LEFT JOIN dbo.HCEXFISIC AS EXF  ON i.IPCODPACI = EXF.IPCODPACI    
                AND i.NUMINGRES = EXF.NUMINGRES    
LEFT OUTER JOIN dbo.PRMODELOHC AS MHC  ON HC.IDMODELOHC = MHC.ID    
LEFT OUTER JOIN dbo.HCANTGINE AS ANTG  ON ANTG.NUMINGRES = HC.NUMINGRES    
                  AND ANTG.NUMEFOLIO = HC.NUMEFOLIO    
INNER JOIN (  SELECT t2.NUMEFOLIO,     
t2.NUMINGRES,     
t2.IPCODPACI,     
DIAGNOSTICOS = STUFF(    
(    
SELECT ', ' + CODDIAGNO    
FROM dbo.INDIAGNOP t1     
WHERE t1.NUMINGRES = t2.NUMINGRES FOR XML PATH('')    
), 1, 1, ''),     
NOMBRE_DIAGNOSTICOS = STUFF(    
(    
SELECT ', ' + LTRIM(RTRIM(NOMDIAGNO))    
FROM dbo.INDIAGNOP AS T1     
 INNER JOIN dbo.INDIAGNOS AS B  ON B.CODDIAGNO = T1.CODDIAGNO    
WHERE t1.NUMINGRES = t2.NUMINGRES FOR XML PATH('')    
), 1, 1, '')    
FROM dbo.INDIAGNOP t2     
WHERE FECDIAGNO between '01-01-2020 00:00:00' and '12-31-2020 23:59:00'
--t2.FECDIAGNO >= DATEADD(MONTH, -10, GETDATE())    
GROUP BY t2.NUMEFOLIO, t2.NUMINGRES, t2.IPCODPACI ) AS DXS ON DXS.NUMINGRES = HC.NUMINGRES AND DXS.NUMEFOLIO = HC.NUMEFOLIO    
--WHERE i.IFECHAING >= DATEADD(MONTH, -6, GETDATE())    
