-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_VIE_SERVICIOS_FACTURADOS_ODONTOSALUD
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW  ViewInternal.VW_VIE_SERVICIOS_FACTURADOS_ODONTOSALUD
as
select * from [DataWareHouse_Finance].[ViewInternal].[VW_VIE_SERVICIOS_FACTURADOS]
where CUPS in ('232102', '232200', '237103', '890203', '890303', 
    '890703', '990203', '990212', '997002', '997106', 
    '997107', '997301');
