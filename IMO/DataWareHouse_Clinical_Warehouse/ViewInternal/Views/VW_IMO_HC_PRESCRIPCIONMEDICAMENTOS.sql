-- Workspace: IMO
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 45d58e75-d0a4-4f2b-bd10-65e2dfeda219
-- Schema: ViewInternal
-- Object: VW_IMO_HC_PRESCRIPCIONMEDICAMENTOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IMO_HC_PrescripcionMedicamentos]
AS

SELECT 
  CC.NOMCENATE AS CentroAtencion,
  A.IPCODPACI AS NumeroDocumento,
  CONCAT(RTRIM(LTRIM(b.IPPRINOMB)), ' ', RTRIM(LTRIM(b.IPSEGNOMB))) AS Nombre_Paciente,
  CONCAT(RTRIM(LTRIM(b.IPPRIAPEL)), ' ', RTRIM(LTRIM(b.IPSEGAPEL))) AS Apellidos_Paciente,
  A.NUMINGRES AS Numero_Ingreso,
  mu.DEPMUNCOD AS CodMunicipio,
  mu.MUNNOMBRE AS Municipio,
  DEP.depcodigo AS CodDpto,
  DEP.nomdepart AS Departamento,
  RTRIM(tp.Nit) AS Nit,
  ea.Name AS Entidad,
  A.CODPRODUC AS Codigo_Producto,
  C.DESPRODUC AS Nombre_Producto,
  A.DOSISPRFN AS Dosis_Medicamento,
  A.DESADMINI AS Administracion,
  G.DESVIAADM AS Via_Administracion,
  A.DURACIDOS AS Duracion,
  A.VALDURFIJ AS DuracionXTiempo_Tratamiento_FIJO,
  CASE A.UNIDURFIJ WHEN 1 THEN 'Minutos' WHEN 2 THEN 'Horas' WHEN 3 THEN 'Dias' END AS Duracion_FIJA,
  A.FRECUENCI AS Duracion_Frecuencia,
  CASE A.UNIFRECUE WHEN 1 THEN 'Minutos' WHEN 2 THEN 'Horas' WHEN 3 THEN 'Dias' END AS [Duracion_Frecuencia Unidad],
  A.INDAPLMED AS Indicaciones,
  CASE A.PREESTADO
    WHEN 1 THEN 'Iniciado'
    WHEN 2 THEN 'Ciclo Completado'
    WHEN 3 THEN 'Tratamiento Descontinuado'
    WHEN 4 THEN 'Tratamiento Suspendido'
    WHEN 5 THEN 'Plan de Manejo Externo'
    WHEN 6 THEN 'Medicamentos Solicitados sin Existencia Actual en el Kardex'
    WHEN 7 THEN 'Tratamiento Terminado por Salida del Paciente'
  END AS Estado_Orden_Medica,
  A.FECINIDOS AS Fecha_Solicitud,
  D.UFUDESCRI AS Unidad_Funcional,
  A.NUMEFOLIO AS FOLIO,
  A.CODDIAGNO AS CIE10,
  DX.NOMDIAGNO AS Diagnostico
FROM [INDIGO035].[dbo].[HCPRESCRA] AS A
INNER JOIN [INDIGO035].[dbo].[IHLISTPRO] AS C ON C.CODPRODUC = A.CODPRODUC
INNER JOIN [INDIGO035].[dbo].[HCVIAADMI] AS G ON G.CODVIAADM = A.CODVIAADM
INNER JOIN [INDIGO035].[dbo].[INPACIENT] AS b ON b.IPCODPACI = A.IPCODPACI
INNER JOIN [INDIGO035].[dbo].[INUNIFUNC] AS D ON D.UFUCODIGO = A.UFUCODIGO
INNER JOIN [INDIGO035].[dbo].[ADCENATEN] AS CC ON CC.CODCENATE = A.CODCENATE
LEFT JOIN [INDIGO035].[dbo].[INUBICACI] AS UB ON UB.AUUBICACI = b.AUUBICACI
LEFT JOIN [INDIGO035].[dbo].[INMUNICIP] AS mu ON mu.DEPMUNCOD = UB.DEPMUNCOD
LEFT JOIN [INDIGO035].[dbo].[INDEPARTA] AS DEP ON DEP.depcodigo = mu.DEPCODIGO
LEFT JOIN [INDIGO035].[dbo].[ADINGRESO] AS I ON I.NUMINGRES = A.NUMINGRES
LEFT JOIN [INDIGO035].[Contract].[HealthAdministrator] AS ea ON ea.Id = I.GENCONENTITY
LEFT JOIN [INDIGO035].[Common].[ThirdParty] AS tp ON tp.Id = ea.ThirdPartyId
LEFT JOIN [INDIGO035].[dbo].[INDIAGNOS] AS DX ON DX.CODDIAGNO = A.CODDIAGNO
WHERE A.FECINIDOS >= '01-01-2025';  -- DATEADD(MONTH, -3, GETDATE())