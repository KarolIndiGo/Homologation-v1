-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_Inventory_DispensacionesFarmaceuticas_NuevaEPS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[IMO_Inventory_DispensacionesFarmaceuticas_NuevaEPS] AS
SELECT  Sede,[Tipo documento], Documento, Fecha, Mes, Identificacion, Paciente, mu.DEPMUNCOD as CodMunicipio,mu.MUNNOMBRE AS Municipio, DEP.depcodigo AS CodDpto, DEP.nomdepart AS Departamento, Nit, Entidad
Cod_Producto, Producto, [Código alterno], [Código alterno 2], [Código Subgrupo], [Código ATC], [Código CUM], CodAlmacen, AlmacenDespacho, 
TipoProducto, CantidadSolicitada, CantidadDevuelta, Cantidad, Unidad_Destino, Presentacion, CIE10, Diagnostico, CodProfesional, [Profesional Ordena], Especialidad, CentroAtencion, 
Lote, FechaVencimiento
FROM [ViewInternal].[IMO_Inventory_DispensacionesFarmaceuticas] as a
left join dbo.INPACIENT as p with (nolock) on a.Identificacion = p.IPCODPACI
LEFT JOIN dbo.INUBICACI AS UB WITH (NOLOCK) ON UB.AUUBICACI = p.AUUBICACI
LEFT JOIN dbo.INMUNICIP AS mu WITH (NOLOCK) ON mu.DEPMUNCOD = UB.DEPMUNCOD
LEFT JOIN dbo.INDEPARTA AS DEP WITH (NOLOCK) ON DEP.depcodigo = mu.DEPCODIGO
WHERE Entidad like '%Nueva%'