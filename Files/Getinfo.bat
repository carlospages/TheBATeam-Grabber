@Echo off
Title Batch Archive's Data Collector!
SetLocal ENableDelayedExpansion
cls

REM Checking important files...
FOR %%A In (batbox.exe wget.exe xidel.exe) DO (IF Not Exist "%%A" (Echo. Download Function, Error... File [%%A] is Missing...))
Set _Ver=1.0

Rem Created by Kvc, for the purpose of 'BatchStore'...
REM Get more plugins / functions like this at www.thebateam.org

rem #TheBATeam

If /i "%~1" == "" (goto :End)
If /i "%~1" == "ver" (echo.%_Ver%&&goto :eof)

If /i "%~2" == "" (goto :End)
If /i "%~3" == "" (goto :End)
If /i "%~4" == "" (goto :End)
If /i "%~5" == "" (goto :End)
If /i "%~6" == "" (goto :End)
If /i "%~7" == "" (goto :End)


REM Settings...
Set "_Junk=%tmp%\BatchStore"
Set "_DataBase=%SystemDrive%\System\BatchStore"
Set "Path=%CD%;%Path%;%_Junk%;"
Set _Quite=F

REM Confirming the required loacations on Disk...
IF Not Exist "%_Junk%" (MD "%_Junk%")
IF Not Exist "%_DataBase%" (MD "%_DataBase%")

:Main
Pushd "%_Junk%"

REM Clearing all pre-existing files...
Del /q * >nul 2>nul

Set _Count=1
Set "_Start_Index=%~1"
Set "_End_Index=%~2"
Set "_Titles=%~3"
Set "_Links=%~4"
Set "_Thumbs=%~5"
Set "_Author=%~6"
Set "_Date=%~7"
Set "_Summary=%~8"
IF /I "%~9" == "/q" (Set _Quite=T)

SET /A _Diffrence=!_End_Index!-!_Start_Index!+1

IF /i "!_Quite!" == "F" (Batbox /c 0x0e /d "Establishing Secure Connection..." /c 0x0a&Echo.)
wget.exe "http://www.thebateam.org/feeds/posts/summary?start-index=!_Start_Index!&max-results=!_Diffrence!" -O "Summary.XML" -q
IF /I "%Errorlevel%" NEQ "0" (Batbox /c 0x0c /d "Error in Connection!" /c 0x07&&Pause>nul&&Exit)
Set "_XML_Doc=Summary.XML"

REM Fail Safe Mechanism!
If /I "!_XML_Doc!" == "" (Batbox /c 0x0c /d "Error in Connection!" /c 0x07&&Goto :End)
If Not Exist summary.xml (Batbox /c 0x0c /d "Error in Connection!" /c 0x07&&Goto :End)

REM Converting things to CSV...
XmlToCsv.Console -xml "!_XML_Doc!" -dir "%_Junk%"

IF /i "!_Quite!" == "F" (Batbox /c 0x0e /d "Fetching Thumbnail Images...")
REM Fetching Article Thumbnails!
For /F "Skip=1 Tokens=1,2,3,4 delims=," %%A In ('type "thumbnail.csv"') Do (Echo.%%A>>"_TmpThumbs.Txt")
IF /i "!_Quite!" == "F" (Batbox /c 0x0a /d "[Done]" &Echo.)

IF /i "!_Quite!" == "F" (Batbox /c 0x0e /d "Fetching Published Date...")
For /F "Skip=1 Tokens=1,2,3,4,5,6 delims=," %%A In ('type "entry.csv"') Do (
	Set "_TmpString=%%~C"
	Echo."!_TmpString:~0,10!">>"_TmpDate.Txt"
	)
IF /i "!_Quite!" == "F" (Batbox /c 0x0a /d "[Done]" &Echo.)

IF /i "!_Quite!" == "F" (Batbox /c 0x0e /d "Fetching Author Details...")
For /F "Skip=2 Tokens=1,2,3,4,5,6 delims=," %%A In ('type "author.csv"') Do (Echo.%%A>>"_TmpAuthor.Txt")
IF /i "!_Quite!" == "F" (Batbox /c 0x0a /d "[Done]" &Echo.)

IF /i "!_Quite!" == "F" (Batbox /c 0x0e /d "Fetching Titles & Links...")
REM Fetching Article titles... And, Links to them!
Find /I "alternate" "Link.CSV">"_Extract.CSV"
For /F "Skip=3 Tokens=1,2,3,4,5,6 delims=," %%A In (_Extract.CSV) Do (
	Echo.%%C>>"_TmpLinks.Txt"
	Echo.%%D>>"_TmpTitles.Txt"
	)

IF /i "!_Quite!" == "F" (Batbox /c 0x0e /d "Reading Summary...")
REM Fetching Summary Text!
Set _Read=N
For /F "Skip=1 Tokens=*" %%A In ('type "Summary.CSV"') Do (
	IF /I "!_Read!" == "Y" (
		Echo."%%A">>"_TmpSummary.Txt"
		Set _Read=N
		)
	
	Set "_TMPVAR=%%A"
	Set _TMPVAR=!_TMPVAR:"=!
	Set _TMPVAR=!_TMPVAR:,=!
	IF /I "!_TMPVAR!" == "text" (Set _Read=Y)
	)

IF /i "!_Quite!" == "F" (Batbox /c 0x0a /d "[Done]" &Echo.&Batbox /c 0x0e /d "Wrapping Up Things...")
Popd
Copy /y "%_Junk%\_TmpTitles.Txt" "!_Titles!" 1>nul
Copy /y "%_Junk%\_TmpLinks.Txt" "!_Links!" 1>nul
Copy /y "%_Junk%\_TmpThumbs.Txt" "!_Thumbs!" 1>nul
Copy /y "%_Junk%\_TmpDate.Txt" "!_Date!" 1>nul
Copy /y "%_Junk%\_TmpAuthor.Txt" "!_Author!" 1>nul
Copy /y "%_Junk%\_TmpSummary.Txt" "!_Summary!" 1>nul

IF /i "!_Quite!" == "F" (Batbox /c 0x0a /d "[Done]" &Echo.&Batbox /c 0x07)

:End
Goto :eof