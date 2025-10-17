-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: AD_Paciente
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [VIEWINTERNAL].[AD_Paciente]
AS
SELECT CEN.NOMCENATE AS Sucursal, A.IPCODPACI AS Documento, CASE IPTIPODOC WHEN 1 THEN 'CC' WHEN 2 THEN 'CE' WHEN 3 THEN 'TI' WHEN 4 THEN 'RC' WHEN 5 THEN 'PA' WHEN 6 THEN 'AS' WHEN 7 THEN 'MS' WHEN 8 THEN 'NU' END AS TipoDocumento, A.CODIGONIT AS Tercero, 
city.Name AS CiudadExpedición,
 A.IPNOMCOMP AS NombrePaciente, 
            'NO APLICA' AS Empresa, 
           CASE IPTIPOPAC WHEN 1 THEN 'CONTRIBUTIVO' WHEN 2 THEN 'SUBSIDIADO' WHEN 3 THEN 'VINCULADO' WHEN 4 THEN 'PARTICULAR' WHEN 5 THEN 'OTRO' WHEN 6 THEN 'DESPLAZADO REG. CONTRIBUTIVO' WHEN 7 THEN 'DESPLAZADO REG. SUBSIDIADO' WHEN 8 THEN 'DESPLAZADO NO ASEGURADO' 
		   WHEN 9 THEN 'Especial o excepción' WHEN 10 THEN 'Personas privadas de la libertad a cargo del Fondo Nacional de Salud' WHEN 11 THEN 'Tomador / amparado ARL' WHEN 12 THEN 'Tomador / amparado SOAT'  WHEN 13 THEN 'Tomador / amparado planes voluntarios de salud' END AS TipoPaciente,
            CASE IPTIPOAFI WHEN 0 THEN 'NO APLICA' WHEN 1 THEN 'COTIZANTE' WHEN 2 THEN 'BENEFICIARIO' WHEN 3 THEN 'ADICIONAL' WHEN 4 THEN 'JUB/RETIRADO' WHEN 5 THEN 'PENSIONADO' END AS TipoAfiliación, 
           CASE CAPACIPAG WHEN 0 THEN ' ' WHEN 1 THEN 'Total Paciente' WHEN 2 THEN 'Cuota Recuperación' WHEN 3 THEN 'Total Entidad' END AS CapacidadPago, cg.Name AS GrupoAtencion, --A.CCCONTRAT + '-' + A.CPPLANBEN AS CODCONTRATO, C.DESCONTRA AS CONTRATO, 
		   D.UBINOMBRE AS Ubicación, mu.MUNNOMBRE AS Municipio, DEP.nomdepart AS Departamento,E.NIVDESCRI AS Nivel, 
           A.IPDIRECCI AS Direccion, A.IPTELEFON AS Telefono, A.IPTELMOVI AS Celular, A.IPFECNACI as FechaNacimiento, F.desactivi as Actividad, CASE IPSEXOPAC WHEN 1 THEN 'MASCULINO' WHEN 2 THEN 'FEMENINO' END AS Genero, 
           CASE IPESTADOC WHEN 1 THEN 'SOLTERO' WHEN 2 THEN 'CASADO' WHEN 3 THEN 'VIUDO' WHEN 4 THEN 'UNION LIBRE' WHEN 5 THEN 'SEPARADO/DIV' END AS EstadoCivil, I.NIVEDESCRI AS NivelEducativo, J.CREDDESCRI AS Creencia, 
           CASE TIPCOBSAL WHEN 1 THEN 'CONTRIBUTIVO' WHEN 2 THEN 'SUBTOTAL' WHEN 3 THEN 'SUBPARCIAL' WHEN 4 THEN 'CON SISBEN' WHEN 5 THEN 'SIN SISBEN' WHEN 6 THEN 'DESPLAZADOS' WHEN 7 THEN 'PLAN DE SALUD ADICIONAL' WHEN 8 THEN 'OTROS' END AS Cobertura, 
           --CASE GRUPCODIGO WHEN 1 THEN 'CARCELARIOS' WHEN 2 THEN 'DESPLAZADOS' WHEN 3 THEN 'MIGRANTES' WHEN 4 THEN 'GESTANTES' WHEN 5 THEN 'HABITANTES DE LA CALLE' WHEN 4 THEN 'OTRO' END AS GrupoEspecial,
		   CASE DISCCODIGO WHEN 2 THEN 'NO' WHEN 1 THEN 'SI' END AS Discapacidad, 
           A.CORELEPAC AS Correo, G.DESGRUPET AS GrupoEtnico, A.IPESTRATO AS Estrato, CASE ESTADOPAC WHEN 1 THEN 'ACTIVO' WHEN 2 THEN 'INACTIVO' END AS EstadoPaciente, A.OBSERVACI AS Observación, H1.NOMUSUARI AS UsuCrea, h1.DESCARUSU as CargoCrea,A.FECREGCRE AS FechaCreacion, H2.NOMUSUARI AS UsuModifica, h2.DESCARUSU as CargoModifica,
           A.FECREGMOD AS Fecha_Modificacion, 
		   CASE WHEN pais.name is null then 'Colombia' else pais.name end as Pais,  
		   CASE PE1.codigo WHEN 1 THEN 'Adulto Mayor' 
						WHEN 2 THEN 'Menores de 5 años' 
						WHEN 3 THEN 'Gestantes' 
						WHEN 4 THEN 'Discapacidad' 
						WHEN 5 THEN 'Personas con enfermedad mental' 
						WHEN 6 THEN 'Código 003' 
						WHEN 7 THEN 'Población indígena' 
						WHEN 8 THEN 'Población desplazada' 
						WHEN 9 THEN 'Población LGTBI' 
						WHEN 10 THEN 'Población extranjera' 
						when 11 then 'Ninguno'
						when 12 then 'Victimas de maltrato o violencia sexual'
						END AS GrupoPoblacional
FROM   dbo.INPACIENT AS A LEFT OUTER JOIN
		dbo.ADINGRESO WITH (NOLOCK) ON A.IPCODPACI = dbo.ADINGRESO.IPCODPACI LEFT OUTER JOIN
           dbo.INENTIDAD AS B ON B.CODENTIDA = A.CODENTIDA LEFT OUTER JOIN
           dbo.COCONTRAT AS C ON C.CODCONTRA = A.CCCONTRAT LEFT OUTER JOIN
           dbo.INUBICACI AS D ON D.AUUBICACI = A.AUUBICACI LEFT OUTER JOIN
           dbo.INMUNICIP AS mu WITH (NOLOCK) ON mu.DEPMUNCOD = D.DEPMUNCOD LEFT OUTER JOIN
           dbo.INDEPARTA AS DEP WITH (NOLOCK) ON DEP.depcodigo = mu.DEPCODIGO LEFT OUTER JOIN
           .dbo.ADNIVELES AS E   WITH (nolock)  ON E.NIVCODIGO = A.NIVCODIGO LEFT OUTER JOIN
            .dbo.ADACTIVID AS F  WITH (nolock)  ON F.codactivi = A.CODACTIVI LEFT OUTER JOIN
            .dbo.ADGRUETNI AS G  WITH (nolock)  ON G.CODGRUPOE = A.CODGRUPOE LEFT OUTER JOIN
            .dbo.SEGusuaru AS H1  WITH (nolock)  ON H1.CODUSUARI = A.CODUSUCRE LEFT OUTER JOIN
            .dbo.SEGusuaru AS H2  WITH (nolock)  ON H2.CODUSUARI = A.CODUSUMOD LEFT OUTER JOIN
            .dbo.ADNIVELED AS I  WITH (nolock)  ON I.NIVECODIGO = A.NIVECODIGO LEFT OUTER JOIN
            .dbo.ADCREDO AS J  WITH (nolock)  ON J.CREDCODIGO = A.CREDCODIGO left outer join
		   Common.Person as pp  WITH (nolock)  on pp.IdentificationNumber=a.IPCODPACI left outer join
		   common.City as city  WITH (nolock)  on city.Id=A.GENEXPEDITIONCITY left outer join
		   Contract.CareGroup as cg  WITH (nolock)  on cg.id=A.GENCAREGROUP LEFT OUTER JOIN
		   Contract.HealthAdministrator as ha  WITH (nolock)  on ha.Id=a.GENCONENTITY 
		 LEFT OUTER JOIN
                  dbo.ADPOBESPEPAC AS pe WITH (NOLOCK) ON pe.IPCODPACI = a.IPCODPACI and pe.ESTADO=1 left outer JOIN
                  dbo.ADPOBESPE AS PE1 WITH (NOLOCK) ON PE1.ID = pe.IDADPOBESPE 
LEFT OUTER JOIN	Common.Country AS pais WITH (nolock) ON pais.Id =A.IDPAIS
left outer join dbo.ADCENATEN as cen on cen.codcenate = dbo.ADINGRESO.CODCENATE

		   where   (A.ESTADOPAC = '1') AND YEAR(dbo.ADINGRESO.IFECHAING) >= '2024'
		   --and a.IPCODPACI like '%017909167'