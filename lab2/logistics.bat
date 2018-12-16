@echo off
setlocal EnableDelayedExpansion
::chcp 65001>nul
chcp 1252>nul

set file=windata.txt
set height=7
set width=6
set col_w_0=3
set col_w_1=12
set col_w_2=5
set col_w_3=3
set col_w_4=3
set col_w_5=3
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
	call :OPEN_FILE
	
	call :BUBBLE
	
	call :PRINT_MAT
	
	::call :PRINT_ARR

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
			set n_space=!col_w_%%x!
			set strlen_input=!mat_%%x_%%y!
			call :STRLEN
			set /a n_space-=strlen
			call :MAKE_N_SPACE
			set tmp_str=!output_str!
			set output_str=!tmp_str!!mat_%%x_%%y! !space_str!
		)
		echo !output_str!
	)
	goto :EOF
:PRINT_MAT_END

:MAKE_N_SPACE
	set space_str=
	for /l %%x in (1,1,%n_space%) do (
		set tmp_str=!space_str!
		set space_str= !tmp_str!
	)
:MAKE_N_SPACE_END

:EXIT
