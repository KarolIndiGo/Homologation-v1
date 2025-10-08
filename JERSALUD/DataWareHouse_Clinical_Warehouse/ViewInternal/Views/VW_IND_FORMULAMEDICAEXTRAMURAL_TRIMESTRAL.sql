-- Workspace: JERSALUD
-- Item: DataWareHouse_Clinical [Warehouse]
-- ItemId: 9c6eaf45-9b46-445f-bd43-868d6c10c562
-- Schema: ViewInternal
-- Object: VW_IND_FORMULAMEDICAEXTRAMURAL_TRIMESTRAL
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_IND_FORMULAMEDICAEXTRAMURAL_TRIMESTRAL
AS 

SELECT DISTINCT
	    O.FECINIDOS AS FechaOrden
        , O.IPCODPACI AS Documento
        , P.IPNOMCOMP AS Paciente
        , O.NUMINGRES AS Ingreso
        , M.CODPRODUC AS CodProducto
        , M.DESPRODUC AS Producto
        , CASE ATC.POSProduct 
            WHEN 0 THEN 'NO' 
            WHEN 1 THEN 'SI' 
            END AS POS,O.CANPEDPRO AS Cantidad
        , O.DURACIDOS AS Duracion
        , CASE O.UNIDURFIJ 
            WHEN 1 THEN 'Minutos' 
            WHEN 2 THEN 'Hora' 
            WHEN 3 THEN 'Dias' 
            END AS Time
        , O.VALDURFIJ AS VlTime
        , O.DESADMINI AS Administracion
        , D.CODDIAGNO AS CodDx
        , D.NOMDIAGNO AS Diagnostico
        , PR.CODPROSAL AS CodProf
        , PR.NOMMEDICO AS Medico
        , E.DESESPECI AS Especialidad
        , C.NOMCENATE AS Sede
        , G.Name AS GrupoFarmacologico
        , INDIGO031.Inventory.DCI.Name AS DCI
        , O.INDAPLMED AS Indicaciones
        , P.IPFECNACI FechaNacimiento
        , DATEDIFF(year, P.IPFECNACI, O.FECINIDOS) AS EdadEnAtencion,
		case 
			when O.INDAPLMED like '%transcripcion%' then 'Si'  
			when O.INDAPLMED like '%red externa%' then 'Si'  
			when O.INDAPLMED like '%reformulacion%' then 'Si'  
			when O.INDAPLMED like '%especialista%' then 'Si'  
			else 'No' 
		end AS Red_Externa,
		case 
		when O.INDAPLMED like '%Renova%' then 'Si'  
		when O.INDAPLMED like '%transcrip%' then 'Si'  
		when O.INDAPLMED like '%Cambio de orden%' then 'Si'  
		else 'No'
	end AS Orden_Por_Transcripcion,
	O.CODCONCEC AS NumeroFormula

FROM [INDIGO031].[dbo].[HCPRESCRA] AS O 
INNER JOIN INDIGO031.dbo.INPACIENT AS P ON O.IPCODPACI = P.IPCODPACI 
INNER JOIN INDIGO031.dbo.IHLISTPRO AS M ON O.CODPRODUC = M.CODPRODUC 
INNER JOIN INDIGO031.dbo.INDIAGNOS AS D ON O.CODDIAGNO = D.CODDIAGNO 
INNER JOIN INDIGO031.dbo.ADCENATEN AS C ON O.CODCENATE = C.CODCENATE 
INNER JOIN INDIGO031.dbo.INPROFSAL AS PR ON O.CODPROSAL = PR.CODPROSAL 
INNER JOIN INDIGO031.dbo.INESPECIA AS E ON PR.CODESPEC1 = E.CODESPECI 
INNER JOIN INDIGO031.Inventory.ATC AS ATC ON M.CODPRODUC = ATC.Code 
INNER JOIN INDIGO031.Inventory.PharmacologicalGroup AS G ON ATC.PharmacologicalGroupId = G.Id 
INNER JOIN INDIGO031.Inventory.DCI ON ATC.DCIId = INDIGO031.Inventory.DCI.Id
WHERE  O.FECINIDOS>= DATEADD(MONTH, -3, GETDATE()) 
; 