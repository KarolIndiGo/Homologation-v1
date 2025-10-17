-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_AD_HC_PerfilEpidemiologico
-- Extracted by Fabric SQL Extractor SPN v3.9.0






create VIEW [ViewInternal].[IMO_AD_HC_PerfilEpidemiologico]
AS
SELECT YEAR(ing.IFECHAING) AS Año, ing.NUMINGRES AS Ingreso, A.IPNOMCOMP AS Paciente, A.IPCODPACI AS Identificacion, 
                  CASE IPTIPODOC WHEN 1 THEN 'CC' WHEN 2 THEN 'CE' WHEN 3 THEN 'TI' WHEN 4 THEN 'RC' WHEN 5 THEN 'PA' WHEN 6 THEN 'AS' WHEN 7 THEN 'MS' WHEN 8 THEN 'NU' END AS TipoIdentificacion, 
                  CASE IPSEXOPAC WHEN 1 THEN 'Masculino' WHEN 2 THEN 'Femenino' END AS Genero, 
				  DATEDIFF(year, A.IPFECNACI, ing.IFECHAING) AS Edad_Años,  CASE IPESTADOC WHEN 1 THEN 'Soltero' WHEN 2 THEN 'Casado' WHEN 3 THEN 'Viudo' WHEN 4 THEN 'Union Libre' WHEN 5 THEN 'Separado/Div' END AS [Estado Civil], 
                  I.NIVEDESCRI AS [Nivel Educativo], F.desactivi AS Ocupación, B.name AS Entidad, 
                  CASE IPTIPOPAC WHEN 1 THEN 'Contributivo' WHEN 2 THEN 'Subsidiado' WHEN 3 THEN 'Vinculado' WHEN 4 THEN 'Particular' WHEN 5 THEN 'Otro' WHEN 6 THEN 'Desplazado Reg. Contributivo' WHEN 7 THEN 'Desplazado Reg. Subsidiado' WHEN
                   8 THEN 'Desplazado No Asegurado' END AS TipoAfiliacion, A.IPESTRATO AS ESTRATO, 
                  CASE ING.IINGREPOR WHEN 1 THEN 'Urgencias' WHEN 2 THEN 'Consulta Externa' WHEN 3 THEN 'Nacido Hospital' WHEN 4 THEN 'Remitido' WHEN 5 THEN 'Hospitalización de Urgencias' END AS IngresoPor, 
                  CASE ING.TIPOINGRE WHEN 1 THEN 'Ambulatorio' WHEN 2 THEN 'Hospitalario' END AS TipoIngreso, ing.IFECHAING AS [Fecha atencion], uf.UFUDESCRI AS Servicio, ES1.DESESPECI AS [Especialidad Tratante], ing.CODDIAING AS CIE10, 
                  dx.NOMDIAGNO AS [Dx Ingreso], Dx1.DIAGNOSTICO AS CodOtrDx, Dx1.NOMBRE AS OtrosDx, ing.CODDIAEGR AS CodEgreso, dxe.NOMDIAGNO AS [Dx Egreso], ca.NOMCENATE AS Sucursal, 
                  CASE A.ZONAPARTADA WHEN 'False' THEN 'Urbana' WHEN 'True' THEN 'Rural' END AS Area, D.UBINOMBRE AS Ubicacion, m.MUNNOMBRE AS MunicipioProcedencia, DEP.nomdepart AS Departamento, 
                  G.DESGRUPET AS GRUPOETNICO, J.CREDDESCRI AS Religion, PE1.DESCRIPCION AS [Población Vulnerable], W.DISCDESCRI AS Discapacidad, cm.DESCAUMUE AS [Causa Muerte], CASE WHEN CONVERT(char(10), eg.FECMUEPAC, 103) 
                  = '01/01/1900' THEN ing.FECHEGRESO WHEN CONVERT(char(10), eg.FECMUEPAC, 103) <> '01/01/1900' THEN eg.FECMUEPAC END AS [Fecha de Defunción], A.IPFECNACI AS FechaNacimiento, A.IPDIRECCI AS Direccion, 
                  A.IPTELEFON AS Telefono, A.IPTELMOVI AS Celular, 
                  CASE GRUPCODIGO WHEN 1 THEN 'CARCELARIOS' WHEN 2 THEN 'DESPLAZADOS' WHEN 3 THEN 'MIGRANTES' WHEN 4 THEN 'GESTANTES' WHEN 5 THEN 'HABITANTES DE LA CALLE' WHEN 4 THEN 'OTRO' END AS GrupoEspecial, 
                  ing.FECHEGRESO AS FechaEgreso, 
				  CASE ESTPACEGR WHEN 1 THEN 'Mejor' WHEN 2 THEN 'Igual o Peor' 
				  WHEN 3 THEN 'Fallecido' WHEN 4 THEN 'Remitido' WHEN 5 
				  THEN 'Hospitalizacion en Casa' END AS [Condicion de Egreso], uf.UFUCODIGO,
			case when DATEDIFF(year, A.IPFECNACI, ing.IFECHAING)  <= '5' THEN '1 a 5 años'
				 when DATEDIFF(year, A.IPFECNACI, ing.IFECHAING)  between '6' and '11'  THEN '6 a 11 años'
				 when DATEDIFF(year, A.IPFECNACI, ing.IFECHAING)  between '12' and '17' then '12 a 17 años'
				 when DATEDIFF(year, A.IPFECNACI, ing.IFECHAING)  between '18' and '28' then '18 a 28 años'
				 when DATEDIFF(year, A.IPFECNACI, ing.IFECHAING)  between '29' and '59' then '29 a 59 años'
				 when DATEDIFF(year, A.IPFECNACI, ing.IFECHAING)  >= '60'   then 'Mayor a 60 años' 
				 end as RangoEdad, tt.Nit, ga.name as GrupoAtencion
				    
FROM     dbo.ADINGRESO AS ing  INNER JOIN
                  dbo.INUNIFUNC AS uf ON uf.UFUCODIGO = ing.UFUCODIGO 
				  --AND uf.UFUCODIGO LIKE 'N%' 
				  INNER JOIN
                  dbo.INPACIENT AS A  ON ing.IPCODPACI = A.IPCODPACI AND YEAR(ing.IFECHAING) >= '2022' INNER JOIN
                  Contract.HealthAdministrator AS B  ON B.id = ing.GENCONENTITY INNER JOIN
				  Common.ThirdParty AS tt  ON tt.id = b.ThirdPartyId INNER JOIN
                  --dbo.COCONTRAT AS C  ON C.CODCONTRA = A.CCCONTRAT INNER JOIN
                  dbo.INUBICACI AS D  ON D.AUUBICACI = A.AUUBICACI INNER JOIN
                  dbo.ADNIVELES AS E  ON E.NIVCODIGO = A.NIVCODIGO LEFT OUTER JOIN
                  dbo.INUNIFUNC AS ufh ON ufh.UFUCODIGO = ing.UFUINGMED 
				  --AND uf.UFUCODIGO LIKE 'N%'
				  INNER JOIN
                  dbo.ADACTIVID AS F  ON F.codactivi = A.CODACTIVI LEFT OUTER JOIN
                  dbo.ADGRUETNI AS G  ON G.CODGRUPOE = A.CODGRUPOE LEFT OUTER JOIN
                  dbo.SEGusuaru AS H1  ON H1.CODUSUARI = A.CODUSUCRE LEFT OUTER JOIN
                  dbo.SEGusuaru AS H2  ON H2.CODUSUARI = A.CODUSUMOD LEFT OUTER JOIN
                  dbo.ADNIVELED AS I  ON I.NIVECODIGO = A.NIVECODIGO LEFT OUTER JOIN
                  dbo.ADDISCAPACI AS W  ON W.DISCCODIGO = A.DISCCODIGO LEFT OUTER JOIN
                  dbo.ADCREDO AS J  ON J.CREDCODIGO = A.CREDCODIGO INNER JOIN
                  dbo.INUBICACI AS u  ON u.AUUBICACI = A.AUUBICACI LEFT OUTER JOIN
                  dbo.INMUNICIP AS m  ON m.DEPMUNCOD = u.DEPMUNCOD LEFT OUTER JOIN
                  dbo.INDEPARTA AS DEP  ON m.DEPCODIGO = DEP.depcodigo LEFT OUTER JOIN
                  Contract.CareGroup AS ga  ON ga.Id = ing.GENCAREGROUP LEFT OUTER JOIN
                  dbo.HCHISPACA AS HC  ON HC.NUMINGRES = ing.NUMINGRES AND HC.TIPHISPAC = 'I' LEFT OUTER JOIN
                  dbo.INESPECIA AS ES1  ON ES1.CODESPECI = HC.CODESPTRA LEFT OUTER JOIN
                  dbo.ADPOBESPEPAC AS pe  ON pe.IPCODPACI = A.IPCODPACI LEFT OUTER JOIN
                  dbo.ADPOBESPE AS PE1  ON PE1.ID = pe.IDADPOBESPE LEFT OUTER JOIN
                  dbo.INDIAGNOS AS dx  ON dx.CODDIAGNO = ing.CODDIAING LEFT OUTER JOIN
                  dbo.INDIAGNOS AS dxe  ON dxe.CODDIAGNO = ing.CODDIAEGR INNER JOIN
                  dbo.ADCENATEN AS ca  ON ca.CODCENATE = ing.CODCENATE LEFT OUTER JOIN
                  dbo.HCREGEGRE AS eg  ON eg.NUMINGRES = ing.NUMINGRES LEFT OUTER JOIN
                  dbo.INCAUMUER AS cm  ON cm.CODCAUMUE = eg.CODCAUMUE LEFT OUTER JOIN
                      (SELECT DISTINCT A.CODDIAGNO AS DIAGNOSTICO, B.NOMDIAGNO AS NOMBRE, A.NUMINGRES
                       FROM      dbo.INDIAGNOH AS A INNER JOIN
                                         dbo.INDIAGNOS AS B ON A.CODDIAGNO = B.CODDIAGNO) AS Dx1 ON Dx1.NUMINGRES = ing.NUMINGRES AND Dx1.DIAGNOSTICO <> HC.CODDIAGNO
WHERE  (A.CORELEPAC IS NOT NULL) AND (ing.CODCENATE in ( '001')) and 
YEAR(ing.IFECHAING) >= '2022' AND ing.IESTADOIN <> 'A' and a.IPCODPACI <> '0123456789'

