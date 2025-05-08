@echo off
chcp 65001 > nul
title Меню настроек Windows


net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Требуются права администратора!
    echo Перезапуск с правами администратора...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:menu
cls
echo ===================================
echo        Меню настроек Windows
echo ===================================
echo.
echo [1] Информация о системе
echo [2] Параметры питания
echo [3] Параметры проводника
echo [4] Управление автозагрузкой
echo [5] Тема и панель задач
echo [6] Активация Windows
echo [7] Сброс триала JetBrains IDE
echo [8] История буфера обмена
echo.
echo ===================================
echo.
echo [9] Выход
echo.
echo ===================================
echo.

set /p choice="Введите номер пункта (1-9): "

if "%choice%"=="1" goto system_info
if "%choice%"=="2" goto power_menu
if "%choice%"=="3" goto explorer_menu
if "%choice%"=="4" goto startup_menu
if "%choice%"=="5" goto theme_menu
if "%choice%"=="6" goto activation
if "%choice%"=="7" goto reset_jetbrains
if "%choice%"=="8" goto clipboard_menu
if "%choice%"=="9" goto exit
goto menu

:system_info
cls
echo Информация о системе:
echo ===================================
systeminfo
pause
goto menu

:power_menu
cls
echo Текущие схемы управления питанием:
echo ===================================
powercfg /list
echo.
echo [1] Высокая производительность
echo [2] Сбалансированная
echo [3] Экономия энергии
echo.
echo ===================================
echo.
echo [4] Вернуться в главное меню
echo.
echo ===================================
echo.

set /p power_choice="Выберите схему питания (1-4): "

if "%power_choice%"=="1" (
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    echo Схема "Высокая производительность" активирована
    pause
    goto power_menu
)
if "%power_choice%"=="2" (
    powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
    echo Схема "Сбалансированная" активирована
    pause
    goto power_menu
)
if "%power_choice%"=="3" (
    powercfg /setactive a1841308-3541-4fab-bc81-f71556f20b4a
    echo Схема "Экономия энергии" активирована
    pause
    goto power_menu
)
if "%power_choice%"=="4" goto menu
goto power_menu

:explorer_menu
cls
echo Параметры проводника:
echo ===================================
echo.
echo [1] Показать расширения файлов
echo [2] Скрыть расширения файлов
echo.
echo ===================================
echo.
echo [3] Включить историю открытий
echo [4] Отключить историю открытий
echo.
echo ===================================
echo.
echo [5] Вернуться в главное меню
echo.
echo ===================================
echo.

set /p explorer_choice="Выберите действие (1-5): "

if "%explorer_choice%"=="1" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f
    echo Расширения файлов теперь отображаются
    goto restart_explorer
)
if "%explorer_choice%"=="2" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 1 /f
    echo Расширения файлов теперь скрыты
    goto restart_explorer
)
if "%explorer_choice%"=="3" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackDocs /t REG_DWORD /d 1 /f
    echo История открытий включена
    goto restart_explorer
)
if "%explorer_choice%"=="4" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackDocs /t REG_DWORD /d 0 /f
    echo История открытий отключена
    goto restart_explorer
)
if "%explorer_choice%"=="5" goto menu
goto explorer_menu

:restart_explorer
echo.
echo Перезапуск проводника...
taskkill /f /im explorer.exe
start explorer.exe
echo Проводник перезапущен
pause
goto menu

:startup_menu
cls
echo Управление автозагрузкой:
echo ===================================
echo.
echo [1] Отключить все программы автозагрузки
echo [2] Вернуться в главное меню
echo.
echo ===================================
echo.

set /p startup_choice="Выберите действие (1-2): "

if "%startup_choice%"=="1" (
    echo Отключение программ автозагрузки...
    
    :: Отключение автозагрузки в реестре
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /va /f
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" /va /f
    reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /va /f
    reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce" /va /f
    
    :: Отключение автозагрузки в папке автозагрузки
    del /f /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\*.*"
    del /f /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\*.*"
    
    echo Все программы автозагрузки отключены
    pause
    goto menu
)
if "%startup_choice%"=="2" goto menu
goto startup_menu

:theme_menu
cls
echo Тема и панель задач:
echo ===================================
echo.
echo [1] Светлая тема
echo [2] Темная тема
echo [3] Системная тема
echo.
echo ===================================
echo.
echo [4] Сместить панель задач вслево
echo.
echo ===================================
echo.
echo [5] Вернуться в главное меню
echo.
echo ===================================
echo.

set /p theme_choice="Выберите действие (1-5): "

if "%theme_choice%"=="1" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 1 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 1 /f
    echo Светлая тема активирована
    goto restart_explorer
)
if "%theme_choice%"=="2" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f
    echo Темная тема активирована
    goto restart_explorer
)
if "%theme_choice%"=="3" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 1 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 1 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 1 /f
    echo Системная тема активирована
    goto restart_explorer
)
if "%theme_choice%"=="4" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 0 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSmallIcons /t REG_DWORD /d 0 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSizeMove /t REG_DWORD /d 1 /f
    echo Панель задач перемещена влево
    goto restart_explorer
)
if "%theme_choice%"=="5" goto menu
goto theme_menu

:activation
cls
echo Активация Windows...
echo ===================================
echo.
echo Выполняется активация, пожалуйста подождите...
echo.


start /b cmd /c "slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX >nul 2>&1"
timeout /t 2 /nobreak >nul
start /b cmd /c "slmgr /skms kms.digiboy.ir >nul 2>&1"
timeout /t 2 /nobreak >nul
start /b cmd /c "slmgr /ato >nul 2>&1"
timeout /t 2 /nobreak >nul

echo.
echo Успешно
echo.
pause
goto menu

:reset_jetbrains
cls
echo Сброс триала JetBrains IDE...
echo ===================================
echo.
echo Выполняется сброс, пожалуйста подождите...
echo.

:: Удаление папок eval и файлов конфигурации
for %%I in ("WebStorm", "IntelliJ", "CLion", "Rider", "GoLand", "PhpStorm", "Resharper", "PyCharm") do (
    for /d %%a in ("%USERPROFILE%\.%%I*") do (
        rd /s /q "%%a/config/eval" 2>nul
        del /q "%%a\config\options\other.xml" 2>nul
    )
)

:: Удаление папки JetBrains и ключа реестра
rmdir /s /q "%APPDATA%\JetBrains" 2>nul
reg delete "HKEY_CURRENT_USER\Software\JavaSoft" /f 2>nul

echo.
echo Триал успешно сброшен
echo.
pause
goto menu

:clipboard_menu
cls
echo История буфера обмена:
echo ===================================
echo.

:: Проверка текущего состояния
reg query "HKCU\Software\Microsoft\Clipboard" /v EnableClipboardHistory 2>nul | find "0x1" >nul
if %errorlevel% equ 0 (
    echo [1] Включить историю буфера обмена *
    echo [2] Отключить историю буфера обмена
) else (
    echo [1] Включить историю буфера обмена 
    echo [2] Отключить историю буфера обмена *
)

echo.
echo ===================================
echo.
echo [3] Вернуться в главное меню
echo.
echo ===================================
echo.

set /p clipboard_choice="Выберите действие (1-3): "

if "%clipboard_choice%"=="1" (
    reg add "HKCU\Software\Microsoft\Clipboard" /v EnableClipboardHistory /t REG_DWORD /d 1 /f
    echo История буфера обмена включена
    goto restart_explorer
)
if "%clipboard_choice%"=="2" (
    reg add "HKCU\Software\Microsoft\Clipboard" /v EnableClipboardHistory /t REG_DWORD /d 0 /f
    echo История буфера обмена отключена
    goto restart_explorer
)
if "%clipboard_choice%"=="3" goto menu
goto clipboard_menu

:exit
exit
