

update survey_data_raw
set disdate = to_char(to_date(substr(disdate,1,9), 'DDMONYYYY'), 'mm/dd/yyyy'),
    admitdate = to_char(to_date(substr(admitdate,1,9), 'DDMONYYYY'), 'mm/dd/yyyy'),
    rtrn_dt = to_char(to_date(substr(rtrn_dt,1,9), 'DDMONYYYY'), 'mm/dd/yyyy'),
    dob = to_char(to_date(substr(dob,1,9), 'DDMONYYYY'), 'mm/dd/yyyy'),
    serdate = to_char(to_date(substr(serdate,1,9), 'DDMONYYYY'), 'mm/dd/yyyy')
where length(disdate) =22
/
commit
/



update survey_data_raw 
set los = null 
where length(los) =1
and los not in ('0','1','2','3','4','5','6','7','8','9')
/
commit
/

update survey_data_raw set admitdate = null where length(ADMITDATE) < 8
/
commit
/

TRUNCATE TABLE SURVEY_DATA_INTERFACE
/


INSERT INTO SURVEY_DATA_INTERFACE
  ( LITHOCD ,
    RTRN_DT ,
    ADMITDATE ,
    ADMTSRC ,
    ADMITTIME ,
    AGE  ,
    CITY ,
    DISDATE ,
    DISTIME ,
    DISUNIT ,
    DOB ,
    FACNAME ,
    FNAME   ,
    GENDER  ,
    LANGID  ,
    LOS     ,
    LNAME   ,
    MIDDLE  ,
    SERDATE ,
    ST             ,
    VISITNUM       ,
    VISITTYPE      ,
    ZIP5           ,
    RESPONSEVALUE  ,
    QUESTIONLABEL  ,
    SCALELABEL     ,
    PROBLEM_SCORE ,
    VISITTYPE2     ,
    HOSPITAL       ,
    QUESTIONNUMBER ,
    VISITTYPE3,
    raw_data_insert_date)
SELECT LITHOCD ,
    TO_DATE (RTRN_DT , 'MM/DD/YYYY'),
    TO_DATE(ADMITDATE ,'MM/DD/YYYY'),
    ADMTSRC ,
    ADMITTIME ,
    TO_NUMBER(AGE)  ,
    CITY ,
    TO_DATE(DISDATE , 'MM/DD/YYYY'),
    DISTIME , 
    DISUNIT ,
    TO_DATE(DOB ,'MM/DD/YYYY'),
    FACNAME ,
    FNAME   ,
    GENDER  ,
    LANGID  ,
    TO_NUMBER(LOS)    ,
    LNAME   ,
    MIDDLE  ,
    TO_DATE(SERDATE ,'MM/DD/YYYY'),
    ST             ,
    VISITNUM       ,
    VISITTYPE,
    ZIP5,
    TO_NUMBER(RESPONSEVALUE),
    QUESTIONLABEL  ,
    SCALELABEL     ,
    PROBLEM_SCORE ,
    VISITTYPE2     ,
    HOSPITAL       ,
    QUESTIONNUMBER ,
    VISITTYPE3,
    to_char(sysdate, 'DD-MON-YYYY hh:mi:ss')     
FROM SURVEY_DATA_RAW
where admitdate between '1/15/13' and '2/15/13'
and rownum < 9000
/
commit
/



--============= UPDATE VISITTYPE MODIFIED =====================

DECLARE
	CURSOR C1 IS 
	SELECT ROWID, VISITTYPE FROM SURVEY_DATA_INTERFACE;
BEGIN
	FOR UPD_VISITTYPE IN C1 LOOP
	IF LENGTH(UPD_VISITTYPE.VISITTYPE) = 12 THEN
	UPDATE SURVEY_DATA_INTERFACE
	SET VISITTYPE_MODIFIED = SUBSTR(UPD_VISITTYPE.VISITTYPE, 3)
	WHERE ROWID = UPD_VISITTYPE.ROWID;

	ELSIF LENGTH(UPD_VISITTYPE.VISITTYPE) = 14 THEN
	UPDATE SURVEY_DATA_INTERFACE
	SET VISITTYPE_MODIFIED = SUBSTR(UPD_VISITTYPE.VISITTYPE, 4)
	WHERE ROWID = UPD_VISITTYPE.ROWID;

	ELSIF INSTR(UPD_VISITTYPE.VISITTYPE, 'AMB') <> 0 THEN
	UPDATE SURVEY_DATA_INTERFACE
	SET VISITTYPE_MODIFIED = SUBSTR(UPD_VISITTYPE.VISITTYPE, -11, 11)
	WHERE ROWID = UPD_VISITTYPE.ROWID;

	ELSIF INSTR(UPD_VISITTYPE.VISITTYPE, 'MEC') <> 0 THEN
	UPDATE SURVEY_DATA_INTERFACE
	SET VISITTYPE_MODIFIED = SUBSTR(UPD_VISITTYPE.VISITTYPE, -11, 11)
	WHERE ROWID = UPD_VISITTYPE.ROWID;

	ELSE UPDATE SURVEY_DATA_INTERFACE
	SET VISITTYPE_MODIFIED = SUBSTR(UPD_VISITTYPE.VISITTYPE, -10, 10)
	WHERE ROWID = UPD_VISITTYPE.ROWID;
	END IF;
	END LOOP;
COMMIT;
END;

/

--============== CLEAN UP REV CODE REF ===============


UPDATE REV_CODE_REF
SET REV_CODE = LTRIM(RTRIM(REV_CODE))
/
commit
/

UPDATE REV_CODE_REF
SET SURVEY_CODE = LTRIM(RTRIM(SURVEY_CODE))
/
commit
/

update survey_data_interface set visittype3 =  null where length(visittype3) = 1
/
commit
/

update rev_code_ref
set final_unit_name = '0'||final_unit_name
where  patient_type like 'Inp%'
and substr(final_unit_name,1,1) in ('1','2','3','4','5','6','7','8','9','0')
and substr(final_unit_name,2,1) not in ('1','2','3','4','5','6','7','8','9','0')
/
commit
/

--================= UPDATE INTERFACE FIELDS =====================
	
DECLARE
	CURSOR C_REV_CODE IS 
	SELECT DISTINCT ltrim(rtrim(DISUNIT)), ltrim(rtrim(VISITTYPE_MODIFIED)), 
	EXTRACT(YEAR FROM DISDATE), ROWID 
	FROM SURVEY_DATA_INTERFACE
	ORDER BY 1;
	V_DISUNIT VARCHAR2(20);
	V_VISITTYPE_MOD VARCHAR2(20);
	V_YEAR VARCHAR2(4);
	V_ROWID ROWID;
BEGIN
	OPEN C_REV_CODE;
	LOOP
	FETCH C_REV_CODE INTO V_DISUNIT, V_VISITTYPE_MOD, v_year, V_ROWID;
	EXIT WHEN C_REV_CODE%NOTFOUND;

	UPDATE SURVEY_DATA_INTERFACE
	SET (FACILITY,FINAL_UNIT_NAME, SURVEY_TYPE, sample_unit, rev_code, survey_code, patient_type)  = 
			(SELECT distinct FACILITY, FINAL_UNIT_NAME, SURVEY_TYPE, 										sample_unit, rev_code, survey_code, patient_type
			FROM REV_CODE_REF
			WHERE ltrim(rtrim(REV_CODE)) = V_DISUNIT
			AND ltrim(rtrim(SURVEY_CODE)) = V_VISITTYPE_MOD
			and rownum = 1)
			--AND YEAR = V_YEAR)
	WHERE ROWID = V_ROWID;
	END LOOP;
	CLOSE C_REV_CODE;
COMMIT;
END;
/


--=================== UPDATE INTERFACE FOR PMC RECORDS =============



UPDATE SURVEY_DATA_INTERFACE
	SET (FACILITY, FINAL_UNIT_NAME, SURVEY_TYPE, YEAR, sample_unit, 
 	rev_code, survey_code, patient_type)  =
  (select null, null, null, null,null,null, null,null from dual)
  where visittype3 is not null
/

commit
/


DECLARE
	CURSOR C_REV_CODE IS 
	SELECT DISTINCT ltrim(rtrim(VISITTYPE3)), ROWID
	FROM SURVEY_DATA_INTERFACE
	WHERE VISITTYPE3 IS NOT NULL;
	
	V_VISITTYPE3 VARCHAR2(20);
	V_ROWID ROWID;
	
BEGIN
	OPEN C_REV_CODE;
	LOOP
	FETCH C_REV_CODE INTO  V_VISITTYPE3, V_ROWID;
	EXIT WHEN C_REV_CODE%NOTFOUND;

	UPDATE SURVEY_DATA_INTERFACE
	SET (FACILITY, FINAL_UNIT_NAME, SURVEY_TYPE, YEAR, 
			sample_unit, rev_code, survey_code, patient_type)  = 
			(SELECT distinct FACILITY,FINAL_UNIT_NAME, SURVEY_TYPE, YEAR,
			sample_unit, rev_code, survey_code, patient_type
			FROM REV_CODE_REF
			WHERE ltrim(rtrim(REV_CODE)) = ltrim(rtrim(V_VISITTYPE3))
			and rownum =1)
	WHERE ROWID = V_ROWID;
	END LOOP;
	CLOSE C_REV_CODE;
COMMIT;
END;
/




























