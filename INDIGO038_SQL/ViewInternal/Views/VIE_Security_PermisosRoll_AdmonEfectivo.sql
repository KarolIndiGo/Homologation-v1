-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_Security_PermisosRoll_AdmonEfectivo
-- Extracted by Fabric SQL Extractor SPN v3.9.0


 CREATE VIEW [ViewInternal].[VIE_Security_PermisosRoll_AdmonEfectivo] as


SELECT 	distinct  p.fullname as Nombre, us.usercode as Cod_Usuario, us.position as Cargo,
case pu.IdForm when 731 then 'Modulo CxP - Notas Debito / Credito' when 532 then 'Modulo Contabilidad - Terceros' when 558 then 'Modulos CxP - Proveedores' when 626 then 'Modulo Admon. Efectivo - Caja'
when 628 then 'Modulo Admon. Efectivo - Cuentas Bancarias Entidades' when 635 then 'Modulo Admon. Efectivo - Recibos de Caja' when 739 then 'Modulo CxP - Extractos de CxP' 
when 742 then 'Modulo CxP - Listado de Notas' when 739 then 'Modulo CxP - Extractos de CxP' when 681 then 'Modulo CxP - Rangos de Provision'
when 686 then 'Modulo CxC - Notas Debito / Credito' when 687 then 'Modulo CxC - Cruce Anticipo vs CxC' when 695 then 'Modulo CxC - Listado de Traslado'
when 694 then 'Modulo CxC - Listado Notas' when 696 then 'Modulo CxC - Listado CxC' when 697 then 'Modulo CxC - Cartera por Edades' 
when 698 then 'Modulo CxC - Extracto de Cartera' when 699 then 'Modulo Contabilidad - PUC' when 718 then 'Modulo CxC - Parametros'
when 719 then 'Modulo CxC - Saldos Iniciales' when 722 then 'Modulo CxP - Razones Rechazo Factura' when 104 then 'Modulo Seguridad - Cambiar Contraseña'
when 105 then 'Modulo Seguridad - Desbloquear Usuario' when 1402 then 'Modulo Inventarios - Comprobante de Entrada' when 1403 then 'Modulo Inventarios - Devolucion de Compra'
when 1504 then 'Modulo Admon. Efentivo - Listado de Anticipos' when 1505 then 'Modulo CxP - Aceptacion Traslado' when 1506 then 'Modulo CxP - Trazabilidad de Documentos'
when 730 then 'Modulo CxP - Cuentas Por Pagar' when 734 then 'Modulo CxP - Traslado de Documentos' when 646 then 'Modulo Admon. Efectivo - Progrmaacion Pagos'
when 1694 then 'Modulo Admon. Efectivo - Confirmación Masiva' when 648 then 'Modulo Admon. Efectivo - Informe Recibos de Caja'
when 648 then 'Modulo Admon. Efectivo - Informe Comprobantes Egreso' when 650  then 'Modulo Admon. Efectivo - Informe de Notas'
when 651 then 'Modulo Admon. Efectivo - Informe Consignacion/Traslado CE' when 652 then 'Modulo Admon. Efectivo - Listado Boletin Tesoreria'
when 653 then 'Modulo Admon. Efectivo - Informe Reembolsos' when 655 then 'Modulo Admon. Efectivo - Cheques Anulados' 
when 656 then 'Modulo Admon. Efectivo - Listado Analisis Tesoreria' when 657 then 'Modulo Admon. Efectivo - Resumen Recibos de Caja'
when 658 then 'Modulo Admon. Efectivo - Listado por Conceptos' when 660 then 'Modulo Admon. Efectivo - Listado Programacion Pagos'
when 661 then 'Modulo Admon. Efectivo - Listado de Cheques' when 662 then 'Modulo Admon. Efectivo - Listado Cheques Girados'
when 664 then 'Modulo Admon. Efectivo - Libro de Caja' when 666 then 'Modulo Admon. Efectivo - Ingresos por Consignación'
when 668 then 'Modulo Admon. Efectivo - Diario Caja' when 1883 then 'Modulo Admon. Efectivo - Informe de Cruce CxC vs CxP' 
when 654 then 'Modulo Admon. Efectivo - Informe Recibos de Caja' when 649 then 'Modulo Admon. Informe Comprobantes Egreso'
when 639 then 'Modulo Admon. Efectivo - Reembolso de Caja Menor' when 640 then 'Modulo Admon. Efectivo - Cruce de Cuentas'
when 642 then 'Modulo Admon. Efectivo - Dispersion de Fondos' when 645 then 'Modulo Admon. Efectivo - Programacion de Pagos'
when 636 then 'Modulo Admon. Efectivo - Comprobantes de Egreso' when 637 then 'Modulo Admon. Efectivo - Notas'
when 638 then 'Modulo Admon. Efectivo - Consignaciones' when 647 then 'Modulo Admon. Efectivo - Cambio de Cheque'
when 507 then 'Modulo Admon. Efectivo - Bancos' when 624 then 'Modulo Admon. Efectivo - Conceptos de Nota'
when 630 then 'Modulo Admon. Efectivo - Conceptos Recibos de Caja'  when 631 then 'Modulo Admon. Efectivo - Concepto de Egreso'
when 632 then 'Modulo Admon. Efectivo - Franquicias Tarjetas de Credito' when 633 then 'Modulo Admon. Efectivo - Conceptos de Pago'
when 641 then 'Modulo Admon. Efectivo - Anulacion de Cheques' when 1947 then 'Modulo Admon. Efectivo - Fondo de Caja Menor'
when 1956 then 'Modulo Admon. Efectivo - Conciliacion Bancaria' when 669 then 'Modulo Admon. Efectivo - Parametros'
else pu.IdForm end as Formulario, 


CASE Pu.ACTION WHEN  1 THEN 'Eliminar' WHEN 2 THEN 'Guardar' when 3 then 'Actualizar' when 7 then 'Confirmar' when 8 then 'Anular' when 16 then 'Adjuntar' when 17 then 'Digitalizar'
when 18 then 'Abrir' when 22 then 'Visualizar Reporte' when 23 then 'Imprimir Reporte'  when 40 then 'Consultar' when 41 then 'Visible' when 19 then 'Auditoria' 
when 33 then 'Activar e Inactivar' when 24 then'Exportar Formato Lectura' when 25 then 'Exportar Formato Escritura' when 70 then 'Personalizar Reporte' when 35 then 'Refrescar Rejillas'
when 71 then 'Modificar Tope Anual' when 13 then 'Documentos' when 75 then 'Entrega Manual' when 73 then 'Modificar Cantidad y Agregar Productos' when 45 then 'Liquidar Todo'
when 11 then 'Customizar' when 51 then 'Causacion'
 else pu.action end as Accion
FROM Security.PermissionRoll as pu
join  Security.[User] AS us on us.RollCode=pu.IdRoll
join Security.PermissionCompany as pc on pc.IdUser=us.Id
join Security.Person as p on p.id=us.IdPerson
where  pc.IdContainer=38 and IdForm in ('507','624','626','628','630','631','632','633','635','636','637','638','639','640','641','642','645','646','647','169','1694','1947','1956','669',
'670','648','649','650','651','652','653','654','655','656','657','658','659','660','661','662','663','664','665','666','667','668','1504','1883') AND US.State=1 -- and us.IdPerson='2435'
--order by p.Fullname , pu.IdForm
