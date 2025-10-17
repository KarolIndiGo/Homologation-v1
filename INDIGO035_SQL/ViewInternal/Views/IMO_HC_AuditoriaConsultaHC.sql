-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_HC_AuditoriaConsultaHC
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE view [ViewInternal].[IMO_HC_AuditoriaConsultaHC] as 
SELECT  
case when  p.CentroCosto is not null and p.CentroCosto like 'NEV%' then 'Neiva' 
when p.CentroCosto is not null and p.CentroCosto like 'PIT%' then 'Pitalito'
when p.CentroCosto is not null and p.CentroCosto like 'TUN%' then 'Tunja'
when  p.CentroCosto is null and p.Position like '%CONTACT%' then 'Contact Center' 
when  p.CentroCosto is null and usu.DESCARUSU like '%CONTACT%' then 'Contact Center' 
else 'Externo' 
end as Sucursal, H.CODUSUCONS AS [Cod Usuario], usu.NOMUSUARI AS [Usuario Consulta], case when p.Position is null then usu.DESCARUSU else p.Position end as Cargo, case pR.tipprofes 
when 1 then 'Medico General'  when 2 then 'Medico Especialista' when 3 then 'Enfermera' when 4 then 'Auxiliar Enfermeria' when 5 then 'Odontologo General' when 6 then 'Odontologo Especialista'
when 7 then 'Nutricionista'when 8 then 'Higienista' when 9 then 'Psicologo' when 10 then 'Trabajadora Social' when 11 then 'Promotor de Saneamiento' when 12 then  'Ingeniero Sanitario'
when 13 then  'Medico Veterinario' when 14 then 'Ingeniero Alimento' when 15 then 'Auxiliar Bacteriologo' when 16 then  'Terapeuta' when 17 then 'Optometra' when 18 then 'Quimico Farmaceutico'
when 19 then 'Radiologo' when 20 then 'Tecnologo Radiologo' when 21 then  'Instrumentador Qx' when 22 then 'Auxiliar Patologia' when 23 then 'Otros' when 24 then 'Medico Interno'
when 25 then 'Bacteriologo(a)' when 26 then 'Patólogo(a)' when 27 then 'Médico residente' end as Profesion,
p.CentroCosto,
case when tratante.CodigoProfesional is not null then 'Si' else 'No' end as 'Tratante', p.TratanteExcluido,
H.CODPACQCON AS [IdentificacionPaciente], 
A.IPNOMCOMP AS Paciente, act.codactivi AS CodActividad, act.desactivi AS ActividadPaciente, /*h.INGRESO as Ingreso, */
case when em.Nit is not null and est.CODUSUARI is null then 'Funcionario' 
	 when em.Nit is null and est.CODUSUARI is not null then 'Estudiante' end as [Funcionario/Estudiante],
           /* H.FECHCONSU AS  FechaConsulta,*/ H.IPMAQCONS AS IP_Consulta, h.NOMMAQCONS as Nombre_Equipo,
			
			Year( H.FECHCONSU) AS [Año Consulta], datename(month, H.FECHCONSU) AS [Mes Consulta],/*, DAY(H.FECHCONSU) AS [Dia Consulta], */  
             
			  CASE A.ESTADOPAC WHEN 1 THEN 'Vivo' WHEN 0 THEN 'Fallecido' END AS EstadoPaciente

FROM   dbo.HCAUDITORIA AS H   -- Auditoria
inner join DBO.SEGusuaru AS usu  on usu.CODUSUARI=h.CODUSUCONS -- Usuario
inner JOIN dbo.INPACIENT AS A  ON A.IPCODPACI = H.CODPACQCON LEFT OUTER JOIN -- Paciente
--dbo.MOVCONSULHC AS M  ON M.Id = H.MOVCONSULHCID LEFT OUTER JOIN -- Motivo Consulta (Solo perfil Administrativo)
dbo.ADACTIVID AS act  ON act.codactivi = A.CODACTIVI LEFT OUTER JOIN -- Actividad Paciente
 DBO.INPROFSAL AS PR  ON PR.CODPROSAL=h.CODUSUCONS LEFT JOIN

(SELECT u.usercode, p.identification, p.fullname , CO.CARGO AS position, t.nit, W.Name as Sucursal, cc.Name as CentroCosto, co.UNIDAD, 
case when co.CARGO in ('LIDER DE CALIDAD','ANALISTA DE CALIDAD','LIDER EN EPIDEMIOLOGIA') then 'Si'
--when unidad in ('GLOSAS Y AUDITORIA-EAL','GLOSAS Y AUDITORIA-FLA','GLOSAS Y AUDITORIA NACIONAL-MA','GLOSAS Y AUDITORIA-NVA','GLOSAS Y AUDITORIA-TJA')
--and co.CARGO in ('ASISTENTE DE GLOSAS','AUDITOR DE CUENTAS MEDICAS','DIRECTOR NACIONAL DE AUDITORIA','ANALISTA DE GLOSAS','JEFE DE GLOSAS') then 'Si'
--when unidad in ('ARCHIVO-NVA','ARCHIVO-TJA','ARCHIVO-FLA') and co.CARGO in ('JEFE DE ARCHIVO TIPO I','JEFE DE ARCHIVO TIPO II','AUXILIAR DE ARCHIVO TIPO I') then 'Si'
--when unidad ='TIC NACIONAL-MA' and co.CARGO ='COORDINADOR NACIONAL DE ARCHIVO Y GESTION DOCUMENTAL' then 'Si'
--when unidad ='CARTERA NACIONAL-MA' and co.CARGO ='JEFE NACIONAL DE FACTURACIN Y CONTRATACIN EN SALUD' then 'Si'
else ' ' end as TratanteExcluido
-- Validacion Talento Humano
FROM [Security].[User] as u  -- Usuario
inner join [Security].Person as p   on p.id=u.Idperson -- Documento
INNER JOIN Common.ThirdParty AS T  ON t.nit=REPLACE(LTRIM(REPLACE(p.Identification,'0',' ')),' ','0')  -- Tercero
LEFT JOIN Payroll.Employee AS E  ON E.ThirdPartyId=T.Id -- Empleado
LEFT JOIN Payroll.WorkCenter AS W  ON W.Id=E.WorkCenterId -- Centro de Trabajo (Sucursal)
LEFT JOIN Payroll.CostCenter as cc  on cc.id=e.CostCenterId
LEFT JOIN (SELECT CO.EmployeeId, CA.Name AS CARGO, FU.Name AS UNIDAD
FROM (
		select max(id) as Id, EmployeeId
		from  Payroll.Contract AS co 
		group by EmployeeId) AS C 
INNER JOIN Payroll.Contract AS CO ON CO.ID=C.ID 
LEFT OUTER JOIN Payroll.Position AS ca  ON ca.Id = co.PositionId LEFT OUTER JOIN
           Payroll.FunctionalUnit AS fu  ON fu.Id = co.FunctionalUnitId) AS CO ON CO.EmployeeId=E.ID) as p on p.UserCode=h.CODUSUCONS -- Centro de Costo
LEFT JOIN DBO.INUNIFUNC AS UF  ON UF.UFUCODIGO=H.UFUCODIGO -- Unidad Funcional Consulta
LEFT JOIN (select t.nit -- Validación Funcionario 
			from  payroll.employee as e 
			inner join payroll.contract as c  on c.employeeid=e.id
			inner join Common.ThirdParty as t  on t.id=e.ThirdPartyId
			where c.status=1) as em on em.Nit=H.CODPACQCON
LEFT JOIN (SELECT CODUSUARI, NOMUSUARI -- Validación Estudiante
			FROM DBO.SEGUSUARU AS U 
			WHERE DESCARUSU LIKE '%ESTUDIANTE%') as est on est.CODUSUARI=H.CODPACQCON
left join ( -- Validación Tratante
SELECT CodigoProfesional,  Paciente, Tipo
FROM (
SELECT p.CODUSUARI AS CodigoProfesional, IPCODPACI as Paciente, 'Medico' as Tipo -- Medico
FROM DBO.HCHISPACA as h 
inner join dbo.INPROFSAL as p on p.CODPROSAL=h.CODPROSAL
--WHERE FECHISPAC BETWEEN '26-02-2023 00:00:00' AND '26-02-2023 23:59:59' 
GROUP BY p.CODUSUARI, IPCODPACI

UNION ALL
SELECT  p.CODUSUARI AS CodigoProfesional, IPCODPACI as Paciente, 'Enfermeria' as Tipo -- Enfermeria
FROM dbo.HCCTRNOTE as h 
inner join dbo.INPROFSAL as p on p.CODPROSAL=h.CODPROSAL
--WHERE FECREGSIS BETWEEN '26-02-2023 00:00:00' AND '26-02-2023 23:59:59' 
GROUP BY p.CODUSUARI, IPCODPACI
UNION ALL
SELECT TOP (1)p.CODUSUARI AS CodigoProfesional, IPCODPACI as Paciente, 'Terapias' as Tipo -- Terapias
FROM dbo.HCCTRNOTT as h 
inner join dbo.INPROFSAL as p on p.CODPROSAL=h.CODPROSAL
--WHERE FECREGSIS BETWEEN '26-02-2023 00:00:00' AND '26-02-2023 23:59:59' 
GROUP BY p.CODUSUARI, IPCODPACI
UNION ALL
SELECT CREATIONUSER as CodigoProfesional, PATIENTCODE as Paciente, 'Facturacion' as Tipo -- Facturación
FROM billing.serviceorder 
--WHERE CreationDate BETWEEN '26-02-2023 00:00:00' AND '26-02-2023 23:59:59' 
GROUP BY CREATIONUSER, PATIENTCODE
) AS A
) as tratante on tratante.CodigoProfesional=H.CODUSUCONS and tratante.Paciente= h.CODPACQCON

WHERE  H.CODPACQCON <>'0123456789' --and h.CODUSUCONS='AT2'
and h.MOVCONSULHCID is null
GROUP BY p.CentroCosto ,  usu.NOMUSUARI, H.CODUSUCONS, usu.NOMUSUARI, p.Position, usu.DESCARUSU, pR.tipprofes, tratante.CodigoProfesional,  
H.CODPACQCON , A.IPNOMCOMP , act.codactivi , act.desactivi , /*h.INGRESO ,*/  est.CODUSUARI, em.Nit,   A.ESTADOPAC,
Year( H.FECHCONSU) , datename(month, H.FECHCONSU) , /*DAY(H.FECHCONSU) , */
p.TratanteExcluido, /*H.FECHCONSU ,*/ H.IPMAQCONS , h.NOMMAQCONS--where a.Tratante='No'
