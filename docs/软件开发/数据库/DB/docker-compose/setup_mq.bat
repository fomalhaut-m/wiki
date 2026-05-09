@echo off
docker run -d --name my-rabbitmq -p 5672:5672 -p 15672:15672 -v C:\docker\rabbitmq\data:/var/lib/rabbitmq --hostname my-rabbitmq-host -e RABBITMQ_DEFAULT_VHOST=/ -e RABBITMQ_DEFAULT_USER=guest -e RABBITMQ_DEFAULT_PASS=guest --restart=always rabbitmq:3-management
pause