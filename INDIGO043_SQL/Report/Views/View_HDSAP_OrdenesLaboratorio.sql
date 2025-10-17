-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_OrdenesLaboratorio
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[View_HDSAP_OrdenesLaboratorio]
AS
     SELECT I.IPCODPACI AS Cedula, 
            P.IPNOMCOMP AS Nombre, 
			DATEDIFF(YEAR, P.IPFECNACI, GETDATE()) AS Edad,
            I.NUMINGRES AS Ingreso, 
            U.UFUDESCRI AS UnidadSolicita, 
			CAM.DESCCAMAS AS Cama,
            i.numefolio AS [FolioSolicita], 
            I.FECORDMED AS FechaOrden, 
            I.CODSERIPS AS CodigoServicio, 
            C.DESSERIPS AS DescripciónServicio, 
            I.CANSERIPS AS CantidadSolicitada, 
            i.CODPROSAL AS CodMedico, 
            pr3.NOMMEDICO AS NombreMedico,
            CASE
                WHEN i.ESTSERIPS = 1
                THEN 'Solicitado'
                WHEN i.ESTSERIPS = 2
                THEN 'Muestra Recolectada '
                WHEN i.ESTSERIPS = 3
                THEN 'Resultado Entregado'
                WHEN i.ESTSERIPS = 4
                THEN 'Examen Interpretado'
                WHEN i.ESTSERIPS = 5
                THEN 'Remitido'
                WHEN i.ESTSERIPS = 6
                THEN 'Anulado'
                WHEN i.ESTSERIPS = 7
                THEN 'Extramural'
                WHEN i.ESTSERIPS = 7
                THEN 'Muestra Recolectada Parcialmente'
            END AS [EstadoSolicitud], 
            i.FECRECMUE AS [FechaLlegaLaboratorio], 
            i.FECHARESULT AS [FechaResultado], 
            i.INTERPRET AS [Interpretación], 
            i.CODPROINT AS [CodMedicoInterpreta], 
            PR2.NOMMEDICO AS [MedicoInterpreta], 
            i.NUMFOLINT AS [FolioInterpreta], 
            hc.fechispac AS [FechaInterpretacion], 
            i.USURECMUE AS [CodAuxRecepciona], 
            pr4.NOMMEDICO AS [AuxRecepciona], 
            ma.DESMOTANU AS [MotivoMuestraNoConforme], 
            i.OBSERMUESTRANOCONFORME AS [ObserMuestraNoConforme], 
            DATEDIFF(minute, I.FECORDMED, i.FECRECMUE) AS [SolicitudVSRecepcion], 
            DATEDIFF(minute, i.FECHARESULT, hc.fechispac) AS [ResultadoVSInterpretacion]
     FROM .hcordlabo AS I
          INNER JOIN .INPACIENT AS P ON P.IPCODPACI = I.IPCODPACI
          INNER JOIN .INUNIFUNC AS U ON U.UFUCODIGO = I.UFUCODIGO
          INNER JOIN .INCUPSIPS AS C ON C.CODSERIPS = I.CODSERIPS
          INNER JOIN .INCUPSSUB AS SG ON SG.CODGRUSUB = C.CODGRUSUB
          LEFT JOIN dbo.HCMOANULB AS ma ON ma.CODMOTANU = i.CODMOTIVOMUESTRANOCONFORME
          LEFT JOIN .ADINGRESO ON I.NUMINGRES = ADINGRESO.NUMINGRES
          LEFT JOIN .HCHISPACA AS hc ON i.numingres = hc.NUMINGRES
                                                  AND i.NUMFOLINT = hc.NUMEFOLIO
          LEFT JOIN dbo.INPROFSAL AS PR2 ON PR2.CODPROSAL = i.CODPROINT
          LEFT JOIN dbo.INPROFSAL AS pr3 ON pr3.CODPROSAL = i.CODPROSAL
          LEFT JOIN dbo.INPROFSAL AS pr4 ON pr4.CODPROSAL = i.USURECMUE
		  INNER JOIN dbo.CHREGESTA AS EST ON I.IPCODPACI = EST.IPCODPACI
                                                  AND I.NUMINGRES = EST.NUMINGRES
												  and I.FECORDMED BETWEEN EST.FECINIEST and EST.FECFINEST
	      INNER JOIN dbo.CHCAMASHO AS CAM ON EST.CODICAMAS=CAM.CODICAMAS

