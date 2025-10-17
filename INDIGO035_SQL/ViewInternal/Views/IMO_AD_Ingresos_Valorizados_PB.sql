-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_AD_Ingresos_Valorizados_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE view  [ViewInternal].[IMO_AD_Ingresos_Valorizados_PB] as

SELECT	Sede, Ingreso, [Fecha Alta médica], 
CASE WHEN tp.persontype = '1' THEN '999' ELSE [Nit Entidad] END AS [Nit Entidad], 
CASE WHEN tp.persontype = '1' THEN 'PACIENTES PARTICULARES' ELSE v.Entidad END AS Entidad, 
--sum ([Vr total folio pendiente facturar]) as [Pte Facturar], 
CASE i.TIPOINGRE WHEN 1 THEN 'Ambulatorio' WHEN 2 THEN 'Hospitalario' END TipoIngreso,
CASE WHEN (CONVERT(varchar, [Fecha Alta médica], 105)) IS NULL
            THEN 'Sin Alta' ELSE 'Con Alta' END AS Egreso, [Vr total folio pendiente facturar] AS VrPteFrar, 
			CASE WHEN i.UFUEGRMED IS NOT NULL THEN ufi1.ufucodigo WHEN i.ufuegrmed IS NULL THEN UFI.ufucodigo END CodUf,
			CASE WHEN i.UFUEGRMED IS NOT NULL THEN ufi1.ufudescri WHEN i.ufuegrmed IS NULL THEN UFI.UFUDESCRI END Unidad_Funcional, UFi.ufuDESCRI AS Unidad_Ingreso,
			v.FechaIngreso, [Descripción Grupo Atención], v.Regimen,  CASE WHEN P.IPSEXOPAC = '1' THEN 'Masculino' WHEN P.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo ,
			 YEAR(i.ifechaing) - YEAR(P.IPFECNACI) AS Edad
FROM  [ViewInternal].[IMO_Billing_AD_Pendiente_facturar] AS v  INNER JOIN
       dbo.adingreso AS i  ON i.numingres = v.Ingreso LEFT OUTER JOIN
	   dbo.inpacient as p on p.ipcodpaci=i.ipcodpaci LEFT OUTER JOIN
       Common.ThirdParty AS tp  ON tp.nit = v.[Nit Entidad] LEFT OUTER JOIN
	   dbo.INUNIFUNC AS UFI  ON UFI.UFUCODIGO = I.UFUCODIGO LEFT OUTER JOIN
           dbo.INUNIFUNC AS ufi1  ON ufi1.UFUCODIGO = i.UFUEGRMED
WHERE i.ipcodpaci not in ('0123456789') --and Ingreso='3262968'
GROUP BY Ingreso, Sede,  [Fecha Alta médica], tp.persontype, tp.persontype, [Nit Entidad] ,UFI.ufucodigo ,
[Vr total folio pendiente facturar] ,  v.Entidad , i.TIPOINGRE , i.UFUEGRMED, ufi1.ufudescri, UFI.UFUDESCRI, UFI.ufucodigo , ufi1.ufucodigo, v.FechaIngreso, [Descripción Grupo Atención], v.regimen,
p.IPSEXOPAC, YEAR(i.ifechaing),YEAR(P.IPFECNACI)
