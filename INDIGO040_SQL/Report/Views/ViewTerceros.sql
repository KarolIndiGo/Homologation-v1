-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewTerceros
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW Report.ViewTerceros AS

select  
Ct.nit AS 'NIT', 
Ct.digitverification AS 'DV',
Ct.NAME AS 'TERCERO', 
CA.Addresss AS 'DIRECCION',
CP.Phone AS 'TELEFONO',
CE.Email AS 'EMAIL',
cea.code AS 'COD ACTIVIDAD ECONOMICA',
CEA.NAME AS 'NOMBRE ACTIVIDAD ECONOMICA',
CT.CODECIIU AS 'CODIGO CIIU',
CASE CE.Type WHEN 1 THEN 'Notificaciones varias'
             WHEN 2 THEN 'Notificación Facturación Electrónica'END AS TIPO,
iif(pro.id is null,'NO','SI') as PROVEEDOR,
iif(pac.id is null,'NO','SI') as PACIENTE,
iif(CC.id is null,'NO','SI') as CLIENTE,
iif(PE.id is null,'NO','SI') as TALENTO_HUMANO
from Common.ThirdParty CT 
left JOIN Common.Address CA ON CT.PersonId = CA.IdPerson
left JOIN Common.Phone CP ON CT.PersonId = CP.IdPerson
left JOIN Common.Email CE ON CT.PersonId = CE.IdPerson
left join Common.Supplier pro on ct.id=pro.IdThirdParty
left join DBO.INPACIENT pac on ct.nit=pac.IPCODPACI
LEFT JOIN Common.Customer cc ON CT.Nit = CC.Nit
LEFT JOIN Payroll.Employee PE ON CT.Id =PE.ThirdPartyId
left join common.EconomicActivity cea on ct.EconomicActivityId = cea.id
 