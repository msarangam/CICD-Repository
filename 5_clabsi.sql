TRUNCATE TABLE VBP_CLABSI_DETAIL
/

INSERT INTO VBP_CLABSI_DETAIL
	(FACILITY                      ,
        MEASURE                        ,
    OBSERVED_INFECTIONS_NO        ,
    PATIENT_DAYS                   ,
    EXPECTED_INFECTIONS_NO         ,
    SIR                            ,
    P_VALUE                       ,
    SD_95                         ,
    SIGNIFICANCE_RATING,
    MONTH)          
SELECT 
	FACILITY                      ,
       INFECTION_TYPE                ,
    OBSERVED_INFECTIONS_NO        ,
    PATIENT_DAYS                   ,
    EXPECTED_INFECTIONS_NO         ,
    SIR                            ,
    P_VALUE                       ,
    CI                         ,
    SIGNIFICANCE_RATING ,
    MONTH         
FROM VBP_CLABSI_RAW
/
COMMIT
/


DECLARE
	CURSOR C_PRD IS
	SELECT facility, MONTH, MEASURE, ROWID
	from VBP_CLABSI_DETAIL;
	V_MONTH DATE;
	V_MEASURE VARCHAR2(200);
	v_facility varchar2(200);
	V_ROWID ROWID;
BEGIN
	OPEN C_PRD;
	LOOP
	FETCH C_PRD INTO v_facility, V_MONTH, V_MEASURE, V_ROWID;
	EXIT WHEN C_PRD%NOTFOUND;

	UPDATE VBP_CLABSI_DETAIL
	SET (TARGET, THRESHOLD, PHASE) = (SELECT VBP_THRESHOLD, VBP_BENCHMARK,PHASE
			FROM VBP_TARGETS
			WHERE MEASURE = V_MEASURE
			and facility = v_facility
			AND perf_prd_start <= v_month
			and perf_prd_end >= v_month  )
	WHERE ROWID = V_ROWID;
	END LOOP;
	CLOSE C_PRD;
COMMIT;
END;
/

update vbp_clabsi_detail set rolling_period = to_char(month,'YYYY')||' Thru '||'Qtr'||to_char(month,'Q')
where month is not null
/



commit
/

/**********
--update vbp_clabsi_detail set target = 0.437 where measure = 'CLABSI_ICU'
/
commit
/

---update vbp_clabsi_detail set threshold = null where measure = 'CLABSI_ICU'
/
commit
/

---update vbp_clabsi_detail set phase = 3 where measure = 'CLABSI_ICU'
/
commit
************************/


update vbp_clabsi_detail set year =substr(rolling_period, 1,4), 
				ROLLING_qtr = substr(rolling_period, -4)
/
commit
/

update vbp_clabsi_detail set ROLLING_qtr_NO = DECODE(ROLLING_QTR, 'Qtr1',1, 'Qtr2',2,
			'Qtr3', 3, 'Qtr4',4, NULL)
/
commit
/

update vbp_clabsi_detail set year_period = year||rolling_qtr_no
/

commit
/

UPDATE VBP_CLABSI_DETAIL SET CASE_COUNT = EXPECTED_INFECTIONS_NO
WHERE EXPECTED_INFECTIONS_NO NOT LIKE '%N/A%'
/
COMMIT

UPDATE VBP_CLABSI_DETAIL SET PERF_SCORE = SIR
WHERE SIR NOT LIKE '%N/A%'
/
COMMIT
/

UPDATE VBP_CLABSI_DETAIL
SET MEASURE =  '*'||MEASURE
WHERE MEASURE = 'CLABSI_ICU'
/
COMMIT
/
