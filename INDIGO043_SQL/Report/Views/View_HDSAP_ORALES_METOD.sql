/****** Object:  View [Report].[View_HDSAP_ORALES_METODO]    Script Date: 16/10/2025 6:20:17 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Miguel Angel Ruiz Vega
-- Create date: 03-01-2024
-- Description:	IAMI
-- =============================================

CREATE VIEW [Report].[View_HDSAP_ORALES_METODO]
AS



SELECT    
          ad.IFECHAING Fecha,
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
						 depa.NOMDEPART Departamento,
						 mun.MUNNOMBRE Municipio,
						 case ubi.TIPOUBICA 
						 when 0
						 then 'Urbano'
						 when 1
						 then 'Rural'
						 end Zona,
						 i.IPTELEFON 'Teléfono usuaria',
						 i.IPDIRECCI 'Dirección de Residencia'


FROM HCHOJAMED  A 
join ADINGRESO ad on ad.NUMINGRES = a.NUMINGRES
join INPACIENT i on i.IPCODPACI = a.IPCODPACI
join INENTIDAD n on n.CODENTIDA = i.CODENTIDA
JOIN INPROFSAL PRO ON PRO.CODPROSAL = A.CODPROSAL
INNER JOIN INUBICACI AS UBI ON i.AUUBICACI= UBI.AUUBICACI
INNER JOIN INMUNICIP AS MUN ON UBI.DEPMUNCOD= MUN.DEPMUNCOD
INNER JOIN INDEPARTA AS depa on depa.DEPCODIGO = MUN.DEPCODIGO
where a.CODPRODUC in ('19988571-01') 

GO


