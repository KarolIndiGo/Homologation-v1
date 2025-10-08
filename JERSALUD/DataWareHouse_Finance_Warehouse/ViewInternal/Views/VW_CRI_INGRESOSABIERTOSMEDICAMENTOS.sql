-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_CRI_INGRESOSABIERTOSMEDICAMENTOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_CRI_INGRESOSABIERTOSMEDICAMENTOS
AS  
     SELECT DISTINCT   
            A.IPCODPACI AS CEDULA,  
            CASE A.IPTIPODOC  
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
            END AS TIPODOCUMENTO,   
            A.CODIGONIT AS Tercero,   
            A.IPNOMCOMP AS PACIENTE,  
            CASE IPTIPOPAC  
                WHEN 1  
                THEN 'CONTRIBUTIVO'  
                WHEN 2  
                THEN 'SUBSIDIADO'  
                WHEN 3  
                THEN 'VINCULADO'  
                WHEN 4  
                THEN 'PARTICULAR'  
                WHEN 5  
                THEN 'OTRO'  
                WHEN 6  
                THEN 'DESPLAZADO REG. CONTRIBUTIVO'  
                WHEN 7  
                THEN 'DESPLAZADO REG. SUBSIDIADO'  
                WHEN 8  
                THEN 'DESPLAZADO NO ASEGURADO'  
            END AS TIPOPACIENTE,  
            CASE A.IPTIPOAFI  
                WHEN 0  
                THEN 'NO APLICA'  
                WHEN 1  
                THEN 'COTIZANTE'  
                WHEN 2  
                THEN 'BENEFICIARIO'  
                WHEN 3  
                THEN 'ADICIONAL'  
                WHEN 4  
                THEN 'JUB/RETIRADO'  
                WHEN 5  
                THEN 'PENSIONADO'  
            END AS TIPOAFILIACION,  
            CASE A.CAPACIPAG  
                WHEN 0  
                THEN 'NO APLICA'  
                WHEN 1  
                THEN 'SI'  
                WHEN 2  
                THEN 'NO'  
                WHEN 3  
                THEN 'DESPLAZADO'  
            END AS CAPACIDADPAGO,   
            B.NOMENTIDA AS ENTIDAD,   
            A.IPDIRECCI AS DIRECCION,   
            A.IPTELEFON AS TELEFONO,   
            A.IPTELMOVI AS MOVIL,   
            A.IPFECNACI AS FechaNacimiento,  
            CASE A.IPSEXOPAC  
                WHEN 1  
                THEN 'MASCULINO'  
                WHEN 2  
                THEN 'FEMENINO'  
            END AS SEXO,  
            CASE A.IPESTADOC  
                WHEN 1  
                THEN 'SOLTERO'  
                WHEN 2  
                THEN 'CASADO'  
                WHEN 3  
                THEN 'VIUDO'  
                WHEN 4  
                THEN 'UNION LIBRE'  
                WHEN 5  
                THEN 'SEPARADO/DIV'  
            END AS ESTADOCIVIL,  
            CASE A.TIPCOBSAL  
                WHEN 1  
                THEN 'CONTRIBUTIVO'  
                WHEN 2  
                THEN 'SUBTOTAL'  
                WHEN 3  
                THEN 'SUBPARCIAL'  
                WHEN 4  
                THEN 'CON SISBEN'  
                WHEN 5  
                THEN 'SIN SISBEN'  
                WHEN 6  
                THEN 'DESPLAZADOS'  
                WHEN 7  
                THEN 'PLAN DE SALUD ADICIONAL'  
                WHEN 8  
                THEN 'OTROS'  
            END AS COBERTURA,   
            A.CORELEPAC AS CORREO,  
            CASE ESTADOPAC  
                WHEN 1  
                THEN 'ACTIVO'  
                WHEN 2  
                THEN 'INACTIVO'  
            END AS ESTADOPACIENTE,   
            A.OBSERVACI AS OBSERVACION,   
            H1.NOMUSUARI AS EMP_CREA,   
            I.FECREGCRE AS FECHA_CREA,   
            H2.NOMUSUARI AS EMP_MODI,   
            I.FECREGMOD AS FECHA_MODIFICA,   
            I.IFECHAING AS FechaIngreso,  
            CASE I.TIPOINGRE  
                WHEN 1  
                THEN 'Ambulatorio'  
                WHEN 2  
                THEN 'Hospitalario'  
            END AS TipoIngreso,   
            U.UFUDESCRI AS Unidad,  
            CASE I.IINGREPOR  
                WHEN 1  
                THEN 'Urgencias'  
                WHEN 2  
          THEN 'Consulta Externa'  
                WHEN 3  
                THEN 'Nacido Hospital'  
                WHEN 4  
                THEN 'Remitido'  
                WHEN 5  
                THEN 'HospitalizacionURG'  
            END AS IngresoPOR,  
            CASE I.ICAUSAING  
                WHEN 1  
                THEN 'Heridos en Combate'  
                WHEN 2  
                THEN 'Enfermedad Profesional'  
                WHEN 3  
                THEN 'Emfermedad General Adulto'  
                WHEN 4  
                THEN 'Enfermedad General Pediatrica'  
                WHEN 1  
                THEN 'Odontologia'  
                WHEN 6  
                THEN 'Accidente de Transito'  
                WHEN 7  
                THEN 'Catastrofe'  
            END AS Causa,   
            I.NUMINGRES,   
            CA.NOMCENATE AS Sede,   
            GA.Code AS Cod_Grupo_Atencion,   
            GA.Name AS Grupo_Atencion,
			
			H.CODDIAGNO as DX,
			CIE10.NOMDIAGNO AS Diagnóstico,

            IIF(H.NUMEFOLIO IS NULL, 'SIN HC', 'CON HC') AS Tiene_HC,   
            I.CODPROING AS [Codigo Profesional Ingreso],   
     (  
         SELECT NOMMEDICO  
         FROM [INDIGO031].[dbo].[INPROFSAL]  
         WHERE CODPROSAL = I.CODPROING  
     ) AS Profesional_Ingreso  
     FROM [INDIGO031].[dbo].[INPACIENT] AS A   
          INNER JOIN [INDIGO031].[dbo].[ADINGRESO] AS I  ON A.IPCODPACI = I.IPCODPACI  
                                                                          AND I.IESTADOIN = ''  
          LEFT JOIN [INDIGO031].[Billing].[ServiceOrder] AS O  ON O.AdmissionNumber = I.NUMINGRES  
          LEFT JOIN [INDIGO031].[Billing].[ServiceOrderDetail] AS OD  ON OD.ServiceOrderId = O.Id  
          INNER JOIN [INDIGO031].[Contract].[CareGroup] AS GA  ON GA.Id = OD.CareGroupId  
          INNER JOIN [INDIGO031].[dbo].[INENTIDAD] AS B  ON I.CODENTIDA = B.CODENTIDA  
          INNER JOIN [INDIGO031].[dbo].[SEGusuaru] AS H1  ON H1.CODUSUARI = I.CODUSUCRE  
          LEFT OUTER JOIN [INDIGO031].[dbo].[SEGusuaru] AS H2  ON H2.CODUSUARI = I.CODUSUMOD  
          INNER JOIN [INDIGO031].[dbo].[INUNIFUNC] AS U  ON I.UFUACTPAC = U.UFUCODIGO  
          INNER JOIN [INDIGO031].[dbo].[ADCENATEN] AS CA  ON I.CODCENATE = CA.CODCENATE  
          LEFT JOIN [INDIGO031].[dbo].[HCHISPACA] AS H  ON H.NUMINGRES = I.NUMINGRES
		  LEFT JOIN [INDIGO031].[dbo].[INDIAGNOS] AS CIE10  ON CIE10.CODDIAGNO = H.CODDIAGNO
	WHERE GA.Name LIKE '%MEDICAMENTOS%'
