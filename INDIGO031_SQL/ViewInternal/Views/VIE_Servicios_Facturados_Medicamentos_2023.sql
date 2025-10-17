-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_Servicios_Facturados_Medicamentos_2023
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[VIE_Servicios_Facturados_Medicamentos_2023] as
select  AdmissionNumber, Factura, Tipo_Documento_Facturado, IPS, Red, Formula, Id_Formula, Identificacion_Paciente, Nombre_Paciente, TipoProducto, Cod_Medicamento_Insumo, Medicamento_Insumo, CUM, Producto, CodeAlternativeTwo, Estado, ProdControl, AltoCosto, 
             Almacen, CantidadFactura, ValorUnitario, ValorTotal, CostoPromedioActual, CostoPromedioVenta, CostoPromedioTotal, Ingreso, FechaFactura, MesFactura, AñoFactura, UsuarioFactura, FechaRegistro, TipoDispensacion, Fecha_Dispensacion, Fecha_Modificacion_Dispensacion, 
             Grupo_Atencion, Codigo_Grupo_Farmacologico, Grupo_Farmacologico, Presentation, Dpto,  m.Grupo, DifDiasDispVSFact, DifHorasDispVSFact, ProfesionOrdena, Codigo_DCI, DCI, Tipo_Liquidacion, CentroCostoDispensacion, CentroCostoFacturacion, 
            NumeroCtaCosto, CuentaCosto, NumeroCtaVenta, CuentaVenta, EstadoIngreso
from [ViewInternal].[VIE_Servicios_Facturados_Medicamentos_2023_D] as M 
left outer join ViewInternal.VIE_AD_AD_Inventory_CtaGruposProductos as c on c.CodUF=m.CodUf and c.CodGrupo=m.CodGrupo
