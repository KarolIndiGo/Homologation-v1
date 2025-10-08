-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_SERVICIOS_FACTURADOS_MEDICAMENTOS_2022
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_VIE_SERVICIOS_FACTURADOS_MEDICAMENTOS_2022 
as
select  
    AdmissionNumber
    , Factura
    , Tipo_Documento_Facturado
    , IPS
    , Red
    , Formula
    , Id_Formula
    , Identificacion_Paciente
    , Nombre_Paciente
    , TipoProducto
    , Cod_Medicamento_Insumo
    , Medicamento_Insumo
    , CUM
    , Producto
    , CodeAlternativeTwo
    , Estado
    , ProdControl
    , AltoCosto
    , Almacen
    , CantidadFactura
    , ValorUnitario
    , ValorTotal
    , CostoPromedioActual
    , CostoPromedioVenta
    , CostoPromedioTotal
    , Ingreso
    , FechaFactura
    , MesFactura
    , AñoFactura
    , UsuarioFactura
    , FechaRegistro
    , TipoDispensacion
    , Fecha_Dispensacion
    , Fecha_Modificacion_Dispensacion
    , Grupo_Atencion
    , Codigo_Grupo_Farmacologico
    , Grupo_Farmacologico
    , Presentation
    , Dpto
    , Municipio
    , Unidad_Operativa
    , M.Grupo
    , DifDiasDispVSFact
    , DifHorasDispVSFact
    , ProfesionOrdena
    , Codigo_DCI
    , DCI
    , Tipo_Liquidacion
    , CentroCostoDispensacion
    , CentroCostoFacturacion
    , NumeroCtaCosto
    , CuentaCosto
    , NumeroCtaVenta
    , CuentaVenta
    , EstadoIngreso

from [DataWareHouse_Finance].[ViewInternal].[VW_VIE_SERVICIOS_FACTURADOS_MEDICAMENTOS_2022_D] as M 
left outer join [DataWareHouse_Finance].[ViewInternal].[VW_VIE_AD_AD_INVENTORY_CTAGRUPOSPRODUCTOS] as c on c.CodUF=M.CodUF and c.CodGrupo=M.CodGrupo
