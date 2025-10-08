-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_AD_INGRESOS_VALORIZADOS_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   VIEW ViewInternal.VW_IMO_AD_INGRESOS_VALORIZADOS_PB
AS

SELECT	Sede, Ingreso, [Fecha Alta médica], 
CASE WHEN tp.PersonType = '1' THEN '999' ELSE [Nit Entidad] END AS [Nit Entidad], 
CASE WHEN tp.PersonType = '1' THEN 'PACIENTES PARTICULARES' ELSE v.Entidad END AS Entidad, 
--sum ([Vr total folio pendiente facturar]) as [Pte Facturar], 
CASE i.TIPOINGRE WHEN 1 THEN 'Ambulatorio' WHEN 2 THEN 'Hospitalario' END TipoIngreso,
CASE WHEN (CONVERT(varchar, [Fecha Alta médica], 105)) IS NULL
            THEN 'Sin Alta' ELSE 'Con Alta' END AS Egreso, [Vr total folio pendiente facturar] AS VrPteFrar, 
			CASE WHEN i.UFUEGRMED IS NOT NULL THEN ufi1.UFUCODIGO WHEN i.UFUEGRMED IS NULL THEN UFI.UFUCODIGO END CodUf,
			CASE WHEN i.UFUEGRMED IS NOT NULL THEN ufi1.UFUDESCRI WHEN i.UFUEGRMED IS NULL THEN UFI.UFUDESCRI END Unidad_Funcional, UFI.UFUDESCRI AS Unidad_Ingreso,
			v.FechaIngreso, [Descripción Grupo Atención], v.Regimen,  CASE WHEN p.IPSEXOPAC = '1' THEN 'Masculino' WHEN p.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo ,
			 YEAR(i.IFECHAING) - YEAR(p.IPFECNACI) AS Edad
FROM  [DataWareHouse_Finance].[ViewInternal].[VW_IMO_BILLING_AD_PENDIENTE_FACTURAR] AS v  INNER JOIN
       [INDIGO035].[dbo].[ADINGRESO] AS i  ON i.NUMINGRES = v.Ingreso LEFT OUTER JOIN
	   [INDIGO035].[dbo].[INPACIENT] as p on p.IPCODPACI=i.IPCODPACI LEFT OUTER JOIN
       [INDIGO035].[Common].[ThirdParty] AS tp  ON tp.Nit = v.[Nit Entidad] LEFT OUTER JOIN
	   [INDIGO035].[dbo].[INUNIFUNC] AS UFI  ON UFI.UFUCODIGO = i.UFUCODIGO LEFT OUTER JOIN
       [INDIGO035].[dbo].[INUNIFUNC] AS ufi1  ON ufi1.UFUCODIGO = i.UFUEGRMED
WHERE i.IPCODPACI not in ('0123456789') --and Ingreso='3262968'
GROUP BY Ingreso, Sede,  [Fecha Alta médica], tp.PersonType, tp.PersonType, [Nit Entidad] ,UFI.UFUCODIGO ,
[Vr total folio pendiente facturar] ,  v.Entidad , i.TIPOINGRE , i.UFUEGRMED, ufi1.UFUDESCRI, UFI.UFUDESCRI, UFI.UFUCODIGO , ufi1.UFUCODIGO, v.FechaIngreso, [Descripción Grupo Atención], v.Regimen,
p.IPSEXOPAC, YEAR(i.IFECHAING),YEAR(p.IPFECNACI)