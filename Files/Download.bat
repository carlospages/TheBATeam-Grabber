@Echo off
SetLocal ENableDelayedExpansion
cls

REM Checking important files...
FOR %%A In (batbox.exe wget.exe xidel.exe) DO (IF Not Exist "%%A" (Echo. Download Function, Error... File [%%A] is Missing...))
Set _Ver=1.0

REM This Utility is created by Kvc - And, it Helps in Direct Downloading the Files From 
REM The Official Batch Programming Blog - www.thebateam.org

rem #kvc

rem Visit https://batchprogrammers.blogspot.com for more extensions / plug-ins like this.... :]
rem #TheBATeam

If /i "%~1" == "" (goto :help)
If /i "%~1" == "/?" (goto :help)
If /i "%~1" == "-h" (goto :help)
If /i "%~1" == "help" (goto :help)
If /i "%~1" == "-help" (goto :help)

If /i "%~1" == "ver" (echo.%_Ver%&&goto :eof)

REM Settings...
Set "_Junk=%tmp%\BatchStore"
Set "_DataBase=%SystemDrive%\System\BatchStore"
Set "Path=%CD%;%Path%;%_Junk%;"

REM Confirming the required loacations on Disk...
IF Not Exist "%_Junk%" (MD "%_Junk%")
IF Not Exist "%_DataBase%" (MD "%_DataBase%")

:Main
Set _Count=1
Set "_Link=%~1"

Pushd "%_Junk%"

Batbox /c 0x0e /d "Reading Link & Page..." /c 0x07&Echo.
Call :ExtractFileName "%_Link%" _FileName

REM Fetching mediafire Link...
REM Checking, If Already in previous Database...
If Not Exist "%_DataBase%\%_FileName%" (
	wget -F "%_Link%" -O "%_FileName%"
	Copy /y "%_FileName%" "%_DataBase%" 1>nul
	Set "_HTML_DOC=%_FileName%"
	) ELSE (Set "_HTML_DOC=%_DataBase%\%_FileName%")

xidel "%_HTML_DOC%" -e //a/@href | find /i "mediafire" >"MediaFireLink.txt"

REM Fail Safe Mechanism...
Set /P _Media_Fire_Link=<"MediaFireLink.Txt"
IF /I "!_Media_Fire_Link!" == "" (Batbox /c 0x0c /d "No Download is Given WIth This Article! Try to Read it for info." /c 0x07&Timeout /t 10 & Goto :EOF)

For /f "tokens=*" %%A in (MediaFireLink.txt) Do (
Set "_Media_Fire_Link=%%A"

REM Fetching the main server link...from the media-fire Download Page...
REM Checking, If Already in previous Database...
Batbox /c 0x0a /d "[Done]"&echo.&Batbox /c 0x0e /d "Contacting Server Page..." /c 0x07&Echo.
If Not Exist "!_DataBase!\!_FileName!_!_Count!.bat" (
	REM Clearing all pre-existing files...
	Del /q * >nul 2>nul

	wget -F "!_Media_Fire_Link!" -O "DownloadPage.html"
	Set "_Server_DOC=DownloadPage.html"

	xidel "!_Server_DOC!" -e "<A class='DownloadButtonAd-startDownload gbtnSecondary'>{_Server_Link:=@href}</A>*" --output-format^=cmd >"Var.bat"
	call "Var.bat"
	Copy /y "Var.bat" "!_DataBase!\!_FileName!_!_Count!.bat" 1>nul
	) ELSE (Call "!_DataBase!\!_FileName!_!_Count!.bat")

REM Fail Safe Mechanism!
IF /I "!_Server_Link!" == "" (Batbox /c 0x0c /d "Can't Download File - No Main Server Link Found!" /c 0x07&Echo.&& Goto :EOF)


REM Clearing all pre-existing files...
Del /q * >nul 2>nul

Batbox /c 0x0a 
wget "!_Server_Link!"
For /f "tokens=*" %%A in ('Dir /b * ') Do Set "_File=%%A"
Batbox /c 0x07

If /I "%~2" NEQ "-N" (
	FOR /F "tokens=*" %%A In ('Savefiledialog "Select Destination For Downloaded Batch Files" "!_File!" "All Files"') DO (Set "_Destination=%%A")
	) ELSE (
	Set "_Destination=%UserProfile%\Desktop\TheBATeam-ALL-Projects"
	IF Not Exist "!_Destination!" (MD "!_Destination!")
	)

IF /I "!_Destination!" NEQ "" (Copy /y "!_File!" "!_Destination!" 1>nul)

Set /A _Count+=1
)

Popd
Goto :EOF



:ExtractFileName [%~1: _Link] [%~2: _Name]
Set _Counter=1
Set "_Linker=%~1"

:ExtractFileName_Loop
IF /I "%_Linker%" NEQ "" (
	IF /I "!_Linker:~-%_Counter%,1!" == "/" (
		Set /A _Counter-=1
		Set "_Name=!_Linker:~-%_Counter%!"
		Goto :ExtractFileName_Next
		)
	Set /A _Counter+=1
	Goto :ExtractFileName_Loop
	)
:ExtractFileName_Next
Set "%~2=%_Name:/=%"
Goto :EOF

:help
Echo.
Echo. This function helps in Direct Downloading the files From the Official Batch
echo. Programming Blog - www.thebateam.org
Echo.
Echo. It is created by Kvc - for the purpose of serving in the BatchStore Batch-app
Echo. Which helps - you in keeping things simpler & easy without visiting the blog.
Echo.
echo.
echo. Syntax: call Download [Link] [Destination]
echo. Syntax: call Download [help ^| /^? ^| -h ^| -help]
echo. Syntax: call Download ver
echo.
echo. Where:-
Echo. Link 			= Link to the article on Blog.
Echo. Destination	= Location to save the Downloaded file on Disk.
Echo.
echo. Created By 'Kvc' aka "Karanveer Chouhan"
echo. Visit www.thebateam.org for more...
echo. #TheBATeam
goto :eof
