-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_DiagnosticoPacientemayor15años
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[IND_DiagnosticoPacientemayor15años]
AS
     SELECT 
	
	 I.NUMINGRES AS Ingreso, 
            P.IPCODPACI AS Documento, 
            DP.FECDIAGNO AS FechaDX, 
            P.IPNOMCOMP AS Paciente, 
            CONVERT(VARCHAR(10), P.IPFECNACI, 103) AS FechaNacimiento, 
			CAST(DATEDIFF(dd, P.IPFECNACI, DP.FECDIAGNO) / 365.25 AS INT) AS EdadAtencion,
            CASE P.IPSEXOPAC
                WHEN 1
                THEN 'Masculino'
                WHEN 2
                THEN 'Femenino'
            END AS Sexo, 
			ES.DESESPECI AS Especialidad,
            D.CODDIAGNO AS DX, 
            D.NOMDIAGNO AS NombreDX,
            CASE DP.DIAINGEGR
                WHEN 'I'
                THEN 'INGRESO'
                WHEN 'E'
                THEN 'EGRESO'
                WHEN 'A'
                THEN 'AMBOS'
            END AS TipoDX,
            CASE
                WHEN DP.CODDIAPRI = 1
                THEN 'Principal'
                ELSE 'Asociado'
            END AS [Tipo Diagnostico], 
            U.UFUDESCRI AS Unidad,
            CASE I.TIPOINGRE
                WHEN 1
                THEN 'Ambulatorio'
                WHEN 2
                THEN 'Hospitalario'
            END AS TipoIngreso, 
            E.NOMENTIDA AS Entidad, 
            E.CODADMPAG AS Cod_EPS, 
            L.DEPMUNCOD AS UbicacionPaciente, 
            P.IPDIRECCI AS Direccion, 
            CA.NOMCENATE AS CentroAtencion
     FROM dbo.INDIAGNOP AS DP
          INNER JOIN dbo.INDIAGNOS AS D ON DP.CODDIAGNO = D.CODDIAGNO                                                            
          INNER JOIN dbo.INPACIENT AS P ON DP.IPCODPACI = P.IPCODPACI
          INNER JOIN dbo.INUNIFUNC AS U ON DP.UFUCODIGO = U.UFUCODIGO
          INNER JOIN dbo.ADINGRESO AS I ON DP.NUMINGRES = I.NUMINGRES
          INNER JOIN dbo.INENTIDAD AS E ON I.CODENTIDA = E.CODENTIDA
          INNER JOIN dbo.INUBICACI AS L ON P.AUUBICACI = L.AUUBICACI
          INNER JOIN dbo.ADCENATEN AS CA ON DP.CODCENATE = CA.CODCENATE
		 INNER JOIN dbo.HCHISPACA AS HC ON DP.NUMINGRES = HC.NUMINGRES 
		  INNER JOIN dbo.INESPECIA AS ES ON ES.CODESPECI = HC.CODESPTRA

		  WHERE year (i.IFECHAING)=2021  and ca.NOMCENATE='JERSALUD GRANADA' 
