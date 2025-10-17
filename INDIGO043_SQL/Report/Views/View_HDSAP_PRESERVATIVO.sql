-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_PRESERVATIVO
-- Extracted by Fabric SQL Extractor SPN v3.9.0


-- =============================================
-- Author:		Miguel Angel Ruiz Vega
-- Create date: 03-01-2024
-- Description:	IAMI
-- =============================================

CREATE VIEW [Report].[View_HDSAP_PRESERVATIVO]
AS



select          
                   d.DocumentDate Fecha,
                   CASE pa.IPTIPODOC
                             WHEN '1'
                             THEN 'CC'
                             WHEN '2'
                             THEN 'CE '
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
							 WHEN 9
							 THEN 'CN'
							 WHEN 11
							 THEN 'SC'
							 WHEN 12
							 THEN 'PE'
							 WHEN 13
							 THEN 'PT'
							 WHEN 14
							 THEN 'DE'
							 WHEN 15
							 THEN 'SI'
                         END AS 'Tipo de documento de identidad', 
						 pa.IPCODPACI 'No. De Identificación',
						 pa.IPPRIAPEL 'Apellido 1',
						 pa.IPSEGAPEL 'Apellido 2',
						 pa.IPPRINOMB 'Nombre 1',
						 pa.IPSEGNOMB 'Nombre 2',
						 n.NOMENTIDA EPS,
						 pa.IPFECNACI 'FECHA DE NACIMIENTO',
						 (datediff (year,pa.IPFECNACI, getdate ())) EDAD,
						 depa.NOMDEPART Departamento,
						 mun.MUNNOMBRE Municipio,
						 case ubi.TIPOUBICA 
						 when 0
						 then 'Urbano'
						 when 1
						 then 'Rural'
						 end Zona,
						 pa.IPTELEFON 'Teléfono usuaria',
						 pa.IPDIRECCI 'Dirección de Residencia',
						 'Descripcion CUPS' PRESERVATIVOS
						 

from Inventory.PharmaceuticalDispensing d
join Inventory.PharmaceuticalDispensingDetail pd on pd.PharmaceuticalDispensingId = d.id
join Inventory.InventoryProduct i on i.id = pd.ProductId
join ADINGRESO ad on ad.NUMINGRES = d.AdmissionNumber
 join INPACIENT pa on pa.IPCODPACI = ad.IPCODPACI
left join INENTIDAD n on n.CODENTIDA = pa.CODENTIDA
INNER JOIN INUBICACI AS UBI ON pa.AUUBICACI= UBI.AUUBICACI
INNER JOIN INMUNICIP AS MUN ON UBI.DEPMUNCOD= MUN.DEPMUNCOD
INNER JOIN INDEPARTA AS depa on depa.DEPCODIGO = MUN.DEPCODIGO

where i.code in ( 'dm-00302') and pd.Quantity = 15
