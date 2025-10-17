-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_DIU
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[View_HDSAP_DIU]
AS


SELECT    distinct
         a.feciniate Fecha,
		 CASE i.IPTIPODOC
                             WHEN '1'
                             THEN 'CC'
                             WHEN '2'
                             THEN 'CE '
                             WHEN '3'
                             THEN 'TI'
                             WHEN '4'
                             THEN 'RC'
                             WHEN '5'
                             THEN 'PA'
                             WHEN '6'
                             THEN 'AS'
                             WHEN '7'
                             THEN 'MS'
                             WHEN '8'
                             THEN 'NU'
							 WHEN 9
							 THEN 'CN'
							 WHEN 11
							 THEN 'SC'
							 WHEN 12
							 THEN 'PE'
							 WHEN 13
							 THEN 'PT'
							 WHEN 14
							 THEN 'DE'
							 WHEN 15
							 THEN 'SI'
                         END AS 'Tipo de documento de identidad', 
						 i.IPCODPACI 'No. De Identificación',
						 i.IPPRIAPEL 'Apellido 1',
						 i.IPSEGAPEL 'Apellido 2',
						 i.IPPRINOMB 'Nombre 1',
						 i.IPSEGNOMB 'Nombre 2',
						 n.NOMENTIDA EPS,
						 i.IPFECNACI 'FECHA DE NACIMIENTO',
						 (datediff (year,i.IPFECNACI, getdate ())) EDAD,
						 i.IPTELEFON 'Teléfono usuaria',
						 depa.NOMDEPART Departamento,
						 mun.MUNNOMBRE Municipio,
						 i.IPDIRECCI Direccion,
						 'Descripcion CUPS' DIU,
						 n.NOMENTIDA Entidad,
						 a.FECINIATE FechaEntrega

FROM HCATINPAR  A 
join ADINGRESO ad on ad.NUMINGRES = a.NUMINGRES
join INPACIENT i on i.IPCODPACI = a.IPCODPACI
join INENTIDAD n on n.CODENTIDA = i.CODENTIDA
JOIN INPROFSAL PRO ON PRO.CODPROSAL = A.CODPROSAL
INNER JOIN INUBICACI AS UBI ON i.AUUBICACI= UBI.AUUBICACI
INNER JOIN INMUNICIP AS MUN ON UBI.DEPMUNCOD= MUN.DEPMUNCOD
INNER JOIN INDEPARTA AS depa on depa.DEPCODIGO = MUN.DEPCODIGO
where a.ANALISISP like '%DIU%'
  

