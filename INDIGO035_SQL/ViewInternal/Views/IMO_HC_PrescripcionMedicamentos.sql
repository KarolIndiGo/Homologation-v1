-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_HC_PrescripcionMedicamentos
-- Extracted by Fabric SQL Extractor SPN v3.9.0

create view ViewInternal.IMO_HC_PrescripcionMedicamentos as
SELECT 
CC.NOMCENATE AS CentroAtencion, a.IPCODPACI AS NumeroDocumento, CONCAT(rtrim(ltrim(b.IPPRINOMB)),' ',rtrim(ltrim(b.IPSEGNOMB))) as Nombre_Paciente, CONCAT(rtrim(ltrim(b.IPPRIAPEL)),' ',rtrim(ltrim(b.IPSEGAPEL))) as Apellidos_Paciente,
a.NUMINGRES as Numero_Ingreso,  mu.DEPMUNCOD as CodMunicipio,mu.MUNNOMBRE AS Municipio, DEP.depcodigo AS CodDpto, DEP.nomdepart AS Departamento, RTRIM(tp.nit) as Nit, ea.NAME AS Entidad,
a.CODPRODUC as Codigo_Producto,c.DESPRODUC as Nombre_Producto, a.DOSISPRFN as Dosis_Medicamento,a.DESADMINI as Administracion, g.DESVIAADM as Via_Administracion, 
a.DURACIDOS as Duracion, a.VALDURFIJ as DuracionXTiempo_Tratamiento_FIJO,
CASE A.UNIDURFIJ WHEN 1 THEN 'Minutos' WHEN 2 THEN 'Horas' when 3 then 'Dias' END AS Duracion_FIJA, a.FRECUENCI as Duracion_Frecuencia,
CASE A.UNIFRECUE WHEN 1 THEN 'Minutos' WHEN 2 THEN 'Horas' when 3 then 'Dias' END AS [Duracion_Frecuencia Unidad],
a.INDAPLMED as Indicaciones, CASE A.PREESTADO WHEN 1 THEN 'Iniciado' WHEN 2 THEN 'Ciclo Completado' when 3 then 'Tratamiento Descontinuado'
when 4 then 'Tratamiento Suspendido' when 5 then 'Plan de Manejo Externo' when 6 then 'Medicamentos Solicitados sin Existencia Actual en el Kardex' 
when 7 then 'Tratamiento Terminado por Salida del Paciente' END AS Estado_Orden_Medica,
a.FECINIDOS as Fecha_Solicitud, d.UFUDESCRI AS Unidad_Funcional, a.NUMEFOLIO as FOLIO, A.CODDIAGNO AS CIE10,  DX.NOMDIAGNO AS Diagnostico
FROM DBO.HCPRESCRA AS A WITH (NOLOCK) INNER JOIN
DBO.IHLISTPRO AS C WITH (NOLOCK) ON C.CODPRODUC = A.CODPRODUC INNER JOIN
DBO.HCVIAADMI AS G WITH (NOLOCK) ON G.CODVIAADM = A.CODVIAADM INNER JOIN
DBO.INPACIENT AS b WITH (NOLOCK) ON b.IPCODPACI = a.IPCODPACI INNER JOIN
DBO.INUNIFUNC AS D WITH (NOLOCK) ON D.UFUCODIGO = a.UFUCODIGO INNER JOIN
dbo.ADCENATEN AS CC ON CC.CODCENATE=A.CODCENATE
LEFT JOIN dbo.INUBICACI AS UB WITH (NOLOCK) ON UB.AUUBICACI = B.AUUBICACI
LEFT JOIN dbo.INMUNICIP AS mu WITH (NOLOCK) ON mu.DEPMUNCOD = UB.DEPMUNCOD
LEFT JOIN dbo.INDEPARTA AS DEP WITH (NOLOCK) ON DEP.depcodigo = mu.DEPCODIGO LEFT JOIN
DBO.ADINGRESO AS I WITH (NOLOCK) ON I.NUMINGRES = A.NUMINGRES LEFT JOIN
contract.healthadministrator AS ea WITH (NOLOCK) ON ea.id = i.genconentity left join
common.thirdparty as tp with (nolock) on tp.id=ea.thirdpartyid LEFT JOIN
dbo.INDIAGNOS AS DX WITH (nolock) ON DX.CODDIAGNO = A.CODDIAGNO
where A.FECINIDOS >='01-01-2025'   --DATEADD (MONTH,-3,GETDATE())
