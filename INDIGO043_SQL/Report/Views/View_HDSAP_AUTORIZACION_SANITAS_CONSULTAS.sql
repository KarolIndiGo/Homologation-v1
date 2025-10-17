-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_AUTORIZACION_SANITAS_CONSULTAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0






CREATE VIEW [Report].[View_HDSAP_AUTORIZACION_SANITAS_CONSULTAS]
AS



select   
                                  getdate () as Fecha_Envio,
								   '415510047901' AS Código_Habilitación, 'E.S.E. Hospital Departamental San Antonio de Pitalito Huila' AS Nombre_del_Prestador,
								   CASE WHEN PAC.IPTIPODOC = 1 THEN 'CC' 
								   WHEN PAC.IPTIPODOC = 2 THEN 'CE' 
								   WHEN PAC.IPTIPODOC = 3 THEN 'TI' 
								   WHEN PAC.IPTIPODOC = 4 THEN 'RC' 
								   WHEN PAC.IPTIPODOC = 5 THEN 'PA' 
								   WHEN PAC.IPTIPODOC = 6 THEN 'AS' 
								   WHEN PAC.IPTIPODOC = 7 THEN 'MS' 
								   WHEN PAC.IPTIPODOC = 8 THEN 'NU' 
								   WHEN PAC.IPTIPODOC = 9 THEN 'CN' 
								   WHEN PAC.IPTIPODOC = 10 THEN 'CD' 
								   WHEN PAC.IPTIPODOC = 11 THEN 'SC' 
								   WHEN PAC.IPTIPODOC = 12 THEN 'PE' 
								   END AS Tipo_Identificación_del_Afiliado,
								   PAC.IPCODPACI AS Número_de_Identificación_del_Afiliado, 
								   PAC.IPNOMCOMP AS Nombre_Paciente,                               
								   
								   PAC.IPTELEFON AS Telefono_Celular_1,
								   PAC.IPTELMOVI AS Telefono_Celular_2, 
								   HC.FECHISPAC AS Fecha_Atencion, 
								   DI.CODDIAGNO AS CIE10, 
								   PROF.NOMMEDICO AS Nombre_Medico,
								   INE.CODESPECI AS Codigo_Especialidad_Remitente,
								   INE.DESESPECI AS Especialidad_Remitente,
                                   AD.CODSERIPS AS Código_CUPS_Prestacion, 
								   CUPS.DESCODCUPS AS Descripcion_Prestacion,
								   '1' AS Cantidad,
								   HC.DATOBJETI AS Justificacion_Clinica,							    
								   CASE WHEN NOMSEMGES IS NULL THEN 0 WHEN ANT.NOMSEMGES >= 0.1 THEN ANT.NOMSEMGES END AS [Edad Gestacional (Semanas)] ,
								   CASE WHEN HCQ.TIPOANEST = 1 THEN 'A' WHEN HCQ.TIPOANEST = 2 THEN 'A' WHEN HCQ.TIPOANEST = 3 THEN 'A' END [Anestesia_(A)], 
													'' [Sedación_(S)], '' as [Contraste_(T)], '' as [Comparativo_(C)], 
													'' [Bilateral_(B)] 

from HCDESCOEX ad
JOIN ADINGRESO ING ON ING.NUMINGRES = AD.NUMINGRES
JOIN INDIAGNOS DI ON DI.CODDIAGNO = ING.CODDIAING
JOIN INPACIENT PAC ON PAC.IPCODPACI = AD.IPCODPACI
JOIN HCHISPACA HC ON AD.NUMINGRES = HC.NUMINGRES
JOIN INCUPSIPS CUPS ON AD.CODSERIPS = CUPS.CODSERIPS 
JOIN INESPECIA INE ON INE.CODESPECI = AD.CODESPECI
LEFT JOIN HCQXINFOR AS HCQ ON HCQ.NUMINGRES = ING.NUMINGRES
JOIN  INPROFSAL AS PROF ON PROF.CODPROSAL = HC.CODPROSAL
left JOIN HCANTGINE AS ANT ON ANT.IPCODPACI = ING.IPCODPACI AND ANT.NUMINGRES=ING.NUMINGRES
WHERE ING.CODENTIDA in ('00021','EA0085')

                        

