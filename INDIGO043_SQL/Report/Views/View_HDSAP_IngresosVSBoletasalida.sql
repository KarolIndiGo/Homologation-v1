-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_IngresosVSBoletasalida
-- Extracted by Fabric SQL Extractor SPN v3.9.0









CREATE VIEW [Report].[View_HDSAP_INGRESOSVSBOLETASALIDA] 
as






WITH CTE_CAMAS_OCUPADA AS
 (
  SELECT  
   FUN.UFUDESCRI AS 'UNIDAD FUNCIONAL',
   C.IPCODPACI 'IDENTIFICACION',
   C.NUMINGRES 'INGRESO',
   A.NUMCAMHOS 'NumCama',
   A.DESCCAMAS 'NOMBRE CAMA',
   G.DESTIPEST 'TIPO ESTANCIA',
   C.ID  'ID_ESTANCIA', 
   A.CODICAMAS 'ID_CAMAS',
   CEN.NOMCENATE 'CENTRO DE ATENCION',
   A.CODCLAHAB ,
   A.CODCLACAM 
  FROM 
   dbo.CHCAMASHO A
   INNER JOIN DBO.INUNIFUNC FUN ON A.UFUCODIGO =FUN.UFUCODIGO 
   LEFT JOIN dbo.CHREGESTA C ON A.CODICAMAS=C.CODICAMAS AND C.REGESTADO = 1 
   LEFT JOIN dbo.CHTIPESTA G ON G.CODTIPEST=C.CODTIPEST 
   LEFT JOIN DBO.ADCENATEN CEN ON CEN.CODCENATE =A.CODCENATE 
 ),
 MaxFechasSalida AS (
    SELECT
        s.AdmissionNumber,
        MAX(s.CreationDate) AS MaxFechaSalida
    FROM
        Billing.SlipOut s
    GROUP BY
        s.AdmissionNumber
),
OrdenServicioCTE AS (
    SELECT
        sd.CreationUser,
        sd.AdmissionNumber,
        sd.CreationDate,
        ROW_NUMBER() OVER (PARTITION BY sd.AdmissionNumber ORDER BY sd.CreationDate DESC) AS RowNum
    FROM
        Billing.ServiceOrder sd
    WHERE
        sd.entityname LIKE '%serviceorder%'
),
DatosFiltrados AS (
    SELECT 
        DISTINCT
        i.ipnomcomp AS NombrePaciente,
        i.ipcodpaci AS Doc_Paciente,
        a.numingres AS Ingreso,
        a.ifechaing AS FechaIngresoPaciente,
        mf.MaxFechaSalida AS FechaBoletaSalida,
		CM.NumCama,
        CONCAT(s.CreationUser, '-', p4.Fullname) AS UsuarioCreaBoleta,
        CONCAT(sd.CreationUser, '-', p2.Fullname) AS CodigoUsuarioCreaOrdeServicio,
        sd.CreationDate AS FechaCreacionOrdenServicio,
		Q.MATERADIC AS Materiales,
        CONCAT(a.CODUSUCRE, '-', p3.Fullname) AS UsuarioCreaIngreso,
        CONCAT(a.CODUSUMOD, '-', p.fullname) AS UsuarioModificaIngreso,
        cas.Detail AS DetalleReciboCaja,
        uni.UFUDESCRI AS UnidadFuncionalEgreso,
        CASE 
            WHEN a.IESTADOIN = ' ' THEN 'Abierto'
            WHEN a.IESTADOIN = 'P' THEN 'Parcial'
            ELSE 'Otros'
        END AS EstadoIngreso,
        CASE 
            WHEN a.TIPOINGRE = 1 THEN 'Ambulatorio'
            WHEN a.TIPOINGRE = 2 THEN 'HOSPITALARIO'
        END AS TipoIngreso,
        n.NOMENTIDA AS Entidad,
        a.IOBSERVAC AS ObservacionIngreso,
        RCD.Observation AS ObservacionFolio,
        CASE 
            WHEN COALESCE(mf.MaxFechaSalida, '') = '' THEN 'Hospitalizado'
            ELSE CONCAT(s.CreationUser, '-', p4.Fullname)
        END AS Responsable,
        ROW_NUMBER() OVER (PARTITION BY a.NUMINGRES ORDER BY mf.MaxFechaSalida DESC) AS Dato

    FROM       ADINGRESO a
    LEFT JOIN  Billing.RevenueControl RC ON RC.AdmissionNumber = a.NUMINGRES AND RC.PatientCode = a.IPCODPACI
    LEFT JOIN  Billing.RevenueControlDetail RCD ON RCD.RevenueControlId = RC.ID
	LEFT JOIN  HCQXINFOR Q ON Q.NUMINGRES = A.NUMINGRES
    LEFT JOIN  INUNIFUNC uni ON uni.ufucodigo = a.UFUEGRHOS
    LEFT JOIN  Portfolio.PortfolioAdvance POR ON POR.AdmissionNumber = RC.AdmissionNumber
    LEFT JOIN  Treasury.CashReceipts cas ON cas.id = por.CashReceiptId
	LEFT JOIN  CTE_CAMAS_OCUPADA CM ON CM.INGRESO = A.NUMINGRES
    INNER JOIN inpacient i ON i.ipcodpaci = a.ipcodpaci
    INNER JOIN inentidad n ON n.CODENTIDA = a.CODENTIDA
    LEFT JOIN  Security.[User] su ON su.UserCode = a.CODUSUMOD
    LEFT JOIN  Security.Person AS p ON p.Id = su.IdPerson
    LEFT JOIN  Security.[User] su3 ON su3.UserCode = a.CODUSUCRE
    LEFT JOIN  Security.Person AS p3 ON p3.Id = su3.IdPerson
    LEFT JOIN
        (
            SELECT MAX(s.CreationDate) AS CreationDate, s.AdmissionNumber, s.CreationUser
            FROM Billing.SlipOut s 
            GROUP BY s.AdmissionNumber, s.CreationUser
        ) s ON s.AdmissionNumber = a.NUMINGRES 
    LEFT JOIN   Security.[User] su4 ON su4.UserCode = s.CreationUser
    LEFT JOIN   Security.Person AS p4 ON p4.Id = su4.IdPerson
    LEFT JOIN   OrdenServicioCTE sd ON sd.AdmissionNumber = a.NUMINGRES AND sd.RowNum = 1
    LEFT JOIN   Security.[User] su2 ON su2.UserCode = sd.CreationUser
    LEFT JOIN   Security.Person AS p2 ON p2.Id = su2.IdPerson
    LEFT JOIN   MaxFechasSalida mf ON mf.AdmissionNumber = a.NUMINGRES
    WHERE  
        a.IESTADOIN IN (' ', 'P')-- AND A.NUMINGRES = '3067617 '
)
SELECT *
FROM DatosFiltrados
WHERE Dato = 1;
