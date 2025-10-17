-- Workspace: SQLServer
-- Item: INDIGO031 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: VIE_Servicios_Facturados_Odontosalud
-- Extracted by Fabric SQL Extractor SPN v3.9.0

create view  [ViewInternal].[VIE_Servicios_Facturados_Odontosalud]
as
select * from [ViewInternal].[VIE_Servicios_Facturados]
where cups in ('232102', '232200', '237103', '890203', '890303', 
    '890703', '990203', '990212', '997002', '997106', 
    '997107', '997301');