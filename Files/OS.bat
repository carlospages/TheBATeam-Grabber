@Echo off
Setlocal EnabledelayedExpansion

REM This OS program is created by Kvc, in order to make life easier for batch programmers,
REM As it will tell, in which OS file is running along with the OS Type...

REM Created by Kvc, at 6:10 PM , 28.2.2016
REM For more, visit: batchprogrammers.blogspot.com
REM #TheBATeam

REM Checking for various parameters of the function...
If /i "%~1" == "/?" (goto :help)
If /i "%~1" == "-h" (goto :help)
If /i "%~1" == "-help" (goto :help)
If /i "%~1" == "help" (goto :help)
If /i "%~1" == "ver" (echo.1.0&&goto :End)

REM Extracting the windows version information from the 'ver' command provided by windows...
For /f "tokens=1,2 delims=." %%A in ('ver') do (
	For /f "tokens=4" %%C in ("%%A") do (
		Set _Ver=%%C.%%B
	)
)

If /i "%_Ver%" == "5.1" (Set _OS=XP)
If /i "%_Ver%" == "6.0" (Set _OS=Vista)
If /i "%_Ver%" == "6.1" (Set _OS=7)
If /i "%_Ver%" == "6.2" (Set _OS=8)
If /i "%_Ver%" == "6.3" (Set _OS=8.1)
If /i "%_Ver%" == "10.0" (Set _OS=10)

If /i "%_OS%" == "" (Set _OS=Unknown)

IF Not Defined ProgramFiles(x86) (Set _Type=x86) ELSE (Set _Type=x64)

If /i "%~1" == "" (Echo.%_OS% %_Type%) Else (Endlocal && Set %~1=%_OS% %_Type%)
Goto :End

:End
Goto :EOF

:Help
Echo.
Echo. This function will simply display the OS type on which it is executed.
echo. It will help in making batch files little more advanced and effective.
Echo. In those cases when batch file is only meant for some particular ver.
Echo. of windows, then you can confirm the OS version via using this file.
echo.
echo. Syntax: call OS [Result]
echo. Syntax: call OS [help ^| /^? ^| -h ^| -help]
echo. Syntax: call OS ver
echo.
echo. Where:-
echo.
Echo. Result			: No need of always specifying this parameter, it is a 
Echo.			  special case parameter.In any case, if you needed the
Echo.			  output to be saved directly into this variable instead
Echo.			  of directly printing it on console.
echo.
Echo. https://batchprogrammers.blogspot.com
Echo. #TheBATeam
goto :End