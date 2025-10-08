-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_BILLING_FACTURACIONELECTRONICA
-- Extracted by Fabric SQL Extractor SPN v3.9.0



CREATE VIEW ViewInternal.VW_BILLING_FACTURACIONELECTRONICA
AS

SELECT	
    fa.AdmissionNumber AS Ingreso,
    U.UnitName AS [Unidad Operativa],
    C.Nit,
    C.Name AS Cliente,
    Tel.Phone AS Telefono,
    Dir1.Addresss AS Dirección,
    Email.Email,
    FE.DocumentDate AS [Fecha Documento],
    CASE FE.EntityName 
        WHEN 'Invoice' THEN 'Factura' 
        WHEN 'BillingNote' THEN 'Nota' 
    END AS Tipo,
    ISNULL(FE.Prefix + DocumentNumber, DocumentNumber) AS Numero,
    CASE fa.Status 
        WHEN 1 THEN 'Facturada' 
        WHEN 2 THEN 'Anulada' 
    END AS Estado_Factura,
    nt.Code AS Nota,
    nt.Observations AS MotivoAnula,
    CASE FE.Status 
        WHEN 0 THEN 'Erroneo' 
        WHEN 1 THEN 'Registrada' 
        WHEN 66 THEN 'Pendiente - Proc. Envio' 
        WHEN 2 THEN 'Enviada' 
        WHEN 3 THEN 'Validada' 
        WHEN 4 THEN 'Invalida' 
        WHEN 99 THEN 'Pendiente - Proc. Validacion' 
        WHEN 88 THEN 'Pendiente - Proc. Envio' 
        WHEN 77 THEN 'No Procesa - Dif. Version'  
    END AS [Estado Factura],
    FE.FilePath AS Ruta,
    T.CreationDate AS FechaEnvio,
    CASE T.Status 
        WHEN 0 THEN 'Fallido' 
        WHEN 1 THEN 'Exitoso' 
        ELSE 'No Enviada' 
    END AS [Estado Envio],
  CASE 
    WHEN LEN(T.Comments) IN (37, 76,77, 78,79, 80, 81, 82) THEN LEFT(T.Comments, 23)
    WHEN LEN(T.Comments) = 97 THEN LEFT(T.Comments, 48)
    ELSE T.Comments
END AS Comentarios,--  LEN(T.Comments),
    CASE T.Destination 
        WHEN 0 THEN 'Validación Previa a generacion XML'
        WHEN 1 THEN 'Envio Documento Electronico a la DIAN' 
        WHEN 2 THEN 'Validación Documento Enviado'
        WHEN 3 THEN 'Envio al Adquiriente' 
    END AS Destino,
    us.NOMUSUARI AS UsuarioFactura,
    FE.Id,
    FE.CUFE,
    fa.TotalInvoice AS TotalFactura, Respuesta
FROM INDIGO031.Billing.Invoice AS fa 
INNER JOIN INDIGO031.Billing.ElectronicDocument AS FE 
    ON fa.InvoiceNumber = ISNULL(FE.Prefix + FE.DocumentNumber, FE.DocumentNumber)
LEFT JOIN (
    SELECT ed.ElectronicDocumentId, ed.Comments, ed.Status, ed.Id, ed.Destination, ed.CreationDate, ed.ResponseData as Respuesta
    FROM INDIGO031.Billing.ElectronicDocumentDetail ed 

    JOIN (
        SELECT ElectronicDocumentId,
               MAX(CASE WHEN Status = 1 THEN Id ELSE NULL END) AS Estado1ID,
               MAX(Id) AS UltimoEstadoID
        FROM INDIGO031.Billing.ElectronicDocumentDetail 
        WHERE Destination = 2 AND CreationDate >= '2025-01-01'
        GROUP BY ElectronicDocumentId
    ) sub ON ed.ElectronicDocumentId = sub.ElectronicDocumentId
    WHERE ed.Id = COALESCE(sub.Estado1ID, sub.UltimoEstadoID)
      AND ed.Destination = 2
) AS T ON T.ElectronicDocumentId = FE.Id
LEFT JOIN INDIGO031.Common.OperatingUnit AS U 
    ON U.Id = FE.OperatingUnitId
LEFT JOIN INDIGO031.Common.ThirdParty AS C 
    ON C.Id = FE.CustomerPartyId
LEFT JOIN INDIGO031.Common.Person AS P 
    ON P.IdentificationNumber = C.Nit
LEFT JOIN (
    SELECT IdPerson, MAX(Phone) AS Phone
    FROM INDIGO031.Common.Phone 
    WHERE IdPhoneType = 1
    GROUP BY IdPerson
) AS Tel ON Tel.IdPerson = P.Id
LEFT JOIN (
    SELECT IdPerson, MAX(Id) AS MAX_ID
    FROM INDIGO031.Common.Address 
    GROUP BY IdPerson
) AS Dir ON Dir.IdPerson = P.Id
LEFT JOIN INDIGO031.Common.Address AS Dir1 
    ON Dir1.Id = Dir.MAX_ID
LEFT JOIN (
    SELECT IdPerson, MAX(Email) AS Email
    FROM INDIGO031.Common.Email 
    GROUP BY IdPerson
) AS Email ON Email.IdPerson = P.Id
LEFT JOIN (
    SELECT InvoiceNumber, MAX(BillingNoteId) AS BillingNoteId
    FROM INDIGO031.Billing.BillingNoteDetail 
    GROUP BY InvoiceNumber
) AS ND ON ND.InvoiceNumber = fa.InvoiceNumber
LEFT JOIN INDIGO031.Billing.BillingNote AS nt 
    ON nt.Id = ND.BillingNoteId
LEFT JOIN [INDIGO031].[dbo].[SEGusuaru] AS us 
    ON us.CODUSUARI = fa.InvoicedUser
WHERE fa.InvoiceDate >= '2025-01-01' and fa.Status =1


