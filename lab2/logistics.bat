@echo off
setlocal EnableDelayedExpansion
::chcp 65001>nul
chcp 1252>nul

set file=windata.txt
set width=6
set height=7
set length=
set col_to_read=

:OPEN_FILE_MATRIX
	set /a width-=1
	set /a height-=1
	
	for /l %%a in (0,1,%width%) do (
		set col_to_read=%%a
		call :OPEN_FILE
		for /l %%b in (0,1,!length!) do (
			set mat_%%a_%%b=!arr_%%b!
		)
	)

	set col_to_read=1
	::call :OPEN_FILE
	
	::call :BUBBLE
	
	::call :PRINT_MAT
	
	::call :PRINT_ARR

	set strlen_input=james
	call :STRLEN
	echo %strlen%

	goto :EOF
:OPEN_FILE_MATRIX_END

goto EXIT

:OPEN_FILE
	set length=0
	set /a col_to_read+=1
	for /f "tokens=%col_to_read% delims=," %%a in (%file%) do (
		set arr_!length!=%%a
		set /A length+=1
	)
	set /A length-=1
	goto :EOF
:OPEN_FILE_END

:BUBBLE
	for /l %%a in (0,1,%length%) do (
		set i=%%a
		for /l %%b in (0,1,%length%) do (	
			set j=%%b
			if /i !arr_%%a! LSS !arr_%%b! (
				call :SWAP
			)
		)
	)
	goto :EOF
:BUBBLE_END

:SWAP
	set tmp=!arr_%i%!
	set arr_%i%=!arr_%j%!
	set arr_%j%=!tmp!
	for /l %%x in (0,1,%width%) do (
		set tmp=!mat_%%x_%i%!
		set mat_%%x_%i%=!mat_%%x_%j%!
		set mat_%%x_%j%=!tmp!
	)
	goto :EOF
:SWAP_END

:STRLEN
	set strlen=0
	:STRLEN_NEXT
		set /a strlen+=1
		if "!strlen_input:~%strlen%,1!" NEQ "" goto :STRLEN_NEXT
	:STRLEN_NEXT_END
	goto :EOF
:STRLEN_END

:PRINT_ARR
	for /l %%c in (0,1,%length%) do echo !arr_%%c!
	goto :EOF
:PRINT_ARR_END

:PRINT_MAT
	for /l %%y in (0,1,%height%) do (
		set output_str=
		set tmp_str=
		for /l %%x in (0,1,%width%) do (
			set tmp_str=!output_str!
			set output_str=!tmp_str!  !mat_%%x_%%y!
		)
		echo !output_str!
	)
	goto :EOF
:PRINT_MAT_END

:EXIT
