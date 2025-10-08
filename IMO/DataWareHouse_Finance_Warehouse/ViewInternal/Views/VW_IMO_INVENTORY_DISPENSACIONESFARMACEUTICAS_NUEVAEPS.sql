-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_INVENTORY_DISPENSACIONESFARMACEUTICAS_NUEVAEPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   VIEW ViewInternal.VW_IMO_INVENTORY_DISPENSACIONESFARMACEUTICAS_NUEVAEPS
AS

SELECT  Sede,[Tipo documento], Documento, Fecha, Mes, Identificacion, Paciente, mu.DEPMUNCOD as CodMunicipio,mu.MUNNOMBRE AS Municipio, DEP.depcodigo AS CodDpto, DEP.nomdepart AS Departamento, Nit, Entidad
Cod_Producto, Producto, [Codigo alterno], [Codigo alterno 2], [Codigo Subgrupo], [Codigo ATC], [Codigo CUM], CodAlmacen, AlmacenDespacho, 
TipoProducto, CantidadSolicitada, CantidadDevuelta, Cantidad, Unidad_Destino, Presentacion, CIE10, Diagnostico, CodProfesional, [Profesional Ordena], Especialidad, CentroAtencion, 
Lote, FechaVencimiento
FROM [ViewInternal].[VW_IMO_INVENTORY_DISPENSACIONESFARMACEUTICAS] as a
left join [INDIGO035].[dbo].[INPACIENT] as p on a.Identificacion = p.IPCODPACI
LEFT JOIN [INDIGO035].[dbo].[INUBICACI] AS UB ON UB.AUUBICACI = p.AUUBICACI
LEFT JOIN [INDIGO035].[dbo].[INMUNICIP] AS mu ON mu.DEPMUNCOD = UB.DEPMUNCOD
LEFT JOIN [INDIGO035].[dbo].[INDEPARTA] AS DEP ON DEP.depcodigo = mu.DEPCODIGO
WHERE Entidad like '%NUEVA%'