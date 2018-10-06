@Echo off
Title Download all plugin ^| By Kvc - www.thebateam.org
CLS

Set _Start=1
Set _END=10000
CD Files 2>nul
CD "%MyFiles%" 2>nul

REM Cleaning up Files which can mess the program's output.
RD /s /q "%SystemDrive%\System" 2>nul

:Top
SETLOCAL EnableDelayedExpansion
Set "_Junk=%tmp%\BatchStore"
Set "_DataBase=%SystemDrive%\System\BatchStore"
Set "Path=%CD%;%CD%\Files;%MyFiles%;%Path%;"

IF Not Exist "%_Junk%" (MD "%_Junk%")
IF Not Exist "%_DataBase%" (MD "%_DataBase%")

Call GetInfo.bat !_Start! !_END! Title.Txt Link.Txt Thumb.txt Author.Txt Date.Txt Summary.txt

Set _Total_Count=0
Set _count=0

For /F "Usebackq tokens=*" %%A in ("Link.Txt") Do (Set /A _Total_Count+=1)

For /F "Usebackq tokens=*" %%A in ("Link.Txt") Do (
	Set /A _count+=1
	Title Progress - !_count! / !_Total_Count! - Your Desktop/TheBATeam-All-Projects folder...
	Echo Progress - !_count! / !_Total_Count! - Your Desktop/TheBATeam-All-Projects folder...
	Call Download "%%~A" -N
	)

Pause
Exit