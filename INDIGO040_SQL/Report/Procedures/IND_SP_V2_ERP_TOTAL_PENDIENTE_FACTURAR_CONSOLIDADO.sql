-- Workspace: SQLServer
-- Item: INDIGO040 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: IND_SP_V2_ERP_TOTAL_PENDIENTE_FACTURAR_CONSOLIDADO
-- Extracted by Fabric SQL Extractor SPN v3.9.0

/*******************************************************************************************************************
Nombre: [Report].[IND_SP_V2_ERP_TOTAL_PENDIENTE_FACTURAR_CONSOLIDADO]
Tipo:Procedimiento Almacenado
Observacion:
Profesional: 
Fecha:
---------------------------------------------------------------------------
Modificaciones
_____________________________________________________________________________
Version 2
Persona que modifico: Nilsson Galindo Lopez
Fecha:23-10-2024
Ovservaciones: Se agrega la logica del estado del ingreso ya que hay varios ingresos que se encuentran cerrados, pero en la tabla de
			   de control de ingresos no se refleja el cambio de estado, esto solicitado en el ticket 21373

--------------------------------------
Version 3
Persona que modifico:
Fecha:
***********************************************************************************************************************************/
CREATE PROCEDURE [Report].[IND_SP_V2_ERP_TOTAL_PENDIENTE_FACTURAR_CONSOLIDADO]
AS

WITH CTE_PENDIENTE_RECONOCER_UNICOS
AS

(

SELECT DISTINCT G.AdmissionNumber 'INGRESO' FROM 
(
 SELECT DISTINCT RC.AdmissionNumber 
  FROM Contract.CareGroup cg
            JOIN Billing.RevenueControlDetail rcd WITH (NOLOCK) ON cg.Id = rcd.CareGroupId
            JOIN Billing.RevenueControl RC with (nolock) ON RCD.RevenueControlId = RC.Id
            JOIN Billing.ServiceOrderDetailDistribution sodd WITH (NOLOCK) on sodd.RevenueControlDetailId = rcd.Id
            JOIN Billing.ServiceOrderDetail sod WITH (NOLOCK) on sodd.ServiceOrderDetailId = sod.Id
            JOIN Payroll.FunctionalUnit f WITH (NOLOCK) on f.Id = sod.PerformsFunctionalUnitId
            JOIN Contract.CUPSEntity ce WITH (NOLOCK) on sod.CUPSEntityId = ce.Id
            JOIN Billing.BillingConcept bc WITH (NOLOCK) on ce.BillingConceptId = bc.Id
          --  JOIN Billing.ServiceOrder AS SO WITH (NOLOCK) ON SOD.ServiceOrderId =SO.Id
            WHERE --cg.Id = @CareGroupId And 
            rcd.Status in (1,3) AND sod.IsDelete = 0 AND sod.SettlementType != 3 AND sod.GrandTotalSalesPrice > 0 AND cg.LiquidationType In (1, 3)--rcd.Id = 189993
			GROUP BY RC.AdmissionNumber 
 UNION ALL
 SELECT DISTINCT RC.AdmissionNumber

   FROM Contract.CareGroup cg
            JOIN Billing.RevenueControlDetail rcd WITH (NOLOCK) ON cg.Id = rcd.CareGroupId
            JOIN Billing.RevenueControl RC with (nolock) ON RCD.RevenueControlId = RC.Id
            JOIN Billing.ServiceOrderDetailDistribution sodd WITH (NOLOCK) on sodd.RevenueControlDetailId = rcd.Id
            JOIN Billing.ServiceOrderDetail sod WITH (NOLOCK) on sodd.ServiceOrderDetailId = sod.Id
            JOIN Inventory.InventoryProduct ip WITH (NOLOCK) on sod.ProductId = ip.Id
            JOIN Inventory.ProductGroup pg WITH (NOLOCK) ON ip.ProductGroupId = pg.Id
          --  JOIN Billing.ServiceOrder AS SO WITH (NOLOCK) ON SOD.ServiceOrderId =SO.Id
            WHERE --cg.Id = @CareGroupId And 
            rcd.Status in (1,3) AND sod.IsDelete = 0 AND sod.SettlementType != 3 AND sod.GrandTotalSalesPrice > 0 AND cg.LiquidationType In (1, 3)--rcd.Id = 189993
			GROUP BY RC.AdmissionNumber 
) AS G
--where AdmissionNumber='105054'
GROUP BY G.AdmissionNumber 
),

CTE_ULTIMA_CAMAS_OCUPADA
----CTE PARA IDENTIFICAR LA ULTIMA CAMA ACTIVA DE ESE INGRESO
AS
(
    SELECT EGR.IPCODPACI ,EGR.NUMINGRES,EGR.FECINIEST ,EGR.FECFINEST ,EGR.CODICAMAS,CAM.NUMCAMHOS ,FUN.UFUDESCRI  ,FUN.UFUTIPUNI  
	FROM CHREGESTA EGR with (nolock)
	INNER JOIN 
	(
	   SELECT EGR.IPCODPACI ,EGR.NUMINGRES,MAX(EGR.ID) ID  FROM CHREGESTA EGR with (nolock)
	   INNER JOIN CTE_PENDIENTE_RECONOCER_UNICOS AS UNI with (nolock) ON UNI.INGRESO =EGR.NUMINGRES
	   GROUP BY EGR.IPCODPACI ,EGR.NUMINGRES) AS G  ON G.ID =EGR.ID
	INNER JOIN CHCAMASHO AS CAM with (nolock) ON CAM.CODICAMAS =EGR.CODICAMAS 
	INNER JOIN DBO.INUNIFUNC AS FUN with (nolock) ON CAM.UFUCODIGO =FUN.UFUCODIGO 
),
CTE_EGRESO_CAMA
----CTE PARA IDENTIFICAR LA FECHA DE EGRESO DE LA CAMA
AS
(
SELECT EGR.NUMINGRES ,EGR.IPCODPACI ,EGR.FECEGRESO  
FROM CHREGEGRE EGR
INNER JOIN 
(
 SELECT EGR.NUMINGRES ,EGR.IPCODPACI ,MAX(EGR.FECEGRESO) EGRESO 
 FROM CHREGEGRE EGR with (nolock) 
 INNER JOIN CTE_PENDIENTE_RECONOCER_UNICOS AS UNI with (nolock) ON UNI.INGRESO=EGR.NUMINGRES
 GROUP BY EGR.NUMINGRES ,EGR.IPCODPACI ) AS G ON G.NUMINGRES=EGR.NUMINGRES AND G.IPCODPACI =EGR.IPCODPACI AND G.EGRESO =EGR.FECEGRESO 
),
CTE_ALTA_MEDICA
----CTE PARA IDENTIFICAR LA FECHA DE ALTA MEDICA
AS
(
SELECT EGR.NUMINGRES ,EGR.IPCODPACI ,EGR.FECALTPAC 
FROM HCREGEGRE EGR with (nolock)
INNER JOIN 
(
 SELECT EGR.NUMINGRES ,EGR.IPCODPACI ,MAX(EGR.FECALTPAC) 'ALTA MEDICA' 
 FROM HCREGEGRE EGR with (nolock) 
 INNER JOIN CTE_PENDIENTE_RECONOCER_UNICOS AS UNI with (nolock) ON UNI.INGRESO=EGR.NUMINGRES
 GROUP BY EGR.NUMINGRES ,EGR.IPCODPACI ) AS G ON G.NUMINGRES=EGR.NUMINGRES AND G.IPCODPACI =EGR.IPCODPACI AND G.[ALTA MEDICA] =EGR.FECALTPAC 
),


CTE_PENDIENTE_RECONOCER_DETALLADO
AS
(

select G.IDENTIFICACION ,G.PACIENTE ,G.INGRESO,G.[FECHA INGRESO] ,G.ENTIDAD ,G.[GRUPO ATENCION] ,G.AMBITO ,G.FOLIO,G.[ESTADO FOLIO]  ,sum(g.VALOR) VALOR ,G.[UNIDAD ACTUAL] ,
G.[USUARIO APERTURO] ,G.[USUARIO MODIFICO] 
from 
(
 SELECT  ing.IPCODPACI 'IDENTIFICACION',PAC.IPNOMCOMP 'PACIENTE',RC.AdmissionNumber 'INGRESO',CAST(ING.IFECHAING AS DATE) 'FECHA INGRESO',HA.Name 'ENTIDAD',
  CG.Name 'GRUPO ATENCION',CASE ING.TIPOINGRE WHEN 1 THEN 'AMBULATORIO' WHEN 2 THEN 'HOSPITALARIO' END 'AMBITO',rcd.FolioOrder 'FOLIO',sum(sod.GrandTotalSalesPrice) 'VALOR',
  ccsf .Name 'ESTADO FOLIO',FUN.UFUDESCRI 'UNIDAD ACTUAL',ISNULL(USU.NOMUSUARI,'AUTO') 'USUARIO APERTURO',USUM.NOMUSUARI 'USUARIO MODIFICO' --sum(sod.GrandTotalSalesPrice) 'Valor Total'

  FROM Contract.CareGroup cg
            JOIN Billing.RevenueControlDetail rcd WITH (NOLOCK) ON cg.Id = rcd.CareGroupId
            JOIN Billing.RevenueControl RC with (nolock) ON RCD.RevenueControlId = RC.Id
            JOIN Billing.ServiceOrderDetailDistribution sodd WITH (NOLOCK) on sodd.RevenueControlDetailId = rcd.Id
            JOIN Billing.ServiceOrderDetail sod WITH (NOLOCK) on sodd.ServiceOrderDetailId = sod.Id
            JOIN Payroll.FunctionalUnit f WITH (NOLOCK) on f.Id = sod.PerformsFunctionalUnitId
            JOIN Contract.CUPSEntity ce WITH (NOLOCK) on sod.CUPSEntityId = ce.Id
            JOIN Billing.BillingConcept bc WITH (NOLOCK) on ce.BillingConceptId = bc.Id
         --   JOIN Billing.ServiceOrder AS SO WITH (NOLOCK) ON SOD.ServiceOrderId =SO.Id
			JOIN DBO.ADINGRESO as ing WITH (NOLOCK) on ing.NUMINGRES =RC.AdmissionNumber
			JOIN DBO.INPACIENT AS PAC WITH (NOLOCK) ON PAC.IPCODPACI =ING.IPCODPACI
			LEFT JOIN Billing .ConceptsCausesStatusFolio ccsf WITH (NOLOCK) on ccsf.Id =rcd.StatusFolioId
			LEFT JOIN Contract .HealthAdministrator AS HA WITH (NOLOCK) ON HA.Id =RCD.HealthAdministratorId
			LEFT JOIN DBO.INUNIFUNC AS FUN WITH (NOLOCK) ON FUN.UFUCODIGO =ING.UFUACTPAC 
			LEFT JOIN DBO.SEGusuaru AS USU WITH (NOLOCK) ON USU.CODUSUARI =ING.CODUSUCRE
			LEFT JOIN DBO.SEGusuaru AS USUM WITH (NOLOCK) ON USUM.CODUSUARI =ING.CODUSUMOD
            WHERE --cg.Id = @CareGroupId And 
            rcd.Status in (1,3) AND sod.IsDelete = 0 AND sod.SettlementType != 3 AND sod.GrandTotalSalesPrice > 0 AND cg.LiquidationType In (1, 3)--rcd.Id = 189993
			/*IN V2*/AND ING.IESTADOIN NOT IN ('C')/*FN V2*/
			GROUP BY rcd.FolioOrder,ccsf .Name,ing.IPCODPACI,PAC.IPNOMCOMP,RC.AdmissionNumber,ING.IFECHAING,HA.Name,CG.Name,ING.TIPOINGRE,FUN.UFUDESCRI,USU.NOMUSUARI,USUM.NOMUSUARI
 UNION ALL

 SELECT ing.IPCODPACI 'IDENTIFICACION',PAC.IPNOMCOMP 'PACIENTE',RC.AdmissionNumber 'INGRESO',CAST(ING.IFECHAING AS DATE) 'FECHA INGRESO',HA.Name 'ENTIDAD',
  CG.Name 'GRUPO ATENCION',CASE ING.TIPOINGRE WHEN 1 THEN 'AMBULATORIO' WHEN 2 THEN 'HOSPITALARIO' END 'AMBITO',rcd.FolioOrder 'FOLIO',sum(sod.GrandTotalSalesPrice) 'VALOR',
  ccsf .Name 'ESTADO FOLIO',FUN.UFUDESCRI 'UNIDAD ACTUAL',ISNULL(USU.NOMUSUARI,'AUTO') 'USUARIO APERTURO',USUM.NOMUSUARI 'USUARIO MODIFICO' --sum(sod.GrandTotalSalesPrice) 'Valor Total'

   FROM Contract.CareGroup cg
            JOIN Billing.RevenueControlDetail rcd WITH (NOLOCK) ON cg.Id = rcd.CareGroupId
            JOIN Billing.RevenueControl RC with (nolock) ON RCD.RevenueControlId = RC.Id
            JOIN Billing.ServiceOrderDetailDistribution sodd WITH (NOLOCK) on sodd.RevenueControlDetailId = rcd.Id
            JOIN Billing.ServiceOrderDetail sod WITH (NOLOCK) on sodd.ServiceOrderDetailId = sod.Id
            JOIN Inventory.InventoryProduct ip WITH (NOLOCK) on sod.ProductId = ip.Id
            JOIN Inventory.ProductGroup pg WITH (NOLOCK) ON ip.ProductGroupId = pg.Id
           -- JOIN Billing.ServiceOrder AS SO WITH (NOLOCK) ON SOD.ServiceOrderId =SO.Id
			JOIN DBO.ADINGRESO as ing WITH (NOLOCK) on ing.NUMINGRES =RC.AdmissionNumber
			JOIN DBO.INPACIENT AS PAC WITH (NOLOCK) ON PAC.IPCODPACI =ING.IPCODPACI
			LEFT JOIN Billing .ConceptsCausesStatusFolio ccsf WITH (NOLOCK) on ccsf.Id =rcd.StatusFolioId
			LEFT JOIN Contract .HealthAdministrator AS HA WITH (NOLOCK) ON HA.Id =RCD.HealthAdministratorId
			LEFT JOIN DBO.INUNIFUNC AS FUN WITH (NOLOCK) ON FUN.UFUCODIGO =ING.UFUACTPAC 
			LEFT JOIN DBO.SEGusuaru AS USU WITH (NOLOCK) ON USU.CODUSUARI =ING.CODUSUCRE
			LEFT JOIN DBO.SEGusuaru AS USUM WITH (NOLOCK) ON USUM.CODUSUARI =ING.CODUSUMOD
            WHERE --cg.Id = @CareGroupId And 
            rcd.Status in (1,3) AND sod.IsDelete = 0 AND sod.SettlementType != 3 AND sod.GrandTotalSalesPrice > 0 AND cg.LiquidationType In (1, 3)--rcd.Id = 189993
			/*IN V2*/AND ING.IESTADOIN NOT IN ('C')/*FN V2*/
			GROUP BY rcd.FolioOrder,ccsf .Name,ing.IPCODPACI,PAC.IPNOMCOMP,RC.AdmissionNumber,ING.IFECHAING,HA.Name,CG.Name,ING.TIPOINGRE,FUN.UFUDESCRI,USU.NOMUSUARI,USUM.NOMUSUARI
 ) as g
 GROUP BY G.FOLIO,G.[ESTADO FOLIO],G.IDENTIFICACION ,G.PACIENTE ,G.INGRESO,G.[FECHA INGRESO] ,G.ENTIDAD ,G.[GRUPO ATENCION] ,G.AMBITO,G.[UNIDAD ACTUAL],G.[USUARIO APERTURO],G.[USUARIO MODIFICO]

)

select DET.IDENTIFICACION,DET.PACIENTE,DET.INGRESO,DET.[FECHA INGRESO],DET.ENTIDAD,DET.[GRUPO ATENCION] ,DET.AMBITO ,DET.FOLIO ,DET.[ESTADO FOLIO],DET.VALOR ,
CAST(MED.FECALTPAC AS DATE) AS 'FECHA ALTA MEDICA',CAST(EGR.FECEGRESO AS DATE) 'FECHA EGRESO CAMA',CAM.NUMCAMHOS  'CAMA' ,
ISNULL(CAM.UFUDESCRI,DET.[UNIDAD ACTUAL] ) 'UNIDAD FUNCIONAL',DET.[USUARIO APERTURO] ,DET.[USUARIO MODIFICO] 
from CTE_PENDIENTE_RECONOCER_DETALLADO DET
LEFT JOIN CTE_EGRESO_CAMA AS EGR WITH (NOLOCK) ON EGR.NUMINGRES =DET.INGRESO 
LEFT JOIN CTE_ULTIMA_CAMAS_OCUPADA CAM WITH (NOLOCK) ON CAM.NUMINGRES =DET.INGRESO 
LEFT JOIN CTE_ALTA_MEDICA MED WITH (NOLOCK) ON MED.NUMINGRES =DET.INGRESO 
--where det.INGRESO='105054'

--SELECT TOP 100* FROM ADINGRESO WHERE CAST(IFECHAING AS DATE)='2024-09-01'
