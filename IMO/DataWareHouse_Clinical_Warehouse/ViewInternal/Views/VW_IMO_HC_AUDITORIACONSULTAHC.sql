-- Workspace: IMO
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 45d58e75-d0a4-4f2b-bd10-65e2dfeda219
-- Schema: ViewInternal
-- Object: VW_IMO_HC_AUDITORIACONSULTAHC
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IMO_HC_AuditoriaConsultaHC]
AS

SELECT
case when  p.CentroCosto is not null and p.CentroCosto like 'NEV%' then 'Neiva' 
     when p.CentroCosto is not null and p.CentroCosto like 'PIT%' then 'Pitalito'
     when p.CentroCosto is not null and p.CentroCosto like 'TUN%' then 'Tunja'
     when  p.CentroCosto is null and p.[Position] like '%CONTACT%' then 'Contact Center' 
     when  p.CentroCosto is null and usu.DESCARUSU like '%CONTACT%' then 'Contact Center' 
     else 'Externo' 
end as Sucursal, 
H.CODUSUCONS AS [Cod Usuario], 
usu.NOMUSUARI AS [Usuario Consulta], 
case when p.[Position] is null then usu.DESCARUSU else p.[Position] end as Cargo, 
case PR.TIPPROFES
     when 1 then 'Medico General'  when 2 then 'Medico Especialista' when 3 then 'Enfermera' when 4 then 'Auxiliar Enfermeria' 
     when 5 then 'Odontologo General' when 6 then 'Odontologo Especialista' when 7 then 'Nutricionista' when 8 then 'Higienista' 
     when 9 then 'Psicologo' when 10 then 'Trabajadora Social' when 11 then 'Promotor de Saneamiento' when 12 then 'Ingeniero Sanitario'
     when 13 then 'Medico Veterinario' when 14 then 'Ingeniero Alimento' when 15 then 'Auxiliar Bacteriologo' when 16 then 'Terapeuta' 
     when 17 then 'Optometra' when 18 then 'Quimico Farmaceutico' when 19 then 'Radiologo' when 20 then 'Tecnologo Radiologo' 
     when 21 then 'Instrumentador Qx' when 22 then 'Auxiliar Patologia' when 23 then 'Otros' when 24 then 'Medico Interno'
     when 25 then 'Bacteriologo(a)' when 26 then 'Patólogo(a)' when 27 then 'Médico residente' 
end as Profesion,
p.CentroCosto,
case when tratante.CodigoProfesional is not null then 'Si' else 'No' end as [Tratante], 
p.TratanteExcluido,
H.CODPACQCON AS [IdentificacionPaciente], 
A.IPNOMCOMP AS Paciente, 
act.codactivi AS CodActividad, 
act.desactivi AS ActividadPaciente, /*h.INGRESO as Ingreso, */
case when em.Nit is not null and est.CODUSUARI is null then 'Funcionario' 
     when em.Nit is null and est.CODUSUARI is not null then 'Estudiante' 
end as [Funcionario/Estudiante],
/* H.FECHCONSU AS  FechaConsulta,*/ 
H.IPMAQCONS AS IP_Consulta, 
H.NOMMAQCONS as Nombre_Equipo,
YEAR(H.FECHCONSU) AS [Año Consulta], 
DATENAME(month, H.FECHCONSU) AS [Mes Consulta],/*, DAY(H.FECHCONSU) AS [Dia Consulta], */  
CASE A.ESTADOPAC WHEN 1 THEN 'Vivo' WHEN 0 THEN 'Fallecido' END AS EstadoPaciente

FROM   [INDIGO035].[dbo].[HCAUDITORIA] AS H   -- Auditoria
INNER JOIN [INDIGO035].[dbo].[SEGusuaru] AS usu  
    ON usu.CODUSUARI = H.CODUSUCONS -- Usuario
INNER JOIN [INDIGO035].[dbo].[INPACIENT] AS A  
    ON A.IPCODPACI = H.CODPACQCON -- Paciente
--LEFT JOIN [INDIGO035].[dbo].[MOVCONSULHC] AS M  ON M.Id = H.MOVCONSULHCID -- Motivo Consulta (Solo perfil Administrativo)
LEFT JOIN [INDIGO035].[dbo].[ADACTIVID] AS act  
    ON act.codactivi = A.CODACTIVI -- Actividad Paciente
LEFT JOIN [INDIGO035].[dbo].[INPROFSAL] AS PR  
    ON PR.CODPROSAL = H.CODUSUCONS

/* Talento Humano */
LEFT JOIN (
    SELECT 
        u.UserCode, 
        p.Identification, 
        p.Fullname, 
        CO.CARGO AS [Position], 
        T.Nit, 
        W.Name AS Sucursal, 
        cc.Name AS CentroCosto, 
        CO.UNIDAD, 
        CASE 
            WHEN CO.CARGO IN ('LIDER DE CALIDAD','ANALISTA DE CALIDAD','LIDER EN EPIDEMIOLOGIA') THEN 'Si'
            ELSE ' ' 
        END AS TratanteExcluido
    FROM [INDIGO035].[Security].[UserInt] AS u  -- Usuario
    INNER JOIN [INDIGO035].[Security].[PersonInt] AS p   
        ON p.Id = u.IdPerson -- Documento
    INNER JOIN [INDIGO035].[Common].[ThirdParty] AS T  
        ON T.Nit = REPLACE(LTRIM(REPLACE(p.Identification,'0',' ')),' ','0')  -- Tercero
    LEFT JOIN [INDIGO035].[Payroll].[Employee] AS E  
        ON E.ThirdPartyId = T.Id -- Empleado
    LEFT JOIN [INDIGO035].[Payroll].[WorkCenter] AS W  
        ON W.Id = E.WorkCenterId -- Centro de Trabajo (Sucursal)
    LEFT JOIN [INDIGO035].[Payroll].[CostCenter] AS cc  
        ON cc.Id = E.CostCenterId
    LEFT JOIN (
        SELECT CO.EmployeeId, ca.Name AS CARGO, fu.Name AS UNIDAD
        FROM (
            SELECT MAX(Id) AS Id, EmployeeId
            FROM [INDIGO035].[Payroll].[Contract] AS co 
            GROUP BY EmployeeId
        ) AS C 
        INNER JOIN [INDIGO035].[Payroll].[Contract] AS CO 
            ON CO.Id = C.Id
        LEFT OUTER JOIN [INDIGO035].[Payroll].[Position] AS ca  
            ON ca.Id = CO.PositionId 
        LEFT OUTER JOIN [INDIGO035].[Payroll].[FunctionalUnit] AS fu  
            ON fu.Id = CO.FunctionalUnitId
    ) AS CO 
        ON CO.EmployeeId = E.Id
) AS p 
    ON p.UserCode = H.CODUSUCONS -- Centro de Costo

LEFT JOIN [INDIGO035].[dbo].[INUNIFUNC] AS UF  
    ON UF.UFUCODIGO = H.UFUCODIGO -- Unidad Funcional Consulta

/* Validación Funcionario */
LEFT JOIN (
    SELECT t.Nit
    FROM  [INDIGO035].[Payroll].[Employee] AS e 
    INNER JOIN [INDIGO035].[Payroll].[Contract] AS c  
        ON c.EmployeeId = e.Id
    INNER JOIN [INDIGO035].[Common].[ThirdParty] AS t  
        ON t.Id = e.ThirdPartyId
    WHERE c.Status = 1
) AS em 
    ON em.Nit = H.CODPACQCON

/* Validación Estudiante */
LEFT JOIN (
    SELECT CODUSUARI, NOMUSUARI
    FROM [INDIGO035].[dbo].[SEGusuaru] AS U 
    WHERE DESCARUSU LIKE '%ESTUDIANTE%'
) AS est 
    ON est.CODUSUARI = H.CODPACQCON

/* Validación Tratante */
LEFT JOIN (
    SELECT CodigoProfesional, Paciente, Tipo
    FROM (
        SELECT p.CODUSUARI AS CodigoProfesional, IPCODPACI AS Paciente, 'Medico' AS Tipo
        FROM [INDIGO035].[dbo].[HCHISPACA] AS h 
        INNER JOIN [INDIGO035].[dbo].[INPROFSAL] AS p 
            ON p.CODPROSAL = h.CODPROSAL
        GROUP BY p.CODUSUARI, IPCODPACI

        UNION ALL
        SELECT p.CODUSUARI, IPCODPACI, 'Enfermeria'
        FROM [INDIGO035].[dbo].[HCCTRNOTE] AS h 
        INNER JOIN [INDIGO035].[dbo].[INPROFSAL] AS p 
            ON p.CODPROSAL = h.CODPROSAL
        GROUP BY p.CODUSUARI, IPCODPACI

        UNION ALL
        SELECT TOP (1) p.CODUSUARI, IPCODPACI, 'Terapias'
        FROM [INDIGO035].[dbo].[HCCTRNOTT] AS h 
        INNER JOIN [INDIGO035].[dbo].[INPROFSAL] AS p 
            ON p.CODPROSAL = h.CODPROSAL
        GROUP BY p.CODUSUARI, IPCODPACI

        UNION ALL
        SELECT CreationUser, PatientCode, 'Facturacion'
        FROM [INDIGO035].[Billing].[ServiceOrder] 
        GROUP BY CreationUser, PatientCode
    ) AS A
) AS tratante 
    ON tratante.CodigoProfesional = H.CODUSUCONS 
   AND tratante.Paciente = H.CODPACQCON

WHERE H.CODPACQCON <> '0123456789'
  AND H.MOVCONSULHCID IS NULL

GROUP BY 
p.CentroCosto, usu.NOMUSUARI, H.CODUSUCONS, usu.NOMUSUARI, p.[Position], usu.DESCARUSU, PR.TIPPROFES, tratante.CodigoProfesional,  
H.CODPACQCON, A.IPNOMCOMP, act.codactivi, act.desactivi, /*h.INGRESO,*/ est.CODUSUARI, em.Nit, A.ESTADOPAC,
YEAR(H.FECHCONSU), DATENAME(month, H.FECHCONSU), /*DAY(H.FECHCONSU),*/
p.TratanteExcluido, /*H.FECHCONSU,*/ H.IPMAQCONS, H.NOMMAQCONS;