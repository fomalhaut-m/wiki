# Docker 快速上手

> 来源：个人笔记整理 | 标签：运维 / Docker

---

## 核心概念

| 概念 | 说明 |
|------|------|
| **Image** | 镜像，模板，只读 |
| **Container** | 容器，镜像的运行实例 |
| **Volume** | 数据卷，持久化数据 |
| **Dockerfile** | 构建镜像的脚本 |

---

## 常用命令

```bash
# 镜像
docker pull nginx:latest
docker images
docker rmi image_name

# 容器
docker run -d -p 8080:80 --name mynginx nginx
docker ps
docker stop mynginx
docker rm mynginx

# 进入容器
docker exec -it mynginx /bin/bash

# 日志
docker logs -f mynginx

# 构建
docker build -t myapp:1.0 .
```

---

## docker-compose

```yaml
version: '3'
services:
  web:
    image: nginx
    ports:
      - "80:80"
    volumes:
      - ./html:/usr/share/nginx/html
  db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: secret
    volumes:
      - db_data:/var/lib/mysql
volumes:
  db_data:
```

```bash
docker-compose up -d
docker-compose down
docker-compose ps
docker-compose logs -f
```

---

## MongoDB Replica Set 示例

```yaml
services:
  master:
    image: mongo:5.0.13
    container_name: mongo_rs1
    hostname: mongo_rs1
    restart: unless-stopped
    ports:
      - "27017:27017"
    volumes:
      - ./data/db:/data/db
    command: mongod --replSet rs --bind_ip_all
    healthcheck:
      test: mongosh --eval "db.adminCommand('ping')"
      interval: 10s
      timeout: 5s
      retries: 3
networks:
  default:
    name: mongo_network
    driver: bridge
```

---

## Dockerfile 示例

```dockerfile
FROM openjdk:11-jre-slim
COPY target/app.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
```

---

## 注意事项

1. **数据持久化** — 使用Volume挂载数据目录
2. **端口映射** — 宿主机端口不要冲突
3. **网络** — 创建自定义网络实现容器互联
4. **资源限制** — 生产环境设置CPU/内存限制
