-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_AS_HC_PYP
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_AS_HC_PYP 
AS

SELECT 
    A.CODCENATE	AS CodSucursal,
    case
        when A.UFUCODIGO like 'MET%' then 'Meta' 
        when A.UFUCODIGO  in ('CAS100','CAS001','CAS002','CAS003','CAS004','YOP001','YOP002','MYO001') then 'Casanare' 
        when A.UFUCODIGO like 'BOY%' then 'Boyaca' 
        when A.UFUCODIGO like 'B0%' then 'Boyaca'  
        when A.UFUCODIGO  in ('MTU001','MTU101') then 'Boyaca'
        when A.UFUCODIGO  in ('MVI001') then 'Meta' 
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
    A.IPCODPACI	    AS Identificacion,
    A.NUMINGRES	    AS Ingreso,
    I.CODDIAING	    AS CIE10,
    dx.NOMDIAGNO    AS Diagnostico,
    RIAS.NOMBRE	    AS DemandaInducida,
    A.UFUCODIGO	    AS CodUF,
    C.UFUDESCRI	    AS UnidadFuncional,
    A.FECREGSIS	    AS Fecha,
    ea.Name		    AS Entidad,
    estado.Estado   AS Estado,			
    TP.Nit		    AS Nit,
    CASE 
        WHEN B.IPSEXOPAC = '1' THEN 'Masculino' 
        WHEN B.IPSEXOPAC = '2' THEN 'Femenino' 
        END AS Sexo,
    CASE
        WHEN DATEDIFF(MONTH,B.IPFECNACI,A.FECREGSIS)/12 <= '5' THEN	'1. Primera Infancia (0-5)'
        WHEN DATEDIFF(MONTH,B.IPFECNACI,A.FECREGSIS)/12 BETWEEN '6' AND '11' THEN '2. Infancia (6-11)'
        WHEN DATEDIFF(MONTH,B.IPFECNACI,A.FECREGSIS)/12 BETWEEN '12' AND '17' THEN	'3. Adolescencia (12-17)'
        WHEN DATEDIFF(MONTH,B.IPFECNACI,A.FECREGSIS)/12 BETWEEN '18' AND '28' THEN	'4. Juventud (18-28)'
        WHEN DATEDIFF(MONTH,B.IPFECNACI,A.FECREGSIS)/12 BETWEEN '29' AND '59' THEN	'5. Adultez (29-59)'
        WHEN DATEDIFF(MONTH,B.IPFECNACI,A.FECREGSIS)/12 >= '60' THEN '6. Vejez (>60)'
        END  AS CursoVida,
    A.CODPROSAL	AS CodProfesional,
    LTRIM(RTRIM(PRO.MEDPRINOM)) +' '+ LTRIM(RTRIM(PRO.MEDPRIAPEL)) AS Profesional, 
    A.JUSNOREPP as [Justificacion No Envio],
    ES.DESESPECI AS Especialidad,
    CASE WHEN  A.JUSNOREPP= '' THEN 'Si' else 'No' end as Enviado

FROM [INDIGO031].[dbo].[HCPPYPPAC] AS A  
INNER JOIN [INDIGO031].[dbo].[RIAS] AS RIAS ON RIAS.ID = A.IDRIAS 
INNER JOIN [INDIGO031].[dbo].[ADINGRESO] AS I  ON I.NUMINGRES = A.NUMINGRES 
INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS B  ON B.IPCODPACI = A.IPCODPACI 
INNER JOIN [INDIGO031].[dbo].[INUNIFUNC] AS C  ON C.UFUCODIGO = A.UFUCODIGO 
INNER JOIN [INDIGO031].[dbo].[ADCENATEN] AS CA ON CA.CODCENATE = A.CODCENATE 
INNER JOIN [INDIGO031].[dbo].[INPROFSAL] AS PRO ON PRO.CODPROSAL = A.CODPROSAL 
INNER JOIN [INDIGO031].[dbo].[INESPECIA] AS ES ON ES.CODESPECI = PRO.CODESPEC1 
INNER JOIN [INDIGO031].[Contract].[CareGroup] AS ga  ON ga.Id = I.GENCAREGROUP 
INNER JOIN [INDIGO031].[Contract].[HealthAdministrator] AS ea  ON ea.Id = I.GENCONENTITY 
INNER JOIN [INDIGO031].[Common].[ThirdParty] AS TP ON TP.Id=ea.ThirdPartyId
INNER JOIN [INDIGO031].[dbo].[INDIAGNOS] AS dx  ON dx.CODDIAGNO = I.CODDIAING 
INNER JOIN [INDIGO031].[dbo].[INUBICACI] AS UB  ON UB.AUUBICACI = B.AUUBICACI 
INNER JOIN [INDIGO031].[dbo].[INDEPARTA] AS dep  ON dep.depcodigo = SUBSTRING(B.AUUBICACI, 1, 2) 
INNER JOIN [INDIGO031].[dbo].[INMUNICIP] AS m  ON m.DEPMUNCOD = SUBSTRING(B.AUUBICACI, 1, 5) 
LEFT OUTER JOIN (select a.NUMINGRES, a.FECHISPAC, CASE  h.INDICAPAC WHEN 11 THEN 'Fallecido' else 'Vivo' end as Estado
					from (
						 select NUMINGRES, max(FECHISPAC) as FECHISPAC
						 FROM [INDIGO031].[dbo].[HCHISPACA] AS A
						 group by NUMINGRES) as a INNER JOIN [INDIGO031].[dbo].[HCHISPACA] as h on h.NUMINGRES=a.NUMINGRES 
                                and h.FECHISPAC=a.FECHISPAC) as estado on estado.NUMINGRES=A.NUMINGRES
WHERE     YEAR(A.FECREGSIS) >= '2022'
