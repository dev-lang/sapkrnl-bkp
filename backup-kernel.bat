@echo off
setlocal ENABLEEXTENSIONS

REM ==================================================
REM  Backup kernel + profiles SAP (Windows)
REM  Uso: backup-kernel SID
REM  Ej : backup-kernel PRD
REM ==================================================

if "%1"=="" (
  echo Uso: %~nx0 SID
  exit /b 1
)

set SID=%1

REM ===== Fecha YYYY-MM-DD =====
for /f %%i in ('wmic os get LocalDateTime ^| find "."') do set DTS=%%i
set FECHA=%DTS:~0,4%-%DTS:~4,2%-%DTS:~6,2%

REM ===== Paths =====
set BASE=C:\backup_kernel
set KERNEL_SRC=C:\usr\sap\%SID%\SYS\exe\uc\NTAMD64
set PROFILE_SRC=C:\usr\sap\%SID%\SYS\profile

set KERNEL_DST=%BASE%\%SID%\kernel_%FECHA%
set PROFILE_DST=%BASE%\%SID%\profile_%FECHA%

echo =====================================
echo   Backup SAP %SID%
echo =====================================

REM ===== Validaciones =====
if not exist "%KERNEL_SRC%" (
  echo ERROR: No existe %KERNEL_SRC%
  exit /b 2
)

if not exist "%PROFILE_SRC%" (
  echo ERROR: No existe %PROFILE_SRC%
  exit /b 3
)

REM ===== Crear destinos =====
mkdir "%KERNEL_DST%" >nul 2>&1
mkdir "%PROFILE_DST%" >nul 2>&1

REM ===== Copia kernel =====
echo.
echo -> Copiando kernel UC...
robocopy "%KERNEL_SRC%" "%KERNEL_DST%" /MIR /COPY:DAT /R:0 /W:0 /XJ

REM ===== Copia profiles =====
echo.
echo -> Copiando profiles...
robocopy "%PROFILE_SRC%" "%PROFILE_DST%" /MIR /COPY:DAT /R:0 /W:0

echo.
echo Backup finalizado para %SID%
echo Kernel : %KERNEL_DST%
echo Profile: %PROFILE_DST%
echo.

pause
endlocal
