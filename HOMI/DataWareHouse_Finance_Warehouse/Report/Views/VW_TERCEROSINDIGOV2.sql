-- Workspace: HOMI
-- Item: DataWareHouse_Finance [Warehouse]
-- ItemId: ca48608f-987a-48d9-8238-40a4987d89e5
-- Schema: Report
-- Object: VW_TERCEROSINDIGOV2
-- Extracted by Fabric SQL Extractor SPN v3.9.0

CREATE VIEW [Report].[VW_TERCEROSINDIGOV2] AS

SELECT
    A.Nit,
    A.DigitVerification,
    CASE
        A.PersonType
        when 1 then 'Natural'
        when 2 then 'Juridico'
    end 'Tipo Persona',
    A.Name 'Nombre Tercero',
    CASE
        WHEN PersonType = 1 THEN LEFT(
            A.Name,
            ISNULL(
                NULLIF(CHARINDEX(' ', A.Name) - 1, -1),
                LEN(A.Name)
            )
        )
    END Primer_Nombre,
CASE
        WHEN PersonType = 1 THEN
        LEFT(
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
    END Segundo_Nombre,
CASE
        WHEN PersonType = 1 THEN
        LEFT(
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
    END Primer_Apellido,
CASE
        WHEN PersonType = 1 THEN
        LEFT(
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
    END Segundo_Apellido,
    A.CodeCIIU 'Cod. CIIU',
    I.Name 'Departamento',
    H.Name 'Ciudad',
    G.Addresss 'Dirección',
    K.Name 'Tipo Telefono',
    J.Phone 'Numero Telefono',
    L.Email 'Correo Electrónico',
    case
        L.Type
        when 1 then 'Notificaciones'
        when 2 then 'Notificación Facturación Electrónica'
    end 'Tipo Correo Electrónico',
    CASE
        A.Class
        WHEN 1 THEN 'Nacional'
        WHEN 2 THEN 'Extranjero'
    END 'Clase',
    CAST (D.Code AS VARCHAR (10)) + ' - ' + D.Name AS 'Actividad Economica',
    CASE
        A.RetentionType
        when 0 then 'Ninguna'
        when 1 then 'Exento de retencion'
        when 2 then 'Hace Retencion'
        when 3 then 'Autoretenedor'
    end 'Tipo de retencion',
    CASE
        A.ContributionType
        when 0 then 'No responsable de Iva'
        when 1 then 'Responsables de Iva'
        when 2 then 'Empresa estatal'
        when 3 then 'Gran Contribuyente'
        when 4 then 'Regimen Simple'
    end 'Tipo de contribuyente',
    CAST (E.Code AS VARCHAR (10)) + ' - ' + E.Name AS 'Concepto ReteIVA',
    CAST (C.Code AS VARCHAR (10)) + ' - ' + C.Name AS 'concepto de cuentas por pagar para la Retencion al IVA',
    CASE
        A.Ica
        WHEN 0 THEN 'NO'
        WHEN 1 THEN 'SI'
    END 'Maneja ICA',
    A.IcaPercentage 'Porcentaje ICA',
    CASE
        A.IcaTop
        WHEN 0 THEN 'NO'
        WHEN 1 THEN 'SI'
    END 'Maneja Tope ICA',
    A.IcaTopValue 'Valor Tope ICA',
    CASE
        A.ElectronicBiller
        WHEN 1 THEN 'SI'
        WHEN 0 THEN 'NO'
    END 'Facturador Electrónico',
    CAST (F.Code as varchar (10)) + ' - ' + F.Name as 'Responsabilidad Fiscal'
FROM
    INDIGO036.Common.ThirdParty A
    LEFT JOIN INDIGO036.Common.ThirdPartyFiscalResponsibility B ON A.Id = B.ThirdPartyId
    LEFT JOIN INDIGO036.Payments.AccountPayableConcepts C ON A.IVARetentionAccountPayableConceptId = C.Id
    LEFT JOIN INDIGO036.Common.EconomicActivity D ON A.EconomicActivityId = D.Id
    LEFT JOIN INDIGO036.GeneralLedger.RetentionConcepts E ON A.IVARetentionConceptId = E.Id
    LEFT JOIN INDIGO036.Common.FiscalResponsibility F ON B.FiscalResponsibilityId = F.Id
    LEFT JOIN INDIGO036.Common.Address G ON A.Id = G.IdPerson
    LEFT JOIN INDIGO036.Common.City H ON G.CityId = H.Id
    LEFT JOIN INDIGO036.Common.Department I ON G.DepartmentId = I.Id
    LEFT JOIN INDIGO036.Common.Phone J ON A.Id = J.IdPerson
    LEFT JOIN INDIGO036.Common.PhoneType K ON J.IdPhoneType = K.Id
    LEFT JOIN INDIGO036.Common.Email L ON A.Id = L.IdPerson --WHERE Nit = '1000221149'