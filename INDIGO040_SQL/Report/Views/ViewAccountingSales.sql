-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewAccountingSales
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [Report].[ViewAccountingSales] AS
     WITH CTE_AÑO_ACTUAL
          AS (SELECT ISNULL(NIT, 0) NIT, 
                     CLIENTE, 
                     CENTROCOSTO, 
                     [DESCRIPCION CENTRO COSTO], 
                     [CENTRO ATENCION], 
                     YEAR(GETDATE()) AÑO, 
                     ISNULL([1], 0) AS 'ENERO', 
                     ISNULL([2], 0) AS 'FEBRERO', 
                     ISNULL([3], 0) AS 'MARZO', 
                     ISNULL([4], 0) AS 'ABRIL', 
                     ISNULL([5], 0) AS 'MAYO', 
                     ISNULL([6], 0) AS 'JUNIO', 
                     ISNULL([7], 0) AS 'JULIO', 
                     ISNULL([8], 0) AS 'AGOSTO', 
                     ISNULL([9], 0) AS 'SEPTIEMBRE', 
                     ISNULL([10], 0) AS 'OCTUBRE', 
                     ISNULL([11], 0) AS 'NOVIEMBRE', 
                     ISNULL([12], 0) AS 'DICIEMBRE', 
                     'CONTABILIDAD' ORIGEN, 
                     'VENTAS EJECUTADAS' AS LOGICA
              FROM
              (
                  SELECT SC.MONTH AS MES, 
                         T.NIT, 
                         T.NAME AS CLIENTE, 
                         CCO.CODE AS CENTROCOSTO, 
                         CCO.NAME AS [DESCRIPCION CENTRO COSTO], 
                         BO.NAME AS [CENTRO ATENCION], --AC.DESCRIPCION AS AGRUPADOR,
                         CASE
                             WHEN SC.MONTH = '1'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '2'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '3'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '4'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '5'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '6'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '7'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '8'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '9'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '10'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '11'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '12'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                         END ACUMULADO
                  FROM GENERALLEDGER.GENERALLEDGERBALANCE AS SC WITH(NOLOCK)
                       INNER JOIN COMMON.THIRDPARTY AS T WITH(NOLOCK) ON T.ID = SC.IDTHIRDPARTY
                       LEFT JOIN PAYROLL.COSTCENTER AS CCO WITH(NOLOCK) ON CCO.ID = SC.IDCOSTCENTER
                       LEFT JOIN PAYROLL.BRANCHOFFICE AS BO WITH(NOLOCK) ON CCO.BRANCHOFFICEID = BO.ID
                       LEFT JOIN GENERALLEDGER.MAINACCOUNTS AS C WITH(NOLOCK) ON C.ID = SC.IDMAINACCOUNT --LEFT JOIN
                  --INDIGODWH.GENERALLEDGER.DWH_AGRUPADORES_CONTABILIDAD AS AC WITH (NOLOCK) ON AC.CODECC=CCO.CODE 
                  WHERE(T.PERSONTYPE = '2')
                       AND (C.LEGALBOOKID = '1')
                       AND (C.NUMBER BETWEEN '41' AND '41999999')
                       AND YEAR = YEAR(GETDATE())
                  GROUP BY T.NIT, 
                           T.NAME, 
                           CCO.CODE, 
                           CCO.NAME, 
                           SC.MONTH, 
                           SC.YEAR, 
                           BO.NAME--,AC.DESCRIPCION

                  UNION
                  SELECT SC.MONTH AS MES, 
                         0 NIT, 
                         'PERSONAS NATURALES' AS CLIENTE, 
                         CCO.CODE AS CENTROCOSTO, 
                         CCO.NAME AS [DESCRIPCION CENTRO COSTO], 
                         BO.NAME AS [CENTRO ATENCION], --AC.DESCRIPCION AS AGRUPADOR,
                         CASE
                             WHEN SC.MONTH = '1'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '2'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '3'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '4'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '5'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '6'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '7'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '8'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '9'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '10'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '11'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '12'
                                  AND SC.YEAR = YEAR(GETDATE())
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                         END ACUMULADO
                  FROM GENERALLEDGER.GENERALLEDGERBALANCE AS SC WITH(NOLOCK)
                       INNER JOIN COMMON.THIRDPARTY AS T WITH(NOLOCK) ON T.ID = SC.IDTHIRDPARTY
                       LEFT JOIN PAYROLL.COSTCENTER AS CCO WITH(NOLOCK) ON CCO.ID = SC.IDCOSTCENTER
                       LEFT JOIN PAYROLL.BRANCHOFFICE AS BO WITH(NOLOCK) ON CCO.BRANCHOFFICEID = BO.ID
                       LEFT JOIN GENERALLEDGER.MAINACCOUNTS AS C WITH(NOLOCK) ON C.ID = SC.IDMAINACCOUNT --LEFT JOIN
                  --INDIGODWH.GENERALLEDGER.DWH_AGRUPADORES_CONTABILIDAD AS AC WITH (NOLOCK) ON AC.CODECC=CCO.CODE 
                  WHERE(T.PERSONTYPE = '1')
                       AND (C.LEGALBOOKID = '1')
                       AND (C.NUMBER BETWEEN '41' AND '41999999')
                       AND YEAR = YEAR(GETDATE())
                  GROUP BY CCO.CODE, 
                           CCO.NAME, 
                           SC.MONTH, 
                           SC.YEAR, 
                           BO.NAME--,AC.DESCRIPCION
              ) DET PIVOT(SUM(ACUMULADO) FOR MES IN([1], 
                                                    [2], 
                                                    [3], 
                                                    [4], 
                                                    [5], 
                                                    [6], 
                                                    [7], 
                                                    [8], 
                                                    [9], 
                                                    [10], 
                                                    [11], 
                                                    [12])) AS PIV
              --ORDER BY 1,2,3,4,5,6
              ),
          CTE_AÑO_ANTERIOR
          AS (SELECT ISNULL(NIT, 0) NIT, 
                     CLIENTE, 
                     CENTROCOSTO, 
                     [DESCRIPCION CENTRO COSTO], 
                     [CENTRO ATENCION], 
                     YEAR(GETDATE()) - 1 AÑO, 
                     ISNULL([1], 0) AS 'ENERO', 
                     ISNULL([2], 0) AS 'FEBRERO', 
                     ISNULL([3], 0) AS 'MARZO', 
                     ISNULL([4], 0) AS 'ABRIL', 
                     ISNULL([5], 0) AS 'MAYO', 
                     ISNULL([6], 0) AS 'JUNIO', 
                     ISNULL([7], 0) AS 'JULIO', 
                     ISNULL([8], 0) AS 'AGOSTO', 
                     ISNULL([9], 0) AS 'SEPTIEMBRE', 
                     ISNULL([10], 0) AS 'OCTUBRE', 
                     ISNULL([11], 0) AS 'NOVIEMBRE', 
                     ISNULL([12], 0) AS 'DICIEMBRE', 
                     'CONTABILIDAD' ORIGEN, 
                     'VENTAS EJECUTADAS' AS LOGICA
              FROM
              (
                  SELECT SC.MONTH AS MES, 
                         T.NIT, 
                         T.NAME AS CLIENTE, 
                         CCO.CODE AS CENTROCOSTO, 
                         CCO.NAME AS [DESCRIPCION CENTRO COSTO], 
                         BO.NAME AS [CENTRO ATENCION], --AC.DESCRIPCION AS AGRUPADOR,
                         CASE
                             WHEN SC.MONTH = '1'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '2'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '3'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '4'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '5'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '6'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '7'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '8'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '9'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '10'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '11'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '12'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                         END ACUMULADO
                  FROM GENERALLEDGER.GENERALLEDGERBALANCE AS SC WITH(NOLOCK)
                       INNER JOIN COMMON.THIRDPARTY AS T WITH(NOLOCK) ON T.ID = SC.IDTHIRDPARTY
                       LEFT JOIN PAYROLL.COSTCENTER AS CCO WITH(NOLOCK) ON CCO.ID = SC.IDCOSTCENTER
                       LEFT JOIN PAYROLL.BRANCHOFFICE AS BO WITH(NOLOCK) ON CCO.BRANCHOFFICEID = BO.ID
                       LEFT JOIN GENERALLEDGER.MAINACCOUNTS AS C WITH(NOLOCK) ON C.ID = SC.IDMAINACCOUNT --LEFT JOIN
                  --INDIGODWH.GENERALLEDGER.DWH_AGRUPADORES_CONTABILIDAD AS AC WITH (NOLOCK) ON AC.CODECC=CCO.CODE 
                  WHERE(T.PERSONTYPE = '2')
                       AND (C.LEGALBOOKID = '1')
                       AND (C.NUMBER BETWEEN '41' AND '41999999')
                       AND YEAR = YEAR(GETDATE()) - 1
                  GROUP BY T.NIT, 
                           T.NAME, 
                           CCO.CODE, 
                           CCO.NAME, 
                           SC.MONTH, 
                           SC.YEAR, 
                           BO.NAME--,AC.DESCRIPCION

                  UNION
                  SELECT SC.MONTH AS MES, 
                         0 NIT, 
                         'PERSONAS NATURALES' AS CLIENTE, 
                         CCO.CODE AS CENTROCOSTO, 
                         CCO.NAME AS [DESCRIPCION CENTRO COSTO], 
                         BO.NAME AS [CENTRO ATENCION], --AC.DESCRIPCION AS AGRUPADOR,
                         CASE
                             WHEN SC.MONTH = '1'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '2'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '3'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '4'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '5'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '6'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '7'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '8'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '9'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '10'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '11'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                             WHEN SC.MONTH = '12'
                                  AND SC.YEAR = YEAR(GETDATE()) - 1
                             THEN((SUM(SC.DEBITVALUE) - SUM(SC.CREDITVALUE))) * -1
                         END ACUMULADO
                  FROM GENERALLEDGER.GENERALLEDGERBALANCE AS SC WITH(NOLOCK)
                       INNER JOIN COMMON.THIRDPARTY AS T WITH(NOLOCK) ON T.ID = SC.IDTHIRDPARTY
                       LEFT JOIN PAYROLL.COSTCENTER AS CCO WITH(NOLOCK) ON CCO.ID = SC.IDCOSTCENTER
                       LEFT JOIN PAYROLL.BRANCHOFFICE AS BO WITH(NOLOCK) ON CCO.BRANCHOFFICEID = BO.ID
                       LEFT JOIN GENERALLEDGER.MAINACCOUNTS AS C WITH(NOLOCK) ON C.ID = SC.IDMAINACCOUNT --LEFT JOIN
                  --INDIGODWH.GENERALLEDGER.DWH_AGRUPADORES_CONTABILIDAD AS AC WITH (NOLOCK) ON AC.CODECC=CCO.CODE 
                  WHERE(T.PERSONTYPE = '1')
                       AND (C.LEGALBOOKID = '1')
                       AND (C.NUMBER BETWEEN '41' AND '41999999')
                       AND YEAR = YEAR(GETDATE()) - 1
                  GROUP BY CCO.CODE, 
                           CCO.NAME, 
                           SC.MONTH, 
                           SC.YEAR, 
                           BO.NAME--,AC.DESCRIPCION
              ) DET PIVOT(SUM(ACUMULADO) FOR MES IN([1], 
                                                    [2], 
                                                    [3], 
                                                    [4], 
                                                    [5], 
                                                    [6], 
                                                    [7], 
                                                    [8], 
                                                    [9], 
                                                    [10], 
                                                    [11], 
                                                    [12])) AS PIV
              --ORDER BY 1,2,3,4,5,6
              )
          SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, *,
		         ([ENERO]+[FEBRERO]+[MARZO]+[ABRIL]+[MAYO]+[JUNIO]+[JULIO]+[AGOSTO]+[SEPTIEMBRE]+[OCTUBRE]+[NOVIEMBRE]+[DICIEMBRE]) as TOTAL,
				 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
          FROM CTE_AÑO_ANTERIOR
          UNION ALL
          SELECT CAST(DB_NAME() AS VARCHAR(9)) AS ID_COMPANY, *,
		         ([ENERO]+[FEBRERO]+[MARZO]+[ABRIL]+[MAYO]+[JUNIO]+[JULIO]+[AGOSTO]+[SEPTIEMBRE]+[OCTUBRE]+[NOVIEMBRE]+[DICIEMBRE]) as TOTAL,				 
				 CONVERT(DATETIME,GETDATE() AT TIME ZONE 'Pakistan Standard Time',1) AS ULT_ACTUAL
          FROM CTE_AÑO_ACTUAL;