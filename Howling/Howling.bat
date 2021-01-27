chcp 65001
echo off
cls
echo.
echo.
echo  ██░ ██  ▒█████   █     █░ ██▓     ██▓ ███▄    █   ▄████ 
echo ▓██░ ██▒▒██▒  ██▒▓█░ █ ░█░▓██▒    ▓██▒ ██ ▀█   █  ██▒ ▀ ▒
echo ▒██████░▒██░  ██▒▒█░ █ ░█ ▒██░    ▒██▒▓██  ▀█ ██▒▒██░▄▄▄░
echo ░▓█ ░██ ▒██   ██░░█░ █ ░█ ▒██░    ░██░▓██▒  ▐▌██▒░▓█  ██▓
echo ░▓█▒░██▓░ ████▓▒░░░██▒██▓ ░██████▒░██░▒██░   ▓██░░▒▓███▀▒
echo ▒ ░░▒░▒░ ▒░▒░▒░ ░ ▓░▒ ▒  ░ ▒░▓  ░░▓  ░ ▒░   ▒ ▒  ░▒   ▒ 
echo ▒ ░▒░ ░  ░ ▒ ▒░   ▒ ░ ░  ░ ░ ▒  ░ ▒ ░░ ░░   ░ ▒░  ░   ░ 
echo ░  ░░ ░░ ░ ░ ▒    ░   ░    ░ ░    ▒ ░   ░   ░ ░ ░ ░   ░ 
echo ░  ░  ░    ░ ░      ░        ░  ░ ░           ░       ░ 
echo.
echo                                       	For angel players 
echo.
set /P temppause="Для начала атаки нажмите Eenter"
echo off
chcp 65001
cls

::Авторизация
curl -g https://zuna.e-sim.org/login.html --cookie-jar cookie.txt
For /F "tokens=7" %%i In (cookie.txt) Do Set cookie=%%i
@echo %cookie%
curl -H "Cookie: JSESSIONID=%cookie%" -d "login=Arry&password=FHN9SVeid8MknGi&facebookAdId=" https://zuna.e-sim.org/login.html --cookie-jar cookie.txt
For /F "tokens=7" %%i In (cookie.txt) Do Set cookiemd=%%i
@echo %cookiemd%
curl -H "Cookie: JSESSIONID=%cookie%" -H "Cookie: md5=%cookiemd%" -d "login=Arry&password=FHN9SVeid8MknGi&facebookAdId=" https://zuna.e-sim.org/login.html --cookie-jar cookie2.txt

::Получение id битвы
:UpdataID
curl --config config.txt -G  --header "Cookie: JSESSIONID=%cookie%"
FindStr /n /c:"		value=" otvet.txt >result.txt
SetLocal EnableExtensions
For /F "tokens=2" %%s in (result.txt) do set var=%%s
echo %var:~7,-1% > battleRoundId.txt
set var =
For /F "tokens=*" %%i In (battleRoundId.txt) Do Set battleRoundId=%%i
@echo %battleRoundId%

::Сам бот
set = weaponQuality
:start
curl --config config.txt -d "weaponQuality=5&battleRoundId=%battleRoundId%&side=side&value=Berserk" https://zuna.e-sim.org/fight.html --output "otvet.txt" --header "Cookie: JSESSIONID=%cookie%"
cls
FindStr /n /C:"No health left" otvet.txt >nul 2>&1 >result.txt
if errorlevel 1 (
	FindStr /n /A:FC "totalDamage" otvet.txt 2>nul 2>&1 >result.txt
	if errorlevel 1 (
		FindStr /n /C:"from your current localization" otvet.txt 2>nul 2>&1 >result.txt
		if errorlevel 1 (
			FindStr /n /C:"Round is closed" otvet.txt 2>nul 2>&1 >result.txt
			if errorlevel 1 (
				FindStr /n /C:"No weapon in storage" otvet.txt 2>nul 2>&1 >result.txt
				if errorlevel 1 (
				echo Поле битвы не найдено\ошибка авторизации\критическая ошибка\отвал прокси
				Pause
				) else (
				echo оружие кончилось
				pause
					)
			
			) else (goto RoundClose)
		) else (echo вы находитесь не в той стране)
	) else (goto damage)
) else (echo Здоровье на нуле)
timeout /t 200
goto start


:damage
echo Дамаге нанесён!
timeout 5
goto start

:RoundClose
echo Раунд закончен.
timeout 10
goto UpdataID
Pause