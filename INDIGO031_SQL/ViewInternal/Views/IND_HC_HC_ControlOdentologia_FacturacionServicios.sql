-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_HC_HC_ControlOdentologia_FacturacionServicios
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[IND_HC_HC_ControlOdentologia_FacturacionServicios] as

SELECT  C.ID AS Id, caa.nomcenate as CentroAtención, u.ufudescri as UnidadFuncional, c.ipcodpaci as DocumentoPaciente, P.IPNOMCOMP as Paciente, c.numingres as Ingreso,  CASE i.iestadoin WHEN ' ' THEN 'Abierto' WHEN 'P' THEN 'ParcialmenteFacturado' WHEN 'C' THEN 'NoFacturable' WHEN 'A' THEN 'Anulado' WHEN 'F' THEN 'Facturado' END AS Estado,
YEAR(FECHAREG) - YEAR(P.IPFECNACI) AS Edad, c.numefolio as Folio, m.nommedico as Profesional, c.fechareg as FechaRegistro,
 RCI.NOMBRE AS RIAS, CV.CEO_C as [Indice Cariados CEO],CEO_E as [Indice Extraidos CEO],  CEO_O as [Indice Obturados CEO], CPO_C as [Indice Cariados CPO],
CPO_P as [Indice Perdidos CPO],  CPO_O as [Indice Obturados CPO], CPO_C+CPO_P+CPO_O as [Indice COP], CDT.CODSERIPS AS CodigoProcedimiento, ps.desserips as Procedimiento, CDT.CANTIDAD as Cantidad, 
fac.invoicenumber as Factura, fac.CodUsuario, fac.UsuarioFactura--, tr.*
FROM DBO.ODONTOCONTROL AS C INNER JOIN
	 DBO.ODONTOCONTROLVALO AS CV ON CV.IDODONTOCONTROL=C.ID INNER JOIN
	 dbo.ADINGRESO AS I  ON C.NUMINGRES = I.NUMINGRES INNER JOIN
     dbo.INPACIENT AS P  ON C.IPCODPACI = P.IPCODPACI INNER JOIN
     dbo.INUNIFUNC AS U  ON C.UFUCODIGO = U.UFUCODIGO INNER JOIN
	dbo.INPROFSAL AS M  ON C.CODPROSAL = M.CODPROSAL LEFT OUTER JOIN
	dbo.RIASCUPS AS RC  ON RC.ID = C.IDRIASCUPS LEFT OUTER JOIN
	dbo.RIAS AS RCI  ON RCI.ID = RC.IDRIAS LEFT OUTER JOIN
	
	 DBO.adcenaten as caa  on caa.codcenate=C.codcenate INNER JOIN 
	(select IDODONTOCONTROL, CODSERIPS, SUM(CANTIDAD) AS CANTIDAD
			from  DBO.ODONTODIENTE as CD  INNER JOIN 
				  DBO.ODONTODIENTETRATA as CDT  ON CDT.IDODONTODIENTE=CD.ID
			where tipoodontograma='T' --AND  CD.IDODONTOCONTROL='129917'
			GROUP BY IDODONTOCONTROL, CODSERIPS) AS CDT ON CDT.IDODONTOCONTROL=C.ID  left outer join 
			dbo.INCUPSIPS AS PS  ON PS.CODSERIPS=CDT.CODSERIPS left outer join
	(SELECT s.admissionnumber, s.code as Orden, cu.code as CUPS, f.invoicenumber, f.invoiceduser as CodUsuario, pe.fullname as UsuarioFactura
			FROM Billing.ServiceOrder as s 
			inner join Billing.ServiceOrderDetail as sd  on sd.ServiceOrderId=s.id
			inner join Contract.CUPSEntity as cu  on cu.id= sd.CUPSEntityId
			inner join Billing.InvoiceDetail as fd  on fd.ServiceOrderDetailid=sd.id
			inner join Billing.Invoice as f  on f.id=fd.invoiceid
			inner join  Security.[User] as us  on us.usercode= f.invoiceduser
			inner join  Security.[Person] as pe  on pe.id=us.idperson
			group by  s.admissionnumber, s.code , cu.code , f.invoicenumber, f.invoiceduser, pe.fullname) as fac on fac.admissionnumber=c.numingres and fac.CUPS=cdt.codserips
			--LEFT OUTER JOIN (select IDODONTOCONTROL, codserips AS Codigo, description as CUPS
			--					FROM dbo.ODONTOOTROSTRA as ot 
			--						inner join Contract.CUPSEntity as cups on cups.code=ot.codserips
			--					) AS TR ON TR.IDODONTOCONTROL=C.ID
WHERE (FECHAREG)>='01-01-2022' --and c.ipcodpaci='1150435785'

union all

--OTROS TRATAMIENTOS
SELECT  C.ID AS Id, caa.nomcenate as CentroAtención, u.ufudescri as UnidadFuncional, c.ipcodpaci as DocumentoPaciente, P.IPNOMCOMP as Paciente, c.numingres as Ingreso,  CASE i.iestadoin WHEN ' ' THEN 'Abierto' WHEN 'P' THEN 'ParcialmenteFacturado' WHEN 'C' THEN 'NoFacturable' WHEN 'A' THEN 'Anulado' WHEN 'F' THEN 'Facturado' END AS Estado,
YEAR(FECHAREG) - YEAR(P.IPFECNACI) AS Edad, c.numefolio as Folio, m.nommedico as Profesional, c.fechareg as FechaRegistro,
 RCI.NOMBRE AS RIAS, CV.CEO_C as [Indice Cariados CEO],CEO_E as [Indice Extraidos CEO],  CEO_O as [Indice Obturados CEO], CPO_C as [Indice Cariados CPO],
CPO_P as [Indice Perdidos CPO],  CPO_O as [Indice Obturados CPO], CPO_C+CPO_P+CPO_O as [Indice COP], tr.codigo AS CodigoProcedimiento, tr.cups as Procedimiento, tr.CANTIDAD as Cantidad, 
fac.invoicenumber as Factura, fac.CodUsuario, fac.UsuarioFactura--, tr.*
FROM DBO.ODONTOCONTROL AS C INNER JOIN
	 DBO.ODONTOCONTROLVALO AS CV ON CV.IDODONTOCONTROL=C.ID INNER JOIN
	 dbo.ADINGRESO AS I  ON C.NUMINGRES = I.NUMINGRES INNER JOIN
     dbo.INPACIENT AS P  ON C.IPCODPACI = P.IPCODPACI INNER JOIN
     dbo.INUNIFUNC AS U  ON C.UFUCODIGO = U.UFUCODIGO INNER JOIN
	dbo.INPROFSAL AS M  ON C.CODPROSAL = M.CODPROSAL LEFT OUTER JOIN
	dbo.RIASCUPS AS RC  ON RC.ID = C.IDRIASCUPS LEFT OUTER JOIN
	dbo.RIAS AS RCI  ON RCI.ID = RC.IDRIAS LEFT OUTER JOIN
	
	 DBO.adcenaten as caa  on caa.codcenate=C.codcenate --INNER JOIN 
LEFT OUTER JOIN (select IDODONTOCONTROL, codserips AS Codigo, description as CUPS, ot.cantidad
								FROM dbo.ODONTOOTROSTRA as ot 
									inner join Contract.CUPSEntity as cups on cups.code=ot.codserips
								) AS TR ON TR.IDODONTOCONTROL=C.ID LEFT OUTER JOIN


	--(select IDODONTOCONTROL, CODSERIPS, SUM(CANTIDAD) AS CANTIDAD
	--		from  DBO.ODONTODIENTE as CD  INNER JOIN 
	--			  DBO.ODONTODIENTETRATA as CDT  ON CDT.IDODONTODIENTE=CD.ID
	--		where tipoodontograma='T' --AND  CD.IDODONTOCONTROL='129917'
	--		GROUP BY IDODONTOCONTROL, CODSERIPS) AS CDT ON CDT.IDODONTOCONTROL=C.ID  left outer join 
--			dbo.INCUPSIPS AS PS  ON PS.CODSERIPS=CDT.CODSERIPS left outer join
	(SELECT s.admissionnumber, s.code as Orden, cu.code as CUPS, f.invoicenumber, f.invoiceduser as CodUsuario, pe.fullname as UsuarioFactura
			FROM Billing.ServiceOrder as s 
			inner join Billing.ServiceOrderDetail as sd  on sd.ServiceOrderId=s.id
			inner join Contract.CUPSEntity as cu  on cu.id= sd.CUPSEntityId
			inner join Billing.InvoiceDetail as fd  on fd.ServiceOrderDetailid=sd.id
			inner join Billing.Invoice as f  on f.id=fd.invoiceid
			inner join  Security.[User] as us  on us.usercode= f.invoiceduser
			inner join  Security.[Person] as pe  on pe.id=us.idperson
			group by  s.admissionnumber, s.code , cu.code , f.invoicenumber, f.invoiceduser, pe.fullname) as fac on fac.admissionnumber=c.numingres and fac.CUPS=tr.codigo
			
WHERE (FECHAREG)>='01-01-2022' --and c.ipcodpaci='1150435785'
