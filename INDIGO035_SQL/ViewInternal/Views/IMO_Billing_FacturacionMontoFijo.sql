-- Workspace: SQLServer
-- Item: INDIGO035 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: IMO_Billing_FacturacionMontoFijo
-- Extracted by Fabric SQL Extractor SPN v3.9.0


create VIEW [ViewInternal].[IMO_Billing_FacturacionMontoFijo]
AS
select  FC.Code AS CodigoFactura,UO.UnitName AS UnidadOperativa,FC.DocumentDate as FechaDocumento, TP.NIT AS Nit, ha.name as Entidad,
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
		usuarioA.NOMUSUARI as UsuarioAnulo,
		FC.AnnulmentDate as FechaAnulado

from Billing.InvoiceEntityCapitated as FC
     INNER JOIN   Common.OperatingUnit AS UO ON UO.Id = FC.OperatingUnitId
	 INNER JOIN   Billing.Invoice AS FAC ON FAC.Id = FC.InvoiceId
	 INNER JOIN Contract.HealthAdministrator AS HA ON HA.ID=FAC.HealthAdministratorId
	 INNER JOIN Common.ThirdParty AS TP ON TP.ID=HA.ThirdPartyId
	 INNER JOIN   Contract.CareGroup AS ga ON ga.Id = FC.CareGroupId
	 INNER JOIN   Billing.InvoiceCategories  AS cat  on cat.id = FC.InvoiceCategoryId
	 LEFT JOIN   SEGusuaru AS usuario ON usuario.CODUSUARI = FC.CreationUser 
	 LEFT JOIN   SEGusuaru AS usuarioc ON usuarioc.CODUSUARI= FC.ConfirmationUser
	 LEFT JOIN   SEGusuaru AS usuariom ON usuariom.CODUSUARI= FC.ModificationUser
	 LEFT JOIN   SEGusuaru AS usuarioa ON usuarioa.CODUSUARI= FC.AnnulmentUser


