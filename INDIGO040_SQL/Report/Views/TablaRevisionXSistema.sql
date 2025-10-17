-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: TablaRevisionXSistema
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [Report].[TablaRevisionXSistema] as

select HC.numingres,HC.ipcodpaci,RS.idhchispaca,RS.idrsvariable,RS.valor,HC.FECHISPAC,VAL.VARIABLE
from 
(
	select * from RSVALORES202104
	UNION ALL	
	select * from RSVALORES202105
	UNION ALL											
	select * from RSVALORES202106
	UNION ALL											
	select * from RSVALORES202107
	UNION ALL											
	select * from RSVALORES202108
	UNION ALL											
	select * from RSVALORES202109
	UNION ALL											
	select * from RSVALORES202110
	UNION ALL											
	select * from RSVALORES202111
	UNION ALL											
	select * from RSVALORES202112
	UNION ALL											
	select * from RSVALORES202201
	UNION ALL											
	select * from RSVALORES202202
	UNION ALL											
	select * from RSVALORES202203
	UNION ALL											
	select * from RSVALORES202204
	UNION ALL											
	select * from RSVALORES202205
	UNION ALL											
	select * from RSVALORES202206
	UNION ALL											
	select * from RSVALORES202207
	UNION ALL											
	select * from RSVALORES202208
	UNION ALL											
	select * from RSVALORES202209
	UNION ALL											
	select * from RSVALORES202210
	UNION ALL											
	select * from RSVALORES202211
	UNION ALL											
	select * from RSVALORES202212
	UNION ALL											
	select * from RSVALORES202301
	UNION ALL									
	select * from RSVALORES202302
	UNION ALL
	select * from RSVALORES202303
	UNION ALL
	select * from RSVALORES202304
	UNION ALL									
	select * from RSVALORES202305
	UNION ALL									
	select * from RSVALORES202307
	UNION ALL									
	select * from RSVALORES202308
	UNION ALL									
	select * from RSVALORES202309
	UNION ALL									
	select * from RSVALORES202310
	UNION ALL									
	select * from RSVALORES202311
	UNION ALL									
	select * from RSVALORES202312
	UNION ALL									
	select * from RSVALORES202401
)  as RS
INNER JOIN HCHISPACA AS HC WITH(NOLOCK) ON HC.ID=RS.IDHCHISPACA INNER JOIN
dbo.RSVARIABLES VAL ON RS.IDRSVARIABLE=VAL.ID



