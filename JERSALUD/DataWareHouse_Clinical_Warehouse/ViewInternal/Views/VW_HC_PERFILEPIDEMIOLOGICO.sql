-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_HC_PERFILEPIDEMIOLOGICO
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.VW_HC_PERFILEPIDEMIOLOGICO
AS

SELECT  
    ca.NOMCENATE AS CentroAtencion, 
    YEAR(INGR.IFECHAING) AS Año, 
    ing.NUMINGRES AS Ingreso, 
    CASE IPTIPODOC 
        WHEN 1 THEN 'CC' 
        WHEN 2 THEN 'CE' 
        WHEN 3 THEN 'TI' 
        WHEN 4 THEN 'RC' 
        WHEN 5 THEN 'PA' 
        WHEN 6 THEN 'AS' 
        WHEN 7 THEN 'MS' 
        WHEN '8' THEN 'NU' 
        WHEN '9' THEN 'NV'  
        WHEN '12' THEN 'PE' 
        WHEN '13' THEN 'PT' 
    END AS TipoIdentificacion, 
    A.IPCODPACI AS Identificacion,  
    CASE IPSEXOPAC 
        WHEN 1 THEN 'M' 
        WHEN 2 THEN 'F' 
    END AS Genero, 
    DATEDIFF(MONTH,A.IPFECNACI,INGR.IFECHAING)/12 AS Edad_Años,
    RTRIM(LTRIM(INDIGO031.dbo.Edad(CONVERT(varchar, A.IPFECNACI, 112), CONVERT(varchar,ing.FECALTPAC, 112)))) AS Edad, -- FUNCION
    A.IPFECNACI AS FechaNacimiento, 
    CASE IPESTADOC
        WHEN 1 THEN 'Soltero' 
        WHEN 2 THEN 'Casado' 
        WHEN 3 THEN 'Viudo' 
        WHEN 4 THEN 'Union Libre' 
        WHEN 5 THEN 'Separado(a)/Div' 
    END AS [Estado Civil], 
    I.NIVEDESCRI AS [Nivel Educativo], 
    F.desactivi AS Ocupacion, 
    ga.Name AS Entidad, 
    CASE IPTIPOPAC 
        WHEN 1 THEN 'Contributivo' 
        WHEN 2 THEN 'Subsidiado' 
        WHEN 3 THEN 'Vinculado' 
        WHEN 4 THEN 'Particular' 
        WHEN 5 THEN 'Otro' 
        WHEN 6 THEN 'Desplazado Reg. Contributivo' 
        WHEN 7 THEN 'Desplazado Reg. Subsidiado' 
        WHEN 8 THEN 'Desplazado No Asegurado' 
    END AS TipoAfiliacion, 
    A.IPESTRATO AS Estrato, 
    CASE A.ZONAPARTADA 
        WHEN 'False' THEN 'Urbana' 
        WHEN 'True' THEN 'Rural' 
    END AS Area, 
    D.UBINOMBRE AS Ubicacion, 
    m.MUNNOMBRE AS MunicipioProcedencia, 
    DEP.nomdepart AS Departamento, 
    G.DESGRUPET AS GrupoEtnico, 
    J.CREDDESCRI AS Religion, 
    ps1.Secundario as [Poblacion Vulnerable], 
    W.DISCDESCRI AS Discapacidad,
    CASE INGR.IINGREPOR 
        WHEN 1 THEN 'Urgencias' 
        WHEN 2 THEN 'Consulta Externa' 
        WHEN 3 THEN 'Nacido Hospital' 
        WHEN 4 THEN 'Remitido' 
        WHEN 5 THEN 'Hospitalizacion de Urgencias' 
    END AS IngresoPor, 
    CASE 
        WHEN INGR.TIPOINGRE = '1' THEN 'Ambulatorio' 
        WHEN INGR.ICAUSAING ='11' and INGR.TIPOINGRE = '2' THEN 'Ambulatorio' 
        ELSE 'Hospitalario' 
    END as TipoIngreso,
    ufh.UFUDESCRI as UnidadFuncionalIngreso,
    INGR.IFECHAING AS [Fecha atencion], 
    ES1.DESESPECI AS [Especialidad Tratante], 
    INGR.CODDIAING AS CIE10_Ingreso, 
    dx.NOMDIAGNO AS [Dx Ingreso], 
    ps.Secundario as OtrosDx,
    INGR.CODDIAEGR AS CodEgreso, 
    dxe.NOMDIAGNO AS [Dx Egreso],    
    uf.UFUDESCRI AS UnidadFuncionalEgreso, 
    ing.FECALTPAC AS FechaEgreso, 
    CASE ESTPACEGR 
        WHEN 1 THEN 'Mejor' 
        WHEN 2 THEN 'Igual o Peor' 
        WHEN 3 THEN 'Fallecido' 
        WHEN 4 THEN 'Remitido' 
        WHEN 5 THEN 'Hospitalizacion en Casa' 
    END AS [Condicion de Egreso],  
    cm.DESCAUMUE AS [Causa Muerte], 
    CASE 
        WHEN CONVERT(char(10), ing.FECMUEPAC, 103) = '01/01/1900' THEN INGR.FECHEGRESO
        ELSE ing.FECMUEPAC
    END AS [Fecha de Defuncion]

FROM INDIGO031.dbo.HCREGEGRE AS ing
INNER JOIN INDIGO031.dbo.ADINGRESO AS INGR ON INGR.NUMINGRES=ing.NUMINGRES
INNER JOIN INDIGO031.dbo.INUNIFUNC AS uf ON uf.UFUCODIGO = ing.UFUCODIGO AND INGR.IESTADOIN <> 'A'
INNER JOIN INDIGO031.dbo.INPACIENT AS A ON ing.IPCODPACI = A.IPCODPACI AND YEAR(ing.FECALTPAC) = '2025'
INNER JOIN INDIGO031.dbo.INUBICACI AS D ON D.AUUBICACI = A.AUUBICACI 
LEFT OUTER JOIN INDIGO031.dbo.ADNIVELES AS E ON E.NIVCODIGO = A.NIVCODIGO 
LEFT OUTER JOIN INDIGO031.dbo.INUNIFUNC AS ufh ON ufh.UFUCODIGO = INGR.UFUCODIGO AND INGR.IESTADOIN <> 'A'
LEFT OUTER JOIN INDIGO031.dbo.ADACTIVID AS F ON F.codactivi = A.CODACTIVI 
LEFT OUTER JOIN INDIGO031.dbo.ADGRUETNI AS G ON G.CODGRUPOE = A.CODGRUPOE 
LEFT OUTER JOIN INDIGO031.dbo.SEGusuaru AS H1 ON H1.CODUSUARI = A.CODUSUCRE 
LEFT OUTER JOIN INDIGO031.dbo.SEGusuaru AS H2 ON H2.CODUSUARI = A.CODUSUMOD 
LEFT OUTER JOIN INDIGO031.dbo.ADNIVELED AS I ON I.NIVECODIGO = A.NIVECODIGO 
LEFT OUTER JOIN INDIGO031.dbo.ADDISCAPACI AS W ON W.DISCCODIGO = A.DISCCODIGO 
LEFT OUTER JOIN INDIGO031.dbo.ADCREDO AS J ON J.CREDCODIGO = A.CREDCODIGO 
LEFT OUTER JOIN INDIGO031.dbo.INUBICACI AS u ON u.AUUBICACI = A.AUUBICACI 
LEFT OUTER JOIN INDIGO031.dbo.INMUNICIP AS m ON m.DEPMUNCOD = u.DEPMUNCOD 
LEFT OUTER JOIN INDIGO031.dbo.INDEPARTA AS DEP ON m.DEPCODIGO = DEP.depcodigo 
LEFT OUTER JOIN INDIGO031.Contract.HealthAdministrator AS ga ON ga.Id = INGR.GENCONENTITY
LEFT OUTER JOIN INDIGO031.dbo.HCHISPACA AS HC ON HC.NUMINGRES = ing.NUMINGRES AND ing.NUMEFOLIO=HC.NUMEFOLIO
LEFT OUTER JOIN INDIGO031.dbo.INESPECIA AS ES1 ON ES1.CODESPECI = HC.CODESPTRA 
LEFT OUTER JOIN INDIGO031.dbo.INDIAGNOS AS dx ON dx.CODDIAGNO = INGR.CODDIAING 
LEFT OUTER JOIN INDIGO031.dbo.INDIAGNOS AS dxe ON dxe.CODDIAGNO = INGR.CODDIAEGR
INNER JOIN INDIGO031.dbo.ADCENATEN AS ca ON ca.CODCENATE = ing.CODCENATE 
LEFT OUTER JOIN INDIGO031.dbo.INCAUMUER AS cm ON cm.CODCAUMUE = ing.CODCAUMUE

/*LEFT OUTER JOIN (
    SELECT 
        DISTINCT (NUMINGRES) AS Ingreso, 
        numefolio,  
        STUFF((SELECT ', ' + rtrim(h.CODDIAGNO) + '-' + rtrim(P.NOMDIAGNO)
               FROM INDIGO031.dbo.INDIAGNOP AS h 
               LEFT JOIN INDIGO031.dbo.INDIAGNOS AS P ON P.CODDIAGNO = H.Coddiagno
               WHERE h.FECDIAGNO >= '2025-01-01' AND H.Numingres = A.NUMINGRES AND h.CODDIAPRI <> 1 
               FOR XML PATH('')), 1, 2, '') AS Secundario
    FROM INDIGO031.dbo.INDIAGNOP AS A
) AS ps ON ps.Ingreso = ing.NUMINGRES AND ps.Secundario IS NOT NULL AND ps.Numefolio = ing.NUMEFOLIO
*/
LEFT OUTER JOIN (
    SELECT 
        A.NUMINGRES AS Ingreso, 
        A.NUMEFOLIO,  
        STRING_AGG(RTRIM(h.CODDIAGNO) + '-' + RTRIM(P.NOMDIAGNO), ', ') AS Secundario
    FROM INDIGO031.dbo.INDIAGNOP AS A
    JOIN INDIGO031.dbo.INDIAGNOP AS h ON h.NUMINGRES = A.NUMINGRES
    LEFT JOIN INDIGO031.dbo.INDIAGNOS AS P ON P.CODDIAGNO = h.CODDIAGNO
    WHERE h.FECDIAGNO >= '2025-01-01' 
      AND h.CODDIAPRI <> 1
    GROUP BY A.NUMINGRES, A.NUMEFOLIO
) AS ps ON ps.Ingreso = ing.NUMINGRES AND ps.Secundario IS NOT NULL AND ps.NUMEFOLIO = ing.NUMEFOLIO

/*
LEFT OUTER JOIN (
    SELECT DISTINCT IPCODPACI AS identi,  
        STUFF((SELECT ', ' + rtrim(Pe1.Descripcion)
               FROM INDIGO031.dbo.ADPOBESPEPAC AS pe  
               INNER JOIN (SELECT IPCODPACI, YEAR(IFECHAING) AS año FROM INDIGO031.dbo.ADINGRESO
                           WHERE YEAR(IFECHAING) = 2025 GROUP BY IPCODPACI, YEAR(IFECHAING)) AS h  
                   ON h.IPCODPACI = pe.IPCODPACI 
               INNER JOIN INDIGO031.dbo.ADPOBESPE AS PE1 ON PE1.(Id) = pe.IDADPOBESPE AND PE1.ESTADO = 1
               WHERE pe.ESTADO = 1 AND pe1.Estado = 1 AND pe.IPCODPACI = A.IPCODPACI
               FOR XML PATH('')), 1, 2, '') AS Secundario
    FROM INDIGO031.dbo.ADPOBESPEPAC AS a 
    WHERE a.ESTADO = 1
) AS ps1 ON ps1.identi = ing.IPCODPACI AND ps.Secundario IS NOT NULL */
LEFT OUTER JOIN (
    SELECT
        a.IPCODPACI AS identi,  
        STRING_AGG(RTRIM(PE1.DESCRIPCION), ', ') AS Secundario
    FROM INDIGO031.dbo.ADPOBESPEPAC AS a
    INNER JOIN INDIGO031.dbo.ADINGRESO AS h
        ON h.IPCODPACI = a.IPCODPACI AND YEAR(h.IFECHAING) = 2025
    INNER JOIN INDIGO031.dbo.ADPOBESPE AS PE1
        ON PE1.ID = a.IDADPOBESPE AND PE1.ESTADO = 1
    WHERE a.ESTADO = 1
    GROUP BY a.IPCODPACI
) AS ps1 ON ps1.identi = ing.IPCODPACI AND ps1.Secundario IS NOT NULL

WHERE 
    (ing.FECALTPAC BETWEEN '2025-01-01 00:00:00' AND '2025-12-31 23:59:59')