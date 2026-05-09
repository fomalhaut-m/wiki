@echo off
chcp 65001 >nul
setlocal

:: 默认值（可通过位置参数覆盖）
set HOST=localhost
set PORT=6379
set DB=0
set PASSWORD=
set REQUIREPASS=

if not "%~1"=="" set HOST=%~1
if not "%~2"=="" set PORT=%~2
if not "%~3"=="" set DB=%~3
if not "%~4"=="" set PASSWORD=%~4
if not "%~5"=="" set REQUIREPASS=%~5

echo Initializing Redis at %HOST%:%PORT% db=%DB%

:: 检查 Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python 未找到，请先安装 Python。
    pause
    exit /b 1
)

:: 确保依赖
python -c "import redis" >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing redis...
    python -m pip install redis
)

:: 构造参数
set ARGS=--host %HOST% --port %PORT% --db %DB%
if not "%PASSWORD%"=="" set ARGS=%ARGS% --password %PASSWORD%
if not "%REQUIREPASS%"=="" set ARGS=%ARGS% --requirepass %REQUIREPASS%

:: 运行初始化脚本（使用绝对路径）
python "c:\work\luke\notes\软件开发\缓存\init_redis.py" %ARGS%
if %errorlevel% neq 0 (
    echo [ERROR] Redis 初始化脚本返回失败 (exit %errorlevel%).
    pause
    exit /b %errorlevel%
)

echo [OK] Redis 初始化完成.
pause
endlocal
