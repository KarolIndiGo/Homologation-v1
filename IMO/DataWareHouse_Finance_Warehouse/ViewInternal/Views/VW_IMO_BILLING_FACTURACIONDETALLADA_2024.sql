-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_BILLING_FACTURACIONDETALLADA_2024
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   VIEW ViewInternal.VW_IMO_BILLING_FACTURACIONDETALLADA_2024
AS 

SELECT * FROM [DataWareHouse_Finance].[ViewInternal].[VW_IMO_BILLING_FACTURACIONDETALLADA]
WHERE YEAR([Fecha Factura])='2024'
