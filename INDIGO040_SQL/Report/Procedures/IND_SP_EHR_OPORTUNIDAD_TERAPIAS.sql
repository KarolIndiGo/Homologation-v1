-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_EHR_OPORTUNIDAD_TERAPIAS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


/*******************************************************************************************************************
Nombre:[Report].UploadCubeVieRCMAuthorizations
Tipo:Procedimiento almacenado
Observacion:Este procedimiento almacenado relacionar las ordenes de procedimientos no qx (terapias), con las notas de terapias.
Profesional: Nilsson Galindo
Fecha:2-12-2024
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico:
Fecha:
Observaciones:
-------------------------------------------------------------------------------------------------------------------------------------
Version 3
Persona que modifico:
Fecha:
Observaciones:
***********************************************************************************************************************************/




CREATE PROCEDURE [Report].[IND_SP_EHR_OPORTUNIDAD_TERAPIAS]
@FECINI DATE,
@FECFIN DATE
AS
BEGIN



--DECLARE @FECINI DATE='2024-11-01',@FECFIN DATE='2024-11-30'
    -- Crear una tabla temporal para almacenar los resultados
CREATE TABLE #Resultados 
(
numingres char(10),
numefolio int,
CODSERIPS CHAR(10),
CODCONSEC numeric(18,0)
);

-- Variables para obtener todos los ingresos únicos
DECLARE @numingres char(10);
DECLARE @codserips char(20);
DECLARE @fechaInicio DATETIME;
DECLARE @fechaFin DATETIME;

--se crea cursor para recorrer los numeros de ingreso y servicio ips distintos
DECLARE ingresos_cursor CURSOR FOR
SELECT DISTINCT numingres, ORD.codserips
FROM dbo.HCORDPRON ORD 
INNER JOIN Contract.CUPSEntity CUPS ON ORD.CODSERIPS=CUPS.Code AND CUPS.Description LIKE '%TERAPIA%'
WHERE MANEXTPRO=0 AND CAST(FECORDMED AS DATE) BETWEEN @FECINI AND @FECFIN;

OPEN ingresos_cursor;
FETCH NEXT FROM ingresos_cursor INTO @numingres, @codserips;

WHILE @@FETCH_STATUS = 0
    BEGIN
    -- Crear una tabla temporal para almacenar las órdenes de un ingreso específico
    CREATE TABLE #Ordenes (
    orden_id INT IDENTITY(1,1),
    FECORDMED DATETIME );
-- Insertar las fechas de las órdenes en la tabla temporal
    INSERT INTO #Ordenes (FECORDMED)
    SELECT FECORDMED
    FROM dbo.HCORDPRON
    WHERE numingres = @numingres AND codserips = @codserips
    ORDER BY FECORDMED;

    DECLARE @i INT = 1;
    DECLARE @max INT;

    -- Obtener el número máximo de órdenes
    SELECT @max = COUNT(*) FROM #Ordenes;

    -- Iterar sobre cada orden
    WHILE @i <= @max
        BEGIN
        -- Obtener la fecha de inicio de la orden actual
        SELECT @fechaInicio = FECORDMED FROM #Ordenes WHERE orden_id = @i;
		-- Obtener la fecha de fin de la siguiente orden o la fecha máxima si es la última orden
        IF @i < @max
			SELECT @fechaFin = FECORDMED FROM #Ordenes WHERE orden_id = @i + 1;
        ELSE
			SELECT @fechaFin = '9999-12-31'; -- Fecha máxima para la última orden
-- Insertar las terapias correspondientes en la tabla de resultados
        INSERT INTO #Resultados (numingres,numefolio,CODSERIPS,CODCONSEC)
            SELECT 
                o.numingres,
				o.NUMEFOLIO,
                o.codserips,
                --o.FECORDMED,
                --t.FECHISPAC,
				t.CODCONSEC
            FROM dbo.HCORDPRON o
            LEFT JOIN dbo.HCPROCTER t ON  o.numingres = t.numingres AND o.codserips = t.codserips
																	AND t.FECHISPAC > @fechaInicio
																	AND t.FECHISPAC <= @fechaFin
            WHERE o.numingres = @numingres AND o.codserips = @codserips AND o.FECORDMED = @fechaInicio;

            SET @i = @i + 1;
        END;

        -- Eliminar la tabla temporal de órdenes
        DROP TABLE #Ordenes;

        FETCH NEXT FROM ingresos_cursor INTO @numingres, @codserips;
    END;

    CLOSE ingresos_cursor;
    DEALLOCATE ingresos_cursor;

    -- Seleccionar los resultados

SELECT
CEN.NOMCENATE AS [CENTRO DE ATENCION],
TIP.SIGLA AS [TIPO IDENTIFICACION],
PAC.IPCODPACI AS [IDENTIFICACION],
PAC.IPNOMCOMP AS [NOMBRE PACIENTE],
CONCAT(DATEDIFF(YEAR, PAC.IPFECNACI, ORD.FECORDMED) - CASE WHEN MONTH(PAC.IPFECNACI) > MONTH(ORD.FECORDMED) OR 
(MONTH(PAC.IPFECNACI) = MONTH(ORD.FECORDMED) AND DAY(PAC.IPFECNACI) > DAY(ORD.FECORDMED)) THEN 1 ELSE 0 END, ' Años, ', DATEDIFF(MONTH, PAC.IPFECNACI, ORD.FECORDMED) % 12 - 
CASE WHEN DAY(PAC.IPFECNACI) > DAY(ORD.FECORDMED) THEN 1 ELSE 0 END, ' Meses, ', DAY(ORD.FECORDMED) - DAY(PAC.IPFECNACI) + 
CASE WHEN DAY(ORD.FECORDMED) < DAY(PAC.IPFECNACI) THEN DAY(EOMONTH(PAC.IPFECNACI, 0)) ELSE 0 END, ' Dias') AS EDAD,
CASE PAC.IPSEXOPAC WHEN '1' THEN 'MASCULINO' ELSE 'FEMENINO' END AS [SEXO],
PAC.IPTELEFON AS [TELEFONO FIJO], 
PAC.IPTELMOVI AS [TELEFONO MOVIL], 
PAC.IPDIRECCI AS DIRECCION,
EA.HealthEntityCode AS [CODIGO EPS/ENTIDAD TERRITORIAL],
EA.CODE + ' - ' + EA.NAME AS [ENTIDAD ADMINISTRADORA], 
GA.CODE [CODIGO GRUPO ATENCION], 
GA.CODE + ' - ' + GA.NAME [GRUPO ATENCION],
CASE GA.LIQUIDATIONTYPE WHEN 1 THEN 'PAGO POR SERVICIOS'
						WHEN 2 THEN 'PGP'
						WHEN 3 THEN 'FACTURA GLOBAL'
						WHEN 4 THEN 'CAPITACION GLOBAL'
						WHEN 5 THEN 'CONTROL'END [TIPO CONTRATO],
CUPS.Code AS [CODIGO CUPS],
CUPS.Description AS [DESCRIPCION SERVICIO],
CG.CODE + '-' + CG.NAME [GRUPO], 
CSG.CODE + '-' + CSG.NAME [SUBGRUPO], 
REL.CODE+' - '+REL.Name AS [DESCRIPCION RELACIONADA],
CASE WHEN MANEXTPRO = 0 THEN 'HOSPITALARIO' ELSE 'AMBULATORIO' END AS [TIPO SOLICITUD], 
'TERAPIA' [TIPO ORDEN], 
RTRIM(ORD.UFUCODIGO) + ' - ' + D.UFUDESCRI AS [UNIDAD FUNCIONAL SOLICITUD],
RES.numingres AS [INGRESO],
RES.numefolio AS [FOLIO ORDEN],
ORD.FECORDMED AS [FECHA SOLICITUD ORDEN],
ORD.CANSERIPS AS CANTIDAD,
RTRIM(ORD.CODPROSAL)+' - '+PRO.NOMMEDICO AS [PROFESIONAL ORDENAMIENTO],
ESP.DESESPECI AS [ESPECIALIDAD ORDENAMIENTO],
ORD.OBSSERIPS AS [OBSERVACION ORDENAMIENTO],
DIAG.CODDIAGNO+' - '+DIAG.NOMDIAGNO AS [DX PRINCIPAL ORDENAMIENTO],
TER.FECHISPAC AS [FECHA REALIZACION],
RTRIM(FUN.UFUCODIGO)+' - '+FUN.UFUDESCRI AS [UNIDAD FUNCIONA REALIZACION],
RTRIM(PROR.CODPROSAL)+' - '+PROR.NOMMEDICO AS [PROFESIONAL REALIZACION],
ESPR.DESESPECI AS [ESPECIALIDAD REALIZACION],
CONVERT(VARCHAR,DATEDIFF(MINUTE,ORD.FECORDMED,TER.FECHISPAC)/60)+','+REPLACE(CONVERT(VARCHAR,CONVERT(INT,ROUND((DATEDIFF(MINUTE,ORD.FECORDMED,TER.FECHISPAC)%60)/0.60,0))),'-','') AS [FECHA ORDEN VS FECHA REALIZACION HORAS],
CAST(ORD.FECORDMED AS DATE) [FECHA BUSQUEDA],
 YEAR(ORD.FECORDMED) AS [AÑO FECHA BUSQUEDA], 
 MONTH(ORD.FECORDMED) AS [MES FECHA BUSQUEDA],
 CASE MONTH(ORD.FECORDMED) WHEN 1 THEN 'ENERO'
						 WHEN 2 THEN 'FEBRERO'
						 WHEN 3 THEN 'MARZO'
						 WHEN 4 THEN 'ABRIL'
						 WHEN 5 THEN 'MAYO'
						 WHEN 6 THEN 'JUNIO'
						 WHEN 7 THEN 'JULIO'
						 WHEN 8 THEN 'AGOSTO'
						 WHEN 9 THEN 'SEPTIEMBRE'
						 WHEN 10 THEN 'OCTUBRE'
						 WHEN 11 THEN 'NOVIEMBRE'
						 WHEN 12 THEN 'DICIEMBRE' END AS [MES NOMBRE FECHA BUSQUEDA], 
 DAY(ORD.FECORDMED) AS [DIA FECHA BUSQUEDA],
 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
FROM
#Resultados RES
INNER JOIN DBO.HCORDPRON ORD ON RES.numingres=ORD.NUMINGRES AND RES.numefolio=ORD.NUMEFOLIO AND RES.CODSERIPS=ORD.CODSERIPS
INNER JOIN DBO.ADCENATEN CEN ON ORD.CODCENATE=CEN.CODCENATE
INNER JOIN dbo.ADINGRESO ING ON RES.NUMINGRES=ING.NUMINGRES
INNER JOIN dbo.INPACIENT PAC ON ING.IPCODPACI=PAC.IPCODPACI
INNER JOIN dbo.ADTIPOIDENTIFICA TIP ON PAC.IPTIPODOC=TIP.CODIGO
INNER JOIN CONTRACT.CAREGROUP AS GA ON ING.GENCAREGROUP=GA.ID
INNER JOIN CONTRACT.HEALTHADMINISTRATOR AS EA ON ING.GENCONENTITY=EA.ID
INNER JOIN Contract.CUPSEntity CUPS ON RES.CODSERIPS=CUPS.Code
INNER JOIN CONTRACT.CUPSSUBGROUP AS CSG ON CUPS.CUPSSUBGROUPID=CSG.ID
INNER JOIN CONTRACT.CUPSGROUP AS CG ON CSG.CUPSGROUPID=CG.ID
INNER JOIN DBO.INUNIFUNC D ON ORD.UFUCODIGO=D.UFUCODIGO
INNER JOIN DBO.INPROFSAL PRO ON ORD.CODPROSAL=PRO.CODPROSAL
INNER JOIN DBO.INESPECIA AS ESP ON PRO.CODESPEC1=ESP.CODESPECI
INNER JOIN dbo.HCHISPACA AS HIS ON RES.numingres=HIS.NUMINGRES AND RES.numefolio=HIS.NUMEFOLIO
INNER JOIN DBO.INDIAGNOS AS DIAG ON HIS.CODDIAGNO=DIAG.CODDIAGNO
INNER JOIN dbo.HCPROCTER AS TER ON RES.CODCONSEC=TER.CODCONSEC
INNER JOIN DBO.INUNIFUNC FUN ON TER.UFUCODIGO=FUN.UFUCODIGO
INNER JOIN DBO.INPROFSAL PROR ON TER.CODPROSAL=PROR.CODPROSAL
INNER JOIN DBO.INESPECIA AS ESPR ON PROR.CODESPEC1=ESPR.CODESPECI
LEFT JOIN contract.CUPSEntityContractDescriptions DERE ON TER.IDDESCRIPCIONRELACIONADA=DERE.Id
LEFT JOIN Contract.ContractDescriptions REL ON DERE.ContractDescriptionId=REL.Id
;

    -- Eliminar la tabla temporal de resultados
    DROP TABLE #Resultados;
END;

