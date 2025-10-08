-- Workspace: JERSALUD
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: f162c5c2-ff5a-4892-94c6-e9d0a7b27477
-- Schema: ViewInternal
-- Object: VW_BILLING_RIPSELECTRONICOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW ViewInternal.VW_BILLING_RIPSELECTRONICOS
AS
SELECT DISTINCT 
    f.[InvoiceNumber] AS [Numero Factura],
    NCV.CUV,

    CASE 
        WHEN f.DocumentType = 2 THEN 'Factura EAPB Sin Contrato'
        WHEN f.DocumentType = 3 THEN 'Factura Particular'
        WHEN f.DocumentType = 4 THEN 'Factura Capitada'
        WHEN f.DocumentType = 1 THEN 'Factura EAPB con Contrato'
        WHEN f.DocumentType = 5 THEN 'Control de Capitacion'
        WHEN f.DocumentType = 6 THEN 'Factura Basica'
        WHEN f.DocumentType = 7 THEN 'Factura de Venta de Productos'
        ELSE 'Tipo Desconocido'
    END AS [Tipo de Documento Factura],

    up.UnitName AS Sede,

    FORMAT(ing.IFECHAING, 'MMMM', 'es-ES') AS [Mes Ingreso],
    FORMAT(f.InvoiceDate, 'MMMM', 'es-ES') AS [Mes Factura],
    
    CASE 
        WHEN cp.PortfolioStatus = 1 THEN 'Sin Radicar'
        WHEN cp.PortfolioStatus = 2 THEN 'Radicada sin Confirmar'
        WHEN cp.PortfolioStatus = 3 THEN 'Radicada Entidad'
        WHEN cp.PortfolioStatus = 4 THEN 'Objetada o Glosada'
        WHEN cp.PortfolioStatus = 7 THEN 'Certificada Parcial'
        WHEN cp.PortfolioStatus = 8 THEN 'Certificada Total'
        WHEN cp.PortfolioStatus = 14 THEN 'Devolución Factura'
        WHEN cp.PortfolioStatus = 15 THEN 'Cuenta de Dificil Recaudo'
        WHEN cp.PortfolioStatus = 16 THEN 'Cobro Jurídico'
        ELSE 'Estado desconocido'
    END AS Estado,

    CASE 
        WHEN pa.IPTIPODOC = 1 THEN 'CC - Cédula de Ciudadanía'
        WHEN pa.IPTIPODOC = 2 THEN 'CE - Cédula de Extranjería'
        WHEN pa.IPTIPODOC = 3 THEN 'TI - Tarjeta de Identidad'
        WHEN pa.IPTIPODOC = 4 THEN 'RC - Registro Civil'
        WHEN pa.IPTIPODOC = 5 THEN 'PA - Pasaporte'
        WHEN pa.IPTIPODOC = 6 THEN 'AS - Adulto Sin Identificación'
        WHEN pa.IPTIPODOC = 7 THEN 'MS - Menor Sin Identificación'
        WHEN pa.IPTIPODOC = 8 THEN 'NU - Número único de identificación personal'
        WHEN pa.IPTIPODOC = 9 THEN 'CN - Certificado de Nacido Vivo'
        WHEN pa.IPTIPODOC = 10 THEN 'CD - Carnet Diplomático'
        WHEN pa.IPTIPODOC = 11 THEN 'SC - Salvoconducto'
        WHEN pa.IPTIPODOC = 12 THEN 'PE - Permiso Especial de Permanencia'
        WHEN pa.IPTIPODOC = 13 THEN 'PT - Permiso Temporal de Permanencia'
        WHEN pa.IPTIPODOC = 14 THEN 'DE - Documento Extranjero'
        WHEN pa.IPTIPODOC = 15 THEN 'SI - Sin Identificación'
        ELSE 'Tipo de documento desconocido'
    END AS [Tipo de Documento Paciente],

    pa.IPCODPACI AS [Numero Documento],

    CASE 
        WHEN pa.IPTIPOPAC = 1 THEN 'Contributivo'
        WHEN pa.IPTIPOPAC = 2 THEN 'Subsidiado'
        WHEN pa.IPTIPOPAC = 3 THEN 'No afiliado'
        WHEN pa.IPTIPOPAC = 4 THEN 'Particular'
        WHEN pa.IPTIPOPAC = 5 THEN 'Otro'
        WHEN pa.IPTIPOPAC = 6 THEN 'No válido (Desplazado Reg. Contributivo)'
        WHEN pa.IPTIPOPAC = 7 THEN 'No válido (Desplazado Reg. Subsidiado)'
        WHEN pa.IPTIPOPAC = 8 THEN 'No válido (Desplazado No Asegurado)'
        WHEN pa.IPTIPOPAC = 9 THEN 'Especial o excepción'
        WHEN pa.IPTIPOPAC = 10 THEN 'Personas privadas de la libertad a cargo del Fondo Nacional de Salud'
        WHEN pa.IPTIPOPAC = 11 THEN 'Tomador / amparado ARL'
        WHEN pa.IPTIPOPAC = 12 THEN 'Tomador / amparado SOAT'
        WHEN pa.IPTIPOPAC = 13 THEN 'Tomador / amparado planes voluntarios de salud'
        ELSE 'Tipo de paciente desconocido'
    END AS [Tipo de Paciente],

    CASE
        WHEN pa.TIPCOBSAL = 1 THEN 'Contributivo'
        WHEN pa.TIPCOBSAL = 2 THEN 'Subsidiado Total'
        WHEN pa.TIPCOBSAL = 3 THEN 'Subsidiado Parcial'
        WHEN pa.TIPCOBSAL = 4 THEN 'Población Pobre sin Asegurar con SISBEN'
        WHEN pa.TIPCOBSAL = 5 THEN 'Población Pobre sin Asegurar sin SISBEN'
        WHEN pa.TIPCOBSAL = 6 THEN 'Desplazados'
        WHEN pa.TIPCOBSAL = 7 THEN 'Plan de Salud Adicional'
        WHEN pa.TIPCOBSAL = 8 THEN 'Otros'
        ELSE 'No definido'
    END AS TipoCoberturaSalud

FROM 
    INDIGO031.Billing.Invoice AS f
    INNER JOIN [DataWareHouse_Finance].[ViewInternal].[VW_BILLING_TRAZABILIDADRIPS_GRAL] AS NCV 
        ON f.[InvoiceNumber] = NCV.NroFactura AND EstadoRIPS = 'Validado'
    LEFT OUTER JOIN INDIGO031.Common.OperatingUnit AS up 
        ON up.Id = f.OperatingUnitId
    LEFT OUTER JOIN [INDIGO031].[dbo].[ADINGRESO] AS ing 
        ON ing.NUMINGRES = f.AdmissionNumber
    LEFT OUTER JOIN INDIGO031.Portfolio.AccountReceivable AS cp 
        ON cp.InvoiceNumber = f.InvoiceNumber
    LEFT OUTER JOIN [INDIGO031].[dbo].[INPACIENT] AS pa 
        ON pa.IPCODPACI = ing.IPCODPACI

WHERE 
    f.InvoiceDate >= '2025-04-01 00:00'
