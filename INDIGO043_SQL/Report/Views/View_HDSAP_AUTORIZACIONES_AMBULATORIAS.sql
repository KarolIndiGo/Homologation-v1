-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_AUTORIZACIONES_AMBULATORIAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [Report].[View_HDSAP_Autorizaciones_Ambulatorias]
AS

SELECT        distinct  getdate () as Fecha_Envio, Código_Habilitación, Nombre_del_Prestador, Tipo_Identificación_del_Afiliado, Número_de_Identificación_del_Afiliado, Nombre_Paciente, Telefono_Celular_1, 
                         Telefono_Celular_2, Fecha_Atencion,CIE10, Nombre_Medico, Codigo_Especialidad_Remitente , Especialidad_Remitente, Código_CUPS_Prestacion, Descripcion_Prestacion, Cantidad,
                         Justificacion_Clinica, [Edad Gestacional (Semanas)], [Anestesia_(A)], [Sedación_(S)], [Contraste_(T)], [Comparativo_(C)], [Bilateral_(B)]

FROM            (SELECT                             '415510047901' AS Código_Habilitación, 'E.S.E. Hospital Departamental San Antonio de Pitalito Huila' AS Nombre_del_Prestador,PAC.IPNOMCOMP AS Nombre_Paciente,
                                                    CASE WHEN PAC.IPTIPODOC = 1 THEN 'CC' WHEN PAC.IPTIPODOC = 2 THEN 'CE' WHEN PAC.IPTIPODOC = 3 THEN 'TI' WHEN PAC.IPTIPODOC = 4 THEN 'RC' WHEN PAC.IPTIPODOC = 5 THEN 'PA' WHEN
                                                    PAC.IPTIPODOC = 6 THEN 'AS' WHEN PAC.IPTIPODOC = 7 THEN 'MS' WHEN PAC.IPTIPODOC = 8 THEN 'NU' WHEN PAC.IPTIPODOC = 9 THEN 'CN' WHEN PAC.IPTIPODOC = 10 THEN 'CD' WHEN PAC.IPTIPODOC = 11 THEN 'SC' WHEN PAC.IPTIPODOC = 12 THEN 'PE' END AS Tipo_Identificación_del_Afiliado,
													PAC.IPCODPACI AS Número_de_Identificación_del_Afiliado, PAC.IPTELEFON AS Telefono_Celular_1, PAC.IPTELMOVI AS Telefono_Celular_2, HCORDLABO.FECORDMED AS Fecha_Atencion, 
                                                    HCORDLABO.CODSERIPS AS Código_CUPS_Prestacion, INCUPSIPS.DESCODCUPS AS Descripcion_Prestacion, NTD.NOMENTIDA EntidadAdministradora,
                                                    HCORDLABO.CANSERIPS AS Cantidad, HCHISPACA.DATOBJETI AS Justificacion_Clinica, INDIAGNOS.CODDIAGNO AS CIE10,  
                                                    PROF.NOMMEDICO AS Nombre_Medico,ESP.CODESPECI AS Codigo_Especialidad_Remitente, ESP.DESESPECI AS Especialidad_Remitente, 
													CASE WHEN NOMSEMGES IS NULL THEN 0 WHEN ANT.NOMSEMGES >= 0.1 THEN ANT.NOMSEMGES END AS [Edad Gestacional (Semanas)] ,
													CASE WHEN HCQ.TIPOANEST = 1 THEN 'A' WHEN HCQ.TIPOANEST = 2 THEN 'A' WHEN HCQ.TIPOANEST = 3 THEN 'A' END [Anestesia_(A)], 
													'' [Sedación_(S)], '' as [Contraste_(T)], '' as [Comparativo_(C)], 
													'' [Bilateral_(B)]
                                                    
                          FROM            ADINGRESO AS ING INNER JOIN
                                                    INESPECIA AS ESP INNER JOIN
                                                    INPROFSAL AS PROF ON ESP.CODESPECI = PROF.CODESPEC1 INNER JOIN
                                                    HCORDLABO INNER JOIN
                                                    INPACIENT AS PAC ON HCORDLABO.IPCODPACI = PAC.IPCODPACI INNER JOIN
                                                    INCUPSIPS ON HCORDLABO.CODSERIPS = INCUPSIPS.CODSERIPS AND 
                                                    HCORDLABO.CODSERIPS = INCUPSIPS.CODSERIPS ON PROF.CODPROSAL = HCORDLABO.CODPROSAL ON 
                                                    ING.NUMINGRES = HCORDLABO.NUMINGRES INNER JOIN
                                                    INDIAGNOS ON HCORDLABO.CODDIAGNO = INDIAGNOS.CODDIAGNO AND 
                                                    HCORDLABO.CODDIAGNO = INDIAGNOS.CODDIAGNO INNER JOIN
                                                    HCHISPACA ON HCORDLABO.NUMINGRES = HCHISPACA.NUMINGRES AND 
                                                    HCORDLABO.NUMEFOLIO = HCHISPACA.NUMEFOLIO LEFT JOIN
													HCQXINFOR AS HCQ ON HCQ.NUMINGRES = ING.NUMINGRES LEFT JOIN
													INENTIDAD NTD ON NTD.CODENTIDA = ING.CODENTIDA INNER JOIN
													HCANTGINE AS ANT ON ANT.IPCODPACI = ING.IPCODPACI AND ANT.NUMINGRES=ING.NUMINGRES

													
                          WHERE        HCORDLABO.MANEXTPRO = 1 AND ING.CODENTIDA in ('00021','EA0085')
                          UNION ALL
                          SELECT                   '415510047901' AS Código_Habilitación, 'E.S.E. Hospital Departamental San Antonio de Pitalito Huila' AS Nombre_del_Prestador,  PAC.IPNOMCOMP AS Nombre_Paciente,
						                           CASE WHEN PAC.IPTIPODOC = 1 THEN 'CC' WHEN PAC.IPTIPODOC = 2 THEN 'CE' WHEN PAC.IPTIPODOC = 3 THEN 'TI' WHEN PAC.IPTIPODOC = 4 THEN 'RC' WHEN PAC.IPTIPODOC = 5 THEN 'PA' WHEN
                                                   PAC.IPTIPODOC = 6 THEN 'AS' WHEN PAC.IPTIPODOC = 7 THEN 'MS' WHEN PAC.IPTIPODOC = 8 THEN 'NU' WHEN PAC.IPTIPODOC = 9 THEN 'CN' WHEN PAC.IPTIPODOC = 10 THEN 'CD' WHEN PAC.IPTIPODOC = 11 THEN 'SC' WHEN PAC.IPTIPODOC = 12 THEN 'PE' END AS Tipo_Identificación_del_Afiliado,
												   PAC.IPCODPACI AS Número_de_Identificación_del_Afiliado, 
                                                   PAC.IPTELEFON AS Telefono_Celular_1, PAC.IPTELMOVI AS Telefono_Celular_2, HCORDIMAG.FECORDMED AS Fecha_Atencion, 
                                                   HCORDIMAG.CODSERIPS AS Código_CUPS_Prestacion, INCUPSIPS_3.DESCODCUPS AS Descripcion_Prestacion, NTD.NOMENTIDA EntidadAdministradora,
                                                   HCORDIMAG.CANSERIPS AS Cantidad,  
                                                   HCHISPACA_3.DATOBJETI AS Justificacion_Clinica, INDIAGNOS_3.CODDIAGNO AS CIE10, 
                                                   PROF.NOMMEDICO AS Nombre_Medico, ESP.CODESPECI AS Codigo_Especialidad_Remitente, ESP.DESESPECI AS Especialidad_Remitente, 
												   CASE WHEN NOMSEMGES IS NULL THEN 0 WHEN ANT.NOMSEMGES >= 0.1 THEN ANT.NOMSEMGES END AS [Edad Gestacional (Semanas)], 
												   CASE WHEN HCQ.TIPOANEST = 1 THEN 'A' WHEN HCQ.TIPOANEST = 2 THEN 'A' WHEN HCQ.TIPOANEST = 3 THEN 'A' END [Anestesia_(A)], 
												   '' [Sedación_(S)], '' as [Contraste_(T)], '' as [Comparativo_(C)], 
												   '' [Bilateral_(B)]  
                                                   
                          FROM            ADINGRESO AS ING INNER JOIN
                                                   INESPECIA AS ESP INNER JOIN
                                                   INPROFSAL AS PROF ON ESP.CODESPECI = PROF.CODESPEC1 INNER JOIN
                                                   HCORDIMAG INNER JOIN
                                                   INPACIENT AS PAC ON HCORDIMAG.IPCODPACI = PAC.IPCODPACI INNER JOIN
                                                   INCUPSIPS AS INCUPSIPS_3 ON HCORDIMAG.CODSERIPS = INCUPSIPS_3.CODSERIPS AND HCORDIMAG.CODSERIPS = INCUPSIPS_3.CODSERIPS ON
                                                   PROF.CODPROSAL = HCORDIMAG.CODPROSAL ON ING.NUMINGRES = HCORDIMAG.NUMINGRES INNER JOIN
                                                   INDIAGNOS AS INDIAGNOS_3 ON HCORDIMAG.CODDIAGNO = INDIAGNOS_3.CODDIAGNO AND 
                                                   HCORDIMAG.CODDIAGNO = INDIAGNOS_3.CODDIAGNO INNER JOIN
                                                   HCHISPACA AS HCHISPACA_3 ON HCORDIMAG.NUMINGRES = HCHISPACA_3.NUMINGRES AND 
                                                   HCORDIMAG.NUMEFOLIO = HCHISPACA_3.NUMEFOLIO LEFT JOIN
												   HCQXINFOR AS HCQ ON HCQ.NUMINGRES = ING.NUMINGRES LEFT JOIN
												   INENTIDAD NTD ON NTD.CODENTIDA = ING.CODENTIDA INNER JOIN
												   HCANTGINE AS ANT ON ANT.IPCODPACI = ING.IPCODPACI AND ANT.NUMINGRES=ING.NUMINGRES
                          WHERE        (HCORDIMAG.MANEXTPRO = 1) AND (ING.CODENTIDA in ('00021','EA0085'))
                          UNION ALL
                          SELECT                   '415510047901' AS Código_Habilitación, 'E.S.E. Hospital Departamental San Antonio de Pitalito Huila' AS Nombre_del_Prestador, PAC.IPNOMCOMP AS Nombre_Paciente, 
                                                   CASE WHEN PAC.IPTIPODOC = 1 THEN 'CC' WHEN PAC.IPTIPODOC = 2 THEN 'CE' WHEN PAC.IPTIPODOC = 3 THEN 'TI' WHEN PAC.IPTIPODOC = 4 THEN 'RC' WHEN PAC.IPTIPODOC = 5 THEN 'PA' WHEN
                                                   PAC.IPTIPODOC = 6 THEN 'AS' WHEN PAC.IPTIPODOC = 7 THEN 'MS' WHEN PAC.IPTIPODOC = 8 THEN 'NU' WHEN PAC.IPTIPODOC = 9 THEN 'CN' WHEN PAC.IPTIPODOC = 10 THEN 'CD' WHEN PAC.IPTIPODOC = 11 THEN 'SC' WHEN PAC.IPTIPODOC = 12 THEN 'PE' END AS Tipo_Identificación_del_Afiliado,
												   PAC.IPCODPACI AS Número_de_Identificación_del_Afiliado, 
                                                   PAC.IPTELEFON AS Telefono_Celular_1, PAC.IPTELMOVI AS Telefono_Celular_2, HCORDPRON.FECORDMED AS Fecha_Atencion, 
                                                   HCORDPRON.CODSERIPS AS Código_CUPS_Prestacion, INCUPSIPS_2.DESCODCUPS AS Descripcion_Prestacion, NTD.NOMENTIDA EntidadAdministradora,
                                                   HCORDPRON.CANSERIPS AS Cantidad,  
                                                   HCHISPACA_2.DATOBJETI AS Justificacion_Clinica, INDIAGNOS_2.CODDIAGNO AS CIE10, 
                                                   PROF.NOMMEDICO AS Nombre_Medico, ESP.CODESPECI AS Codigo_Especialidad_Remitente, ESP.DESESPECI AS Especialidad_Remitente ,
												   CASE WHEN NOMSEMGES IS NULL THEN 0 WHEN ANT.NOMSEMGES >= 0.1 THEN ANT.NOMSEMGES END AS [Edad Gestacional (Semanas)],
												   CASE WHEN HCQ.TIPOANEST = 1 THEN 'A' WHEN HCQ.TIPOANEST = 2 THEN 'A' WHEN HCQ.TIPOANEST = 3 THEN 'A' END [Anestesia_(A)], 
												   '' [Sedación_(S)], '' as [Contraste_(T)], '' as [Comparativo_(C)], 
												   '' [Bilateral_(B)]  
                                                   
                          FROM            ADINGRESO AS ING LEFT OUTER JOIN
                                                   INESPECIA AS ESP LEFT OUTER JOIN
                                                   INPROFSAL AS PROF ON ESP.CODESPECI = PROF.CODESPEC1 LEFT OUTER JOIN
                                                   HCORDPRON LEFT OUTER JOIN
                                                   INPACIENT AS PAC ON HCORDPRON.IPCODPACI = PAC.IPCODPACI LEFT OUTER JOIN
                                                   INCUPSIPS AS INCUPSIPS_2 ON HCORDPRON.CODSERIPS = INCUPSIPS_2.CODSERIPS AND 
                                                   HCORDPRON.CODSERIPS = INCUPSIPS_2.CODSERIPS ON PROF.CODPROSAL = HCORDPRON.CODPROSAL ON 
                                                   ING.NUMINGRES = HCORDPRON.NUMINGRES LEFT OUTER JOIN
                                                   INDIAGNOS AS INDIAGNOS_2 ON HCORDPRON.CODDIAGNO = INDIAGNOS_2.CODDIAGNO AND 
                                                   HCORDPRON.CODDIAGNO = INDIAGNOS_2.CODDIAGNO LEFT OUTER JOIN
                                                   HCHISPACA AS HCHISPACA_2 ON HCORDPRON.NUMINGRES = HCHISPACA_2.NUMINGRES AND 
                                                   HCORDPRON.NUMEFOLIO = HCHISPACA_2.NUMEFOLIO LEFT JOIN
												   HCQXINFOR AS HCQ ON HCQ.NUMINGRES = ING.NUMINGRES LEFT JOIN
												   INENTIDAD NTD ON NTD.CODENTIDA = ING.CODENTIDA INNER JOIN
												   HCANTGINE AS ANT ON ANT.IPCODPACI = ING.IPCODPACI AND ANT.NUMINGRES=ING.NUMINGRES
                          WHERE        (HCORDPRON.MANEXTPRO = 1) AND (ING.CODENTIDA in ('00021','EA0085'))
                          UNION ALL
                          SELECT                   '415510047901' AS Código_Habilitación, 'E.S.E. Hospital Departamental San Antonio de Pitalito Huila' AS Nombre_del_Prestador, PAC.IPNOMCOMP AS Nombre_Paciente,  
                                                   CASE WHEN PAC.IPTIPODOC = 1 THEN 'CC' WHEN PAC.IPTIPODOC = 2 THEN 'CE' WHEN PAC.IPTIPODOC = 3 THEN 'TI' WHEN PAC.IPTIPODOC = 4 THEN 'RC' WHEN PAC.IPTIPODOC = 5 THEN 'PA' WHEN
                                                   PAC.IPTIPODOC = 6 THEN 'AS' WHEN PAC.IPTIPODOC = 7 THEN 'MS' WHEN PAC.IPTIPODOC = 8 THEN 'NU' WHEN PAC.IPTIPODOC = 9 THEN 'CN' WHEN PAC.IPTIPODOC = 10 THEN 'CD' WHEN PAC.IPTIPODOC = 11 THEN 'SC' WHEN PAC.IPTIPODOC = 12 THEN 'PE' END AS Tipo_Identificación_del_Afiliado,
												   PAC.IPCODPACI AS Número_de_Identificación_del_Afiliado, 
                                                   PAC.IPTELEFON AS Telefono_Celular_1, PAC.IPTELMOVI AS Telefono_Celular_2, HCORDPROQ.FECORDMED AS Fecha_Atencion, 
                                                   HCORDPROQ.CODSERIPS AS Código_CUPS_Prestacion, INCUPSIPS_1.DESCODCUPS AS Descripcion_Prestacion, NTD.NOMENTIDA EntidadAdministradora,
                                                   HCORDPROQ.CANSERIPS AS Cantidad,  
                                                   HCHISPACA_1.DATOBJETI AS Justificacion_Clinica, INDIAGNOS_1.CODDIAGNO AS CIE10, 
                                                   PROF.NOMMEDICO AS Nombre_Medico, ESP.CODESPECI AS Codigo_Especialidad_Remitente, ESP.DESESPECI AS Especialidad_Remitente ,
												   CASE WHEN NOMSEMGES IS NULL THEN 0 WHEN ANT.NOMSEMGES >= 0.1 THEN ANT.NOMSEMGES END AS [Edad Gestacional (Semanas)],
												   CASE WHEN HCQ.TIPOANEST = 1 THEN 'A' WHEN HCQ.TIPOANEST = 2 THEN 'A' WHEN HCQ.TIPOANEST = 3 THEN 'A' END [Anestesia_(A)], 
												   '' [Sedación_(S)], '' as [Contraste_(T)], '' as [Comparativo_(C)], 
												   '' [Bilateral_(B)] 
                                                   
                          FROM            ADINGRESO AS ING LEFT OUTER JOIN
                                                   INESPECIA AS ESP LEFT OUTER JOIN
                                                   INPROFSAL AS PROF ON ESP.CODESPECI = PROF.CODESPEC1 LEFT OUTER JOIN
                                                   HCORDPROQ LEFT OUTER JOIN
                                                   INPACIENT AS PAC ON HCORDPROQ.IPCODPACI = PAC.IPCODPACI LEFT OUTER JOIN
                                                   INCUPSIPS AS INCUPSIPS_1 ON HCORDPROQ.CODSERIPS = INCUPSIPS_1.CODSERIPS AND 
                                                   HCORDPROQ.CODSERIPS = INCUPSIPS_1.CODSERIPS ON PROF.CODPROSAL = HCORDPROQ.CODPROSAL ON 
                                                   ING.NUMINGRES = HCORDPROQ.NUMINGRES LEFT OUTER JOIN
                                                   INDIAGNOS AS INDIAGNOS_1 ON HCORDPROQ.CODDIAGNO = INDIAGNOS_1.CODDIAGNO AND 
                                                   HCORDPROQ.CODDIAGNO = INDIAGNOS_1.CODDIAGNO LEFT OUTER JOIN
                                                   HCHISPACA AS HCHISPACA_1 ON HCORDPROQ.NUMINGRES = HCHISPACA_1.NUMINGRES AND 
                                                   HCORDPROQ.NUMEFOLIO = HCHISPACA_1.NUMEFOLIO LEFT JOIN
												   HCQXINFOR AS HCQ ON HCQ.NUMINGRES = ING.NUMINGRES LEFT JOIN
												   INENTIDAD NTD ON NTD.CODENTIDA = ING.CODENTIDA INNER JOIN
												   HCANTGINE AS ANT ON ANT.IPCODPACI = ING.IPCODPACI AND ANT.NUMINGRES=ING.NUMINGRES
                          WHERE        (HCORDPROQ.MANEXTPRO = 1) AND (ING.CODENTIDA in ('00021','EA0085'))
						  UNION ALL
						  SELECT                   '415510047901' AS Código_Habilitación, 'E.S.E. Hospital Departamental San Antonio de Pitalito Huila' AS Nombre_del_Prestador, PAC.IPNOMCOMP AS Nombre_Paciente,  
                                                   CASE WHEN PAC.IPTIPODOC = 1 THEN 'CC' WHEN PAC.IPTIPODOC = 2 THEN 'CE' WHEN PAC.IPTIPODOC = 3 THEN 'TI' WHEN PAC.IPTIPODOC = 4 THEN 'RC' WHEN PAC.IPTIPODOC = 5 THEN 'PA' WHEN
                                                   PAC.IPTIPODOC = 6 THEN 'AS' WHEN PAC.IPTIPODOC = 7 THEN 'MS' WHEN PAC.IPTIPODOC = 8 THEN 'NU' WHEN PAC.IPTIPODOC = 9 THEN 'CN' WHEN PAC.IPTIPODOC = 10 THEN 'CD' WHEN PAC.IPTIPODOC = 11 THEN 'SC' WHEN PAC.IPTIPODOC = 12 THEN 'PE' END AS Tipo_Identificación_del_Afiliado,
												   PAC.IPCODPACI AS Número_de_Identificación_del_Afiliado, 
                                                   PAC.IPTELEFON AS Telefono_Celular_1, PAC.IPTELMOVI AS Telefono_Celular_2, HCORDINTE.FECORDMED AS Fecha_Atencion, 
                                                   HCORDINTE.CODSERIPS AS Código_CUPS_Prestacion, INCUPSIPS_3.DESCODCUPS AS Descripcion_Pretacion, NTD.NOMENTIDA EntidadAdministradora,
                                                   HCORDINTE.CANSERIPS AS Cantidad, 
                                                   HCHISPACA_3.DATOBJETI AS Justificacion_Clinica, INDIAGNOS_3.CODDIAGNO AS CIE10, 
                                                   PROF.NOMMEDICO AS Nombre_Medico,ESP.CODESPECI AS Codigo_Especialidad_Remitente, ESP.DESESPECI AS Especialidad_Remitente ,
												   CASE WHEN NOMSEMGES IS NULL THEN 0 WHEN ANT.NOMSEMGES >= 0.1 THEN ANT.NOMSEMGES END AS [Edad Gestacional (Semanas)], 
												   CASE WHEN HCQ.TIPOANEST = 1 THEN 'A' WHEN HCQ.TIPOANEST = 2 THEN 'A' WHEN HCQ.TIPOANEST = 3 THEN 'A' END [Anestesia_(A)], 
												   ''  [Sedación_(S)],
												   ''  [Contraste_(T)], '' as [Comparativo_(C)], 
												   ''  [Bilateral_(B)]  
                                                   
                          FROM            ADINGRESO AS ING INNER JOIN
                                                   INESPECIA AS ESP INNER JOIN
                                                   INPROFSAL AS PROF ON ESP.CODESPECI = PROF.CODESPEC1 INNER JOIN
                                                   HCORDINTE INNER JOIN
                                                   INPACIENT AS PAC ON HCORDINTE.IPCODPACI = PAC.IPCODPACI INNER JOIN
                                                   INCUPSIPS AS INCUPSIPS_3 ON HCORDINTE.CODSERIPS = INCUPSIPS_3.CODSERIPS AND HCORDINTE.CODSERIPS = INCUPSIPS_3.CODSERIPS ON PROF.CODPROSAL = HCORDINTE.CODPROSAL ON ING.NUMINGRES = HCORDINTE.NUMINGRES INNER JOIN
                                                   INDIAGNOS AS INDIAGNOS_3 ON HCORDINTE.CODDIAGNO = INDIAGNOS_3.CODDIAGNO AND 
                                                   HCORDINTE.CODDIAGNO = INDIAGNOS_3.CODDIAGNO INNER JOIN
                                                   HCHISPACA AS HCHISPACA_3 ON HCORDINTE.NUMINGRES = HCHISPACA_3.NUMINGRES AND 
                                                   HCORDINTE.NUMEFOLIO = HCHISPACA_3.NUMEFOLIO LEFT JOIN
												   HCQXINFOR AS HCQ ON HCQ.NUMINGRES = ING.NUMINGRES LEFT JOIN
												   INENTIDAD NTD ON NTD.CODENTIDA = ING.CODENTIDA INNER JOIN
												   HCANTGINE AS ANT ON ANT.IPCODPACI = ING.IPCODPACI AND ANT.NUMINGRES=ING.NUMINGRES
                          WHERE        (HCORDINTE.MANEXTPRO = 1) AND (ING.CODENTIDA in ('00021','EA0085'))
						  UNION ALL
						  SELECT                   '415510047901' AS Código_Habilitación, 'E.S.E. Hospital Departamental San Antonio de Pitalito Huila' AS Nombre_del_Prestador, PAC.IPNOMCOMP AS Nombre_Paciente,
                                                   CASE WHEN PAC.IPTIPODOC = 1 THEN 'CC' WHEN PAC.IPTIPODOC = 2 THEN 'CE' WHEN PAC.IPTIPODOC = 3 THEN 'TI' WHEN PAC.IPTIPODOC = 4 THEN 'RC' WHEN PAC.IPTIPODOC = 5 THEN 'PA' WHEN
                                                   PAC.IPTIPODOC = 6 THEN 'AS' WHEN PAC.IPTIPODOC = 7 THEN 'MS' WHEN PAC.IPTIPODOC = 8 THEN 'NU' WHEN PAC.IPTIPODOC = 9 THEN 'CN' WHEN PAC.IPTIPODOC = 10 THEN 'CD' WHEN PAC.IPTIPODOC = 11 THEN 'SC' WHEN PAC.IPTIPODOC = 12 THEN 'PE' END AS Tipo_Identificación_del_Afiliado,
												   PAC.IPCODPACI AS Número_de_Identificación_del_Afiliado, 
                                                   PAC.IPTELEFON AS Telefono_Celular_1, PAC.IPTELMOVI AS Telefono_Celular_2, HCORDPATO.FECORDMED AS Fecha_Atencion, 
                                                   HCORDPATO.CODSERIPS AS Código_CUPS_Prestacion, INCUPSIPS_3.DESCODCUPS AS Descripcion_Prestacion, NTD.NOMENTIDA EntidadAdministradora,
                                                   HCORDPATO.CANSERIPS AS Cantidad,  
                                                   HCHISPACA_3.DATOBJETI AS Justificacion_Clinica, INDIAGNOS_3.CODDIAGNO AS CIE10, 
                                                   PROF.NOMMEDICO AS Nombre_Medico, ESP.CODESPECI AS Codigo_Especialidad_Remitente, ESP.DESESPECI AS Especialidad_Remitente ,
												   CASE WHEN NOMSEMGES IS NULL THEN 0 WHEN ANT.NOMSEMGES >= 0.1 THEN ANT.NOMSEMGES END AS [Edad Gestacional (Semanas)],
												   CASE WHEN HCQ.TIPOANEST = 1 THEN 'A' WHEN HCQ.TIPOANEST = 2 THEN 'A' WHEN HCQ.TIPOANEST = 3 THEN 'A' END [Anestesia_(A)], 
												   '' [Sedación_(S)], '' as [Contraste_(T)], '' as [Comparativo_(C)], 
												   '' [Bilateral_(B)]  
                                                   
                          FROM            ADINGRESO AS ING INNER JOIN
                                                   INESPECIA AS ESP INNER JOIN
                                                   INPROFSAL AS PROF ON ESP.CODESPECI = PROF.CODESPEC1 INNER JOIN
                                                   HCORDPATO INNER JOIN
                                                   INPACIENT AS PAC ON HCORDPATO.IPCODPACI = PAC.IPCODPACI INNER JOIN
                                                   INCUPSIPS AS INCUPSIPS_3 ON HCORDPATO.CODSERIPS = INCUPSIPS_3.CODSERIPS AND HCORDPATO.CODSERIPS = INCUPSIPS_3.CODSERIPS ON PROF.CODPROSAL = HCORDPATO.CODPROSAL ON ING.NUMINGRES = HCORDPATO.NUMINGRES INNER JOIN
                                                   INDIAGNOS AS INDIAGNOS_3 ON HCORDPATO.CODDIAGNO = INDIAGNOS_3.CODDIAGNO AND 
                                                   HCORDPATO.CODDIAGNO = INDIAGNOS_3.CODDIAGNO INNER JOIN
                                                   HCHISPACA AS HCHISPACA_3 ON HCORDPATO.NUMINGRES = HCHISPACA_3.NUMINGRES AND 
                                                   HCORDPATO.NUMEFOLIO = HCHISPACA_3.NUMEFOLIO LEFT JOIN
												   HCQXINFOR AS HCQ ON HCQ.NUMINGRES = ING.NUMINGRES LEFT JOIN
												   INENTIDAD NTD ON NTD.CODENTIDA = ING.CODENTIDA INNER JOIN
												   HCANTGINE AS ANT ON ANT.IPCODPACI = ING.IPCODPACI AND ANT.NUMINGRES=ING.NUMINGRES
                          WHERE        (HCORDPATO.MANEXTPRO = 1) AND (ING.CODENTIDA in ('00021','EA0085'))
						  ) AS datos

                        

