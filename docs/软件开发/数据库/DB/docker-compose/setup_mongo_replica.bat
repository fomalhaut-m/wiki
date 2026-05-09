@echo off
chcp 65001 > nul
REM ================================================
REM MongoDB 副本集一键配置脚本 (UTF-8编码)
REM 版本：v2.2 - 使用 initReplica.js 避免多行 JS 失败
REM ================================================

:: 初始化配置
set SERVICE_NAME=mongo_rs1
set REPLICA_SET_NAME=rs
set ADMIN_USER=admin
set ADMIN_PWD=admin
set ROOT_USER=root
set ROOT_PWD=root

title MongoDB副本集配置工具 - 正在运行...

:: 阶段1 - 环境准备
echo [1/8] 清理旧容器和网络...
docker-compose down -v >nul 2>&1
docker network rm mongo_network >nul 2>&1
timeout /t 2 /nobreak >nul

:: 阶段2 - 启动服务
echo [2/8] 启动MongoDB容器...
docker-compose up -d
if %errorlevel% neq 0 (
    echo [错误] 容器启动失败!
    docker-compose logs
    pause
    exit /b 1
)

:: 阶段3 - 等待服务就绪
echo [3/8] 等待MongoDB初始化(15秒)...
timeout /t 15 /nobreak >nul
docker-compose logs --tail=10

:: 阶段4 - 初始化副本集 (修复多行JS问题)
echo [4/8] 初始化副本集...
docker cp initReplica.js %SERVICE_NAME%:/initReplica.js
docker exec %SERVICE_NAME% mongosh /initReplica.js
if %errorlevel% neq 0 (
    echo [错误] 副本集初始化失败! 尝试强制重新配置...
    docker exec %SERVICE_NAME% mongosh --eval "rs.reconfig({_id:'%REPLICA_SET_NAME%', version:1, members:[{_id:0, host:'%SERVICE_NAME%:27017'}]}, {force:true})"
)

:: 阶段5 - 创建管理员用户
echo [5/8] 创建管理员用户...
docker exec %SERVICE_NAME% mongosh --quiet --eval "db.getSiblingDB('admin').createUser({user: '%ADMIN_USER%', pwd: '%ADMIN_PWD%', roles:[{ role: 'clusterAdmin', db: 'admin' },{ role: 'userAdminAnyDatabase', db: 'admin' }]})"

:: 阶段6 - 创建 root 用户
echo [6/8] 创建root用户...
docker exec %SERVICE_NAME% mongosh -u %ADMIN_USER% -p %ADMIN_PWD% --authenticationDatabase admin --quiet --eval "db.getSiblingDB('admin').createUser({user: '%ROOT_USER%', pwd: '%ROOT_PWD%', roles: [{ role: 'root', db: 'admin' }]})"

:: 阶段7 - 验证配置
echo [7/8] 验证副本集状态...
docker exec %SERVICE_NAME% mongosh -u %ADMIN_USER% -p %ADMIN_PWD% --authenticationDatabase admin --eval "print('=== 副本集状态 ==='); rs.status(); print('\n=== 当前节点角色 ==='); db.isMaster(); print('\n=== 用户列表 ==='); db.getSiblingDB('admin').system.users.find()"

:: 阶段8 - 输出连接信息
echo [8/8] 生成访问信息...
echo ================================================
echo [√] MongoDB副本集配置成功!
echo.
echo 连接字符串:
echo mongodb://%ADMIN_USER%:%ADMIN_PWD%@localhost:27017/?replicaSet=%REPLICA_SET_NAME%&authSource=admin
echo.
echo 管理命令:
echo 1. 查看副本集状态: docker exec %SERVICE_NAME% mongosh -u %ADMIN_USER% -p %ADMIN_PWD% --eval "rs.status()"
echo 2. 查看实时日志: docker-compose logs -f %SERVICE_NAME%
echo 3. 进入容器Shell: docker exec -it %SERVICE_NAME% bash
echo ================================================
pause
