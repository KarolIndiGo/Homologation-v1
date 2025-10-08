-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_AD_PACIENTE
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VW_AD_PACIENTE
AS
SELECT
    cen.NOMCENATE AS Sucursal, 
    A.IPCODPACI AS Documento, 
    CASE A.IPTIPODOC 
        WHEN 1 THEN 'CC' 
        WHEN 2 THEN 'CE' 
        WHEN 3 THEN 'TI' 
        WHEN 4 THEN 'RC' 
        WHEN 5 THEN 'PA' 
        WHEN 6 THEN 'AS' 
        WHEN 7 THEN 'MS' 
        WHEN 8 THEN 'NU' 
    END AS TipoDocumento, 
    A.CODIGONIT AS Tercero, 
    city.Name AS CiudadExpedición,
    A.IPNOMCOMP AS NombrePaciente, 
    'NO APLICA' AS Empresa, 
    CASE A.IPTIPOPAC 
        WHEN 1 THEN 'CONTRIBUTIVO' 
        WHEN 2 THEN 'SUBSIDIADO' 
        WHEN 3 THEN 'VINCULADO' 
        WHEN 4 THEN 'PARTICULAR' 
        WHEN 5 THEN 'OTRO' 
        WHEN 6 THEN 'DESPLAZADO REG. CONTRIBUTIVO' 
        WHEN 7 THEN 'DESPLAZADO REG. SUBSIDIADO' 
        WHEN 8 THEN 'DESPLAZADO NO ASEGURADO' 
        WHEN 9 THEN 'Especial o excepción' 
        WHEN 10 THEN 'Personas privadas de la libertad a cargo del Fondo Nacional de Salud' 
        WHEN 11 THEN 'Tomador / amparado ARL' 
        WHEN 12 THEN 'Tomador / amparado SOAT'  
        WHEN 13 THEN 'Tomador / amparado planes voluntarios de salud' 
    END AS TipoPaciente,
    CASE A.IPTIPOAFI 
        WHEN 0 THEN 'NO APLICA' 
        WHEN 1 THEN 'COTIZANTE' 
        WHEN 2 THEN 'BENEFICIARIO' 
        WHEN 3 THEN 'ADICIONAL' 
        WHEN 4 THEN 'JUB/RETIRADO' 
        WHEN 5 THEN 'PENSIONADO' 
    END AS TipoAfiliación, 
    CASE A.CAPACIPAG 
        WHEN 0 THEN ' ' 
        WHEN 1 THEN 'Total Paciente' 
        WHEN 2 THEN 'Cuota Recuperación' 
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
    CASE A.IPSEXOPAC 
        WHEN 1 THEN 'MASCULINO' 
        WHEN 2 THEN 'FEMENINO' 
    END AS Genero, 
    CASE A.IPESTADOC 
        WHEN 1 THEN 'SOLTERO' 
        WHEN 2 THEN 'CASADO' 
        WHEN 3 THEN 'VIUDO' 
        WHEN 4 THEN 'UNION LIBRE' 
        WHEN 5 THEN 'SEPARADO/DIV' 
    END AS EstadoCivil, 
    I.NIVEDESCRI AS NivelEducativo, 
    J.CREDDESCRI AS Creencia, 
    CASE A.TIPCOBSAL 
        WHEN 1 THEN 'CONTRIBUTIVO' 
        WHEN 2 THEN 'SUBTOTAL' 
        WHEN 3 THEN 'SUBPARCIAL' 
        WHEN 4 THEN 'CON SISBEN' 
        WHEN 5 THEN 'SIN SISBEN' 
        WHEN 6 THEN 'DESPLAZADOS' 
        WHEN 7 THEN 'PLAN DE SALUD ADICIONAL' 
        WHEN 8 THEN 'OTROS' 
    END AS Cobertura, 
    CASE A.DISCCODIGO 
        WHEN 2 THEN 'NO' 
        WHEN 1 THEN 'SI' 
    END AS Discapacidad, 
    A.CORELEPAC AS Correo, 
    G.DESGRUPET AS GrupoEtnico, 
    A.IPESTRATO AS Estrato, 
    CASE A.ESTADOPAC 
        WHEN 1 THEN 'ACTIVO' 
        WHEN 2 THEN 'INACTIVO' 
    END AS EstadoPaciente, 
    A.OBSERVACI AS Observación, 
    H1.NOMUSUARI AS UsuCrea, 
    H1.DESCARUSU as CargoCrea,
    A.FECREGCRE AS FechaCreacion, 
    H2.NOMUSUARI AS UsuModifica, 
    H2.DESCARUSU as CargoModifica,
    A.FECREGMOD AS Fecha_Modificacion, 
    CASE WHEN pais.Name is null then 'Colombia' else pais.Name end as Pais,  
    CASE PE1.CODIGO 
        WHEN 1 THEN 'Adulto Mayor' 
        WHEN 2 THEN 'Menores de 5 años' 
        WHEN 3 THEN 'Gestantes' 
        WHEN 4 THEN 'Discapacidad' 
        WHEN 5 THEN 'Personas con enfermedad mental' 
        WHEN 6 THEN 'Código 003' 
        WHEN 7 THEN 'Población indígena' 
        WHEN 8 THEN 'Población desplazada' 
        WHEN 9 THEN 'Población LGTBI' 
        WHEN 10 THEN 'Población extranjera' 
        WHEN 11 THEN 'Ninguno'
        WHEN 12 THEN 'Victimas de maltrato o violencia sexual'
    END AS GrupoPoblacional
FROM 
    [INDIGO031].[dbo].[INPACIENT] AS A 
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADINGRESO] ON A.IPCODPACI = [INDIGO031].[dbo].[ADINGRESO].IPCODPACI 
    LEFT OUTER JOIN [INDIGO031].[dbo].[INENTIDAD] AS B ON B.CODENTIDA = A.CODENTIDA 
    LEFT OUTER JOIN [INDIGO031].[dbo].[COCONTRAT] AS C ON C.CODCONTRA = A.CCCONTRAT 
    LEFT OUTER JOIN [INDIGO031].[dbo].[INUBICACI] AS D ON D.AUUBICACI = A.AUUBICACI 
    LEFT OUTER JOIN [INDIGO031].[dbo].[INMUNICIP] AS mu ON mu.DEPMUNCOD = D.DEPMUNCOD 
    LEFT OUTER JOIN [INDIGO031].[dbo].[INDEPARTA] AS DEP ON DEP.depcodigo = mu.DEPCODIGO 
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADNIVELES] AS E ON E.NIVCODIGO = A.NIVCODIGO 
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADACTIVID] AS F ON F.codactivi = A.CODACTIVI 
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADGRUETNI] AS G ON G.CODGRUPOE = A.CODGRUPOE
    LEFT OUTER JOIN [INDIGO031].[dbo].[SEGusuaru] AS H1 ON H1.CODUSUARI = A.CODUSUCRE 
    LEFT OUTER JOIN [INDIGO031].[dbo].[SEGusuaru] AS H2 ON H2.CODUSUARI = A.CODUSUMOD 
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADNIVELED] AS I ON I.NIVECODIGO = A.NIVECODIGO 
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADCREDO] AS J ON J.CREDCODIGO = A.CREDCODIGO 
    LEFT OUTER JOIN [INDIGO031].[Common].[Person] as pp on pp.IdentificationNumber = A.IPCODPACI 
    LEFT OUTER JOIN [INDIGO031].[Common].[City] as city on city.Id = A.GENEXPEDITIONCITY 
    LEFT OUTER JOIN [INDIGO031].[Contract].[CareGroup] as cg on cg.Id = A.GENCAREGROUP 
    LEFT OUTER JOIN [INDIGO031].[Contract].[HealthAdministrator] as ha on ha.Id = A.GENCONENTITY 
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADPOBESPEPAC] AS pe ON pe.IPCODPACI = A.IPCODPACI and pe.ESTADO = 1 
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADPOBESPE] AS PE1 ON PE1.ID = pe.IDADPOBESPE 
    LEFT OUTER JOIN [INDIGO031].[Common].[Country] AS pais ON pais.Id = A.IDPAIS
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADCENATEN] as cen on cen.CODCENATE = [INDIGO031].[dbo].[ADINGRESO].CODCENATE
WHERE  
    (A.ESTADOPAC = '1') 
    AND YEAR([INDIGO031].[dbo].[ADINGRESO].IFECHAING) >= '2024'

