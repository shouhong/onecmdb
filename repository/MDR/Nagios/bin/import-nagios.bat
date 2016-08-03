:: Nagios import script 
@ECHO OFF

CALL ..\setenv.cmd
echo ============ENVIRONMENT=====================
echo ONECMDB_HOME=%ONECMDB_HOME%
echo JAVA_HOME=%JAVA_HOME%
echo ONECDMB_URL=%ONECMDB_URL%
echo ONECDMB_URL_DESKTOP=%ONECMDB_DESKTOP_URL%
echo ============================================


:checkparameters
:: REM Grab the first variable supplied as a whole.
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
IF [%SWITCH%] == [/importDir] goto setImportDir
IF [%SWITCH%] == [/onecmdb_token] goto setToken
SHIFT
goto checkparameters

:setToken
SET TOKEN=%VALUE%
SHIFT
goto checkparameters


:setHistory
SET HISTORY=%VALUE%
SHIFT
goto checkparameters

:setImportDir
SET IMPORT_DIR=%VALUE%
SHIFT
goto checkparameters

:help
ECHO Nagios import start script: 
ECHO Options:
ECHO /importDir:dir - Specifies the path to where nagios config files are located.
ECHO /mdr_history:ALIAS   - Specifies the history entry name.
ECHO /onecmdb_token:token - login token from onecmdb.
goto end

:endswitchparsing

if [%TOKEN%] == [] GOTO notoken

ECHO ImportDir=%IMPORT_DIR% HISTORY=%HISTORY% TOKEN=%TOKEN%

:: MAIN Start point
ECHO Convert nagios cfg to xml.
CALL "%JAVA_HOME%\bin\java" -cp "lib\onecmdb-nagios-utils.jar" org.onecmdb.nagios.Config2XML nagios_configs/example %IMPORT_DIR% 
IF %ERRORLEVEL% NEQ 0 GOTO nagioserror

ECHO Start import nagios config from %IMPORT_DIR% ...
CALL "%JAVA_HOME%\bin\java" -cp "%ONECMDB_HOME%\lib\classloader.jar" org.onecmdb.utils.classloader.RemoteClassLoader "%ONECMDB_URL%/remote/classpath/;file:lib/onecmdb-nagios-utils.jar" org.onecmdb.nagios.Nagios2OneCMDB --input %IMPORT_DIR% --output result/nagios-onecmdb.xml
IF %ERRORLEVEL% NEQ 0 GOTO nagioserror

:: If history entry is specified upload result to changehandler.
IF [%HISTORY%] == [] goto end
ECHO Upload result to change manager.
CALL "%ONECMDB_HOME%/bin/upload.bat" --token %TOKEN% --postURL %ONECMDB_DESKTOP_URL%/onecmdb/change --input result\nagios-onecmdb.xml --history %HISTORY%

IF %ERRORLEVEL% NEQ 0 GOTO uploaderror

:end
ECHO Terminated.
EXIT 0

:nagioserror
ECHO Nagios transform terminated with error code %ERRORLEVEL%
EXIT %ERRORLEVEL%

:uploaderror
ECHO Upload terminated with error code %ERRORLEVEL%
EXIT %ERRORLEVEL%

:notoken
ECHO ERROR: No token specified.
EXIT -1
