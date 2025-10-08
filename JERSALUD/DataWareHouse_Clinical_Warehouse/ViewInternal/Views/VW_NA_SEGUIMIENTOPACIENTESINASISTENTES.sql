-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_NA_SEGUIMIENTOPACIENTESINASISTENTES
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [ViewInternal].[VW_NA_SEGUIMIENTOPACIENTESINASISTENTES] AS 
--SELECT * FROM (
     SELECT  DISTINCT
            NP.ID AS Id, 
            
            CASE P.IPTIPODOC
                WHEN 1 THEN 'CC'
                WHEN 2 THEN 'CE'
                WHEN 3 THEN 'TI'
                WHEN 4 THEN 'RC'
                WHEN 5 THEN 'PA'
                WHEN 6 THEN 'AS'
                WHEN 7 THEN 'MS'
                WHEN 8 THEN 'NU'
				WHEN 9 THEN  'CN' 
				WHEN 10 THEN 'CD' 
				WHEN 11 THEN 'SC' 
				WHEN 12 THEN 'PE'  
				WHEN 13 THEN 'PT' 
				WHEN 14 THEN 'DE'  
				WHEN 15 THEN 'SI'
				WHEN 20 THEN 'SI'
            END AS Tipo_Documento_Paciente, 
            NP.IPCODPACI AS Identificacion, 
            P.IPNOMCOMP AS Nombre_Paciente, 
            P.IPDIRECCI AS Direccion, 
            P.IPTELEFON AS Telefono, 
            P.IPTELMOVI AS Celular, 
            P.IPFECNACI AS Fecha_Nacimiento, 
            (CAST(DATEDIFF(dd, P.IPFECNACI, GETDATE()) / 365.25 AS INT)) AS Edad, 
            NP.FECHACREACION AS Fecha_Nota, 
            TN.NOMBRE AS Nombre_Nota,  
            CA.NOMCENATE AS Centro_Atencion,
			US.NOMUSUARI AS USUARIO,
     (
         SELECT ND.VALOR
         FROM [INDIGO031].dbo.NTNOTASADMINISTRATIVASD AS ND 
         WHERE ND.IDNTVARIABLE = 1
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS 'Observaciones',
	 (
      SELECT TVL.NOMBRE
         FROM [INDIGO031].dbo.NTNOTASADMINISTRATIVASD AS ND 
              LEFT JOIN [INDIGO031].dbo.NTVARIABLESL AS TVL  ON TVL.CODIGO = ND.VALOR
                                                                                  AND TVL.IDNTVARIABLE = ND.IDNTVARIABLE
         WHERE ND.IDNTVARIABLE = 30
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS 'Relsutado de la llamada o de la visita domiciliaria',
     (
         SELECT ND.VALOR
         FROM [INDIGO031].dbo.NTNOTASADMINISTRATIVASD AS ND 
         WHERE ND.IDNTVARIABLE = 31
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS 'Fecha de asignación de la cita',
     (
		 SELECT CONCAT(ND.VALOR,' - ',TVL.NOMBRE)
         FROM [INDIGO031].dbo.NTNOTASADMINISTRATIVASD AS ND 
              LEFT JOIN [INDIGO031].dbo.NTVARIABLESL AS TVL  ON TVL.CODIGO = ND.VALOR
                                                                                  AND TVL.IDNTVARIABLE = ND.IDNTVARIABLE
         WHERE ND.IDNTVARIABLE = 105
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS Diagnostico,
	 (
		 SELECT TVL.NOMBRE
         FROM [INDIGO031].dbo.NTNOTASADMINISTRATIVASD AS ND 
              LEFT JOIN [INDIGO031].dbo.NTVARIABLESL AS TVL  ON TVL.CODIGO = ND.VALOR
                                                                                  AND TVL.IDNTVARIABLE = ND.IDNTVARIABLE
         WHERE ND.IDNTVARIABLE = 121
               AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     ) AS MotivoInasistencia,
	 --(
  --       SELECT ND.VALOR
  --       FROM dbo.NTNOTASADMINISTRATIVASD AS ND 
  --       WHERE ND.IDNTVARIABLE = 122
  --             AND ND.IDNTNOTASADMINISTRATIVASC = NP.ID
     --) AS IdCita
	 CASE WHEN IdCita.VALOR IS NULL THEN '01' ELSE
	 --WHEN IdCita.VALOR = '890206' THEN '01' ELSE
	 IdCita.VALOR END as IdCita,
	NP.NUMINGRES AS Ingreso, 
	 CASE
	WHEN I.IESTADOIN = '' THEN 'Sin Confirmar Hoja de Trabajo'
	WHEN I.IESTADOIN = 'F' THEN 'Confirmada Hoja de Trabajo'
	WHEN I.IESTADOIN = 'A' THEN 'Anulado'
	WHEN I.IESTADOIN = 'C' THEN 'Cerrado'
	WHEN I.IESTADOIN = 'P' THEN 'Parcial'
	END AS EstadoIngreso,
	CASE F.Status WHEN 1 THEN 'Facturado' WHEN 2 THEN 'Anulado' END AS EstadoFactura,F.TotalInvoice AS TotalFactura,  CUPS.Code AS CUPS_Facturado, CUPS.Description AS DescripcionCUPS_Facturado

     FROM [INDIGO031].dbo.NTNOTASADMINISTRATIVASC AS NP 
          INNER JOIN [INDIGO031].dbo.NTADMINISTRATIVAS AS TN  ON TN.ID = NP.IDNOTAADMINISTRATIVA
          INNER JOIN [INDIGO031].dbo.INPACIENT AS P  ON P.IPCODPACI = NP.IPCODPACI
          INNER JOIN [INDIGO031].dbo.ADCENATEN AS CA  ON CA.CODCENATE = NP.CODCENATE
		  INNER JOIN [INDIGO031].dbo.SEGusuaru AS US ON US.CODUSUARI = NP.CODUSUARI
		  LEFT JOIN [INDIGO031].dbo.ADINGRESO AS I ON I.NUMINGRES = NP.NUMINGRES
		  LEFT JOIN [INDIGO031].Billing.Invoice AS F ON F.AdmissionNumber = NP.NUMINGRES AND F.Status = 1
		  LEFT JOIN [INDIGO031].Billing.InvoiceDetail AS FD  ON F.Id=FD.InvoiceId 
		  LEFT JOIN [INDIGO031].Billing.ServiceOrderDetail AS SOD  ON FD.ServiceOrderDetailId=SOD.Id
		  LEFT JOIN [INDIGO031].Contract.CUPSEntity AS CUPS  ON CUPS.Id=SOD.CUPSEntityId
		  		  left join (select  D.VALOR, IDNTNOTASADMINISTRATIVASC
from [INDIGO031].[dbo].[NTNOTASADMINISTRATIVASD] AS D
inner join [INDIGO031].[dbo].NTVARIABLES as vari on vari.ID=D.IDNTVARIABLE
left outer join [INDIGO031].dbo.NTVARIABLESL as vard on vard.ID=D.IDITEMLISTA
where  vari.ID='122') as IdCita on IdCita.IDNTNOTASADMINISTRATIVASC=NP.ID


WHERE TN.ID='10'
--and IdCita.valor like '%33611%'
and NP.ID not in ('7727','7728') --and IdCita.Valor not in ('890206')
--and np.NUMINGRES='3958020' 
--and NP.IPCODPACI='1000145836' --and NP.ID='250635'
--ORDER BY NP.FECHACREACION DESC
--) AS A


--select * from dbo.NTNOTASADMINISTRATIVASC
--where IPCODPACI='1050632897' and ID='250635'
--select * from dbo.NTNOTASADMINISTRATIVASD --where IDNTVARIABLE='122'
--where IDNTNOTASADMINISTRATIVASC='250635'
--select * from dbo.NTVARIABLES
--where ID in('103','104','111','112','113')


--select * from dbo.NTADMINISTRATIVAS

--SELECT TOP 10 * FROM ViewInternal.VIE_Servicios_Facturados
