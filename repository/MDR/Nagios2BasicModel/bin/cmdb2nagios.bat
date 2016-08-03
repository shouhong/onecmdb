:: CMDB2Nagios Start script 
@ECHO OFF

CALL ..\setenv.cmd
echo ============ENVIRONMENT=====================
echo ONECMDB_HOME=%ONECMDB_HOME%
echo JAVA_HOME=%JAVA_HOME%
echo ONECDMB_URL=%ONECMDB_URL%
echo ONECDMB_URL_DESKTOP=%ONECMDB_DESKTOP_URL%
echo ============================================

SET NAME=default

:checkparameters
:: REM Grab the first variable supplied as a whole. Ex. /action:start
set SWITCHPARSE=%1
ECHO %SWITCHPARSE%

:: REM Check to see if there are no more switches, if so goto end of 
:: parsing, prevents endless loop
IF [%SWITCHPARSE%] == [] goto endswitchparsing
:: REM Reset variables as clean up. Dont know if i need this anymore
:: since i am checking for exit above. Oh well.
set SWITCH=
set VALUE=
:: In the SWITCHPARSE variable, grab the two tokens separated 
:: by a : and assign the first to SWITCH and the second to VALUE
for /F "tokens=1,2 delims=: " %%a IN ("%SWITCHPARSE%") DO SET SWITCH=%%a&set VALUE=%%b
:: Check which action to perform based on the switch
IF [%SWITCH%] == [/?] goto help
IF [%SWITCH%] == [/h] goto help
IF [%SWITCH%] == [/help] goto help
IF [%SWITCH%] == [/mdr_history] goto setHistory
IF [%SWITCH%] == [/name] goto setName
IF [%SWITCH%] == [/onecmdb_token] goto setToken
SHIFT
goto checkparameters

:setToken
SET TOKEN=%VALUE%
SHIFT
goto checkparameters

:setName
SET NAME=%VALUE%
SHIFT
goto checkparameters

:setHistory
SET HISTORY=%VALUE%
SHIFT
goto checkparameters

:help
ECHO CMDB2NAGIOS start script: 
ECHO Options:
ECHO /name:NAME - A name for this discovery
ECHO /mdr_history:ALIAS   - Specifies the history entry name.
ECHO /onecmdb_token:token - login token from onecmdb.
goto end

:endswitchparsing

if [%TOKEN%] == [] GOTO notoken

ECHO HISTORY=%HISTORY% TOKEN=%TOKEN%

:: MAIN Start point
ECHO Start transform...
::CALL "%ONECMDB_HOME%\bin\generate-transform.bat" --input conf/cmdb2nagios.xml --type xml --output conf/cmdb2nagios-transform.xml
:IF %ERRORLEVEL% NEQ 0 GOTO transformerror

::ECHO Transform output.
 
CALL "%ONECMDB_HOME%/bin/transform.bat" --url %ONECMDB_URL%/webservice/onecmdb --token %TOKEN% --transform conf/cmdb2nagios.xml --transformType simple --fileSource "%ONECMDB_DESKTOP_URL%/onecmdb/export?name=cmdb2nagios.cfg" --sourceType xml  --name cmdb2nagios --output result/cmdb2nagios_result.xml
IF %ERRORLEVEL% NEQ 0 GOTO transformerror

:: If history entry is specified upload result to changehandler.
IF [%HISTORY%] == [] goto end
ECHO Upload result to change manager.
CALL "%ONECMDB_HOME%/bin/upload.bat" --token %TOKEN% --postURL %ONECMDB_DESKTOP_URL%/onecmdb/change --input result\cmdb2nagios_result.xml --history %HISTORY%

IF %ERRORLEVEL% NEQ 0 GOTO uploaderror

:end
ECHO Terminated.
EXIT 0


:transformerror
ECHO Transform terminated with error code %ERRORLEVEL%
EXIT %ERRORLEVEL%

:uploaderror
ECHO Upload terminated with error code %ERRORLEVEL%
EXIT %ERRORLEVEL%

:notoken
ECHO ERROR: No token specified.
EXIT -1
