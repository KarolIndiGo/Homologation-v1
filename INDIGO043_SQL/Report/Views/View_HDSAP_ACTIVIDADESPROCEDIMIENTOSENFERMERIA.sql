-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_ACTIVIDADESPROCEDIMIENTOSENFERMERIA
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[View_HDSAP_ACTIVIDADESPROCEDIMIENTOSENFERMERIA]
AS
     SELECT HG.IPCODPACI AS identificación, 
            INP.IPNOMCOMP AS 'nombre y apellidos',
            CASE INP.IPSEXOPAC
                WHEN 1
                THEN 'Masculino'
                WHEN 2
                THEN 'Femenino'
            END AS sexo, 
            CAST(INP.IPFECNACI AS DATE) AS 'fecha nacimiento', 
            CAST(DATEDIFF(dd, INP.IPFECNACI, HG.FECHAUTIL) / 365.25 AS INT) AS edad, 
            INM.MUNNOMBRE AS municipio, 
            INP.IPDIRECCI AS dirección, 
            HG.CONSECUTI, 
            HG.FECHAUTIL AS fecha, 
            HG.CODPROSAL AS codProfesional, 
            INPROFSAL.NOMMEDICO AS Profesional, 
            HG.NUMINGRES AS Ingreso, 
            INUNIFUNC.UFUDESCRI AS Uf, 
            HCACTENFE.DESACTENF AS Actividad, 
            HG.CANUTIPRO AS Cantidad, 
            HG.OBSERVACI AS Observaciones
     FROM DBO.HCHOGASIN AS HG
          INNER JOIN DBO.HCACTENFE ON HG.CODACTENF = HCACTENFE.CODACTENF
          INNER JOIN DBO.INPROFSAL ON HG.CODPROSAL = INPROFSAL.CODPROSAL
          INNER JOIN DBO.INUNIFUNC ON HG.UFUCODIGO = INUNIFUNC.UFUCODIGO
          INNER JOIN DBO.INPACIENT AS INP ON HG.IPCODPACI = INP.IPCODPACI
          INNER JOIN DBO.INUBICACI AS INU ON INU.AUUBICACI = INP.AUUBICACI
          INNER JOIN DBO.INMUNICIP AS INM ON INM.DEPMUNCOD = INU.DEPMUNCOD;

