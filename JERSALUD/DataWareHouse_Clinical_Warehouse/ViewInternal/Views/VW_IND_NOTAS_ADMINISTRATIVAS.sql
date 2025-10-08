-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_NOTAS_ADMINISTRATIVAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_NOTAS_ADMINISTRATIVAS
AS
SELECT DISTINCT
    CASE P.IPTIPODOC
        WHEN 1
        THEN 'CC'
        WHEN 2
        THEN 'CE'
        WHEN 3
        THEN 'TI'
        WHEN 4
        THEN 'RC'
        WHEN 5
        THEN 'PA'
        WHEN 6
        THEN 'AS'
        WHEN 7
        THEN 'MS'
        WHEN 8
        THEN 'NU'
    END AS Tipo_Documento_Paciente, 
    NP.IPCODPACI AS Paciente, 
    P.IPNOMCOMP AS Nombre_Paciente, 
    P.IPDIRECCI AS Direccion, 
    P.IPTELEFON AS Telefono, 
    P.IPTELMOVI AS Celular, 
    P.IPFECNACI AS Fecha_Nacimiento, 
    (CAST(DATEDIFF(dd, P.IPFECNACI, GETDATE()) / 365.25 AS INT)) AS Edad, 
    NP.FECHACREACION AS Fecha_Nota, 
    TN.NOMBRE AS Nombre_Nota, 
    --PR.NOMMEDICO AS Medico, 
    CA.NOMCENATE AS Centro_Atencion,
    US.NOMUSUARI AS USUARIO,
    IdCita.VALOR as IdCita
FROM [INDIGO031].[dbo].[NTNOTASADMINISTRATIVASC] AS NP
    INNER JOIN [INDIGO031].[dbo].[NTADMINISTRATIVAS] AS TN ON TN.ID = NP.IDNOTAADMINISTRATIVA
    INNER JOIN [INDIGO031].[dbo].[INPACIENT] AS P ON P.IPCODPACI = NP.IPCODPACI
    INNER JOIN [INDIGO031].[dbo].[ADCENATEN] AS CA ON CA.CODCENATE = NP.CODCENATE
    --INNER JOIN [INDIGO031].[dbo].[INPROFSAL] AS PR ON PR.CODPROSAL = NP.CODUSUARI
    INNER JOIN [INDIGO031].[dbo].[SEGusuaru] AS US ON US.CODUSUARI = NP.CODUSUARI
    left join (select  D.VALOR, IDNTNOTASADMINISTRATIVASC
            from [INDIGO031].[dbo].[NTNOTASADMINISTRATIVASD] AS D 
            inner join [INDIGO031].[dbo].[NTVARIABLES] as vari  on vari.ID=D.IDNTVARIABLE
            left outer join [INDIGO031].[dbo].[NTVARIABLESL] as vard  on vard.ID=D.IDITEMLISTA
            where  vari.ID='122') as IdCita on IdCita.IDNTNOTASADMINISTRATIVASC=NP.ID
