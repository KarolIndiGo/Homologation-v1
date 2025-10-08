-- Workspace: HOMI
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: ca48608f-987a-48d9-8238-40a4987d89e5
-- Schema: Report
-- Object: VW_TERCEROSINDIGOV3
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [Report].[VW_TERCEROSINDIGOV3] AS

SELECT
    A.Nit,
    A.DigitVerification,
    (
        CASE
            A.PersonType
            WHEN 1 THEN 'Natural'
            WHEN 2 THEN 'Juridico'
        END
    ) AS 'Tipo Persona',
    A.Name AS 'Nombre Tercero',
    (
        CASE WHEN PersonType = 1 THEN LEFT(
            A.Name,
            ISNULL(
                NULLIF(CHARINDEX(' ', A.Name) - 1, -1),
                LEN(A.Name)
            )
        )
    END
    ) AS Primer_Nombre,
    (
        CASE WHEN PersonType = 1 THEN LEFT(
            (
                SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
            ),
            ISNULL(
                NULLIF(
                    CHARINDEX(
                        ' ',
                        (
                            SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                        )
                    ) - 1,
                    -1
                ),
                LEN(
                    (
                        SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                    )
                )
            )
        )
    END
    ) AS Segundo_Nombre,
    (
        CASE WHEN PersonType = 1 THEN LEFT(
            (
                SUBSTRING(
                    (
                        SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                    ),
                    CHARINDEX(
                        ' ',
                        (
                            SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                        )
                    ) + 1,
                    LEN(
                        (
                            SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                        )
                    )
                )
            ),
            ISNULL(
                NULLIF(
                    CHARINDEX(
                        ' ',
                        (
                            SUBSTRING(
                                (
                                    SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                ),
                                CHARINDEX(
                                    ' ',
                                    (
                                        SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                    )
                                ) + 1,
                                LEN(
                                    (
                                        SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                    )
                                )
                            )
                        )
                    ) - 1,
                    -1
                ),
                LEN(
                    (
                        SUBSTRING(
                            (
                                SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                            ),
                            CHARINDEX(
                                ' ',
                                (
                                    SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                )
                            ) + 1,
                            LEN(
                                (
                                    SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                )
                            )
                        )
                    )
                )
            )
        )
    END
    ) AS Primer_Apellido,
    (
        CASE
            WHEN PersonType = 1 THEN LEFT(
                (
                    SUBSTRING(
                        (
                            SUBSTRING(
                                (
                                    SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                ),
                                CHARINDEX(
                                    ' ',
                                    (
                                        SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                    )
                                ) + 1,
                                LEN(
                                    (
                                        SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                    )
                                )
                            )
                        ),
                        CHARINDEX(
                            ' ',
                            (
                                SUBSTRING(
                                    (
                                        SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                    ),
                                    CHARINDEX(
                                        ' ',
                                        (
                                            SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                        )
                                    ) + 1,
                                    LEN(
                                        (
                                            SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                        )
                                    )
                                )
                            )
                        ) + 1,
                        LEN(
                            (
                                SUBSTRING(
                                    (
                                        SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                    ),
                                    CHARINDEX(
                                        ' ',
                                        (
                                            SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                        )
                                    ) + 1,
                                    LEN(
                                        (
                                            SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                        )
                                    )
                                )
                            )
                        )
                    )
                ),
                ISNULL(
                    NULLIF(
                        CHARINDEX(
                            ' ',
                            (
                                SUBSTRING(
                                    (
                                        SUBSTRING(
                                            (
                                                SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                            ),
                                            CHARINDEX(
                                                ' ',
                                                (
                                                    SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                                )
                                            ) + 1,
                                            LEN(
                                                (
                                                    SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                                )
                                            )
                                        )
                                    ),
                                    CHARINDEX(
                                        ' ',
                                        (
                                            SUBSTRING(
                                                (
                                                    SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                                ),
                                                CHARINDEX(
                                                    ' ',
                                                    (
                                                        SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                                    )
                                                ) + 1,
                                                LEN(
                                                    (
                                                        SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                                    )
                                                )
                                            )
                                        )
                                    ) + 1,
                                    LEN(
                                        (
                                            SUBSTRING(
                                                (
                                                    SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                                ),
                                                CHARINDEX(
                                                    ' ',
                                                    (
                                                        SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                                    )
                                                ) + 1,
                                                LEN(
                                                    (
                                                        SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                        ) - 1,
                        -1
                    ),
                    LEN(
                        (
                            SUBSTRING(
                                (
                                    SUBSTRING(
                                        (
                                            SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                        ),
                                        CHARINDEX(
                                            ' ',
                                            (
                                                SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                            )
                                        ) + 1,
                                        LEN(
                                            (
                                                SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                            )
                                        )
                                    )
                                ),
                                CHARINDEX(
                                    ' ',
                                    (
                                        SUBSTRING(
                                            (
                                                SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                            ),
                                            CHARINDEX(
                                                ' ',
                                                (
                                                    SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                                )
                                            ) + 1,
                                            LEN(
                                                (
                                                    SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                                )
                                            )
                                        )
                                    )
                                ) + 1,
                                LEN(
                                    (
                                        SUBSTRING(
                                            (
                                                SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                            ),
                                            CHARINDEX(
                                                ' ',
                                                (
                                                    SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                                )
                                            ) + 1,
                                            LEN(
                                                (
                                                    SUBSTRING(A.Name, CHARINDEX(' ', A.Name) + 1, LEN(A.Name))
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        END
    ) AS Segundo_Apellido,
    A.CodeCIIU AS 'Cod.CIIU',
    I.Name AS 'Departamento',
    H.Name AS 'Ciudad',
    G.Addresss AS 'Dirección',
    NULL AS 'Tipo Telefono',
    phones.phones AS 'Numero Telefono',
    L.Email AS 'Correo Electrónico',
    (
        CASE A.Class
            WHEN 1 THEN 'Nacional'
            WHEN 2 THEN 'Extranjero'
        END
    ) AS 'Clase',
    CAST(D.Code AS VARCHAR(10)) + ' - ' + D.Name AS 'Actividad Economica',
    (
        CASE A.RetentionType
            WHEN 0 THEN 'Ninguna'
            WHEN 1 THEN 'Exento de retencion'
            WHEN 2 THEN 'Hace Retencion'
            WHEN 3 THEN 'Autoretenedor'
        END
    ) AS 'Tipo de retencion',
    (
        CASE A.ContributionType
            WHEN 0 THEN 'No responsable de Iva'
            WHEN 1 THEN 'Responsables de Iva'
            WHEN 2 THEN 'Empresa estatal'
            WHEN 3 THEN 'Gran Contribuyente'
            WHEN 4 THEN 'Regimen Simple'
        END
    ) AS 'Tipo de contribuyente',
    CAST(E.Code AS VARCHAR(10)) + ' - ' + E.Name AS 'Concepto ReteIVA',
    CAST(C.Code AS VARCHAR(10)) + ' - ' + C.Name AS 'concepto de cuentas por pagar para la Retencion al IVA',
    (
        CASE A.Ica
            WHEN 0 THEN 'NO'
            WHEN 1 THEN 'SI'
        END
    ) AS 'Maneja ICA',
    A.IcaPercentage AS 'Porcentaje ICA',
    (
        CASE A.IcaTop
            WHEN 0 THEN 'NO'
            WHEN 1 THEN 'SI'
        END
    ) AS 'Maneja Tope ICA',
    A.IcaTopValue AS 'Valor Tope ICA',
    (
        CASE A.ElectronicBiller
            WHEN 1 THEN 'SI'
            WHEN 0 THEN 'NO'
        END
    ) AS 'Facturador Electrónico',
    CAST(F.Code AS VARCHAR(10)) + ' - ' + F.Name AS 'Responsabilidad Fiscal',
    INDIGO036.Common.DistributionLines.Code + ' - ' + INDIGO036.Common.DistributionLines.Name AS 'Linea de distribuicion',
    INDIGO036.GeneralLedger.MainAccounts.Number + ' - ' + INDIGO036.GeneralLedger.MainAccounts.Name AS 'Cuenta Contable',
    [INDIGO036].[Payroll].[Position].[Code] + ' - ' + [INDIGO036].[Payroll].[Position].[Name] AS Cargo
FROM INDIGO036.Common.ThirdParty A
LEFT JOIN INDIGO036.Common.ThirdPartyFiscalResponsibility B ON A.Id = B.ThirdPartyId
LEFT JOIN INDIGO036.Payments.AccountPayableConcepts C ON A.IVARetentionAccountPayableConceptId = C.Id
LEFT JOIN INDIGO036.Common.EconomicActivity D ON A.EconomicActivityId = D.Id
LEFT JOIN INDIGO036.GeneralLedger.RetentionConcepts E ON A.IVARetentionConceptId = E.Id
LEFT JOIN INDIGO036.Common.FiscalResponsibility F ON B.FiscalResponsibilityId = F.Id
LEFT JOIN INDIGO036.Common.Address G ON A.PersonId = G.IdPerson
LEFT JOIN INDIGO036.Common.City H ON G.CityId = H.Id
LEFT JOIN INDIGO036.Common.Supplier ON A.Nit = INDIGO036.Common.Supplier.Code
LEFT JOIN INDIGO036.Common.SuppliersDistributionLines ON INDIGO036.Common.Supplier.Id = INDIGO036.Common.SuppliersDistributionLines.IdSupplier
LEFT JOIN INDIGO036.Common.DistributionLines ON INDIGO036.Common.SuppliersDistributionLines.IdDistributionLine = INDIGO036.Common.DistributionLines.Id
LEFT JOIN INDIGO036.GeneralLedger.MainAccounts ON INDIGO036.Common.DistributionLines.IdMainAccount = INDIGO036.GeneralLedger.MainAccounts.Id
LEFT JOIN INDIGO036.Payroll.Position ON INDIGO036.Common.SuppliersDistributionLines.PositionId = [INDIGO036].[Payroll].[Position].[Id]
LEFT JOIN INDIGO036.Common.Department I ON G.DepartmentId = I.Id
LEFT JOIN (
    SELECT
        IdPerson,
        (
            CASE
                WHEN [1] IS NULL AND NOT([2] IS NULL) THEN [2]
                WHEN NOT([1] IS NULL) AND [2] IS NULL THEN [1]
                WHEN NOT([1] IS NULL) AND NOT([2] IS NULL) THEN ([1] + ' - ' + [2])
            END
        ) AS phones
    FROM (
        SELECT
            J.IdPerson,
            J.IdPhoneType,
            K.Name + ': ' + J.Phone AS phones
        FROM INDIGO036.Common.Phone J
        LEFT JOIN INDIGO036.Common.PhoneType K ON J.IdPhoneType = K.Id
    ) AS sourcetable
    PIVOT (MAX(phones) FOR IdPhoneType IN ([1], [2])) AS PivotTable
) phones ON A.PersonId = phones.IdPerson
LEFT JOIN INDIGO036.Common.Email L ON A.PersonId = L.IdPerson