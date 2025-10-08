-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: SP_IND_SP_V2_ERP_COTIZACIONES
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE   PROCEDURE Report.SP_IND_SP_V2_ERP_COTIZACIONES
AS

SELECT 
    Q.Code [DOCUMENTO COTIZACION]
    , DocumentDate [FECHA COTIZACION]
    ,case Q. QuotationType 
        when 1 then 'INTRAHOSPITLARIO' 
        WHEN 2 THEN 'AMBULATORIO' 
        END [TIPO COTIZACION], 
    CASE Q.Status 
        WHEN 1 THEN 'REGISTRADO' 
        WHEN 2 THEN 'CONFIRMADO' 
        ELSE 'OTRO' END [ESTADO]
    ,AdmissionNumber [INGRESO]
    , TP.Nit [IDENTIFICACION]
    ,TP.Name [PACIENTE]
    , Q.Description [DESCRIPCION]
    ,'SERVICIOS' [TIPO]
    , HA.Name [ENTIDAD]
    ,CG.Code [CODIGO GRUPO ATENCION]
    , CG.Name [GRUPO DE ATENCION]
    ,TP2.Nit [NIT]
    ,TP2.Name [TERCERO]
    ,CUPS.Code [CUPS]
    ,CUPS.Description [DESCRIPCION CUPS]
    , SERVICIOSIPS.Code [CODIGO SERVICIO/PRODUCTO]
    ,SERVICIOSIPS.Name [SERVICIO/PRODUCTO]
    ,QX.Code [CODIGO HIJO]
    , QX.Name [SERVICIO HIJO]
    ,QSOD.InvoicedQuantity [CANTIDAD]
    , iif (QSODS.Id is null,QSOD.RateManualSalePrice,QSODS.TotalSalesPrice) [VALOR TARIFA],
    QSOD.ServiceDate [FECHA SERVICIO], QSOD.AuthorizationNumber [NRO AUTORIZACION], 
    FU.Code + ' - ' + FU.Name [UNIDAD FUNCIONAL SERVICIO], RTRIM(MED.CODPROSAL) + ' - ' + MED.NOMMEDICO [PROFESIONAL],
    iif (QSODS.Id is null,QSOD.SubTotalSalesPrice,QSODS.TotalSalesPrice) [PRECIO UNITARIO SERVICIO],  
    iif (QSODS.Id is null,QSOD.GrandTotalSalesPrice,QSODS.TotalSalesPrice) [PRECIO TOTAL SERVICIO],QSOD.GrandTotalSalesPrice [VALOR TOTAL ORDEN],
    '' [ALMACEN]
FROM INDIGO036.Billing.Quotation Q 
join INDIGO036.Billing.QuotationServiceOrderDetail QSOD  ON QSOD .QuotationId =Q.Id 
JOIN INDIGO036.Common.OperatingUnit OU   ON Q.OperatingUnitId =OU.Id 
LEFT JOIN INDIGO036.Common.ThirdParty AS TP  ON TP.Id =Q.ThirdPartyId  
LEFT JOIN INDIGO036.Contract.HealthAdministrator AS HA  ON HA.Id =QSOD.HealthAdministratorId 
LEFT JOIN INDIGO036.Contract.CareGroup CG  ON QSOD.CareGroupId =CG.Id 
LEFT JOIN INDIGO036.Common.ThirdParty AS TP2  ON TP2.Id =QSOD.ThirdPartyId 
LEFT JOIN INDIGO036.Contract.CUPSEntity AS CUPS  ON CUPS.Id = QSOD.CUPSEntityId
LEFT JOIN INDIGO036.Contract.IPSService AS SERVICIOSIPS  ON SERVICIOSIPS.Id = QSOD.IPSServiceId
LEFT JOIN INDIGO036.Payroll .FunctionalUnit FU  ON FU.CostCenterId =QSOD.PerformsFunctionalUnitId  
LEFT JOIN INDIGO036.dbo.INPROFSAL AS MED  ON MED.CODPROSAL = QSOD.PerformsHealthProfessionalCode
LEFT JOIN INDIGO036.Payroll .CostCenter AS CC  ON CC.Id =QSOD.CostCenterId  
LEFT JOIN INDIGO036.Billing .QuotationServiceOrderDetailSurgical AS QSODS  ON QSODS.QuotationServiceOrderDetailId =QSOD.Id 
LEFT JOIN INDIGO036.Contract.IPSService AS QX  ON QX.Id = QSODS.IPSServiceId AND QSODS.QuotationServiceOrderDetailId =QSOD.Id
--WHERE Q.Code ='00000285' AND QSOD.ISDELETE = '0'
union 
SELECT Q.Code [DOCUMENTO COTIZACION], DocumentDate [FECHA COTIZACION], case Q. QuotationType when 1 then 'INTRAHOSPITLARIO' WHEN 2 THEN 'AMBULATORIO' END [TIPO COTIZACION], 
CASE Q.Status WHEN 1 THEN 'REGISTRADO' WHEN 2 THEN 'CONFIRMADO' ELSE 'OTRO' END [ESTADO],AdmissionNumber [INGRESO], 
TPP.Nit [IDENTIFICACION],TPP.Name [PACIENTE], Q.Description [DESCRIPCION],'PRODUCTOS' [TIPO],HAP.Name [ENTIDAD],CGP.Code [CODIGO GRUPO ATENCION], CGP.Name [GRUPO DE ATENCION],
TPP.Nit [NIT],TPP.Name [TERCERO],'' [CUPS],'' [DESCRIPCION CUPS],PRO.Code [CODIGO SERVICIO/PRODUCTO],PRO.Name [SERVICIO/PRODUCTO],
'' [CODIGO HIJO], '' [SERVICIO HIJO],
Quantity [CANTIDAD],SalePrice [VALOR TARIFA],
QPDD.ServiceDate [FECHA SERVICIO],QPDD.AuthorizationNumber [NRO AUTORIZACION],FUP.Code + ' - ' + FUP.Name [UNIDAD FUNCIONAL SERVICIO],RTRIM(MEDP.CODPROSAL) + ' - ' + MEDP.NOMMEDICO [PROFESIONAL],
QPDD.TotalSalesPrice [PRECIO UNITARIO SERVICIO], QPDD.GrandTotalSalesPrice [PRECIO TOTAL SERVICIO],QPDD.GrandTotalSalesPrice [VALOR TOTAL ORDEN], WH.Code + ' - ' + WH.Name [ALMACEN]
FROM INDIGO036.Billing.Quotation Q 
JOIN INDIGO036.Billing.QuotationPharmaceuticalDispensingDetail QPDD  ON Q.Id =QPDD.QuotationId 
LEFT JOIN INDIGO036.Contract.HealthAdministrator AS HAP  ON HAP.Id =QPDD.HealthAdministratorId 
LEFT JOIN INDIGO036.Contract.CareGroup CGP  ON QPDD.CareGroupId =CGP.Id 
LEFT JOIN INDIGO036.Common.ThirdParty AS TPP  ON TPP.Id =Q.ThirdPartyId
LEFT JOIN INDIGO036.Inventory.InventoryProduct PRO  ON PRO.Id =QPDD.ProductId
LEFT JOIN INDIGO036.Inventory.Warehouse WH  ON WH.Id =QPDD .WarehouseId 
LEFT JOIN INDIGO036.Payroll.FunctionalUnit FUP  ON FUP.CostCenterId =QPDD.FunctionalUnitId 
LEFT JOIN INDIGO036.dbo.INPROFSAL AS MEDP  ON MEDP.CODPROSAL = QPDD.OrderedHealthProfessionalCode
