-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_HC_HC_CONTROLODENTOLOGIA_FACTURACIONSERVICIOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_HC_HC_CONTROLODENTOLOGIA_FACTURACIONSERVICIOS 
as

SELECT  C.ID AS Id
    , caa.NOMCENATE as CentroAtención
    , U.UFUDESCRI as UnidadFuncional
    , C.IPCODPACI as DocumentoPaciente
    , P.IPNOMCOMP as Paciente
    , C.NUMINGRES as Ingreso
    , CASE I.IESTADOIN
        WHEN ' ' THEN 'Abierto' 
        WHEN 'P' THEN 'ParcialmenteFacturado' 
        WHEN 'C' THEN 'NoFacturable' 
        WHEN 'A' THEN 'Anulado' 
        WHEN 'F' THEN 'Facturado' 
        END AS Estado
    , YEAR(FECHAREG) - YEAR(P.IPFECNACI) AS Edad
    , C.NUMEFOLIO as Folio
    , M.NOMMEDICO as Profesional
    , C.FECHAREG as FechaRegistro
    , RCI.NOMBRE AS RIAS
    , CV.CEO_C as [Indice Cariados CEO]
    , CEO_E as [Indice Extraidos CEO]
    , CEO_O as [Indice Obturados CEO]
    , CPO_C as [Indice Cariados CPO]
    , CPO_P as [Indice Perdidos CPO]
    , CPO_O as [Indice Obturados CPO]
    , CPO_C+CPO_P+CPO_O as [Indice COP]
    , CDT.CODSERIPS AS CodigoProcedimiento
    , PS.DESSERIPS as Procedimiento
    , CDT.CANTIDAD as Cantidad
    , fac.InvoiceNumber as Factura
    , fac.CodUsuario
    , fac.UsuarioFactura

FROM [INDIGO031].[dbo].[ODONTOCONTROL] AS C
INNER JOIN INDIGO031.dbo.ODONTOCONTROLVALO AS CV ON CV.IDODONTOCONTROL=C.ID 
INNER JOIN INDIGO031.dbo.ADINGRESO AS I  ON C.NUMINGRES = I.NUMINGRES 
INNER JOIN INDIGO031.dbo.INPACIENT AS P  ON C.IPCODPACI = P.IPCODPACI 
INNER JOIN INDIGO031.dbo.INUNIFUNC AS U  ON C.UFUCODIGO = U.UFUCODIGO 
INNER JOIN INDIGO031.dbo.INPROFSAL AS M  ON C.CODPROSAL = M.CODPROSAL
LEFT OUTER JOIN INDIGO031.dbo.RIASCUPS AS RC  ON RC.ID = C.IDRIASCUPS
LEFT OUTER JOIN INDIGO031.dbo.RIAS AS RCI  ON RCI.ID = RC.IDRIAS
LEFT OUTER JOIN INDIGO031.dbo.ADCENATEN as caa  on caa.CODCENATE=C.CODCENATE

INNER JOIN (select IDODONTOCONTROL, CODSERIPS, SUM(CANTIDAD) AS CANTIDAD
			from [INDIGO031].[dbo].[ODONTODIENTE] as CD
            INNER JOIN INDIGO031.dbo.ODONTODIENTETRATA as CDT  ON CDT.IDODONTODIENTE=CD.ID
			where TIPOODONTOGRAMA='T' --AND  CD.IDODONTOCONTROL='129917'
			GROUP BY IDODONTOCONTROL, CODSERIPS) AS CDT ON CDT.IDODONTOCONTROL=C.ID

left outer join INDIGO031.dbo.INCUPSIPS AS PS  ON PS.CODSERIPS=CDT.CODSERIPS

left outer join (SELECT s.AdmissionNumber, s.Code as Orden, cu.Code as CUPS, f.InvoiceNumber, f.InvoicedUser as CodUsuario, pe.Fullname as UsuarioFactura
			FROM [INDIGO031].[Billing].[ServiceOrder] as s 
			inner join [INDIGO031].[Billing].[ServiceOrderDetail] as sd  on sd.ServiceOrderId=s.Id
			inner join [INDIGO031].[Contract].[CUPSEntity] as cu  on cu.Id= sd.CUPSEntityId
			inner join [INDIGO031].[Billing].[InvoiceDetail] as fd  on fd.ServiceOrderDetailId=sd.Id
			inner join [INDIGO031].[Billing].[Invoice] as f  on f.Id=fd.InvoiceId
			inner join INDIGO031.Security.[UserInt] as us  on us.UserCode= f.InvoicedUser
			inner join INDIGO031.Security.[PersonInt] as pe  on pe.Id=us.IdPerson
			group by  s.AdmissionNumber, s.Code , cu.Code , f.InvoiceNumber, f.InvoicedUser, pe.Fullname) as fac on fac.AdmissionNumber=C.NUMINGRES and fac.CUPS=CDT.CODSERIPS

WHERE (FECHAREG)>='01-01-2022'

union all

--OTROS TRATAMIENTOS
SELECT  C.ID AS Id
    , caa.NOMCENATE as CentroAtención
    , U.UFUDESCRI as UnidadFuncional
    , C.IPCODPACI as DocumentoPaciente
    , P.IPNOMCOMP as Paciente
    , C.NUMINGRES as Ingreso
    , CASE I.IESTADOIN 
        WHEN ' ' THEN 'Abierto' 
        WHEN 'P' THEN 'ParcialmenteFacturado' 
        WHEN 'C' THEN 'NoFacturable' 
        WHEN 'A' THEN 'Anulado' 
        WHEN 'F' THEN 'Facturado' 
        END AS Estado
    , YEAR(FECHAREG) - YEAR(P.IPFECNACI) AS Edad
    , C.NUMEFOLIO as Folio
    , M.NOMMEDICO as Profesional
    , C.FECHAREG as FechaRegistro
    , RCI.NOMBRE AS RIAS
    , CV.CEO_C as [Indice Cariados CEO]
    , CEO_E as [Indice Extraidos CEO]
    , CEO_O as [Indice Obturados CEO]
    , CPO_C as [Indice Cariados CPO]
    , CPO_P as [Indice Perdidos CPO]
    , CPO_O as [Indice Obturados CPO]
    , CPO_C+CPO_P+CPO_O as [Indice COP]
    , TR.Codigo AS CodigoProcedimiento
    , TR.CUPS as Procedimiento
    , TR.CANTIDAD as Cantidad
    , fac.InvoiceNumber as Factura
    , fac.CodUsuario
    , fac.UsuarioFactura

FROM [INDIGO031].[dbo].[ODONTOCONTROL] AS C
INNER JOIN INDIGO031.dbo.ODONTOCONTROLVALO AS CV ON CV.IDODONTOCONTROL=C.ID 
INNER JOIN INDIGO031.dbo.ADINGRESO AS I  ON C.NUMINGRES = I.NUMINGRES 
INNER JOIN INDIGO031.dbo.INPACIENT AS P  ON C.IPCODPACI = P.IPCODPACI 
INNER JOIN INDIGO031.dbo.INUNIFUNC AS U  ON C.UFUCODIGO = U.UFUCODIGO 
INNER JOIN INDIGO031.dbo.INPROFSAL AS M  ON C.CODPROSAL = M.CODPROSAL 
LEFT OUTER JOIN INDIGO031.dbo.RIASCUPS AS RC  ON RC.ID = C.IDRIASCUPS 
LEFT OUTER JOIN INDIGO031.dbo.RIAS AS RCI  ON RCI.ID = RC.IDRIAS 
LEFT OUTER JOIN INDIGO031.dbo.ADCENATEN as caa  on caa.CODCENATE=C.CODCENATE

LEFT OUTER JOIN (select IDODONTOCONTROL, CODSERIPS AS Codigo, Description as CUPS, ot.CANTIDAD
                FROM [INDIGO031].[dbo].[ODONTOOTROSTRA] as ot 
                inner join [INDIGO031].[Contract].[CUPSEntity] as cups on cups.Code=ot.CODSERIPS
                ) AS TR ON TR.IDODONTOCONTROL=C.ID

LEFT OUTER JOIN (SELECT s.AdmissionNumber, s.Code as Orden, cu.Code as CUPS, f.InvoiceNumber, f.InvoicedUser as CodUsuario, pe.Fullname as UsuarioFactura
                FROM [INDIGO031].[Billing].[ServiceOrder] as s 
                inner join [INDIGO031].[Billing].[ServiceOrderDetail] as sd  on sd.ServiceOrderId=s.Id
                inner join [INDIGO031].[Contract].[CUPSEntity] as cu  on cu.Id= sd.CUPSEntityId
                inner join [INDIGO031].[Billing].[InvoiceDetail] as fd  on fd.ServiceOrderDetailId=sd.Id
                inner join [INDIGO031].[Billing].[Invoice] as f  on f.Id=fd.InvoiceId
                inner join INDIGO031.Security.[UserInt] as us  on us.UserCode= f.InvoicedUser
                inner join INDIGO031.Security.[PersonInt] as pe  on pe.Id=us.IdPerson
                group by  s.AdmissionNumber, s.Code , cu.Code , f.InvoiceNumber, f.InvoicedUser, pe.Fullname) as fac on fac.AdmissionNumber=C.NUMINGRES and fac.CUPS=TR.Codigo
		
WHERE (FECHAREG)>='01-01-2022'
