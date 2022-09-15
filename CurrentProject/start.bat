

@taskkill /im Love.exe
@cd /d%~dp0..    
@del /s CurrentProject\*.bak 
@cls
  

@cd %cd%"\CurrentProject"  

@start "CurrentProject" "LOVE\love.exe" %cd% 

                         