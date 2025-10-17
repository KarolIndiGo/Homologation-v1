-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_IndicadoresGralxProfesional_Medicamentos_Tarifa
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[IND_IndicadoresGralxProfesional_Medicamentos_Tarifa] as
     SELECT 'Medicamentos' AS Tipo, 
            ca.NOMCENATE AS Sede, prof.codprosal, PROF.NOMMEDICO as Medico, ESP.DESESPECI as Profesion,
            CASE
                 WHEN ca.codcenate IN(002, 003, 004, 005, 006, 007, 008, 009,017,021)
                THEN 'BOYACA'
                WHEN ca.codcenate IN(010, 011, 012, 013, 014,018)
                THEN 'META'
                WHEN ca.codcenate IN (015,016,019,020)
                THEN 'CASANARE'
            END AS Regional, 
            MONTH(OM.FECINIDOS) AS Mes, 
            YEAR(OM.FECINIDOS) AS Año, 
           
			om.numingres as Ingreso,
			om.codproduc as Producto,
			m.desproduc,
			--tt.CodAgrupador,
			--tt.Agrupador,
			--tt.VrProducto,
			--CASE WHEN OM.VALDURFIJ=90 THEN OM.CANPEDPRO/OM.UNIDURFIJ ELSE OM.CANPEDPRO END AS CANPEDPRO,
			OM.CANPEDPRO
			--OM.VALDURFIJ,
			--OM.UNIDURFIJ
		-- TT.VrProducto AS Total
     FROM dbo.HCPRESCRA OM 
          JOIN dbo.IHLISTPRO M WITH (NOLOCK) ON OM.CODPRODUC = M.CODPRODUC
          JOIN dbo.ADCENATEN CA WITH (NOLOCK) ON OM.CODCENATE = CA.CODCENATE
		  		  JOIN dbo.INPROFSAL prof WITH (NOLOCK) on OM.CODPROSAL = prof.CODPROSAL
		  JOIN dbo.INESPECIA ESP WITH (NOLOCK) ON prof.CODESPEC1 = ESP.CODESPECI
		 
     WHERE M.TIPPRODUC = 1
           AND om.FECINIDOS >= '01-01-2022'  and om.IPCODPACI not in ('1234567', '12345678', '14141414','9999999')  AND om.NUMINGRES+NUMEFOLIO NOT IN (SELECT NUMINGRES+NUMEFOLIO
										FROM INDIGO031.dbo.HCFOLANUL) --and PROF.NOMMEDICO  like '%FORERO%'
