@ECHO OFF

ECHO -
ECHO - MDM Diff. Starting...
ECHO -
SET true=1==1
SET false=1==0



REM set MDD file names
SET "MDD_A=p123456.mdd"
SET "MDD_B=p654321.mdd"



REM :: change to %true% or %false%
REM :: don't add spaces around " = ", like in other programming languages
SET compare_properties=%true%
SET compare_translations=%true%
SET compare_metadata_scripts=%true%
SET compare_routing=%true%







REM get reports
ECHO -
ECHO "- Getting report for MDD_A %MDD_A%"
SET "REPORT_A=report.%MDD_A%.xml"
SET "REPORT_B=report.%MDD_B%.xml"
SET "mdmrep_params= /d:RUN_SECTIONS=55 /a:RUN_FEATURES=label"
IF %compare_properties% (
SET "mdmrep_params=%mdmrep_params%,properties"
)
IF %compare_translations% (
SET "mdmrep_params=%mdmrep_params%,translations"
)
IF %compare_metadata_scripts% (
SET "mdmrep_params=%mdmrep_params%,scripting"
)
REM :: example call:
REM :: mrscriptcl mdmrep.mrs "/a:INPUT_MDD=%MDD_A%" "/a:RUN_FEATURES=label,properties,translations" /d:RUN_SECTIONS=119
REM :: possible params:
REM ::  "/a:RUN_FEATURES=label,properties,translations,scripting"
REM ::  /d:RUN_SECTIONS=119
REM ::  "/a:RUN_FEATURES_LABEL_FORCE_CONTEXT=Question"
REM ::  "/a:RUN_FEATURES_PROPERTIES_CONTEXTS=Analysis,Question"
mrscriptcl mdmrep.mrs "/a:INPUT_MDD=%MDD_A%" %mdmrep_params%
if %ERRORLEVEL% NEQ 0 ( echo ERROR: Failure && pause && exit /b %errorlevel% )
python mdmcreatehtmlrep.py "%REPORT_A%"
if %ERRORLEVEL% NEQ 0 ( echo ERROR: Failure && pause && exit /b %errorlevel% )
IF %compare_routing% (
mrscriptcl mdmrep.mrs "/a:INPUT_MDD=%MDD_A%" /a:RUN_FEATURES=label /d:RUN_SECTIONS=64 /a:REPORT_FILENAME_SUFFIX=.routing
if %ERRORLEVEL% NEQ 0 ( echo ERROR: Failure && pause && exit /b %errorlevel% )
)
REM :: MDD_B:
mrscriptcl mdmrep.mrs "/a:INPUT_MDD=%MDD_B%" %mdmrep_params%
if %ERRORLEVEL% NEQ 0 ( echo ERROR: Failure && pause && exit /b %errorlevel% )
python mdmcreatehtmlrep.py "%REPORT_B%"
if %ERRORLEVEL% NEQ 0 ( echo ERROR: Failure && pause && exit /b %errorlevel% )
IF %compare_routing% (
mrscriptcl mdmrep.mrs "/a:INPUT_MDD=%MDD_B%" /a:RUN_FEATURES=label /d:RUN_SECTIONS=64 /a:REPORT_FILENAME_SUFFIX=.routing
if %ERRORLEVEL% NEQ 0 ( echo ERROR: Failure && pause && exit /b %errorlevel% )
)



REM get diff
SET "REPORT_DIFF=report.diff-report.%MDD_A%-%MDD_B%.json"
ECHO -
ECHO - Calling the diff script
python mdmfinddiff.py "%REPORT_A%" "%REPORT_B%"
if %ERRORLEVEL% NEQ 0 ( echo ERROR: Failure && pause && exit /b %errorlevel% )
::report.diff-report.{mdd_a}-{mdd_b}.json
python mdmcreatehtmlrep.py "%REPORT_DIFF%"
if %ERRORLEVEL% NEQ 0 ( echo ERROR: Failure && pause && exit /b %errorlevel% )
SET "REPORTROUTING_A=report.%MDD_A%.routing.xml"
SET "REPORTROUTING_B=report.%MDD_B%.routing.xml"
SET "REPORTREPORTROUTING1_DIFF=report.diff-report.%MDD_A%.routing-%MDD_B%.routing.json"
SET "REPORTREPORTROUTING2_DIFF=report.diff-report.%MDD_A%-%MDD_B%.routing.json"
IF %compare_routing% (
ECHO - And diff script for routing
python mdmfinddiff.py "%REPORTROUTING_A%" "%REPORTROUTING_B%"
if %ERRORLEVEL% NEQ 0 ( echo ERROR: Failure && pause && exit /b %errorlevel% )
REN "%REPORTREPORTROUTING1_DIFF%" "%REPORTREPORTROUTING2_DIFF%"
python mdmcreatehtmlrep.py "%REPORTREPORTROUTING2_DIFF%"
if %ERRORLEVEL% NEQ 0 ( echo ERROR: Failure && pause && exit /b %errorlevel% )
)

ECHO -
ECHO - MDM Diff. Reached the end of script
ECHO -