-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_CRI_INGRESOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_CRI_INGRESOS
AS
SELECT
    i.NUMINGRES AS Ingreso,
    caa.NOMCENATE as CentroAtencion,
    ga.Code AS Cód_Grupo_Atención,
    ga.Name AS Grupo_Atención,
    t.Nit,
    ea.Name AS Entidad,
    i.IPCODPACI AS Identificación,
    CAST(p.GENEXPEDITIONCITY AS varchar(20)) + ' - ' + ISNULL(ci.Name, '') AS Lugar_Expedición,
    p.IPNOMCOMP AS Paciente,
    i.IFECHAING AS Fecha_Ingreso,
    CASE i.IESTADOIN
        WHEN '  ' THEN 'Sin Confirmar Hoja de Trabajo'
        WHEN 'F' THEN 'Confirmada Hoja de Trabajo'
        WHEN 'A' THEN 'Anulado'
        WHEN 'C' THEN 'Cerrado'
        WHEN 'P' THEN 'Facturado Parcial'
    END AS Estado,
    uf.UFUCODIGO as CodUF,
    uf.UFUDESCRI AS Unidad_Funcional,
    em.FECALTPAC AS Fecha_Alta_Médica,
    LTRIM(RTRIM(em.CODPROSAL)) + ' - ' + LTRIM(RTRIM(PRO.NOMMEDICO)) as MedicoAltaMedica,
    HC.CODDIAGNO AS CIE_10,
    CIE10.NOMDIAGNO AS Diagnóstico,
    i.CODUSUCRE AS CódUsuarioCrea,
    i.FECREGCRE AS Fecha_Creación,
    uu.NOMUSUARI AS UsuarioModifico,
    i.FECREGMOD AS Fecha_Modificación,
    D.UFUDESCRI AS UnidadActual,
    i.IOBSERVAC AS Observaciones,
    CASE i.TIPOINGRE
        WHEN 1 THEN 'Ambulatorio'
        WHEN 2 THEN 'Hospitalario'
    END AS TipoIngreso,
    HCU.ENFACTUAL AS Enfermedad_Actual,
    UBINOMBRE AS Ubicación,
    MUNNOMBRE AS Municipio,
    p.IPTELEFON AS [Tele Fijo],
    p.IPTELMOVI AS [Tel Movil],
    i.IAUTORIZA as Autorizacion,
    CASE
        WHEN (CONVERT(varchar, em.FECALTPAC, 105)) IS NULL THEN 'Sin Alta'
        ELSE 'Con Alta'
    END AS Egreso,
    DEP.nomdepart as Departamento,
    CASE IPTIPOPAC
        WHEN 1 THEN 'Contributivo'
        WHEN 2 THEN 'Subsidiado'
        WHEN 3 THEN 'Vinculado'
        WHEN 4 THEN 'Particular'
        WHEN 5 THEN 'Otro'
        WHEN 6 THEN 'Desplazado Reg. Contributivo'
        WHEN 7 THEN 'Desplazado Reg. Subsidiado'
        WHEN 8 THEN 'Desplazado No Asegurado'
    END AS TipoPaciente
FROM
    [INDIGO031].[dbo].[ADINGRESO] AS i
    INNER JOIN [INDIGO031].[dbo].[INUNIFUNC] AS uf ON uf.UFUCODIGO = i.UFUCODIGO
    LEFT OUTER JOIN INDIGO031.Contract.CareGroup AS ga ON ga.Id = i.GENCAREGROUP
    LEFT OUTER JOIN [INDIGO031].[dbo].[HCHISPACA] AS HC ON HC.NUMINGRES = i.NUMINGRES AND HC.IPCODPACI = HC.IPCODPACI AND HC.TIPHISPAC = 'i'
    LEFT OUTER JOIN [INDIGO031].[dbo].[INPACIENT] AS p ON p.IPCODPACI = i.IPCODPACI
    LEFT OUTER JOIN INDIGO031.Contract.HealthAdministrator AS ea ON ea.Id = i.GENCONENTITY
    LEFT OUTER JOIN INDIGO031.Common.ThirdParty AS t ON t.Id = ea.ThirdPartyId
    LEFT OUTER JOIN INDIGO031.Common.City AS ci ON ci.Id = p.GENEXPEDITIONCITY
    LEFT OUTER JOIN [INDIGO031].[dbo].[HCURGING1] AS HCU ON HCU.NUMINGRES = HC.NUMINGRES AND HCU.IPCODPACI = HC.IPCODPACI AND HCU.NUMEFOLIO = HC.NUMEFOLIO
    LEFT OUTER JOIN (
        SELECT
            IPCODPACI,
            NUMINGRES,
            MAX(NUMEFOLIO) AS Folio
        FROM
            [INDIGO031].[dbo].[INDIAGNOP]
        WHERE
            (CODDIAPRI = 'True')
        GROUP BY
            NUMINGRES,
            IPCODPACI
    ) AS DX ON DX.IPCODPACI = HCU.IPCODPACI AND DX.NUMINGRES = HCU.NUMINGRES AND DX.Folio = HC.NUMEFOLIO
    LEFT OUTER JOIN [INDIGO031].[dbo].[INDIAGNOS] AS CIE10 ON CIE10.CODDIAGNO = HC.CODDIAGNO
    LEFT OUTER JOIN [INDIGO031].[dbo].[HCURGEVO1] AS HCU1 ON HCU.NUMINGRES = HC.NUMINGRES AND HCU1.IPCODPACI = HC.IPCODPACI AND HCU1.NUMEFOLIO = HC.NUMEFOLIO
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADINGRESO] AS I2 ON I2.NUMINGRES = i.NUMINGRES
    LEFT OUTER JOIN [INDIGO031].[dbo].[INUNIFUNC] AS D ON I2.UFUAACTHOS = D.UFUCODIGO
    LEFT OUTER JOIN [INDIGO031].[dbo].[HCREGEGRE] AS em ON em.IPCODPACI = HC.IPCODPACI AND em.NUMINGRES = HC.NUMINGRES
    LEFT OUTER JOIN [INDIGO031].[dbo].[SEGusuaru] AS uu ON uu.CODUSUARI = i.CODUSUCRE
    LEFT OUTER JOIN [INDIGO031].[dbo].[INUBICACI] AS BB ON BB.AUUBICACI = p.AUUBICACI
    LEFT OUTER JOIN [INDIGO031].[dbo].[INMUNICIP] AS EE ON EE.DEPMUNCOD = BB.DEPMUNCOD
    LEFT OUTER JOIN [INDIGO031].[dbo].[INDEPARTA] AS DEP ON DEP.depcodigo = EE.DEPCODIGO
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADCENATEN] as caa on caa.CODCENATE = i.CODCENATE
    LEFT OUTER JOIN [INDIGO031].[dbo].[INPROFSAL] AS PRO ON PRO.CODPROSAL = em.CODPROSAL
WHERE
    (i.IESTADOIN <> 'A')
    AND i.IFECHAING >= '01-02-2025'
