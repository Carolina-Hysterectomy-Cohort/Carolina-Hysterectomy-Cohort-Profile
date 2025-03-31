/* Note October 9, 2024: This is a copy of the original file that has folder references removed to be transferred to SRW*/



libname ZHcheck /*Path redacted*/;
%inc /*Path redacted*/'hyst_redcapformat.sas';

data ZH_payor_Check;
set ZHcheck.hyst_master_jm;

/**Looking at our analytic cohort***/
if aim1_2_sample=1;

/** grouping into payor categories**/
If insurance_modified in ("Medicaid Only","Medicare Only","Agency Only") then payorgrp = "Public";
else if insurance_modified in ("Tricare Only","Private Insurance Only") then payorgrp = "Private";
else if insurance_modified in ("Self-Pay Only") then payorgrp = "Unins";

/**Saw this coding in ZH's paper***/
if marital_status=" " then marital_status= "Unknown";

/***Adding hysterectomy hospital sites, 1. Academic, 0 Non-academic ***/
if c_hospital in ("XXXX", "XXXX") then CDWH_HOSP_ID = 1;
else if c_hospital in ("XXXX", "XXXX", "XXXX", "XXXX", "XXXX", "XXXX") then CDWH_HOSP_ID = 0;

run;

proc freq data=ZH_payor_Check;
tables insurance_modified payorgrp / missing;
run;

proc freq data=ZH_payor_Check;
tables 

race_six_level* payorgrp
marital_status * payorgrp
CDWH_HOSP_ID * payorgrp
county_urban_surgery * payorgrp
(c_dx_anemia c_dx_endometriosis c_dx_fibroids c_dx_menorrhagia c_dx_pain) * payorgrp
(r_plan_dysmenorrhea r_plan_menorrhagia r_plan_aub r_plan_fibroids) * payorgrp
/ missing nopercent norow;
run;

proc sort data = ZH_payor_Check out = bypayor;
	by payorgrp;
	run;

proc means data = bypayor nmiss median min max;
	var r_age_hyst;
	by payorgrp;
	run;
