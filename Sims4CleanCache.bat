@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
SET "localthumbcache=C:\Users\%Username%\Documents\Electronic Arts\The Sims 4\localthumbcache.package"
SET "avatarcache=C:\Users\%Username%\Documents\Electronic Arts\The Sims 4\avatarcache.package"
SET "lastexception=C:\Users\%Username%\Documents\Electronic Arts\The Sims 4\lastexception*.txt"
SET "lastcrash=C:\Users\%Username%\Documents\Electronic Arts\The Sims 4\lastcrash*.txt"
SET "notifyglob=C:\Users\%Username%\Documents\Electronic Arts\The Sims 4\notify.glob"
SET "sims4folder=C:\Users\%Username%\Documents\Electronic Arts\The Sims 4\"

@REM Functions to check and delete files
CALL :DeleteFiles "%avatarcache%"
CALL :DeleteFiles "%lastexception%"
CALL :DeleteFiles "%lastcrash%"
CALL :DeleteFiles "%notifyglob%"
FOR %%F IN ("%sims4folder%\screenshots\*.png") DO CALL :CheckAndDeleteY/N "%%F" ELSE (
    ECHO No more screenshots found.
)

ECHO Exiting in 5 seconds...
TIMEOUT /T 5 /NOBREAK
EXIT

:DeleteFiles
IF EXIST "%~1" (
    SET "filename=%~nx1"
    DEL "%~1"
    ECHO !filename! deleted.
) ELSE (
    ECHO %~1 does not exist.
)

:CheckAndDeleteY/N
IF EXIST "%~1" (
    SET "filename=%~nx1"
    SET /P "action=Screenshots - Delete all (D) or Check each file (C): "
    IF /I "!action!"=="D" (
        DEL "%sims4folder%\screenshots\*.png"
        ECHO All Screenshots deleted.
        ECHO Exiting in 5 seconds...
        TIMEOUT /T 5 /NOBREAK
        EXIT
    ) ELSE IF /I "!action!"=="C" (
        GOTO :CheckEachFile
    ) ELSE (
        ECHO Invalid choice. Select again.
        GOTO :CheckAndDeleteY/N
    )
)
:CheckEachFile
    IF EXIST "%~1" (
        SET "filename=%~nx1"
        SET /P "choice= !filename! - (D=Delete/S=Skip/V=View): "
    IF /I "!choice!"=="D" (
        DEL "%~1"
        ECHO !filename! deleted.
        GOTO :CheckEachFile
    ) ELSE IF /I "!choice!"=="S" (
        ECHO !filename! skipped.
    ) ELSE IF /I "!choice!"=="V" (
        START "" "%~1"
        ECHO Viewing !filename!. Close the file to continue.
        PAUSE
        GOTO :CheckEachFile
    ) ELSE (
        ECHO Invalid choice. Please enter D, S, or V.
        GOTO :CheckEachFile
    )
)
EXIT /B
