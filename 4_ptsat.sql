
--==== VBP TARGETS & GENERAL TARGETS ==========

--Tables maintained by Adol's group



--=========== VBP PT SATISFACTION DETAIL ====================

TRUNCATE TABLE VBP_PT_SAT_DETAIL
/


INSERT INTO VBP_PT_SAT_DETAIL
(FACILITY, PATIENT_TYPE, FINAL_UNIT_NAME, QUESTIONNUMBER, DISCHARGE_DATE, RATING, ROW_COUNT)
SELECT FACILITY, PATIENT_TYPE, FINAL_UNIT_NAME, QUESTIONNUMBER, LAST_DAY(DISDATE), RATING, ROW_COUNT
FROM FACT_STG_SRVY_QSTN_RSPNS_F
WHERE ltrim(rtrim(QUESTIONNUMBER)) IN (SELECT DISTINCT ltrim(rtrim(QUESTIONNUMBER)) FROM GENERAL_TARGETS)
/

commit
/


--============== UPDATE USING GENERAL_TARGETS =================

DECLARE
	CURSOR C_tgt IS
	SELECT DISTINCT QUESTIONNUMBER, YEAR FROM GENERAL_TARGETS
	WHERE SCORE_TYPE = 'PT SAT';
	V_QNUM VARCHAR2(200);
	V_YEAR VARCHAR2(4);
	
BEGIN
	OPEN C_TGT;
	LOOP
	FETCH C_TGT INTO  V_QNUM, V_YEAR;
	EXIT WHEN C_TGT%NOTFOUND;

	UPDATE VBP_PT_SAT_DETAIL
	SET (DIMENSION, QUESTIONLABEL, FLOOR,TARGET, THRESHOLD, NATIONAL_50_PCTL, NATIONAL_90_PCTL, ASSIGNMENT_YEAR ) = 
			(SELECT DIMENSION, QUESTIONLABEL, FLOOR,TARGET, THRESHOLD, NATIONAL_50_PCTL, NATIONAL_90_PCTL, 
			YEAR 
			FROM GENERAL_TARGETS
			WHERE QUESTIONNUMBER = V_QNUM
			AND YEAR = V_YEAR)
	WHERE QUESTIONNUMBER = V_QNUM
	AND TO_CHAR(DISCHARGE_DATE, 'YYYY') = V_YEAR;
	END LOOP;
	CLOSE C_TGT;
COMMIT;
END;
/

/****************
--============== UPDATE USING VBP_TARGETS =================

DECLARE
	CURSOR C_tgt IS
	SELECT DISTINCT QUESTIONNUMBER, perf_prd_start, perf_prd_end, FACILITY, PHASE, VBP_YES_NO
	FROM VBP_TARGETS
	WHERE SCORE_TYPE = 'PT SAT';
	V_QNUM VARCHAR2(200);
	V_PERF_START DATE;
	V_PERF_END DATE;
	V_FACILITY VARCHAR2(100);
	V_PHASE VARCHAR2(100);
	V_YES_NO VARCHAR2(20);
BEGIN
	OPEN C_TGT;
	LOOP
	FETCH C_TGT INTO  V_QNUM, V_PERF_START,V_PERF_END, V_FACILITY, V_PHASE, V_YES_NO;
	EXIT WHEN C_TGT%NOTFOUND;

	UPDATE VBP_PT_SAT_DETAIL
	SET ( VBP_BENCHMARK, VBP_THRESHOLD, phase, perf_prd_start, perf_prd_end,
				baseline_prd_start, baseline_prd_end, VBP_YES_NO) = 
			(SELECT VBP_benchmark, VBP_THRESHold, phase, perf_prd_start, perf_prd_end,
				baseline_prd_start, baseline_prd_end, VBP_YES_NO
			FROM VBP_TARGETS
			WHERE QUESTIONNUMBER = V_QNUM
			AND perf_prd_start = v_PERF_START
			and perf_prd_end = v_PERF_END
			and score_type = 'PT SAT'
			AND FACILITY = V_FACILITY
			AND PHASE = V_PHASE)
	WHERE QUESTIONNUMBER = V_QNUM
	AND DISCHARGE_DATE BETWEEN V_PERF_START AND V_PERF_END;
	END LOOP;
	CLOSE C_TGT;
COMMIT;
END;
/

**************************/

UPDATE VBP_PT_SAT_DETAIL
SET MEASURE_KEY = FACILITY||'|'||PATIENT_TYPE||'|'||FINAL_UNIT_NAME||'|'||DIMENSION||'|'||QUESTIONNUMBER
/

commit
/



---- =========== VBP PT SAT AGG STG =================

TRUNCATE TABLE VBP_PT_SAT_AGG_STG
/


INSERT INTO VBP_PT_SAT_AGG_STG (DISCHARGE_DATE)
SELECT DISTINCT DISCHARGE_DATE FROM 
VBP_PT_SAT_DETAIL
/
COMMIT
/


/***
DECLARE
	CURSOR C_STG IS
	SELECT DISTINCT DISCHARGE_DATE FROM
	VBP_PT_SAT_DETAIL;
	V_DISCHARGE_DATE DATE;
	
BEGIN
	OPEN C_STG;
	LOOP
	FETCH C_STG INTO V_DISCHARGE_DATE;
	EXIT WHEN C_STG%NOTFOUND;

	INSERT INTO VBP_PT_SAT_AGG_STG 
	(FACILITY, PATIENT_TYPE, FINAL_UNIT_NAME, DIMENSION, QUESTIONNUMBER, QUESTIONLABEL, DISCHARGE_DATE)
	SELECT DISTINCT FACILITY, PATIENT_TYPE, FINAL_UNIT_NAME, DIMENSION, QUESTIONNUMBER, QUESTIONLABEL, V_DISCHARGE_DATE
	FROM VBP_PT_SAT_DETAIL;
	END LOOP;
	CLOSE C_STG;
COMMIT;
END;
******/

DECLARE
	CURSOR C_STG IS
	SELECT DISTINCT DISCHARGE_DATE FROM
	VBP_PT_SAT_DETAIL;
	V_DISCHARGE_DATE DATE;
	
BEGIN
	OPEN C_STG;
	LOOP
	FETCH C_STG INTO V_DISCHARGE_DATE;
	EXIT WHEN C_STG%NOTFOUND;

	INSERT INTO VBP_PT_SAT_AGG_STG 
	(FACILITY, PATIENT_TYPE, FINAL_UNIT_NAME, DIMENSION, QUESTIONNUMBER, QUESTIONLABEL, DISCHARGE_DATE)
	SELECT DISTINCT FACILITY, PATIENT_TYPE, FINAL_UNIT_NAME, DIMENSION, QUESTIONNUMBER, QUESTIONLABEL, 	DISCHARGE_DATE
	FROM VBP_PT_SAT_DETAIL
	where discharge_date = v_discharge_date;
	END LOOP;
	CLOSE C_STG;
COMMIT;
END;
/



DECLARE 
	CURSOR C_STG_UPD IS 
	SELECT FACILITY, PATIENT_TYPE, FINAL_UNIT_NAME, DIMENSION, QUESTIONNUMBER, QUESTIONLABEL, DISCHARGE_DATE, ROWID
	FROM VBP_PT_SAT_AGG_STG;
	V_FACILITY VARCHAR2(20);
	V_PATIENT_TYPE VARCHAR2(200);
	V_FINAL_UNIT VARCHAR2(200);
	V_DIMENSION VARCHAR2(200);
	V_QUESTIONNUMBER VARCHAR2(20);
	V_QUESTIONLABEL VARCHAR2(200);
	V_DISCHARGE_DATE DATE;
	V_ROWID ROWID;
BEGIN
	OPEN C_STG_UPD;
	LOOP
	FETCH C_STG_UPD INTO V_FACILITY, v_PATIENT_TYPE, V_FINAL_UNIT, V_DIMENSION, V_QUESTIONNUMBER, V_QUESTIONLABEL,
				V_DISCHARGE_DATE, V_ROWID;
	EXIT WHEN C_STG_UPD%NOTFOUND;

	UPDATE VBP_PT_SAT_AGG_STG
	SET (MEASURE_KEY, VBP_BENCHMARK, VBP_THRESHOLD,
	ASSIGNMENT_YEAR, POSITIVE_RESP_COUNT,  TOTAL_RESP_COUNT,
	PHASE, PERF_PRD_START, PERF_PRD_END, BASELINE_PRD_START, BASELINE_PRD_END, VBP_YES_NO,
	TARGET, THRESHOLD, NATIONAL_50_PCTL, NATIONAL_90_PCTL,FLOOR) =
	(SELECT MEASURE_KEY,VBP_BENCHMARK, VBP_THRESHOLD,
	ASSIGNMENT_YEAR, SUM(RATING), SUM(ROW_COUNT),
	PHASE, PERF_PRD_START, PERF_PRD_END, BASELINE_PRD_START, BASELINE_PRD_END, VBP_YES_NO,
	TARGET, THRESHOLD, NATIONAL_50_PCTL, NATIONAL_90_PCTL,FLOOR
	FROM VBP_PT_SAT_DETAIL
	WHERE DIMENSION IS NOT NULL
	AND FACILITY = V_FACILITY
	AND PATIENT_TYPE = V_PATIENT_TYPE
	AND FINAL_UNIT_NAME = V_FINAL_UNIT
	AND DIMENSION = V_DIMENSION
	AND QUESTIONNUMBER = V_QUESTIONNUMBER
	AND QUESTIONLABEL = V_QUESTIONLABEL
	AND DISCHARGE_DATE = V_DISCHARGE_DATE
	GROUP BY MEASURE_KEY, VBP_BENCHMARK, VBP_THRESHOLD,
	ASSIGNMENT_YEAR, PHASE, PERF_PRD_START, PERF_PRD_END, BASELINE_PRD_START, BASELINE_PRD_END, 		VBP_YES_NO,TARGET, THRESHOLD, NATIONAL_50_PCTL, NATIONAL_90_PCTL,FLOOR)
	WHERE ROWID = V_ROWID;
	END LOOP;
	CLOSE C_STG_UPD;
COMMIT;
END;
/

--======= VBP PT SAT AGG ==========================


TRUNCATE TABLE VBP_PT_SAT_AGG
/

INSERT INTO VBP_PT_SAT_AGG
	SELECT * FROM VBP_PT_SAT_AGG_STG
/
COMMIT
/

/************************
	INSERT INTO VBP_PT_SAT_AGG
(FACILITY, PATIENT_TYPE, FINAL_UNIT_NAME, QUESTIONNUMBER, DIMENSION, QUESTIONLABEL, 
MEASURE_KEY, DISCHARGE_DATE, VBP_BENCHMARK, VBP_THRESHOLD,
ASSIGNMENT_YEAR, POSITIVE_RESP_COUNT,  TOTAL_RESP_COUNT,
PHASE, PERF_PRD_START, PERF_PRD_END, BASELINE_PRD_START, BASELINE_PRD_END, VBP_YES_NO,
TARGET, THRESHOLD, NATIONAL_50_PCTL, NATIONAL_90_PCTL,FLOOR)
	SELECT 
FACILITY, PATIENT_TYPE, FINAL_UNIT_NAME, QUESTIONNUMBER, DIMENSION,  QUESTIONLABEL, 
MEASURE_KEY, DISCHARGE_DATE, VBP_BENCHMARK, VBP_THRESHOLD,
ASSIGNMENT_YEAR, SUM(RATING), SUM(ROW_COUNT),
PHASE, PERF_PRD_START, PERF_PRD_END, BASELINE_PRD_START, BASELINE_PRD_END, VBP_YES_NO,
TARGET, THRESHOLD, NATIONAL_50_PCTL, NATIONAL_90_PCTL,FLOOR
FROM VBP_PT_SAT_DETAIL
WHERE DIMENSION IS NOT NULL
GROUP BY FACILITY, PATIENT_TYPE, FINAL_UNIT_NAME, QUESTIONNUMBER, DIMENSION, QUESTIONLABEL, MEASURE_KEY, DISCHARGE_DATE, VBP_BENCHMARK, VBP_THRESHOLD,ASSIGNMENT_YEAR, PHASE, PERF_PRD_START, PERF_PRD_END, BASELINE_PRD_START, BASELINE_PRD_END, VBP_YES_NO,
TARGET, THRESHOLD, NATIONAL_50_PCTL, NATIONAL_90_PCTL,FLOOR
/
*************************************/

commit
/


UPDATE VBP_PT_SAT_AGG
SET DIMENSION_DESC = dimension||'('||final_unit_name||')'
/

commit
/



DECLARE
	CURSOR C_YTD IS
	SELECT FACILITY, PATIENT_TYPE, FINAL_UNIT_NAME, DIMENSION, QUESTIONLABEL, DISCHARGE_DATE, ROWID
	from VBP_PT_SAT_AGG;
	V_FACILITY VARCHAR2(20);
	V_DIMENSION VARCHAR2(200);
	V_QLABEL VARCHAR2(200);
	V_DISCHARGE_DATE DATE;
	V_ROWID ROWID;
	V_PATIENT_TYPE VARCHAR2(200);
	V_FINAL_UNIT VARCHAR2(200);
BEGIN
	OPEN C_YTD;
	LOOP
	FETCH C_YTD INTO V_FACILITY, V_PATIENT_TYPE, V_FINAL_UNIT, V_DIMENSION, V_QLABEL, V_DISCHARGE_DATE, V_ROWID;
	EXIT WHEN C_YTD%NOTFOUND;

	UPDATE VBP_PT_SAT_AGG
	SET (YTD_POSITIVE_RESP_COUNT, YTD_TOTAL_RESP_COUNT) = (SELECT SUM(POSITIVE_RESP_COUNT), 		
					SUM(TOTAL_RESP_COUNT)
			FROM VBP_PT_SAT_AGG
			WHERE DISCHARGE_DATE <= V_DISCHARGE_DATE
			AND EXTRACT(YEAR FROM DISCHARGE_DATE) = EXTRACT(YEAR FROM V_DISCHARGE_DATE)
			AND FACILITY = V_FACILITY
			AND PATIENT_TYPE = V_PATIENT_TYPE
			AND FINAL_UNIT_NAME = V_FINAL_UNIT
			AND DIMENSION = V_DIMENSION
			AND QUESTIONLABEL = V_QLABEL)
	WHERE ROWID = V_ROWID;
	END LOOP;
	CLOSE C_YTD;
COMMIT;
END;
/






--=========== TARGET /THRESHOLD WEIGHTED ===============

UPDATE VBP_PT_SAT_AGG
SET TARGET_WEIGHTED = TARGET * TOTAL_RESP_COUNT,
    THRESHOLD_WEIGHTED = THRESHOLD * TOTAL_RESP_COUNT
/

commit
/


--======== REMOVE 'ED-A: Overall rating of facility' =============

UPDATE VBP_PT_SAT_AGG
SET QUESTIONLABEL = NULL
WHERE PATIENT_TYPE LIKE 'Community%'

/
commit
/




