::FOR /F %%i IN (data.txt) DO @echo %%i %%j
::for /f "tokens=4 delims=, " %%a in (data.txt) do (
::	echo %%a
::)
@echo  off
setlocal EnableDelayedExpansion

set length=0
for /f "tokens=4 delims=, " %%a in (windata.txt) do (
	set arr_%length%=%%a
	set /A length+=1
)

echo %length%

for /L %%a in (0,1,%length%) do (
	set lhs=%%a
	for /L %%b in (0,1,%length%) do (	
	
		set rhs=%%b
		echo !lhs!
		echo !rhs!
		if /I !lhs! LSS !rhs! goto pass
		set tmp=!lhs!
		
		:pass
		
	)
)

for /L %%c in (0,1,%length%) do echo !arr_%%c!


:setlocal EnableDelayedExpansion
:for /l %%i in (1, 1, 10) do (
 : set array_%%i=!random!
:)

:for /l %%i in (1, 1, 10) do (
 : echo !array_%%i!
:)

::set j=0
::for /f %%a in 

