-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_HC_HC_ControlOdontologiaCEO_CPO
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_HC_HC_ControlOdontologiaCEO_CPO] as

SELECT   caa.nomcenate as CentroAtención, u.ufudescri as UnidadFuncional, c.ipcodpaci as DocumentoPaciente, c.numingres as Ingreso,  YEAR(FECHAREG) - YEAR(P.IPFECNACI) AS Edad, c.numefolio as Folio, m.nommedico as Profesional, c.fechareg as FechaRegistro,
rc.codserips as CodigoProcedimiento, ps.desserips as Procedimiento, RCI.NOMBRE AS RIAS, CV.CEO_C as [Indice Cariados CEO],CEO_E as [Indice Extraidos CEO],  CEO_O as [Indice Obturados CEO], CPO_C as [Indice Cariados CPO],
CPO_P as [Indice Perdidos CPO],  CPO_O as [Indice Obturados CPO], CPO_C+CPO_P+CPO_O as [Indice COP],  CEO_C+CEO_E+CEO_O as [Indice CEO] , 

 CASE 
        WHEN ds.Sanos < 10 THEN CONCAT('0', ds.Sanos)
		WHEN ds.Sanos is null then COALESCE(CAST(ds.Sanos AS VARCHAR), '00')
        ELSE CAST(ds.Sanos AS VARCHAR)
    END AS [Diente Sano],

	CASE 
        WHEN dn.diente2 < 10 THEN CONCAT('0', dn.diente2)
		WHEN dn.diente2 is null then COALESCE(CAST(dn.diente2 AS VARCHAR), '00')
        ELSE CAST(dn.diente2 AS VARCHAR)
    END AS [Caries No Cavitacional],

	CASE 
        WHEN dc.diente < 10 THEN CONCAT('0', dc.diente)
		WHEN dc.diente is null then COALESCE(CAST(dc.DIENTE AS VARCHAR), '00')
        ELSE CAST(dc.diente AS VARCHAR)
    END AS [Caries Cavitacional],

    CASE 
        WHEN ob.obturado < 10 THEN CONCAT('0', ob.obturado)
		WHEN Ob.obturado is null then COALESCE(CAST(dc.DIENTE AS VARCHAR), '00')
        ELSE CAST(ob.obturado AS VARCHAR)
    END AS Obturados, 

	CASE 
        WHEN pe.perdidos < 10 THEN CONCAT('0', pe.perdidos)
		WHEN pe.perdidos is null then COALESCE(CAST(pe.perdidos AS VARCHAR), '00')
        ELSE CAST(pe.perdidos AS VARCHAR)
    END AS Perdidos,
	
	 COALESCE((ds.Sanos), 0) + COALESCE((dc.DIENTE), 0) + COALESCE((dn.diente2), 0)  + COALESCE((ob.obturado ), 0) as [Total Dientes Presentes],

	CONCAT(
        CASE 
            WHEN ds.Sanos < 10 THEN CONCAT('0', ds.Sanos)
            WHEN ds.Sanos IS NULL THEN '00'
            ELSE CAST(ds.Sanos AS VARCHAR)
        END,
        
        CASE 
            WHEN dn.diente2 < 10 THEN CONCAT('0', dn.diente2)
            WHEN dn.diente2 IS NULL THEN '00'
            ELSE CAST(dn.diente2 AS VARCHAR)
        END,
        
        CASE 
            WHEN dc.diente < 10 THEN CONCAT('0', dc.diente)
            WHEN dc.diente IS NULL THEN '00'
            ELSE CAST(dc.diente AS VARCHAR)
        END,
        
        CASE 
            WHEN ob.obturado < 10 THEN CONCAT('0', ob.obturado)
            WHEN ob.obturado IS NULL THEN '00'
            ELSE CAST(ob.obturado AS VARCHAR)
        END ,  
		
    CASE 
            WHEN pe.perdidos < 10 THEN CONCAT('0', pe.perdidos)
            WHEN pe.perdidos IS NULL THEN '00'
            ELSE CAST(pe.perdidos AS VARCHAR)
        END     

    ) AS Resolucion


FROM DBO.ODONTOCONTROL AS C INNER JOIN
	 DBO.ODONTOCONTROLVALO AS CV ON CV.IDODONTOCONTROL=C.ID INNER JOIN
	 dbo.ADINGRESO AS I  ON C.NUMINGRES = I.NUMINGRES INNER JOIN
     dbo.INPACIENT AS P  ON C.IPCODPACI = P.IPCODPACI INNER JOIN
     dbo.INUNIFUNC AS U  ON C.UFUCODIGO = U.UFUCODIGO INNER JOIN
	 dbo.INPROFSAL AS M  ON C.CODPROSAL = M.CODPROSAL LEFT OUTER JOIN
	 dbo.RIASCUPS AS RC  ON RC.ID = C.IDRIASCUPS LEFT OUTER JOIN
	 dbo.RIAS AS RCI  ON RCI.ID = RC.IDRIAS LEFT OUTER JOIN
	 dbo.INCUPSIPS AS PS  ON PS.CODSERIPS=RC.CODSERIPS  left outer join 
	 DBO.adcenaten as caa  on caa.codcenate=C.codcenate left outer join (

-- sanos	
select SUM(Sanos) as Sanos,ID_ODONTOCONTROL
from 
(

Select c.ID AS ID_ODONTOCONTROL, COALESCE(count(d.DIENTE), 0) as 'Sanos'
from DBO.ODONTOCONTROL as c 
inner join dbo.ODONTODIENTE as d with (nolock) on c.ID = d.IDODONTOCONTROL
inner join dbo.ODONTODIENTEDIAG as e with (nolock) on d.ID = e.IDODONTODIENTE
inner join dbo.ODOPARDIA as g with (nolock) on g.CONSECDIA = e.CONSECDIA 
WHERE OBSERVDIA LIKE '%diente sano%' 
GROUP BY c.ID

union all

Select c.ID AS ID_ODONTOCONTROL, COALESCE(count(d.DIENTE), 0) as 'Sanos'
from DBO.ODONTOCONTROL as c 
inner join dbo.ODONTODIENTE as d with (nolock) on c.ID = d.IDODONTOCONTROL
inner join dbo.ODONTODIENTETRATA as e with (nolock) on d.ID = e.IDODONTODIENTE
inner join dbo.ODOPARTRA as g with (nolock) on g.CONSECTRA = e.CONSECTRA
WHERE OBSERVTRA LIKE '%diente sano%'


GROUP BY c.ID
)as a GROUP BY ID_ODONTOCONTROL) as DS ON C.ID = DS.ID_ODONTOCONTROL

left outer join (

-- carie cavitacional

select SUM([caries cavitacional]) as diente,ID_ODONTOCONTROL
from 
(

Select c.ID AS ID_ODONTOCONTROL, COALESCE(count(d.DIENTE), 0) as 'Caries Cavitacional'
from DBO.ODONTOCONTROL as c 
inner join dbo.ODONTODIENTE as d with (nolock) on c.ID = d.IDODONTOCONTROL
inner join dbo.ODONTODIENTEDIAG as e with (nolock) on d.ID = e.IDODONTODIENTE
inner join dbo.ODOPARDIA as g with (nolock) on g.CONSECDIA = e.CONSECDIA 
WHERE OBSERVDIA LIKE '%Caries Cavitacional%' 
GROUP BY c.ID

union all

Select c.ID AS ID_ODONTOCONTROL, COALESCE(count(d.DIENTE), 0) as 'Caries Cavitacional'
from DBO.ODONTOCONTROL as c 
inner join dbo.ODONTODIENTE as d with (nolock) on c.ID = d.IDODONTOCONTROL
inner join dbo.ODONTODIENTETRATA as e with (nolock) on d.ID = e.IDODONTODIENTE
inner join dbo.ODOPARTRA as g with (nolock) on g.CONSECTRA = e.CONSECTRA
WHERE OBSERVTRA LIKE '%Caries Cavitacional%'
GROUP BY c.ID
)as diente 
GROUP BY ID_ODONTOCONTROL) as dc ON C.ID = dc.ID_ODONTOCONTROL

left outer join (

-- carie no cavitacional

select SUM([carie no cavitacional]) as diente2,ID_ODONTOCONTROL
from 
(

Select c.ID AS ID_ODONTOCONTROL, COALESCE(count(d.DIENTE), 0) as 'carie no cavitacional'
from DBO.ODONTOCONTROL as c 
inner join dbo.ODONTODIENTE as d with (nolock) on c.ID = d.IDODONTOCONTROL
inner join dbo.ODONTODIENTEDIAG as e with (nolock) on d.ID = e.IDODONTODIENTE
inner join dbo.ODOPARDIA as g with (nolock) on g.CONSECDIA = e.CONSECDIA 
WHERE OBSERVDIA LIKE '%no cavitacional%' 
GROUP BY c.ID

union all

Select c.ID AS ID_ODONTOCONTROL, COALESCE(count(d.DIENTE), 0) as 'carie no cavitacional'
from DBO.ODONTOCONTROL as c 
inner join dbo.ODONTODIENTE as d with (nolock) on c.ID = d.IDODONTOCONTROL
inner join dbo.ODONTODIENTETRATA as e with (nolock) on d.ID = e.IDODONTODIENTE
inner join dbo.ODOPARTRA as g with (nolock) on g.CONSECTRA = e.CONSECTRA
WHERE OBSERVTRA LIKE '%no cavitacional%'
GROUP BY c.ID
)as diente 
GROUP BY ID_ODONTOCONTROL) as dn ON C.ID = dn.ID_ODONTOCONTROL

left outer join (

-- Obturados

select SUM(Obturado) as obturado,ID_ODONTOCONTROL
from 
(

Select c.ID AS ID_ODONTOCONTROL, COALESCE(count(d.DIENTE), 0) as 'Obturado'
from DBO.ODONTOCONTROL as c 
inner join dbo.ODONTODIENTE as d with (nolock) on c.ID = d.IDODONTOCONTROL
inner join dbo.ODONTODIENTEDIAG as e with (nolock) on d.ID = e.IDODONTODIENTE
inner join dbo.ODOPARDIA as g with (nolock) on g.CONSECDIA = e.CONSECDIA 
WHERE OBSERVDIA LIKE '%Obturado%'
GROUP BY c.ID

union all

Select c.ID AS ID_ODONTOCONTROL, COALESCE(count(d.DIENTE), 0) as 'carie no cavitacional'
from DBO.ODONTOCONTROL as c 
inner join dbo.ODONTODIENTE as d with (nolock) on c.ID = d.IDODONTOCONTROL
inner join dbo.ODONTODIENTETRATA as e with (nolock) on d.ID = e.IDODONTODIENTE
inner join dbo.ODOPARTRA as g with (nolock) on g.CONSECTRA = e.CONSECTRA
WHERE OBSERVTRA LIKE '%Obturado%'
GROUP BY c.ID
)as diente 
GROUP BY ID_ODONTOCONTROL) as ob ON C.ID = ob.ID_ODONTOCONTROL

left outer join (
-- perdidos

select SUM(Perdidos) as perdidos,ID_ODONTOCONTROL
from 
(

Select c.ID AS ID_ODONTOCONTROL, COALESCE(count(d.DIENTE), 0) as 'perdidos'
from DBO.ODONTOCONTROL as c 
inner join dbo.ODONTODIENTE as d with (nolock) on c.ID = d.IDODONTOCONTROL
inner join dbo.ODONTODIENTEDIAG as e with (nolock) on d.ID = e.IDODONTODIENTE
inner join dbo.ODOPARDIA as g with (nolock) on g.CONSECDIA = e.CONSECDIA 
WHERE OBSERVDIA LIKE '%perdido%'
GROUP BY c.ID

union all

Select c.ID AS ID_ODONTOCONTROL, COALESCE(count(d.DIENTE), 0) as 'perdidos'
from DBO.ODONTOCONTROL as c 
inner join dbo.ODONTODIENTE as d with (nolock) on c.ID = d.IDODONTOCONTROL
inner join dbo.ODONTODIENTETRATA as e with (nolock) on d.ID = e.IDODONTODIENTE
inner join dbo.ODOPARTRA as g with (nolock) on g.CONSECTRA = e.CONSECTRA
WHERE OBSERVTRA LIKE '%perdido%'
GROUP BY c.ID
)as diente 
GROUP BY ID_ODONTOCONTROL) as pe ON C.ID = pe.ID_ODONTOCONTROL




	-- DBO.adcenaten as caa  on caa.codcenate=C.codcenate
WHERE (FECHAREG)>='01-01-2025' 
--and c.NUMINGRES = 'C781073342'



