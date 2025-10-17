-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: HDSAP_CENSOPLANEACION
-- Extracted by Fabric SQL Extractor SPN v3.9.0




CREATE PROCEDURE [Report].[HDSAP_CENSOPLANEACION]  
@fecha_inicial DATETIME, 
@fecha_final   DATETIME, 
@fecha_corte   DATETIME
AS
    BEGIN
        -- SET NOCOUNT ON added to prevent extra result sets from
        -- interfering with SELECT statements.
        SET NOCOUNT ON;

        -- Insert statements for procedure here
        SELECT UF.UFUDESCRI AS Servicio, 
               C.DESCCAMAS AS 'No.Cama', 
               I.NUMINGRES AS 'No.Ingreso', 
               I.IFECHAING AS FechaIngreso, 
               DATEDIFF(d, I.IFECHAING, EGR.FECALTPAC) AS DiasHospital, 
               E.IPCODPACI AS NumeroIdentificación,
               CASE P.IPTIPODOC
                   WHEN '1'
                   THEN 'CC'
                   WHEN '2'
                   THEN 'CE'
                   WHEN '3'
                   THEN 'TI'
                   WHEN '4'
                   THEN 'RC'
                   WHEN '5'
                   THEN 'PA'
                   WHEN '6'
                   THEN 'AS'
                   WHEN '7'
                   THEN 'MS'
                   WHEN '8'
                   THEN 'NU'
                   WHEN '9'
                   THEN 'NV'
                   WHEN '12'
                   THEN 'PE'
               END AS 'TipoDocumento', 
               P.IPNOMCOMP AS NombrePaciente, 
               (datediff (year,p.IPFECNACI, getdate ())) EDAD,
               CASE
                   WHEN P.IPSEXOPAC = '1'
                   THEN 'Masculino'
                   WHEN P.IPSEXOPAC = '2'
                   THEN 'Femenino'
               END AS Sexo, 
               D.CODDIAGNO AS 'CodigoCIE-10', 
               V.NOMDIAGNO AS 'NombreCIE-10', 
               '' AS Clasificacion,
               CASE
                   WHEN C.CODICAMAS IN('2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '33', '34', '36', '37', '38', '39', '40', '41', '42', '43', '44', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '92', '97', '98', '99', '100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '117', '136', '137', '138', '139', '140', '141', '142', '143', '144', '145', '146', '147', '148', '149', '150', '151', '152', '153', '154', '155', '156', '157', '158', '159', '160', '161', '162', '163', '164', '165', '166', '167', '168', '169', '170', '171', '172', '173', '174', '175', '176', '177', '178', '179', '180', '181', '182', '184', '185', '187', '188', '189', '190', '191', '192', '193', '194', '195', '196', '197', '198', '199', '200', '201', '202', '203', '204', '205', '206', '207', '208', '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222', '223', '224', '225', '226', '227', '229', '230', '231', '232', '233', '234', '235', '236', '237', '238', '320', '321', '322', '323', '324', '325', '326', '327', '328', '329', '330', '351', '352', '353', '355', '356', '357', '358', '359', '360', '361', '362', '363', '364', '365', '366', '367', '368', '369', '370', '371', '372', '373', '374', '375', '376', '377', '378', '379', '704', '719', '720', '721', '722', '723', '724', '725', '726', '727', '728', '729', '730', '731', '732', '756', '757', '764', '765', '785', '786', '787', '808', '809', '810', '811', '812', '813', '814', '815', '816', '817', '818', '819', '820', '821', '822', '823', '824', '825', '826', '827', '828', '829', '830', '831', '832', '833', '834', '836', '837', '838', '839', '840', '841', '842', '843', '888', '889', '890', '891', '892', '893', '894', '895', '896', '897', '898', '899', '901', '954', '1153', '1154', '1155', '1156', '1157', '1158', '1159', '1160', '1161', '1162', '1163', '1164', '1165', '1166', '1167', '1168', '1169', '1170', '1171', '1172', '1173', '1174', '1175', '1176', '1177', '1178', '1179', '1180', '1181', '1182', '1183', '1184', '1185', '1186', '1187', '1188', '1189', '1190', '1191', '1192', '1193', '1194', '1195', '1196', '1197', '1198', '1199', '1200', '1201', '1202', '1203', '1204', '1205', '1206', '1207', '1208', '1209', '1210', '1211', '1212', '1213', '1214', '1215', '1216', '1217', '1218', '1219', '1220', '1221', '1222', '1223', '1224', '1225', '1226', '1227', '1228', '1229', '1230', '1231', '1232', '1233', '1255', '1256', '1257', '1258', '1259', '1260', '1261', '1262', '1263', '1264', '1265', '1266', '1267', '1268')
                   THEN 'N.A.'
                   WHEN C.CODICAMAS IN('1007', '1008', '1009', '1010', '1011', '1012', '1013', '1014', '1015', '1016', '1286', '1287', '1288', '1289', '1290', '1291', '1292', '1293', '1294', '1295')
                   THEN 'FASE I'
                   WHEN C.CODICAMAS IN('341', '342', '343', '344', '345', '346', '347', '348', '349', '350', '425', '440', '441', '442', '443', '444', '445', '446', '447', '448', '468', '469', '470', '471', '472', '473', '474', '475', '476', '477', '478', '679', '680', '681', '682', '683', '684', '685', '686', '687', '688', '689', '690', '691', '692', '693', '694', '695', '696', '697', '698', '1234', '1235', '1236', '1237', '1238', '1239', '1240', '1241', '1242', '1243', '1244', '1245', '1246', '1247', '1248', '1249', '1250')
                   THEN 'FASE II'
                   WHEN C.CODICAMAS IN('759', '760', '761', '762', '763', '766', '767', '768', '769', '770', '771', '772', '773', '774', '775', '776', '777', '778', '779', '780', '781', '782', '783', '784', '955', '957', '958', '959', '960', '961', '963', '964', '965', '966', '967', '968', '969', '970', '971', '972', '973', '974', '975', '976', '977', '978', '979', '981', '982', '983', '984', '985', '986', '1018', '1082', '1083', '1084', '1085', '1086', '1087', '1088', '1089', '1090', '1091', '1092', '1093', '1094', '1095', '1096', '1269', '1270', '1271', '1272', '1273', '1274', '1275', '1276', '1277', '1278', '1279', '1280', '1281', '1282', '1283', '1284', '1285')
                   THEN 'FASE III'
                   WHEN C.CODICAMAS IN('844', '845', '846', '847', '848', '849', '850', '851', '852', '853', '854', '855', '856', '857', '858', '859', '860', '861', '862', '863', '864', '865', '866', '867', '868', '869', '870', '871', '872', '873', '874', '875', '876', '877', '878', '879', '880', '881', '882', '883', '884', '885', '903', '904', '905', '906', '908', '909', '910', '911', '912', '913', '914', '915', '916', '917', '918', '919', '920', '921', '922', '923', '924', '925', '926', '927', '928', '929', '930', '931', '932', '933', '934', '935', '936', '937', '938', '939', '940', '941', '942', '943', '944', '945', '946', '947', '948', '949', '951', '952', '953', '1019', '1020', '1021', '1022', '1023', '1024', '1025', '1026', '1027', '1028', '1029', '1030', '1031', '1032', '1033', '1034', '1035', '1036', '1037', '1038', '1039', '1040', '1041', '1042', '1043', '1044', '1045', '1046', '1047', '1048', '1049', '1050', '1051', '1052', '1053', '1054', '1055', '1056', '1057', '1058', '1059', '1060', '1061', '1062', '1063', '1064', '1065', '1066', '1067', '1068', '1069', '1070', '1071', '1072', '1073', '1097', '1098', '1099', '1100', '1101', '1102', '1103', '1104', '1105', '1106', '1107', '1108', '1109', '1110', '1111', '1112', '1113', '1114', '1115', '1116', '1117', '1118', '1119', '1120', '1121', '1122', '1123', '1124', '1125', '1126', '1127', '1128', '1129', '1130', '1131', '1132', '1133', '1134', '1135', '1136', '1137', '1138', '1139', '1140', '1141', '1142', '1143', '1144', '1145', '1146', '1147', '1148', '1149', '1150', '1151', '1152')
                   THEN 'FASE IV'
                   WHEN C.CODICAMAS IN('1253')
                   THEN 'SALA PARTOS RESPIRATORIO'
                   WHEN C.CODICAMAS IN('1254')
                   THEN 'TOMA MUESTRAS RESPIRATORIO'
               END AS 'FasePlanContingenciaCOVID-19', 
               P.IPDIRECCI AS Direccion, 
               P.IPTELEFON AS Telefono, 
               P.IPTELMOVI AS Movil, 
               E.FECINIEST AS IngresoCama, 
               DATEDIFF(d, E.FECINIEST, E.FECFINEST) AS DiasCama, 
               A.NOMENTIDA AS Eps, 
               dbo.INESPECIA.DESESPECI AS EspecialidadTratante, 
               MUN.MUNNOMBRE AS Procedencia,
               CASE HIS.INDICAPAC
                   WHEN '1'
                   THEN 'Trasladar a Urgencias'
                   WHEN '2'
                   THEN 'Trasladar a Observacion Urgencias'
                   WHEN '3'
                   THEN 'Trasladar a Hospitalizacion'
                   WHEN '4'
                   THEN 'Trasladar a UCI Adulto'
                   WHEN '5'
                   THEN 'Trasladar a UCI Pediatrica'
                   WHEN '6'
                   THEN 'Trasladar a UCI Neonatal'
                   WHEN '7'
                   THEN 'Trasladar a Consulta Externa'
                   WHEN '8'
                   THEN 'Trasladar a Cirugia'
                   WHEN '9'
                   THEN 'Hospitalizacion en Casa'
                   WHEN '10'
                   THEN 'Referencia'
                   WHEN '11'
                   THEN 'Morgue'
                   WHEN '12'
                   THEN 'Salida'
                   WHEN '13'
                   THEN 'Continua en la Unidad'
                   WHEN '14'
                   THEN 'Paciente en Tratamiento'
                   WHEN '15'
                   THEN 'Retiro Voluntario'
                   WHEN '16'
                   THEN 'Fuga'
                   WHEN '17'
                   THEN 'Salida Parcial'
                   WHEN '18'
                   THEN 'Estancia Con la Madre'
                   WHEN '19'
                   THEN 'U.Cuidado Intermedio'
                   WHEN '20'
                   THEN 'U.Basica'
                   WHEN '21'
                   THEN 'No Aplica'
                   ELSE 'Continua en la Unidad'
               END AS Estado,
               CASE
                   WHEN HIS.INDICAPAC IS NULL
                   THEN NULL
                   ELSE t1.FECHAENF
               END AS FechaSalidaEnfermeria, 
               CUP.DESSERIPS AS 'InterconsultasPendientes'
        --E.FECFINEST AS 'SalidaCama'
        --CASE 
        --    WHEN E.FECFINEST = '1900-01-01 00:00:00.000'
        --    THEN '2050-01-01 00:00:00.000'
        --    ELSE E.FECFINEST
        --END AS 'SalidaCama'
        FROM dbo.CHCAMASHO AS C
             INNER JOIN dbo.ADCENATEN AS CA ON CA.CODCENATE = C.CODCENATE
             INNER JOIN dbo.INUNIFUNC AS UF ON UF.UFUCODIGO = C.UFUCODIGO
             INNER JOIN dbo.CHREGESTA AS E ON E.CODICAMAS = C.CODICAMAS
                                                        AND E.REGESTADO = '2'
             INNER JOIN dbo.CHTIPESTA AS TE ON TE.CODTIPEST = E.CODTIPEST
             INNER JOIN dbo.ADINGRESO AS I ON I.NUMINGRES = E.NUMINGRES
             INNER JOIN dbo.INPACIENT AS P ON P.IPCODPACI = E.IPCODPACI
             INNER JOIN dbo.INENTIDAD AS A ON A.CODENTIDA = I.CODENTIDA
             LEFT OUTER JOIN dbo.INDIAGNOP AS D ON D.NUMINGRES = E.NUMINGRES
                                                             AND D.IPCODPACI = E.IPCODPACI
                                                             AND D.CODDIAPRI = 'True'
             LEFT OUTER JOIN dbo.INDIAGNOS AS V ON V.CODDIAGNO = D.CODDIAGNO
             INNER JOIN dbo.INESPECIA ON I.CODESPTRA = dbo.INESPECIA.CODESPECI
             INNER JOIN dbo.INUBICACI AS UBI ON P.AUUBICACI = UBI.AUUBICACI
             INNER JOIN dbo.INMUNICIP AS MUN ON UBI.DEPMUNCOD = MUN.DEPMUNCOD
             INNER JOIN dbo.HCREGEGRE AS EGR ON I.NUMINGRES = EGR.NUMINGRES
             INNER JOIN dbo.HCHISPACA AS HIS ON EGR.NUMINGRES = HIS.NUMINGRES
                                                          AND EGR.NUMEFOLIO = HIS.NUMEFOLIO
             LEFT JOIN
        (
            SELECT IPCODPACI, 
                   NUMINGRES, 
                   MAX(FECREGIST) AS FECHAENF
            FROM DBO.HCCTRNOTE
            WHERE TITNOTENF LIKE '%HISTORIA FINAL DE ENFERMERIA%'
            GROUP BY IPCODPACI, 
                     NUMINGRES
        ) AS t1 ON i.NUMINGRES = t1.NUMINGRES
                   AND i.IPCODPACI = t1.IPCODPACI
             LEFT JOIN DBO.HCORDINTE AS IT ON I.NUMINGRES = IT.NUMINGRES
                                                        AND I.IPCODPACI = IT.IPCODPACI
                                                        AND IT.ESTSERIPS = 1
             LEFT JOIN DBO.INCUPSIPS AS CUP ON IT.CODSERIPS = CUP.CODSERIPS
        WHERE(C.CODCENATE = '001')
             AND (C.ESTADCAMA = '1')
             AND (I.IFECHAING BETWEEN @fecha_inicial AND @fecha_final)
        UNION
        SELECT UF.UFUDESCRI AS Servicio, 
               C.DESCCAMAS AS 'No.Cama', 
               I.NUMINGRES AS 'No.Ingreso', 
               I.IFECHAING AS FechaIngreso,
               CASE
                   WHEN EGR.FECALTPAC IS NULL
                   THEN DATEDIFF(d, I.IFECHAING, GETDATE())
                   WHEN EGR.FECALTPAC IS NOT NULL
                   THEN DATEDIFF(d, I.IFECHAING, EGR.FECALTPAC)
               END AS DiasHospital, 
               E.IPCODPACI AS NumeroIdentificación,
               CASE P.IPTIPODOC
                   WHEN '1'
                   THEN 'CC'
                   WHEN '2'
                   THEN 'CE'
                   WHEN '3'
                   THEN 'TI'
                   WHEN '4'
                   THEN 'RC'
                   WHEN '5'
                   THEN 'PA'
                   WHEN '6'
                   THEN 'AS'
                   WHEN '7'
                   THEN 'MS'
                   WHEN '8'
                   THEN 'NU'
                   WHEN '9'
                   THEN 'NV'
                   WHEN '12'
                   THEN 'PE'
               END AS 'TipoDocumento', 
               P.IPNOMCOMP AS NombrePaciente, 
               (datediff (year,p.IPFECNACI, getdate ())) EDAD,
               CASE
                   WHEN P.IPSEXOPAC = '1'
                   THEN 'Masculino'
                   WHEN P.IPSEXOPAC = '2'
                   THEN 'Femenino'
               END AS Sexo, 
               D.CODDIAGNO AS 'CodigoCIE-10', 
               V.NOMDIAGNO AS 'NombreCIE-10', 
               '' AS Clasificacion,
               CASE
                   WHEN C.NUMCAMHOS IN('UG01      ', 'UG02      ', 'UG03      ', 'UG04      ', 'UG05      ', 'UG06      ', 'UG07      ', 'UG08      ', 'UG09      ', 'UG10      ', 'UG11      ', 'UG12      ', 'UG13      ', 'UG14      ', 'UG15      ', '303', '304', '305', '306', '307', '308', '309', '310', '311', '312', '313', '314', '521', '522', '523', '524', '525', '526', '527', '528', '529', '530', '531', '532', '533', '534', '535', '536', '537', '538', '539', '540', '541', '542', '543', '544', '545', 'PP1       ', 'PP2       ', 'PP3       ', 'PP4       ', 'PP5       ', 'PP6       ', 'PP7       ', 'PP8       ', 'PP9       ', 'PP10      ', 'PP11      ', 'PP12      ', 'PP13      ', 'PP14      ', 'RQ1       ', 'RQ2       ', 'RQ3       ', 'RQ4       ', 'RQ5       ', 'RQ6       ', 'RQ7       ', 'RQ8       ', 'RQ9       ', 'RQ10      ', 'RQ11      ', 'RQ12      ', 'RQ13      ', 'RQ14      ', 'PQ01      ', 'PQ02      ', 'PQ03      ', 'PQ04      ', 'PQ05      ', 'PQ06      ', 'PQ07      ', 'PQ08      ', 'PQ09      ', 'PQ10      ', 'PQ11      ', 'PQ12      ', 'PQ13      ', 'PQ14      ', 'PQ15      ', 'PQ16      ', 'PQ17      ', 'PQ18      ', 'PQ19      ', 'PQ20      ', '701', '702', '703', '704', '705', '706', '707', '708', '709', '710', '711', '712', '713', '714', '715', '716', '717', '718', '401', '402', '403', '404', '405', '406', '407', '408', '409', '410', '411', '412', '413', '414', '415', '416', '417', '418', '419', '420', '421', '422', '423', '424', '425', '426', '427', '428', '429', '315', '301', '302', '601', '602', '603', '604', '605', '606', '607', '608', '609', '610', '611', '612', '613', '614', '615', '616', '617', '618', '619', '620', '621', '622', '623', '624', '625', '626', 'RQ15      ', 'RQ16      ', 'RQ17      ', 'RQ18      ', 'RQ19      ', 'RQ20      ', 'RQ21      ', 'RQ22      ', 'RQ23      ', 'RQ24      ', 'RQ25      ', 'RQ26      ', 'RQ27      ', 'RQ28      ', 'RQ29      ', 'PQ21      ', 'PQ22      ', 'PQ23      ', 'PQ24      ', 'PQ25      ', 'PQ26      ', 'PQ27      ', 'PQ28      ', 'PQ29      ', 'PQ30      ', 'UCI01     ', 'UCI02     ', 'UCI03     ', 'UCI04     ', 'UCI05     ', 'UCI06     ', 'UCI07     ', 'UCI08     ', 'UCI09     ', 'UCI10     ', '546', 'QX01      ', 'QX02      ', 'QX03      ', 'RO01      ', 'RO02      ', 'RO03      ', 'RO04      ', 'RO05      ', 'RO06      ', 'RO07      ', 'RO08      ', 'RO09      ', 'RO10      ', 'RO11      ', 'RO12      ', 'RO13      ', 'RO14      ', '501', '502', '503', '504', '505', '506', '507', '508', '509', '510', '547', 'OPQ01     ', 'OPQ02     ', 'OPQ03     ', 'OPQ04     ', 'OPQ05     ', 'OPQ06     ', 'OPQ07     ', 'OPQ08     ', 'OPQ09     ', 'OPQ10     ', 'OPQ11     ', 'OPQ12     ', 'OPQ13     ', 'OPQ14     ', 'OPQ15     ', '719', '720', '627', '628', '511', '512', '513', 'QX04      ', 'QX05      ', 'QX06      ', 'QX07      ', 'QX08      ', 'QX09      ', 'QX10      ', '316', '317', 'RO15      ', 'RO16      ', 'RO17      ', 'RO18      ', 'RO19      ', 'RO20      ', 'UG16      ', 'UG17      ', 'UG18      ', 'UG19      ', 'UG20      ', 'RO21      ', 'RO22      ', 'RO23      ', 'RO24      ', 'RO25      ', 'RO26      ', 'RO27      ', 'RO28      ', 'RO29      ', 'RO30      ', 'RO31      ', 'RO32      ', 'RO33      ', 'RO34      ', 'RO35      ', 'ROVirtual1', 'ROVirtual2', 'ROVirtual3', 'ROVirtual4', 'ROVirtual5', 'ROVirtual6', 'ROVirtual7', 'ROVirtual8', 'ROVirtual9', 'ROVirtual0', 'V1        ', 'V2        ', 'PPV015    ', '629', '1202', '1203', '1204', '1205', '1206', '1207', '1208', '1209', '1210', '1211', '1212', '1213', '1214', '1215', '1216', '1217', '1218', '1219', '1220', '1221', '1222', '1223', '1224', '1225', '1226', '1227', '1228', '1229', '1230', '1231', '1232', '1233', '1234', '1235', '1236', '1237', '1238', '1239', '1240', '1241', '1242', '1243', '1244', '1245', '1246', '1247', '1248', '1249', '1250', '1251', '1252', '1253', '1254', '1255', '1256', '1257', '1258', '1259', '1260', '1261', '1262', '1263', '1264', '1265', '1266', '1267', '1268', '1269', '1270', '1271', '1272', '1273', '1274', '1275', '1276', '1277', '1278', '1279', '1280', '1281', '1282', '801', '802', '803', '804', '805', '806', '807', '808', '809', '810', '811', '812', '813', '814')
                   THEN 'N.A.'
                   WHEN C.NUMCAMHOS IN('950', '951', '952', '953', '954', '955', '956', '957', '958', '959', '960', '961', '962', '963', '964', '965', '966', '967', '968', '969')
                   THEN 'FASE I'
                   WHEN C.NUMCAMHOS IN('801', '802', '803', '804', '805', '806', '807', '808', '809', '810', '851', '852', '853', '854', '855', '856', '857', '858', '859', '860', '831', '832', '833', '834', '835', '836', '837', '838', '839', '840', '841', '811', '812', '813', '814', '815', '816', '817', '818', '819', '820', '821', '822', '823', '824', '825', '826', '827', '828', '829', '830', '861', '862', '863', '864', '865', '866', '867', '868', '869', '870', '842', '843', '844', '845', '846', '847', '848')
                   THEN 'FASE II'
                   WHEN C.NUMCAMHOS IN('980', '981', '982', '983', '984', '871', '872', '873', '874', '875', '876', '877', '878', '879', '880', '881', '882', '883', '884', '885', '886', '887', '888', '889', '900', '901', '902', '903', '904', '905', '906', '907', '908', '909', '910', '911', '912', '913', '914', '915', '916', '917', '918', '919', '920', '921', '922', '924', '925', '926', '927', '928', '929', '923', '985', '986', '987', '988', '989', '990', '991', '992', '993', '994', '995', '996', '997', '998', '999', '930', '931', '932', '933', '934', '935', '936', '937', '938', '939', '940', '941', '942', '943', '944', '945', '946')
                   THEN 'FASE III'
                   WHEN C.NUMCAMHOS IN('1001', '1002', '1003', '1004', '1005', '1006', '1007', '1008', '1009', '1010', '1011', '1012', '1013', '1014', '1015', '1016', '1017', '1018', '1019', '1020', '001VIRTUAL', '800', '1021', '1022', '1023', '1024', '1025', '1026', '1027', '1028', '1029', '1030', '1031', '1032', '1033', '1034', '1035', '1036', '1037', '1038', '1039', '1040', '1041', '1042', '1043', '1044', '1046', '1047', '1048', '1049', '1050', '1051', '1052', '1053', '1054', '1055', '1056', '1057', '1058', '1059', '1060', '1061', '1062', '1063', '1064', '1065', '1066', '1067', '1068', '1069', '1070', '1071', '1072', '1073', '1074', '1075', '1076', '1077', '1078', '1079', '1080', '1081', '1082', '1083', '1084', '1085', '1086', '1087', '1088', '1089', '1090', '1091', '1092', '1093', '1094', '1095', '1096', '1097', '1098', '1099', '1100', '1101', '1102', '1103', '1104', '1105', '1106', '1107', '1108', '1109', '1110', '1111', '1112', '1113', '1114', '1115', '1116', '1117', '1118', '1119', '1120', '1121', '1122', '1123', '1124', '1125', '1126', '1127', '1128', '1129', '1130', '1131', '1132', '1133', '1134', '1135', '1136', '1137', '1138', '1139', '1140', '1141', '1142', '1143', '1144', '1145', '1146', '1147', '1148', '1149', '1150', '1151', '1152', '1153', '1154', '1155', '1156', '1157', '1158', '1159', '1160', '1161', '1162', '1163', '1164', '1165', '1166', '1167', '1168', '1169', '1170', '1171', '1172', '1173', '1174', '1175', '1176', '1177', '1178', '1179', '1180', '1181', '1182', '1183', '1184', '1185', '1186', '1187', '1188', '1189', '1190', '1191', '1192', '1193', '1194', '1195', '1196', '1197', '1198', '1199', '1200', '1201')
                   THEN 'FASE IV'
               END AS 'FasePlanContingenciaCOVID-19', 
               P.IPDIRECCI AS Direccion, 
               P.IPTELEFON AS Telefono, 
               P.IPTELMOVI AS Movil, 
               E.FECINIEST AS IngresoCama, 
               DATEDIFF(d, E.FECINIEST, GETDATE()) AS DiasCama, 
               A.NOMENTIDA AS Eps, 
               dbo.INESPECIA.DESESPECI AS EspecialidadTratante, 
               MUN.MUNNOMBRE AS Procedencia,
               CASE HIS.INDICAPAC
                   WHEN '1'
                   THEN 'Trasladar a Urgencias'
                   WHEN '2'
                   THEN 'Trasladar a Observacion Urgencias'
                   WHEN '3'
                   THEN 'Trasladar a Hospitalizacion'
                   WHEN '4'
                   THEN 'Trasladar a UCI Adulto'
                   WHEN '5'
                   THEN 'Trasladar a UCI Pediatrica'
                   WHEN '6'
                   THEN 'Trasladar a UCI Neonatal'
                   WHEN '7'
                   THEN 'Trasladar a Consulta Externa'
                   WHEN '8'
                   THEN 'Trasladar a Cirugia'
                   WHEN '9'
                   THEN 'Hospitalizacion en Casa'
                   WHEN '10'
                   THEN 'Referencia'
                   WHEN '11'
                   THEN 'Morgue'
                   WHEN '12'
                   THEN 'Salida'
                   WHEN '13'
                   THEN 'Continua en la Unidad'
                   WHEN '14'
                   THEN 'Paciente en Tratamiento'
                   WHEN '15'
                   THEN 'Retiro Voluntario'
                   WHEN '16'
                   THEN 'Fuga'
                   WHEN '17'
                   THEN 'Salida Parcial'
                   WHEN '18'
                   THEN 'Estancia Con la Madre'
                   WHEN '19'
                   THEN 'U.Cuidado Intermedio'
                   WHEN '20'
                   THEN 'U.Basica'
                   WHEN '21'
                   THEN 'No Aplica'
                   ELSE 'Continua en la Unidad'
               END AS Estado,
               CASE
                   WHEN HIS.INDICAPAC IS NULL
                   THEN NULL
                   ELSE t1.FECHAENF
               END AS FechaSalidaEnfermeria, 
               CUP.DESSERIPS AS 'InterconsultasPendientes'
        --E.FECFINEST AS 'SalidaCama'
        --CASE 
        --    WHEN E.FECFINEST = '1900-01-01 00:00:00.000'
        --    THEN '2050-01-01 00:00:00.000'
        --    ELSE E.FECFINEST
        --END AS 'SalidaCama'
        FROM dbo.CHCAMASHO AS C
             INNER JOIN dbo.ADCENATEN AS CA ON CA.CODCENATE = C.CODCENATE
             INNER JOIN dbo.INUNIFUNC AS UF ON UF.UFUCODIGO = C.UFUCODIGO
             INNER JOIN dbo.CHREGESTA AS E ON E.CODICAMAS = C.CODICAMAS
                                                        AND E.REGESTADO = '1'
             INNER JOIN dbo.CHTIPESTA AS TE ON TE.CODTIPEST = E.CODTIPEST
             INNER JOIN dbo.ADINGRESO AS I ON I.NUMINGRES = E.NUMINGRES
             INNER JOIN dbo.INPACIENT AS P ON P.IPCODPACI = E.IPCODPACI
             INNER JOIN dbo.INENTIDAD AS A ON A.CODENTIDA = I.CODENTIDA
             LEFT OUTER JOIN dbo.INDIAGNOP AS D ON D.NUMINGRES = E.NUMINGRES
                                                             AND D.IPCODPACI = E.IPCODPACI
                                                             AND D.CODDIAPRI = 'True'
             LEFT OUTER JOIN dbo.INDIAGNOS AS V ON V.CODDIAGNO = D.CODDIAGNO
             INNER JOIN dbo.INESPECIA ON I.CODESPTRA = dbo.INESPECIA.CODESPECI
             INNER JOIN dbo.INUBICACI AS UBI ON P.AUUBICACI = UBI.AUUBICACI
             INNER JOIN dbo.INMUNICIP AS MUN ON UBI.DEPMUNCOD = MUN.DEPMUNCOD
             LEFT JOIN dbo.HCREGEGRE AS EGR ON I.NUMINGRES = EGR.NUMINGRES
             LEFT JOIN dbo.HCHISPACA AS HIS ON EGR.NUMINGRES = HIS.NUMINGRES
                                                         AND EGR.NUMEFOLIO = HIS.NUMEFOLIO
             LEFT JOIN
        (
            SELECT IPCODPACI, 
                   NUMINGRES, 
                   MAX(FECREGIST) AS FECHAENF
            FROM DBO.HCCTRNOTE
            WHERE TITNOTENF LIKE '%HISTORIA FINAL DE ENFERMERIA%'
            GROUP BY IPCODPACI, 
                     NUMINGRES
        ) AS t1 ON i.NUMINGRES = t1.NUMINGRES
                   AND i.IPCODPACI = t1.IPCODPACI
             LEFT JOIN DBO.HCORDINTE AS IT ON I.NUMINGRES = IT.NUMINGRES
                                                        AND I.IPCODPACI = IT.IPCODPACI
                                                        AND (IT.ESTSERIPS = 1)
             LEFT JOIN DBO.INCUPSIPS AS CUP ON IT.CODSERIPS = CUP.CODSERIPS
        WHERE(C.CODCENATE = '001')
             AND (C.ESTADCAMA = '2')
             AND (I.IFECHAING <= @fecha_corte);
    END;
