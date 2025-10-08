-- Workspace: IMO
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 45d58e75-d0a4-4f2b-bd10-65e2dfeda219
-- Schema: ViewInternal
-- Object: VW_IMO_HC_ORDENESMEDICAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IMO_HC_OrdenesMedicas]
AS

SELECT 
  FechaSolicitud AS FechaOrdenamiento, 
  TipoIdentificacionPaciente,
  Documento,
  PrimerNombre, SegundoNombre, 
  PrimerApellido, SegundoApellido,
  Telefonos, Correo, Entidad, Edad,
  DX.CODDIAGNO AS CIE10, DX.NOMDIAGNO AS Diagnostico,
  TipoIdentificacionMedico, DocumentoMedico,
  ProfesionalOrdena, Especialidad,
  CUPS, DescripcionCUPS, 
  CASE WHEN CantidadCUPS = '0' THEN NULL ELSE CantidadCUPS END AS CantidadCUPS,
  CUM, DescripcionCUM,
  CASE WHEN CantidadCUM = '0' THEN NULL ELSE CantidadCUM END AS CantidadCUM,
  Folio, Ingreso, TipoServicio, Sucursal
FROM (
  SELECT DISTINCT
    'Imagenes Diagnosticas' AS TipoServicio,
    CASE 
      WHEN A.CODCENATE = '001' THEN 'Neiva'
      WHEN A.CODCENATE = '002' THEN 'Pitalito'  
    END AS Sucursal, 
    A.IPCODPACI AS Documento, 
    P.IPNOMCOMP AS Nombre,
    A.NUMINGRES AS Ingreso,
    FECORDMED AS FechaSolicitud, 
    RTRIM(pr.NOMMEDICO) AS ProfesionalOrdena,
    RTRIM(B.CODSERIPS) AS CUPS,
    RTRIM(DESSERIPS) AS DescripcionCUPS, 
    CASE ESTSERIPS 
      WHEN 1 THEN 'Solicitado' 
      WHEN 2 THEN 'Realizando Estudio' 
      WHEN 3 THEN 'Pendiente Interpretación'
      WHEN 4 THEN 'Interpretado'
      WHEN 5 THEN 'Estudio Remitido' 
      WHEN 6 THEN 'Anulado' 
      WHEN 7 THEN 'Extramural'  
    END AS Estado,  
    A.NUMEFOLIO AS Folio,
    ag.Name AS Entidad, 
    i.IFECHAING AS FechaIngreso, 
    UF.UFUDESCRI AS UnidadFuncional,  
    CG.Name AS GrupoAtención,
    UB.UBINOMBRE AS Ubicacion,   
    mu.MUNNOMBRE AS Municipio,   
    DEP.nomdepart AS Departamento, 
    OBSSERIPS AS Observacion , 
    '' AS MedicoRealiza,
    DATENAME(weekday, FECORDMED) AS DiaSemana,  
    YEAR(FECORDMED) - YEAR(P.IPFECNACI) AS Edad, 
    CASE WHEN (YEAR(FECORDMED) - YEAR(P.IPFECNACI)) < 18 THEN 'Pediatrico' ELSE 'Adulto' END AS TipoPaciente,
    P.IPPRIAPEL AS PrimerApellido, P.IPSEGAPEL AS SegundoApellido, P.IPPRINOMB AS PrimerNombre, P.IPSEGNOMB AS SegundoNombre,
    CASE
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI IS NOT NULL THEN P.IPTELMOVI
      WHEN P.IPTELMOVI = '' AND P.IPTELEFON IS NOT NULL THEN P.IPTELEFON
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI = '' THEN NULL
      WHEN P.IPTELEFON IS NOT NULL AND P.IPTELMOVI IS NOT NULL THEN CONCAT(P.IPTELEFON,' - ',P.IPTELMOVI) 
    END AS Telefonos,
    P.CORELEPAC AS Correo,
    CASE P.IPTIPODOC WHEN 1 THEN 'CC - Cédula de Ciudadanía' WHEN 2 THEN 'CE - Cédula de Extranjería' WHEN 3 THEN 'TI - Tarjeta de Identidad' WHEN 4 THEN 'RC - Registro Civil' WHEN 5 THEN 'PA - Pasaporte' WHEN 6 THEN 'AS - Adulto Sin Identificación'
      WHEN 7 THEN 'MS - Menor Sin Identificación' WHEN 8 THEN 'NU - Número único de identificación personal' WHEN 9 THEN 'CN - Certificado de Nacido Vivo' WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)' WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
      WHEN 12 THEN 'PE - Permiso especial de Permanencia (Aplica para extranjeros)' WHEN 13 THEN 'PT - Permiso temporal de permanencia' WHEN 14 THEN 'DE - Documento extranjero' WHEN 15 THEN 'SI - Sin identificación' 
    END AS TipoIdentificacionPaciente,
    ID.NOMBRE AS TipoIdentificacionMedico, pr.CODIGONIT AS DocumentoMedico, '' AS CUM, '' AS DescripcionCUM, '' AS CantidadCUM, A.CANSERIPS AS CantidadCUPS, G.DESESPECI AS Especialidad
  FROM [INDIGO035].[dbo].[HCORDIMAG] A 
  INNER JOIN [INDIGO035].[dbo].[INCUPSIPS] B ON A.CODSERIPS = B.CODSERIPS 
  INNER JOIN [INDIGO035].[dbo].[INPACIENT] AS P ON P.IPCODPACI = A.IPCODPACI
  INNER JOIN [INDIGO035].[dbo].[INUNIFUNC] AS UF ON UF.UFUCODIGO = A.UFUCODIGO
  INNER JOIN [INDIGO035].[dbo].[ADINGRESO] AS i ON i.NUMINGRES = A.NUMINGRES
  INNER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS ag ON ag.Id = i.GENCONENTITY
  INNER JOIN [INDIGO035].[dbo].[INPROFSAL] AS pr ON pr.CODPROSAL = A.CODPROSAL
  LEFT OUTER JOIN [INDIGO035].[Contract].[CareGroup] AS CG ON CG.Id = i.GENCAREGROUP
  LEFT OUTER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS HA ON HA.Id = i.GENCONENTITY
  LEFT OUTER JOIN [INDIGO035].[dbo].[INUBICACI] AS UB
  LEFT JOIN [INDIGO035].[dbo].[INMUNICIP] AS mu
  LEFT JOIN [INDIGO035].[dbo].[INDEPARTA] AS DEP ON DEP.depcodigo = mu.DEPCODIGO ON mu.DEPMUNCOD = UB.DEPMUNCOD ON UB.AUUBICACI = P.AUUBICACI
  LEFT JOIN [INDIGO035].[dbo].[ADTIPOIDENTIFICA] AS ID ON ID.ID = pr.IDADTIPOIDENTIFICA
  LEFT JOIN [INDIGO035].[dbo].[HCHISPACA] AS H ON H.NUMINGRES = A.NUMINGRES AND H.NUMEFOLIO = A.NUMEFOLIO 
  LEFT JOIN [INDIGO035].[dbo].[INESPECIA] AS G ON G.CODESPECI = H.CODESPTRA
  WHERE A.FECORDMED >= '01-08-2022' AND ESTSERIPS NOT IN ('6')

  UNION ALL

  SELECT DISTINCT 
    'Laboratorio' AS TipoServicio,
    CASE 
      WHEN A.CODCENATE = '001' THEN 'Neiva'
      WHEN A.CODCENATE = '002' THEN 'Pitalito'  
    END AS Sucursal,
    A.IPCODPACI AS Documento, 
    P.IPNOMCOMP AS Nombre,
    A.NUMINGRES AS Ingreso,
    FECORDMED AS FechaSolicitud, 
    RTRIM(pr.NOMMEDICO) AS ProfesionalOrdena,
    RTRIM(B.CODSERIPS) AS CUPS,
    RTRIM(DESSERIPS) AS DescripcionCUPS, 
    CASE ESTSERIPS 
      WHEN 1 THEN 'Solicitado' 
      WHEN 2 THEN 'Realizando Estudio' 
      WHEN 3 THEN 'Pendiente Interpretación' 
      WHEN 4 THEN 'Interpretado'
      WHEN 5 THEN 'Estudio Remitido' 
      WHEN 6 THEN 'Anulado' 
      WHEN '7' THEN 'Extramural'  
    END AS Estado, 
    A.NUMEFOLIO AS Folio,
    ag.Name AS Entidad, 
    i.IFECHAING AS FechaIngreso, 
    UF.UFUDESCRI AS UnidadFuncional,  
    CG.Name AS GrupoAtención,
    UB.UBINOMBRE AS Ubicacion,  
    mu.MUNNOMBRE AS Municipio,    
    DEP.nomdepart AS Departamento, 
    OBSSERIPS AS Observacion , 
    '' AS MedicoRealiza,
    DATENAME(weekday, FECORDMED) AS DiaSemana,  
    YEAR(FECORDMED) - YEAR(P.IPFECNACI) AS Edad, 
    CASE WHEN (YEAR(FECORDMED) - YEAR(P.IPFECNACI)) < 18 THEN 'Pediatrico' ELSE 'Adulto' END AS TipoPaciente,
    P.IPPRIAPEL AS PrimerApellido, P.IPSEGAPEL AS SegundoApellido, P.IPPRINOMB AS PrimerNombre, P.IPSEGNOMB AS SegundoNombre,
    CASE 
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI IS NOT NULL THEN P.IPTELMOVI
      WHEN P.IPTELMOVI = '' AND P.IPTELEFON IS NOT NULL THEN P.IPTELEFON
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI = '' THEN NULL
      WHEN P.IPTELEFON IS NOT NULL AND P.IPTELMOVI IS NOT NULL THEN CONCAT(P.IPTELEFON,' - ',P.IPTELMOVI) 
    END AS Telefonos,
    P.CORELEPAC AS Correo,
    CASE P.IPTIPODOC WHEN 1 THEN 'CC - Cédula de Ciudadanía' WHEN 2 THEN 'CE - Cédula de Extranjería' WHEN 3 THEN 'TI - Tarjeta de Identidad' WHEN 4 THEN 'RC - Registro Civil' WHEN 5 THEN 'PA - Pasaporte' WHEN 6 THEN 'AS - Adulto Sin Identificación'
      WHEN 7 THEN 'MS - Menor Sin Identificación' WHEN 8 THEN 'NU - Número único de identificación personal' WHEN 9 THEN 'CN - Certificado de Nacido Vivo' WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)' WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
      WHEN 12 THEN 'PE - Permiso especial de Permanencia (Aplica para extranjeros)' WHEN 13 THEN 'PT - Permiso temporal de permanencia' WHEN 14 THEN 'DE - Documento extranjero' WHEN 15 THEN 'SI - Sin identificación' 
    END AS TipoIdentificacionPaciente,
    ID.NOMBRE AS TipoIdentificacionMedico, pr.CODIGONIT AS DocumentoMedico, '' AS CUM, '' AS DescripcionCUM, '' AS CantidadCUM, A.CANSERIPS AS CantidadCUPS, G.DESESPECI AS Especialidad
  FROM [INDIGO035].[dbo].[HCORDLABO] A 
  INNER JOIN [INDIGO035].[dbo].[INCUPSIPS] B ON A.CODSERIPS = B.CODSERIPS 
  INNER JOIN [INDIGO035].[dbo].[INPACIENT] AS P ON P.IPCODPACI = A.IPCODPACI
  INNER JOIN [INDIGO035].[dbo].[INUNIFUNC] AS UF ON UF.UFUCODIGO = A.UFUCODIGO
  INNER JOIN [INDIGO035].[dbo].[ADINGRESO] AS i ON i.NUMINGRES = A.NUMINGRES
  INNER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS ag ON ag.Id = i.GENCONENTITY
  INNER JOIN [INDIGO035].[dbo].[INPROFSAL] AS pr ON pr.CODPROSAL = A.CODPROSAL
  LEFT OUTER JOIN [INDIGO035].[Contract].[CareGroup] AS CG ON CG.Id = i.GENCAREGROUP
  LEFT OUTER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS HA ON HA.Id = i.GENCONENTITY
  LEFT OUTER JOIN [INDIGO035].[dbo].[INUBICACI] AS UB
  LEFT JOIN [INDIGO035].[dbo].[INMUNICIP] AS mu
  LEFT JOIN [INDIGO035].[dbo].[INDEPARTA] AS DEP ON DEP.depcodigo = mu.DEPCODIGO ON mu.DEPMUNCOD = UB.DEPMUNCOD ON UB.AUUBICACI = P.AUUBICACI
  LEFT JOIN [INDIGO035].[dbo].[ADTIPOIDENTIFICA] AS ID ON ID.ID = pr.IDADTIPOIDENTIFICA
  LEFT JOIN [INDIGO035].[dbo].[HCHISPACA] AS H ON H.NUMINGRES = A.NUMINGRES AND H.NUMEFOLIO = A.NUMEFOLIO 
  LEFT JOIN [INDIGO035].[dbo].[INESPECIA] AS G ON G.CODESPECI = H.CODESPTRA
  WHERE A.FECORDMED >= '01-08-2022' AND ESTSERIPS NOT IN ('6')

  UNION ALL

  SELECT DISTINCT 
    'Interconsulta' AS TipoServicio, 
    CASE 
      WHEN A.CODCENATE = '001' THEN 'Neiva'
      WHEN A.CODCENATE = '002' THEN 'Pitalito'  
    END AS Sucursal,
    A.IPCODPACI AS Documento, P.IPNOMCOMP AS Nombre, A.NUMINGRES AS Ingreso, FECORDMED AS FechaSolicitud, RTRIM(pr.NOMMEDICO) AS ProfesionalOrdena,
    RTRIM(B.CODSERIPS) AS CUPS, RTRIM(DESSERIPS) AS DescripcionCUPS, 
    CASE ESTSERIPS WHEN 1 THEN 'Solicitado' WHEN 2 THEN 'Solicitud Enviada' WHEN 3 THEN 'Interconsulta Realizada' WHEN 4 THEN 'Extramural' WHEN 5 THEN 'Anulado' END AS Estado, A.NUMEFOLIO AS Folio,
    ag.Name AS Entidad, i.IFECHAING AS FechaIngreso, UF.UFUDESCRI AS UnidadFuncional, CG.Name AS GrupoAtención,
    UB.UBINOMBRE AS Ubicacion, mu.MUNNOMBRE AS Municipio, DEP.nomdepart AS Departamento, OBSSERIPS AS Observacion, '' AS MedicoRealiza,
    DATENAME(weekday, FECORDMED) AS DiaSemana, YEAR(FECORDMED) - YEAR(P.IPFECNACI) AS Edad, 
    CASE WHEN (YEAR(FECORDMED) - YEAR(P.IPFECNACI)) < 18 THEN 'Pediatrico' ELSE 'Adulto' END AS TipoPaciente,
    P.IPPRIAPEL AS PrimerApellido, P.IPSEGAPEL AS SegundoApellido, P.IPPRINOMB AS PrimerNombre, P.IPSEGNOMB AS SegundoNombre,
    CASE 
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI IS NOT NULL THEN P.IPTELMOVI
      WHEN P.IPTELMOVI = '' AND P.IPTELEFON IS NOT NULL THEN P.IPTELEFON
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI = '' THEN NULL
      WHEN P.IPTELEFON IS NOT NULL AND P.IPTELMOVI IS NOT NULL THEN CONCAT(P.IPTELEFON,' - ',P.IPTELMOVI) 
    END AS Telefonos,
    P.CORELEPAC AS Correo,
    CASE P.IPTIPODOC WHEN 1 THEN 'CC - Cédula de Ciudadanía' WHEN 2 THEN 'CE - Cédula de Extranjería' WHEN 3 THEN 'TI - Tarjeta de Identidad' WHEN 4 THEN 'RC - Registro Civil' WHEN 5 THEN 'PA - Pasaporte' WHEN 6 THEN 'AS - Adulto Sin Identificación'
      WHEN 7 THEN 'MS - Menor Sin Identificación' WHEN 8 THEN 'NU - Número único de identificación personal' WHEN 9 THEN 'CN - Certificado de Nacido Vivo' WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)' WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
      WHEN 12 THEN 'PE - Permiso especial de Permanencia (Aplica para extranjeros)' WHEN 13 THEN 'PT - Permiso temporal de permanencia' WHEN 14 THEN 'DE - Documento extranjero' WHEN 15 THEN 'SI - Sin identificación' 
    END AS TipoIdentificacionPaciente,
    ID.NOMBRE AS TipoIdentificacionMedico, pr.CODIGONIT AS DocumentoMedico, '' AS CUM, '' AS DescripcionCUM, '' AS CantidadCUM, A.CANSERIPS AS CantidadCUPS, G.DESESPECI AS Especialidad
  FROM [INDIGO035].[dbo].[HCORDINTE] A 
  INNER JOIN [INDIGO035].[dbo].[INCUPSIPS] B ON A.CODSERIPS = B.CODSERIPS 
  INNER JOIN [INDIGO035].[dbo].[INPACIENT] AS P ON P.IPCODPACI = A.IPCODPACI
  INNER JOIN [INDIGO035].[dbo].[INUNIFUNC] AS UF ON UF.UFUCODIGO = A.UFUCODIGO
  INNER JOIN [INDIGO035].[dbo].[ADINGRESO] AS i ON i.NUMINGRES = A.NUMINGRES
  INNER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS ag ON ag.Id = i.GENCONENTITY
  INNER JOIN [INDIGO035].[dbo].[INPROFSAL] AS pr ON pr.CODPROSAL = A.CODPROSAL
  LEFT OUTER JOIN [INDIGO035].[Contract].[CareGroup] AS CG ON CG.Id = i.GENCAREGROUP
  LEFT OUTER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS HA ON HA.Id = i.GENCONENTITY
  LEFT OUTER JOIN [INDIGO035].[dbo].[INUBICACI] AS UB
  LEFT JOIN [INDIGO035].[dbo].[INMUNICIP] AS mu
  LEFT JOIN [INDIGO035].[dbo].[INDEPARTA] AS DEP ON DEP.depcodigo = mu.DEPCODIGO ON mu.DEPMUNCOD = UB.DEPMUNCOD ON UB.AUUBICACI = P.AUUBICACI
  LEFT JOIN [INDIGO035].[dbo].[ADTIPOIDENTIFICA] AS ID ON ID.ID = pr.IDADTIPOIDENTIFICA
  LEFT JOIN [INDIGO035].[dbo].[HCHISPACA] AS H ON H.NUMINGRES = A.NUMINGRES AND H.NUMEFOLIO = A.NUMEFOLIO 
  LEFT JOIN [INDIGO035].[dbo].[INESPECIA] AS G ON G.CODESPECI = H.CODESPTRA
  WHERE A.FECORDMED >= '01-08-2022' AND ESTSERIPS NOT IN ('5')

  UNION ALL

  SELECT DISTINCT 
    'Procedimientos No Qx' AS TipoServicio,
    CASE 
      WHEN A.CODCENATE = '001' THEN 'Neiva'
      WHEN A.CODCENATE = '002' THEN 'Pitalito'  
    END AS Sucursal,
    A.IPCODPACI AS Documento, P.IPNOMCOMP AS Nombre, A.NUMINGRES AS Ingreso, FECORDMED AS FechaSolicitud, RTRIM(pr.NOMMEDICO) AS ProfesionalOrdena,
    RTRIM(B.CODSERIPS) AS CUPS, RTRIM(DESSERIPS) AS DescripcionCUPS, 
    CASE ESTSERIPS WHEN 1 THEN 'Solicitado' WHEN 2 THEN 'Completado' WHEN 3 THEN 'Interpretado' WHEN 4 THEN 'Sin Interfaz' WHEN 5 THEN 'Anulado' END AS Estado, A.NUMEFOLIO AS Folio,
    ag.Name AS Entidad, i.IFECHAING AS FechaIngreso, UF.UFUDESCRI AS UnidadFuncional, CG.Name AS GrupoAtención,
    UB.UBINOMBRE AS Ubicacion, mu.MUNNOMBRE AS Municipio, DEP.nomdepart AS Departamento, OBSSERIPS AS Observacion, pr1.NOMMEDICO AS MedicoRealiza,
    DATENAME(weekday, FECORDMED) AS DiaSemana, YEAR(FECORDMED) - YEAR(P.IPFECNACI) AS Edad, 
    CASE WHEN (YEAR(FECORDMED) - YEAR(P.IPFECNACI)) < 18 THEN 'Pediatrico' ELSE 'Adulto' END AS TipoPaciente,
    P.IPPRIAPEL AS PrimerApellido, P.IPSEGAPEL AS SegundoApellido, P.IPPRINOMB AS PrimerNombre, P.IPSEGNOMB AS SegundoNombre,
    CASE 
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI IS NOT NULL THEN P.IPTELMOVI
      WHEN P.IPTELMOVI = '' AND P.IPTELEFON IS NOT NULL THEN P.IPTELEFON
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI = '' THEN NULL
      WHEN P.IPTELEFON IS NOT NULL AND P.IPTELMOVI IS NOT NULL THEN CONCAT(P.IPTELEFON,' - ',P.IPTELMOVI) 
    END AS Telefonos,
    P.CORELEPAC AS Correo,
    CASE P.IPTIPODOC WHEN 1 THEN 'CC - Cédula de Ciudadanía' WHEN 2 THEN 'CE - Cédula de Extranjería' WHEN 3 THEN 'TI - Tarjeta de Identidad' WHEN 4 THEN 'RC - Registro Civil' WHEN 5 THEN 'PA - Pasaporte' WHEN 6 THEN 'AS - Adulto Sin Identificación'
      WHEN 7 THEN 'MS - Menor Sin Identificación' WHEN 8 THEN 'NU - Número único de identificación personal' WHEN 9 THEN 'CN - Certificado de Nacido Vivo' WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)' WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
      WHEN 12 THEN 'PE - Permiso especial de Permanencia (Aplica para extranjeros)' WHEN 13 THEN 'PT - Permiso temporal de permanencia' WHEN 14 THEN 'DE - Documento extranjero' WHEN 15 THEN 'SI - Sin identificación' 
    END AS TipoIdentificacionPaciente,
    ID.NOMBRE AS TipoIdentificacionMedico, pr.CODIGONIT AS DocumentoMedico, '' AS CUM, '' AS DescripcionCUM, '' AS CantidadCUM, A.CANSERIPS AS CantidadCUPS, G.DESESPECI AS Especialidad
  FROM [INDIGO035].[dbo].[HCORDPRON] A 
  INNER JOIN [INDIGO035].[dbo].[INCUPSIPS] B ON A.CODSERIPS = B.CODSERIPS 
  INNER JOIN [INDIGO035].[dbo].[INPACIENT] AS P ON P.IPCODPACI = A.IPCODPACI
  INNER JOIN [INDIGO035].[dbo].[INUNIFUNC] AS UF ON UF.UFUCODIGO = A.UFUCODIGO
  INNER JOIN [INDIGO035].[dbo].[ADINGRESO] AS i ON i.NUMINGRES = A.NUMINGRES
  INNER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS ag ON ag.Id = i.GENCONENTITY
  INNER JOIN [INDIGO035].[dbo].[INPROFSAL] AS pr ON pr.CODPROSAL = A.CODPROSAL
  LEFT OUTER JOIN [INDIGO035].[Contract].[CareGroup] AS CG ON CG.Id = i.GENCAREGROUP
  LEFT OUTER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS HA ON HA.Id = i.GENCONENTITY
  LEFT OUTER JOIN [INDIGO035].[dbo].[INUBICACI] AS UB
  LEFT JOIN [INDIGO035].[dbo].[INMUNICIP] AS mu
  LEFT JOIN [INDIGO035].[dbo].[INDEPARTA] AS DEP ON DEP.depcodigo = mu.DEPCODIGO ON mu.DEPMUNCOD = UB.DEPMUNCOD ON UB.AUUBICACI = P.AUUBICACI
  LEFT JOIN [INDIGO035].[dbo].[ADTIPOIDENTIFICA] AS ID ON ID.ID = pr.IDADTIPOIDENTIFICA
  LEFT OUTER JOIN [INDIGO035].[dbo].[INPROFSAL] AS pr1 ON pr1.CODPROSAL = A.MEDREALI
  LEFT JOIN [INDIGO035].[dbo].[HCHISPACA] AS H ON H.NUMINGRES = A.NUMINGRES AND H.NUMEFOLIO = A.NUMEFOLIO 
  LEFT JOIN [INDIGO035].[dbo].[INESPECIA] AS G ON G.CODESPECI = H.CODESPTRA
  WHERE A.FECORDMED >= '01-08-2022' 

  UNION ALL

  SELECT DISTINCT 
    'Procedimientos Qx' AS TipoServicio, 
    CASE 
      WHEN A.CODCENATE = '001' THEN 'Neiva'
      WHEN A.CODCENATE = '002' THEN 'Pitalito'  
    END AS Sucursal, 
    A.IPCODPACI AS Documento, P.IPNOMCOMP AS Nombre, A.NUMINGRES AS Ingreso, FECORDMED AS FechaSolicitud, RTRIM(pr.NOMMEDICO) AS ProfesionalOrdena,
    RTRIM(B.CODSERIPS) AS CUPS, RTRIM(DESSERIPS) AS DescripcionCUPS, 
    CASE ESTSERIPS WHEN 1 THEN 'Solicitado' WHEN 2 THEN 'Sala Programada' WHEN 3 THEN 'Cancelado' WHEN 4 THEN 'Resultado Revisado' END AS Estado, A.NUMEFOLIO AS Folio,
    ag.Name AS Entidad, i.IFECHAING AS FechaIngreso, UF.UFUDESCRI AS UnidadFuncional, CG.Name AS GrupoAtención,
    UB.UBINOMBRE AS Ubicacion, mu.MUNNOMBRE AS Municipio, DEP.nomdepart AS Departamento, OBSSERIPS AS Observacion, '' AS MedicoRealiza,
    DATENAME(weekday, FECORDMED) AS DiaSemana, YEAR(FECORDMED) - YEAR(P.IPFECNACI) AS Edad, 
    CASE WHEN (YEAR(FECORDMED) - YEAR(P.IPFECNACI)) < 18 THEN 'Pediatrico' ELSE 'Adulto' END AS TipoPaciente,
    P.IPPRIAPEL AS PrimerApellido, P.IPSEGAPEL AS SegundoApellido, P.IPPRINOMB AS PrimerNombre, P.IPSEGNOMB AS SegundoNombre, 
    CASE 
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI IS NOT NULL THEN P.IPTELMOVI
      WHEN P.IPTELMOVI = '' AND P.IPTELEFON IS NOT NULL THEN P.IPTELEFON
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI = '' THEN NULL
      WHEN P.IPTELEFON IS NOT NULL AND P.IPTELMOVI IS NOT NULL THEN CONCAT(P.IPTELEFON,' - ',P.IPTELMOVI) 
    END AS Telefonos,
    P.CORELEPAC AS Correo,
    CASE P.IPTIPODOC WHEN 1 THEN 'CC - Cédula de Ciudadanía' WHEN 2 THEN 'CE - Cédula de Extranjería' WHEN 3 THEN 'TI - Tarjeta de Identidad' WHEN 4 THEN 'RC - Registro Civil' WHEN 5 THEN 'PA - Pasaporte' WHEN 6 THEN 'AS - Adulto Sin Identificación'
      WHEN 7 THEN 'MS - Menor Sin Identificación' WHEN 8 THEN 'NU - Número único de identificación personal' WHEN 9 THEN 'CN - Certificado de Nacido Vivo' WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)' WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
      WHEN 12 THEN 'PE - Permiso especial de Permanencia (Aplica para extranjeros)' WHEN 13 THEN 'PT - Permiso temporal de permanencia' WHEN 14 THEN 'DE - Documento extranjero' WHEN 15 THEN 'SI - Sin identificación' 
    END AS TipoIdentificacionPaciente,
    ID.NOMBRE AS TipoIdentificacionMedico, pr.CODIGONIT AS DocumentoMedico, '' AS CUM, '' AS DescripcionCUM, '' AS CantidadCUM, A.CANSERIPS AS CantidadCUPS, G.DESESPECI AS Especialidad
  FROM [INDIGO035].[dbo].[HCORDPROQ] A 
  INNER JOIN [INDIGO035].[dbo].[INCUPSIPS] B ON A.CODSERIPS = B.CODSERIPS 
  INNER JOIN [INDIGO035].[dbo].[INPACIENT] AS P ON P.IPCODPACI = A.IPCODPACI
  INNER JOIN [INDIGO035].[dbo].[INUNIFUNC] AS UF ON UF.UFUCODIGO = A.UFUCODIGO
  INNER JOIN [INDIGO035].[dbo].[ADINGRESO] AS i ON i.NUMINGRES = A.NUMINGRES
  INNER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS ag ON ag.Id = i.GENCONENTITY
  INNER JOIN [INDIGO035].[dbo].[INPROFSAL] AS pr ON pr.CODPROSAL = A.CODPROSAL
  LEFT OUTER JOIN [INDIGO035].[Contract].[CareGroup] AS CG ON CG.Id = i.GENCAREGROUP
  LEFT OUTER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS HA ON HA.Id = i.GENCONENTITY
  LEFT OUTER JOIN [INDIGO035].[dbo].[INUBICACI] AS UB
  LEFT JOIN [INDIGO035].[dbo].[INMUNICIP] AS mu
  LEFT JOIN [INDIGO035].[dbo].[INDEPARTA] AS DEP ON DEP.depcodigo = mu.DEPCODIGO ON mu.DEPMUNCOD = UB.DEPMUNCOD ON UB.AUUBICACI = P.AUUBICACI
  LEFT JOIN [INDIGO035].[dbo].[ADTIPOIDENTIFICA] AS ID ON ID.ID = pr.IDADTIPOIDENTIFICA
  LEFT JOIN [INDIGO035].[dbo].[HCHISPACA] AS H ON H.NUMINGRES = A.NUMINGRES AND H.NUMEFOLIO = A.NUMEFOLIO 
  LEFT JOIN [INDIGO035].[dbo].[INESPECIA] AS G ON G.CODESPECI = H.CODESPTRA
  WHERE A.FECORDMED >= '01-08-2022' AND ESTSERIPS NOT IN ('3')
          
  UNION ALL

  SELECT DISTINCT 
    'Patologias' AS TipoServicio,
    CASE 
      WHEN A.CODCENATE = '001' THEN 'Neiva'
      WHEN A.CODCENATE = '002' THEN 'Pitalito'  
    END AS Sucursal, 
    A.IPCODPACI AS Documento, P.IPNOMCOMP AS Nombre, A.NUMINGRES AS Ingreso, FECORDMED AS FechaSolicitud, RTRIM(pr.NOMMEDICO) AS ProfesionalOrdena,
    RTRIM(B.CODSERIPS) AS CUPS, RTRIM(DESSERIPS) AS DescripcionCUPS, 
    CASE ESTSERIPS WHEN 1 THEN 'Solicitado' WHEN 2 THEN 'Muestra Recolectada' WHEN 3 THEN 'Resultado Entregado' WHEN 4 THEN 'Examen Interpretado' 
      WHEN 5 THEN 'Estudio Remitido' WHEN 6 THEN 'Anulado' WHEN 7 THEN 'Extramural' 
    END AS Estado, A.NUMEFOLIO AS Folio,
    ag.Name AS Entidad, i.IFECHAING AS FechaIngreso, UF.UFUDESCRI AS UnidadFuncional, CG.Name AS GrupoAtención,
    UB.UBINOMBRE AS Ubicacion, mu.MUNNOMBRE AS Municipio, DEP.nomdepart AS Departamento, OBSSERIPS AS Observacion, '' AS MedicoRealiza,
    DATENAME(weekday, FECORDMED) AS DiaSemana, YEAR(FECORDMED) - YEAR(P.IPFECNACI) AS Edad, 
    CASE WHEN (YEAR(FECORDMED) - YEAR(P.IPFECNACI)) < 18 THEN 'Pediatrico' ELSE 'Adulto' END AS TipoPaciente,
    P.IPPRIAPEL AS PrimerApellido, P.IPSEGAPEL AS SegundoApellido, P.IPPRINOMB AS PrimerNombre, P.IPSEGNOMB AS SegundoNombre,
    CASE  
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI IS NOT NULL THEN P.IPTELMOVI
      WHEN P.IPTELMOVI = '' AND P.IPTELEFON IS NOT NULL THEN P.IPTELEFON
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI = '' THEN NULL
      WHEN P.IPTELEFON IS NOT NULL AND P.IPTELMOVI IS NOT NULL THEN CONCAT(P.IPTELEFON,' - ',P.IPTELMOVI) 
    END AS Telefonos,
    P.CORELEPAC AS Correo,
    CASE P.IPTIPODOC WHEN 1 THEN 'CC - Cédula de Ciudadanía' WHEN 2 THEN 'CE - Cédula de Extranjería' WHEN 3 THEN 'TI - Tarjeta de Identidad' WHEN 4 THEN 'RC - Registro Civil' WHEN 5 THEN 'PA - Pasaporte' WHEN 6 THEN 'AS - Adulto Sin Identificación'
      WHEN 7 THEN 'MS - Menor Sin Identificación' WHEN 8 THEN 'NU - Número único de identificación personal' WHEN 9 THEN 'CN - Certificado de Nacido Vivo' WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)' WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
      WHEN 12 THEN 'PE - Permiso especial de Permanencia (Aplica para extranjeros)' WHEN 13 THEN 'PT - Permiso temporal de permanencia' WHEN 14 THEN 'DE - Documento extranjero' WHEN 15 THEN 'SI - Sin identificación' 
    END AS TipoIdentificacionPaciente,
    ID.NOMBRE AS TipoIdentificacionMedico, pr.CODIGONIT AS DocumentoMedico, '' AS CUM, '' AS DescripcionCUM, '' AS CantidadCUM, A.CANSERIPS AS CantidadCUPS, G.DESESPECI AS Especialidad
  FROM [INDIGO035].[dbo].[HCORDPATO] A 
  INNER JOIN [INDIGO035].[dbo].[INCUPSIPS] B ON A.CODSERIPS = B.CODSERIPS 
  INNER JOIN [INDIGO035].[dbo].[INPACIENT] AS P ON P.IPCODPACI = A.IPCODPACI
  INNER JOIN [INDIGO035].[dbo].[INUNIFUNC] AS UF ON UF.UFUCODIGO = A.UFUCODIGO
  INNER JOIN [INDIGO035].[dbo].[ADINGRESO] AS i ON i.NUMINGRES = A.NUMINGRES
  INNER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS ag ON ag.Id = i.GENCONENTITY
  INNER JOIN [INDIGO035].[dbo].[INPROFSAL] AS pr ON pr.CODPROSAL = A.CODPROSAL
  LEFT OUTER JOIN [INDIGO035].[Contract].[CareGroup] AS CG ON CG.Id = i.GENCAREGROUP
  LEFT OUTER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS HA ON HA.Id = i.GENCONENTITY
  LEFT OUTER JOIN [INDIGO035].[dbo].[INUBICACI] AS UB
  LEFT JOIN [INDIGO035].[dbo].[INMUNICIP] AS mu
  LEFT JOIN [INDIGO035].[dbo].[INDEPARTA] AS DEP ON DEP.depcodigo = mu.DEPCODIGO ON mu.DEPMUNCOD = UB.DEPMUNCOD ON UB.AUUBICACI = P.AUUBICACI
  LEFT JOIN [INDIGO035].[dbo].[ADTIPOIDENTIFICA] AS ID ON ID.ID = pr.IDADTIPOIDENTIFICA
  LEFT OUTER JOIN [INDIGO035].[dbo].[INPROFSAL] AS pr1 ON pr1.CODPROSAL = A.USURECEXA
  LEFT JOIN [INDIGO035].[dbo].[HCHISPACA] AS H ON H.NUMINGRES = A.NUMINGRES AND H.NUMEFOLIO = A.NUMEFOLIO 
  LEFT JOIN [INDIGO035].[dbo].[INESPECIA] AS G ON G.CODESPECI = H.CODESPTRA
  WHERE A.FECORDMED >= '01-08-2022'  
          
  UNION ALL

  SELECT DISTINCT 
    'Medicamentos' AS TipoServicio,
    CASE 
      WHEN A.CODCENATE = '001' THEN 'Neiva'
      WHEN A.CODCENATE = '002' THEN 'Pitalito'  
    END AS Sucursal, 
    A.IPCODPACI AS Documento,
    P.IPNOMCOMP AS Nombre,
    A.NUMINGRES AS Ingreso,
    A.FECINIDOS AS FechaSolicitud,
    RTRIM(pr.NOMMEDICO) AS ProfesionalOrdena,
    '' AS CUPS,
    '' AS DescripcionCUPS,
    CASE PREESTADO
      WHEN '1' THEN 'Iniciado' 
      WHEN '2' THEN 'Ciclo Completado' 
      WHEN '3' THEN 'Tratamiento Descontinuado' 
      WHEN '4' THEN 'Tratamiento Suspendido' 
      WHEN '5' THEN 'Plan de Manejo Externo' 
      WHEN '6' THEN 'Medicamentos Solicitados sin Existencia Actual en el Kardex' 
      WHEN '7' THEN 'Tratamiento Terminado por Salida del Paciente'
    END AS Estado,
    A.NUMEFOLIO AS Folio,
    ag.Name AS Entidad,
    i.IFECHAING AS FechaIngreso, UF.UFUDESCRI AS UnidadFuncional, CG.Name AS GrupoAtención,
    UB.UBINOMBRE AS Ubicacion, mu.MUNNOMBRE AS Municipio, DEP.nomdepart AS Departamento, A.INDAPLMED AS Observacion, '' AS MedicoRealiza,
    DATENAME(weekday, A.FECINIDOS) AS DiaSemana, YEAR(A.FECINIDOS) - YEAR(P.IPFECNACI) AS Edad, 
    CASE WHEN (YEAR(A.FECINIDOS) - YEAR(P.IPFECNACI)) < 18 THEN 'Pediatrico' ELSE 'Adulto' END AS TipoPaciente,
    P.IPPRIAPEL AS PrimerApellido, P.IPSEGAPEL AS SegundoApellido, P.IPPRINOMB AS PrimerNombre, P.IPSEGNOMB AS SegundoNombre,
    CASE 
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI IS NOT NULL THEN P.IPTELMOVI
      WHEN P.IPTELMOVI = '' AND P.IPTELEFON IS NOT NULL THEN P.IPTELEFON
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI = '' THEN NULL
      WHEN P.IPTELEFON IS NOT NULL AND P.IPTELMOVI IS NOT NULL THEN CONCAT(P.IPTELEFON,' - ',P.IPTELMOVI)  
    END AS Telefonos, 
    P.CORELEPAC AS Correo,
    CASE P.IPTIPODOC WHEN 1 THEN 'CC - Cédula de Ciudadanía' WHEN 2 THEN 'CE - Cédula de Extranjería' WHEN 3 THEN 'TI - Tarjeta de Identidad' WHEN 4 THEN 'RC - Registro Civil' WHEN 5 THEN 'PA - Pasaporte' WHEN 6 THEN 'AS - Adulto Sin Identificación'
      WHEN 7 THEN 'MS - Menor Sin Identificación' WHEN 8 THEN 'NU - Número único de identificación personal' WHEN 9 THEN 'CN - Certificado de Nacido Vivo' WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)' WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
      WHEN 12 THEN 'PE - Permiso especial de Permanencia (Aplica para extranjeros)' WHEN 13 THEN 'PT - Permiso temporal de permanencia' WHEN 14 THEN 'DE - Documento extranjero' WHEN 15 THEN 'SI - Sin identificación' 
    END AS TipoIdentificacionPaciente,
    ID.NOMBRE AS TipoIdentificacionMedico, pr.CODIGONIT AS DocumentoMedico, A.CODPRODUC AS CUM, ATC.Name AS DescripcionCUM, A.CANPEDPRO AS CantidadCUM, '' AS CantidadCUPS, G.DESESPECI AS Especialidad
  FROM [INDIGO035].[dbo].[HCPRESCRA] AS A
  INNER JOIN [INDIGO035].[dbo].[IHLISTPRO] AS c ON c.CODPRODUC = A.CODPRODUC
  INNER JOIN [INDIGO035].[dbo].[INPACIENT] AS P ON P.IPCODPACI = A.IPCODPACI
  INNER JOIN [INDIGO035].[dbo].[INPROFSAL] AS pr ON pr.CODPROSAL = A.CODPROSAL
  INNER JOIN [INDIGO035].[dbo].[ADINGRESO] AS i ON i.NUMINGRES = A.NUMINGRES
  INNER JOIN [INDIGO035].[dbo].[INUNIFUNC] AS UF ON UF.UFUCODIGO = A.UFUCODIGO
  LEFT OUTER JOIN [INDIGO035].[Contract].[CareGroup] AS CG ON CG.Id = i.GENCAREGROUP
  INNER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS ag ON ag.Id = i.GENCONENTITY
  LEFT OUTER JOIN [INDIGO035].[dbo].[INUBICACI] AS UB
  LEFT JOIN [INDIGO035].[dbo].[INMUNICIP] AS mu
  LEFT JOIN [INDIGO035].[dbo].[INDEPARTA] AS DEP ON DEP.depcodigo = mu.DEPCODIGO ON mu.DEPMUNCOD = UB.DEPMUNCOD ON UB.AUUBICACI = P.AUUBICACI
  LEFT JOIN [INDIGO035].[dbo].[ADTIPOIDENTIFICA] AS ID ON ID.ID = pr.IDADTIPOIDENTIFICA
  LEFT JOIN [INDIGO035].[Inventory].[ATC] AS ATC ON ATC.Code = A.CODPRODUC
  LEFT JOIN [INDIGO035].[dbo].[HCHISPACA] AS H ON H.NUMINGRES = A.NUMINGRES AND H.NUMEFOLIO = A.NUMEFOLIO 
  LEFT JOIN [INDIGO035].[dbo].[INESPECIA] AS G ON G.CODESPECI = H.CODESPTRA
  WHERE A.CODCENATE IN ('001','00101','00102','00103','00104','00105','002','00201','004','00401','00402','00403','007')
    AND A.FECINIDOS >= '01-08-2022' 

  UNION ALL

  SELECT DISTINCT 
    'Consulta de Control' AS TipoServicio, 
    CASE 
      WHEN A.CODCENATE = '001' THEN 'Neiva'
      WHEN A.CODCENATE = '002' THEN 'Pitalito'  
    END AS Sucursal, 
    A.IPCODPACI AS Documento, P.IPNOMCOMP AS Nombre, A.NUMINGRES AS Ingreso, H.FECHISPAC AS FechaSolicitud, RTRIM(pr.NOMMEDICO) AS ProfesionalOrdena,
    RTRIM(B.CODSERIPS) AS CUPS, RTRIM(DESSERIPS) AS DescripcionCUPS, 
    'Enviado' AS Estado, A.NUMEFOLIO AS Folio,
    ag.Name AS Entidad, i.IFECHAING AS FechaIngreso, UF.UFUDESCRI AS UnidadFuncional, CG.Name AS GrupoAtención,
    UB.UBINOMBRE AS Ubicacion, mu.MUNNOMBRE AS Municipio, DEP.nomdepart AS Departamento, '' AS Observacion, '' AS MedicoRealiza,
    DATENAME(weekday, H.FECHISPAC) AS DiaSemana, YEAR(H.FECHISPAC) - YEAR(P.IPFECNACI) AS Edad, 
    CASE WHEN (YEAR(H.FECHISPAC) - YEAR(P.IPFECNACI)) < 18 THEN 'Pediatrico' ELSE 'Adulto' END AS TipoPaciente,
    P.IPPRIAPEL AS PrimerApellido, P.IPSEGAPEL AS SegundoApellido, P.IPPRINOMB AS PrimerNombre, P.IPSEGNOMB AS SegundoNombre,
    CASE 
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI IS NOT NULL THEN P.IPTELMOVI
      WHEN P.IPTELMOVI = '' AND P.IPTELEFON IS NOT NULL THEN P.IPTELEFON
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI = '' THEN NULL
      WHEN P.IPTELEFON IS NOT NULL AND P.IPTELMOVI IS NOT NULL THEN CONCAT(P.IPTELEFON,' - ',P.IPTELMOVI)  
    END AS Telefonos,
    P.CORELEPAC AS Correo,
    CASE P.IPTIPODOC WHEN 1 THEN 'CC - Cédula de Ciudadanía' WHEN 2 THEN 'CE - Cédula de Extranjería' WHEN 3 THEN 'TI - Tarjeta de Identidad' WHEN 4 THEN 'RC - Registro Civil' WHEN 5 THEN 'PA - Pasaporte' WHEN 6 THEN 'AS - Adulto Sin Identificación'
      WHEN 7 THEN 'MS - Menor Sin Identificación' WHEN 8 THEN 'NU - Número único de identificación personal' WHEN 9 THEN 'CN - Certificado de Nacido Vivo' WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)' WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
      WHEN 12 THEN 'PE - Permiso especial de Permanencia (Aplica para extranjeros)' WHEN 13 THEN 'PT - Permiso temporal de permanencia' WHEN 14 THEN 'DE - Documento extranjero' WHEN 15 THEN 'SI - Sin identificación' 
    END AS TipoIdentificacionPaciente,
    ID.NOMBRE AS TipoIdentificacionMedico, pr.CODIGONIT AS DocumentoMedico, '' AS CUM, '' AS DescripcionCUM, '' AS CantidadCUM, '1' AS CantidadCUPS, G.DESESPECI AS Especialidad
  FROM [INDIGO035].[dbo].[HCDESCOEX] A 
  INNER JOIN [INDIGO035].[dbo].[INCUPSIPS] B ON A.CODSERIPS = B.CODSERIPS 
  INNER JOIN [INDIGO035].[dbo].[INPACIENT] AS P ON P.IPCODPACI = A.IPCODPACI
  INNER JOIN [INDIGO035].[dbo].[INUNIFUNC] AS UF ON UF.UFUCODIGO = A.UFUCODIGO
  INNER JOIN [INDIGO035].[dbo].[ADINGRESO] AS i ON i.NUMINGRES = A.NUMINGRES
  INNER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS ag ON ag.Id = i.GENCONENTITY 
  LEFT JOIN [INDIGO035].[dbo].[HCHISPACA] AS H ON H.NUMINGRES = A.NUMINGRES AND H.NUMEFOLIO = A.NUMEFOLIO 
  INNER JOIN [INDIGO035].[dbo].[INDIAGNOS] AS D ON D.CODDIAGNO = H.CODDIAGNO 
  INNER JOIN [INDIGO035].[dbo].[INPROFSAL] AS pr ON pr.CODPROSAL = H.CODPROSAL
  LEFT OUTER JOIN [INDIGO035].[Contract].[CareGroup] AS CG ON CG.Id = i.GENCAREGROUP
  LEFT OUTER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS HA ON HA.Id = i.GENCONENTITY
  LEFT OUTER JOIN [INDIGO035].[dbo].[INUBICACI] AS UB
  LEFT JOIN [INDIGO035].[dbo].[INMUNICIP] AS mu
  LEFT JOIN [INDIGO035].[dbo].[INDEPARTA] AS DEP ON DEP.depcodigo = mu.DEPCODIGO ON mu.DEPMUNCOD = UB.DEPMUNCOD ON UB.AUUBICACI = P.AUUBICACI
  LEFT JOIN [INDIGO035].[dbo].[ADTIPOIDENTIFICA] AS ID ON ID.ID = pr.IDADTIPOIDENTIFICA
  LEFT JOIN [INDIGO035].[dbo].[INESPECIA] AS G ON G.CODESPECI = H.CODESPTRA
  WHERE H.FECHISPAC >= '01-08-2022'
) AS e 
LEFT OUTER JOIN (
  SELECT NUMINGRES, MAX(ID) AS Id
  FROM [INDIGO035].[dbo].[HCHISPACA]
  GROUP BY NUMINGRES
) AS hcc ON hcc.NUMINGRES = e.Ingreso
LEFT OUTER JOIN [INDIGO035].[dbo].[HCHISPACA] AS hc ON hc.ID = hcc.Id
LEFT OUTER JOIN [INDIGO035].[dbo].[INDIAGNOS] AS DX ON DX.CODDIAGNO = hc.CODDIAGNO
--WHERE e.Ingreso = '6365'
;