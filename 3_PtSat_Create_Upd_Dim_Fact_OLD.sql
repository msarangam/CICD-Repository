


--DIM_ADMNSRVY_D

TRUNCATE TABLE DIM_ADMNSRVY_D
/


Insert into DIM_admnsrvy_d
(ADMNSRVY_ID          ,
    ADMNSRVY_VN         ,
    SRVY_ID              ,
    SRVY_VN              ,
    SRVY_DEL_METHD_CD_ID,
    ADMNSRVY_NBR         ,
    serdate ,
    SRVY_PD_END_DT ,
    admitdate ,
    disdate ,
    rtrn_dt ,
    NT                        ,
    ORIG_SRVY_DEL_METHD_CD_ID ,
    CREATED_BY_ID            ,
    CHANGED_BY_ID            ,
    CREATED_ON_DT ,
    CHANGED_ON_DT ,
    INSERT_DT,
    UPDATE_DT ,
    REQUEST_ID ,
    SRC_EFF_FROM_DT,
    SRC_EFF_TO_DT ,
    EFFECTIVE_FROM_DT ,
    EFFECTIVE_TO_DT ,
    CURRENT_FLG              ,
    INCORRECT_FLG          ,
    DATASOURCE_NUM_ID        ,
    lithocd           ,
    TENANT_ID                ,
    DELETE_FLG               ,
    SRVY_DEL_METHD_CD_VN     ,
    ORIG_SRVY_DEL_METHD_CD_VN ,
    Fname             ,
    middle               ,
    Lname              ,
    gender                     ,
    langid                    ,
    admtsrc                      ,
    city                 ,
    disunit                      ,
   facname                   ,
     LOS                    ,
    st                  ,
    zip5                   ,
    visittype2                    ,
    hospital                     ,
    --UDA15                    ,
    visittype3,
    age                 ,
    admittime                     ,
    distime                    ,
    dob ,
    UDA20,
    enterprise_id)
select
    ADMNSRVY_ID         ,
    ADMNSRVY_VN         ,
    SRVY_ID             ,
    SRVY_VN             ,
    SRVY_DEL_METHD_CD_ID ,
    ADMNSRVY_NBR         ,
    SRVY_PD_STRT_DT,
    SRVY_PD_END_DT ,
    SVC_STRT_DT ,
    SVC_END_DT ,
    SRVY_SNT_DT ,
    NT                       ,
    ORIG_SRVY_DEL_METHD_CD_ID ,
    CREATED_BY_ID             ,
    CHANGED_BY_ID             ,
    CREATED_ON_DT ,
    CHANGED_ON_DT ,
    sysdate,
    sysdate,
    REQUEST_ID ,
    SRC_EFF_FROM_DT ,
    SRC_EFF_TO_DT ,
    EFFECTIVE_FROM_DT ,
    EFFECTIVE_TO_DT ,
    CURRENT_FLG              ,
    INCORRECT_FLG             ,
    DATASOURCE_NUM_ID         ,
    INTEGRATION_ID           ,
    TENANT_ID                ,
    DELETE_FLG               ,
    SRVY_DEL_METHD_CD_VN     ,
    ORIG_SRVY_DEL_METHD_CD_VN ,
    UDA1                      ,
    UDA2                      ,
    UDA3                     ,
    UDA4                      ,
    UDA5                      ,
    UDA6                     ,
    UDA7                      ,
    UDA8                      ,
    UDA9                      ,
    UDA10                    ,
    UDA11                    ,
    UDA12                    ,
    UDA13                     ,
    UDA14                    ,
    UDA15                    ,
    UDA16                    ,
    UDA17                    ,
    UDA18                     ,
    UDA19 ,
    UDA20,
    enterprise_id
From hdm.hdm_admnsrvy
where current_flg = 'Y'
/

commit
/



-- =========== DIM_SRVY_D ===================

TRUNCATE TABLE DIM_SRVY_D
/
COMMIT
/


insert into dim_srvy_d
select * from hdm.hdm_srvy
where current_flg = 'Y'
/
commit
/




--=========== DIM_SRVY_QSTN_D =====================

TRUNCATE TABLE DIM_SRVY_QSTN_D
/

insert into dim_srvy_qstn_d
select * from hdm.hdm_srvy_qstn
where current_flg = 'Y'
/
COMMIT
/


--============= FACT_STG_SRVY_QSTN_RSPNS_F ===============

TRUNCATE TABLE FACT_STG_SRVY_QSTN_RSPNS_F
/

INSERT INTO FACT_STG_SRVY_QSTN_RSPNS_F
(SRVY_QSTN_rspns_ID	,
SRVY_QSTN_RSPNS_VN	,
SRVY_FDBCK_ID	,
SRVY_FDBCK_VN	,
SRVY_QSTN_ID	,
SRVY_QSTN_VN	,
RSPNS_VAL_TYP_ID	,
RSPNS_VAL_CD_ID	,
scalelabel	,
responsevalue	,
RSPNS_VAL_FLG	,
NT	,
ORIG_RSPNS_VAL_TYP_ID	,
ORIG_RSPNS_VAL_CD_ID	,
CREATED_BY_ID	,
CHANGED_BY_ID	,
CREATED_ON_DT	,
CHANGED_ON_DT	,
INSERT_DT	,
UPDATE_DT	,
REQUEST_ID	,
SRC_EFF_FROM_DT	,
SRC_EFF_TO_DT	,
EFFECTIVE_FROM_DT	,
EFFECTIVE_TO_DT	,
CURRENT_FLG	,
INCORRECT_FLG	,
DATASOURCE_NUM_ID	,
INTEGRATION_ID	,
TENANT_ID	,
DELETE_FLG	,
ORIG_RSPNS_VAL_TYP_VN	,
ORIG_RSPNS_VAL_CD_VN	,
RSPNS_VAL_TYP_VN	,
RSPNS_VAL_CD_VN	,
RECRD_SET_ID	,
ENTERPRISE_ID	,
CORRECTION_FLG	,
visittype	,
visitnum	,
account_number	,
UDA4	,
UDA5	,
UDA6	,
UDA7	,
UDA8	,
UDA9	,
UDA10	,
UDA11	,
UDA12	,
UDA13	,
UDA14	,
UDA15	,
UDA16	,
UDA17	,
UDA18	,
UDA19	,
UDA20	,
UDA1_CD_ID	,
UDA1_CD_VN	,
UDA2_CD_ID	,
UDA2_CD_VN	,
UDA3_CD_ID	,
UDA3_CD_VN	,
UDA4_CD_ID	,
UDA4_CD_VN	,
UDA5_CD_ID	,
UDA5_CD_VN	,
ORIG_UDA1_CD_ID	,
ORIG_UDA1_CD_VN	,
ORIG_UDA2_CD_ID	,
ORIG_UDA2_CD_VN	,
ORIG_UDA3_CD_ID	,
ORIG_UDA3_CD_VN	,
ORIG_UDA4_CD_ID	,
ORIG_UDA4_CD_VN	,
ORIG_UDA5_CD_ID	,
ORIG_UDA5_CD_VN	) 
select 
SRVY_QSTN_rspns_ID	,
SRVY_QSTN_RSPNS_VN	,
SRVY_FDBCK_ID	,
SRVY_FDBCK_VN	,
SRVY_QSTN_ID	,
SRVY_QSTN_VN	,
RSPNS_VAL_TYP_ID	,
RSPNS_VAL_CD_ID	,
RSPNS_VAL_TXT	,
RSPNS_VAL_NMERIC	,
RSPNS_VAL_FLG	,
NT	,
ORIG_RSPNS_VAL_TYP_ID	,
ORIG_RSPNS_VAL_CD_ID	,
CREATED_BY_ID	,
CHANGED_BY_ID	,
CREATED_ON_DT	,
CHANGED_ON_DT	,
INSERT_DT	,
UPDATE_DT	,
REQUEST_ID	,
SRC_EFF_FROM_DT	,
SRC_EFF_TO_DT	,
EFFECTIVE_FROM_DT	,
EFFECTIVE_TO_DT	,
CURRENT_FLG	,
INCORRECT_FLG	,
DATASOURCE_NUM_ID	,
INTEGRATION_ID	,
TENANT_ID	,
DELETE_FLG	,
ORIG_RSPNS_VAL_TYP_VN	,
ORIG_RSPNS_VAL_CD_VN	,
RSPNS_VAL_TYP_VN	,
RSPNS_VAL_CD_VN	,
RECRD_SET_ID	,
ENTERPRISE_ID	,
CORRECTION_FLG	,
UDA1	,
UDA2	,
UDA3	,
UDA4	,
UDA5	,
UDA6	,
UDA7	,
UDA8	,
UDA9	,
UDA10	,
UDA11	,
UDA12	,
UDA13	,
UDA14	,
UDA15	,
UDA16	,
UDA17	,
UDA18	,
UDA19	,
UDA20	,
UDA1_CD_ID	,
UDA1_CD_VN	,
UDA2_CD_ID	,
UDA2_CD_VN	,
UDA3_CD_ID	,
UDA3_CD_VN	,
UDA4_CD_ID	,
UDA4_CD_VN	,
UDA5_CD_ID	,
UDA5_CD_VN	,
ORIG_UDA1_CD_ID	,
ORIG_UDA1_CD_VN	,
ORIG_UDA2_CD_ID	,
ORIG_UDA2_CD_VN	,
ORIG_UDA3_CD_ID	,
ORIG_UDA3_CD_VN	,
ORIG_UDA4_CD_ID	,
ORIG_UDA4_CD_VN	,
ORIG_UDA5_CD_ID	,
ORIG_UDA5_CD_VN	
from hdm.hdm_srvy_qstn_rspns
where current_flg = 'Y'
/

COMMIT
/



/************
===============Create Calendar=================
create table t as 
 select trunc(sysdate)-11680 startdate,
        trunc(sysdate) + 10950 enddate
 from   dual;


insert into dim_calendar_d (cal_day)
select startdate+level-1 
from   t
connect by level <= (enddate-startdate)+1;

update dim_calendar_d set cal_week = to_char(cal_day, 'iw')

update dim_calendar_d set cal_year = extract(year from cal_day)

update dim_calendar_d set year_desc = ('YR'||'Cal_Year')

***************/


--==================Load Keys into Fact=======================


update FACT_STG_SRVY_QSTN_RSPNS_F set(lithocd)= substr(integration_id,1,instr(integration_id,'|')-1)
/
COMMIT
/




-- ============= UPDATE WITH DATA FROM DIM_ADMNSRVY_D 


DECLARE
	CURSOR C_QSTN_RSPNS IS 
	SELECT DISTINCT LITHOCD, ROWID FROM FACT_STG_SRVY_QSTN_RSPNS_F;
	V_LITHOCD VARCHAR2(20);
	V_ROWID ROWID;

BEGIN
	OPEN C_QSTN_RSPNS;
	LOOP
	FETCH C_QSTN_RSPNS INTO V_LITHOCD, V_ROWID;
	EXIT WHEN C_QSTN_RSPNS%NOTFOUND;

	UPDATE FACT_STG_SRVY_QSTN_RSPNS_F
		SET (SRVY_ID, ADMNSRVY_ID, DISDATE, DISUNIT, FACNAME, HOSPITAL, VISITTYPE2, VISITTYPE3) =
		(SELECT SRVY_ID, ADMNSRVY_ID, DISDATE, DISUNIT, FACNAME, HOSPITAL,VISITTYPE2, VISITTYPE3
		FROM DIM_ADMNSRVY_D 
		WHERE LITHOCD = V_LITHOCD)
	WHERE LITHOCD = V_LITHOCD
	AND ROWID = V_ROWID;
	END LOOP;
	CLOSE C_QSTN_RSPNS;
COMMIT;
END;
/

-- LOAD CAL_MONTH_NAME ETC TO THE STG FACT ============

update FACT_STG_SRVY_QSTN_RSPNS_F set disdate_year = extract(year from DISDATE)
/
COMMIT
/
update FACT_STG_SRVY_QSTN_RSPNS_F set disdate_month = extract(month from DISDATE)

/
COMMIT
/

--========== UPDATE WITH DATE ID ==========================
	
DECLARE
	CURSOR C_DATE_ID IS 
	SELECT DISDATE, ROWID FROM FACT_STG_SRVY_QSTN_RSPNS_F;
	V_DISDATE DATE;
	V_ROWID ROWID;
	
BEGIN
	OPEN C_DATE_ID;
	LOOP
	FETCH C_DATE_ID INTO V_DISDATE, V_ROWID;
	EXIT WHEN C_DATE_ID%NOTFOUND;

	UPDATE FACT_STG_SRVY_QSTN_RSPNS_F
		SET (DATE_ID) =
		(SELECT DATE_ID
		FROM DIM_CALENDAR_D
		WHERE CAL_DAY = V_DISDATE)
	WHERE DISDATE = V_DISDATE
	AND ROWID = V_ROWID;
	END LOOP;
	CLOSE C_DATE_ID;
COMMIT;
END;
/


---=============== UPADATE VISITTYPE MODIFIED =======================

DECLARE
	CURSOR C1 IS 
	SELECT ROWID, VISITTYPE FROM FACT_STG_SRVY_QSTN_RSPNS_F;
BEGIN
	FOR UPD_VISITTYPE IN C1 LOOP
	IF LENGTH(UPD_VISITTYPE.VISITTYPE) = 12 THEN
	UPDATE FACT_STG_SRVY_QSTN_RSPNS_F
	SET VISITTYPE_MODIFIED = SUBSTR(UPD_VISITTYPE.VISITTYPE, 3)
	WHERE ROWID = UPD_VISITTYPE.ROWID;

	ELSIF LENGTH(UPD_VISITTYPE.VISITTYPE) = 14 THEN
	UPDATE FACT_STG_SRVY_QSTN_RSPNS_F
	SET VISITTYPE_MODIFIED = SUBSTR(UPD_VISITTYPE.VISITTYPE, 4)
	WHERE ROWID = UPD_VISITTYPE.ROWID;

	ELSIF INSTR(UPD_VISITTYPE.VISITTYPE, 'AMB') <> 0 THEN
	UPDATE FACT_STG_SRVY_QSTN_RSPNS_F
	SET VISITTYPE_MODIFIED = SUBSTR(UPD_VISITTYPE.VISITTYPE, -11, 11)
	WHERE ROWID = UPD_VISITTYPE.ROWID;

	ELSIF INSTR(UPD_VISITTYPE.VISITTYPE, 'MEC') <> 0 THEN
	UPDATE FACT_STG_SRVY_QSTN_RSPNS_F
	SET VISITTYPE_MODIFIED = SUBSTR(UPD_VISITTYPE.VISITTYPE, -11, 11)
	WHERE ROWID = UPD_VISITTYPE.ROWID;

	ELSE UPDATE FACT_STG_SRVY_QSTN_RSPNS_F
	SET VISITTYPE_MODIFIED = SUBSTR(UPD_VISITTYPE.VISITTYPE, -10, 10)
	WHERE ROWID = UPD_VISITTYPE.ROWID;
	END IF;
	END LOOP;
COMMIT;
END;
/

--======== UPDATE WITH DATA FROM REV_CODE_REF FOR VISITTYPE2 =====================

DECLARE
	CURSOR C_REV_CODE IS 
	SELECT DISTINCT DISUNIT, VISITTYPE_MODIFIED, ROWID
	FROM FACT_STG_SRVY_QSTN_RSPNS_F;


	V_DISUNIT VARCHAR2(50);
	V_VISITTYPE_MODIFIED VARCHAR2(50);
--	V_YEAR VARCHAR2(4);
	V_ROWID ROWID;

BEGIN
	OPEN C_REV_CODE;
	LOOP
	FETCH C_REV_CODE INTO V_DISUNIT, V_VISITTYPE_MODIFIED, V_ROWID;
	EXIT WHEN C_REV_CODE%NOTFOUND;

	UPDATE FACT_STG_SRVY_QSTN_RSPNS_F
	SET (FACILITY, FINAL_UNIT_NAME, SURVEY_TYPE,
			sample_unit, survey_code, patient_type)  = 
	(SELECT distinct FACILITY, FINAL_UNIT_NAME, SURVEY_TYPE,
			sample_unit, survey_code, patient_type
		FROM REV_CODE_REF 
			WHERE REV_CODE = V_DISUNIT
			AND SURVEY_CODE = V_VISITTYPE_MODIFIED
			--AND YEAR = V_YEAR
			and rownum = 1)
--	WHERE DISUNIT = V_DISUNIT
--	AND VISITTYPE_MODIFIED = V_VISITTYPE_MODIFIED
--	AND EXTRACT(YEAR FROM DISDATE) = V_YEAR
  	where ROWID = V_ROWID;
	END LOOP;
	CLOSE C_REV_CODE;
COMMIT;
END;
/


--======== UPDATE WITH DATA FROM REV_CODE_REF FOR VISITYTYPE3 =====================


DECLARE
	CURSOR C_REV_CODE IS 
	SELECT DISTINCT ltrim(rtrim(VISITTYPE3)), ROWID
	FROM FACT_STG_SRVY_QSTN_RSPNS_F
	WHERE VISITTYPE3 IS NOT NULL;
	
	V_VISITTYPE3 VARCHAR2(20);
	V_ROWID ROWID;
BEGIN
	OPEN C_REV_CODE;
	LOOP
	FETCH C_REV_CODE INTO V_VISITTYPE3, V_ROWID;
	EXIT WHEN C_REV_CODE%NOTFOUND;

	UPDATE FACT_STG_SRVY_QSTN_RSPNS_F
	SET 	(FACILITY, FINAL_UNIT_NAME, SURVEY_TYPE, 
			sample_unit, survey_code, patient_type)  = 
	(SELECT distinct FACILITY,FINAL_UNIT_NAME, SURVEY_TYPE, 
			sample_unit, survey_code, patient_type
		FROM REV_CODE_REF
			WHERE REV_CODE = V_VISITTYPE3
			AND ROWNUM = 1)
	WHERE ROWID = V_ROWID;
	END LOOP;
	CLOSE C_REV_CODE;
COMMIT;
END;
/



--===================== CREATE FACILITY DIM ==============


TRUNCATE table DIM_FACILITY_D
/


--================== Non-PMC Facilities ============== 

insert into dim_facility_d (facname, hospital, facility, sample_unit, final_unit_name)
select distinct a.facname, a.hospital, b.facility, b.sample_unit, b.final_unit_name 
from fact_stg_srvy_qstn_rspns_f a, rev_code_ref b
where a.disunit = b.rev_code
and a.visittype_modified = b.survey_code

/
COMMIT
/

--================== PMC Facilities ============== 

insert into dim_facility_d (facname, hospital, facility, sample_unit, final_unit_name)
select distinct a.facname, a.hospital, b.facility, b.sample_unit, b.final_unit_name 
from fact_stg_srvy_qstn_rspns_f a, rev_code_ref b
where a.visittype3 = b.rev_code
/
COMMIT
/



DECLARE
	CURSOR C_FACILITY_ID 
	IS SELECT ROWID, FACNAME
	FROM DIM_FACILITY_D;
BEGIN
	FOR V_FACILITY_ID IN C_FACILITY_ID LOOP
	UPDATE DIM_FACILITY_D
	SET FACILITY_ID = FACILITY_ID_SEQ.NEXTVAL
	WHERE ROWID = V_FACILITY_ID.ROWID;
	END LOOP;
COMMIT;
END;
/


-- ======= UPDATE FACT STG WITH DATA FROM DIM_FACILITY_D  ========================

DECLARE
	CURSOR C_FACILITY_ID IS 
	SELECT FACNAME,HOSPITAL, SAMPLE_UNIT, FACILITY, FINAL_UNIT_NAME, ROWID 
	FROM FACT_STG_SRVY_QSTN_RSPNS_F;
	V_FACNAME VARCHAR2(50);
	V_HOSPITAL VARCHAR2(100);
	V_SAMPLE_UNIT VARCHAR2(50);
	V_FACILITY VARCHAR2(50);
	V_FINAL_UNIT_NAME VARCHAR2(50);
	V_ROWID ROWID;
BEGIN
	OPEN C_FACILITY_ID;
	LOOP
	FETCH C_FACILITY_ID INTO V_FACNAME,V_HOSPITAL, V_SAMPLE_UNIT, V_FACILITY, 
		V_FINAL_UNIT_NAME, V_ROWID;
	EXIT WHEN C_FACILITY_ID%NOTFOUND;

	UPDATE FACT_STG_SRVY_QSTN_RSPNS_F
		SET (FACILITY_ID) =
		(SELECT FACILITY_ID 
		FROM DIM_FACILITY_D
		WHERE FACNAME = V_FACNAME
		AND HOSPITAL = V_HOSPITAL
		AND SAMPLE_UNIT = V_SAMPLE_UNIT
		AND FACILITY = V_FACILITY
		AND FINAL_UNIT_NAME = V_FINAL_UNIT_NAME)
	WHERE ROWID = V_ROWID;
	END LOOP;
	CLOSE C_FACILITY_ID;
COMMIT;
END;
/


--================== Add Question Number to Stg Fact FROM DIM_SRVY_QSTN_D   ============

DECLARE
	CURSOR C_QID IS SELECT DISTINCT SRVY_QSTN_ID
	FROM FACT_STG_SRVY_QSTN_RSPNS_F;
	V_QID VARCHAR2(20);
BEGIN
	OPEN C_QID;
	LOOP
	FETCH C_QID INTO V_QID;
	EXIT WHEN C_QID%NOTFOUND;	

	UPDATE FACT_STG_SRVY_QSTN_RSPNS_F
	SET (QUESTIONNUMBER, QUESTIONLABEL) = (SELECT QUESTIONNUMBER, QUESTIONLABEL 
	FROM DIM_SRVY_QSTN_D
	WHERE SRVY_QSTN_ID = V_QID)
	WHERE SRVY_QSTN_ID = V_QID;
	END LOOP;
	CLOSE C_QID;
COMMIT;
END;
/


update FACT_STG_SRVY_QSTN_RSPNS_F 
set questionnumber =  substr(questionnumber, 1, 7)
where length(questionnumber) = 8
/
COMMIT
/



--====== APPLY RATINGS USING QUERY RATING SPREADSHEET FROM FENGWEI ======


DECLARE
	CURSOR C_RATING IS
	SELECT ltrim(rtrim(QUESTIONNUMBER)), RESPONSEVALUE, ROWID 
	FROM FACT_STG_SRVY_QSTN_RSPNS_F;
	V_QNUM VARCHAR2(20);
	V_RESVAL VARCHAR2(4);
	V_ROWID ROWID;
BEGIN
	OPEN C_RATING;
	LOOP
	FETCH C_RATING INTO V_QNUM, V_RESVAL, V_ROWID;
	EXIT WHEN C_RATING%NOTFOUND;

	UPDATE FACT_STG_SRVY_QSTN_RSPNS_F
	SET (RATING, ROW_COUNT) = (SELECT NUMERATOR, 1 
			FROM QUERY_RATING
			WHERE ltrim(rtrim(QUESTIONNUMBER)) = V_QNUM
			AND RESPONSEVALUE = V_RESVAL
			AND ROWNUM = 1)
	--WHERE QUESTIONNUMBER = V_QNUM
	--AND RESPONSEVALUE = V_RESVAL
	WHERE ROWID = V_ROWID;
	END LOOP;
	CLOSE C_RATING;
COMMIT;
END;
/








