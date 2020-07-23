
---======== Employee Summary =============

TRUNCATE TABLE emp_survey
/


INSERT INTO emp_survey
  ( FACILITY ,
    survey_PERIOD ,
    engagement_score,
    percentile,
    goal_score,
    TARGET_3        ,
    STRETCH_5     
    )
SELECT FACILITY ,
    survey_PERIOD ,
    engagement_score,
    percentile,
    goal_score,
    TARGET_3        ,
    STRETCH_5
FROM emp_survey_RAW
/
COMMIT
/

DECLARE
	CURSOR C_IND IS 
	SELECT TARGET_3, STRETCH_5, ROWID FROM emp_survey;
	V_ROWID ROWID;
	V_TGT NUMBER;
	V_STRETCH NUMBER;
BEGIN
	OPEN C_IND;
	LOOP
	FETCH C_IND INTO V_TGT, V_STRETCH, V_ROWID;
	EXIT WHEN C_IND%NOTFOUND;
	UPDATE emp_survey
	SET PERF_INDICATOR = 'RED' 
	WHERE percentile < V_TGT
	AND ROWID = V_ROWID;

	UPDATE emp_survey
	SET PERF_INDICATOR = 'GREEN' 
	WHERE percentile >= V_STRETCH
	AND ROWID = V_ROWID;

	UPDATE emp_survey
	SET PERF_INDICATOR = 'YELLOW' 
	WHERE percentile BETWEEN V_TGT AND V_STRETCH
	AND ROWID = V_ROWID;
	END LOOP;
	CLOSE C_IND;
COMMIT;
END;
/


