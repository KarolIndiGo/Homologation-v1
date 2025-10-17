-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_AD_Fixed_RelaciónActivos_Vie
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IMO_AD_Fixed_RelaciónActivos_Vie] AS

SELECT   Ing.id AS IdIngreso, pa.AdquisitionDate AS FAdquisición, pa.Id AS id_activo, 
			CASE WHEN l.Code LIKE 'C%' THEN 'Faca' WHEN l.Code LIKE 'B%' THEN 'Bogota' WHEN l.Code LIKE 'F%' THEN 'Florencia' WHEN l.Code LIKE 'n%' THEN 'Neiva' WHEN l.Code LIKE 'T%' THEN 'Tunja' WHEN l.Code LIKE 'P%' THEN 'Pitalito' WHEN l.Code LIKE 'M%' THEN 'Mocoa' END AS Sucursal, Ing.Code AS Ingreso, 
			CASE Ing.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' when 3 then 'Anulado' END AS Estado, Ing.EntryDate AS Fecha, 
			CASE Ing.AdquisitionType WHEN '1' THEN 'CompraDirecta' WHEN '3' THEN 'Comodato' WHEN '4' THEN 'Donadacion' WHEN '5' THEN 'TraspasoBienes' WHEN '6' THEN 'OtroConcepto' WHEN '7' THEN 'LeasingFinanciero' WHEN '8' THEN 'Comodato Tercerizado' WHEN '9' THEN 'Renting Financiero' when '10' then 'Renting Operativo' END AS [Tipo Adquisición], RTRIM(Art.Code) AS CodArticulo, 
			RTRIM(Art.Description) AS [Artículo], CASE substring(tart.Code, 1, 2) 
			WHEN '01' THEN 'BIOMEDICO' WHEN '02' THEN 'INDUSTRIAL' WHEN '03' THEN 'INFRAESTRUCTURA' WHEN '04' THEN 'MOBILIARIO' WHEN '05' THEN 'MUEBLES_OFICINA' WHEN '06' THEN 'COMPUTO_COMUNICACIONES' WHEN '07' THEN 'INSTRUMENTAL_BIOMEDICO' WHEN '08' THEN 'ACCESORIO_BIOMEDICO' WHEN '09' THEN 'MEDICO_HOSPITALARIO' WHEN '10' THEN 'PATRON'
			WHEN '11' THEN 'OTROS' WHEN '12' THEN 'VEHICULOS' END AS TipoInventario, pa.Plate AS Placa, mar.Name AS Marca, pa.Model AS Modelo, pa.Serie, CASE pa.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS EstadoActivo, RTRIM(t .Nit) + ' - ' + RTRIM(t .Name) AS Responsable, 
			RTRIM(l.Code) + ' - ' + RTRIM(l.Name) AS Localizacion, 
			RTRIM(UF.Code) AS CodUF , RTRIM(UF.Name) AS UnidadFuncional, RTRIM(cc.cODE) + ' - ' + RTRIM(CC.nAME) AS CentroCosto, Ing.InvoiceDate AS FechaFactura, Ing.EntryNumber AS Factura, RTRIM(pv.Code) + ' - ' + RTRIM(pv.Name) AS Proveedor, pa.HistoricalValue AS VrHistorico, padb.DepreciatedValue AS VrDepreciado, padb.ResidualValue AS SaldoNeto, 
			CASE DIng.RemissionSource WHEN '1' THEN 'Ninguna' WHEN '2' THEN 'OrdenCompra' WHEN '3' THEN 'Remision_Entrada' END AS Origen, 
			rtrim(cata.Code) + ' - ' + rtrim(cata.Description) AS Catálogo, RTRIM(cue.Number) + ' - ' + RTRIM(cue.Name) AS Cuenta, RTRIM(pol.Code) + ' - ' + RTRIM(pol.Name) AS Poliza, Ing.Description AS Descripción, 
          
			-- padb.TransactionValue 
		  
			isnull(trans.valorizacion,0)-isnull(desv.valorizacion,0)  AS VrTransacciones, 
		   
			EID.WarrantyExpirationDate AS [Fecha vencimiento garantia], padb.LifeTime AS [VidaUtil], padb.DaysPendingDepreciate AS [DiasPendDepreciar], padb.DepreciatedDays AS [DiasDepreciados], l.UseTime AS [Tiempo Uso], CASE art.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END [Deprecia Tiempo Uso], 
			DIng.IvaValue AS IvaItem, pa.NumberContractLeasing AS [Contrato Leasing], pa.InitialDateLeasing[Fecha Inicial Leasing], pa.EndDateLeasing AS [Fecha Final Leasing],
			case when padb.Devaluation is not null then padb.Devaluation else desv.valorizacion end as Desvalorizacion, trans.valorizacion as Valorizacion
FROM    FixedAsset.FixedAssetEntry AS Ing  INNER JOIN
			FixedAsset.FixedAssetEntryItem AS DIng  ON Ing.Id = DIng.FixedAssetEntryId AND Ing.Status <> '3' INNER JOIN
			FixedAsset.FixedAssetEntryItemDetail AS eid ON eid.FixedAssetEntryItemId = DIng.id INNER JOIN
			FixedAsset.FixedAssetItem AS Art  ON Art.Id = DIng.ItemId INNER JOIN
			FixedAsset.FixedAssetPhysicalAsset AS pa  ON pa.ItemId = Art.Id AND pa.plate = eid.plate INNER JOIN
			FixedAsset.FixedAssetItemType AS tart  ON tart.Id = Art.ItemTypeId INNER JOIN
			Common.OperatingUnit AS uo ON uo.Id = Ing.OperatingUnitId INNER JOIN
			Common.Supplier AS pv ON pv.Id = Ing.SupplierId INNER JOIN
			FixedAsset.FixedAssetTrademark AS mar ON mar.Id = pa.TrademarkId INNER JOIN
			GeneralLedger.MainAccounts AS cue  ON cue.Id = pa.MainAccountId AND cue.LegalBookId = '1' INNER JOIN
			.FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId INNER JOIN
			FixedAsset.FixedAssetResponsible AS res ON res.Id = pa.ResponsibleId /* AND pa.AdquisitionDate > '31/12/2016 00:00:00' */ INNER JOIN
			Common.ThirdParty AS t  ON t .Id = res.ThirdPartyId LEFT OUTER JOIN
			FixedAsset.FixedAssetPolicy AS pol  ON pol.Id = pa.PolicyId INNER JOIN
			Payroll.FunctionalUnit AS UF  ON UF.Id = l.FunctionalUnitId INNER JOIN
			FixedAsset.FixedAssetItemCatalog AS cata  ON cata.id = art.ItemCatalogId LEFT OUTER JOIN
			FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb  ON padb.PhysicalAssetId = pa.id AND padb.legalbookid = '1' INNER JOIN
			Payroll.CostCenter AS cc ON cc.Id = uf.CostCenterId 
			left outer join (select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='1' and ValorizationType='1'  and tt.status='2'
								group by t.PhysicalAssetId ) as trans on trans.idactivo=pa.id	 
								left outer join 	(select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='2' and ValorizationType='0'  and tt.status='2'  
								group by t.PhysicalAssetId) as desv on desv.idactivo=pa.id	  
WHERE  (Ing.Status <> '3')  AND pa.hasoutput = '0'  AND pa.Status = '1'

--union all 

--SELECT  Ing.id AS IdIngreso, pa.AdquisitionDate AS FAdquisición, pa.Id AS id_activo, 
--           CASE WHEN l.Code LIKE 'C%' THEN 'Faca' WHEN l.Code LIKE 'B%' THEN 'Bogota' WHEN l.Code LIKE 'F%' THEN 'Florencia' WHEN l.Code LIKE 'n%' THEN 'Neiva' WHEN l.Code LIKE 'T%' THEN 'Tunja' WHEN l.Code LIKE 'P%' THEN 'Pitalito' WHEN l.Code LIKE 'M%' THEN 'Mocoa' END AS Sucursal, Ing.Code AS Ingreso, 
--           CASE Ing.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado'  when 3 then 'Anulado'  END AS Estado, Ing.EntryDate AS Fecha, 
--           CASE Ing.AdquisitionType WHEN '1' THEN 'CompraDirecta' WHEN '3' THEN 'Comodato' WHEN '4' THEN 'Donadacion' WHEN '5' THEN 'TraspasoBienes' WHEN '6' THEN 'OtroConcepto' WHEN '7' THEN 'LeasingFinanciero' WHEN '8' THEN 'Comodato Tercerizado' WHEN '9' THEN 'Renting Financiero' when '10' then 'Renting Operativo' END AS [Tipo Adquisición], RTRIM(Art.Code) AS CodArticulo, 
--           RTRIM(Art.Description) AS [Artículo], CASE substring(tart.Code, 1, 2) 
--           WHEN '01' THEN 'BIOMEDICO' WHEN '02' THEN 'INDUSTRIAL' WHEN '03' THEN 'INFRAESTRUCTURA' WHEN '04' THEN 'MOBILIARIO' WHEN '05' THEN 'MUEBLES_OFICINA' WHEN '06' THEN 'COMPUTO_COMUNICACIONES' WHEN '07' THEN 'INSTRUMENTAL_BIOMEDICO' WHEN '08' THEN 'ACCESORIO_BIOMEDICO' WHEN '09' THEN 'MEDICO_HOSPITALARIO' WHEN '10' THEN 'PATRON'
--            WHEN '11' THEN 'OTROS' WHEN '12' THEN 'VEHICULOS' END AS TipoInventario, pa.Plate AS Placa, mar.Name AS Marca, pa.Model AS Modelo, pa.Serie, CASE pa.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS EstadoActivo, RTRIM(t .Nit) + ' - ' + RTRIM(t .Name) AS Responsable, 
--			RTRIM(l.Code) + ' - ' + RTRIM(l.Name) AS Localizacion, 
--			RTRIM(UF.Code) AS CodUF , RTRIM(UF.Name) AS UnidadFuncional, RTRIM(cc.cODE) + ' - ' + RTRIM(CC.nAME) AS CentroCosto, Ing.InvoiceDate AS FechaFactura, Ing.EntryNumber AS Factura, RTRIM(pv.Code) + ' - ' + RTRIM(pv.Name) AS Proveedor, pa.HistoricalValue AS VrHistorico, padb.DepreciatedValue AS VrDepreciado, padb.ResidualValue AS SaldoNeto, 
--           CASE DIng.RemissionSource WHEN '1' THEN 'Ninguna' WHEN '2' THEN 'OrdenCompra' WHEN '3' THEN 'Remision_Entrada' END AS Origen, 
--		   rtrim(cata.Code) + ' - ' + rtrim(cata.Description) AS Catálogo, RTRIM(cue.Number) + ' - ' + RTRIM(cue.Name) AS Cuenta, RTRIM(pol.Code) + ' - ' + RTRIM(pol.Name) AS Poliza, Ing.Description AS Descripción, 
          
--		  -- padb.TransactionValue 
		  
--		  isnull(trans.valorizacion,0)-isnull(desv.valorizacion,0)  AS VrTransacciones, 
		   
--		   EID.WarrantyExpirationDate AS [Fecha vencimiento garantia], padb.LifeTime AS [VidaUtil], padb.DaysPendingDepreciate AS [DiasPendDepreciar], padb.DepreciatedDays AS [DiasDepreciados], l.UseTime AS [Tiempo Uso], CASE art.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END [Deprecia Tiempo Uso], 
--           DIng.IvaValue AS IvaItem, pa.NumberContractLeasing AS [Contrato Leasing], pa.InitialDateLeasing[Fecha Inicial Leasing], pa.EndDateLeasing AS [Fecha Final Leasing],
--		   case when padb.Devaluation is not null then padb.Devaluation else desv.valorizacion end as Desvalorizacion, trans.valorizacion as Valorizacion
--FROM    FixedAsset.FixedAssetEntry AS Ing  INNER JOIN
--           FixedAsset.FixedAssetEntryItem AS DIng  ON Ing.Id = DIng.FixedAssetEntryId AND Ing.Status <> '3' INNER JOIN
--           FixedAsset.FixedAssetEntryItemDetail AS eid ON eid.FixedAssetEntryItemId = DIng.id INNER JOIN
--           FixedAsset.FixedAssetItem AS Art  ON Art.Id = DIng.ItemId INNER JOIN
--           FixedAsset.FixedAssetPhysicalAsset AS pa  ON pa.ItemId = Art.Id AND pa.plate = eid.plate INNER JOIN
--           FixedAsset.FixedAssetItemType AS tart  ON tart.Id = Art.ItemTypeId INNER JOIN
--           Common.OperatingUnit AS uo ON uo.Id = Ing.OperatingUnitId INNER JOIN
--           Common.Supplier AS pv ON pv.Id = Ing.SupplierId INNER JOIN
--           FixedAsset.FixedAssetTrademark AS mar ON mar.Id = pa.TrademarkId INNER JOIN
--           GeneralLedger.MainAccounts AS cue  ON cue.Id = pa.MainAccountId AND cue.LegalBookId = '1' INNER JOIN
--           .FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId INNER JOIN
--           FixedAsset.FixedAssetResponsible AS res ON res.Id = pa.ResponsibleId /* AND pa.AdquisitionDate > '31/12/2016 00:00:00' */ INNER JOIN
--           Common.ThirdParty AS t  ON t .Id = res.ThirdPartyId LEFT OUTER JOIN
--           FixedAsset.FixedAssetPolicy AS pol  ON pol.Id = pa.PolicyId INNER JOIN
--           Payroll.FunctionalUnit AS UF  ON UF.Id = l.FunctionalUnitId INNER JOIN
--           FixedAsset.FixedAssetItemCatalog AS cata  ON cata.id = art.ItemCatalogId LEFT OUTER JOIN
--           FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb  ON padb.PhysicalAssetId = pa.id AND padb.legalbookid = '1' INNER JOIN
--           Payroll.CostCenter AS cc ON cc.Id = uf.CostCenterId 
--		   left outer join (select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
--								from FixedAsset.FixedAssetTransactionDetail as t inner join
--										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
--										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
--								where  TransactionType='1' and ValorizationType='1'  and tt.status='2'
--								group by t.PhysicalAssetId ) as trans on trans.idactivo=pa.id	 
--								left outer join 	(select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
--								from FixedAsset.FixedAssetTransactionDetail as t inner join
--										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
--										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
--								where  TransactionType='2' and ValorizationType='0'  and tt.status='2'  
--								group by t.PhysicalAssetId) as desv on desv.idactivo=pa.id	  
--WHERE  (Ing.Status <> '3') AND pa.Plate in ('F004952','F004941','F004946','F004979','015392','013585','F005501','014124','014133','014185','014179','014180','014186','F005608','F005610','F005618','F005621','F005628','F005591',
--'014261','013464','013820','013800','014134','014919','014947','F005671','015709','015718','015722','015731','015732','015734','015736','015740','015752','015763','F005710','015692','015693','015789','016556','016532',
--'016540','016694','018380','017009','017006','017012','017068','017011','017014','017015','017021','017022','017019','T005358',
--'PROV01', 'PROV02','014127','013429','014274','015428','016528','016775','014607','013568','014509','014545','014541','013288','014188','013822',
--'013855','013864','014914','013564','013272','014272','013861','014946','014922','014916','009145','013990','016552','017389','016244','015381','018477',
--'018491','018484','014653','016928','013457','016945','019125','019138','TRG0207R','TRG0029R','TRG0024R','TRG0033R','TRG0035R','TRG0037R','TRG0038R',
--'TRG0025R','TRG0021R','TRG0023R','TRG0027R','TRG0042R','TRG0022R','TRG0039R','TRG0026R','TRG0044R','TRG0028R','TRG0032R','TRG0371R','020011B','019994B',
--'019996B','019995B','019997B','TRG0062R','TRG0120R','TRG0137R','TRG0138R','TRG0067R','TRG0068R','TRG0069R','TRG0130R','TRG0131R','TRG0142R','TRG0143R',

--'TRG0116R','TRG0117R','TRG0118R','TRG0128R','TRG0129R','TRG0139R','TRG0141R','TRG0114R','TRG0115R','TRG0063R','TRG0064R','TRG0065R','TRG0121R','TRG0136R',
--'TRG0147R','TRG0206R','TRG0070R','TRG0201R','TRG0202R','TRG0203R','TRG0204R','TRG0205R','TRG0132R','TRG0133R','TRG0134R','TRG0135R','TRG0144R','TRG0145R',
--'TRG0146R','TRG0122R','TRG0123R','TRG0124R','TRG0125R','TRG0126R','RG0199R','RG0211R','TRG0046R','TRG0047R','TRG0048R','F004950','014590','014513','014527','014524','014531','010923','T004997',
--'F005558','F005590','F005592','F005594','014275','014262','014284',' 014229','013711','009268','014952','013865','014968','014969','013993',
--'013966','013965','014977','014975','013937','015701','017199','F005716','015689','015799','011821','015639','015788','015792','015640','015614','016364','016041','016326','016372','016368','016376',
--'016512','016539','016516','016465','016377','017319','016502','016803','T005339','017255','017258','017259','017003','017004','016245','AF-002436','017027','017028','017034','017042','017080','018492',
--'018489','018488','018483','018327','018374','018302','T005342','T005344','016780','017387','016923','013465','F005877','F005885','F005882','F005881','013469','019719','016993','016937','016940','016939',
--'016942','016885','016888','016881','016887','016843','017143','016941','016944','016946','016965','017133','017134','017135','017136','017137','017138','017139','017140','017141','017142','019319','019320',
--'019322','019323','019337','019102','019144','019154','019157','019121','019127','019133','019135','019137','019174','018401','019385','019386','019387','019388','019389','006082','004205','AF-002366','015080',
--'014017','014016','014001','014002','014005','F005930','F005940','016291','014801','014846','af-003341','019581','015393','011823','F006090','015028','015046','016735','018426','006427','019831','F006139','F006128',
--'019832','019885','019840','019852','RG0054R','RG0038R','TRG0381R','TRG0383R','019752','019711','019769','019767','T003402','019957','019942','FRG0213R','FRG0215R','FRG0219R','FRG0218R','FRG0214R','FRG0212R',
--'FRG0220R','FRG0217R','019978','019954','020037','020058','020057','T005601','013758','014170','T005202','014276','013708','014915','014940','014953','013733','013862',
--'014951','014904','014954',
--'013628','015997','013989','010185','SILLA1','SILLA2','SILLA3','SILLA4','SILLAP1','SILLAP2','015675','015647','016586','016233','016548','016467','016366','016378','016645',
--'016647','016513','016690','017392','017390','015383','014293','016477','016482','016506','018353','018348','018344','018342','018339','018334',
--'016688','001820','016804','015987','016415','016417','017257','017252','016237','016238','017001','017005','AF-004070','017048','017039','017060',
--'017061','AF-001199','AF-004375','017083','NVA001','016763','018326','018373','016764','016766','016768','016428','016426','016817','016863',
--'016839','016832','016838','016800','016877','016488','016908','016909','016818','016961','017052','017054','017102','012011','014289',
--'017206','016989','016991','010621','016996','016997','016998','016990','016999','014786','017244','017599','017600','019245','015042','015374',
--'019258','019259','019280','019282','019318','019321','019324','019326','019327','019328','019330','019331','019332','019335','019338',
--'019261','019262','019265','019266','019267','019268','019269','019270','019271','019272','019273','015367','019275','019278','019052',
--'019062','019069','019077','019081','019100','018553','018555','019351','019352','018531','019111','018603','019113','019300','019140','019357',
--'019153',
--'019122',
--'019139',
--'019168',
--'019187',
--'019190',
--'019195',
--'019197',
--'019198',
--'019183',
--'019208',
--'019209',
--'019210',
--'019211',
--'019212',
--'019213',
--'019214',
--'019356',
--'017423',
--'017452',
--'017559',
--'019371',
--'015037',
--'001030',
--'019450',
--'019454',
--'007167',
--'019461',
--'019462',
--'019471',
--'019472',
--'019476',
--'017132',
--'019593',
--'005634',
--'014047',
--'014007',
--'014008',
--'013687',
--'013688',
--'014095',
--'017152',
--'017153',
--'017154',
--'017155',
--'019592',
--'017157',
--'015146',
--'019561',
--'014077',
--'014823',
--'014833',
--'014895',
--'015150',
--'001200',
--'015380',
--'015032',
--'014814',
--'012988',
--'012965',
--'012943',
--'015094',
--'015095',
--'011952',
--'019400',
--'017215',
--'012934',
--'015396',
--'019815',
--'015017',
--'014511',
--'019849',
--'019876',
--'019889',
--'F006171',
--'FRG0216R',
--'RG0206R',
--'RG0167R',
--'RG0212R',
--'RG0214R',
--'RG0246R',
--'RG0157R',
--'RG0235R',
--'RG0236R',
--'RG0174R',
--'019794R',
--'RG0232R',
--'RG0149R',
--'RG0204R',
--'RG0227R',
--'RG0198R',
--'RG0249R',
--'RG0256R',
--'RG0084R',
--'RG0216R',
--'RG0245R',
--'RG0250R',
--'RG0263R',
--'RG0139R',
--'RG0223R',
--'RG0240R',
--'000540R',
--'rg0279R',
--'RG0190R',
--'RG0210R',
--'RG0158R',
--'RG0081R',
--'RG0179R',
--'RG0242R',
--'020836',
--'014526',
--'014949','lg1927','015696','016582','016523','016399','016926','020438','020441','020876',
--'014540','TRG0415BAJA','FRG0236BAJA','017391','014579','014119','014178','014939','RG0284BAJA','RG0285BAJA','RG0286BAJA','RG0287BAJA',
--'RG0298BAJA','RG0299BAJA','RG0296BAJA','RG0280BAJA','RG0264BAJA','RG0171BAJA','RG0283BAJA','RG0049BAJA','RG0207BAJA','RG0281BAJA','RG0045BAJA',
--'RG0274BAJA','RG0172BAJA','RG0300BAJA','RG0165BAJA','RG0295BAJA','013838','013625','015719','016514','013456','RG0005R','014656',
--'011106','T005637','014858','003853',
----Bajas de Lerrennt, caso glpi 103092
--'013565',	'AF-003957',	'F004944',	'F004980',	'014577',	'014217',	'F005503',	'014120',	'013430',	'020184',	'020185',	'000018',	'000023',	'015898',	'014184',	'014281',	'014283',	'013403',	'013749',	'F005654',	'014913',	'014944',	'014945',	'014948',	'013953',	'013954',	'013955',	'013882',	'014669',	'013879',	'013334',	'015635',	'015632',	'016355',	'015638',	'016531',	'016515',	'016510',	'013792',	'016505',	'016501',	'016691',	'016736',	'014290',	'018485',	'002404',	'T005365',	'016702',	'016922',	'016925',	'016896',	'016895',	'017062',	'T005454',	'018088',	'019142',	'019143',	'019147',	'019149',	'019152',	'019123',	'019126',	'019128',	'019129',	'019130',	'019131',	'019134',	'019170',	'019171',	'019175',	'019176',	'019178',	'019189',	'019182',	'019184',	'018402',	'016727',	'017540',	'017550',	'017554',	'019286',	'019289',	'019393',	'019396',	'019360',	'014020',	'F005933',	'F006526',	'RG0409BAJA',	'RG0410BAJA',	'014612',	'014609',	'014613',	'015103',	'016841',	'017217',	'F006127',	'017764',	'017209',	'TRG0376',	'019777',	'015633',	'020047',	'020008',	'TRG0406',	'TRG0100',	'T005598',	'T005640',	'T005658',	'F006353',	'020439',	'020600',	'020800',	'021073',	'050744',	'050748',	'050757',	'050760',	'050770',	'050761',	'050070',	'050624',	'050738',	'050740',	'050741',	'050742',	'050756',	'050758',	'050768',	'050771',	'051167',	'050743',	'050071',	'050230',	'050425',	'050498',	'050585',	'050609',	'050662',	'050675',	'050678',	'050700',	'050791',	'050794',	'050620',	'050943',	'051051',	'050332',	'050341',	'050363',	'050382',	'050394',	'050411',	'050117',	'050320',	'050330',	'050339',	'050344',	'050362',	'050372',	'050371',	'050383',	'050402',	'050404',	'050648',	'050649',	'050660',	'050446',	'051258',	'051259',	'051260',	'051261',	'051262',	'051263',	'051264',	'050438',	'050581',	'050659',	'050974',	'051041',	'051042',	'050215',	'050108',	'050340',	'050434',	'050435',	'050684',	'050685',	'050686',	'050687',	'050688',	'050898',	'050429',	'050525',	'050533',	'050553',	'050571',	'050098',	'050153',	'050165',	'050176',	'050181',	'050186',	'050199',	'050200',	'050219',	'050227',	'050229',	'050239',	'050251',	'050268',	'050269',	'050292',	'050299',	'050304',	'050329',	'050351',	'050380',	'050444',	'050478',	'050479',	'050493',	'050504',	'050509',	'050519',	'050529',	'050545',	'050550',	'050566',	'050582',	'050583',	'050668',	'050801',	'050851',	'050890',	'050909',	'050921',	'051006',	'051050',	'051164',	'051204',	'051205',	'050236',	'050495',	'050564',	'050603',	'050689',	'050795',	'050812',	'050972',	'050997',	'051047',	'051048',	'051156',	'050522',	'050539',	'050551',	'050567',	'050218',	'050225',	'050238',	'050277',	'050284',	'050300',	'050130',	'050131',	'050132',	'050134',	'050135',	'050136',	'050137',	'050138',	'050156',	'050157',	'050162',	'050167',	'050173',	'050175',	'050182',	'050185',	'050191',	'050198',	'050205',	'050211',	'050214',	'050243',	'050249',	'050255',	'050258',	'050266',	'050271',	'050274',	'050288',	'050293',	'050305',	'050308',	'050325',	'050335',	'050336',	'050343',	'050353',	'050374',	'050386',	'050398',	'050405',	'050417',	'050418',	'050604',	'050783',	'050800',	'050810',	'050838',	'050843',	'050856',	'050863',	'050871',	'050891',	'050908',	'050927',	'050936',	'050120',	'050121',	'050326',	'050328',	'050334',	'050342',	'050360',	'050361',	'050373',	'050381',	'050388',	'050401',	'050419',	'050420',	'050833',	'050846',	'050849',	'050858',	'050866',	'050892',	'050928',	'050930',	'050969',	'050524',	'050531',	'050532',	'050540',	'050565',	'050322',	'050346',	'050356',	'050364',	'050370',	'050384',	'050395',	'050406',	'050412',	'050413',	'050447',	'050448',	'050449',	'050450',	'050451',	'050452',	'050453',	'050454',	'050455',	'050456',	'050457',	'050458',	'050459',	'050460',	'050461',	'050462',	'050463',	'050464',	'050465',	'050466',	'050467',	'050468',	'050469',	'050470',	'050471',	'050472',	'050473',	'050806',	'050813',	'050831',	'050171',	'050337',	'050309',	'050321',	'050355',	'050365',	'050368',	'050399',	'050407',	'050416',	'050640',	'051206',	'050082',	'050537',	'050538',	'050599',	'050642',	'050653',	'051034',	'050232',	'050422',	'050625',	'050641',	'050655',	'050657',	'050663',	'050672',	'050679',	'050681',	'050698',	'050722',	'050723',	'050776',	'050782',	'050788',	'050796',	'050807',	'050992',	'051025',	'051038',	'051149',	'051150',	'051152',	'051157',	'051207',	'051208',	'051209',	'050512',	'050477',	'050496',	'050803',	'050062',	'050100',	'050104',	'050144',	'050312',	'050515',	'050516',	'050586',	'050587',	'050590',	'050595',	'050699',	'050736',	'050772',	'050780',	'050781',	'051032',	'051035',	'051036',	'051039',	'051266',	'050066',	'050142',	'050317',	'050584',	'050593',	'050600',	'050617',	'050618',	'050619',	'050656',	'050661',	'050676',	'050680',	'050682',	'050727',	'050789',	'050804',	'050809',	'050811',	'051145',	'051146',	'051147',	'051158',	'050063',	'050068',	'050310',	'050423',	'050424',	'050432',	'050591',	'050646',	'050650',	'050674',	'050690',	'050691',	'050779',	'050824',	'051005',	'051212',	'050067',	'050099',	'050101',	'050102',	'050150',	'050193',	'050197',	'050275',	'050281',	'050287',	'050302',	'050316',	'050433',	'050499',	'050501',	'050502',	'050510',	'050511',	'050513',	'050514',	'050520',	'050535',	'050547',	'050598',	'050602',	'050726',	'050798',	'050830',	'050839',	'050929',	'051003',	'051019',	'051027',	'050445',	'050561',	'050629',	'050630',	'050572',	'050627',	'050628',	'050631',	'050632',	'050633',	'050634',	'050635',	'050636',	'050637',	'051267',	'051265',	'T005971',	'T005972',
----Bajas de Lerrennt, caso glpi 115624
--'014576',	'014584',	'014532',	'014529',	'014126',	'013983',	'013939',	'015456',	'000613',	'011891',	'011897',	'010011',	'015775',	'015664',	'015615',	'016388',	'017393',	'016503',	'T004521-A',	'018486',	'EX0320',	'016847',	'T005355',	'T005356',	'T005362',	'T005363',	'016840',	'016842',	'017055',	'017056',	'017063',	'TLG0695-A',	'013802',	'019070',	'019072',	'019095',	'019103',	'019105',	'019112',	'019118',	'019185',	'019188',	'019196',	'019200',	'019201',	'019181',	'017539',	'F005937',	'RG0401BAJA',	'RG0414BAJA',	'RG0402BAJA',	'RG0403BAJA',	'RG0404BAJA',	'RG0405BAJA',	'RG0406BAJA',	'RG0407BAJA',	'RG0408BAJA',	'015097',	'RG0104',	'TRG0380',	'TRG0378',	'020867',	'TRG0226',	'TRG0388',	'TRG0274',	'T005597',	'020674',	'020690',	'020903',	'020692',	'020682',	'020822',	'020768',	'020767',	'020894',	'021185',	'021224'
--)


UNION ALL


SELECT  ' ' AS IdIngreso, pa.AdquisitionDate AS FAdquisición, faibi.Id AS id_activo, 
           CASE WHEN l.Code LIKE 'C%' THEN 'Faca' WHEN l.Code LIKE 'B%' THEN 'Bogota' WHEN l.Code LIKE 'F%' THEN 'Florencia' WHEN l.Code LIKE 'n%' THEN 'Neiva' WHEN l.Code LIKE 'T%' THEN 'Tunja' WHEN l.Code LIKE 'P%' THEN 'Pitalito' WHEN l.Code LIKE 'M%' THEN 'Mocoa' END AS Sucursal, 'SaldInic' + ' - ' + RTRIM(faib.Code) AS Ingreso, 
           CASE faib.status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END AS Estado, faibi.AdquisitionDate AS Fecha, 
           CASE faibi.AdquisitionType WHEN '1' THEN 'CompraDirecta' WHEN '3' THEN 'Comodato' WHEN '4' THEN 'Donadacion' WHEN '5' THEN 'TraspasoBienes' WHEN '6' THEN 'OtroConcepto' WHEN '7' THEN 'LeasingFinanciero' WHEN '8' THEN 'Comodato Tercerizado' WHEN '9' THEN 'Renting Financiero' when '10' then 'Renting Operativo' END AS [Tipo Adquisición], RTRIM(fai.Code) AS CodArticulo, 
           RTRIM(fai.Description) AS [Artículo], CASE substring(ta.Code, 1, 2) 
           WHEN '01' THEN 'BIOMEDICO' WHEN '02' THEN 'INDUSTRIAL' WHEN '03' THEN 'INFRAESTRUCTURA' WHEN '04' THEN 'MOBILIARIO' WHEN '05' THEN 'MUEBLES_OFICINA' WHEN '06' THEN 'COMPUTO_COMUNICACIONES' WHEN '07' THEN 'INSTRUMENTAL_BIOMEDICO' WHEN '08' THEN 'ACCESORIO_BIOMEDICO' WHEN '09' THEN 'MEDICO_HOSPITALARIO' WHEN '10' THEN 'PATRON'
            WHEN '11' THEN 'OTROS' WHEN '12' THEN 'VEHICULOS' END AS TipoInventario, faibi.Plate AS 'Placa', mar.Name AS Marca, pa.Model AS Modelo, pa.Serie, 
			CASE faibi.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS EstadoActivo, RTRIM(t .Nit) + ' - ' + RTRIM(t .Name) AS Responsable, 
			RTRIM(l.Code) + ' - ' + RTRIM(l.Name) AS Localizacion, 
			RTRIM(UF.Code) AS CodUF , RTRIM(UF.Name) AS UnidadFuncional, RTRIM(cc.cODE) + ' - ' + RTRIM(CC.nAME) AS CentroCosto, faibi.AdquisitionDate AS FechaFactura, 'N/A' AS Factura, RTRIM(pv.Code) + ' - ' + RTRIM(pv.Name) AS Proveedor, faibi.HistoricalValue AS VrHistorico, padb.DepreciatedValue AS VrDepreciado, 
		  
		  --case  when padb.ResidualValue is null then faibi.HistoricalValue  when padb.ResidualValue =0 then faibi.HistoricalValue  else padb.ResidualValue end AS SaldoNeto,
		   padb.ResidualValue  AS SaldoNeto,
		   'SaldoInicial' AS Origen, RTRIM(cata.Code) 
           + ' - ' + RTRIM(cata.Description) AS Catálogo, 'N/A' AS Cuenta, RTRIM(pol.Code) + ' - ' + RTRIM(pol.Name) AS Poliza, 'SaldosIniciales' AS Descripción,
		   -- case when  padb.TransactionValue is not null then padb.TransactionValue else fatd.Value end AS VrTransacciones, 
			isnull(trans.valorizacion,0)-isnull(desv.valorizacion,0)  AS VrTransacciones, 

			FAIBI.WarrantyExpirationDate AS [Fecha vencimiento garantia], padb.LifeTime AS [VidaUtil], padb.DaysPendingDepreciate AS [DiasPendDepreciar], 
           padb.DepreciatedDays AS [DiasDepreciados], l.UseTime AS [Tiempo Uso], CASE fai.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END [Deprecia Tiempo Uso], '0' AS IvaItem, pa.NumberContractLeasing AS [Contrato Leasing], pa.InitialDateLeasing[Fecha Inicial Leasing], pa.EndDateLeasing AS [Fecha Final Leasing], 
		   case when padb.Devaluation is not null then padb.Devaluation else desv.valorizacion end as Desvalorizacion, trans.valorizacion as Valorizacion
FROM    FixedAsset.FixedAssetInitialBalanceItem AS faibi  LEFT OUTER JOIN
           FixedAsset.FixedAssetInitialBalanceItemDetailBook AS faibidb  ON faibidb.FixedAssetInitialBalanceItemId = faibi.Id AND faibidb.LegalBookId = '1' INNER JOIN
           FixedAsset.FixedAssetPhysicalAsset AS pa ON faibi.Plate = pa.Plate INNER JOIN
           FixedAsset.FixedAssetInitialBalance AS faib  ON faibi.FixedAssetInitialBalanceId = faib.Id INNER JOIN
           FixedAsset.FixedAssetTrademark AS mar ON mar.Id = PA.TrademarkId INNER JOIN
           FixedAsset.FixedAssetResponsible AS res  ON res.Id = pa.ResponsibleId INNER JOIN
           Common.ThirdParty AS t  ON t .Id = res.ThirdPartyId INNER JOIN
           .FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId INNER JOIN
           Common.Supplier AS pv  ON pv.Id = faibi.SupplierId INNER JOIN
           FixedAsset.FixedAssetItem AS fai  ON faibi.ItemId = fai.Id LEFT OUTER JOIN
           FixedAsset.FixedAssetItemType AS ta  ON ta.Id = fai.ItemTypeId INNER JOIN
           Payroll.FunctionalUnit AS UF  ON UF.Id = l.FunctionalUnitId LEFT OUTER JOIN
           FixedAsset.FixedAssetPolicy AS pol  ON pol.Id = faibi.PolicyId LEFT OUTER JOIN
		   (SELECT PA.PLATE AS Placa, art.ItemCatalogId as Catalogo
				FROM    FixedAsset.FixedAssetItem AS Art  INNER JOIN
					FixedAsset.FixedAssetPhysicalAsset AS pa  ON pa.ItemId = Art.Id ) as articulo on articulo.placa=faibi.plate left outer join

           FixedAsset.FixedAssetItemCatalog AS cata  ON cata.Id = articulo.catalogo LEFT OUTER JOIN
           FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb  ON padb.PhysicalAssetId = pa.id AND padb.legalbookid = '1' INNER JOIN
            Payroll.CostCenter AS cc ON cc.Id = uf.CostCenterId
		     LEFT OUTER JOIN FixedAsset.FixedAssetTransactionDetail AS fatd  on fatd.PhysicalAssetId=pa.id and fai.Description like '%lote%'
			  left outer join (select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='1' and ValorizationType='1'  and tt.status='2'
								group by t.PhysicalAssetId) as trans on trans.idactivo=pa.id	
			left outer join 	(select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='2' and ValorizationType='0'  and tt.status='2'  
								group by t.PhysicalAssetId) as desv on desv.idactivo=pa.id	
WHERE  (faib.Status <> '3')  


union all

SELECT  Ing.id AS IdIngreso, pa.AdquisitionDate AS FAdquisición, pa.Id AS id_activo, 
           CASE WHEN l.Code LIKE 'C%' THEN 'Faca' WHEN l.Code LIKE 'B%' THEN 'Bogota' WHEN l.Code LIKE 'F%' THEN 'Florencia' WHEN l.Code LIKE 'n%' THEN 'Neiva' WHEN l.Code LIKE 'T%' THEN 'Tunja' WHEN l.Code LIKE 'P%' THEN 'Pitalito' WHEN l.Code LIKE 'M%' THEN 'Mocoa' END AS Sucursal, Ing.Code AS Ingreso, 
           CASE Ing.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado'  END AS Estado, Ing.EntryDate AS Fecha, 
           CASE Ing.AdquisitionType WHEN '1' THEN 'CompraDirecta' WHEN '3' THEN 'Comodato' WHEN '4' THEN 'Donadacion' WHEN '5' THEN 'TraspasoBienes' WHEN '6' THEN 'OtroConcepto' WHEN '7' THEN 'LeasingFinanciero' WHEN '8' THEN 'Comodato Tercerizado' WHEN '9' THEN 'Renting Financiero'  when '10' then 'Renting Operativo' END AS [Tipo Adquisición], RTRIM(Art.Code) AS CodArticulo, 
           RTRIM(Art.Description) AS [Artículo], CASE substring(tart.Code, 1, 2) 
           WHEN '01' THEN 'BIOMEDICO' WHEN '02' THEN 'INDUSTRIAL' WHEN '03' THEN 'INFRAESTRUCTURA' WHEN '04' THEN 'MOBILIARIO' WHEN '05' THEN 'MUEBLES_OFICINA' WHEN '06' THEN 'COMPUTO_COMUNICACIONES' WHEN '07' THEN 'INSTRUMENTAL_BIOMEDICO' WHEN '08' THEN 'ACCESORIO_BIOMEDICO' WHEN '09' THEN 'MEDICO_HOSPITALARIO' WHEN '10' THEN 'PATRON'
            WHEN '11' THEN 'OTROS' WHEN '12' THEN 'VEHICULOS' END AS TipoInventario, pa.Plate AS Placa, mar.Name AS Marca, pa.Model AS Modelo, pa.Serie, CASE pa.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS EstadoActivo, RTRIM(t .Nit) + ' - ' + RTRIM(t .Name) AS Responsable, 
			RTRIM(l.Code) + ' - ' + RTRIM(l.Name) AS Localizacion, 
			RTRIM(UF.Code) AS CodUF , RTRIM(UF.Name) AS UnidadFuncional, RTRIM(cc.cODE) + ' - ' + RTRIM(CC.nAME) AS CentroCosto, Ing.InvoiceDate AS FechaFactura, Ing.EntryNumber AS Factura, RTRIM(pv.Code) + ' - ' + RTRIM(pv.Name) AS Proveedor, pa.HistoricalValue AS VrHistorico, padb.DepreciatedValue AS VrDepreciado, padb.ResidualValue AS SaldoNeto, 
           CASE DIng.RemissionSource WHEN '1' THEN 'Ninguna' WHEN '2' THEN 'OrdenCompra' WHEN '3' THEN 'Remision_Entrada' END AS Origen, 
		   rtrim(cata.Code) + ' - ' + rtrim(cata.Description) AS Catálogo, RTRIM(cue.Number) + ' - ' + RTRIM(cue.Name) AS Cuenta, RTRIM(pol.Code) + ' - ' + RTRIM(pol.Name) AS Poliza, Ing.Description AS Descripción, 
		  -- padb.TransactionValue 
		  isnull(trans.valorizacion,0)-isnull(desv.valorizacion,0)  AS VrTransacciones,    
		   EID.WarrantyExpirationDate AS [Fecha vencimiento garantia], padb.LifeTime AS [VidaUtil], padb.DaysPendingDepreciate AS [DiasPendDepreciar], padb.DepreciatedDays AS [DiasDepreciados], l.UseTime AS [Tiempo Uso], CASE art.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END [Deprecia Tiempo Uso], 
           DIng.IvaValue AS IvaItem, pa.NumberContractLeasing AS [Contrato Leasing], pa.InitialDateLeasing[Fecha Inicial Leasing], pa.EndDateLeasing AS [Fecha Final Leasing],
		   case when padb.Devaluation is not null then padb.Devaluation else desv.valorizacion end as Desvalorizacion, trans.valorizacion as Valorizacion
FROM    FixedAsset.FixedAssetEntry AS Ing  INNER JOIN
           FixedAsset.FixedAssetEntryItem AS DIng  ON Ing.Id = DIng.FixedAssetEntryId AND Ing.Status <> '3' INNER JOIN
           FixedAsset.FixedAssetEntryItemDetail AS eid  ON eid.FixedAssetEntryItemId = DIng.id INNER JOIN
           FixedAsset.FixedAssetItem AS Art  ON Art.Id = DIng.ItemId INNER JOIN
           FixedAsset.FixedAssetPhysicalAsset AS pa  ON pa.ItemId = Art.Id AND pa.plate = eid.plate INNER JOIN
           FixedAsset.FixedAssetItemType AS tart  ON tart.Id = Art.ItemTypeId INNER JOIN
           Common.OperatingUnit AS uo ON uo.Id = Ing.OperatingUnitId INNER JOIN
           Common.Supplier AS pv ON pv.Id = Ing.SupplierId INNER JOIN
           FixedAsset.FixedAssetTrademark AS mar ON mar.Id = pa.TrademarkId INNER JOIN
           GeneralLedger.MainAccounts AS cue  ON cue.Id = pa.MainAccountId AND cue.LegalBookId = '1' INNER JOIN
            .FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId INNER JOIN
           FixedAsset.FixedAssetResponsible AS res ON res.Id = pa.ResponsibleId /* AND pa.AdquisitionDate > '31/12/2016 00:00:00' */ INNER JOIN
           Common.ThirdParty AS t  ON t .Id = res.ThirdPartyId LEFT OUTER JOIN
           FixedAsset.FixedAssetPolicy AS pol  ON pol.Id = pa.PolicyId INNER JOIN
           Payroll.FunctionalUnit AS UF  ON UF.Id = l.FunctionalUnitId INNER JOIN
           FixedAsset.FixedAssetItemCatalog AS cata  ON cata.id = art.ItemCatalogId LEFT OUTER JOIN
           FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb  ON padb.PhysicalAssetId = pa.id AND padb.legalbookid = '1' INNER JOIN
           Payroll.CostCenter AS cc ON cc.Id = uf.CostCenterId 
		   left outer join (select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='1' and ValorizationType='1'  and tt.status='2'
								group by t.PhysicalAssetId ) as trans on trans.idactivo=pa.id	 
								left outer join 	(select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='2' and ValorizationType='0'  and tt.status='2'  
								group by t.PhysicalAssetId) as desv on desv.idactivo=pa.id	  
WHERE  (Ing.Status <> '3') AND pa.Status = '0' AND pa.hasoutput = '1'  and Ing.AdquisitionType in ('3','8') 


union all

SELECT   Ing.id AS IdIngreso, pa.AdquisitionDate AS FAdquisición, pa.Id AS id_activo, 
           CASE WHEN l.Code LIKE 'C%' THEN 'Faca' WHEN l.Code LIKE 'B%' THEN 'Bogota' WHEN l.Code LIKE 'F%' THEN 'Florencia' WHEN l.Code LIKE 'n%' THEN 'Neiva' WHEN l.Code LIKE 'T%' THEN 'Tunja' WHEN l.Code LIKE 'P%' THEN 'Pitalito' WHEN l.Code LIKE 'M%' THEN 'Mocoa' END AS Sucursal, Ing.Code AS Ingreso, 
           CASE Ing.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado'  END AS Estado, Ing.EntryDate AS Fecha, 
           CASE Ing.AdquisitionType WHEN '1' THEN 'CompraDirecta' WHEN '3' THEN 'Comodato' WHEN '4' THEN 'Donadacion' WHEN '5' THEN 'TraspasoBienes' WHEN '6' THEN 'OtroConcepto' WHEN '7' THEN 'LeasingFinanciero' WHEN '8' THEN 'Comodato Tercerizado' WHEN '9' THEN 'Renting Financiero' when '10' then 'Renting Operativo' END AS [Tipo Adquisición], RTRIM(Art.Code) AS CodArticulo, 
           RTRIM(Art.Description) AS [Artículo], CASE substring(tart.Code, 1, 2) 
           WHEN '01' THEN 'BIOMEDICO' WHEN '02' THEN 'INDUSTRIAL' WHEN '03' THEN 'INFRAESTRUCTURA' WHEN '04' THEN 'MOBILIARIO' WHEN '05' THEN 'MUEBLES_OFICINA' WHEN '06' THEN 'COMPUTO_COMUNICACIONES' WHEN '07' THEN 'INSTRUMENTAL_BIOMEDICO' WHEN '08' THEN 'ACCESORIO_BIOMEDICO' WHEN '09' THEN 'MEDICO_HOSPITALARIO' WHEN '10' THEN 'PATRON'
            WHEN '11' THEN 'OTROS' WHEN '12' THEN 'VEHICULOS' END AS TipoInventario, pa.Plate AS Placa, mar.Name AS Marca, pa.Model AS Modelo, pa.Serie, CASE pa.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS EstadoActivo, RTRIM(t .Nit) + ' - ' + RTRIM(t .Name) AS Responsable, 
			RTRIM(l.Code) + ' - ' + RTRIM(l.Name) AS Localizacion, 
			RTRIM(UF.Code) AS CodUF , RTRIM(UF.Name) AS UnidadFuncional, RTRIM(cc.cODE) + ' - ' + RTRIM(CC.nAME) AS CentroCosto, Ing.InvoiceDate AS FechaFactura, Ing.EntryNumber AS Factura, RTRIM(pv.Code) + ' - ' + RTRIM(pv.Name) AS Proveedor, pa.HistoricalValue AS VrHistorico, padb.DepreciatedValue AS VrDepreciado, padb.ResidualValue AS SaldoNeto, 
           CASE DIng.RemissionSource WHEN '1' THEN 'Ninguna' WHEN '2' THEN 'OrdenCompra' WHEN '3' THEN 'Remision_Entrada' END AS Origen, 
		   rtrim(cata.Code) + ' - ' + rtrim(cata.Description) AS Catálogo, RTRIM(cue.Number) + ' - ' + RTRIM(cue.Name) AS Cuenta, RTRIM(pol.Code) + ' - ' + RTRIM(pol.Name) AS Poliza, Ing.Description AS Descripción, 
		  -- padb.TransactionValue 
		  isnull(trans.valorizacion,0)-isnull(desv.valorizacion,0)  AS VrTransacciones,    
		   EID.WarrantyExpirationDate AS [Fecha vencimiento garantia], padb.LifeTime AS [VidaUtil], padb.DaysPendingDepreciate AS [DiasPendDepreciar], padb.DepreciatedDays AS [DiasDepreciados], l.UseTime AS [Tiempo Uso], CASE art.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END [Deprecia Tiempo Uso], 
           DIng.IvaValue AS IvaItem, pa.NumberContractLeasing AS [Contrato Leasing], pa.InitialDateLeasing[Fecha Inicial Leasing], pa.EndDateLeasing AS [Fecha Final Leasing],
		   case when padb.Devaluation is not null then padb.Devaluation else desv.valorizacion end as Desvalorizacion, trans.valorizacion as Valorizacion
FROM    FixedAsset.FixedAssetEntry AS Ing  INNER JOIN
           FixedAsset.FixedAssetEntryItem AS DIng  ON Ing.Id = DIng.FixedAssetEntryId AND Ing.Status <> '3' INNER JOIN
           FixedAsset.FixedAssetEntryItemDetail AS eid  ON eid.FixedAssetEntryItemId = DIng.id INNER JOIN
           FixedAsset.FixedAssetItem AS Art  ON Art.Id = DIng.ItemId INNER JOIN
           FixedAsset.FixedAssetPhysicalAsset AS pa  ON pa.ItemId = Art.Id AND pa.plate = eid.plate INNER JOIN
           FixedAsset.FixedAssetItemType AS tart  ON tart.Id = Art.ItemTypeId INNER JOIN
           Common.OperatingUnit AS uo ON uo.Id = Ing.OperatingUnitId INNER JOIN
           Common.Supplier AS pv ON pv.Id = Ing.SupplierId INNER JOIN
           FixedAsset.FixedAssetTrademark AS mar ON mar.Id = pa.TrademarkId INNER JOIN
           GeneralLedger.MainAccounts AS cue  ON cue.Id = pa.MainAccountId AND cue.LegalBookId = '1' INNER JOIN
           FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId INNER JOIN
           FixedAsset.FixedAssetResponsible AS res ON res.Id = pa.ResponsibleId /* AND pa.AdquisitionDate > '31/12/2016 00:00:00' */ INNER JOIN
           Common.ThirdParty AS t  ON t .Id = res.ThirdPartyId LEFT OUTER JOIN
           FixedAsset.FixedAssetPolicy AS pol  ON pol.Id = pa.PolicyId INNER JOIN
           Payroll.FunctionalUnit AS UF  ON UF.Id = l.FunctionalUnitId INNER JOIN
           FixedAsset.FixedAssetItemCatalog AS cata  ON cata.id = art.ItemCatalogId LEFT OUTER JOIN
           FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb  ON padb.PhysicalAssetId = pa.id AND padb.legalbookid = '1' INNER JOIN
            .Payroll.CostCenter AS cc ON cc.Id = uf.CostCenterId 
		   left outer join (select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='1' and ValorizationType='1'  and tt.status='2'
								group by t.PhysicalAssetId ) as trans on trans.idactivo=pa.id	 
								left outer join 	(select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='2' and ValorizationType='0'  and tt.status='2'  
								group by t.PhysicalAssetId) as desv on desv.idactivo=pa.id	  
WHERE  (Ing.Status <> '3') AND pa.Status = '1' AND pa.hasoutput = '1'  and Ing.AdquisitionType in ('3','8') 

union all

select 0 AS IdIngreso, pa.AdquisitionDate AS FAdquisición, pa.Id AS id_activo, 
			CASE WHEN l.Code LIKE 'C%' THEN 'Faca' WHEN l.Code LIKE 'B%' THEN 'Bogota' WHEN l.Code LIKE 'F%' THEN 'Florencia'
			WHEN l.Code LIKE 'n%' THEN 'Neiva' WHEN l.Code LIKE 'T%' THEN 'Tunja' WHEN l.Code LIKE 'P%' THEN 'Pitalito' 
			WHEN l.Code LIKE 'M%' THEN 'Mocoa' END AS Sucursal, '' AS Ingreso, 
			''  AS Estado, '' AS Fecha, 
			''AS [Tipo Adquisición], RTRIM(Art.Code) AS CodArticulo, 
			RTRIM(Art.Description) AS [Artículo], CASE substring(tart.Code, 1, 2) 
			WHEN '01' THEN 'BIOMEDICO' WHEN '02' THEN 'INDUSTRIAL' WHEN '03' THEN 'INFRAESTRUCTURA' WHEN '04' THEN 'MOBILIARIO' 
			WHEN '05' THEN 'MUEBLES_OFICINA' WHEN '06' THEN 'COMPUTO_COMUNICACIONES' WHEN '07' THEN 'INSTRUMENTAL_BIOMEDICO' WHEN '08' THEN 'ACCESORIO_BIOMEDICO' WHEN '09' THEN 'MEDICO_HOSPITALARIO' WHEN '10' THEN 'PATRON'
			WHEN '11' THEN 'OTROS' WHEN '12' THEN 'VEHICULOS' END AS TipoInventario, pa.Plate AS Placa,
			mar.Name AS Marca, pa.Model AS Modelo, pa.Serie, 
			CASE pa.Status WHEN '1' THEN 'Activo' WHEN '0' THEN 'Inactivo' END AS EstadoActivo, RTRIM(t .Nit) + ' - ' + RTRIM(t .Name) AS Responsable, 
			RTRIM(l.Code) + ' - ' + RTRIM(l.Name) AS Localizacion, 
			RTRIM(UF.Code) AS CodUF , RTRIM(UF.Name) AS UnidadFuncional, RTRIM(cc.cODE) + ' - ' + RTRIM(CC.nAME) AS CentroCosto,
			'' AS FechaFactura, '' AS Factura, '' AS Proveedor, pa.HistoricalValue AS VrHistorico, padb.DepreciatedValue AS VrDepreciado, padb.ResidualValue AS SaldoNeto, 
			'' AS Origen, 
			rtrim(cata.Code) + ' - ' + rtrim(cata.Description) AS Catálogo, RTRIM(cue.Number) + ' - ' + RTRIM(cue.Name) AS Cuenta, RTRIM(pol.Code) + ' - ' + RTRIM(pol.Name) AS Poliza, '0' AS Descripción, 
          
			-- padb.TransactionValue 
		  
			isnull(trans.valorizacion,0)-isnull(desv.valorizacion,0)   AS VrTransacciones, 
		   
			'' AS [Fecha vencimiento garantia], padb.LifeTime AS [VidaUtil], padb.DaysPendingDepreciate AS [DiasPendDepreciar], padb.DepreciatedDays AS [DiasDepreciados], l.UseTime AS [Tiempo Uso], CASE art.DepreciateByTimeUse WHEN 0 THEN 'NO' WHEN 1 THEN 'SI' END [Deprecia Tiempo Uso], 
			0 AS IvaItem, pa.NumberContractLeasing AS [Contrato Leasing], pa.InitialDateLeasing[Fecha Inicial Leasing], pa.EndDateLeasing AS [Fecha Final Leasing],
			case when padb.Devaluation is not null then padb.Devaluation else desv.valorizacion end as Desvalorizacion, trans.valorizacion as Valorizacion
from FixedAsset.FixedAssetPhysicalAsset AS pa INNER JOIN
FixedAsset.FixedAssetItem AS Art  ON pa.ItemId = Art.Id INNER JOIN
FixedAsset.FixedAssetItemType AS tart  ON tart.Id = Art.ItemTypeId INNER JOIN
			--Common.OperatingUnit AS uo ON uo.Id = Ing.OperatingUnitId INNER JOIN
			--Common.Supplier AS pv ON pv.Id = Ing.SupplierId INNER JOIN
			FixedAsset.FixedAssetTrademark AS mar ON mar.Id = pa.TrademarkId INNER JOIN
			GeneralLedger.MainAccounts AS cue  ON cue.Id = pa.MainAccountId AND cue.LegalBookId = '1' INNER JOIN
			.FixedAsset.FixedAssetLocation AS l  ON l.Id = pa.LocationId INNER JOIN
			FixedAsset.FixedAssetResponsible AS res ON res.Id = pa.ResponsibleId /* AND pa.AdquisitionDate > '31/12/2016 00:00:00' */ INNER JOIN
			Common.ThirdParty AS t  ON t .Id = res.ThirdPartyId LEFT OUTER JOIN
			FixedAsset.FixedAssetPolicy AS pol  ON pol.Id = pa.PolicyId INNER JOIN
			Payroll.FunctionalUnit AS UF  ON UF.Id = l.FunctionalUnitId INNER JOIN
			FixedAsset.FixedAssetItemCatalog AS cata  ON cata.id = art.ItemCatalogId LEFT OUTER JOIN
			FixedAsset.FixedAssetPhysicalAssetDetailBook AS padb  ON padb.PhysicalAssetId = pa.id AND padb.legalbookid = '1' INNER JOIN
			Payroll.CostCenter AS cc ON cc.Id = uf.CostCenterId 
			left outer join (select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='1' and ValorizationType='1'  and tt.status='2'
								group by t.PhysicalAssetId ) as trans on trans.idactivo=pa.id	 
								left outer join 	(select	t.PhysicalAssetId as idactivo, sum(t.totalvalue) as valorizacion
								from FixedAsset.FixedAssetTransactionDetail as t inner join
										FixedAsset.FixedAssetTransaction as tt on tt.id=t.FixedAssetTransactionid inner join
										FixedAsset.FixedAssetPhysicalAsset AS pa on pa.id=t.PhysicalAssetId
								where  TransactionType='2' and ValorizationType='0'  and tt.status='2'  
								group by t.PhysicalAssetId) as desv on desv.idactivo=pa.id	  
where pa.Status = '1' AND pa.hasoutput = '0'  and pa.plate not in (select plate
												from FixedAsset.FixedAssetEntryItemDetail)
						 and pa.plate not in (select plate
												from FixedAsset.FixedAssetInitialBalanceItem AS faibi  LEFT OUTER JOIN
													 FixedAsset.FixedAssetInitialBalanceItemDetailBook AS faibidb  ON faibidb.FixedAssetInitialBalanceItemId = faibi.Id AND faibidb.LegalBookId = '1' 
													 )




