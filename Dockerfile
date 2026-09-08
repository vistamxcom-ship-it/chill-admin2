FROM node:18-alpine

WORKDIR /app

# Copiar package.json
COPY package.json .

# Instalar dependencias
RUN npm ci --only=production

# Copiar archivos
COPY admin-optimizado.html .
COPY 01_SCHEMA_SUPABASE.sql .
COPY server.js .

# Variables de entorno
ENV NODE_ENV=production
ENV PORT=3000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/api/health', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Exponer puerto
EXPOSE 3000

# Ejecutar server
CMD ["node", "server.js"]
