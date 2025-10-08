-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_AD_HC_ATENCIONCEXT
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_AD_HC_ATENCIONCEXT 
AS
SELECT
MONTH(I.Fecha) AS Mes, 
YEAR(I.Fecha) as Año, 
I.NUMINGRES as Ingreso, 
h.IPCODPACI as Documento, 
h.CODESPTRA as CodEsp, 
ltrim(rtrim(E.DESESPECI)) as EspecialidadTratante, 
h.UFUCODIGO,
case
when h.UFUCODIGO like 'MET%' then 'Meta' 
when h.UFUCODIGO  in ('CAS100','CAS001','CAS002','CAS003','CAS004','YOP001','YOP002','MYO001') then 'Casanare' 
when h.UFUCODIGO like 'BOY%' then 'Boyaca' 
when h.UFUCODIGO like 'B0%' then 'Boyaca'  
when h.UFUCODIGO  in ('MTU001','MTU101') then 'Boyaca'
when h.UFUCODIGO  in ('MVI001') then 'Meta' 
end as Regional,
CASE
WHEN h.CODCENATE = '001' THEN 'BOGOTA'                                                                                     
WHEN h.CODCENATE = '002' THEN 'TUNJA'                                                                                      
WHEN h.CODCENATE = '003' THEN 'DUITAMA'                                                                                    
WHEN h.CODCENATE = '004' THEN 'SOGAMOSO'                                                                                   
WHEN h.CODCENATE = '005' THEN 'CHIQUINQUIRA'                                                                               
WHEN h.CODCENATE = '006' THEN 'GARAGOA'                                                                                    
WHEN h.CODCENATE = '007' THEN 'GUATEQUE'                                                                                   
WHEN h.CODCENATE = '008' THEN 'SOATA'                                                                                      
WHEN h.CODCENATE = '009' THEN 'MONIQUIRA'                                                                                  
WHEN h.CODCENATE = '010' THEN 'VILLAVICENCIO'                                                                              
WHEN h.CODCENATE = '011' THEN 'ACACIAS'                                                                                    
WHEN h.CODCENATE = '012' THEN 'GRANADA'                                                                                    
WHEN h.CODCENATE = '013' THEN 'PUERTO LOPEZ'                                                                               
WHEN h.CODCENATE = '014' THEN 'PUERTO GAITAN'                                                                              
WHEN h.CODCENATE = '015' THEN 'YOPAL'                                                                                      
WHEN h.CODCENATE = '016' THEN 'VILLANUEVA'                                                                                 
WHEN h.CODCENATE = '017' THEN 'PUERTO BOYACA'  
WHEN h.CODCENATE = '018' THEN 'SAN MARTIN'  
WHEN h.CODCENATE = '019' THEN 'PAZ DE ARIPORO'  
WHEN h.CODCENATE = '020' THEN 'AGUAZUL'  
WHEN h.CODCENATE = '021' THEN 'MIRAFLORES'  
WHEN h.CODCENATE = '999' THEN 'NUEVO CENTRO'
END AS Sede, 
tp.Nit

FROM (
		select max(FECHISPAC) as Fecha, NUMINGRES
		from [INDIGO031].[dbo].[HCHISPACA] AS H 
        INNER JOIN [INDIGO031].[dbo].[INUNIFUNC] AS U ON U.UFUCODIGO=H.UFUCODIGO
		where U.UFUTIPUNI IN (15,24) and FECHISPAC>='01-01-2022'
		group by NUMINGRES
	) AS I 
INNER JOIN [INDIGO031].[dbo].[HCHISPACA] as h on h.NUMINGRES=I.NUMINGRES and h.FECHISPAC=I.Fecha
inner join [INDIGO031].[dbo].[INESPECIA] AS E ON E.CODESPECI=h.CODESPTRA
inner join [INDIGO031].[dbo].[ADINGRESO] AS G ON G. NUMINGRES=I.NUMINGRES
INNER JOIN [INDIGO031].[Contract].[HealthAdministrator] as ha on ha.Id= G.GENCONENTITY
inner join [INDIGO031].[Common].[ThirdParty] as tp on tp.Id=ha.ThirdPartyId
