@echo off

rem Förlåt mig Jimpan, ty jag har syndat

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
set header=ID  NAME         VIKT  L   B   H

:READ_ARGS
	if "%1" == "" (
		goto :INTERACTIVE
	)
	if "%1" == "/?" (
		call :PRINT_HELP
		goto :EXIT
	)

	if "%2" == "" ( goto :BAD)

	set file=%1
	call :OPEN_FILE_MATRIX

	if "%2" == "/?" (
		call :PRINT_HELP
		goto :EXIT
	)

	if /i "%2" == "/print" (
		call :PRINT_MAT
		goto :EXIT
	)

	if /i "%2" == "/backup" (
		set  backup_file=windata.backup
		call :BACKUP
		echo !file! copied to !backup_file!
		goto :EXIT
	)

	if "%3" == "" ( goto :BAD)
	if /i "%2" == "/sort" (
		set col_to_read=

		if /i "%3" == "i" ( set col_to_read=0 )
		if /i "%3" == "n" ( set col_to_read=1 )
		if /i "%3" == "v" ( set col_to_read=2 )
		if /i "%3" == "l" ( set col_to_read=3 )
		if /i "%3" == "b" ( set col_to_read=4 )
		if /i "%3" == "h" ( set col_to_read=5 )
		if "!col_to_read!"=="" ( goto :BAD )
		
		call :OPEN_FILE
		call :BUBBLE
		call :PRINT_MAT
		
		goto :EXIT
	)

	goto :EXIT
)

:INTERACTIVE
	call :PRINT_HELP_INTERACTIVE
	choice /c FPSBQ

	if ERRORLEVEL 5 goto :EXIT

	rem BACKUP
	if ERRORLEVEL 4 (
		if "!file!" == "" (
			echo.
			echo FILE HAS NOT BEEN SPECIFIED
			echo.
			goto :INTERACTIVE
		)
		echo.
		call :BACKUP
		echo.
		echo !file! copied to !backup_file!
		echo.
		goto :INTERACTIVE
	)

	rem SORT_FILE
	if ERRORLEVEL 3 (
		if "!file!" == "" (
			echo.
			echo FILE HAS NOT BEEN SPECIFIED
			echo.
			goto :INTERACTIVE
		)
		:READ_COLUMN_FAIL
		set col_to_read=
		echo.
		echo Sort by:
		echo i = id [] n = name [] v = weight [] l = length [] b = width [] h = height
		echo.
		set /p input="Enter column to sort by: "
		if /i "!input!" == "i" ( set col_to_read=0 )
		if /i "!input!" == "n" ( set col_to_read=1 )
		if /i "!input!" == "v" ( set col_to_read=2 )
		if /i "!input!" == "l" ( set col_to_read=3 )
		if /i "!input!" == "b" ( set col_to_read=4 )
		if /i "!input!" == "h" ( set col_to_read=5 )
		if "!col_to_read!"=="" ( 
			echo.
			echo ERROR COLUMN !input! DOES NOT EXIST
			echo.
			goto :READ_COLUMN_FAIL 
		)
		call :OPEN_FILE
		call :BUBBLE
		echo.
		echo SORTED
		echo.
		goto :INTERACTIVE
	)
	
	rem PRINT_FILE
	if ERRORLEVEL 2 (
		if "!file!" == "" (
			echo.
			echo FILE HAS NOT BEEN SPECIFIED
			echo.
			goto :INTERACTIVE
		)
		echo.
		call :PRINT_MAT
		echo.
		goto :INTERACTIVE
	)
	
	rem OPEN_FILE
	if ERRORLEVEL 1 (
		:READ_FILE_FAIL
		echo.
		set /p file="Enter path to file: " 
		echo.
		if exist !file! (
			call :OPEN_FILE_MATRIX
			goto :INTERACTIVE
		)
		echo.
		echo ERROR: FILE !file! DOES NOT EXIST
		echo.
		goto :READ_FAIL
	)
	
:INTERACTIVE_END
	

:READ_ARGS_END

:BAD
	echo MISSING ARGUMENT, SPECIFY /? FOR HELP
	goto EXIT
:BAD_END

:BACKUP
	if %backup_file% == "" goto :EOF
	COPY "%file%" "%backup_file%" >nul
	goto :EOF
:BACKUP_END

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
	echo %header%
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
	goto :EOF
:MAKE_N_SPACE_END

:PRINT_HELP
	echo Används för logistikhantering.
	echo.
	echo Syntax : logistics [ enhet :] sökväg [^/backup ^| ^/print ^| ^/sort ^<i ^| n ^| v ^| l ^| b ^| h ^>^]
	echo.
	echo /backup     Genererar en säkerhetskopia av datafilen i samma katalog.
	echo /print      Skriver ut innehållet i datafilen.
	echo /sort       Sorterar och skriver ut innehållet i datafilen.
	echo              i efter produktnummer     n efter namn
	echo              v efter vikt              l efter längd
	echo              b efter bredd             h efter höjd
	echo:/?          Skriver ut den här hjälptexten.


	goto :EOF
:PRINT_HELP_END

:PRINT_HELP_INTERACTIVE
	echo COMMANDS:
	echo.
	echo F Select file
	echo P Print file contents
	echo S Sort file output
	echo B Create backup
	echo Q Quit
	echo H Prints help
	echo.
	goto :EOF
:PRINT_HELP_INTERACTIVE_END

:EXIT
