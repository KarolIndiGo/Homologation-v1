-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_ALISTAMIENTOHC
-- Extracted by Fabric SQL Extractor SPN v3.9.0








CREATE VIEW [Report].[View_HDSAP_ALISTAMIENTOHC]
AS

  SELECT 
           H.IPCODPACI AS Identificacion,
           H.NUMINGRES AS Ingresos, 
       	   CASE P.IPTIPODOC
			WHEN 1 THEN 'CC - Cédula de Ciudadanía'
			WHEN 2 THEN 'CE - Cédula de Extranjería'
			WHEN 3 THEN 'TI - Tarjeta de Identidad'
			WHEN 4 THEN 'RC - Registro Civil'
			WHEN 5 THEN 'PA - Pasaporte'
			WHEN 6 THEN 'AS - Adulto Sin Identificación'
			WHEN 7 THEN 'MS - Menor Sin Identificación'
			WHEN 8 THEN 'NU - Número único de identificación personal'
			WHEN 9 THEN 'CN - Certificado de Nacido Vivo'
			WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)'
			WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
			WHEN 12 THEN 'PE - Permiso Especial de Permanencia (Aplica para extranjeros)'
			WHEN 13 THEN 'PT - Permiso Temporal de Permanencia'
			WHEN 14 THEN 'DE - Documento Extranjero'
			WHEN 15 THEN 'SI - Sin Identificación'
			END 'Tipo Documento',
		   i.IFECHAING As FechaIngreso,
		   P.IPNOMCOMP AS Nombre,
		   i.CODICAMHO as Cama,
 U.UFUDESCRI AS UnidadDeEgreso,
 he.FECALTPAC as fechaEgreso,
INV.CreationUser+' '+PRS.Fullname AS 'Usuario Genera Boleta'
FROM dbo.HCHISPACA AS H
     LEFT join dbo.HCREGEGRE as  he on he.NUMINGRES = h.NUMINGRES
     inner JOIN dbo.ADINGRESO AS I ON I.NUMINGRES = H.NUMINGRES AND I.IPCODPACI = H.IPCODPACI 
     INNER JOIN dbo.INPACIENT AS P ON P.IPCODPACI = H.IPCODPACI
     INNER JOIN dbo.INENTIDAD AS S ON S.CODENTIDA = I.CODENTIDA
     INNER JOIN dbo.INUBICACI AS M ON M.AUUBICACI = P.AUUBICACI
     INNER JOIN dbo.INMUNICIP AS L ON L.DEPMUNCOD = M.DEPMUNCOD
     INNER JOIN dbo.INUNIFUNC AS U ON U.UFUCODIGO = H.UFUCODIGO
     INNER JOIN dbo.INPROFSAL AS PR ON PR.CODPROSAL = H.CODPROSAL
     INNER JOIN dbo.INESPECIA AS EM ON EM.CODESPECI = PR.CODESPEC1
                                                 AND PR.CODPROSAL = H.CODPROSAL
     left JOIN DBO.CHCAMASHO AS CA ON CA.CODICAMAS = I.CODICAMHO
     LEFT outer JOIN Billing.SlipOut AS INV ON INV.AdmissionNumber = I.NUMINGRES
     LEFT outer JOIN Security.[User] AS USR ON USR.UserCode = INV.CreationUser
     LEFT outer JOIN Security.[Person] AS PRS ON PRS.Id = USR.IdPerson

WHERE(H.INDICAPAC IN('10', '11', '12','15')) and u.UFUTIPUNI <> '15' and u.UFUCODIGO <> '121' 


