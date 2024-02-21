@ECHO OFF

ECHO -
ECHO - MDM Diff. Starting...
ECHO -

REM set MDD file names
SET "MDD_A=p2302159IN_auto_20240207.mdd"
SET "MDD_B=p2302159IN_v20.mdd"

REM SET "MDD_A=p221365_auto_11-18-2022.mdd"
REM SET "MDD_B=p221365_v16.mdd"

REM SET "MDD_A=P190827_auto_11-08-2022.mdd"
REM SET "MDD_B=P200138_auto_11-16-2022.mdd"





REM get reports
ECHO -
ECHO "- Getting report for MDD_A %MDD_A%"
SET "REPORT_A=report.%MDD_A%.json"
SET "REPORT_B=report.%MDD_B%.json"
REM :: possible params:
REM ::  "/a:RUN_FEATURES=label,properties,translations,scripting"
REM ::  /d:RUN_SECTIONS=119
REM ::  "/a:RUN_FEATURES_LABEL_FORCE_CONTEXT=Question"
REM ::  "/a:RUN_FEATURES_PROPERTIES_CONTEXTS=Analysis,Question"
REM mrscriptcl mdmrep.mrs "/a:INPUT_MDD=%MDD_A%" "/a:RUN_FEATURES=label" /d:RUN_SECTIONS=64
REM if %ERRORLEVEL% NEQ 0 ( echo ERROR: Failure && pause && exit /b %errorlevel% )
python mdmcreatehtmlrep.py "%REPORT_A%"
if %ERRORLEVEL% NEQ 0 ( echo ERROR: Failure && pause && exit /b %errorlevel% )
REM :: possible params:
REM ::  "/a:RUN_FEATURES=label,properties,translations,scripting"
REM ::  /d:RUN_SECTIONS=119
REM ::  "/a:RUN_FEATURES_LABEL_FORCE_CONTEXT=Question"
REM ::  "/a:RUN_FEATURES_PROPERTIES_CONTEXTS=Analysis,Question"
ECHO "- Getting report for MDD_B %MDD_B%"
REM mrscriptcl mdmrep.mrs "/a:INPUT_MDD=%MDD_B%" "/a:RUN_FEATURES=label" /d:RUN_SECTIONS=64
if %ERRORLEVEL% NEQ 0 ( echo ERROR: Failure && pause && exit /b %errorlevel% )
python mdmcreatehtmlrep.py "%REPORT_B%"
if %ERRORLEVEL% NEQ 0 ( echo ERROR: Failure && pause && exit /b %errorlevel% )


SET "REPORT_A=report.%MDD_A%.json"
SET "REPORT_B=report.%MDD_B%.json"



REM get diff
SET "REPORT_DIFF=report.diff-report.%MDD_A%-%MDD_B%.json"
ECHO -
ECHO - Calling the diff script
python mdmfinddiff.py "%REPORT_A%" "%REPORT_B%"
if %ERRORLEVEL% NEQ 0 ( echo ERROR: Failure && pause && exit /b %errorlevel% )
::report.diff-report.{mdd_a}-{mdd_b}.json
python mdmcreatehtmlrep.py "%REPORT_DIFF%"
if %ERRORLEVEL% NEQ 0 ( echo ERROR: Failure && pause && exit /b %errorlevel% )

ECHO -
ECHO - MDM Diff. Reached the end of script
ECHO -
