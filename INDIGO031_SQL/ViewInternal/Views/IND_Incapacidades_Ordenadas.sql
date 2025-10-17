-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_Incapacidades_Ordenadas
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_Incapacidades_Ordenadas]
AS 
     --Identifica la Causa del Ingreso: 1. Heridos en combate 2. Enfermedad profesional 3. Enfermedad general adulto 4. Enfermedad general pediatria 5. Odontología 6. Accidente de transito 7. Catastrofe/Fisalud 8. Quemados 9. Maternidad 10. Accidente Laboral 11. Cirugia Programada
     --Tipo de Ingreso: 1 = Ambulatorio 2 = Hospitalario
     --Es una Prorroga: True = Si False = No
	 --40381432
     SELECT DISTINCT 
            INC.IPCODPACI AS Documento, 
            P.IPNOMCOMP AS Paciente, 
            INC.NUMINGRES AS Ingreso, 
            INC.FECINIINC AS Inicio_Incapacidad, 
            INC.FECFININC AS Fin_Incapacidad, 
            DATEDIFF(dd, INC.FECINIINC, INC.FECFININC)+1 AS Dias_Incapacidad, 
			--(INC.FECFININC -INC.FECINIINC) AS Dias_Incapacidad, 
            INC.FECREGIST AS Registro_Incapacidad,
            CASE INC.ICAUSAING
                WHEN 1
                THEN 'Heridos en Combate'
                WHEN 2
                THEN 'Enfermedad Profesional'
                WHEN 3
                THEN 'Enfermedad general adulto'
                WHEN 4
                THEN 'Enfermedad general pediatria'
                WHEN 5
                THEN 'Odontología'
                WHEN 6
                THEN 'Accidente de transito'
                WHEN 7
                THEN 'Catastrofe/Fisalud'
                WHEN 8
                THEN 'Quemados'
                WHEN 9
                THEN 'Maternidad'
                WHEN 10
                THEN 'Accidente Laboral'
                WHEN 11
                THEN 'Cirugia Programada'
            END AS Causa_Ingreso,
            CASE INC.TIPOINCAP
                WHEN 1
                THEN 'Ambulatorio'
                WHEN 2
                THEN 'Hospitalario'
            END AS Tipo_Ingreso,
            CASE INC.ESPRORROG
                WHEN 'True'
                THEN 'Si'
                WHEN 'False'
                THEN 'No'
            END AS Prorroga, 
            D.CODDIAGNO AS CodDx, 
            D.NOMDIAGNO AS Diagnostico, 
            PR.CODPROSAL AS CodProf, 
            PR.NOMMEDICO AS Medico, 
            E.DESESPECI AS Especialidad, 
            C.NOMCENATE AS Sede, 
            P.IPDIRECCI AS Direccion, 
            P.IPTELEFON AS Telefono, 
            P.IPTELMOVI AS Celular, 
            P.IPFECNACI AS Fecha_Nacimiento, 
            (CAST(DATEDIFF(dd, P.IPFECNACI, GETDATE()) / 365.25 AS INT)) AS EDAD
     FROM dbo.HCINCAPAC AS INC
          INNER JOIN dbo.INPACIENT AS P ON INC.IPCODPACI = P.IPCODPACI
          INNER JOIN dbo.INDIAGNOS AS D ON INC.CODDIAGNO = D.CODDIAGNO
          INNER JOIN dbo.ADCENATEN AS C ON INC.CODCENATE = C.CODCENATE
          INNER JOIN dbo.INPROFSAL AS PR ON INC.CODPROSAL = PR.CODPROSAL
          INNER JOIN dbo.INESPECIA AS E ON PR.CODESPEC1 = E.CODESPECI
	--where INC.IPCODPACI ='40381432'
