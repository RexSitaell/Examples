::@echo off

@taskkill /im Love.exe
@cd /d%~dp0..    
@del /s clicker\*.bak 
@cls
::@set project_path=%~1   
::@if "%~1"=="" (set project_path=noproj)
::@del Sitael\engine\project.txt
::@echo %project_path%>>Sitael\engine\project.txt   

@cd %cd%"\clicker"  
::@echo %cd%  
::@pause
@start "clicker" "engine\core\LOVE\love.exe" %cd% 

::@set /p wait=""
:: @ - бесшумное выполнение команды
:: cd /d - переход в текущую директорию
:: %~dp0.. -переход на 1*(..) уровень выше
:: @del (удаление файлов) /s(в т.ч во всех подкаталогах) Sitael\engine\(путь) *.bak(расширение)                             