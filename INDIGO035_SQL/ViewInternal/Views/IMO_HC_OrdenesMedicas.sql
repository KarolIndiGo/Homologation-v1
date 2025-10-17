-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_HC_OrdenesMedicas
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW [ViewInternal].[IMO_HC_OrdenesMedicas] as

SELECT 
  e.FechaSolicitud AS FechaOrdenamiento,
  e.TipoIdentificacionPaciente,
  e.Documento,
  e.PrimerNombre, e.SegundoNombre,
  e.PrimerApellido, e.SegundoApellido,
  e.Sexo,
  e.Telefonos, e.Correo, e.Entidad, e.Edad,
  e.Municipio, e.Departamento,

  -- Solo descripción de Tipo de Afiliación (desde IPTIPOAFI)
  CASE TRY_CONVERT(int, NULLIF(LTRIM(RTRIM(e.IPTIPOAFI)), ''))
    WHEN 0 THEN 'No Aplica'
    WHEN 1 THEN 'Cotizante'
    WHEN 2 THEN 'Beneficiario'
    WHEN 3 THEN 'Adicional'
    WHEN 4 THEN 'Jub/Retirado'
    WHEN 5 THEN 'Pensionado'
    ELSE 'No informado'
  END AS TipoAfiliacion,

  DX.CODDIAGNO AS CIE10, 
  DX.NOMDIAGNO AS Diagnostico,
  e.TipoIdentificacionMedico, e.DocumentoMedico,
  e.ProfesionalOrdena, e.Especialidad,
  e.CUPS, e.DescripcionCUPS,
  CASE WHEN e.CantidadCUPS = '0' THEN NULL ELSE e.CantidadCUPS END AS CantidadCUPS,
  e.CUM, e.DescripcionCUM,
  CASE WHEN e.CantidadCUM  = '0' THEN NULL ELSE e.CantidadCUM  END AS CantidadCUM,
  e.Folio, e.Ingreso, e.TipoServicio, e.Sucursal
FROM (
  /* ============================
     IMÁGENES DIAGNÓSTICAS
     ============================ */
  SELECT DISTINCT
    'Imagenes Diagnosticas' AS TipoServicio,
    CASE WHEN A.CODCENATE = '001' THEN 'Neiva'
         WHEN A.CODCENATE = '002' THEN 'Pitalito' END AS Sucursal, 
    A.IPCODPACI AS Documento, 
    P.IPNOMCOMP AS Nombre,
    A.NUMINGRES AS Ingreso,
    A.FECORDMED AS FechaSolicitud, 
    RTRIM(PR.NOMMEDICO) AS ProfesionalOrdena,
    RTRIM(B.CODSERIPS) AS CUPS,
    RTRIM(B.DESSERIPS) AS DescripcionCUPS, 
    CASE A.ESTSERIPS 
      WHEN 1 THEN 'Solicitado' 
      WHEN 2 THEN 'Realizando Estudio' 
      WHEN 3 THEN 'Pendiente Interpretación'
      WHEN 4 THEN 'Interpretado'
      WHEN 5 THEN 'Estudio Remitido' 
      WHEN 6 THEN 'Anulado' 
      WHEN 7 THEN 'Extramural'  
    END AS Estado,  
    A.NUMEFOLIO AS Folio,
    AG.NAME AS Entidad, 
    I.IFECHAING AS FechaIngreso, 
    UF.UFUDESCRI AS UnidadFuncional,  
    u.UBINOMBRE AS Ubicacion,   
    m.MUNNOMBRE AS Municipio,   
    dep.NOMDEPART AS Departamento, 
    A.OBSSERIPS AS Observacion, 
    ''  AS MedicoRealiza,
    DATENAME(WEEKDAY, A.FECORDMED) AS DiaSemana,  
    YEAR(A.FECORDMED) - YEAR(P.IPFECNACI) AS Edad, 
    CASE WHEN (YEAR(A.FECORDMED) - YEAR(P.IPFECNACI)) < 18 THEN 'Pediatrico' ELSE 'Adulto' END AS TipoPaciente,
    P.IPPRIAPEL AS PrimerApellido, P.IPSEGAPEL AS SegundoApellido, P.IPPRINOMB AS PrimerNombre, P.IPSEGNOMB AS SegundoNombre,
    CASE WHEN P.IPSEXOPAC = '1' THEN 'Masculino' WHEN P.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo,
    P.IPTIPOAFI AS IPTIPOAFI, -- código crudo (solo para mapear afuera)
    CASE
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI IS NOT NULL THEN P.IPTELMOVI
      WHEN P.IPTELMOVI = '' AND P.IPTELEFON IS NOT NULL THEN P.IPTELEFON
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI = '' THEN NULL
      WHEN P.IPTELEFON IS NOT NULL AND P.IPTELMOVI IS NOT NULL THEN CONCAT(P.IPTELEFON,' - ',P.IPTELMOVI) 
    END AS Telefonos,
    P.CORELEPAC AS Correo,
    CASE P.IPTIPODOC 
      WHEN  1 THEN 'CC - Cédula de Ciudadanía' 
      WHEN  2 THEN 'CE - Cédula de Extranjería' 
      WHEN  3 THEN 'TI - Tarjeta de Identidad' 
      WHEN  4 THEN 'RC - Registro Civil' 
      WHEN  5 THEN 'PA - Pasaporte' 
      WHEN  6 THEN 'AS - Adulto Sin Identificación'
      WHEN  7 THEN 'MS - Menor Sin Identificación' 
      WHEN  8 THEN 'NU - Número único de identificación personal' 
      WHEN  9 THEN 'CN - Certificado de Nacido Vivo' 
      WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)' 
      WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
      WHEN 12 THEN 'PE - Permiso especial de Permanencia (Aplica para extranjeros)' 
      WHEN 13 THEN 'PT - Permiso temporal de permanencia' 
      WHEN 14 THEN 'DE - Documento extranjero' 
      WHEN 15 THEN 'SI - Sin identificación' 
    END AS TipoIdentificacionPaciente,
    ID.NOMBRE AS TipoIdentificacionMedico, 
    PR.CODIGONIT AS DocumentoMedico, 
    '' AS CUM, '' AS DescripcionCUM, '' AS CantidadCUM, 
    A.CANSERIPS AS CantidadCUPS, 
    G.DESESPECI AS Especialidad
  FROM dbo.HCORDIMAG AS A 
  INNER JOIN dbo.INCUPSIPS AS B  ON A.CODSERIPS = B.CODSERIPS 
  INNER JOIN dbo.INPACIENT  AS P  ON P.IPCODPACI = A.IPCODPACI
  INNER JOIN dbo.INUNIFUNC  AS UF ON UF.UFUCODIGO = A.UFUCODIGO
  INNER JOIN dbo.ADINGRESO  AS I  ON I.NUMINGRES = A.NUMINGRES
  INNER JOIN Contract.HealthAdministrator AS AG ON AG.ID = I.GENCONENTITY
  INNER JOIN dbo.INPROFSAL  AS PR ON PR.CODPROSAL = A.CODPROSAL
  LEFT  JOIN Contract.CAREGROUP AS CG ON CG.ID = I.GENCAREGROUP
  LEFT  JOIN Contract.HealthAdministrator AS HA ON HA.ID = I.GENCONENTITY
  -- ► Ubicación/Municipio/Departamento (INDIGO035)
  LEFT  JOIN INDIGO035.dbo.INUBICACI  AS u   WITH (NOLOCK) ON u.AUUBICACI = P.AUUBICACI
  LEFT  JOIN INDIGO035.dbo.INMUNICIP  AS m   WITH (NOLOCK) ON m.DEPMUNCOD = u.DEPMUNCOD
  LEFT  JOIN INDIGO035.dbo.INDEPARTA  AS dep WITH (NOLOCK) ON m.DEPCODIGO = dep.DEPCODIGO
  LEFT  JOIN dbo.ADTIPOIDENTIFICA AS ID WITH (NOLOCK) ON ID.ID = PR.IDADTIPOIDENTIFICA
  LEFT  JOIN dbo.HCHISPACA AS H ON H.NUMINGRES = A.NUMINGRES AND H.NUMEFOLIO = A.NUMEFOLIO 
  LEFT  JOIN dbo.INESPECIA  AS G WITH (NOLOCK) ON G.CODESPECI = H.CODESPTRA
  WHERE A.FECORDMED >= '2022-08-01' AND A.ESTSERIPS NOT IN (6)

  UNION ALL

  /* ============================
     LABORATORIO
     ============================ */
  SELECT DISTINCT 
    'Laboratorio' AS TipoServicio,
    CASE WHEN A.CODCENATE = '001' THEN 'Neiva'
         WHEN A.CODCENATE = '002' THEN 'Pitalito' END AS Sucursal,
    A.IPCODPACI AS Documento, 
    P.IPNOMCOMP AS Nombre,
    A.NUMINGRES AS Ingreso,
    A.FECORDMED AS FechaSolicitud, 
    RTRIM(PR.NOMMEDICO) AS ProfesionalOrdena,
    RTRIM(B.CODSERIPS) AS CUPS,
    RTRIM(B.DESSERIPS) AS DescripcionCUPS, 
    CASE A.ESTSERIPS 
      WHEN 1 THEN 'Solicitado' 
      WHEN 2 THEN 'Realizando Estudio' 
      WHEN 3 THEN 'Pendiente Interpretación' 
      WHEN 4 THEN 'Interpretado'
      WHEN 5 THEN 'Estudio Remitido' 
      WHEN 6 THEN 'Anulado' 
      WHEN 7 THEN 'Extramural'  
    END AS Estado, 
    A.NUMEFOLIO AS Folio,
    AG.NAME AS Entidad, 
    I.IFECHAING AS FechaIngreso, 
    UF.UFUDESCRI AS UnidadFuncional,  
    u.UBINOMBRE AS Ubicacion,  
    m.MUNNOMBRE AS Municipio,    
    dep.NOMDEPART AS Departamento, 
    A.OBSSERIPS AS Observacion, 
    '' AS MedicoRealiza,
    DATENAME(WEEKDAY, A.FECORDMED) AS DiaSemana,  
    YEAR(A.FECORDMED) - YEAR(P.IPFECNACI) AS Edad, 
    CASE WHEN (YEAR(A.FECORDMED) - YEAR(P.IPFECNACI)) < 18 THEN 'Pediatrico' ELSE 'Adulto' END AS TipoPaciente,
    P.IPPRIAPEL AS PrimerApellido, P.IPSEGAPEL AS SegundoApellido, P.IPPRINOMB AS PrimerNombre, P.IPSEGNOMB AS SegundoNombre,
    CASE WHEN P.IPSEXOPAC = '1' THEN 'Masculino' WHEN P.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo,
    P.IPTIPOAFI AS IPTIPOAFI,
    CASE 
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI IS NOT NULL THEN P.IPTELMOVI
      WHEN P.IPTELMOVI = '' AND P.IPTELEFON IS NOT NULL THEN P.IPTELEFON
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI = '' THEN NULL
      WHEN P.IPTELEFON IS NOT NULL AND P.IPTELMOVI IS NOT NULL THEN CONCAT(P.IPTELEFON,' - ',P.IPTELMOVI) 
    END AS Telefonos,
    P.CORELEPAC AS Correo,
    CASE P.IPTIPODOC 
      WHEN  1 THEN 'CC - Cédula de Ciudadanía' 
      WHEN  2 THEN 'CE - Cédula de Extranjería' 
      WHEN  3 THEN 'TI - Tarjeta de Identidad' 
      WHEN  4 THEN 'RC - Registro Civil' 
      WHEN  5 THEN 'PA - Pasaporte' 
      WHEN  6 THEN 'AS - Adulto Sin Identificación'
      WHEN  7 THEN 'MS - Menor Sin Identificación' 
      WHEN  8 THEN 'NU - Número único de identificación personal' 
      WHEN  9 THEN 'CN - Certificado de Nacido Vivo' 
      WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)' 
      WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
      WHEN 12 THEN 'PE - Permiso especial de Permanencia (Aplica para extranjeros)' 
      WHEN 13 THEN 'PT - Permiso temporal de permanencia' 
      WHEN 14 THEN 'DE - Documento extranjero' 
      WHEN 15 THEN 'SI - Sin identificación' 
    END AS TipoIdentificacionPaciente,
    ID.NOMBRE AS TipoIdentificacionMedico, 
    PR.CODIGONIT AS DocumentoMedico, 
    '' AS CUM, '' AS DescripcionCUM, '' AS CantidadCUM, 
    A.CANSERIPS AS CantidadCUPS, 
    G.DESESPECI AS Especialidad
  FROM dbo.HCORDLABO AS A 
  INNER JOIN dbo.INCUPSIPS AS B  ON A.CODSERIPS = B.CODSERIPS 
  INNER JOIN dbo.INPACIENT  AS P  ON P.IPCODPACI = A.IPCODPACI
  INNER JOIN dbo.INUNIFUNC  AS UF ON UF.UFUCODIGO = A.UFUCODIGO
  INNER JOIN dbo.ADINGRESO  AS I  ON I.NUMINGRES = A.NUMINGRES
  INNER JOIN Contract.HealthAdministrator AS AG ON AG.ID = I.GENCONENTITY
  INNER JOIN dbo.INPROFSAL  AS PR ON PR.CODPROSAL = A.CODPROSAL
  LEFT  JOIN Contract.CAREGROUP AS CG ON CG.ID = I.GENCAREGROUP
  LEFT  JOIN Contract.HealthAdministrator AS HA ON HA.ID = I.GENCONENTITY
  LEFT  JOIN INDIGO035.dbo.INUBICACI  AS u   WITH (NOLOCK) ON u.AUUBICACI = P.AUUBICACI
  LEFT  JOIN INDIGO035.dbo.INMUNICIP  AS m   WITH (NOLOCK) ON m.DEPMUNCOD = u.DEPMUNCOD
  LEFT  JOIN INDIGO035.dbo.INDEPARTA  AS dep WITH (NOLOCK) ON m.DEPCODIGO = dep.DEPCODIGO
  LEFT  JOIN dbo.ADTIPOIDENTIFICA AS ID WITH (NOLOCK) ON ID.ID = PR.IDADTIPOIDENTIFICA
  LEFT  JOIN dbo.HCHISPACA AS H ON H.NUMINGRES = A.NUMINGRES AND H.NUMEFOLIO = A.NUMEFOLIO 
  LEFT  JOIN dbo.INESPECIA  AS G WITH (NOLOCK) ON G.CODESPECI = H.CODESPTRA
  WHERE A.FECORDMED >= '2022-08-01' AND A.ESTSERIPS NOT IN (6)

  UNION ALL

  /* ============================
     INTERCONSULTA
     ============================ */
  SELECT DISTINCT 
    'Interconsulta' AS TipoServicio, 
    CASE WHEN A.CODCENATE = '001' THEN 'Neiva'
         WHEN A.CODCENATE = '002' THEN 'Pitalito' END AS Sucursal,
    A.IPCODPACI AS Documento, 
    P.IPNOMCOMP AS Nombre,
    A.NUMINGRES AS Ingreso,
    A.FECORDMED AS FechaSolicitud,
    RTRIM(PR.NOMMEDICO) AS ProfesionalOrdena,
    RTRIM(B.CODSERIPS) AS CUPS,
    RTRIM(B.DESSERIPS) AS DescripcionCUPS, 
    CASE A.ESTSERIPS 
      WHEN 1 THEN 'Solicitado' 
      WHEN 2 THEN 'Solicitud Enviada' 
      WHEN 3 THEN 'Interconsulta Realizada' 
      WHEN 4 THEN 'Extramural' 
      WHEN 5 THEN 'Anulado' 
    END AS Estado, 
    A.NUMEFOLIO AS Folio,
    AG.NAME AS Entidad, 
    I.IFECHAING AS FechaIngreso, 
    UF.UFUDESCRI AS UnidadFuncional,  
    u.UBINOMBRE AS Ubicacion,   
    m.MUNNOMBRE AS Municipio,    
    dep.NOMDEPART AS Departamento, 
    A.OBSSERIPS AS Observacion, 
    '' AS MedicoRealiza,
    DATENAME(WEEKDAY, A.FECORDMED) AS DiaSemana,  
    YEAR(A.FECORDMED) - YEAR(P.IPFECNACI) AS Edad, 
    CASE WHEN (YEAR(A.FECORDMED) - YEAR(P.IPFECNACI)) < 18 THEN 'Pediatrico' ELSE 'Adulto' END AS TipoPaciente,
    P.IPPRIAPEL AS PrimerApellido, P.IPSEGAPEL AS SegundoApellido, P.IPPRINOMB AS PrimerNombre, P.IPSEGNOMB AS SegundoNombre,
    CASE WHEN P.IPSEXOPAC = '1' THEN 'Masculino' WHEN P.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo,
    P.IPTIPOAFI AS IPTIPOAFI,
    CASE 
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI IS NOT NULL THEN P.IPTELMOVI
      WHEN P.IPTELMOVI = '' AND P.IPTELEFON IS NOT NULL THEN P.IPTELEFON
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI = '' THEN NULL
      WHEN P.IPTELEFON IS NOT NULL AND P.IPTELMOVI IS NOT NULL THEN CONCAT(P.IPTELEFON,' - ',P.IPTELMOVI) 
    END AS Telefonos,
    P.CORELEPAC AS Correo,
    CASE P.IPTIPODOC 
      WHEN  1 THEN 'CC - Cédula de Ciudadanía' 
      WHEN  2 THEN 'CE - Cédula de Extranjería' 
      WHEN  3 THEN 'TI - Tarjeta de Identidad' 
      WHEN  4 THEN 'RC - Registro Civil' 
      WHEN  5 THEN 'PA - Pasaporte' 
      WHEN  6 THEN 'AS - Adulto Sin Identificación'
      WHEN  7 THEN 'MS - Menor Sin Identificación' 
      WHEN  8 THEN 'NU - Número único de identificación personal' 
      WHEN  9 THEN 'CN - Certificado de Nacido Vivo' 
      WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)' 
      WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
      WHEN 12 THEN 'PE - Permiso especial de Permanencia (Aplica para extranjeros)' 
      WHEN 13 THEN 'PT - Permiso temporal de permanencia' 
      WHEN 14 THEN 'DE - Documento extranjero' 
      WHEN 15 THEN 'SI - Sin identificación' 
    END AS TipoIdentificacionPaciente,
    ID.NOMBRE AS TipoIdentificacionMedico, 
    PR.CODIGONIT AS DocumentoMedico, 
    '' AS CUM, '' AS DescripcionCUM, '' AS CantidadCUM, 
    A.CANSERIPS AS CantidadCUPS, 
    G.DESESPECI AS Especialidad
  FROM dbo.HCORDINTE AS A 
  INNER JOIN dbo.INCUPSIPS AS B  ON A.CODSERIPS = B.CODSERIPS 
  INNER JOIN dbo.INPACIENT  AS P  ON P.IPCODPACI = A.IPCODPACI
  INNER JOIN dbo.INUNIFUNC  AS UF ON UF.UFUCODIGO = A.UFUCODIGO
  INNER JOIN dbo.ADINGRESO  AS I  ON I.NUMINGRES = A.NUMINGRES
  INNER JOIN Contract.HealthAdministrator AS AG ON AG.ID = I.GENCONENTITY
  INNER JOIN dbo.INPROFSAL  AS PR ON PR.CODPROSAL = A.CODPROSAL
  LEFT  JOIN Contract.CAREGROUP AS CG ON CG.ID = I.GENCAREGROUP
  LEFT  JOIN Contract.HealthAdministrator AS HA ON HA.ID = I.GENCONENTITY
  LEFT  JOIN INDIGO035.dbo.INUBICACI  AS u   WITH (NOLOCK) ON u.AUUBICACI = P.AUUBICACI
  LEFT  JOIN INDIGO035.dbo.INMUNICIP  AS m   WITH (NOLOCK) ON m.DEPMUNCOD = u.DEPMUNCOD
  LEFT  JOIN INDIGO035.dbo.INDEPARTA  AS dep WITH (NOLOCK) ON m.DEPCODIGO = dep.DEPCODIGO
  LEFT  JOIN dbo.ADTIPOIDENTIFICA AS ID WITH (NOLOCK) ON ID.ID = PR.IDADTIPOIDENTIFICA
  LEFT  JOIN dbo.HCHISPACA AS H ON H.NUMINGRES = A.NUMINGRES AND H.NUMEFOLIO = A.NUMEFOLIO 
  LEFT  JOIN dbo.INESPECIA  AS G WITH (NOLOCK) ON G.CODESPECI = H.CODESPTRA
  WHERE A.FECORDMED >= '2022-08-01' AND A.ESTSERIPS NOT IN (5)

  UNION ALL

  /* ============================
     PROCEDIMIENTOS NO Qx
     ============================ */
  SELECT DISTINCT 
    'Procedimientos No Qx' AS TipoServicio,
    CASE WHEN A.CODCENATE = '001' THEN 'Neiva'
         WHEN A.CODCENATE = '002' THEN 'Pitalito' END AS Sucursal,
    A.IPCODPACI AS Documento, 
    P.IPNOMCOMP AS Nombre,
    A.NUMINGRES AS Ingreso,
    A.FECORDMED AS FechaSolicitud,
    RTRIM(PR.NOMMEDICO) AS ProfesionalOrdena,
    RTRIM(B.CODSERIPS) AS CUPS,
    RTRIM(B.DESSERIPS) AS DescripcionCUPS, 
    CASE A.ESTSERIPS 
      WHEN 1 THEN 'Solicitado' 
      WHEN 2 THEN 'Completado' 
      WHEN 3 THEN 'Interpretado' 
      WHEN 4 THEN 'Sin Interfaz'  
      WHEN 5 THEN 'Anulado' 
    END AS Estado, 
    A.NUMEFOLIO AS Folio,
    AG.NAME AS Entidad, 
    I.IFECHAING AS FechaIngreso, 
    UF.UFUDESCRI AS UnidadFuncional,  
    u.UBINOMBRE AS Ubicacion,   
    m.MUNNOMBRE AS Municipio,    
    dep.NOMDEPART AS Departamento, 
    A.OBSSERIPS AS Observacion, 
    PR1.NOMMEDICO AS MedicoRealiza,
    DATENAME(WEEKDAY, A.FECORDMED) AS DiaSemana,  
    YEAR(A.FECORDMED) - YEAR(P.IPFECNACI) AS Edad, 
    CASE WHEN (YEAR(A.FECORDMED) - YEAR(P.IPFECNACI)) < 18 THEN 'Pediatrico' ELSE 'Adulto' END AS TipoPaciente,
    P.IPPRIAPEL AS PrimerApellido, P.IPSEGAPEL AS SegundoApellido, P.IPPRINOMB AS PrimerNombre, P.IPSEGNOMB AS SegundoNombre,
    CASE WHEN P.IPSEXOPAC = '1' THEN 'Masculino' WHEN P.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo,
    P.IPTIPOAFI AS IPTIPOAFI,
    CASE 
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI IS NOT NULL THEN P.IPTELMOVI
      WHEN P.IPTELMOVI = '' AND P.IPTELEFON IS NOT NULL THEN P.IPTELEFON
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI = '' THEN NULL
      WHEN P.IPTELEFON IS NOT NULL AND P.IPTELMOVI IS NOT NULL THEN CONCAT(P.IPTELEFON,' - ',P.IPTELMOVI) 
    END AS Telefonos,
    P.CORELEPAC AS Correo,
    CASE P.IPTIPODOC 
      WHEN  1 THEN 'CC - Cédula de Ciudadanía' 
      WHEN  2 THEN 'CE - Cédula de Extranjería' 
      WHEN  3 THEN 'TI - Tarjeta de Identidad' 
      WHEN  4 THEN 'RC - Registro Civil' 
      WHEN  5 THEN 'PA - Pasaporte' 
      WHEN  6 THEN 'AS - Adulto Sin Identificación'
      WHEN  7 THEN 'MS - Menor Sin Identificación' 
      WHEN  8 THEN 'NU - Número único de identificación personal' 
      WHEN  9 THEN 'CN - Certificado de Nacido Vivo' 
      WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)' 
      WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
      WHEN 12 THEN 'PE - Permiso especial de Permanencia (Aplica para extranjeros)' 
      WHEN 13 THEN 'PT - Permiso temporal de permanencia' 
      WHEN 14 THEN 'DE - Documento extranjero' 
      WHEN 15 THEN 'SI - Sin identificación' 
    END AS TipoIdentificacionPaciente,
    ID.NOMBRE AS TipoIdentificacionMedico, 
    PR.CODIGONIT AS DocumentoMedico, 
    '' AS CUM, '' AS DescripcionCUM, '' AS CantidadCUM, 
    A.CANSERIPS AS CantidadCUPS, 
    G.DESESPECI AS Especialidad
  FROM dbo.HCORDPRON AS A 
  INNER JOIN dbo.INCUPSIPS AS B  ON A.CODSERIPS = B.CODSERIPS 
  INNER JOIN dbo.INPACIENT  AS P  ON P.IPCODPACI = A.IPCODPACI
  INNER JOIN dbo.INUNIFUNC  AS UF ON UF.UFUCODIGO = A.UFUCODIGO
  INNER JOIN dbo.ADINGRESO  AS I  ON I.NUMINGRES = A.NUMINGRES
  INNER JOIN Contract.HealthAdministrator AS AG ON AG.ID = I.GENCONENTITY
  INNER JOIN dbo.INPROFSAL  AS PR ON PR.CODPROSAL = A.CODPROSAL
  LEFT  JOIN Contract.CAREGROUP AS CG ON CG.ID = I.GENCAREGROUP
  LEFT  JOIN Contract.HealthAdministrator AS HA ON HA.ID = I.GENCONENTITY
  LEFT  JOIN INDIGO035.dbo.INUBICACI  AS u   WITH (NOLOCK) ON u.AUUBICACI = P.AUUBICACI
  LEFT  JOIN INDIGO035.dbo.INMUNICIP  AS m   WITH (NOLOCK) ON m.DEPMUNCOD = u.DEPMUNCOD
  LEFT  JOIN INDIGO035.dbo.INDEPARTA  AS dep WITH (NOLOCK) ON m.DEPCODIGO = dep.DEPCODIGO
  LEFT  JOIN dbo.ADTIPOIDENTIFICA AS ID WITH (NOLOCK) ON ID.ID = PR.IDADTIPOIDENTIFICA
  LEFT  JOIN dbo.INPROFSAL AS PR1 ON PR1.CODPROSAL = A.MEDREALI
  LEFT  JOIN dbo.HCHISPACA AS H ON H.NUMINGRES = A.NUMINGRES AND H.NUMEFOLIO = A.NUMEFOLIO 
  LEFT  JOIN dbo.INESPECIA  AS G WITH (NOLOCK) ON G.CODESPECI = H.CODESPTRA
  WHERE A.FECORDMED >= '2022-08-01'

  UNION ALL

  /* ============================
     PROCEDIMIENTOS Qx
     ============================ */
  SELECT DISTINCT 
    'Procedimientos Qx' AS TipoServicio, 
    CASE WHEN A.CODCENATE = '001' THEN 'Neiva'
         WHEN A.CODCENATE = '002' THEN 'Pitalito' END AS Sucursal, 
    A.IPCODPACI AS Documento, 
    P.IPNOMCOMP AS Nombre,
    A.NUMINGRES AS Ingreso,
    A.FECORDMED AS FechaSolicitud,
    RTRIM(PR.NOMMEDICO) AS ProfesionalOrdena,
    RTRIM(B.CODSERIPS) AS CUPS,
    RTRIM(B.DESSERIPS) AS DescripcionCUPS, 
    CASE A.ESTSERIPS 
      WHEN 1 THEN 'Solicitado' 
      WHEN 2 THEN 'Sala Programada' 
      WHEN 3 THEN 'Cancelado' 
      WHEN 4 THEN 'Resultado Revisado'  
    END AS Estado, 
    A.NUMEFOLIO AS Folio,
    AG.NAME AS Entidad, 
    I.IFECHAING AS FechaIngreso, 
    UF.UFUDESCRI AS UnidadFuncional,  
    u.UBINOMBRE AS Ubicacion,   
    m.MUNNOMBRE AS Municipio,    
    dep.NOMDEPART AS Departamento, 
    A.OBSSERIPS AS Observacion, 
    '' AS MedicoRealiza,
    DATENAME(WEEKDAY, A.FECORDMED) AS DiaSemana,  
    YEAR(A.FECORDMED) - YEAR(P.IPFECNACI) AS Edad, 
    CASE WHEN (YEAR(A.FECORDMED) - YEAR(P.IPFECNACI)) < 18 THEN 'Pediatrico' ELSE 'Adulto' END AS TipoPaciente,
    P.IPPRIAPEL AS PrimerApellido, P.IPSEGAPEL AS SegundoApellido, P.IPPRINOMB AS PrimerNombre, P.IPSEGNOMB AS SegundoNombre, 
    CASE WHEN P.IPSEXOPAC = '1' THEN 'Masculino' WHEN P.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo,
    P.IPTIPOAFI AS IPTIPOAFI,
    CASE 
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI IS NOT NULL THEN P.IPTELMOVI
      WHEN P.IPTELMOVI = '' AND P.IPTELEFON IS NOT NULL THEN P.IPTELEFON
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI = '' THEN NULL
      WHEN P.IPTELEFON IS NOT NULL AND P.IPTELMOVI IS NOT NULL THEN CONCAT(P.IPTELEFON,' - ',P.IPTELMOVI) 
    END AS Telefonos,
    P.CORELEPAC AS Correo,
    CASE P.IPTIPODOC 
      WHEN  1 THEN 'CC - Cédula de Ciudadanía' 
      WHEN  2 THEN 'CE - Cédula de Extranjería' 
      WHEN  3 THEN 'TI - Tarjeta de Identidad' 
      WHEN  4 THEN 'RC - Registro Civil' 
      WHEN  5 THEN 'PA - Pasaporte' 
      WHEN  6 THEN 'AS - Adulto Sin Identificación'
      WHEN  7 THEN 'MS - Menor Sin Identificación' 
      WHEN  8 THEN 'NU - Número único de identificación personal' 
      WHEN  9 THEN 'CN - Certificado de Nacido Vivo' 
      WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)' 
      WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
      WHEN 12 THEN 'PE - Permiso especial de Permanencia (Aplica para extranjeros)' 
      WHEN 13 THEN 'PT - Permiso temporal de permanencia' 
      WHEN 14 THEN 'DE - Documento extranjero' 
      WHEN 15 THEN 'SI - Sin identificación' 
    END AS TipoIdentificacionPaciente,
    ID.NOMBRE AS TipoIdentificacionMedico, 
    PR.CODIGONIT AS DocumentoMedico, 
    '' AS CUM, '' AS DescripcionCUM, '' AS CantidadCUM, 
    A.CANSERIPS AS CantidadCUPS, 
    G.DESESPECI AS Especialidad
  FROM dbo.HCORDPROQ AS A 
  INNER JOIN dbo.INCUPSIPS AS B  ON A.CODSERIPS = B.CODSERIPS 
  INNER JOIN dbo.INPACIENT  AS P  ON P.IPCODPACI = A.IPCODPACI
  INNER JOIN dbo.INUNIFUNC  AS UF ON UF.UFUCODIGO = A.UFUCODIGO
  INNER JOIN dbo.ADINGRESO  AS I  ON I.NUMINGRES = A.NUMINGRES
  INNER JOIN Contract.HealthAdministrator AS AG ON AG.ID = I.GENCONENTITY
  INNER JOIN dbo.INPROFSAL  AS PR ON PR.CODPROSAL = A.CODPROSAL
  LEFT  JOIN Contract.CAREGROUP AS CG ON CG.ID = I.GENCAREGROUP
  LEFT  JOIN Contract.HealthAdministrator AS HA ON HA.ID = I.GENCONENTITY
  LEFT  JOIN INDIGO035.dbo.INUBICACI  AS u   WITH (NOLOCK) ON u.AUUBICACI = P.AUUBICACI
  LEFT  JOIN INDIGO035.dbo.INMUNICIP  AS m   WITH (NOLOCK) ON m.DEPMUNCOD = u.DEPMUNCOD
  LEFT  JOIN INDIGO035.dbo.INDEPARTA  AS dep WITH (NOLOCK) ON m.DEPCODIGO = dep.DEPCODIGO
  LEFT  JOIN dbo.ADTIPOIDENTIFICA AS ID WITH (NOLOCK) ON ID.ID = PR.IDADTIPOIDENTIFICA
  LEFT  JOIN dbo.HCHISPACA AS H ON H.NUMINGRES = A.NUMINGRES AND H.NUMEFOLIO = A.NUMEFOLIO 
  LEFT  JOIN dbo.INESPECIA  AS G WITH (NOLOCK) ON G.CODESPECI = H.CODESPTRA
  WHERE A.FECORDMED >= '2022-08-01' AND A.ESTSERIPS NOT IN (3)

  UNION ALL

  /* ============================
     PATOLOGÍAS
     ============================ */
  SELECT DISTINCT 
    'Patologias' AS TipoServicio,
    CASE WHEN A.CODCENATE = '001' THEN 'Neiva'
         WHEN A.CODCENATE = '002' THEN 'Pitalito' END AS Sucursal, 
    A.IPCODPACI AS Documento, 
    P.IPNOMCOMP AS Nombre,
    A.NUMINGRES AS Ingreso,
    A.FECORDMED AS FechaSolicitud,
    RTRIM(PR.NOMMEDICO) AS ProfesionalOrdena,
    RTRIM(B.CODSERIPS) AS CUPS,
    RTRIM(B.DESSERIPS) AS DescripcionCUPS, 
    CASE A.ESTSERIPS 
      WHEN 1 THEN 'Solicitado' 
      WHEN 2 THEN 'Muestra Recolectada' 
      WHEN 3 THEN 'Resultado Entregado' 
      WHEN 4 THEN 'Examen Interpretado' 
      WHEN 5 THEN 'Estudio Remitido'  
      WHEN 6 THEN 'Anulado'  
      WHEN 7 THEN 'Extramural'  
    END AS Estado, 
    A.NUMEFOLIO AS Folio,
    AG.NAME AS Entidad, 
    I.IFECHAING AS FechaIngreso, 
    UF.UFUDESCRI AS UnidadFuncional,  
    u.UBINOMBRE AS Ubicacion,   
    m.MUNNOMBRE AS Municipio,    
    dep.NOMDEPART AS Departamento, 
    A.OBSSERIPS AS Observacion, 
    '' AS MedicoRealiza,
    DATENAME(WEEKDAY, A.FECORDMED) AS DiaSemana,  
    YEAR(A.FECORDMED) - YEAR(P.IPFECNACI) AS Edad, 
    CASE WHEN (YEAR(A.FECORDMED) - YEAR(P.IPFECNACI)) < 18 THEN 'Pediatrico' ELSE 'Adulto' END AS TipoPaciente,
    P.IPPRIAPEL AS PrimerApellido, P.IPSEGAPEL AS SegundoApellido, P.IPPRINOMB AS PrimerNombre, P.IPSEGNOMB AS SegundoNombre,
    CASE WHEN P.IPSEXOPAC = '1' THEN 'Masculino' WHEN P.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo,
    P.IPTIPOAFI AS IPTIPOAFI,
    CASE  
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI IS NOT NULL THEN P.IPTELMOVI
      WHEN P.IPTELMOVI = '' AND P.IPTELEFON IS NOT NULL THEN P.IPTELEFON
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI = '' THEN NULL
      WHEN P.IPTELEFON IS NOT NULL AND P.IPTELMOVI IS NOT NULL THEN CONCAT(P.IPTELEFON,' - ',P.IPTELMOVI) 
    END AS Telefonos,
    P.CORELEPAC AS Correo,
    CASE P.IPTIPODOC 
      WHEN  1 THEN 'CC - Cédula de Ciudadanía' 
      WHEN  2 THEN 'CE - Cédula de Extranjería' 
      WHEN  3 THEN 'TI - Tarjeta de Identidad' 
      WHEN  4 THEN 'RC - Registro Civil' 
      WHEN  5 THEN 'PA - Pasaporte' 
      WHEN  6 THEN 'AS - Adulto Sin Identificación'
      WHEN  7 THEN 'MS - Menor Sin Identificación' 
      WHEN  8 THEN 'NU - Número único de identificación personal' 
      WHEN  9 THEN 'CN - Certificado de Nacido Vivo' 
      WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)' 
      WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
      WHEN 12 THEN 'PE - Permiso especial de Permanencia (Aplica para extranjeros)' 
      WHEN 13 THEN 'PT - Permiso temporal de permanencia' 
      WHEN 14 THEN 'DE - Documento extranjero' 
      WHEN 15 THEN 'SI - Sin identificación' 
    END AS TipoIdentificacionPaciente,
    ID.NOMBRE AS TipoIdentificacionMedico, 
    PR.CODIGONIT AS DocumentoMedico, 
    '' AS CUM, '' AS DescripcionCUM, '' AS CantidadCUM, 
    A.CANSERIPS AS CantidadCUPS, 
    G.DESESPECI AS Especialidad
  FROM dbo.HCORDPATO AS A 
  INNER JOIN dbo.INCUPSIPS AS B  ON A.CODSERIPS = B.CODSERIPS 
  INNER JOIN dbo.INPACIENT  AS P  ON P.IPCODPACI = A.IPCODPACI
  INNER JOIN dbo.INUNIFUNC  AS UF ON UF.UFUCODIGO = A.UFUCODIGO
  INNER JOIN dbo.ADINGRESO  AS I  ON I.NUMINGRES = A.NUMINGRES
  INNER JOIN Contract.HealthAdministrator AS AG ON AG.ID = I.GENCONENTITY
  INNER JOIN dbo.INPROFSAL  AS PR ON PR.CODPROSAL = A.CODPROSAL
  LEFT  JOIN Contract.CAREGROUP AS CG ON CG.ID = I.GENCAREGROUP
  LEFT  JOIN Contract.HealthAdministrator AS HA ON HA.ID = I.GENCONENTITY
  LEFT  JOIN INDIGO035.dbo.INUBICACI  AS u   WITH (NOLOCK) ON u.AUUBICACI = P.AUUBICACI
  LEFT  JOIN INDIGO035.dbo.INMUNICIP  AS m   WITH (NOLOCK) ON m.DEPMUNCOD = u.DEPMUNCOD
  LEFT  JOIN INDIGO035.dbo.INDEPARTA  AS dep WITH (NOLOCK) ON m.DEPCODIGO = dep.DEPCODIGO
  LEFT  JOIN dbo.ADTIPOIDENTIFICA AS ID WITH (NOLOCK) ON ID.ID = PR.IDADTIPOIDENTIFICA
  LEFT  JOIN dbo.INPROFSAL AS PR1 ON PR1.CODPROSAL = A.USURECEXA
  LEFT  JOIN dbo.HCHISPACA AS H ON H.NUMINGRES = A.NUMINGRES AND H.NUMEFOLIO = A.NUMEFOLIO 
  LEFT  JOIN dbo.INESPECIA  AS G WITH (NOLOCK) ON G.CODESPECI = H.CODESPTRA
  WHERE A.FECORDMED >= '2022-08-01'

  UNION ALL

  /* ============================
     MEDICAMENTOS
     ============================ */
  SELECT DISTINCT 
    'Medicamentos' AS TipoServicio,
    CASE WHEN A.CODCENATE = '001' THEN 'Neiva'
         WHEN A.CODCENATE = '002' THEN 'Pitalito' END AS Sucursal, 
    A.IPCODPACI AS Documento,
    P.IPNOMCOMP AS Nombre,
    A.NUMINGRES AS Ingreso,
    A.FECINIDOS AS FechaSolicitud,
    RTRIM(PR.NOMMEDICO) AS ProfesionalOrdena,
    '' AS CUPS,
    '' AS DescripcionCUPS,
    CASE A.PREESTADO
      WHEN '1' THEN 'Iniciado' 
      WHEN '2' THEN 'Ciclo Completado' 
      WHEN '3' THEN 'Tratamiento Descontinuado' 
      WHEN '4' THEN 'Tratamiento Suspendido' 
      WHEN '5' THEN 'Plan de Manejo Externo' 
      WHEN '6' THEN 'Medicamentos Solicitados sin Existencia Actual en el Kardex' 
      WHEN '7' THEN 'Tratamiento Terminado por Salida del Paciente'
    END AS Estado,
    A.NUMEFOLIO AS Folio,
    AG.NAME AS Entidad,
    I.IFECHAING AS FechaIngreso, 
    UF.UFUDESCRI AS UnidadFuncional,  
    u.UBINOMBRE AS Ubicacion,   
    m.MUNNOMBRE AS Municipio,    
    dep.NOMDEPART AS Departamento,  
    A.INDAPLMED AS Observacion,
    '' AS MedicoRealiza,
    DATENAME(WEEKDAY, A.FECINIDOS) AS DiaSemana,  
    YEAR(A.FECINIDOS) - YEAR(P.IPFECNACI) AS Edad, 
    CASE WHEN (YEAR(A.FECINIDOS) - YEAR(P.IPFECNACI)) < 18 THEN 'Pediatrico' ELSE 'Adulto' END AS TipoPaciente,
    P.IPPRIAPEL AS PrimerApellido, P.IPSEGAPEL AS SegundoApellido, P.IPPRINOMB AS PrimerNombre, P.IPSEGNOMB AS SegundoNombre,
    CASE WHEN P.IPSEXOPAC = '1' THEN 'Masculino' WHEN P.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo,
    P.IPTIPOAFI AS IPTIPOAFI,
    CASE 
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI IS NOT NULL THEN P.IPTELMOVI
      WHEN P.IPTELMOVI = '' AND P.IPTELEFON IS NOT NULL THEN P.IPTELEFON
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI = '' THEN NULL
      WHEN P.IPTELEFON IS NOT NULL AND P.IPTELMOVI IS NOT NULL THEN CONCAT(P.IPTELEFON,' - ',P.IPTELMOVI)  
    END AS Telefonos, 
    P.CORELEPAC AS Correo,
    CASE P.IPTIPODOC 
      WHEN  1 THEN 'CC - Cédula de Ciudadanía' 
      WHEN  2 THEN 'CE - Cédula de Extranjería' 
      WHEN  3 THEN 'TI - Tarjeta de Identidad' 
      WHEN  4 THEN 'RC - Registro Civil' 
      WHEN  5 THEN 'PA - Pasaporte' 
      WHEN  6 THEN 'AS - Adulto Sin Identificación'
      WHEN  7 THEN 'MS - Menor Sin Identificación' 
      WHEN  8 THEN 'NU - Número único de identificación personal' 
      WHEN  9 THEN 'CN - Certificado de Nacido Vivo' 
      WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)' 
      WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
      WHEN 12 THEN 'PE - Permiso especial de Permanencia (Aplica para extranjeros)' 
      WHEN 13 THEN 'PT - Permiso temporal de permanencia' 
      WHEN 14 THEN 'DE - Documento extranjero' 
      WHEN 15 THEN 'SI - Sin identificación' 
    END AS TipoIdentificacionPaciente,
    ID.NOMBRE AS TipoIdentificacionMedico, 
    PR.CODIGONIT AS DocumentoMedico, 
    A.CODPRODUC AS CUM, 
    ATC.NAME    AS DescripcionCUM, 
    A.CANPEDPRO AS CantidadCUM, 
    '' AS CantidadCUPS, 
    G.DESESPECI AS Especialidad
  FROM dbo.HCPRESCRA AS A WITH (NOLOCK)
  INNER JOIN dbo.IHLISTPRO AS C WITH (NOLOCK) ON C.CODPRODUC = A.CODPRODUC
  INNER JOIN dbo.INPACIENT  AS P  ON P.IPCODPACI = A.IPCODPACI
  INNER JOIN dbo.INPROFSAL  AS PR ON PR.CODPROSAL = A.CODPROSAL
  INNER JOIN dbo.ADINGRESO  AS I  ON I.NUMINGRES = A.NUMINGRES
  INNER JOIN dbo.INUNIFUNC  AS UF ON UF.UFUCODIGO = A.UFUCODIGO
  LEFT  JOIN Contract.CAREGROUP AS CG ON CG.ID = I.GENCAREGROUP
  INNER JOIN Contract.HealthAdministrator AS AG ON AG.ID = I.GENCONENTITY
  LEFT  JOIN INDIGO035.dbo.INUBICACI  AS u   WITH (NOLOCK) ON u.AUUBICACI = P.AUUBICACI
  LEFT  JOIN INDIGO035.dbo.INMUNICIP  AS m   WITH (NOLOCK) ON m.DEPMUNCOD = u.DEPMUNCOD
  LEFT  JOIN INDIGO035.dbo.INDEPARTA  AS dep WITH (NOLOCK) ON m.DEPCODIGO = dep.DEPCODIGO
  LEFT  JOIN dbo.ADTIPOIDENTIFICA AS ID WITH (NOLOCK) ON ID.ID = PR.IDADTIPOIDENTIFICA
  LEFT  JOIN Inventory.ATC AS ATC WITH (NOLOCK) ON ATC.CODE = A.CODPRODUC
  LEFT  JOIN dbo.HCHISPACA AS H ON H.NUMINGRES = A.NUMINGRES AND H.NUMEFOLIO = A.NUMEFOLIO 
  LEFT  JOIN dbo.INESPECIA  AS G WITH (NOLOCK) ON G.CODESPECI = H.CODESPTRA
  WHERE A.CODCENATE IN ('001','00101','00035','00103','00104','00105','002','00201','004','00401','00402','00403','007')
    AND A.FECINIDOS >= '2022-08-01'

  UNION ALL

  /* ============================
     CONSULTA DE CONTROL
     ============================ */
  SELECT DISTINCT 
    'Consulta de Control' AS TipoServicio, 
    CASE WHEN A.CODCENATE = '001' THEN 'Neiva'
         WHEN A.CODCENATE = '002' THEN 'Pitalito' END AS Sucursal, 
    A.IPCODPACI AS Documento, 
    P.IPNOMCOMP AS Nombre,
    A.NUMINGRES AS Ingreso,
    H.FECHISPAC AS FechaSolicitud,
    RTRIM(PR.NOMMEDICO) AS ProfesionalOrdena,
    RTRIM(B.CODSERIPS) AS CUPS,
    RTRIM(B.DESSERIPS) AS DescripcionCUPS, 
    'Enviado' AS Estado, 
    A.NUMEFOLIO AS Folio,
    AG.NAME AS Entidad, 
    I.IFECHAING AS FechaIngreso, 
    UF.UFUDESCRI AS UnidadFuncional,  
    u.UBINOMBRE AS Ubicacion,   
    m.MUNNOMBRE AS Municipio,    
    dep.NOMDEPART AS Departamento, 
    '' AS Observacion, 
    '' AS MedicoRealiza,
    DATENAME(WEEKDAY, H.FECHISPAC) AS DiaSemana,  
    YEAR(H.FECHISPAC) - YEAR(P.IPFECNACI) AS Edad, 
    CASE WHEN (YEAR(H.FECHISPAC) - YEAR(P.IPFECNACI)) < 18 THEN 'Pediatrico' ELSE 'Adulto' END AS TipoPaciente,
    P.IPPRIAPEL AS PrimerApellido, P.IPSEGAPEL AS SegundoApellido, P.IPPRINOMB AS PrimerNombre, P.IPSEGNOMB AS SegundoNombre,
    CASE WHEN P.IPSEXOPAC = '1' THEN 'Masculino' WHEN P.IPSEXOPAC = '2' THEN 'Femenino' END AS Sexo,
    P.IPTIPOAFI AS IPTIPOAFI,
    CASE 
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI IS NOT NULL THEN P.IPTELMOVI
      WHEN P.IPTELMOVI = '' AND P.IPTELEFON IS NOT NULL THEN P.IPTELEFON
      WHEN P.IPTELEFON = '' AND P.IPTELMOVI = '' THEN NULL
      WHEN P.IPTELEFON IS NOT NULL AND P.IPTELMOVI IS NOT NULL THEN CONCAT(P.IPTELEFON,' - ',P.IPTELMOVI)  
    END AS Telefonos,
    P.CORELEPAC AS Correo,
    CASE P.IPTIPODOC 
      WHEN  1 THEN 'CC - Cédula de Ciudadanía' 
      WHEN  2 THEN 'CE - Cédula de Extranjería' 
      WHEN  3 THEN 'TI - Tarjeta de Identidad' 
      WHEN  4 THEN 'RC - Registro Civil' 
      WHEN  5 THEN 'PA - Pasaporte' 
      WHEN  6 THEN 'AS - Adulto Sin Identificación'
      WHEN  7 THEN 'MS - Menor Sin Identificación' 
      WHEN  8 THEN 'NU - Número único de identificación personal' 
      WHEN  9 THEN 'CN - Certificado de Nacido Vivo' 
      WHEN 10 THEN 'CD - Carnet Diplomático (Aplica para extranjeros)' 
      WHEN 11 THEN 'SC - Salvoconducto (Aplica para extranjeros)'
      WHEN 12 THEN 'PE - Permiso especial de Permanencia (Aplica para extranjeros)' 
      WHEN 13 THEN 'PT - Permiso temporal de permanencia' 
      WHEN 14 THEN 'DE - Documento extranjero' 
      WHEN 15 THEN 'SI - Sin identificación' 
    END AS TipoIdentificacionPaciente,
    ID.NOMBRE AS TipoIdentificacionMedico, 
    PR.CODIGONIT AS DocumentoMedico, 
    '' AS CUM, '' AS DescripcionCUM, '' AS CantidadCUM, 
    '1' AS CantidadCUPS, 
    G.DESESPECI AS Especialidad
  FROM dbo.HCDESCOEX AS A 
  INNER JOIN dbo.INCUPSIPS  AS B  ON A.CODSERIPS = B.CODSERIPS 
  INNER JOIN dbo.INPACIENT  AS P  ON P.IPCODPACI = A.IPCODPACI
  INNER JOIN dbo.INUNIFUNC  AS UF ON UF.UFUCODIGO = A.UFUCODIGO
  INNER JOIN dbo.ADINGRESO  AS I  ON I.NUMINGRES = A.NUMINGRES
  INNER JOIN Contract.HealthAdministrator AS AG ON AG.ID = I.GENCONENTITY 
  LEFT  JOIN dbo.HCHISPACA  AS H  ON H.NUMINGRES = A.NUMINGRES AND H.NUMEFOLIO = A.NUMEFOLIO 
  INNER JOIN dbo.INDIAGNOS  AS D  ON D.CODDIAGNO = H.CODDIAGNO 
  INNER JOIN dbo.INPROFSAL  AS PR ON PR.CODPROSAL = H.CODPROSAL
  LEFT  JOIN Contract.CAREGROUP AS CG ON CG.ID = I.GENCAREGROUP
  LEFT  JOIN Contract.HealthAdministrator AS HA ON HA.ID = I.GENCONENTITY
  LEFT  JOIN INDIGO035.dbo.INUBICACI  AS u   WITH (NOLOCK) ON u.AUUBICACI = P.AUUBICACI
  LEFT  JOIN INDIGO035.dbo.INMUNICIP  AS m   WITH (NOLOCK) ON m.DEPMUNCOD = u.DEPMUNCOD
  LEFT  JOIN INDIGO035.dbo.INDEPARTA  AS dep WITH (NOLOCK) ON m.DEPCODIGO = dep.DEPCODIGO
  LEFT  JOIN dbo.ADTIPOIDENTIFICA AS ID WITH (NOLOCK) ON ID.ID = PR.IDADTIPOIDENTIFICA
  LEFT  JOIN dbo.INESPECIA  AS G WITH (NOLOCK) ON G.CODESPECI = H.CODESPTRA
  WHERE H.FECHISPAC >= '2022-08-01'
) AS e
LEFT OUTER JOIN (
  SELECT NUMINGRES, MAX(ID) AS ID
  FROM dbo.HCHISPACA
  GROUP BY NUMINGRES
) AS hcc
  ON hcc.NUMINGRES = e.Ingreso
LEFT OUTER JOIN dbo.HCHISPACA AS hc
  ON hc.ID = hcc.ID
LEFT OUTER JOIN dbo.INDIAGNOS AS DX
  ON DX.CODDIAGNO = hc.CODDIAGNO;
-- WHERE e.Ingreso = '6365'
