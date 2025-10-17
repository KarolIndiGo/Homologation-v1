-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: Billing_FacturacionElectronica
-- Extracted by Fabric SQL Extractor SPN v3.9.0





CREATE VIEW [ViewInternal].[Billing_FacturacionElectronica]
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
    CASE fe.entityName 
        WHEN 'Invoice' THEN 'Factura' 
        WHEN 'BillingNote' THEN 'Nota' 
    END AS Tipo,
    ISNULL(fe.Prefix + DocumentNumber, DocumentNumber) AS Numero,
    CASE fa.status 
        WHEN 1 THEN 'Facturada' 
        WHEN 2 THEN 'Anulada' 
    END AS Estado_Factura,
    nt.Code AS Nota,
    nt.Observations AS MotivoAnula,
    CASE fe.Status 
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
    CASE T.status 
        WHEN 0 THEN 'Fallido' 
        WHEN 1 THEN 'Exitoso' 
        ELSE 'No Enviada' 
    END AS [Estado Envio],
  CASE 
    WHEN LEN(T.Comments) IN (37, 76,77, 78,79, 80, 81, 82) THEN LEFT(T.Comments, 23)
    WHEN LEN(T.Comments) = 97 THEN LEFT(T.Comments, 48)
    ELSE T.Comments
END AS Comentarios,--  LEN(T.Comments),
    CASE T.destination 
        WHEN 0 THEN 'Validación Previa a generacion XML'
        WHEN 1 THEN 'Envio Documento Electronico a la DIAN' 
        WHEN 2 THEN 'Validación Documento Enviado'
        WHEN 3 THEN 'Envio al Adquiriente' 
    END AS Destino,
    us.nomusuari AS UsuarioFactura,
    fe.id,
    fe.CUFE,
    FA.TotalInvoice AS TotalFactura, Respuesta
FROM INDIGO038.Billing.Invoice AS fa WITH (NOLOCK)
INNER JOIN INDIGO038.Billing.ElectronicDocument AS FE WITH (NOLOCK) 
    ON fa.InvoiceNumber = ISNULL(FE.Prefix + FE.DocumentNumber, FE.DocumentNumber)
LEFT JOIN (
    SELECT ed.ElectronicDocumentID, ed.Comments, ed.Status, ed.Id, ed.Destination, ed.CreationDate, ed.ResponseData as Respuesta
    FROM INDIGO038.Billing.ElectronicDocumentDetail ed WITH (NOLOCK)

    JOIN (
        SELECT ElectronicDocumentID,
               MAX(CASE WHEN Status = 1 THEN Id ELSE NULL END) AS Estado1ID,
               MAX(Id) AS UltimoEstadoID
        FROM INDIGO038.Billing.ElectronicDocumentDetail WITH (NOLOCK)
        WHERE Destination = 2 AND CreationDate >= DATEADD(MONTH, -2, GETDATE())
        GROUP BY ElectronicDocumentID
    ) sub ON ed.ElectronicDocumentID = sub.ElectronicDocumentID
    WHERE ed.Id = COALESCE(sub.Estado1ID, sub.UltimoEstadoID)
      AND ed.Destination = 2
) AS T ON T.ElectronicDocumentID = FE.Id
LEFT JOIN INDIGO038.Common.OperatingUnit AS U WITH (NOLOCK) 
    ON U.Id = FE.OperatingUnitId
LEFT JOIN INDIGO038.Common.ThirdParty AS C WITH (NOLOCK) 
    ON C.Id = FE.CustomerPartyId
LEFT JOIN INDIGO038.Common.Person AS P WITH (NOLOCK) 
    ON P.IdentificationNumber = C.Nit
LEFT JOIN (
    SELECT IdPerson, MAX(Phone) AS Phone
    FROM INDIGO038.Common.Phone WITH (NOLOCK)
    WHERE IdPhoneType = 1
    GROUP BY IdPerson
) AS Tel ON Tel.IdPerson = P.Id
LEFT JOIN (
    SELECT IdPerson, MAX(Id) AS MAX_ID
    FROM INDIGO038.Common.Address WITH (NOLOCK)
    GROUP BY IdPerson
) AS Dir ON Dir.IdPerson = P.Id
LEFT JOIN INDIGO038.Common.Address AS Dir1 WITH (NOLOCK) 
    ON Dir1.Id = Dir.MAX_ID
LEFT JOIN (
    SELECT IdPerson, MAX(Email) AS Email
    FROM INDIGO038.Common.Email WITH (NOLOCK)
    GROUP BY IdPerson
) AS Email ON Email.IdPerson = P.Id
LEFT JOIN (
    SELECT InvoiceNumber, MAX(BillingNoteId) AS BillingNoteId
    FROM INDIGO038.Billing.BillingNoteDetail WITH (NOLOCK)
    GROUP BY InvoiceNumber
) AS ND ON ND.InvoiceNumber = fa.InvoiceNumber
LEFT JOIN INDIGO038.Billing.BillingNote AS nt WITH (NOLOCK) 
    ON nt.Id = ND.BillingNoteId
LEFT JOIN INDIGO038.dbo.Segusuaru AS us WITH (NOLOCK) 
    ON us.codusuari = fa.InvoicedUser
WHERE fa.InvoiceDate>= DATEADD(MONTH, -2, GETDATE())  and fa.status =1
--  AND T.Destination = 2;
