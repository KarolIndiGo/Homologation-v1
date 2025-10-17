-- Workspace: SQLServer
-- Item: INDIGO038 [SQL]
-- ItemId: SPN
-- Schema: ViewInternal
-- Object: ControlNominaVie_Total
-- Extracted by Fabric SQL Extractor SPN v3.9.0


CREATE VIEW [ViewInternal].[ControlNominaVie_Total] AS

    SELECT DISTINCT 
                         'C' AS Estado, TP.Nit AS NumeroIdentificacion, p.FirstName + ' ' + p.SecondName + ' ' + p.FirstLastName + ' ' + p.SecondLastName AS NombreEmpleado, ca.Code AS Cod_Cargo, ca.Name AS Cargo, cc.Code AS [Centro Costo], 
                         cc.Name AS CentroCosto, fu.Name AS UnidadFuncional, l_1.PayrollDateLiquidated AS [Fecha Acumulado], ROUND(COALESCE (NULLIF (SalarioAprendiz.ConceptTotalValue, 0), 0), 0) AS SalarioAprendiz, 
                         ROUND(COALESCE (NULLIF (Apren_Lectiva.ConceptTotalValue, 0), 0), 0) AS SalarioAprendizLectiva, ROUND(COALESCE (NULLIF (SalarioIntegral.ConceptTotalValue, 0), 0), 0) AS SalarioIntegral, 
                         ROUND(COALESCE (NULLIF (Sueldo.ConceptTotalValue, 0), 0), 0) AS Sueldo, ROUND(COALESCE (NULLIF (SalarioAprendiz.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (SalarioIntegral.ConceptTotalValue, 0), 0), 0) 
                         + ROUND(COALESCE (NULLIF (Sueldo.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (Apren_Lectiva.ConceptTotalValue, 0), 0), 0) AS TotalSueldo, ROUND(COALESCE (NULLIF (AuxTransporte.ConceptTotalValue, 0), 0),
                          0) AS AuxTransporte, ROUND(COALESCE (NULLIF (Eventos_Horas_Extras.ConceptTotalValue, 0), 0), 0) AS Eventos_Horas_Extras, ROUND(COALESCE (NULLIF (Hora_Extra_Diurna.ConceptTotalValue, 0), 0), 0) 
                         AS Hora_Extra_Diurna, ROUND(COALESCE (NULLIF (Hora_Extra_Diurna_Evento.ConceptTotalValue, 0), 0), 0) AS Hora_Extra_Diurna_Evento, ROUND(COALESCE (NULLIF (Hora_Extra_Festiva_Nocturna.ConceptTotalValue, 0), 0), 
                         0) AS Hora_Extra_Festiva_Nocturna, ROUND(COALESCE (NULLIF (Hora_Extra_Festiva_Nocturna_Evento.ConceptTotalValue, 0), 0), 0) AS Hora_Extra_Festiva_Nocturna_Evento, 
                         ROUND(COALESCE (NULLIF (Hora_Extra_Nocturna.ConceptTotalValue, 0), 0), 0) AS Hora_Extra_Nocturna, ROUND(COALESCE (NULLIF (Hora_Extra_Nocturna_Evento.ConceptTotalValue, 0), 0), 0) AS Hora_Extra_Nocturna_Evento, 
                         ROUND(COALESCE (NULLIF (Hora_Extra_Festiva_Diurna.ConceptTotalValue, 0), 0), 0) AS Hora_Extra_Festiva_Diurna, ROUND(COALESCE (NULLIF (Hora_Extra_Festiva_Diurna_Evento.ConceptTotalValue, 0), 0), 0) 
                         AS Hora_Extra_Festiva_Diurna_Evento, ROUND(COALESCE (NULLIF (Recargo_Nocturno_Festivo.ConceptTotalValue, 0), 0), 0) AS Recargo_Nocturno_Festivo, 
                         ROUND(COALESCE (NULLIF (Recargo_Nocturno_Festivo_Eventos.ConceptTotalValue, 0), 0), 0) AS Recargo_Nocturno_Festivo_Eventos, ROUND(COALESCE (NULLIF (Recargo_Nocturno_Normal.ConceptTotalValue, 0), 0), 0) 
                         AS Recargo_Nocturno_Normal, ROUND(COALESCE (NULLIF (Valor_Dominical_Cuadro.ConceptTotalValue, 0), 0), 0) AS Valor_Dominical_Cuadro, ROUND(COALESCE (NULLIF (Valor_Dominical_Evento.ConceptTotalValue, 0), 0), 0) 
                         AS Valor_Dominical_Evento, ROUND(COALESCE (NULLIF (Valor_Dominical_Extra.ConceptTotalValue, 0), 0), 0) AS Valor_Dominical_Extra, l_1.DiasTrabajados AS [Dias Laborados], 
                         ROUND(COALESCE (NULLIF (Valor_Dominical_Evento.ConceptTotalValue, 0), 0), 0) AS AuxilioMovilizacionSalarial, ROUND(COALESCE (NULLIF (Aux_Movilizacion.ConceptTotalValue, 0), 0), 0) AS Aux_Movilizacion, 
                         ROUND(COALESCE (NULLIF (Aux_Habitacion.ConceptTotalValue, 0), 0), 0) AS Aux_Habitacion, ROUND(COALESCE (NULLIF (Aux_Rodamiento.ConceptTotalValue, 0), 0), 0) AS Aux_Rodamiento, 
                         ROUND(COALESCE (NULLIF (Prima_Tecnica.ConceptTotalValue, 0), 0), 0) AS Prima_Tecnica, ROUND(COALESCE (NULLIF (Aux_Alimen.ConceptTotalValue, 0), 0), 0) AS Aux_Alimen, 
						 ROUND(COALESCE (NULLIF (Aux_Por_Compensacion.ConceptTotalValue, 0), 0), 0) AS Aux_Por_Compensacion, ROUND(COALESCE (NULLIF (Aux_Por_Compensacion_NoSalarial.ConceptTotalValue, 0), 0), 0) AS Aux_Por_Compensacion_NoSalarial, --agregado caso 251666
						 ROUND(COALESCE (NULLIF (Comisiones.ConceptTotalValue, 0), 0), 0) AS Comisiones, --agregado caso 251666
                         ROUND(COALESCE (NULLIF (Bono_Navideño.ConceptTotalValue, 0), 0), 0) AS Bono_Navideño, ROUND(COALESCE (NULLIF (Bonificaciones.ConceptTotalValue, 0), 0), 0) AS Bonificaciones, 
                         ROUND(COALESCE (NULLIF (DisponibilidadesMensajeria.ConceptTotalValue, 0), 0), 0) AS DisponibilidadesMensajeria, ROUND(COALESCE (NULLIF (l_1.IncapAmbulatoria, 0), 0), 0) AS IncapaAmbulatoria, 
                         l_1.AmbulatoryDisabilityDays AS DiaIA, ROUND(COALESCE (NULLIF (IncapaRiesgoProfesional.ConceptTotalValue, 0), 0), 0) AS IncapaRiesgoProfesional, l_1.OccupationalRisksDays AS DiaIP, 
                         ROUND(COALESCE (NULLIF (l_1.UnpaidLicenseValue, 0), 0), 0) AS LicenciaNR, 
						 ROUND(COALESCE (NULLIF (Licencia_Materna.ConceptTotalValue, 0), 0), 0) AS Licencia_Materna, 
                         ROUND(COALESCE (NULLIF (Licencia_Paterna.ConceptTotalValue, 0), 0), 0) AS Licencia_Paterna,
						
						ROUND(COALESCE (NULLIF (LicLuto.ConceptTotalValue, 0), 0), 0) AS Licencia_Luto, 
						
						ROUND(COALESCE (NULLIF (Reajuste_Pens.ConceptTotalValue, 0), 0), 0) AS Reajuste_Pens, 
                         ROUND(COALESCE (NULLIF (Reajuste_Salud.ConceptTotalValue, 0), 0), 0) AS Reajuste_Salud, ROUND(COALESCE (NULLIF (Reajuste_Mov.ConceptTotalValue, 0), 0), 0) AS Reajuste_Mov, 
                         ROUND(COALESCE (NULLIF (Reajuste_HED.ConceptTotalValue, 0), 0), 0) AS Reajuste_HED, ROUND(COALESCE (NULLIF (Reajuste_HEN.ConceptTotalValue, 0), 0), 0) AS Reajuste_HEN, 
                         ROUND(COALESCE (NULLIF (Reajuste_IncAmb.ConceptTotalValue, 0), 0), 0) AS Reajuste_IncAmb, ROUND(COALESCE (NULLIF (Reajuste_RNF.ConceptTotalValue, 0), 0), 0) AS Reajuste_RNF, 
                         ROUND(COALESCE (NULLIF (Reajuste_RNN.ConceptTotalValue, 0), 0), 0) AS Reajuste_RNN, ROUND(COALESCE (NULLIF (Reajuste_Sueldo.ConceptTotalValue, 0), 0), 0) AS Reajuste_Sueldo, 
                         ROUND(COALESCE (NULLIF (Reajuste_ValorDomi.ConceptTotalValue, 0), 0), 0) AS Reajuste_ValorDomi, ROUND(COALESCE (NULLIF (Reajuste_HEFD.ConceptTotalValue, 0), 0), 0) AS Reajuste_HEFD, 
                         ROUND(COALESCE (NULLIF (Reaj_Aux_Rodami.ConceptTotalValue, 0), 0), 0) AS Reaj_Aux_Rodami, ROUND(COALESCE (NULLIF (Reaj_HExtra_DE.ConceptTotalValue, 0), 0), 0) AS Reaj_HExtra_DiurnaE, 
                         ROUND(COALESCE (NULLIF (Reaj_Dom_Extra.ConceptTotalValue, 0), 0), 0) AS Reaj_Dom_Extra, ROUND(COALESCE (NULLIF (Reajuste_Eventos_HE.ConceptTotalValue, 0), 0), 0) AS Reajuste_EventoHE, 
                         ROUND(COALESCE (NULLIF (ReajusteAux_Rodamiento.ConceptTotalValue, 0), 0), 0) AS ReajusteAux_Rodamiento, ROUND(COALESCE (NULLIF (ReajusteFes_Cuadro.ConceptTotalValue, 0), 0), 0) AS ReajusteFes_Cuadro, 
                         ROUND(COALESCE (NULLIF (ReajPoli_SegSura.ConceptTotalValue, 0), 0), 0) AS ReajPoli_SegSura, ROUND(COALESCE (NULLIF (RecarNoct_FestExtra.ConceptTotalValue, 0), 0), 0) AS RecarNoct_FestExtra, 
                         ROUND(COALESCE (NULLIF (AjustFes_Cuadro.ConceptTotalValue, 0), 0), 0) AS AjustFes_Cuadro, ROUND(COALESCE (NULLIF (PrimaTecnica2.ConceptTotalValue, 0), 0), 0) AS PrimaTecnica2, 
                         ROUND(COALESCE (NULLIF (Reajuste_AuxTransp.ConceptTotalValue, 0), 0), 0) AS Reajuste_AuxTransp, ROUND(COALESCE (NULLIF (Reajuste_Bon.ConceptTotalValue, 0), 0), 0) AS Reajuste_Bon, 
                         ROUND(COALESCE (NULLIF (Reajuste_HEFN.ConceptTotalValue, 0), 0), 0) AS Reajuste_HEFN, ROUND(COALESCE (NULLIF (Reajuste_LiceMater.ConceptTotalValue, 0), 0), 0) AS Reajuste_LiceMater, 
                         ROUND(COALESCE (NULLIF (Reajuste_AuxMovSalarial.ConceptTotalValue, 0), 0), 0) AS Reajuste_AuxMovSalarial, ROUND(COALESCE (NULLIF (Reajuste_PrimaTec.ConceptTotalValue, 0), 0), 0) AS Reajuste_PrimaTec, 
                         ROUND(COALESCE (NULLIF (Reajuste_AuxAlimen.ConceptTotalValue, 0), 0), 0) AS Reajuste_AuxAlimen, ROUND(COALESCE (NULLIF (DecuentoAutClinica.ConceptTotalValue, 0), 0), 0) AS DecuentoAutClinica, 
                         ROUND(COALESCE (NULLIF (Reajuste_EmbJudici.ConceptTotalValue, 0), 0), 0) AS Reajuste_EmbJudici, ROUND(COALESCE (NULLIF (Reajuste_LibranzaBancolo.ConceptTotalValue, 0), 0), 0) AS Reajuste_LibranzaBancolo, 
                         ROUND(COALESCE (NULLIF (Reajuste_LibranzaConfa.ConceptTotalValue, 0), 0), 0) AS Reajuste_LibranzaConfa, l_1.AccumulatedOtherAccrued AS OtrosDevengados, l_1.totalacrued AS [Total Devengado], 
                         l_1.SALUD AS AporteSalud, l_1.pension AS AportesPension, l_1.PensionSolidarityFundValueContribution AS [Fondo Solidaridad], ROUND(COALESCE (NULLIF (Retencion_Fuente.ConceptTotalValue, 0), 0), 0) AS Retencion_Fuente, 
                         ROUND(COALESCE (NULLIF (Femedis.ConceptTotalValue, 0), 0), 0) AS Femedis, ROUND(COALESCE (NULLIF (ReintegroBonificacion.ConceptTotalValue, 0), 0), 0) AS ReintegroBonificacion, 
                         ROUND(COALESCE (NULLIF (Aportes_CTAS_AFC.ConceptTotalValue, 0), 0), 0) AS Aportes_CTAS_AFC, ROUND(COALESCE (NULLIF (Aportes_Fonsaludh.ConceptTotalValue, 0), 0), 0) AS Aportes_Fonsaludh, 
                         ROUND(COALESCE (NULLIF (AporteFemedis.ConceptTotalValue, 0), 0), 0) AS AporteFemedis, l_1.AccumulatedOtherDeducted AS OtrosDeducidos, ROUND(COALESCE (NULLIF (Embargo_Alimentos_ValorF.ConceptTotalValue, 0), 
                         0), 0) AS Embargo_Alimentos_ValorF, ROUND(COALESCE (NULLIF (Embargo_Alimentos_Prcentaje.ConceptTotalValue, 0), 0), 0) AS Embargo_Alimentos_Prcentaje, 
                         ROUND(COALESCE (NULLIF (Embargo_Judiciales.ConceptTotalValue, 0), 0), 0) AS Embargo_Judiciales, 
						 ROUND(COALESCE (NULLIF (Libranza_Bancolombia.ConceptTotalValue, 0), 0), 0) AS Libranza_Bancolombia, 
                         ROUND(COALESCE (NULLIF (Libranza_Comfaca.ConceptTotalValue, 0), 0), 0) AS Libranza_Comfaca, 
						 ROUND(COALESCE (NULLIF (Libranza_Comfamiliar.ConceptTotalValue, 0), 0), 0) AS Libranza_Comfamiliar, 
                         ROUND(COALESCE (NULLIF (Libranza_Confaboy.ConceptTotalValue, 0), 0), 0) AS Libranza_Confaboy, 
						 ROUND(COALESCE (NULLIF (Libranza_Occidente.ConceptTotalValue, 0), 0), 0) AS Libranza_Occidente, 
                         ROUND(COALESCE (NULLIF (Libranza_Fonsaludh.ConceptTotalValue, 0), 0), 0) AS Libranza_Fonsaludh, 
						 ROUND(COALESCE (NULLIF (LibranzaBBVA.ConceptTotalValue, 0), 0), 0) AS Libranza_BBVA,

						 ROUND(COALESCE (NULLIF (S_C_A_R_E.ConceptTotalValue, 0), 0), 0) AS S_C_A_R_E, 
                         ROUND(COALESCE (NULLIF (Pension_Voluntaria_APV.ConceptTotalValue, 0), 0), 0) AS Pension_Voluntaria_APV, ROUND(COALESCE (NULLIF (Poliza_Seg_Sura.ConceptTotalValue, 0), 0), 0) AS Poliza_Seg_Sura, 
                         ROUND(COALESCE (NULLIF (Reintegro_AuxTrans.ConceptTotalValue, 0), 0), 0) AS Reintegro_AuxTrans, ROUND(COALESCE (NULLIF (Rein_IncapAmb.ConceptTotalValue, 0), 0), 0) AS Rein_IncapAmb, 
                         ROUND(COALESCE (NULLIF (Reintegro_RecarNF.ConceptTotalValue, 0), 0), 0) AS Reintegro_RecarNF, ROUND(COALESCE (NULLIF (Reintegro_RecarNN.ConceptTotalValue, 0), 0), 0) AS Reintegro_RecarNN, 
                         ROUND(COALESCE (NULLIF (Reintegro_Sueldo.ConceptTotalValue, 0), 0), 0) AS Reintegro_Sueldo, ROUND(COALESCE (NULLIF (Reintegro_ValDomAsis.ConceptTotalValue, 0), 0), 0) AS Reintegro_ValDomAsis, 
                         ROUND(COALESCE (NULLIF (Reintegro_HED.ConceptTotalValue, 0), 0), 0) AS Reintegro_HED, ROUND(COALESCE (NULLIF (Reintegro_HEN.ConceptTotalValue, 0), 0), 0) AS Reintegro_HEN, 
                         ROUND(COALESCE (NULLIF (Reintegro_AuxMov.ConceptTotalValue, 0), 0), 0) AS Reintegro_AuxMov, ROUND(COALESCE (NULLIF (Reintegro_AuxRoda.ConceptTotalValue, 0), 0), 0) AS Reintegro_AuxRoda, 
                         ROUND(COALESCE (NULLIF (Reintegro_AuxAlim.ConceptTotalValue, 0), 0), 0) AS Reintegro_AuxAlim, 
						 ROUND(COALESCE (NULLIF (Reintegro_EmbJudi.ConceptTotalValue, 0), 0), 0) AS Reintegro_EmbJudi, 
                         ROUND(COALESCE (NULLIF (Reintegro_LibranzaBancolo.ConceptTotalValue, 0), 0), 0) AS Reintegro_LibranzaBancolo, 
						 
						 ROUND(COALESCE (NULLIF (Reint_AporPension.ConceptTotalValue, 0), 0), 0) AS Reintegro_AportePension, 
						 ROUND(COALESCE (NULLIF (Reint_FondSolPension.ConceptTotalValue, 0), 0), 0) AS Reintegro_FondoSolidPensional, 
						 

						 l_1.totaldedu AS [Total Deducido], l_1.[Total Pagado], 
                         ROUND(COALESCE (NULLIF (SaludPatronoIntegral.ConceptTotalValue, 0), 0), 0) AS [Salud Integral Patrono], ROUND(COALESCE (NULLIF (SaludPatrono.ConceptTotalValue, 0), 0), 0) AS [Salud Patrono], l_1.[Pension Patrono], 
                         l_1.Riesgo AS RiesgosProfesionales, l_1.saludcon + l_1.pencon + l_1.Aportes_Patronales AS Aportes_Patronales, l_1.SENA, l_1.ICBF, l_1.[Caja de Compensacion Familiar], l_1.Parafiscales, l_1.[Provision Vacaciones], 
                         l_1.[Provision Prima], l_1.[Provision Intereses Censantias], l_1.Cesantias, l_1.[Provision Vacaciones] + l_1.[Provision Prima] + l_1.[Provision Intereses Censantias] + l_1.Cesantias AS PrestacionesSociales, 
                         --ROUND(COALESCE (NULLIF (SalarioAprendiz.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (SalarioIntegral.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (Sueldo.ConceptTotalValue, 0), 0), 0) 
                         --+ ROUND(COALESCE (NULLIF (AuxTransporte.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (Valor_Dominical_Evento.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (Bonificaciones.ConceptTotalValue, 
                         --0), 0), 0) + ROUND(COALESCE (NULLIF (DisponibilidadesMensajeria.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (Eventos_Horas_Extras.ConceptTotalValue, 0), 0), 0) 
                         --+ ROUND(COALESCE (NULLIF (Hora_Extra_Diurna.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (Hora_Extra_Diurna_Evento.ConceptTotalValue, 0), 0), 0) 
                         --+ ROUND(COALESCE (NULLIF (Hora_Extra_Festiva_Nocturna.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (Hora_Extra_Festiva_Nocturna_Evento.ConceptTotalValue, 0), 0), 0) 
                         --+ ROUND(COALESCE (NULLIF (Hora_Extra_Nocturna.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (Hora_Extra_Nocturna_Evento.ConceptTotalValue, 0), 0), 0) 
                         --+ ROUND(COALESCE (NULLIF (Hora_Extra_Festiva_Diurna.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (Hora_Extra_Festiva_Diurna_Evento.ConceptTotalValue, 0), 0), 0) 
                         --+ ROUND(COALESCE (NULLIF (Recargo_Nocturno_Festivo.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (Recargo_Nocturno_Festivo_Eventos.ConceptTotalValue, 0), 0), 0) 
                         --+ ROUND(COALESCE (NULLIF (Recargo_Nocturno_Normal.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (Valor_Dominical_Cuadro.ConceptTotalValue, 0), 0), 0) 
                         --+ ROUND(COALESCE (NULLIF (Valor_Dominical_Evento.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (Valor_Dominical_Extra.ConceptTotalValue, 0), 0), 0) 
                         --+ ROUND(COALESCE (NULLIF (IncapaAmbulatoria.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (IncapaRiesgoProfesional.ConceptTotalValue, 0), 0), 0) 
                         --+ ROUND(COALESCE (NULLIF (Licencia_Materna.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (Licencia_Paterna.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (LicLuto.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (l_1.AccumulatedOtherAccrued, 0), 0), 0) 
                         --+ ROUND(COALESCE (NULLIF (l_1.[Salud Patrono], 0), 0), 0) + ROUND(COALESCE (NULLIF (l_1.[Pension Patrono], 0), 0), 0) + ROUND(COALESCE (NULLIF (l_1.Riesgo, 0), 0), 0) + ROUND(COALESCE (NULLIF (l_1.SENA, 0), 0), 0) 
                         --+ ROUND(COALESCE (NULLIF (l_1.ICBF, 0), 0), 0) + ROUND(COALESCE (NULLIF (l_1.[Caja de Compensacion Familiar], 0), 0), 0) + ROUND(COALESCE (NULLIF (l_1.[Provision Vacaciones], 0), 0), 0) 
                         --+ ROUND(COALESCE (NULLIF (l_1.[Provision Prima], 0), 0), 0) + ROUND(COALESCE (NULLIF (l_1.[Provision Intereses Censantias], 0), 0), 0) + ROUND(COALESCE (NULLIF (l_1.Cesantias, 0), 0), 0) 
                         --+ ROUND(COALESCE (NULLIF (Reajuste_Eventos_HE.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (ReajusteAux_Rodamiento.ConceptTotalValue, 0), 0), 0) 
                         --+ ROUND(COALESCE (NULLIF (ReajusteFes_Cuadro.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (ReajPoli_SegSura.ConceptTotalValue, 0), 0), 0) 
                         --+ ROUND(COALESCE (NULLIF (RecarNoct_FestExtra.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (AjustFes_Cuadro.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (Apren_Lectiva.ConceptTotalValue, 0), 
                         --0), 0) + ROUND(COALESCE (NULLIF (PrimaTecnica2.ConceptTotalValue, 0), 0), 0) + ROUND(COALESCE (NULLIF (SaludPatronoIntegral.ConceptTotalValue, 0), 0), 0) AS TotalNomina,
				
						 
						 co.BasicSalary AS [Salario Basico], E.Id
FROM            Payroll.Employee AS E INNER JOIN
                         Common.ThirdParty AS TP  ON TP.Id = E.ThirdPartyId INNER JOIN
                         Common.Person AS p  ON p.Id = TP.PersonId LEFT OUTER JOIN
                             (SELECT        SUM(EmployeeHealthContributionValue) AS SALUD, EmployeeId AS idempleado, PayrollDateLiquidated, SUM(DaysWorked) AS DiasTrabajados, SUM(AmbulatoryDisabilityDays) AS AmbulatoryDisabilityDays, 
                                                         OccupationalRisksDays, UnpaidLicenseValue, AccumulatedOtherAccrued, SUM(TotalAccrued) AS totalacrued,
														 CASE WHEN E.Pensionary=1 THEN 0 ELSE SUM(PensionContributionValue) END AS pension, 
														 CASE WHEN E.Pensionary=1 THEN 0 ELSE PensionSolidarityFundValueContribution END AS PensionSolidarityFundValueContribution, 
                                                         AccumulatedOtherDeducted, SUM(TotalDeducted) AS totaldedu, SUM(TotalPaid) AS [Total Pagado], SUM(EmployerHealthContributionValue) AS [Salud Patrono], SUM(EmployerPensionContributionValue) 
                                                         AS [Pension Patrono], SUM(OccupationalRisksContributionValue) AS Riesgo, SUM(EmployerHealthContributionValue) AS saludcon, SUM(EmployerPensionContributionValue) AS pencon, 
                                                         SUM(OccupationalRisksContributionValue) AS Aportes_Patronales, SUM(SenaContributionValue) AS SENA, SUM(ICBFContributionValue) AS ICBF, SUM(FamilyCompensationFundContributionValue) 
                                                         AS [Caja de Compensacion Familiar], SUM(ParafiscalContribution) AS Parafiscales, SUM(ProvisionVacation) AS [Provision Vacaciones], SUM(UnemploymentAccumulated) AS Cesantias, SUM(ProvisionIncentive) 
                                                         AS [Provision Prima], SUM(ProvisionInterestsUnemployment) AS [Provision Intereses Censantias], SUM(AmbulatoryDisabilityValue) AS IncapAmbulatoria, ContractId
                               FROM            Payroll.Liquidation AS L inner join 
											   Payroll.Employee AS E ON E.ID=L.EmployeeId
                               WHERE        (PayrollDateLiquidated = '2025-09-30')
                               GROUP BY EmployeeId, ContractId, PayrollDateLiquidated, OccupationalRisksDays, UnpaidLicenseValue, 
							   AccumulatedOtherAccrued, PensionSolidarityFundValueContribution, AccumulatedOtherDeducted, Pensionary) AS l_1 ON 
                         l_1.idempleado = E.Id LEFT OUTER JOIN
                         Payroll.Contract AS co  ON co.Id = l_1.ContractId LEFT OUTER JOIN
                         Payroll.Position AS ca  ON ca.Id = co.PositionId LEFT OUTER JOIN
                         Payroll.FunctionalUnit AS fu  ON fu.Id = co.FunctionalUnitId LEFT OUTER JOIN
                         Payroll.ContractType AS ct  ON co.ContractTypeId = ct.Id LEFT OUTER JOIN
                         Payroll.[Group] AS g  ON co.GroupId = g.Id LEFT OUTER JOIN
                         [Payroll].[CostCenter] AS cc  ON fu.CostCenterId = cc.Id LEFT OUTER JOIN
                         Payroll.RetirementReason AS rr  ON co.RetirementReasonId = rr.Id LEFT OUTER JOIN
                         Payroll.ContractModificationReason AS cmr  ON co.ContractModificationReasonId = cmr.Id LEFT OUTER JOIN
                             (SELECT        SUM(ld.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS ld INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = ld.PayrollId
                               WHERE        (ld.ConceptCode = '001') AND (ld.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Sueldo ON Sueldo.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_86.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_86 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_86.PayrollId
                               WHERE        (LiquidationDetail_86.ConceptCode = '003') AND (LiquidationDetail_86.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS SalarioAprendiz ON SalarioAprendiz.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_85.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_85 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_85.PayrollId
                               WHERE        (LiquidationDetail_85.ConceptCode = '002') AND (LiquidationDetail_85.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS SalarioIntegral ON SalarioIntegral.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_84.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_84 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_84.PayrollId
                               WHERE        (LiquidationDetail_84.ConceptCode = '015') AND (LiquidationDetail_84.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS HoraEx ON HoraEx.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_83.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_83 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_83.PayrollId
                               WHERE        (LiquidationDetail_83.ConceptCode = '005') AND (LiquidationDetail_83.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS AuxTransporte ON AuxTransporte.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_82.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_82 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_82.PayrollId
                               WHERE        (LiquidationDetail_82.ConceptCode = '018') AND (LiquidationDetail_82.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Eventos_Horas_Extras ON Eventos_Horas_Extras.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_81.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_81 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_81.PayrollId
                               WHERE        (LiquidationDetail_81.ConceptCode = '021') AND (LiquidationDetail_81.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Hora_Extra_Diurna ON Hora_Extra_Diurna.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_80.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_80 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_80.PayrollId
                               WHERE        (LiquidationDetail_80.ConceptCode = '041') AND (LiquidationDetail_80.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Hora_Extra_Diurna_Evento ON Hora_Extra_Diurna_Evento.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_79.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_79 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_79.PayrollId
                               WHERE        (LiquidationDetail_79.ConceptCode = '024') AND (LiquidationDetail_79.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Hora_Extra_Festiva_Nocturna ON Hora_Extra_Festiva_Nocturna.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_78.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_78 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_78.PayrollId
                               WHERE        (LiquidationDetail_78.ConceptCode = '044') AND (LiquidationDetail_78.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Hora_Extra_Festiva_Nocturna_Evento ON Hora_Extra_Festiva_Nocturna_Evento.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_77.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_77 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_77.PayrollId
                               WHERE        (LiquidationDetail_77.ConceptCode = '022') AND (LiquidationDetail_77.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Hora_Extra_Nocturna ON Hora_Extra_Nocturna.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_76.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_76 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_76.PayrollId
                               WHERE        (LiquidationDetail_76.ConceptCode = '042') AND (LiquidationDetail_76.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Hora_Extra_Nocturna_Evento ON Hora_Extra_Nocturna_Evento.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_75.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_75 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_75.PayrollId
                               WHERE        (LiquidationDetail_75.ConceptCode = '023') AND (LiquidationDetail_75.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Hora_Extra_Festiva_Diurna ON Hora_Extra_Festiva_Diurna.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_74.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_74 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_74.PayrollId
                               WHERE        (LiquidationDetail_74.ConceptCode = '043') AND (LiquidationDetail_74.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Hora_Extra_Festiva_Diurna_Evento ON Hora_Extra_Festiva_Diurna_Evento.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_73.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_73 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_73.PayrollId
                               WHERE        (LiquidationDetail_73.ConceptCode = '007') AND (LiquidationDetail_73.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Recargo_Nocturno_Festivo ON Recargo_Nocturno_Festivo.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_72.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_72 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_72.PayrollId
                               WHERE        (LiquidationDetail_72.ConceptCode = '046') AND (LiquidationDetail_72.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Recargo_Nocturno_Festivo_Eventos ON Recargo_Nocturno_Festivo_Eventos.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_71.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_71 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_71.PayrollId
                               WHERE        (LiquidationDetail_71.ConceptCode = '006') AND (LiquidationDetail_71.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Recargo_Nocturno_Normal ON Recargo_Nocturno_Normal.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_70.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_70 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_70.PayrollId
                               WHERE        (LiquidationDetail_70.ConceptCode = '008') AND (LiquidationDetail_70.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Valor_Dominical_Cuadro ON Valor_Dominical_Cuadro.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_69.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_69 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_69.PayrollId
                               WHERE        (LiquidationDetail_69.ConceptCode = '045') AND (LiquidationDetail_69.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Valor_Dominical_Evento ON Valor_Dominical_Evento.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_68.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_68 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_68.PayrollId
                               WHERE        (LiquidationDetail_68.ConceptCode = '025') AND (LiquidationDetail_68.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Valor_Dominical_Extra ON Valor_Dominical_Extra.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_67.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_67 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_67.PayrollId
                               WHERE        (LiquidationDetail_67.ConceptCode = '047') AND (LiquidationDetail_67.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS AuxilioMovilizacionSalarial ON AuxilioMovilizacionSalarial.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_66.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_66 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_66.PayrollId
                               WHERE        (LiquidationDetail_66.ConceptCode = '020') AND (LiquidationDetail_66.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Aux_Movilizacion ON Aux_Movilizacion.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_65.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_65 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_65.PayrollId
                               WHERE        (LiquidationDetail_65.ConceptCode = '038') AND (LiquidationDetail_65.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Aux_Habitacion ON Aux_Habitacion.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_64.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_64 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_64.PayrollId
                               WHERE        (LiquidationDetail_64.ConceptCode = '039') AND (LiquidationDetail_64.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Aux_Rodamiento ON Aux_Rodamiento.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_63.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_63 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_63.PayrollId
                               WHERE        (LiquidationDetail_63.ConceptCode = '040') AND (LiquidationDetail_63.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Prima_Tecnica ON Prima_Tecnica.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_62.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_62 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_62.PayrollId
                               WHERE        (LiquidationDetail_62.ConceptCode = '048') AND (LiquidationDetail_62.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Aux_Alimen ON Aux_Alimen.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_61.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_61 INNER JOIN
                                                         Payroll.Liquidation AS l ON l.Id = LiquidationDetail_61.PayrollId
                               WHERE        (LiquidationDetail_61.ConceptCode = '037') AND (LiquidationDetail_61.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Bono_Navideño ON Bono_Navideño.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_60.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_60 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_60.PayrollId
                               WHERE        (LiquidationDetail_60.ConceptCode = '017') AND (LiquidationDetail_60.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Bonificaciones ON Bonificaciones.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_59.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_59 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_59.PayrollId
                               WHERE        (LiquidationDetail_59.ConceptCode = '019') AND (LiquidationDetail_59.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS DisponibilidadesMensajeria ON DisponibilidadesMensajeria.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_58.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_58 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_58.PayrollId
                               WHERE        (LiquidationDetail_58.ConceptCode = '009') AND (LiquidationDetail_58.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS IncapaAmbulatoria ON IncapaAmbulatoria.EmployeeId = TP.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_57.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_57 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_57.PayrollId
                               WHERE        (LiquidationDetail_57.ConceptCode = '011') AND (LiquidationDetail_57.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS IncapaRiesgoProfesional ON IncapaRiesgoProfesional.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_56.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_56 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_56.PayrollId
                               WHERE        (LiquidationDetail_56.ConceptCode = '012') AND (LiquidationDetail_56.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Licencia_Materna ON Licencia_Materna.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_55.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_55 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_55.PayrollId
                               WHERE        (LiquidationDetail_55.ConceptCode = '013') AND (LiquidationDetail_55.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Licencia_Paterna ON Licencia_Paterna.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_54.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_54 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_54.PayrollId
                               WHERE        (LiquidationDetail_54.ConceptCode = '1202') AND (LiquidationDetail_54.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_Pens ON Reajuste_Pens.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_53.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_53 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_53.PayrollId
                               WHERE        (LiquidationDetail_53.ConceptCode = '1201') AND (LiquidationDetail_53.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_Salud ON Reajuste_Salud.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_52.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_52 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_52.PayrollId
                               WHERE        (LiquidationDetail_52.ConceptCode = '1020') AND (LiquidationDetail_52.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_Mov ON Reajuste_Mov.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_51.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_51 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_51.PayrollId
                               WHERE        (LiquidationDetail_51.ConceptCode = '1021') AND (LiquidationDetail_51.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_HED ON Reajuste_HED.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_50.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_50 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_50.PayrollId
                               WHERE        (LiquidationDetail_50.ConceptCode = '1022') AND (LiquidationDetail_50.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_HEN ON Reajuste_HEN.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_49.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_49 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_49.PayrollId
                               WHERE        (LiquidationDetail_49.ConceptCode = '1009') AND (LiquidationDetail_49.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_IncAmb ON Reajuste_IncAmb.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_48.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_48 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_48.PayrollId
                               WHERE        (LiquidationDetail_48.ConceptCode = '1007') AND (LiquidationDetail_48.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_RNF ON Reajuste_RNF.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_47.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_47 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_47.PayrollId
                               WHERE        (LiquidationDetail_47.ConceptCode = '1006') AND (LiquidationDetail_47.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_RNN ON Reajuste_RNN.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_46.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_46 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_46.PayrollId
                               WHERE        (LiquidationDetail_46.ConceptCode = '1001') AND (LiquidationDetail_46.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_Sueldo ON Reajuste_Sueldo.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_45.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_45 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_45.PayrollId
                               WHERE        (LiquidationDetail_45.ConceptCode = '1008') AND (LiquidationDetail_45.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_ValorDomi ON Reajuste_ValorDomi.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_44.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_44 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_44.PayrollId
                               WHERE        (LiquidationDetail_44.ConceptCode = '1023') AND (LiquidationDetail_44.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_HEFD ON Reajuste_HEFD.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_42.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_42 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_42.PayrollId
                               WHERE        (LiquidationDetail_42.ConceptCode = '1005') AND (LiquidationDetail_42.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_AuxTransp ON Reajuste_AuxTransp.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_41.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_41 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_41.PayrollId
                               WHERE        (LiquidationDetail_41.ConceptCode = '1017') AND (LiquidationDetail_41.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_Bon ON Reajuste_Bon.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_40.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_40 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_40.PayrollId
                               WHERE        (LiquidationDetail_40.ConceptCode = '1024') AND (LiquidationDetail_40.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_HEFN ON Reajuste_HEFN.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_39.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_39 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_39.PayrollId
                               WHERE        (LiquidationDetail_39.ConceptCode = '1012') AND (LiquidationDetail_39.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_LiceMater ON Reajuste_LiceMater.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_38.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_38 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_38.PayrollId
                               WHERE        (LiquidationDetail_38.ConceptCode = '1047') AND (LiquidationDetail_38.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_AuxMovSalarial ON Reajuste_AuxMovSalarial.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_37.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_37 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_37.PayrollId
                               WHERE        (LiquidationDetail_37.ConceptCode = '1040') AND (LiquidationDetail_37.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_PrimaTec ON Reajuste_PrimaTec.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_36.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_36 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_36.PayrollId
                               WHERE        (LiquidationDetail_36.ConceptCode = '1048') AND (LiquidationDetail_36.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_AuxAlimen ON Reajuste_AuxAlimen.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_35.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_35 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_35.PayrollId
                               WHERE        (LiquidationDetail_35.ConceptCode = '226') AND (LiquidationDetail_35.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS DecuentoAutClinica ON DecuentoAutClinica.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_34.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_34 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_34.PayrollId
                               WHERE        (LiquidationDetail_34.ConceptCode = '1228') AND (LiquidationDetail_34.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_EmbJudici ON Reajuste_EmbJudici.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_33.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_33 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_33.PayrollId
                               WHERE        (LiquidationDetail_33.ConceptCode = '1222') AND (LiquidationDetail_33.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_LibranzaBancolo ON Reajuste_LibranzaBancolo.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_32.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_32 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_32.PayrollId
                               WHERE        (LiquidationDetail_32.ConceptCode = '1216') AND (LiquidationDetail_32.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_LibranzaConfa ON Reajuste_LibranzaConfa.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_31.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_31 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_31.PayrollId
                               WHERE        (LiquidationDetail_31.ConceptCode = '701') AND (LiquidationDetail_31.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Retencion_Fuente ON Retencion_Fuente.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_30.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_30 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_30.PayrollId
                               WHERE        (LiquidationDetail_30.ConceptCode = '219') AND (LiquidationDetail_30.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Femedis ON Femedis.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_29.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_29 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_29.PayrollId
                               WHERE        (LiquidationDetail_29.ConceptCode = '2017') AND (LiquidationDetail_29.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS ReintegroBonificacion ON ReintegroBonificacion.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_28.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_28 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_28.PayrollId
                               WHERE        (LiquidationDetail_28.ConceptCode = '208') AND (LiquidationDetail_28.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Aportes_CTAS_AFC ON Aportes_CTAS_AFC.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_27.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_27 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_27.PayrollId
                               WHERE        (LiquidationDetail_27.ConceptCode = '213') AND (LiquidationDetail_27.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Aportes_Fonsaludh ON Aportes_Fonsaludh.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_26.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_26 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_26.PayrollId
                               WHERE        (LiquidationDetail_26.ConceptCode = '214') AND (LiquidationDetail_26.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS AporteFemedis ON AporteFemedis.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_25.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_25 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_25.PayrollId
                               WHERE        (LiquidationDetail_25.ConceptCode = '229') AND (LiquidationDetail_25.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Embargo_Alimentos_ValorF ON Embargo_Alimentos_ValorF.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_24.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_24 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_24.PayrollId
                               WHERE        (LiquidationDetail_24.ConceptCode = '230') AND (LiquidationDetail_24.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Embargo_Alimentos_Prcentaje ON Embargo_Alimentos_Prcentaje.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_23.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_23 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_23.PayrollId
                               WHERE        (LiquidationDetail_23.ConceptCode = '228') AND (LiquidationDetail_23.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Embargo_Judiciales ON Embargo_Judiciales.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_22.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_22 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_22.PayrollId
                               WHERE        (LiquidationDetail_22.ConceptCode = '222') AND (LiquidationDetail_22.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Libranza_Bancolombia ON Libranza_Bancolombia.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_21.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_21 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_21.PayrollId
                               WHERE        (LiquidationDetail_21.ConceptCode = '218') AND (LiquidationDetail_21.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Libranza_Comfaca ON Libranza_Comfaca.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_20.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_20 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_20.PayrollId
                               WHERE        (LiquidationDetail_20.ConceptCode = '216') AND (LiquidationDetail_20.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Libranza_Comfamiliar ON Libranza_Comfamiliar.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_19.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_19 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_19.PayrollId
                               WHERE        (LiquidationDetail_19.ConceptCode = '217') AND (LiquidationDetail_19.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Libranza_Confaboy ON Libranza_Confaboy.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_18.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_18 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_18.PayrollId
                               WHERE        (LiquidationDetail_18.ConceptCode = '223') AND (LiquidationDetail_18.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Libranza_Occidente ON Libranza_Occidente.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_17.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_17 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_17.PayrollId
                               WHERE        (LiquidationDetail_17.ConceptCode = '221') AND (LiquidationDetail_17.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Libranza_Fonsaludh ON Libranza_Fonsaludh.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_16.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_16 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_16.PayrollId
                               WHERE        (LiquidationDetail_16.ConceptCode = '234') AND (LiquidationDetail_16.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS S_C_A_R_E ON S_C_A_R_E.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_15.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_15 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_15.PayrollId
                               WHERE        (LiquidationDetail_15.ConceptCode = '207') AND (LiquidationDetail_15.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Pension_Voluntaria_APV ON Pension_Voluntaria_APV.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_14.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_14 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_14.PayrollId
                               WHERE        (LiquidationDetail_14.ConceptCode = '224') AND (LiquidationDetail_14.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Poliza_Seg_Sura ON Poliza_Seg_Sura.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_13.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_13 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_13.PayrollId
                               WHERE        (LiquidationDetail_13.ConceptCode = '2005') AND (LiquidationDetail_13.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reintegro_AuxTrans ON Reintegro_AuxTrans.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_12.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_12 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_12.PayrollId
                               WHERE        (LiquidationDetail_12.ConceptCode = '2009') AND (LiquidationDetail_12.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Rein_IncapAmb ON Rein_IncapAmb.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_11.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_11 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_11.PayrollId
                               WHERE        (LiquidationDetail_11.ConceptCode = '2007') AND (LiquidationDetail_11.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reintegro_RecarNF ON Reintegro_RecarNF.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_10.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_10 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_10.PayrollId
                               WHERE        (LiquidationDetail_10.ConceptCode = '2006') AND (LiquidationDetail_10.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reintegro_RecarNN ON Reintegro_RecarNN.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_9.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_9 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_9.PayrollId
                               WHERE        (LiquidationDetail_9.ConceptCode = '2001') AND (LiquidationDetail_9.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reintegro_Sueldo ON Reintegro_Sueldo.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_8.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_8 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_8.PayrollId
                               WHERE        (LiquidationDetail_8.ConceptCode = '2008') AND (LiquidationDetail_8.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reintegro_ValDomAsis ON Reintegro_ValDomAsis.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_7.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_7 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_7.PayrollId
                               WHERE        (LiquidationDetail_7.ConceptCode = '2021') AND (LiquidationDetail_7.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reintegro_HED ON Reintegro_HED.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_6.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_6 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_6.PayrollId
                               WHERE        (LiquidationDetail_6.ConceptCode = '2022') AND (LiquidationDetail_6.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reintegro_HEN ON Reintegro_HEN.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_5.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_5 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_5.PayrollId
                               WHERE        (LiquidationDetail_5.ConceptCode = '2020') AND (LiquidationDetail_5.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reintegro_AuxMov ON Reintegro_AuxMov.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_4.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_4 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_4.PayrollId
                               WHERE        (LiquidationDetail_4.ConceptCode = '2039') AND (LiquidationDetail_4.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reintegro_AuxRoda ON Reintegro_AuxRoda.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_3.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_3 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_3.PayrollId
                               WHERE        (LiquidationDetail_3.ConceptCode = '2048') AND (LiquidationDetail_3.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reintegro_AuxAlim ON Reintegro_AuxAlim.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_2.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_2 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_2.PayrollId
                               WHERE        (LiquidationDetail_2.ConceptCode = '2228') AND (LiquidationDetail_2.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reintegro_EmbJudi ON Reintegro_EmbJudi.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_1.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_1 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_1.PayrollId
                               WHERE        (LiquidationDetail_1.ConceptCode = '2222') AND (LiquidationDetail_1.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reintegro_LibranzaBancolo ON Reintegro_LibranzaBancolo.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_0.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_0 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_0.PayrollId
                               WHERE        (LiquidationDetail_0.ConceptCode = '1018') AND (LiquidationDetail_0.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reajuste_Eventos_HE ON Reajuste_Eventos_HE.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_88.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_88 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_88.PayrollId
                               WHERE        (LiquidationDetail_88.ConceptCode = '1039') AND (LiquidationDetail_88.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS ReajusteAux_Rodamiento ON ReajusteAux_Rodamiento.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_89.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_89 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_89.PayrollId
                               WHERE        (LiquidationDetail_89.ConceptCode = '1027') AND (LiquidationDetail_89.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS ReajusteFes_Cuadro ON ReajusteFes_Cuadro.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_90.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_90 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_90.PayrollId
                               WHERE        (LiquidationDetail_90.ConceptCode = '1224') AND (LiquidationDetail_90.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS ReajPoli_SegSura ON ReajPoli_SegSura.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_91.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_91 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_91.PayrollId
                               WHERE        (LiquidationDetail_91.ConceptCode = '026') AND (LiquidationDetail_91.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS RecarNoct_FestExtra ON RecarNoct_FestExtra.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_92.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_92 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_92.PayrollId
                               WHERE        (LiquidationDetail_92.ConceptCode = '027') AND (LiquidationDetail_92.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS AjustFes_Cuadro ON AjustFes_Cuadro.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_93.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_93 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_93.PayrollId
                               WHERE        (LiquidationDetail_93.ConceptCode = '049') AND (LiquidationDetail_93.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS PrimaTecnica2 ON PrimaTecnica2.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_94.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_94 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_94.PayrollId
                               WHERE        (LiquidationDetail_94.ConceptCode = '1025') AND (LiquidationDetail_94.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reaj_Dom_Extra ON Reaj_Dom_Extra.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_95.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_95 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_95.PayrollId
                               WHERE        (LiquidationDetail_95.ConceptCode = '1041') AND (LiquidationDetail_95.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reaj_HExtra_DE ON Reaj_HExtra_DE.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_96.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_96 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_96.PayrollId
                               WHERE        (LiquidationDetail_96.ConceptCode = '319') AND (LiquidationDetail_96.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS SaludPatrono ON SaludPatrono.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_97.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_97 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_97.PayrollId
                               WHERE        (LiquidationDetail_97.ConceptCode = '1039') AND (LiquidationDetail_97.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Reaj_Aux_Rodami ON Reaj_Aux_Rodami.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_98.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_98 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_98.PayrollId
                               WHERE        (LiquidationDetail_98.ConceptCode = '004') AND (LiquidationDetail_98.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS Apren_Lectiva ON Apren_Lectiva.EmployeeId = E.Id LEFT OUTER JOIN
                             (SELECT        SUM(LiquidationDetail_99.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_99 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_99.PayrollId
                               WHERE        (LiquidationDetail_99.ConceptCode = '303') AND (LiquidationDetail_99.PayrollDate = '2025-09-30')
                               GROUP BY l.EmployeeId) AS SaludPatronoIntegral ON SaludPatronoIntegral.EmployeeId = E.Id LEFT OUTER JOIN

							  (SELECT        SUM(LiquidationDetail_100.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_100 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_100.PayrollId
                               WHERE        (LiquidationDetail_100.ConceptCode = '215') AND (LiquidationDetail_100.PayrollDate = '2025-09-30')
							    GROUP BY l.EmployeeId) AS LibranzaBBVA on LibranzaBBVA.EmployeeId = E.Id

								LEFT OUTER JOIN

							  (SELECT        SUM(LiquidationDetail_100.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_100 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_100.PayrollId
                               WHERE        (LiquidationDetail_100.ConceptCode = '2202') AND (LiquidationDetail_100.PayrollDate = '2025-09-30')
							    GROUP BY l.EmployeeId) AS Reint_AporPension on Reint_AporPension.EmployeeId = E.Id

									LEFT OUTER JOIN

							  (SELECT        SUM(LiquidationDetail_100.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_100 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_100.PayrollId
                               WHERE        (LiquidationDetail_100.ConceptCode = '2233') AND (LiquidationDetail_100.PayrollDate = '2025-09-30')
							    GROUP BY l.EmployeeId) AS Reint_FondSolPension on Reint_FondSolPension.EmployeeId = E.Id

								LEFT OUTER JOIN

							  (SELECT        SUM(LiquidationDetail_100.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_100 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_100.PayrollId
                               WHERE        (LiquidationDetail_100.ConceptCode = '320') AND (LiquidationDetail_100.PayrollDate = '2025-09-30')
							    GROUP BY l.EmployeeId) AS LicLuto on LicLuto.EmployeeId = E.Id

								LEFT OUTER JOIN

							  (SELECT        SUM(LiquidationDetail_100.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_100 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_100.PayrollId
                               WHERE        (LiquidationDetail_100.ConceptCode = '052') AND (LiquidationDetail_100.PayrollDate = '2025-09-30')
							    GROUP BY l.EmployeeId) AS Comisiones on Comisiones.EmployeeId = E.Id

								LEFT OUTER JOIN

							  (SELECT        SUM(LiquidationDetail_100.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_100 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_100.PayrollId
                               WHERE        (LiquidationDetail_100.ConceptCode = '080') AND (LiquidationDetail_100.PayrollDate = '2025-09-30')
							    GROUP BY l.EmployeeId) AS Aux_Por_Compensacion on Aux_Por_Compensacion.EmployeeId = E.Id

								LEFT OUTER JOIN

							  (SELECT        SUM(LiquidationDetail_100.ConceptTotalValue) AS ConceptTotalValue, l.EmployeeId
                               FROM            Payroll.LiquidationDetail AS LiquidationDetail_100 INNER JOIN
                                                         Payroll.Liquidation AS l  ON l.Id = LiquidationDetail_100.PayrollId
                               WHERE        (LiquidationDetail_100.ConceptCode = '090') AND (LiquidationDetail_100.PayrollDate = '2025-09-30')
							    GROUP BY l.EmployeeId) AS Aux_Por_Compensacion_NoSalarial on Aux_Por_Compensacion_NoSalarial.EmployeeId = E.Id

WHERE        (l_1.PayrollDateLiquidated = '2025-09-30')
--and tp.nit='55056900'

