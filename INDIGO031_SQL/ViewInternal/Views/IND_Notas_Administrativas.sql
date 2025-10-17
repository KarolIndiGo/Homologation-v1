-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_Notas_Administrativas
-- Extracted by Fabric SQL Extractor SPN v3.9.0

--select * from dbo.SEGusuaru where NOMUSUARI LIKE '%XIOMARA%'
CREATE VIEW [ViewInternal].[IND_Notas_Administrativas]
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
			IdCita.Valor as IdCita
     FROM dbo.NTNOTASADMINISTRATIVASC AS NP
          INNER JOIN dbo.NTADMINISTRATIVAS AS TN ON TN.ID = NP.IDNOTAADMINISTRATIVA
          INNER JOIN dbo.INPACIENT AS P ON P.IPCODPACI = NP.IPCODPACI
          INNER JOIN dbo.ADCENATEN AS CA ON CA.CODCENATE = NP.CODCENATE
          --INNER JOIN dbo.INPROFSAL AS PR ON PR.CODPROSAL = NP.CODUSUARI
		  INNER JOIN dbo.SEGusuaru AS US ON US.CODUSUARI = NP.CODUSUARI
		  left join (select  d.valor, IDNTNOTASADMINISTRATIVASC
from [Dbo].[NTNOTASADMINISTRATIVASD] AS D WITH(NOLOCK)
inner join [Dbo].NTVARIABLES as vari WITH(NOLOCK) on vari.id=d.IDNTVARIABLE
left outer join Dbo.NTVARIABLESL as vard WITH(NOLOCK) on vard.id=d.iditemlista
where  vari.id='122') as IdCita on IdCita.IDNTNOTASADMINISTRATIVASC=NP.ID

