@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

:: ============================================================
::  CHECK_DeepAiUG.bat
::  Diagnostica automatica installazione DeepAiUG
:: ============================================================

set "DEST=%USERPROFILE%\DeepAiUG"
set "LOG=%USERPROFILE%\DeepAiUG_install_log.txt"
set "ERRORI=0"

title DeepAiUG - Diagnostica

echo.
echo  ============================================================
echo       DeepAiUG - Diagnostica installazione
echo  ============================================================
echo.

:: --- 1. Python ---
echo   1. Python
set "PY_OK=0"

if exist "C:\Program Files\Python312\python.exe" (
    set "PY_OK=1"
    echo      [OK] Python trovato in: C:\Program Files\Python312\python.exe
) else (
    where python >nul 2>&1
    if !errorlevel! equ 0 (
        set "PY_OK=1"
        for /f "tokens=*" %%P in ('where python') do echo      [OK] Python trovato nel PATH: %%P
    )
)

if !PY_OK! equ 0 (
    echo      [ERRORE] Python non trovato.
    echo      Soluzione: Scarica Python 3.12 da https://www.python.org/downloads/
    set /a ERRORI+=1
)
echo.

:: --- 2. Ollama ---
echo   2. Ollama

set "OLLAMA_OK=0"
if exist "%LOCALAPPDATA%\Ollama\ollama.exe" (
    set "OLLAMA_OK=1"
    echo      [OK] Ollama trovato in: %LOCALAPPDATA%\Ollama\
) else if exist "%LOCALAPPDATA%\Programs\Ollama\ollama.exe" (
    set "OLLAMA_OK=1"
    echo      [OK] Ollama trovato in: %LOCALAPPDATA%\Programs\Ollama\
) else (
    where ollama >nul 2>&1
    if !errorlevel! equ 0 (
        set "OLLAMA_OK=1"
        echo      [OK] Ollama trovato nel PATH.
    )
)

if !OLLAMA_OK! equ 0 (
    echo      [ERRORE] Ollama non trovato.
    echo      Soluzione: Scarica Ollama da https://ollama.com/download
    set /a ERRORI+=1
)
echo.

:: --- 3. Cartella DeepAiUG ---
echo   3. Cartella DeepAiUG

if exist "!DEST!" (
    echo      [OK] Cartella trovata: !DEST!
) else (
    echo      [ERRORE] Cartella non trovata: !DEST!
    echo      Soluzione: Esegui nuovamente INSTALLA_DeepAiUG.bat
    set /a ERRORI+=1
)
echo.

:: --- 4. Virtual Environment ---
echo   4. Ambiente virtuale (venv)

if exist "!DEST!\venv\Scripts\python.exe" (
    echo      [OK] venv trovato: !DEST!\venv\
) else (
    echo      [ERRORE] venv non trovato in: !DEST!\venv\
    echo      Soluzione: Esegui nuovamente INSTALLA_DeepAiUG.bat
    set /a ERRORI+=1
)
echo.

:: --- 5. requirements.txt ---
echo   5. requirements.txt

if exist "!DEST!\requirements.txt" (
    echo      [OK] requirements.txt trovato in: !DEST!\
) else (
    echo      [ERRORE] requirements.txt non trovato in: !DEST!\
    echo      Soluzione: Esegui nuovamente INSTALLA_DeepAiUG.bat
    set /a ERRORI+=1
)
echo.

:: --- 6. Modelli Ollama ---
echo   6. Modelli Ollama installati

where ollama >nul 2>&1
if !errorlevel! equ 0 (
    echo.
    ollama list 2>nul
    if !errorlevel! neq 0 (
        echo      [ATTENZIONE] Ollama non raggiungibile. Verifica che sia in esecuzione.
        echo      Soluzione: Avvia Ollama ^(icona nella barra di sistema^)
    )
) else (
    if exist "%LOCALAPPDATA%\Programs\Ollama\ollama.exe" (
        echo.
        "%LOCALAPPDATA%\Programs\Ollama\ollama.exe" list 2>nul
    ) else if exist "%LOCALAPPDATA%\Ollama\ollama.exe" (
        echo.
        "%LOCALAPPDATA%\Ollama\ollama.exe" list 2>nul
    ) else (
        echo      [ATTENZIONE] Impossibile elencare i modelli. Ollama non trovato.
    )
)
echo.

:: --- 7. Log installazione ---
echo   7. Log installazione

if exist "!LOG!" (
    echo      [OK] Log trovato: !LOG!
    echo.
    echo      Ultime 20 righe del log:
    echo      --------------------------------------------------------
    powershell -Command "Get-Content '!LOG!' -Tail 20 | ForEach-Object { Write-Host ('      ' + $_) }"
    echo.
    echo      --------------------------------------------------------
) else (
    echo      [INFO] Log installazione non trovato.
    echo      Il log viene creato durante l'installazione: !LOG!
)
echo.

:: --- Riepilogo ---
echo  ============================================================
if !ERRORI! equ 0 (
    echo   RISULTATO: Tutti i controlli superati!
    echo   DeepAiUG dovrebbe funzionare correttamente.
) else (
    echo   RISULTATO: Trovati !ERRORI! problemi.
    echo   Segui le indicazioni sopra per risolverli.
)
echo  ============================================================
echo.

pause
exit /b 0
