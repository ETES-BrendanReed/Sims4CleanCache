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
    SET /P "action=(D=Delete all screenshots) or (C=Check each file)? "
    IF /I "!action!"=="D" (
        FOR %%F IN (%screenshots%) DO (
            DEL "%%F"
            ECHO %%F deleted.
        )
        EXIT /B
    ) ELSE IF /I "!action!"=="C" (
        GOTO CheckEachFile
    ) ELSE (
        ECHO Invalid choice. Exiting.
        EXIT /B
    )
)

:CheckEachFile
SET "lastFile="
FOR %%F IN (%screenshots%) DO (
    SET "lastFile=%%F"
)

FOR %%F IN (%screenshots%) DO (
    IF EXIST "%%F" (
        SET "filename=%%~nxF"
        SET /P "choice=!filename! | (D=Delete/S=Skip/V=View): "
        IF /I "!choice!"=="D" (
            DEL "%%F"
            ECHO !filename! deleted.
        ) ELSE IF /I "!choice!"=="S" (
            ECHO !filename! skipped.
            IF "%%F"=="!lastFile!" (
                EXIT
            )
        ) ELSE IF /I "!choice!"=="V" (
            START "" "%%F"
            ECHO Viewing !filename!. Close the file to continue.
            PAUSE
        ) ELSE (
            ECHO Invalid choice. Please enter D, S, or V.
        )
    )
)
EXIT /B