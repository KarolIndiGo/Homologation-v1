-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_AD_HC_AtencionCExt
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[IND_AD_HC_AtencionCExt] AS
SELECT 
MONTH(i.Fecha) AS Mes, 
YEAR(i.Fecha) as Año, 
i.NUMINGRES as Ingreso, 
h.IPCODPACI as Documento, 
h.CODESPTRA as CodEsp, 
ltrim(rtrim(E.DESESPECI)) as EspecialidadTratante, 
h.UFUCODIGO,
case 
when H.ufucodigo like 'MET%' then 'Meta' 
when H.ufucodigo  in ('CAS100','CAS001','CAS002','CAS003','CAS004','YOP001','YOP002','MYO001') then 'Casanare' 
when H.ufucodigo like 'BOY%' then 'Boyaca' 
when H.ufucodigo like 'B0%' then 'Boyaca'  
when H.ufucodigo  in ('MTU001','MTU101') then 'Boyaca'
when H.ufucodigo  in ('MVI001') then 'Meta' 
end as Regional,
CASE
WHEN H.CODCENATE = '001' THEN 'BOGOTA'                                                                                     
WHEN H.CODCENATE = '002' THEN 'TUNJA'                                                                                      
WHEN H.CODCENATE = '003' THEN 'DUITAMA'                                                                                    
WHEN H.CODCENATE = '004' THEN 'SOGAMOSO'                                                                                   
WHEN H.CODCENATE = '005' THEN 'CHIQUINQUIRA'                                                                               
WHEN H.CODCENATE = '006' THEN 'GARAGOA'                                                                                    
WHEN H.CODCENATE = '007' THEN 'GUATEQUE'                                                                                   
WHEN H.CODCENATE = '008' THEN 'SOATA'                                                                                      
WHEN H.CODCENATE = '009' THEN 'MONIQUIRA'                                                                                  
WHEN H.CODCENATE = '010' THEN 'VILLAVICENCIO'                                                                              
WHEN H.CODCENATE = '011' THEN 'ACACIAS'                                                                                    
WHEN H.CODCENATE = '012' THEN 'GRANADA'                                                                                    
WHEN H.CODCENATE = '013' THEN 'PUERTO LOPEZ'                                                                               
WHEN H.CODCENATE = '014' THEN 'PUERTO GAITAN'                                                                              
WHEN H.CODCENATE = '015' THEN 'YOPAL'                                                                                      
WHEN H.CODCENATE = '016' THEN 'VILLANUEVA'                                                                                 
WHEN H.CODCENATE = '017' THEN 'PUERTO BOYACA'  
WHEN H.CODCENATE = '018' THEN 'SAN MARTIN'  
WHEN H.CODCENATE = '019' THEN 'PAZ DE ARIPORO'  
WHEN H.CODCENATE = '020' THEN 'AGUAZUL'  
WHEN H.CODCENATE = '021' THEN 'MIRAFLORES'  
WHEN H.CODCENATE = '999' THEN 'NUEVO CENTRO'
END AS Sede, 
tp.nit

FROM (
		select max(FECHISPAC) as Fecha, NUMINGRES
		from dbo.HCHISPACA AS H INNER JOIN 
		     dbo.INUNIFUNC AS U ON U.UFUCODIGO=H.UFUCODIGO
		where U.UFUTIPUNI IN (15,24) and FECHISPAC>='01-01-2022'
		group by NUMINGRES
	) AS I INNER JOIN 
dbo.HCHISPACA as h on h.NUMINGRES=i.NUMINGRES and h.FECHISPAC=i.Fecha
inner join dbo.INESPECIA AS E ON E.CODESPECI=H.CODESPTRA
inner join dbo.ADINGRESO AS G ON G. NUMINGRES=I.NUMINGRES
INNER JOIN  Contract.HealthAdministrator as ha on ha.Id= g.GENCONENTITY
inner join Common.ThirdParty as tp on tp.id=ha.ThirdPartyId
