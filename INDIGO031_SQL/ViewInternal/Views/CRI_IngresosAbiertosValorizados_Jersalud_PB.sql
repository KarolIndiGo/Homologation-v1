-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: CRI_IngresosAbiertosValorizados_Jersalud_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[CRI_IngresosAbiertosValorizados_Jersalud_PB] as


SELECT	Sede, Ingreso, [Fecha Alta médica], 
CASE WHEN tp.persontype = '1' THEN '999' ELSE [Nit Entidad] END AS [Nit Entidad], 
CASE WHEN tp.persontype = '1' THEN 'PACIENTES PARTICULARES' ELSE v.Entidad END AS Entidad, 
--sum ([Vr total folio pendiente facturar]) as [Pte Facturar], 
CASE i.TIPOINGRE WHEN 1 THEN 'Ambulatorio' WHEN 2 THEN 'Hospitalario' END TipoIngreso,
CASE WHEN (CONVERT(varchar, [Fecha Alta médica], 105)) IS NULL
            THEN 'Sin Alta' ELSE 'Con Alta' END AS Egreso, [Vr total folio pendiente facturar] AS VrPteFrar, 
			CASE WHEN i.UFUEGRMED IS NOT NULL THEN ufi1.ufucodigo WHEN i.ufuegrmed IS NULL THEN UFI.ufucodigo END CodUf,
			CASE WHEN i.UFUEGRMED IS NOT NULL THEN ufi1.ufudescri WHEN i.ufuegrmed IS NULL THEN UFI.UFUDESCRI END Unidad_Funcional, UFi.ufuDESCRI AS Unidad_Ingreso,
			v.FechaIngreso, [Descripción Grupo Atención]
FROM   ViewInternal.[VIE_PendienteFacturar_Jersalud_PB] AS v  INNER JOIN
      dbo.adingreso AS i  ON i.numingres = v.Ingreso LEFT OUTER JOIN
       Common.ThirdParty AS tp  ON tp.nit = v.[Nit Entidad] LEFT OUTER JOIN
	  dbo.INUNIFUNC AS UFI  ON UFI.UFUCODIGO = I.UFUCODIGO LEFT OUTER JOIN
       dbo.INUNIFUNC AS ufi1  ON ufi1.UFUCODIGO = i.UFUEGRMED
WHERE Ingreso <>'0000000000' --and Ingreso='3262968'
GROUP BY Ingreso, Sede,  [Fecha Alta médica], tp.persontype, tp.persontype, [Nit Entidad] ,UFI.ufucodigo ,
[Vr total folio pendiente facturar] ,  v.Entidad , i.TIPOINGRE , i.UFUEGRMED, ufi1.ufudescri, UFI.UFUDESCRI, UFI.ufucodigo , ufi1.ufucodigo, v.FechaIngreso, [Descripción Grupo Atención]
