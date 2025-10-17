-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_LABORATORIOCOVID19
-- Extracted by Fabric SQL Extractor SPN v3.9.0







CREATE VIEW [Report].[View_HDSAP_LABORATORIOCOVID19]
AS
     SELECT PNQ.FECORDMED AS 'FechaMuestra', 
       MUN.MUNNOMBRE AS 'Municipio',
       CASE PAC.IPTIPODOC
           WHEN '1'
           THEN 'CC'
           WHEN '2'
           THEN 'CE'
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
           THEN 'NV'
           WHEN '12'
           THEN 'PE'
       END AS 'TipoDocumento', 
       PNQ.IPCODPACI AS 'NumeroDocumento',
	   '' AS 'Evento',
	   '415510047901' AS 'CodigoIPSQueEnvia',
	   '' AS 'SubcodigoIPSQueEnvia',
	   PAC.IPPRINOMB AS 'PrimerNombre',
	   PAC.IPSEGNOMB AS 'SegundoNombre',
	   PAC.IPPRIAPEL AS 'PrimerApellido',
	   PAC.IPSEGAPEL AS 'SegundoApellido',
	   PAC.IPFECNACI AS 'FechaNacimiento',
	   DATEDIFF(YEAR,PAC.IPFECNACI,PNQ.FECORDMED) AS 'Edad',
	   CASE
                WHEN PAC.IPSEXOPAC = '1'
                THEN 'Masculino'
                WHEN PAC.IPSEXOPAC = '2'
                THEN 'Femenino'
            END AS 'Sexo',
	   '' AS 'CondicionFinal',
	   A.NOMENTIDA AS 'EPS',
	   CASE PAC.TIPCOBSAL
           WHEN 1
           THEN 'Contributivo'
           WHEN 2
           THEN 'Subsidiado Total'
           WHEN 3
           THEN 'Subsidiado Parcial'
           WHEN 4
           THEN 'Poblacion Pobre sin Asegurar con SISBEN '
           WHEN 5
           THEN 'Poblacion Pobre sin Asegurar sin SISBEN'
           WHEN 6
           THEN 'Desplazados '
           WHEN 7
           THEN 'Plan de Salud Adicional'
           WHEN 8
           THEN 'Otros'
       END AS 'Regimen',
	   COU.Name AS 'PaisNacimiento',
	   'COLOMBIA' AS 'PaisResidencia',
	   DEP.NOMDEPART AS 'DepartamentoResidencia',
	   MUN.MUNNOMBRE AS 'MunicipioResidencia',
	   PAC.IPDIRECCI AS 'Direccion',
	   PAC.IPTELEFON AS 'TelefonoFijo',
	   PAC.IPTELMOVI AS 'TelefonoMovil',
	   'Laboratorio Salud Publica' AS 'LaboratorioAlQueEnvia',
	   '' AS 'TrabajadorSalud',
	   '' AS 'ContactoCasoConfirmado',
	   '' AS 'TipoPrueba',
	   '' AS 'Resultado',
	   PNQ.OBSSERIPS AS 'Observaciones',
	   SUBSTRING(CUP.CODSERIPS,0,7) + ' - ' + CUP.DESSERIPS AS 'CodigoCUPS'
FROM (select FECORDMED,IPCODPACI, OBSSERIPS, NUMINGRES, CODSERIPS 
      from HCORDPRON
	  union
	  select FECORDMED,IPCODPACI, OBSSERIPS, NUMINGRES, CODSERIPS 
      from HCORDLABO) AS PNQ
     INNER JOIN INPACIENT AS PAC ON PNQ.IPCODPACI = PAC.IPCODPACI
     LEFT JOIN INUBICACI AS UBI ON PAC.AUUBICACI = UBI.AUUBICACI
     LEFT JOIN INMUNICIP AS MUN ON UBI.DEPMUNCOD = MUN.DEPMUNCOD
	 LEFT JOIN ADINGRESO AS I ON I.NUMINGRES = PNQ.NUMINGRES
	 LEFT JOIN INENTIDAD AS A ON A.CODENTIDA = I.CODENTIDA
	 LEFT JOIN Common.Country AS COU ON PAC.IDPAIS=COU.Id
	 LEFT JOIN INDEPARTA AS DEP ON MUN.DEPCODIGO=DEP.DEPCODIGO
	 LEFT JOIN INCUPSIPS AS CUP ON PNQ.CODSERIPS=CUP.CODSERIPS
WHERE PNQ.CODSERIPS in ('920307','332206','908856');



