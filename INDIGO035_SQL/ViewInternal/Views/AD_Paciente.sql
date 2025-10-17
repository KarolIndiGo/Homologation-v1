-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: AD_Paciente
-- Extracted by Fabric SQL Extractor SPN v3.9.0

--/****** Object:  View [ViewInternal].[AD_Paciente]    Script Date: 24/04/2025 4:43:50 p. m. ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


CREATE VIEW [ViewInternal].[AD_Paciente]
AS
SELECT  
    CASE
        WHEN ig1.codcenate = '001' THEN 'Neiva'
        WHEN ig1.codcenate = '002' THEN 'Pitalito'
    END AS Sucursal,
    A.IPCODPACI AS Documento,
   
    CASE IPTIPODOC 
        WHEN 1 THEN 'CC' WHEN 2 THEN 'CE' WHEN 3 THEN 'TI' WHEN 4 THEN 'RC' 
        WHEN 5 THEN 'PA' WHEN 6 THEN 'AS' WHEN 7 THEN 'MS' WHEN 8 THEN 'NU' 
        WHEN 9 THEN 'CN' WHEN 10 THEN 'CD' WHEN 11 THEN 'SC' WHEN 12 THEN 'PE'  
        WHEN 13 THEN 'PT' WHEN 14 THEN 'DE' WHEN 15 THEN 'SI' 
    END AS TipoDocumento, 
    A.CODIGONIT AS Tercero, 
    city.Name AS CiudadExpedición,
    A.IPNOMCOMP AS NombrePaciente, 
    DATEDIFF(year, IPFECNACI, ig1.IFECHAING) AS Edad, 
    'NO APLICA' AS Empresa, 
    CASE IPTIPOPAC 
        WHEN 1 THEN 'CONTRIBUTIVO' WHEN 2 THEN 'SUBSIDIADO' WHEN 3 THEN 'VINCULADO' 
        WHEN 4 THEN 'PARTICULAR' WHEN 5 THEN 'OTRO' WHEN 6 THEN 'DESPLAZADO REG. CONTRIBUTIVO' 
        WHEN 7 THEN 'DESPLAZADO REG. SUBSIDIADO' WHEN 8 THEN 'DESPLAZADO NO ASEGURADO' 
        WHEN 9 THEN 'Especial o excepción' WHEN 10 THEN 'Personas privadas de la libertad a cargo del Fondo Nacional de Salud' 
        WHEN 11 THEN 'Tomador / amparado ARL' WHEN 12 THEN 'Tomador / amparado SOAT'  
        WHEN 13 THEN 'Tomador / amparado planes voluntarios de salud' 
    END AS TipoPaciente,
    CASE IPTIPOAFI 
        WHEN 0 THEN 'NO APLICA' WHEN 1 THEN 'COTIZANTE' WHEN 2 THEN 'BENEFICIARIO' 
        WHEN 3 THEN 'ADICIONAL' WHEN 4 THEN 'JUB/RETIRADO' WHEN 5 THEN 'PENSIONADO' 
    END AS TipoAfiliación, 
    CASE CAPACIPAG 
        WHEN 0 THEN ' ' WHEN 1 THEN 'Total Paciente' WHEN 2 THEN 'Cuota Recuperación' 
        WHEN 3 THEN 'Total Entidad' 
    END AS CapacidadPago, 
    cg.Name AS GrupoAtencion, 
    D.UBINOMBRE AS Ubicación, 
    mu.MUNNOMBRE AS Municipio, 
    DEP.nomdepart AS Departamento, 
    E.NIVDESCRI AS Nivel, 
    A.IPDIRECCI AS Direccion, 
    A.IPTELEFON AS Telefono, 
    A.IPTELMOVI AS Celular, 
    A.IPFECNACI as FechaNacimiento, 
    F.desactivi as Actividad, 
    CASE IPSEXOPAC 
        WHEN 1 THEN 'MASCULINO' WHEN 2 THEN 'FEMENINO' 
    END AS Genero, 
    CASE IPESTADOC 
        WHEN 1 THEN 'SOLTERO' WHEN 2 THEN 'CASADO' WHEN 3 THEN 'VIUDO' 
        WHEN 4 THEN 'UNION LIBRE' WHEN 5 THEN 'SEPARADO/DIV' 
    END AS EstadoCivil, 
    I.NIVEDESCRI AS NivelEducativo, 
    J.CREDDESCRI AS Creencia, 
    CASE TIPCOBSAL 
        WHEN 1 THEN 'CONTRIBUTIVO' WHEN 2 THEN 'SUBTOTAL' WHEN 3 THEN 'SUBPARCIAL' 
        WHEN 4 THEN 'CON SISBEN' WHEN 5 THEN 'SIN SISBEN' WHEN 6 THEN 'DESPLAZADOS' 
        WHEN 7 THEN 'PLAN DE SALUD ADICIONAL' WHEN 8 THEN 'OTROS' 
    END AS Cobertura, 
    CASE DISCCODIGO 
        WHEN 2 THEN 'NO' WHEN 1 THEN 'SI' 
    END AS Discapacidad, 
    A.CORELEPAC AS Correo, 
    G.DESGRUPET AS GrupoEtnico, 
    A.IPESTRATO AS Estrato, 
    CASE ESTADOPAC 
        WHEN 1 THEN 'ACTIVO' WHEN 2 THEN 'INACTIVO' 
    END AS EstadoPaciente, 
    A.OBSERVACI AS Observación, 
    H1.NOMUSUARI AS UsuCrea, 
    h1.DESCARUSU as CargoCrea,
    A.FECREGCRE AS FechaCreacion, 
    H2.NOMUSUARI AS UsuModifica, 
    h2.DESCARUSU as CargoModifica,
    A.FECREGMOD AS Fecha_Modificacion, 
    CASE WHEN pais.name IS NULL THEN 'Colombia' ELSE pais.name END AS Pais, 
	 ISNULL(ingresos.CantidadIngresos, 0) AS CantidadIngresos

FROM dbo.INPACIENT AS A WITH (NOLOCK)

-- Subconsulta para contar ingresos por paciente
LEFT JOIN (
    SELECT IPCODPACI, COUNT(*) AS CantidadIngresos
    FROM dbo.ADINGRESO WITH (NOLOCK)
    GROUP BY IPCODPACI
) AS ingresos ON ingresos.IPCODPACI = A.IPCODPACI

-- Traer último ingreso
LEFT JOIN (
    SELECT MAX(IFECHAING) AS fecha, IPCODPACI
    FROM dbo.ADINGRESO WITH (NOLOCK)
    GROUP BY IPCODPACI
) AS ig ON ig.IPCODPACI = A.IPCODPACI

LEFT JOIN dbo.ADINGRESO AS ig1 ON ig1.IPCODPACI = ig.IPCODPACI AND ig1.IFECHAING = ig.fecha

LEFT OUTER JOIN dbo.INENTIDAD AS B ON B.CODENTIDA = A.CODENTIDA 
LEFT OUTER JOIN dbo.COCONTRAT AS C ON C.CODCONTRA = A.CCCONTRAT 
LEFT OUTER JOIN dbo.INUBICACI AS D ON D.AUUBICACI = A.AUUBICACI 
LEFT OUTER JOIN dbo.INMUNICIP AS mu WITH (NOLOCK) ON mu.DEPMUNCOD = D.DEPMUNCOD 
LEFT OUTER JOIN dbo.INDEPARTA AS DEP WITH (NOLOCK) ON DEP.depcodigo = mu.DEPCODIGO 
LEFT OUTER JOIN dbo.ADNIVELES AS E WITH (NOLOCK) ON E.NIVCODIGO = A.NIVCODIGO 
LEFT OUTER JOIN dbo.ADACTIVID AS F WITH (NOLOCK) ON F.codactivi = A.CODACTIVI 
LEFT OUTER JOIN dbo.ADGRUETNI AS G WITH (NOLOCK) ON G.CODGRUPOE = A.CODGRUPOE 
LEFT OUTER JOIN dbo.SEGusuaru AS H1 WITH (NOLOCK) ON H1.CODUSUARI = A.CODUSUCRE 
LEFT OUTER JOIN dbo.SEGusuaru AS H2 WITH (NOLOCK) ON H2.CODUSUARI = A.CODUSUMOD 
LEFT OUTER JOIN dbo.ADNIVELED AS I WITH (NOLOCK) ON I.NIVECODIGO = A.NIVECODIGO 
LEFT OUTER JOIN dbo.ADCREDO AS J WITH (NOLOCK) ON J.CREDCODIGO = A.CREDCODIGO 
LEFT OUTER JOIN Common.Person AS pp WITH (NOLOCK) ON pp.IdentificationNumber = A.IPCODPACI 
LEFT OUTER JOIN common.City AS city WITH (NOLOCK) ON city.Id = A.GENEXPEDITIONCITY 
LEFT OUTER JOIN Contract.CareGroup AS cg WITH (NOLOCK) ON cg.id = A.GENCAREGROUP 
LEFT OUTER JOIN Contract.HealthAdministrator AS ha WITH (NOLOCK) ON ha.Id = A.GENCONENTITY 
LEFT OUTER JOIN Common.Country AS pais WITH (NOLOCK) ON pais.Id = A.IDPAIS 

WHERE A.ESTADOPAC = '1'  
  AND ig1.CODCENATE IN ('001', '002')
  AND ig.fecha >= '2025/01/01'
  

