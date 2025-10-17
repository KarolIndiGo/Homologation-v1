-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_INGRESOSUCI
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [Report].[View_HDSAP_INGRESOSUCI]
AS
     SELECT         distinct
	                CASE PA.IPTIPODOC
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
							 WHEN '9'
                             THEN 'CN'
                             WHEN '11'
                             THEN 'SC'
                             WHEN '12'
                             THEN 'PE'
							 WHEN '13'
                             THEN 'PT'
                             WHEN '14'
                             THEN 'DE'
							  WHEN '15'
                             THEN 'SI'
                         END AS 'Tipo Documento',
	        PA.IPCODPACI AS Documento, 
            PA.IPNOMCOMP AS NombrePaciente, 
            ES.NUMINGRES AS Ingreso, 
            UF.UFUCODIGO AS CodigoUnidad, 
            UF.UFUDESCRI AS UnidadFuncional, 
            CA.DESCCAMAS AS Cama, 
            CONVERT(DATETIME, ES.FECINIEST, 101)  AS InicioEstancia, 
            CONVERT(DATETIME, ES.FECFINEST, 101) AS FinEstancia, 
            T2.FECHA AS FechaEgresoUnidad, 
            (datediff (year,CONVERT(DATETIME, pa.IPFECNACI, 101), getdate ())) EDAD, 
            EN.NOMENTIDA AS Entidad,
            CASE PA.IPTIPOPAC
                WHEN 1
                THEN 'Contributivo'
                WHEN 2
                THEN 'Subsidiado'
                WHEN 3
                THEN 'Vinculado'
                WHEN 4
                THEN 'Particular'
                WHEN 5
                THEN 'Otro'
                WHEN 6
                THEN 'Desplazado Reg. Contributivo'
                WHEN 7
                THEN 'Desplazado Reg. Subsidiado'
                WHEN 8
                THEN 'Desplazado No Asegurado'
                ELSE NULL
            END AS Regimen,
			p.CODDIAGNO [Codigo Diagnostico],
       s.NOMDIAGNO [Nombre Diagnostico],

	   case 
	   when p.DIAINGEGR = 'A'
	   then 'Diagnostico Ingreso'
	   when p.DIAINGEGR = 'I'
	   then 'Diagnostico Egreso'
	   end 'Estado Diagnostico',
	   case
	   when PA.ipsexopac = 1
	   then 'Masculino'
	   when PA.ipsexopac = 2
	   then 'Femenino'
	   end Sexo

     FROM CHREGESTA AS ES
          INNER JOIN CHCAMASHO AS CA ON ES.CODICAMAS = CA.CODICAMAS
          INNER JOIN INUNIFUNC AS UF ON CA.UFUCODIGO = UF.UFUCODIGO
          INNER JOIN INPACIENT AS PA ON ES.IPCODPACI = PA.IPCODPACI
		  INNER JOIN INDIAGNOP AS P ON P.NUMINGRES = ES.NUMINGRES
		  INNER JOIN INDIAGNOS AS S ON S.CODDIAGNO = P.CODDIAGNO
          INNER JOIN

     (
         SELECT NUMINGRES, 
                MIN(CONVERT(DATETIME, FECINIEST, 101) ) FECHA,
				CC.UFUCODIGO
         FROM CHREGESTA CR
              INNER JOIN CHCAMASHO CC ON CR.CODICAMAS = CC.CODICAMAS
              INNER JOIN INUNIFUNC UF ON CC.UFUCODIGO = UF.UFUCODIGO
         WHERE UF.UFUTIPUNI IN('5', '6')
         GROUP BY NUMINGRES, CC.UFUCODIGO
     ) AS T1 ON ES.NUMINGRES = T1.NUMINGRES
                AND T1.FECHA = ES.FECINIEST
          LEFT JOIN
     (
         SELECT NUMINGRES, 
                MAX(CONVERT(DATETIME, FECFINEST, 101) ) FECHA,
				CC.UFUCODIGO
         FROM CHREGESTA CR
              INNER JOIN CHCAMASHO CC ON CR.CODICAMAS = CC.CODICAMAS
              INNER JOIN INUNIFUNC UF ON CC.UFUCODIGO = UF.UFUCODIGO
         WHERE UF.UFUTIPUNI ='5'
         GROUP BY NUMINGRES, CC.UFUCODIGO
     ) AS T2 ON ES.NUMINGRES = T2.NUMINGRES
          INNER JOIN INENTIDAD AS EN ON PA.CODENTIDA = EN.CODENTIDA		  
WHERE UF.UFUTIPUNI IN ('5', '6') and p.CODDIAPRI = 1
  

