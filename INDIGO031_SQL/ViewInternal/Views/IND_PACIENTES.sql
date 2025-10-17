-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IND_PACIENTES
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IND_PACIENTES] AS
     SELECT CASE PA.IPTIPODOC
                WHEN 1 THEN 'CC'
                WHEN 2 THEN 'CE'
                WHEN 3 THEN 'TI'
                WHEN 4 THEN 'RC'
                WHEN 5 THEN 'PA'
                WHEN 6 THEN 'AS'
                WHEN 7 THEN 'MS'
                WHEN 8 THEN 'NU'
            END AS TIPO_DOCUMENTO, 
            PA.IPCODPACI AS 'NUM_DOCUMENTO', 
            PA.IPNOMCOMP AS 'PACIENTE', 
            PA.IPDIRECCI AS 'DIRECCION', 
            PA.IPTELEFON AS 'TEL_FIJO', 
            PA.IPTELMOVI AS 'TEL_MOVIL',
            CASE PA.IPSEXOPAC
                WHEN 1 THEN 'M'
                WHEN 2 THEN 'F'
                WHEN 3 THEN 'Í'
            END AS "SEXO",
            CASE PA.[CODGRUPOE]
                WHEN '000' THEN 'NINGUNO'
                WHEN '001' THEN 'INDIGENA'
                WHEN '002' THEN 'AFROCOLOMBIANOS NEGROS MULATOS O AFRODESCENDIENTES'
                WHEN '003' THEN 'RAIZALES SAN ANDRES Y PROVIDENCIA'
                WHEN '004' THEN 'PUEBLO ROM GITANOS'
                WHEN '005' THEN 'PALENQUEROS DE SAN BASILIO'
            END AS 'GRUPO ETNICO', 
            PA.GRUPCODIGO AS 'COD_GRUPO_ETNICO', 
            PA.AUUBICACI AS 'UBICACION', 
            UB.UBINOMBRE AS 'NOMBRE_UBICACION',
			PA.CORELEPAC AS EMAIL,
			CASE PA.ESTADOPAC
                WHEN 0 THEN 'Inactivo'
                WHEN 1 THEN 'Activo'
            END AS 'EstadoPaciente',
			PA.CODUSUCRE AS 'UsuarioCrea',
			PA.FECREGCRE AS 'FechaCrea',
			PA.CODUSUMOD AS 'UsuarioModifica',
			PA.FECREGMOD AS 'FechaModifica',
			DI.DISCDESCRI AS 'Discapacidad' --CASO 259667
     FROM dbo.INPACIENT AS PA
          INNER JOIN dbo.INUBICACI AS UB ON UB.AUUBICACI = PA.AUUBICACI
		  LEFT JOIN dbo.ADDISCAPACI AS DI ON PA.DISCCODIGO = DI.DISCCODIGO 
