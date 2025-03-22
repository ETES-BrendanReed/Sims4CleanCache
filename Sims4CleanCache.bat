@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

SET "localthumbcache=C:\Users\%Username%\Documents\Electronic Arts\The Sims 4\localthumbcache.package"
SET "avatarcache=C:\Users\%Username%\Documents\Electronic Arts\The Sims 4\avatarcache.package"
SET "lastexception=C:\Users\%Username%\Documents\Electronic Arts\The Sims 4\lastexception*.txt"
SET "lastcrash=C:\Users\%Username%\Documents\Electronic Arts\The Sims 4\lastcrash*.txt"
SET "notifyglob=C:\Users\%Username%\Documents\Electronic Arts\The Sims 4\notify.glob"
SET screenshots="C:\Users\%Username%\Documents\Electronic Arts\The Sims 4\screenshots\*.png"

REM Functions to check and delete files
CALL :CheckAndDelete "%localthumbcache%"
CALL :CheckAndDelete "%avatarcache%"
CALL :CheckAndDelete "%lastexception%"
CALL :CheckAndDelete "%lastcrash%"
CALL :CheckAndDelete "%notifyglob%"
FOR %%F IN (%screenshots%) DO CALL :CheckAndDeleteY/N "%%F"

ECHO Waiting for 5 seconds...
TIMEOUT /T 5 /NOBREAK
EXIT

:CheckAndDelete
IF EXIST "%~1" (
    SET "filename=%~nx1"
    DEL "%~1"
    ECHO !filename! deleted.
) ELSE (
    ECHO %~1 does not exist.
)
EXIT /B

:CheckAndDeleteY/N
IF EXIST "%~1" (
    SET "filename=%~nx1"
    SET /P "action=Delete all (D) or Check each file (C)? "
    IF /I "!action!"=="D" (
        DEL "%~1"
        ECHO All files deleted.
        EXIT /B
    ) ELSE IF /I "!action!"=="C" (
        GOTO Prompt
    ) ELSE (
        ECHO Invalid choice. Exiting.
        EXIT /B
    )
    :Prompt
    ECHO Found: !filename!
    SET /P "choice=Delete, Skip, or View !filename! (Y=Delete/N=Skip/V=View): "
    IF /I "!choice!"=="Y" (
        DEL "%~1"
        ECHO !filename! deleted.
    ) ELSE IF /I "!choice!"=="N" (
        ECHO !filename! skipped.
    ) ELSE IF /I "!choice!"=="V" (
        START "" "%~1"
        ECHO Viewing !filename!. Close the file to continue.
        PAUSE
        GOTO Prompt
    ) ELSE (
        ECHO Invalid choice. Please enter Y, N, or V.
        GOTO Prompt
    )
)
EXIT /B