@echo off
chcp 65001 >nul
setlocal

:: 默认值（可通过位置参数覆盖）
set HOST=localhost
set PORT=5672
set USERNAME=guest
set PASSWORD=guest
set VHOST=/

if not "%~1"=="" set HOST=%~1
if not "%~2"=="" set PORT=%~2
if not "%~3"=="" set USERNAME=%~3
if not "%~4"=="" set PASSWORD=%~4
if not "%~5"=="" set VHOST=%~5

echo Initializing RabbitMQ at %HOST%:%PORT% vhost="%VHOST%" user="%USERNAME%"

:: 检查 Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python 未找到，请先安装 Python。
    pause
    exit /b 1
)

:: 确保依赖
python -c "import requests" >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing requests...
    python -m pip install requests
)

python -c "import pika" >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing pika...
    python -m pip install pika
)

:: 运行初始化脚本（使用绝对路径）
python "c:\work\luke\notes\软件开发\消息队列\init_rabbitmq.py" --host %HOST% --port %PORT% --username %USERNAME% --password %PASSWORD% --vhost "%VHOST%"
if %errorlevel% neq 0 (
    echo [ERROR] RabbitMQ 初始化脚本返回失败 (exit %errorlevel%).
    pause
    exit /b %errorlevel%
)

echo [OK] RabbitMQ 初始化完成.
pause
endlocal
