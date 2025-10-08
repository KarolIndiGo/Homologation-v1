-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_BILLING_FACTURACIONMONTOFIJO
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW ViewInternal.IMO_Billing_FacturacionMontoFijo
AS

select  FC.Code AS CodigoFactura,UO.UnitName AS UnidadOperativa,FC.DocumentDate as FechaDocumento, TP.Nit AS Nit, HA.Name as Entidad,
ga.Name AS GrupoAtencion,FC.InitialDate as FechaInicial, 
FC.EndDate as FechaFinal, FC.UserNumber as NumeroUsuarios, FC.UserValue as ValorXUsuario,
        FC.TotalValue as ValorTotal,FC.DiscountPercentage as PorcentajeDescuento,
		FC.DiscountValue as ValorDescuento,FAC.InvoiceNumber AS Factura, cat.Name as CategoriaFact  ,
		case FC.Status 
		when '1' then 'Registrado' 
		when '2' then 'Confirmado'
		when '3' then 'Anulado'
		when '4' then 'Reservado' end as Estado,
		usuario.NOMUSUARI as UsuarioCreacion,
		FC.CreationDate as FechaCreacion,
		usuariom.NOMUSUARI as UsuarioModifica,
		FC.ModificationDate as FechaMidificacion,
		usuarioc.NOMUSUARI as UsuarioConfirma,
		FC.ConfirmationDate as FechaConfirmacion,
		usuarioa.NOMUSUARI as UsuarioAnulo,
		FC.AnnulmentDate as FechaAnulado

from [INDIGO035].[Billing].[InvoiceEntityCapitated] as FC
     INNER JOIN   [INDIGO035].[Common].[OperatingUnit] AS UO ON UO.Id = FC.OperatingUnitId
	 INNER JOIN   [INDIGO035].[Billing].[Invoice] AS FAC ON FAC.Id = FC.InvoiceId
	 INNER JOIN [INDIGO035].[Contract].[HealthAdministrator] AS HA ON HA.Id=FAC.HealthAdministratorId
	 INNER JOIN [INDIGO035].[Common].[ThirdParty] AS TP ON TP.Id=HA.ThirdPartyId
	 INNER JOIN   [INDIGO035].[Contract].[CareGroup] AS ga ON ga.Id = FC.CareGroupId
	 INNER JOIN   [INDIGO035].[Billing].[InvoiceCategories]  AS cat  on cat.Id = FC.InvoiceCategoryId
	 LEFT JOIN   [INDIGO035].[dbo].[SEGusuaru] AS usuario ON usuario.CODUSUARI = FC.CreationUser 
	 LEFT JOIN   [INDIGO035].[dbo].[SEGusuaru] AS usuarioc ON usuarioc.CODUSUARI= FC.ConfirmationUser
	 LEFT JOIN   [INDIGO035].[dbo].[SEGusuaru] AS usuariom ON usuariom.CODUSUARI= FC.ModificationUser
	 LEFT JOIN   [INDIGO035].[dbo].[SEGusuaru] AS usuarioa ON usuarioa.CODUSUARI= FC.AnnulmentUser


