-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_AS_HC_PyP
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE VIEW [ViewInternal].[IND_AS_HC_PyP] AS
SELECT 
A.CODCENATE					AS CodSucursal,
case 
when A.ufucodigo like 'MET%' then 'Meta' 
when A.ufucodigo  in ('CAS100','CAS001','CAS002','CAS003','CAS004','YOP001','YOP002','MYO001') then 'Casanare' 
when A.ufucodigo like 'BOY%' then 'Boyaca' 
when A.ufucodigo like 'B0%' then 'Boyaca'  
when A.ufucodigo  in ('MTU001','MTU101') then 'Boyaca'
when A.ufucodigo  in ('MVI001') then 'Meta' 
end as Regional,
CASE
WHEN A.CODCENATE = '001' THEN 'BOGOTA'                                                                                     
WHEN A.CODCENATE = '002' THEN 'TUNJA'                                                                                      
WHEN A.CODCENATE = '003' THEN 'DUITAMA'                                                                                    
WHEN A.CODCENATE = '004' THEN 'SOGAMOSO'                                                                                   
WHEN A.CODCENATE = '005' THEN 'CHIQUINQUIRA'                                                                               
WHEN A.CODCENATE = '006' THEN 'GARAGOA'                                                                                    
WHEN A.CODCENATE = '007' THEN 'GUATEQUE'                                                                                   
WHEN A.CODCENATE = '008' THEN 'SOATA'                                                                                      
WHEN A.CODCENATE = '009' THEN 'MONIQUIRA'                                                                                  
WHEN A.CODCENATE = '010' THEN 'VILLAVICENCIO'                                                                              
WHEN A.CODCENATE = '011' THEN 'ACACIAS'                                                                                    
WHEN A.CODCENATE = '012' THEN 'GRANADA'                                                                                    
WHEN A.CODCENATE = '013' THEN 'PUERTO LOPEZ'                                                                               
WHEN A.CODCENATE = '014' THEN 'PUERTO GAITAN'                                                                              
WHEN A.CODCENATE = '015' THEN 'YOPAL'                                                                                      
WHEN A.CODCENATE = '016' THEN 'VILLANUEVA'                                                                                 
WHEN A.CODCENATE = '017' THEN 'PUERTO BOYACA'                                                                              
WHEN A.CODCENATE = '999' THEN 'NUEVO CENTRO'
END AS Sede,
A.IPCODPACI					AS Identificacion,
A.NUMINGRES					AS Ingreso,
I.CODDIAING					AS CIE10,
DX.NOMDIAGNO				AS Diagnostico,
RIAS.NOMBRE					AS DemandaInducida,
A.ufucodigo					AS CodUF,
C.UFUDESCRI					AS UnidadFuncional,
a.fecregsis					AS Fecha,
ea.NAME						AS Entidad,
estado.estado				AS Estado,			
tp.nit						AS Nit,
CASE WHEN B.IPSEXOPAC = '1' THEN 'Masculino' WHEN B.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo,

 CASE
   WHEN DATEDIFF(MONTH,B.IPFECNACI,a.fecregsis)/12 <= '5' THEN						'1. Primera Infancia (0-5)'
   WHEN DATEDIFF(MONTH,B.IPFECNACI,a.fecregsis)/12 BETWEEN '6' AND '11' THEN		'2. Infancia (6-11)'
   WHEN DATEDIFF(MONTH,B.IPFECNACI,a.fecregsis)/12 BETWEEN '12' AND '17' THEN		'3. Adolescencia (12-17)'
   WHEN DATEDIFF(MONTH,B.IPFECNACI,a.fecregsis)/12 BETWEEN '18' AND '28' THEN		'4. Juventud (18-28)'
   WHEN DATEDIFF(MONTH,B.IPFECNACI,a.fecregsis)/12 BETWEEN '29' AND '59' THEN		'5. Adultez (29-59)'
   WHEN DATEDIFF(MONTH,B.IPFECNACI,a.fecregsis)/12 >= '60' THEN						'6. Vejez (>60)'
 END                                   AS CursoVida,
 A.CODPROSAL						   AS CodProfesional,
 LTRIM(RTRIM(PRO.MEDPRINOM)) +' '+ LTRIM(RTRIM(PRO.MEDPRIAPEL))							AS Profesional, 
 a.JUSNOREPP as [Justificacion No Envio], ES.DESESPECI AS Especialidad,
 CASE WHEN  a.JUSNOREPP= '' THEN 'Si' else 'No' end as Enviado

FROM DBO.HCPPYPPAC AS A  INNER JOIN
DBO.RIAS AS RIAS ON RIAS.ID = A.IDRIAS INNER JOIN
DBO.ADINGRESO AS I  ON I.NUMINGRES = A.NUMINGRES INNER JOIN
dbo.INPACIENT AS B  ON B.IPCODPACI = A.IPCODPACI INNER JOIN
dbo.INUNIFUNC AS C  ON C.UFUCODIGO = A.UFUCODIGO INNER JOIN
dbo.ADCENATEN AS CA ON CA.CODCENATE = A.CODCENATE INNER JOIN
dbo.INPROFSAL AS PRO ON PRO.CODPROSAL = A.CODPROSAL INNER JOIN
dbo.INESPECIA AS ES ON ES.CODESPECI = PRO.CODESPEC1 INNER JOIN
Contract.CareGroup AS ga  ON ga.Id = I.GENCAREGROUP INNER JOIN
Contract.HealthAdministrator AS ea  ON ea.Id = I.GENCONENTITY INNER JOIN
Common.ThirdParty AS TP ON TP.ID=EA.ThirdPartyId INNER JOIN
dbo.INDIAGNOS AS dx  ON dx.CODDIAGNO = I.CODDIAING INNER JOIN
dbo.INUBICACI AS UB  ON UB.AUUBICACI = B.AUUBICACI INNER JOIN
dbo.INDEPARTA AS dep  ON dep.depcodigo = SUBSTRING(B.AUUBICACI, 1, 2) INNER JOIN
dbo.INMUNICIP AS m  ON m.DEPMUNCOD = SUBSTRING(B.AUUBICACI, 1, 5) LEFT OUTER JOIN
				(select A.NUMINGRES, A.FECHISPAC, CASE  H.INDICAPAC WHEN 11 THEN 'Fallecido' else 'Vivo' end as Estado
					from (
						 select numingres, max(FECHISPAC) as FECHISPAC
						 FROM            dbo.HCHISPACA AS A
						 group by numingres) as a INNER JOIN
						 dbo.HCHISPACA as h on h.NUMINGRES=a.NUMINGRES and h.FECHISPAC=a.FECHISPAC) as estado on estado.NUMINGRES=a.NUMINGRES
WHERE     YEAR(A.FECREGSIS) >= '2022'
