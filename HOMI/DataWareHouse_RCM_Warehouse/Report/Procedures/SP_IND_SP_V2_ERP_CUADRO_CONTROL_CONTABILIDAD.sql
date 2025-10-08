-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: SP_IND_SP_V2_ERP_CUADRO_CONTROL_CONTABILIDAD
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE   PROCEDURE [Report].[SP_IND_SP_V2_ERP_CUADRO_CONTROL_CONTABILIDAD]
    @ANO INT,
    @MES INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ID_COMPANY VARCHAR(50) = CAST(DB_NAME() AS VARCHAR(50));

    DECLARE @LegalBookA INT,
            @ReverseRevenueRecognition INT,
            @LegalBookB INT,
            @Invoice INT,
            @Anulacion INT,
            @Notas INT,
            @Reconocido INT;

    -- Ajuste: funciona tanto si la DB es INDIGO036 como si es DataWareHouse_RCM
    IF @ID_COMPANY IN ('INDIGO036','DataWareHouse_RCM')
    BEGIN
        SET @LegalBookA = 2;
        SET @ReverseRevenueRecognition = 54;
        SET @LegalBookB = 1;
        SET @Invoice = 116;
        SET @Anulacion = 14;
        SET @Notas = 21;
        SET @Reconocido = 53;
    END;

    -- Aquí sigue el mismo WITH ... (tus CTEs)
    WITH 
    CTE_REVERSION_RECONOCIMIENTOS_UNICOS AS (
        SELECT JV.Id, JV.EntityCode, JV.EntityId,
               CAST(JV.VoucherDate AS DATE) AS VoucherDate,
               SUM(JVD.DebitValue) AS Valor_Debito
        FROM INDIGO036.GeneralLedger.JournalVouchers JV
        INNER JOIN INDIGO036.GeneralLedger.JournalVoucherDetails JVD ON JVD.IdAccounting = JV.Id
        WHERE YEAR(JV.VoucherDate) = @ANO
          AND MONTH(JV.VoucherDate) = @MES
          AND JV.LegalBookId = @LegalBookA
          AND JV.EntityName = 'ReverseRevenueRecognition'
          AND JV.IdJournalVoucher = @ReverseRevenueRecognition
        GROUP BY JV.Id, JV.EntityCode, JV.EntityId, CAST(JV.VoucherDate AS DATE)
    ),
    CTE_FACTURADOS_UNICOS AS (
        SELECT JV.Id, JV.EntityCode, JV.EntityId,
               CAST(JV.VoucherDate AS DATE) AS VoucherDate,
               SUM(JVD.CreditValue) AS Valor_Credito,
               JV.CreationUser
        FROM INDIGO036.GeneralLedger.JournalVouchers JV
        INNER JOIN INDIGO036.GeneralLedger.JournalVoucherDetails JVD ON JVD.IdAccounting = JV.Id
        WHERE YEAR(JV.VoucherDate) = @ANO
          AND MONTH(JV.VoucherDate) = @MES
          AND JV.LegalBookId = @LegalBookB
          AND JV.EntityName = 'Invoice'
          AND JV.IdJournalVoucher = @Invoice
        GROUP BY JV.Id, JV.EntityCode, JV.EntityId, CAST(JV.VoucherDate AS DATE), JV.CreationUser
    ),
    CTE_ANULADOS_UNICOS AS (
        SELECT JV.Id, JV.EntityCode, JV.EntityId,
               CAST(JV.VoucherDate AS DATE) AS VoucherDate,
               SUM(JVD.CreditValue) AS Valor_Credito,
               JV.CreationUser
        FROM INDIGO036.GeneralLedger.JournalVouchers JV
        INNER JOIN INDIGO036.GeneralLedger.JournalVoucherDetails JVD ON JVD.IdAccounting = JV.Id
        WHERE YEAR(JV.VoucherDate) = @ANO
          AND MONTH(JV.VoucherDate) = @MES
          AND JV.LegalBookId = @LegalBookB
          AND JV.EntityName = 'Invoice'
          AND JV.IdJournalVoucher = @Anulacion
        GROUP BY JV.Id, JV.EntityCode, JV.EntityId, CAST(JV.VoucherDate AS DATE), JV.CreationUser
    ),
    CTE_NOTAS_UNICOS AS (
        SELECT JV.Id, JV.EntityCode, JV.EntityId,
               CAST(JV.VoucherDate AS DATE) AS VoucherDate,
               SUM(JVD.DebitValue) AS Valor_Debito,
               JV.CreationUser
        FROM INDIGO036.GeneralLedger.JournalVouchers JV
        INNER JOIN INDIGO036.GeneralLedger.JournalVoucherDetails JVD ON JVD.IdAccounting = JV.Id
        INNER JOIN INDIGO036.GeneralLedger.MainAccounts MA ON MA.Id = JVD.IdMainAccount
        WHERE YEAR(JV.VoucherDate) = @ANO
          AND MONTH(JV.VoucherDate) = @MES
          AND JV.LegalBookId = @LegalBookB
          AND JV.EntityName = 'PortfolioNote'
          AND JV.IdJournalVoucher = @Notas
          AND MA.Number BETWEEN '41' AND '41999999'
        GROUP BY JV.Id, JV.EntityCode, JV.EntityId, CAST(JV.VoucherDate AS DATE), JV.CreationUser
    ),
    CTE_RECONOCIMIENTOS_UNICOS AS (
        SELECT JV.Id, JV.EntityCode, JV.EntityId,
               CAST(JV.VoucherDate AS DATE) AS VoucherDate,
               SUM(JVD.CreditValue) AS Valor_Credito
        FROM INDIGO036.GeneralLedger.JournalVouchers JV
        INNER JOIN INDIGO036.GeneralLedger.JournalVoucherDetails JVD ON JVD.IdAccounting = JV.Id
        WHERE YEAR(JV.VoucherDate) = @ANO
          AND MONTH(JV.VoucherDate) = @MES
          AND JV.LegalBookId = @LegalBookB
          AND JV.EntityName = 'RevenueRecognition'
          AND JV.IdJournalVoucher = @Reconocido
        GROUP BY JV.Id, JV.EntityCode, JV.EntityId, CAST(JV.VoucherDate AS DATE)
    ),
    CTE_DATOS_CONSOLIDADOS AS (
        SELECT '1. REVERSION RECONOCIMIENTO MES ANTERIOR' AS TIPO,
               SUM(UNI.Valor_Debito) * -1 AS [VALOR TOTAL]
        FROM INDIGO036.Billing.RevenueRecognition RR
        INNER JOIN CTE_REVERSION_RECONOCIMIENTOS_UNICOS UNI ON UNI.EntityId = RR.Id
        GROUP BY YEAR(UNI.VoucherDate), MONTH(UNI.VoucherDate)

        UNION ALL

        SELECT '2. FACTURACION TOTAL MES ACTUAL' AS TIPO,
               SUM(I.TotalInvoice) AS [VALOR TOTAL]
        FROM INDIGO036.Billing.Invoice I
        INNER JOIN CTE_FACTURADOS_UNICOS UNI ON UNI.EntityId = I.Id
        INNER JOIN INDIGO036.dbo.ADINGRESO ING ON ING.NUMINGRES = I.AdmissionNumber
        INNER JOIN INDIGO036.Common.ThirdParty TP ON TP.Id = I.ThirdPartyId
        INNER JOIN INDIGO036.Contract.CareGroup CG ON CG.Id = I.CareGroupId
        INNER JOIN INDIGO036.dbo.INPACIENT PAC ON PAC.IPCODPACI = I.PatientCode
        LEFT JOIN INDIGO036.dbo.SEGusuaru USU ON USU.CODUSUARI = UNI.CreationUser
        GROUP BY YEAR(UNI.VoucherDate), MONTH(UNI.VoucherDate)

        UNION ALL

        SELECT '3. FACTURACION ANULADA TOTAL MES ACTUAL' AS TIPO,
               SUM(UNI.Valor_Credito) * -1 AS [VALOR TOTAL]
        FROM INDIGO036.Billing.Invoice I
        INNER JOIN CTE_ANULADOS_UNICOS UNI ON UNI.EntityId = I.Id
        INNER JOIN INDIGO036.dbo.ADINGRESO ING ON ING.NUMINGRES = I.AdmissionNumber
        INNER JOIN INDIGO036.Common.ThirdParty TP ON TP.Id = I.ThirdPartyId
        INNER JOIN INDIGO036.Contract.CareGroup CG ON CG.Id = I.CareGroupId
        INNER JOIN INDIGO036.dbo.INPACIENT PAC ON PAC.IPCODPACI = I.PatientCode
        LEFT JOIN INDIGO036.dbo.SEGusuaru USU ON USU.CODUSUARI = UNI.CreationUser
        GROUP BY YEAR(UNI.VoucherDate), MONTH(UNI.VoucherDate)

        UNION ALL

        SELECT '4. NOTAS CREDITOS MES ACTUAL' AS TIPO,
               SUM(JVD.DebitValue) * -1 AS [VALOR TOTAL]
        FROM INDIGO036.GeneralLedger.JournalVoucherDetails JVD
        INNER JOIN CTE_NOTAS_UNICOS UNI ON UNI.Id = JVD.IdAccounting
        GROUP BY YEAR(UNI.VoucherDate), MONTH(UNI.VoucherDate)

        UNION ALL

        SELECT '5. RECONOCIMIENTO MES ACTUAL' AS TIPO,
               SUM(RRD.GrandTotalSalesPrice) AS [VALOR TOTAL]
        FROM INDIGO036.Billing.RevenueRecognition RR
        INNER JOIN CTE_RECONOCIMIENTOS_UNICOS UNI ON UNI.EntityId = RR.Id
        INNER JOIN INDIGO036.Billing.RevenueRecognitionDetail RRD ON RRD.RevenueRecognitionId = RR.Id
        INNER JOIN INDIGO036.Contract.CareGroup CG ON CG.Id = RR.CareGroupId
        LEFT JOIN INDIGO036.Billing.ServiceOrderDetail SOD ON SOD.Id = RRD.ServiceOrderDetailId
        LEFT JOIN INDIGO036.Billing.ServiceOrder SO ON SO.Id = SOD.ServiceOrderId
        LEFT JOIN INDIGO036.Billing.RevenueControlDetail RCD ON RCD.Id = RRD.RevenueControlDetailId
        LEFT JOIN INDIGO036.Billing.RevenueControl RC ON RC.Id = RCD.RevenueControlId
        LEFT JOIN INDIGO036.dbo.ADINGRESO ING ON ING.NUMINGRES = ISNULL(SO.AdmissionNumber, RC.AdmissionNumber)
        LEFT JOIN INDIGO036.dbo.INPACIENT PAC ON PAC.IPCODPACI = ISNULL(SO.PatientCode, RC.PatientCode)
        LEFT JOIN INDIGO036.Contract.Contract CON ON CON.Id = CG.ContractId
        LEFT JOIN INDIGO036.Contract.HealthAdministrator HA ON HA.Id = CON.HealthAdministratorId
        LEFT JOIN INDIGO036.Common.ThirdParty TP ON TP.Id = ISNULL(HA.ThirdPartyId, RRD.ThirdPartySalesPrice)
        GROUP BY YEAR(UNI.VoucherDate), MONTH(UNI.VoucherDate)
    )
    SELECT * FROM CTE_DATOS_CONSOLIDADOS
    ORDER BY TIPO;
END;
