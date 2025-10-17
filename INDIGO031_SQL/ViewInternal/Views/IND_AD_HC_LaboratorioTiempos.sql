-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_AD_HC_LaboratorioTiempos
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[IND_AD_HC_LaboratorioTiempos]
AS
     SELECT DISTINCT 
            L.IPCODPACI AS DocPcte, 
            P.IPNOMCOMP AS NombrePcte,
			YEAR(GETDATE()) - YEAR(P.IPFECNACI) AS Edad,P.IPESTRATO AS Estrato,GE.DESGRUPET as GrupoEtnico,NE.NIVEDESCRI AS NivelEducativo,
            L.NUMINGRES AS Ingreso, 
            I.IFECHAING AS FechaIngreso, 
            L.UFUCODIGO AS CodUnidad, 
            U.UFUDESCRI AS UnidadFuncional, 
            L.CODPROSAL AS CodMedicoSolicita, 
            M.NOMMEDICO AS NombreMedicoSolicita, 
            L.FECORDMED AS FechaSolicitud, 
            L.CODSERIPS AS CodServicio, 
            S.DESSERIPS AS Servicio,
            CASE
                WHEN L.ESTSERIPS = '1'
                THEN 'Solicitado'
                WHEN L.ESTSERIPS = '2'
                THEN 'MuestraRecolectada'
                WHEN L.ESTSERIPS = '3'
                THEN 'ResultadoEntregado'
                WHEN L.ESTSERIPS = '4'
                THEN 'ExamenInterpretado'
                WHEN L.ESTSERIPS = '5'
                THEN 'Remitido'
                WHEN L.ESTSERIPS = '6'
                THEN 'Anulado'
                WHEN L.ESTSERIPS = '7'
                THEN 'Extramural'
                WHEN L.ESTSERIPS = '8'
                THEN 'MuestraRecolectadaParcialmente'
            END AS EstadoLaboratorio, 
            L.CODPROINT, 
            MI.NOMMEDICO AS MedicoInterpreta, 
            L.FECRECMUE AS FechaRecoleccionMuestra, 
            L.INTERPRET AS Interpretacion, 
            Z.FECGENERA AS FechaEntregaResultado, 
            DATEDIFF(MINUTE, L.FECORDMED, L.FECRECMUE) AS TiempoToma1, 
            DATEDIFF(MINUTE, L.FECRECMUE, Z.FECGENERA) AS TiempoResultado, 
            DATEDIFF(MINUTE, L.FECORDMED, Z.FECGENERA) AS TiempoTotal, 
            l.obsserips AS Observacion,
            CASE l.priserips
                WHEN 1
                THEN 'Urgente'
                WHEN 2
                THEN 'Rutina'
            END AS Prioridad, 
            caa.CODCENATE AS Codcc, 
            caa.nomcenate AS CentroAtencion, 
            'Intrahospitalario' AS Tipo
     FROM dbo.HCORDLABO AS L
          INNER JOIN dbo.ADINGRESO AS I  ON L.NUMINGRES = I.NUMINGRES
          INNER JOIN dbo.INPACIENT AS P  ON L.IPCODPACI = P.IPCODPACI
          INNER JOIN dbo.INUNIFUNC AS U  ON L.UFUCODIGO = U.UFUCODIGO
          INNER JOIN dbo.INPROFSAL AS M  ON L.CODPROSAL = M.CODPROSAL
          INNER JOIN dbo.INCUPSIPS AS S  ON L.CODSERIPS = S.CODSERIPS
          LEFT OUTER JOIN dbo.INPROFSAL AS MI  ON L.CODPROINT = MI.CODPROSAL
          LEFT OUTER JOIN dbo.INTERCTRL AS Z  ON L.AUTO = Z.AUTOLABOR
          LEFT OUTER JOIN dbo.adcenaten AS caa  ON caa.codcenate = l.codcenate
		  LEFT OUTER JOIN dbo.ADNIVELED  AS NE   on  P.NIVCODIGO = NE.NIVECODIGO 
		 LEFT OUTER JOIN dbo.ADGRUETNI AS GE    on  P.CODGRUPOE = GE.CODGRUPOE
     WHERE (L.FECORDMED >= '01/01/2022')  and (I.IESTADOIN <> 'A')
     UNION ALL
     SELECT DISTINCT 
            L.IPCODPACI AS DocPcte, 
            P.IPNOMCOMP AS NombrePcte,
			YEAR(GETDATE()) - YEAR(P.IPFECNACI) AS Edad,P.IPESTRATO AS Estrato,GE.DESGRUPET as GrupoEtnico,NE.NIVEDESCRI AS NivelEducativo,
            L.NUMINGRES AS Ingreso, 
            I.IFECHAING AS FechaIngreso, 
            L.UFUCODIGO AS CodUnidad, 
            U.UFUDESCRI AS UnidadFuncional, 
            L.CODPROSAL AS CodMedicoSolicita, 
            M.NOMMEDICO AS NombreMedicoSolicita, 
            L.FECORDMED AS FechaSolicitud, 
            L.CODSERIPS AS CodServicio, 
            S.DESSERIPS AS Servicio,
            CASE
                WHEN L.ESTSERIPS = '1'
                THEN 'Solicitado'
                WHEN L.ESTSERIPS = '2'
                THEN 'MuestraRecolectada'
                WHEN L.ESTSERIPS = '3'
                THEN 'ResultadoEntregado'
                WHEN L.ESTSERIPS = '4'
                THEN 'ExamenInterpretado'
                WHEN L.ESTSERIPS = '5'
                THEN 'Remitido'
                WHEN L.ESTSERIPS = '6'
                THEN 'Anulado'
                WHEN L.ESTSERIPS = '7'
                THEN 'Extramural'
                WHEN L.ESTSERIPS = '8'
                THEN 'MuestraRecolectadaParcialmente'
            END AS EstadoLaboratorio, 
            '' AS CODPROINT, 
            '' AS MedicoInterpreta, 
            L.FECRECMUE AS FechaRecoleccionMuestra, 
            L.INTERPRET AS Interpretacion, 
            Z.FECGENERA AS FechaEntregaResultado, 
            DATEDIFF(MINUTE, L.FECORDMED, L.FECRECMUE) AS TiempoToma1, 
            DATEDIFF(MINUTE, L.FECRECMUE, Z.FECGENERA) AS TiempoResultado, 
            DATEDIFF(MINUTE, L.FECORDMED, Z.FECGENERA) AS TiempoTotal, 
            '' AS Observacion, 
            '' AS Prioridad, 
            caa.CODCENATE AS Codcc, 
            caa.nomcenate AS CentroAtencion, 
            'Ambulatorio' AS Tipo
     FROM dbo.AMBORDLAB AS L
          INNER JOIN dbo.ADINGRESO AS I  ON L.NUMINGRES = I.NUMINGRES
          INNER JOIN dbo.INPACIENT AS P  ON L.IPCODPACI = P.IPCODPACI
          INNER JOIN dbo.INUNIFUNC AS U  ON L.UFUCODIGO = U.UFUCODIGO
          INNER JOIN dbo.INPROFSAL AS M  ON L.CODPROSAL = M.CODPROSAL
          INNER JOIN dbo.INCUPSIPS AS S  ON L.CODSERIPS = S.CODSERIPS
		  LEFT OUTER JOIN dbo.ADNIVELED  AS NE   on  P.NIVCODIGO = NE.NIVECODIGO 
		  LEFT OUTER JOIN dbo.ADGRUETNI AS GE    on  P.CODGRUPOE = GE.CODGRUPOE
          LEFT OUTER JOIN --dbo.INPROFSAL AS MI with (nolock) ON L.CODPROINT = MI.CODPROSAL INNER JOIN
          dbo.INTERCTRL AS Z  ON L.AUTO = Z.AUTOLABOR
          LEFT OUTER JOIN dbo.adcenaten AS caa  ON caa.codcenate = l.codcenate
     WHERE (L.FECORDMED >= '01/01/2022') and (I.IESTADOIN <> 'A'); 
