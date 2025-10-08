-- Workspace: IMO
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: 9fad3369-545e-4a50-9f3d-dedf7967aac6
-- Schema: ViewInternal
-- Object: VW_BILLING_FACTURACIONELECTRONICA
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.Billing_FacturacionElectronica AS

SELECT	
    FA.AdmissionNumber AS Ingreso,
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
    CASE FA.Status 
        WHEN 1 THEN 'Facturada' 
        WHEN 2 THEN 'Anulada' 
    END AS Estado_Factura,
    NT.Code AS Nota,
    NT.Observations AS MotivoAnula,
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
    END AS Comentarios,
    CASE T.Destination 
        WHEN 0 THEN 'Validación Previa a generacion XML'
        WHEN 1 THEN 'Envio Documento Electronico a la DIAN' 
        WHEN 2 THEN 'Validación Documento Enviado'
        WHEN 3 THEN 'Envio al Adquiriente' 
    END AS Destino,
    US.NOMUSUARI AS UsuarioFactura,
    FE.Id,
    FE.CUFE,
    FA.TotalInvoice AS TotalFactura, 
    Respuesta
FROM [INDIGO035].[Billing].[Invoice] AS FA
INNER JOIN [INDIGO035].[Billing].[ElectronicDocument] AS FE 
    ON FA.InvoiceNumber = ISNULL(FE.Prefix + FE.DocumentNumber, FE.DocumentNumber)
LEFT JOIN (
    SELECT ED.ElectronicDocumentId, ED.Comments, ED.Status, ED.Id, ED.Destination, ED.CreationDate, ED.ResponseData AS Respuesta
    FROM [INDIGO035].[Billing].[ElectronicDocumentDetail] AS ED
    JOIN (
        SELECT ElectronicDocumentId,
               MAX(CASE WHEN Status = 1 THEN Id ELSE NULL END) AS Estado1ID,
               MAX(Id) AS UltimoEstadoID
        FROM [INDIGO035].[Billing].[ElectronicDocumentDetail]
        WHERE Destination = 2 AND CreationDate >= '2025-01-01'
        GROUP BY ElectronicDocumentId
    ) SUB ON ED.ElectronicDocumentId = SUB.ElectronicDocumentId
    WHERE ED.Id = COALESCE(SUB.Estado1ID, SUB.UltimoEstadoID)
      AND ED.Destination = 2
) AS T ON T.ElectronicDocumentId = FE.Id
LEFT JOIN [INDIGO035].[Common].[OperatingUnit] AS U 
    ON U.Id = FE.OperatingUnitId
LEFT JOIN [INDIGO035].[Common].[ThirdParty] AS C 
    ON C.Id = FE.CustomerPartyId
LEFT JOIN [INDIGO035].[Common].[Person] AS P 
    ON P.IdentificationNumber = C.Nit
LEFT JOIN (
    SELECT IdPerson, MAX(Phone) AS Phone
    FROM [INDIGO035].[Common].[Phone]
    WHERE IdPhoneType = 1
    GROUP BY IdPerson
) AS Tel ON Tel.IdPerson = P.Id
LEFT JOIN (
    SELECT IdPerson, MAX(Id) AS MAX_ID
    FROM [INDIGO035].[Common].[Address]
    GROUP BY IdPerson
) AS Dir ON Dir.IdPerson = P.Id
LEFT JOIN [INDIGO035].[Common].[Address] AS Dir1 
    ON Dir1.Id = Dir.MAX_ID
LEFT JOIN (
    SELECT IdPerson, MAX(Email) AS Email
    FROM [INDIGO035].[Common].[Email]
    GROUP BY IdPerson
) AS Email ON Email.IdPerson = P.Id
LEFT JOIN (
    SELECT InvoiceNumber, MAX(BillingNoteId) AS BillingNoteId
    FROM [INDIGO035].[Billing].[BillingNoteDetail]
    GROUP BY InvoiceNumber
) AS ND ON ND.InvoiceNumber = FA.InvoiceNumber
LEFT JOIN [INDIGO035].[Billing].[BillingNote] AS NT 
    ON NT.Id = ND.BillingNoteId
LEFT JOIN [INDIGO035].[dbo].[SEGusuaru] AS US 
    ON US.CODUSUARI = FA.InvoicedUser
WHERE FA.InvoiceDate >= '2025-01-01' 
  AND FA.Status = 1;