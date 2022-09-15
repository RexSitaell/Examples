

@taskkill /im Love.exe
@cd /d%~dp0..    
@del /s fractalDragon\*.bak 
@cls
  

@cd %cd%"\fractalDragon"  

@start "fractalDragon" "LOVE\love.exe" %cd% 

                         