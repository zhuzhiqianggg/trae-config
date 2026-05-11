---
name: ops-docker-essentials
description: Essential Docker commands and workflows for container management, image operations, and debugging. Use when running containers, building images, managing Docker Compose, debugging containers, or cleaning up Docker resources.
tags: [docker, containers, devops, containerization, compose]
---

# Docker Essentials

Essential Docker commands for container and image management.

## Container Lifecycle

### Running Containers
```bash
docker run -d --name my-nginx -p 8080:80 nginx
docker run -it --rm ubuntu bash
docker run -e MY_VAR=value -v /host/path:/container/path -d app
```

### Managing Containers
```bash
docker ps -a                              # list all containers
docker stop/start/restart <container>     # lifecycle
docker rm -f <container>                  # force remove
docker container prune                    # remove all stopped
```

## Container Inspection

```bash
docker logs --tail 100 -f <container>     # follow logs
docker exec -it <container> bash          # interactive shell
docker exec -u root <container> <cmd>     # as specific user
docker inspect <container>                # full details
docker stats <container>                  # live resource usage
docker top <container>                    # processes inside
```

## Image Management

```bash
docker build -t myapp:1.0 .               # build from Dockerfile
docker build --no-cache -t myapp .        # rebuild without cache
docker pull nginx:alpine                  # pull from registry
docker tag myapp:1.0 myapp:latest         # tag
docker push myrepo/myapp:1.0              # push
docker image prune -a                     # remove unused
```

## Docker Compose

```bash
docker compose up -d                      # start in background
docker compose down -v                    # stop + remove volumes
docker compose logs -f web                # follow service logs
docker compose exec web bash              # exec in service
docker compose up -d --build              # rebuild and restart
docker compose up -d --scale web=3        # scale service
```

## Multi-Stage Build

```dockerfile
FROM node:20 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
```

## Useful Patterns

```bash
# Dev container
docker run -it --rm -v $(pwd):/app -w /app -p 3000:3000 node:20 npm run dev

# Database
docker run -d --name pg -e POSTGRES_PASSWORD=secret -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:16

# Debug
docker cp <container>:/path/to/file ./local/
docker cp ./local/file <container>:/path/
```

## Best Practices

- Use `.dockerignore` to exclude files from build context
- Combine `RUN` commands to reduce layers
- Multi-stage builds to minimize image size
- Pin image tags with versions (never `:latest`)
- Use `--rm` for one-off containers
- Set resource limits: `--memory="512m" --cpus="0.5"`
- Run as non-root: `USER` in Dockerfile + `runAsNonRoot`
- Regular cleanup: `docker system prune -af --filter "until=24h"`

## Verification

- [ ] `docker system df` shows manageable disk usage
- [ ] Images use specific version tags, not `:latest`
- [ ] Multi-stage build produces minimal final image
- [ ] Containers have resource limits and health checks
- [ ] `.dockerignore` excludes `node_modules`, `.git`, etc.
