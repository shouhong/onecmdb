:: Nagios export script 
@ECHO OFF

CALL ..\setenv.cmd
echo ============ENVIRONMENT=====================
echo ONECMDB_HOME=%ONECMDB_HOME%
echo JAVA_HOME=%JAVA_HOME%
echo ONECDMB_URL=%ONECMDB_URL%
echo ONECDMB_URL=%ONECMDB_DESKTOP_URL%
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
IF [%SWITCH%] == [/exportDir] goto setExportDir
IF [%SWITCH%] == [/onecmdb_token] goto setToken

SHIFT
goto checkparameters

:setName
SET NAME=%NAME%
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

:setExportDir
SET EXPORT_DIR=%VALUE%
SHIFT
goto checkparameters

:help
ECHO Nagios import start script: 
ECHO Options:
ECHO /exportDir:dir - Specifies the path to where nagios config files are located.
ECHO /mdr_history:ALIAS   - Specifies the history entry name.
ECHO /onecmdb_token:token - login token from onecmdb.
goto end

:endswitchparsing

if [%EXPORT_DIR%] == [] GOTO noexportdir

:: MAIN Start point

ECHO Start export nagios config to %EXPORT_DIR% ...
CALL "%JAVA_HOME%\bin\java" -cp "%ONECMDB_HOME%\lib\classloader.jar" org.onecmdb.utils.classloader.RemoteClassLoader "%ONECMDB_URL%/remote/classpath/;file:lib/onecmdb-nagios-utils.jar" org.onecmdb.nagios.OneCMDB2Nagios --output %EXPORT_DIR%/nagios-export.cfg
IF %ERRORLEVEL% NEQ 0 GOTO nagioserror


ECHO Terminated.
EXIT 0


:noexportdir
ECHO ERROR: No export directory specified.
EXIT -1
