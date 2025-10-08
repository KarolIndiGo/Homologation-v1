-- Workspace: HOMI
-- Item: DataWareHouse_RCM [Warehouse]
-- ItemId: 834d5676-5644-4a78-a5e2-f198281d02d0
-- Schema: Report
-- Object: SP_CXC_SALDOS_ANTICIPOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE PROCEDURE Report.SP_CXC_SALDOS_ANTICIPOS
AS
BEGIN
    SELECT
        PA.Code AS 'CODIGO',
        TP.Nit AS 'NIT',
        TP.Name AS 'CLIENTE',
        MA.Number AS 'CUENTA',
        MA.Name AS 'NOMBRE CUENTA',
        PA.DocumentDate AS 'FECHA DOCUMENTO',
        PA.Value AS 'VALOR',
        PA.Observations AS 'OBSERVACIONES'
    FROM
        [INDIGO036].[Portfolio].[PortfolioAdvance] PA
        INNER JOIN [INDIGO036].[Common].[ThirdParty] AS TP ON TP.Id = PA.ThirdPartyId
        INNER JOIN [INDIGO036].[GeneralLedger].[MainAccounts] AS MA ON MA.Id = PA.MainAccountId
    WHERE
        PA.OpeningBalance = 1
    ORDER BY
        PA.Code;
END
