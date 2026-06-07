# Week 1 — Docker

## What I built
- Optimised Dockerfile for a Node.js Express application
- Multi-container setup with Docker Compose

## Image optimisation results
| Version | Change | Size |
|---------|--------|------|
| v1 | Original node:18 base | 1.57GB |
| alpine | Switched to node:18-alpine | 187MB |
| secure | Added non-root user | 192MB |
| final | Added HEALTHCHECK | 194MB |

## Security scanning
- Tool: Trivy
- CRITICAL vulnerabilities: 0
- HIGH vulnerabilities: 4 (musl in alpine3.19, no fix without introducing new CRITICAL)

## Key decisions made
1. Layer caching — copy package.json before app code so npm install is cached
2. Alpine base image — reduces size by 87%
3. Non-root user — limits blast radius if container is compromised
4. HEALTHCHECK — allows Docker and Kubernetes to detect unhealthy containers
5. .dockerignore — prevents node_modules being copied into image

## How to run
docker build -t devopsapp:final .
docker run -p 3000:3000 devopsapp:final

## How to run with Docker Compose
docker compose up
- App: localhost:3000
- MongoExpress UI: localhost:8081
