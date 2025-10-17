-- Workspace: SQLServer
-- Item: INDIGO043 [SQL]
-- ItemId: SPN
-- Schema: Report
-- Object: View_HDSAP_PROCEDIMIENTOQX_ANULADOS
-- Extracted by Fabric SQL Extractor SPN v3.9.0




-- =============================================
-- Author:      Miguel Angle Ruiz Vega
-- Create date: 2025-01-31 10:51:38
-- Database:    INDIGO043
-- Description: Reporte Cuentas Medicas Trazabilidad
-- =============================================



CREATE VIEW [Report].[View_HDSAP_PROCEDIMIENTOQX_ANULADOS]
AS
SELECT
B.IPNOMCOMP AS 'NOMBRE DEL PACIENTE',
B.IPCODPACI AS 'DOCUMENTO',
FORMAT(A.FECHORAIN, 'dd/MM/yy') AS 'FECHA DE CIRUGIA PROGRAMADA',
A.CODSERIPS AS 'CODIGO CUPS',
D.DESSERIPS AS 'NOMBRE CIRUGIA',
A.DURPROCQX AS 'DURACION DE PROCEDIMIENTO QX',
FORMAT(A.FECHORAFI, 'dd/MM/yy') AS 'FECHA FINAL DE CIRUGIA PROGRAMADA',
E.NOMUSUARI AS 'PROFESIONAL QUE CANCELA',
F.DESCAUCAN AS 'causas de cancelación de las cirugías',
C.DESCRIPSAL AS 'NOMBRE SALA',
FORMAT(A.FECHACAN, 'dd/MM/yy') AS 'FECHA CANCELACION',
A.OBSERCAN AS 'OBSERVACION',
CASE A.CODESTPQX
WHEN 0 THEN 'Cirugia Programada'
WHEN 1 THEN 'Paciente admitido (Cirugia Origen Ambulatoria)'
WHEN 2 THEN 'Paciente en sala de espera'
WHEN 3 THEN 'Paciente en sala quirurgica'
WHEN 4 THEN 'Paciente en recuperación'
WHEN 5 THEN 'Paciente con alta'
WHEN 6 THEN 'Anulado - Cancelada'
END 'Estado del procedimiento',
CASE A.ORIGENQX
WHEN 1 THEN 'Cirugía de origen Ambulatorias'
WHEN 2 THEN 'Cirugía de origen Hospitalaria'
END ORIGEN
FROM AGEPROGQX A
JOIN INPACIENT B ON B.IPCODPACI = A.IPCODPACI
JOIN AGENSALAC C ON C.CODCONCEC = A.AGENSALAC
JOIN INCUPSIPS D ON D.CODSERIPS = A.CODSERIPS
JOIN SEGusuaru E ON E.CODUSUARI = A.CODUSUCAN
JOIN AGCACANQX F ON F.CODCACANQ = A.CODCAUCAN
  

