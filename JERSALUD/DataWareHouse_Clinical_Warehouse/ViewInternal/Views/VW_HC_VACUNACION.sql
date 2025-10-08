-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_HC_VACUNACION
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_HC_VACUNACION 
AS

SELECT 
    P.IPCODPACI AS Documento
    , PA.IPNOMCOMP as Nombre
    , P.NUMINGRES as Ingreso
    , C.EDAREGVAC AS EdadAplicación
    , C.TIPVACUNA as TipoVacuna
    , C.NUMDOSISV as NumeroDosis
    , P.FECAPLVAC as FechaAplicación
    , P.OBSVACUNA as Observación
    , CE.NOMCENATE AS CentroAtención, 
case P.MTVNOAPL when 0 then 'Aplicada'
				when 1 then 'No se Administra por una Tradición'
				when 2 then 'No se Administra por una Condición de Salud'
				when 3 then 'No se Administra por Negación del Usuario'
				when 4 then 'No se Administra por tener datos del contacto del usuario no actualizado'
				when 5 then 'No se administra por otras razones'
				end as 'Motivo No Aplica', LOTEDOSIS as Lote_Dosis, LOTEJERINGA as Lote_Jeringa,
P.USUREGISTRA as [Usuario Registra Vacuna], 
case APLICADA 
    when 1 then 'Si' 
    when 0 then 'No' end as Aplicada
, HA.Name AS Entidad
, HC.FECHISPAC AS FechaAtención

FROM [INDIGO031].[dbo].[HCPLANVAC] AS P
INNER JOIN [INDIGO031].[dbo].[INPLANVAC] AS C ON C.IDPLAVACU=P.IDPLAVACU
INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS PA ON PA.IPCODPACI=P.IPCODPACI
INNER JOIN [INDIGO031].[dbo].[ADCENATEN] AS CE ON CE.CODCENATE=P.CODCENATE
LEFT JOIN [INDIGO031].[Contract].[HealthAdministrator] AS HA ON HA.Id=P.GENCONENTITY
LEFT JOIN [INDIGO031].[dbo].[HCHISPACA] AS HC ON HC.NUMINGRES=P.NUMINGRES AND HC.NUMEFOLIO=P.NUMFOLIO