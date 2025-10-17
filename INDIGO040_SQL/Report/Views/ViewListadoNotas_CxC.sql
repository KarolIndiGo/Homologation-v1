-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: ViewListadoNotas_CxC
-- Extracted by Fabric SQL Extractor SPN v3.9.0


/*******************************************************************************************************************
Nombre: [Report].[ViewListadoNotas_CxC] 
Tipo: Vista
Observacion:Reporte listado de Notas.
Profesional:Andres Cabrera & Nilsson Galindo
Fecha Creación:
Profesional revisión:
Fecha Revisión:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 1
Persona que modifico:Amira Gil Meneses
Fecha:24-02-2025
Observaciones:Se modifica la conexión de la tabla Portfolio.AccountReceivable para que genere toda la información
de las notas.
--------------------------------------
Version 2
Persona que modifico:
Fecha:
Observaciones:
***********************************************************************************************************************************/


CREATE VIEW [Report].[ViewListadoNotas_CxC] 
AS

SELECT  
nota.Code as 'NUMERO NOTA', 
cli.Nit, cli.Name as 'NOMBRE CLIENTE',  
nota.NoteDate as 'FECHA NOTA',
nota.Observations as 'OBSERVACION'   ,
CASE nota.Nature WHEN '1' THEN 'Debito' WHEN '2' THEN 'Credito' END 'NATURALEZA',
CASE nota.Status WHEN '1' THEN 'Registrado' WHEN '2' THEN 'Confirmado' WHEN '3' THEN 'Anulado' END 'ESTADO',
fact.InvoiceNumber as 'factura', fact.AccountReceivableDate as 'fecha factura',  notade.AdjusmentValue as 'VALOR',
PER.Fullname AS [USUARIO CONFIRMACION],PERA.Fullname AS [USUARIO ANULACION],
CAST(nota.NoteDate AS DATE) as [FECHA BUSQUEDA]
from Portfolio.PortfolioNote nota
inner join Common.Customer cli   on nota.CustomerId =cli.Id
inner join Portfolio.PortfolioNoteAccountReceivableAdvance notade on nota.id=notade.PortfolioNoteId
inner join Portfolio.AccountReceivable fact ON nota.Code=fact.Code
--inner join Portfolio.AccountReceivable fact on notade.AccountReceivableId=fact.Id
LEFT join Security.[User] US ON NOTA.ConfirmationUser=US.UserCode
LEFT JOIN Security.Person PER ON US.IdPerson=PER.Id
LEFT JOIN Security.[User] USA ON NOTA.AnnulmentUser=USA.UserCode
LEFT JOIN Security.Person PERA ON USA.IdPerson=PERA.Id
--WHERE nota.Status=3
--where nota.Code='018139'

