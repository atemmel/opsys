::FOR /F %%i IN (data.txt) DO @echo %%i %%j
::for /f "tokens=4 delims=, " %%a in (data.txt) do (
::	echo %%a
::)
@echo  off
setlocal EnableDelayedExpansion



::goto EXIT

:OPEN_FILE
	set length=0
	for /f "tokens=4 delims=," %%a in (windata.txt) do (
		set arr_!length!=%%a
		set /A length+=1
	)
	set /A length-=1
:OPEN_FILE_END

:BUBBLE
	for /l %%a in (0,1,%length%) do (
		set i=%%a
		for /l %%b in (0,1,%length%) do (	
			set j=%%b
			if /i !arr_%%a! LSS !arr_%%b! (
				set tmp=!arr_%%a!
				set arr_!i!=!arr_%%b!
				set arr_!j!=!tmp!
			)
		)
	)
:BUBBLE_END

:PRINT_ARR
	for /l %%c in (0,1,%length%) do echo !arr_%%c!
:PRINT_ARR_END


:EXIT
