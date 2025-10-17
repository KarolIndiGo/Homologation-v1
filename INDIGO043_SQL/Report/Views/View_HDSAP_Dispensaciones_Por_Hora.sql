-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_Dispensaciones_Por_Hora
-- Extracted by Fabric SQL Extractor SPN v3.9.0






/*******************************************************************************************************************
Nombre: Dispensaciones
Tipo:Vista
Observacion: Dispensaciones_Por_Hora
Profesional: Milton Urbano Bolañoz
Fecha:13-08-2025 (Modificació) _ CantidadDevuelta
-----------------------------------------------------------------*/




CREATE VIEW [Report].[View_HDSAP_Dispensaciones_Por_Hora] AS

SELECT --top 10
       CAST(pdd.ServiceDate as date) AS 'Fecha', 
	   CAST(CAST(pdd.ServiceDate as time) as varchar(8)) AS 'Hora', 
       pd.Code AS 'ConsecutivoDispensacion', 
       ing.IPCODPACI AS 'DocumentoPaciente', 
       pd.AdmissionNumber AS 'Ingreso',
       CASE ing.TIPOINGRE
           WHEN '1'
           THEN 'Ambulatorio'
           WHEN '2'
           THEN 'Hospitalario'
       END AS 'TipoIngreso', 
       pac.IPNOMCOMP AS 'NombrePaciente', 
       al.Name AS 'Almacen', 
       pd.CreationUser AS 'CodigoAuxDisp', 
       pr.Code AS 'CodigoProducto', 
       pr.Name AS 'NombreProducto', 
       pdd.Quantity AS 'CantidadSolicitada',
	   pdd.ReturnedQuantity AS 'CantidadDevuelta',  
       pdd.OrderedHealthProfessionalCode AS 'CodigoAuxiliar', 
       aux.NOMMEDICO AS 'NombreAuxiliar', 
       uf.Name AS 'UnidadFuncional',
       en.NOMENTIDA as 'Entidad'
FROM Inventory.PharmaceuticalDispensing AS pd
     JOIN Inventory.PharmaceuticalDispensingDetail AS pdd ON pdd.PharmaceuticalDispensingId = pd.Id
     JOIN dbo.ADINGRESO AS ing ON ing.NUMINGRES = pd.AdmissionNumber
     JOIN dbo.INPACIENT AS pac ON pac.IPCODPACI = ing.IPCODPACI
     JOIN Inventory.Warehouse AS al ON al.Id = pdd.WarehouseId
     JOIN Inventory.InventoryProduct AS pr ON pr.Id = pdd.ProductId
     JOIN dbo.INPROFSAL AS aux ON aux.CODPROSAL = pdd.OrderedHealthProfessionalCode
     JOIN Payroll.FunctionalUnit AS uf ON uf.Id = pdd.FunctionalUnitId
     LEFT JOIN dbo.INENTIDAD as en on ing.CODENTIDA=en.CODENTIDA
  

