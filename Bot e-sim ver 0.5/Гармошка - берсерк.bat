echo off
chcp 65001
:start
curl --config config.txt
cls
FindStr /n /A:FC /C:"No health left" otvet.txt >nul 2>&1 >result.txt
if errorlevel 1 (
	FindStr /n /A:FC "totalDamageUpdate" otvet.txt 2>nul 2>&1 >result.txt
	if errorlevel 1 (
		FindStr /n /A:FC /C:"Round is closed" otvet.txt >nul 2>&1 >result.txt
		if errorlevel 1 (
			echo error
		) else (goto closed)
	) else (
		echo Дамаге нанесён
		timeout 5
		goto start
		)
) else (echo Здоровье на нуле)
timeout /t 200
goto start

:closed
cls
color 4
echo раунд закрыт