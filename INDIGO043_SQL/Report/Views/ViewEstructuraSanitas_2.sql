-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewEstructuraSanitas_2
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE view [Report].[ViewEstructuraSanitas_2] as

SELECT        distinct  getdate () as Fecha_Envio, Código_Habilitación, Nombre_del_Prestador, Tipo_Identificación_del_Afiliado, Número_de_Identificación_del_Afiliado, Nombre_Paciente, Telefono_Celular_1, 
                         Telefono_Celular_2, Fecha_Atencion,CIE10, Nombre_Medico, Codigo_Especialidad_Remitente , Especialidad_Remitente, Código_CUPS_Prestacion, Descripcion_Prestacion, Cantidad,
                         Justificacion_Clinica, [Edad Gestacional (Semanas)], [Anestesia_(A)], [Sedación_(S)], [Contraste_(T)], [Comparativo_(C)], [Bilateral_(B)]

FROM            (SELECT                             '415510047901' AS Código_Habilitación, 'E.S.E. Hospital Departamental San Antonio de Pitalito Huila' AS Nombre_del_Prestador,PAC.IPNOMCOMP AS Nombre_Paciente,
                                                    CASE WHEN PAC.IPTIPODOC = 1 THEN 'CC' WHEN PAC.IPTIPODOC = 2 THEN 'CE' WHEN PAC.IPTIPODOC = 3 THEN 'TI' WHEN PAC.IPTIPODOC = 4 THEN 'RC' WHEN PAC.IPTIPODOC = 5 THEN 'PA' WHEN
                                                    PAC.IPTIPODOC = 6 THEN 'AS' WHEN PAC.IPTIPODOC = 7 THEN 'MS' WHEN PAC.IPTIPODOC = 8 THEN 'NU' WHEN PAC.IPTIPODOC = 9 THEN 'CN' WHEN PAC.IPTIPODOC = 10 THEN 'CD' WHEN PAC.IPTIPODOC = 11 THEN 'SC' WHEN PAC.IPTIPODOC = 12 THEN 'PE' END AS Tipo_Identificación_del_Afiliado,
													PAC.IPCODPACI AS Número_de_Identificación_del_Afiliado, PAC.IPTELEFON AS Telefono_Celular_1, PAC.IPTELMOVI AS Telefono_Celular_2, .dbo.HCORDLABO.FECORDMED AS Fecha_Atencion, 
                                                    .dbo.HCORDLABO.CODSERIPS AS Código_CUPS_Prestacion, .dbo.INCUPSIPS.DESCODCUPS AS Descripcion_Prestacion, 
                                                    .dbo.HCORDLABO.CANSERIPS AS Cantidad, .dbo.HCHISPACA.DATOBJETI AS Justificacion_Clinica, .dbo.INDIAGNOS.CODDIAGNO AS CIE10,  
                                                    PROF.NOMMEDICO AS Nombre_Medico,ESP.CODESPECI AS Codigo_Especialidad_Remitente, ESP.DESESPECI AS Especialidad_Remitente, 
													CASE WHEN NOMSEMGES IS NULL THEN 0 WHEN ANT.NOMSEMGES >= 0.1 THEN ANT.NOMSEMGES END AS [Edad Gestacional (Semanas)] ,
													CASE WHEN HCQ.TIPOANEST = 1 THEN 'A' WHEN HCQ.TIPOANEST = 2 THEN 'A' WHEN HCQ.TIPOANEST = 3 THEN 'A' END [Anestesia_(A)], 
													'' [Sedación_(S)], '' as [Contraste_(T)], '' as [Comparativo_(C)], 
													'' [Bilateral_(B)]
                                                    
                          FROM            .dbo.ADINGRESO AS ING INNER JOIN
                                                    .dbo.INESPECIA AS ESP INNER JOIN
                                                    .dbo.INPROFSAL AS PROF ON ESP.CODESPECI = PROF.CODESPEC1 INNER JOIN
                                                    .dbo.HCORDLABO INNER JOIN
                                                    .dbo.INPACIENT AS PAC ON .dbo.HCORDLABO.IPCODPACI = PAC.IPCODPACI INNER JOIN
                                                    .dbo.INCUPSIPS ON .dbo.HCORDLABO.CODSERIPS = .dbo.INCUPSIPS.CODSERIPS AND 
                                                    .dbo.HCORDLABO.CODSERIPS = .dbo.INCUPSIPS.CODSERIPS ON PROF.CODPROSAL = .dbo.HCORDLABO.CODPROSAL ON 
                                                    ING.NUMINGRES = .dbo.HCORDLABO.NUMINGRES INNER JOIN
                                                    .dbo.INDIAGNOS ON .dbo.HCORDLABO.CODDIAGNO = .dbo.INDIAGNOS.CODDIAGNO AND 
                                                    .dbo.HCORDLABO.CODDIAGNO = .dbo.INDIAGNOS.CODDIAGNO INNER JOIN
                                                    .dbo.HCHISPACA ON .dbo.HCORDLABO.NUMINGRES = .dbo.HCHISPACA.NUMINGRES AND 
                                                    .dbo.HCORDLABO.NUMEFOLIO = .dbo.HCHISPACA.NUMEFOLIO LEFT JOIN
													.DBO.HCQXINFOR AS HCQ ON HCQ.NUMINGRES = ING.NUMINGRES LEFT JOIN
													.dbo.HCANTGINE AS ANT ON ANT.IPCODPACI = ING.IPCODPACI AND ANT.NUMINGRES=ING.NUMINGRES
													
                          WHERE        (.dbo.HCORDLABO.MANEXTPRO = 1) AND (ING.CODENTIDA = '00021')
                          UNION ALL
                          SELECT                   '415510047901' AS Código_Habilitación, 'E.S.E. Hospital Departamental San Antonio de Pitalito Huila' AS Nombre_del_Prestador,  PAC.IPNOMCOMP AS Nombre_Paciente,
						                           CASE WHEN PAC.IPTIPODOC = 1 THEN 'CC' WHEN PAC.IPTIPODOC = 2 THEN 'CE' WHEN PAC.IPTIPODOC = 3 THEN 'TI' WHEN PAC.IPTIPODOC = 4 THEN 'RC' WHEN PAC.IPTIPODOC = 5 THEN 'PA' WHEN
                                                   PAC.IPTIPODOC = 6 THEN 'AS' WHEN PAC.IPTIPODOC = 7 THEN 'MS' WHEN PAC.IPTIPODOC = 8 THEN 'NU' WHEN PAC.IPTIPODOC = 9 THEN 'CN' WHEN PAC.IPTIPODOC = 10 THEN 'CD' WHEN PAC.IPTIPODOC = 11 THEN 'SC' WHEN PAC.IPTIPODOC = 12 THEN 'PE' END AS Tipo_Identificación_del_Afiliado,
												   PAC.IPCODPACI AS Número_de_Identificación_del_Afiliado, 
                                                   PAC.IPTELEFON AS Telefono_Celular_1, PAC.IPTELMOVI AS Telefono_Celular_2, .dbo.HCORDIMAG.FECORDMED AS Fecha_Atencion, 
                                                   .dbo.HCORDIMAG.CODSERIPS AS Código_CUPS_Prestacion, INCUPSIPS_3.DESCODCUPS AS Descripcion_Prestacion, 
                                                   .dbo.HCORDIMAG.CANSERIPS AS Cantidad,  
                                                   HCHISPACA_3.DATOBJETI AS Justificacion_Clinica, INDIAGNOS_3.CODDIAGNO AS CIE10, 
                                                   PROF.NOMMEDICO AS Nombre_Medico, ESP.CODESPECI AS Codigo_Especialidad_Remitente, ESP.DESESPECI AS Especialidad_Remitente, 
												   CASE WHEN NOMSEMGES IS NULL THEN 0 WHEN ANT.NOMSEMGES >= 0.1 THEN ANT.NOMSEMGES END AS [Edad Gestacional (Semanas)], 
												   CASE WHEN HCQ.TIPOANEST = 1 THEN 'A' WHEN HCQ.TIPOANEST = 2 THEN 'A' WHEN HCQ.TIPOANEST = 3 THEN 'A' END [Anestesia_(A)], 
												   '' [Sedación_(S)], '' as [Contraste_(T)], '' as [Comparativo_(C)], 
												   '' [Bilateral_(B)]  
                                                   
                          FROM            .dbo.ADINGRESO AS ING INNER JOIN
                                                   .dbo.INESPECIA AS ESP INNER JOIN
                                                   .dbo.INPROFSAL AS PROF ON ESP.CODESPECI = PROF.CODESPEC1 INNER JOIN
                                                   .dbo.HCORDIMAG INNER JOIN
                                                   .dbo.INPACIENT AS PAC ON .dbo.HCORDIMAG.IPCODPACI = PAC.IPCODPACI INNER JOIN
                                                   .dbo.INCUPSIPS AS INCUPSIPS_3 ON .dbo.HCORDIMAG.CODSERIPS = INCUPSIPS_3.CODSERIPS AND .dbo.HCORDIMAG.CODSERIPS = INCUPSIPS_3.CODSERIPS ON
                                                   PROF.CODPROSAL = .dbo.HCORDIMAG.CODPROSAL ON ING.NUMINGRES = .dbo.HCORDIMAG.NUMINGRES INNER JOIN
                                                   .dbo.INDIAGNOS AS INDIAGNOS_3 ON .dbo.HCORDIMAG.CODDIAGNO = INDIAGNOS_3.CODDIAGNO AND 
                                                   .dbo.HCORDIMAG.CODDIAGNO = INDIAGNOS_3.CODDIAGNO INNER JOIN
                                                   .dbo.HCHISPACA AS HCHISPACA_3 ON .dbo.HCORDIMAG.NUMINGRES = HCHISPACA_3.NUMINGRES AND 
                                                   .dbo.HCORDIMAG.NUMEFOLIO = HCHISPACA_3.NUMEFOLIO LEFT JOIN
												   .DBO.HCQXINFOR AS HCQ ON HCQ.NUMINGRES = ING.NUMINGRES LEFT JOIN
												   .dbo.HCANTGINE AS ANT ON ANT.IPCODPACI = ING.IPCODPACI AND ANT.NUMINGRES=ING.NUMINGRES
                          WHERE        (.dbo.HCORDIMAG.MANEXTPRO = 1) AND (ING.CODENTIDA = '00021')
                          UNION ALL
                          SELECT                   '415510047901' AS Código_Habilitación, 'E.S.E. Hospital Departamental San Antonio de Pitalito Huila' AS Nombre_del_Prestador, PAC.IPNOMCOMP AS Nombre_Paciente, 
                                                   CASE WHEN PAC.IPTIPODOC = 1 THEN 'CC' WHEN PAC.IPTIPODOC = 2 THEN 'CE' WHEN PAC.IPTIPODOC = 3 THEN 'TI' WHEN PAC.IPTIPODOC = 4 THEN 'RC' WHEN PAC.IPTIPODOC = 5 THEN 'PA' WHEN
                                                   PAC.IPTIPODOC = 6 THEN 'AS' WHEN PAC.IPTIPODOC = 7 THEN 'MS' WHEN PAC.IPTIPODOC = 8 THEN 'NU' WHEN PAC.IPTIPODOC = 9 THEN 'CN' WHEN PAC.IPTIPODOC = 10 THEN 'CD' WHEN PAC.IPTIPODOC = 11 THEN 'SC' WHEN PAC.IPTIPODOC = 12 THEN 'PE' END AS Tipo_Identificación_del_Afiliado,
												   PAC.IPCODPACI AS Número_de_Identificación_del_Afiliado, 
                                                   PAC.IPTELEFON AS Telefono_Celular_1, PAC.IPTELMOVI AS Telefono_Celular_2, .dbo.HCORDPRON.FECORDMED AS Fecha_Atencion, 
                                                   .dbo.HCORDPRON.CODSERIPS AS Código_CUPS_Prestacion, INCUPSIPS_2.DESCODCUPS AS Descripcion_Prestacion, 
                                                   .dbo.HCORDPRON.CANSERIPS AS Cantidad,  
                                                   HCHISPACA_2.DATOBJETI AS Justificacion_Clinica, INDIAGNOS_2.CODDIAGNO AS CIE10, 
                                                   PROF.NOMMEDICO AS Nombre_Medico, ESP.CODESPECI AS Codigo_Especialidad_Remitente, ESP.DESESPECI AS Especialidad_Remitente ,
												   CASE WHEN NOMSEMGES IS NULL THEN 0 WHEN ANT.NOMSEMGES >= 0.1 THEN ANT.NOMSEMGES END AS [Edad Gestacional (Semanas)],
												   CASE WHEN HCQ.TIPOANEST = 1 THEN 'A' WHEN HCQ.TIPOANEST = 2 THEN 'A' WHEN HCQ.TIPOANEST = 3 THEN 'A' END [Anestesia_(A)], 
												   '' [Sedación_(S)], '' as [Contraste_(T)], '' as [Comparativo_(C)], 
												   '' [Bilateral_(B)]  
                                                   
                          FROM            .dbo.ADINGRESO AS ING LEFT OUTER JOIN
                                                   .dbo.INESPECIA AS ESP LEFT OUTER JOIN
                                                   .dbo.INPROFSAL AS PROF ON ESP.CODESPECI = PROF.CODESPEC1 LEFT OUTER JOIN
                                                   .dbo.HCORDPRON LEFT OUTER JOIN
                                                   .dbo.INPACIENT AS PAC ON .dbo.HCORDPRON.IPCODPACI = PAC.IPCODPACI LEFT OUTER JOIN
                                                   .dbo.INCUPSIPS AS INCUPSIPS_2 ON .dbo.HCORDPRON.CODSERIPS = INCUPSIPS_2.CODSERIPS AND 
                                                   .dbo.HCORDPRON.CODSERIPS = INCUPSIPS_2.CODSERIPS ON PROF.CODPROSAL = .dbo.HCORDPRON.CODPROSAL ON 
                                                   ING.NUMINGRES = .dbo.HCORDPRON.NUMINGRES LEFT OUTER JOIN
                                                   .dbo.INDIAGNOS AS INDIAGNOS_2 ON .dbo.HCORDPRON.CODDIAGNO = INDIAGNOS_2.CODDIAGNO AND 
                                                   .dbo.HCORDPRON.CODDIAGNO = INDIAGNOS_2.CODDIAGNO LEFT OUTER JOIN
                                                   .dbo.HCHISPACA AS HCHISPACA_2 ON .dbo.HCORDPRON.NUMINGRES = HCHISPACA_2.NUMINGRES AND 
                                                   .dbo.HCORDPRON.NUMEFOLIO = HCHISPACA_2.NUMEFOLIO LEFT JOIN
												   .DBO.HCQXINFOR AS HCQ ON HCQ.NUMINGRES = ING.NUMINGRES LEFT JOIN
												   .dbo.HCANTGINE AS ANT ON ANT.IPCODPACI = ING.IPCODPACI AND ANT.NUMINGRES=ING.NUMINGRES
                          WHERE        (.dbo.HCORDPRON.MANEXTPRO = 1) AND (ING.CODENTIDA = '00021')
                          UNION ALL
                          SELECT                   '415510047901' AS Código_Habilitación, 'E.S.E. Hospital Departamental San Antonio de Pitalito Huila' AS Nombre_del_Prestador, PAC.IPNOMCOMP AS Nombre_Paciente,  
                                                   CASE WHEN PAC.IPTIPODOC = 1 THEN 'CC' WHEN PAC.IPTIPODOC = 2 THEN 'CE' WHEN PAC.IPTIPODOC = 3 THEN 'TI' WHEN PAC.IPTIPODOC = 4 THEN 'RC' WHEN PAC.IPTIPODOC = 5 THEN 'PA' WHEN
                                                   PAC.IPTIPODOC = 6 THEN 'AS' WHEN PAC.IPTIPODOC = 7 THEN 'MS' WHEN PAC.IPTIPODOC = 8 THEN 'NU' WHEN PAC.IPTIPODOC = 9 THEN 'CN' WHEN PAC.IPTIPODOC = 10 THEN 'CD' WHEN PAC.IPTIPODOC = 11 THEN 'SC' WHEN PAC.IPTIPODOC = 12 THEN 'PE' END AS Tipo_Identificación_del_Afiliado,
												   PAC.IPCODPACI AS Número_de_Identificación_del_Afiliado, 
                                                   PAC.IPTELEFON AS Telefono_Celular_1, PAC.IPTELMOVI AS Telefono_Celular_2, .dbo.HCORDPROQ.FECORDMED AS Fecha_Atencion, 
                                                   .dbo.HCORDPROQ.CODSERIPS AS Código_CUPS_Prestacion, INCUPSIPS_1.DESCODCUPS AS Descripcion_Prestacion, 
                                                   .dbo.HCORDPROQ.CANSERIPS AS Cantidad,  
                                                   HCHISPACA_1.DATOBJETI AS Justificacion_Clinica, INDIAGNOS_1.CODDIAGNO AS CIE10, 
                                                   PROF.NOMMEDICO AS Nombre_Medico, ESP.CODESPECI AS Codigo_Especialidad_Remitente, ESP.DESESPECI AS Especialidad_Remitente ,
												   CASE WHEN NOMSEMGES IS NULL THEN 0 WHEN ANT.NOMSEMGES >= 0.1 THEN ANT.NOMSEMGES END AS [Edad Gestacional (Semanas)],
												   CASE WHEN HCQ.TIPOANEST = 1 THEN 'A' WHEN HCQ.TIPOANEST = 2 THEN 'A' WHEN HCQ.TIPOANEST = 3 THEN 'A' END [Anestesia_(A)], 
												   '' [Sedación_(S)], '' as [Contraste_(T)], '' as [Comparativo_(C)], 
												   '' [Bilateral_(B)] 
                                                   
                          FROM            .dbo.ADINGRESO AS ING LEFT OUTER JOIN
                                                   .dbo.INESPECIA AS ESP LEFT OUTER JOIN
                                                   .dbo.INPROFSAL AS PROF ON ESP.CODESPECI = PROF.CODESPEC1 LEFT OUTER JOIN
                                                   .dbo.HCORDPROQ LEFT OUTER JOIN
                                                   .dbo.INPACIENT AS PAC ON .dbo.HCORDPROQ.IPCODPACI = PAC.IPCODPACI LEFT OUTER JOIN
                                                   .dbo.INCUPSIPS AS INCUPSIPS_1 ON .dbo.HCORDPROQ.CODSERIPS = INCUPSIPS_1.CODSERIPS AND 
                                                   .dbo.HCORDPROQ.CODSERIPS = INCUPSIPS_1.CODSERIPS ON PROF.CODPROSAL = .dbo.HCORDPROQ.CODPROSAL ON 
                                                   ING.NUMINGRES = .dbo.HCORDPROQ.NUMINGRES LEFT OUTER JOIN
                                                   .dbo.INDIAGNOS AS INDIAGNOS_1 ON .dbo.HCORDPROQ.CODDIAGNO = INDIAGNOS_1.CODDIAGNO AND 
                                                   .dbo.HCORDPROQ.CODDIAGNO = INDIAGNOS_1.CODDIAGNO LEFT OUTER JOIN
                                                   .dbo.HCHISPACA AS HCHISPACA_1 ON .dbo.HCORDPROQ.NUMINGRES = HCHISPACA_1.NUMINGRES AND 
                                                   .dbo.HCORDPROQ.NUMEFOLIO = HCHISPACA_1.NUMEFOLIO LEFT JOIN
												   .DBO.HCQXINFOR AS HCQ ON HCQ.NUMINGRES = ING.NUMINGRES LEFT JOIN
												   .dbo.HCANTGINE AS ANT ON ANT.IPCODPACI = ING.IPCODPACI AND ANT.NUMINGRES=ING.NUMINGRES
                          WHERE        (.dbo.HCORDPROQ.MANEXTPRO = 1) AND (ING.CODENTIDA = '00021')
						  UNION ALL
						  SELECT                   '415510047901' AS Código_Habilitación, 'E.S.E. Hospital Departamental San Antonio de Pitalito Huila' AS Nombre_del_Prestador, PAC.IPNOMCOMP AS Nombre_Paciente,  
                                                   CASE WHEN PAC.IPTIPODOC = 1 THEN 'CC' WHEN PAC.IPTIPODOC = 2 THEN 'CE' WHEN PAC.IPTIPODOC = 3 THEN 'TI' WHEN PAC.IPTIPODOC = 4 THEN 'RC' WHEN PAC.IPTIPODOC = 5 THEN 'PA' WHEN
                                                   PAC.IPTIPODOC = 6 THEN 'AS' WHEN PAC.IPTIPODOC = 7 THEN 'MS' WHEN PAC.IPTIPODOC = 8 THEN 'NU' WHEN PAC.IPTIPODOC = 9 THEN 'CN' WHEN PAC.IPTIPODOC = 10 THEN 'CD' WHEN PAC.IPTIPODOC = 11 THEN 'SC' WHEN PAC.IPTIPODOC = 12 THEN 'PE' END AS Tipo_Identificación_del_Afiliado,
												   PAC.IPCODPACI AS Número_de_Identificación_del_Afiliado, 
                                                   PAC.IPTELEFON AS Telefono_Celular_1, PAC.IPTELMOVI AS Telefono_Celular_2, .dbo.HCORDINTE.FECORDMED AS Fecha_Atencion, 
                                                   .dbo.HCORDINTE.CODSERIPS AS Código_CUPS_Prestacion, INCUPSIPS_3.DESCODCUPS AS Descripcion_Pretacion, 
                                                   .dbo.HCORDINTE.CANSERIPS AS Cantidad, 
                                                   HCHISPACA_3.DATOBJETI AS Justificacion_Clinica, INDIAGNOS_3.CODDIAGNO AS CIE10, 
                                                   PROF.NOMMEDICO AS Nombre_Medico,ESP.CODESPECI AS Codigo_Especialidad_Remitente, ESP.DESESPECI AS Especialidad_Remitente ,
												   CASE WHEN NOMSEMGES IS NULL THEN 0 WHEN ANT.NOMSEMGES >= 0.1 THEN ANT.NOMSEMGES END AS [Edad Gestacional (Semanas)], 
												   CASE WHEN HCQ.TIPOANEST = 1 THEN 'A' WHEN HCQ.TIPOANEST = 2 THEN 'A' WHEN HCQ.TIPOANEST = 3 THEN 'A' END [Anestesia_(A)], 
												   ''  [Sedación_(S)],
												   ''  [Contraste_(T)], '' as [Comparativo_(C)], 
												   ''  [Bilateral_(B)]  
                                                   
                          FROM            .dbo.ADINGRESO AS ING INNER JOIN
                                                   .dbo.INESPECIA AS ESP INNER JOIN
                                                   .dbo.INPROFSAL AS PROF ON ESP.CODESPECI = PROF.CODESPEC1 INNER JOIN
                                                   .dbo.HCORDINTE INNER JOIN
                                                   .dbo.INPACIENT AS PAC ON .dbo.HCORDINTE.IPCODPACI = PAC.IPCODPACI INNER JOIN
                                                   .dbo.INCUPSIPS AS INCUPSIPS_3 ON .dbo.HCORDINTE.CODSERIPS = INCUPSIPS_3.CODSERIPS AND .dbo.HCORDINTE.CODSERIPS = INCUPSIPS_3.CODSERIPS ON PROF.CODPROSAL = .dbo.HCORDINTE.CODPROSAL ON ING.NUMINGRES = .dbo.HCORDINTE.NUMINGRES INNER JOIN
                                                   .dbo.INDIAGNOS AS INDIAGNOS_3 ON .dbo.HCORDINTE.CODDIAGNO = INDIAGNOS_3.CODDIAGNO AND 
                                                   .dbo.HCORDINTE.CODDIAGNO = INDIAGNOS_3.CODDIAGNO INNER JOIN
                                                   .dbo.HCHISPACA AS HCHISPACA_3 ON .dbo.HCORDINTE.NUMINGRES = HCHISPACA_3.NUMINGRES AND 
                                                   .dbo.HCORDINTE.NUMEFOLIO = HCHISPACA_3.NUMEFOLIO LEFT JOIN
												   .DBO.HCQXINFOR AS HCQ ON HCQ.NUMINGRES = ING.NUMINGRES LEFT JOIN
												   .dbo.HCANTGINE AS ANT ON ANT.IPCODPACI = ING.IPCODPACI AND ANT.NUMINGRES=ING.NUMINGRES
                          WHERE        (.dbo.HCORDINTE.MANEXTPRO = 1) AND (ING.CODENTIDA = '00021')
						  UNION ALL
						  SELECT                   '415510047901' AS Código_Habilitación, 'E.S.E. Hospital Departamental San Antonio de Pitalito Huila' AS Nombre_del_Prestador, PAC.IPNOMCOMP AS Nombre_Paciente,
                                                   CASE WHEN PAC.IPTIPODOC = 1 THEN 'CC' WHEN PAC.IPTIPODOC = 2 THEN 'CE' WHEN PAC.IPTIPODOC = 3 THEN 'TI' WHEN PAC.IPTIPODOC = 4 THEN 'RC' WHEN PAC.IPTIPODOC = 5 THEN 'PA' WHEN
                                                   PAC.IPTIPODOC = 6 THEN 'AS' WHEN PAC.IPTIPODOC = 7 THEN 'MS' WHEN PAC.IPTIPODOC = 8 THEN 'NU' WHEN PAC.IPTIPODOC = 9 THEN 'CN' WHEN PAC.IPTIPODOC = 10 THEN 'CD' WHEN PAC.IPTIPODOC = 11 THEN 'SC' WHEN PAC.IPTIPODOC = 12 THEN 'PE' END AS Tipo_Identificación_del_Afiliado,
												   PAC.IPCODPACI AS Número_de_Identificación_del_Afiliado, 
                                                   PAC.IPTELEFON AS Telefono_Celular_1, PAC.IPTELMOVI AS Telefono_Celular_2, .dbo.HCORDPATO.FECORDMED AS Fecha_Atencion, 
                                                   .dbo.HCORDPATO.CODSERIPS AS Código_CUPS_Prestacion, INCUPSIPS_3.DESCODCUPS AS Descripcion_Prestacion, 
                                                   .dbo.HCORDPATO.CANSERIPS AS Cantidad,  
                                                   HCHISPACA_3.DATOBJETI AS Justificacion_Clinica, INDIAGNOS_3.CODDIAGNO AS CIE10, 
                                                   PROF.NOMMEDICO AS Nombre_Medico, ESP.CODESPECI AS Codigo_Especialidad_Remitente, ESP.DESESPECI AS Especialidad_Remitente ,
												   CASE WHEN NOMSEMGES IS NULL THEN 0 WHEN ANT.NOMSEMGES >= 0.1 THEN ANT.NOMSEMGES END AS [Edad Gestacional (Semanas)],
												   CASE WHEN HCQ.TIPOANEST = 1 THEN 'A' WHEN HCQ.TIPOANEST = 2 THEN 'A' WHEN HCQ.TIPOANEST = 3 THEN 'A' END [Anestesia_(A)], 
												   '' [Sedación_(S)], '' as [Contraste_(T)], '' as [Comparativo_(C)], 
												   '' [Bilateral_(B)]  
                                                   
                          FROM            .dbo.ADINGRESO AS ING INNER JOIN
                                                   .dbo.INESPECIA AS ESP INNER JOIN
                                                   .dbo.INPROFSAL AS PROF ON ESP.CODESPECI = PROF.CODESPEC1 INNER JOIN
                                                   .dbo.HCORDPATO INNER JOIN
                                                   .dbo.INPACIENT AS PAC ON .dbo.HCORDPATO.IPCODPACI = PAC.IPCODPACI INNER JOIN
                                                   .dbo.INCUPSIPS AS INCUPSIPS_3 ON .dbo.HCORDPATO.CODSERIPS = INCUPSIPS_3.CODSERIPS AND .dbo.HCORDPATO.CODSERIPS = INCUPSIPS_3.CODSERIPS ON PROF.CODPROSAL = .dbo.HCORDPATO.CODPROSAL ON ING.NUMINGRES = .dbo.HCORDPATO.NUMINGRES INNER JOIN
                                                   .dbo.INDIAGNOS AS INDIAGNOS_3 ON .dbo.HCORDPATO.CODDIAGNO = INDIAGNOS_3.CODDIAGNO AND 
                                                   .dbo.HCORDPATO.CODDIAGNO = INDIAGNOS_3.CODDIAGNO INNER JOIN
                                                   .dbo.HCHISPACA AS HCHISPACA_3 ON .dbo.HCORDPATO.NUMINGRES = HCHISPACA_3.NUMINGRES AND 
                                                   .dbo.HCORDPATO.NUMEFOLIO = HCHISPACA_3.NUMEFOLIO LEFT JOIN
												   .DBO.HCQXINFOR AS HCQ ON HCQ.NUMINGRES = ING.NUMINGRES LEFT JOIN
												   .dbo.HCANTGINE AS ANT ON ANT.IPCODPACI = ING.IPCODPACI AND ANT.NUMINGRES=ING.NUMINGRES
                          WHERE        (.dbo.HCORDPATO.MANEXTPRO = 1) AND (ING.CODENTIDA = '00021')
						  ) AS datos

						  
