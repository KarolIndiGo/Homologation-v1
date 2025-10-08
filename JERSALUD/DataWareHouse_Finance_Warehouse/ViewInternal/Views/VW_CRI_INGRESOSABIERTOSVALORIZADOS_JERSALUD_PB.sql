-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_CRI_INGRESOSABIERTOSVALORIZADOS_JERSALUD_PB
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_CRI_INGRESOSABIERTOSVALORIZADOS_JERSALUD_PB 
as

SELECT	Sede, Ingreso, [Fecha Alta médica], 
CASE WHEN tp.PersonType = '1' THEN '999' ELSE [Nit Entidad] END AS [Nit Entidad], 
CASE WHEN tp.PersonType = '1' THEN 'PACIENTES PARTICULARES' ELSE v.Entidad END AS Entidad, 
CASE i.TIPOINGRE WHEN 1 THEN 'Ambulatorio' WHEN 2 THEN 'Hospitalario' END TipoIngreso,
CASE WHEN (CONVERT(varchar, [Fecha Alta médica], 105)) IS NULL
            THEN 'Sin Alta' ELSE 'Con Alta' END AS Egreso, [Vr total folio pendiente facturar] AS VrPteFrar, 
			CASE WHEN i.UFUEGRMED IS NOT NULL THEN ufi1.UFUCODIGO WHEN i.UFUEGRMED IS NULL THEN UFI.UFUCODIGO END CodUf,
			CASE WHEN i.UFUEGRMED IS NOT NULL THEN ufi1.UFUDESCRI WHEN i.UFUEGRMED IS NULL THEN UFI.UFUDESCRI END Unidad_Funcional, UFI.UFUDESCRI AS Unidad_Ingreso,
			v.FechaIngreso, [Descripción Grupo Atención]
FROM   [DataWareHouse_Finance].[ViewInternal].[VW_VIE_PENDIENTEFACTURAR_JERSALUD_PB] AS v  
INNER JOIN [INDIGO031].[dbo].[ADINGRESO] AS i  ON i.NUMINGRES = v.Ingreso 
LEFT OUTER JOIN [INDIGO031].[Common].[ThirdParty] AS tp  ON tp.Nit = v.[Nit Entidad]
LEFT OUTER JOIN [INDIGO031].[dbo].[INUNIFUNC] AS UFI  ON UFI.UFUCODIGO = i.UFUCODIGO
LEFT OUTER JOIN [INDIGO031].[dbo].[INUNIFUNC] AS ufi1  ON ufi1.UFUCODIGO = i.UFUEGRMED
WHERE Ingreso <>'0000000000' --and Ingreso='3262968'
GROUP BY Ingreso, Sede,  [Fecha Alta médica], tp.PersonType, tp.PersonType, [Nit Entidad] ,UFI.UFUCODIGO ,
[Vr total folio pendiente facturar] ,  v.Entidad , i.TIPOINGRE , i.UFUEGRMED, ufi1.UFUDESCRI, UFI.UFUDESCRI, UFI.UFUCODIGO , ufi1.UFUCODIGO, v.FechaIngreso, [Descripción Grupo Atención]
