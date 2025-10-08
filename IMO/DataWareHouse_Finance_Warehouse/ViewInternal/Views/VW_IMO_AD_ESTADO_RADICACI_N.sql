-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_IMO_AD_ESTADO_RADICACIÓN
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.IMO_AD_Estado_Radicación
AS

SELECT  uo.UnitName AS Sede,
       PC.InvoiceNumber AS NroFactura,
       CASE PC.AccountReceivableType
           WHEN '1' THEN
               'Facturación Básica'
           WHEN '2' THEN
               'Facturación Ley 100'
           WHEN '3' THEN
               'Impuestos'
           WHEN '4' THEN
               'Pagarés'
           WHEN '5' THEN
               'AcuerdosPago'
           WHEN '6' THEN
               'DocumentoPagoCuotaModeradora'
           WHEN '7' THEN
               'Factura de Producto'
       END AS TipoCxC,
       ing.NUMINGRES AS Ingreso,
       ing.IFECHAING AS [Fecha Ingreso],
       ea.HealthEntityCode AS Entidad_Administradora,
       t.Nit,
       t.DigitVerification AS DígitoVerificación,
       t.Name AS Entidad,
       f.PatientCode AS Identificación,
       p.IPNOMCOMP AS NombrePaciente,
       ga.Code + ' - ' + ga.Name AS GrupoAtención,
       PC.AccountReceivableDate AS FechaFactura,
       f.InvoiceExpirationDate AS FechaVencimiento,
       PC.Value AS VrFactura,
       sxcc.Balance AS SaldoSinRadicar,
       PC.Balance AS SaldoTotal,
       CASE PC.PortfolioStatus
           WHEN '1' THEN
               'SIN RADICAR'
           WHEN '2' THEN
               'RADICADA SIN CONFIRMAR'
           WHEN '3' THEN
               'RADICADA ENTIDAD'
           WHEN '7' THEN
               'CERTIFICADA_PARCIAL'
           WHEN '8' THEN
               'CERTIFICADA_TOTAL'
           WHEN '14' THEN
               'DEVOLUCION_FACTURA'
           WHEN '15' THEN
               'TRASLADO COBRO JURÍDICO CONFIRMADO'
       END AS EstadoFacturaCartera,
       cr.RadicatedConsecutive AS NroRadicado,
       cr.ConfirmDate AS FechaConfirmación,
       PC.Observations AS OrigenFactura,
       uc.NOMUSUARI AS Usuario,
       CASE
	   WHEN ing.UFUCODIGO like 'E%' THEN 'Sede Abner'
           WHEN ing.UFUCODIGO = 'N02' THEN
               'Sede Altico'
           WHEN ing.UFUCODIGO IN ( 'N30' ) THEN
               'Sede la Toma'
           WHEN ing.UFUCODIGO = 'N28' THEN
               'Sede Rehabilitación Cardiaca'
           ELSE
               'Sede Principal'
       END AS Sedes,
	   cat.Name as CategoriaFactura,
	   CASE IPTIPOPAC WHEN 1 THEN 'CONTRIBUTIVO' WHEN 2 THEN 'SUBSIDIADO' WHEN 3 THEN 'VINCULADO' WHEN 4 THEN 'PARTICULAR' WHEN 5 THEN 'OTRO' WHEN 6 THEN 'DESPLAZADO REG. CONTRIBUTIVO' 
			WHEN 7 THEN 'DESPLAZADO REG. SUBSIDIADO' WHEN 8 THEN 'DESPLAZADO NO ASEGURADO' END AS TipoPaciente--, tipo as TipoEntidad,
			,ALTA.FECALTPAC AS FechaAltaMedica
FROM [INDIGO035].[Portfolio].[AccountReceivable] AS PC
--(select *
--from Portfolio.AccountReceivable as pc
--where  pc.InvoiceCategoryId<>'212' and (PC.Balance > '0')
--      --AND (PC.Status <> '3')
--      AND (PC.AccountReceivableType NOT IN ( '6', '4' )) AND PC.AccountReceivableType<>'7' 
--union all
--select *
--from Portfolio.AccountReceivable as pc
--where pc.InvoiceCategoryId is null and (PC.Balance > '0')
--      --AND (PC.Status <> '3')
--      AND (PC.AccountReceivableType NOT IN ( '6', '4' )) AND PC.AccountReceivableType<>'7' 
--)
-- AS PC 
    LEFT JOIN [INDIGO035].[Billing].[Invoice] AS f
	LEFT JOIN [INDIGO035].[Contract].[HealthAdministrator] AS ea ON ea.Id = f.HealthAdministratorId
	LEFT JOIN [INDIGO035].[dbo].[INPACIENT] AS p            ON p.IPCODPACI = f.PatientCode
    LEFT JOIN [INDIGO035].[dbo].[ADINGRESO] AS ing            ON ing.NUMINGRES = f.AdmissionNumber
    LEFT JOIN [INDIGO035].[Contract].[CareGroup] AS ga            ON ga.Id = f.CareGroupId        ON f.InvoiceNumber = PC.InvoiceNumber           AND f.Status <> '2'
    LEFT JOIN [INDIGO035].[Portfolio].[RadicateInvoiceD] AS dr        
	LEFT JOIN [INDIGO035].[Portfolio].[RadicateInvoiceC] AS cr ON cr.Id = dr.RadicateInvoiceCId AND cr.State <> '4' ON dr.InvoiceNumber = PC.InvoiceNumber AND dr.State <> '4'
    LEFT JOIN [INDIGO035].[Common].[ThirdParty] AS t        ON t.Id = PC.ThirdPartyId
    LEFT JOIN [INDIGO035].[Common].[OperatingUnit] AS uo        ON uo.Id = PC.OperatingUnitId
    LEFT JOIN [INDIGO035].[dbo].[SEGusuaru] AS uc        ON uc.CODUSUARI = PC.CreationUser
    LEFT JOIN [INDIGO035].[GeneralLedger].[MainAccounts] AS cuca        ON cuca.Id = PC.AccountRadicateId
    LEFT JOIN [INDIGO035].[Portfolio].[AccountReceivableAccounting] AS sxcc        ON sxcc.AccountReceivableId = PC.Id           AND sxcc.Balance > 0
	left join [INDIGO035].[Billing].[InvoiceCategories] as cat on cat.Id=PC.InvoiceCategoryId
		  -- left outer join 
		  --(SELECT distinct(InvoiceNumber) as invoicenumber, h.Tipo
				--FROM Billing.Invoice as i  WITH (nolock)
				--inner join ReportesMedi.dbo.VIE_AD_Contract_EntidadesAdministradoras as h WITH (nolock) on h.id=i.HealthAdministratorId
				--) as tipo on tipo.InvoiceNumber=pc.invoicenumber
				left outer join [INDIGO035].[dbo].[HCREGEGRE] AS ALTA ON ALTA.NUMINGRES=f.AdmissionNumber
--WHERE (PC.Balance > '0')
--      AND (PC.Status <> '3')
--      AND (PC.AccountReceivableType NOT IN ( '6', '4' )) AND PC.AccountReceivableType<>'7'  and pc.InvoiceCategoryId<>'212'
	 -- and pc.invoicenumber='NEV504887'