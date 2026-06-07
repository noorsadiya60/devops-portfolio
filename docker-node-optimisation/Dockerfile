FROM node:18.20-alpine3.20
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev
COPY . .

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN chown -R appuser:appgroup /app
USER appuser

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3000/ || exit 1
    
EXPOSE 3000
CMD ["node", "app.js"]
