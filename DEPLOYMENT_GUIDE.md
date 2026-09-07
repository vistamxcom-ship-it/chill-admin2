# 🚀 GUÍA DE DEPLOYMENT - CASHAZO ADMIN

## ✅ ¿Qué se optimizó?

| Métrica | Antes | Después |
|---------|-------|---------|
| Ancho de banda/mes | 20GB | ~2GB |
| Polling pullFromServer | 15s | 120s |
| Polling loadRedes | 20s | 300s |
| Costo | $$$$ | $0 |

---

## 📋 PASO 1: Preparar el Proyecto

### 1.1 Crear carpeta y clonar archivos
```bash
mkdir cashazo-admin
cd cashazo-admin
# Copiar todos los archivos aquí (admin-optimizado.html, server.js, etc.)
```

### 1.2 Instalar dependencias locales
```bash
npm install
```

### 1.3 Crear archivo `.env`
```
SUPABASE_URL=https://heljnwezenhdaxjcevti.supabase.co
SUPABASE_KEY=sb_publishable_JEl1Zq6hs0sbGQ32Y1uzaA_7Px1gXkq
PORT=3000
NODE_ENV=production
```

### 1.4 Probar localmente
```bash
npm start
# Ir a http://localhost:3000
```

---

## 🌐 PASO 2: Desplegar Frontend en Vercel (5 minutos)

### 2.1 Crear cuenta Vercel
1. Ir a https://vercel.com
2. Registrarse con GitHub (recomendado) o email
3. Crear nueva app

### 2.2 Conectar repositorio
1. Click en "New Project"
2. Importar repositorio de GitHub (o crear uno vacío)
3. Configurar:
   - **Framework Preset:** `Other`
   - **Root Directory:** `.`
   - **Build Command:** `echo 'Static build'`
   - **Output Directory:** `.`

### 2.3 Desplegar
1. Click "Deploy"
2. Esperar ~2 minutos
3. **Tu URL Vercel:** `cashazo-admin-xxxxx.vercel.app`

✅ **Frontend LISTO en Vercel**

---

## ⚙️ PASO 3: Desplegar Backend en Fly.io (10 minutos)

### 3.1 Instalar Fly CLI
```bash
# macOS
brew install flyctl

# Linux
curl -L https://fly.io/install.sh | sh

# Windows
iwr https://fly.io/install.ps1 -useb | iex
```

### 3.2 Login en Fly.io
```bash
flyctl auth login
# Abre navegador, crea cuenta gratis
```

### 3.3 Crear app en Fly.io
```bash
flyctl launch
```

Se te pedirá:
- **App name:** `cashazo-admin` (o el que quieras)
- **Region:** `sjc` o `iad` (lo que sea más cercano)
- **Postgres?** → `No`
- **Redis?** → `No`

### 3.4 Configurar variables de entorno
```bash
flyctl secrets set SUPABASE_URL="https://heljnwezenhdaxjcevti.supabase.co"
flyctl secrets set SUPABASE_KEY="sb_publishable_JEl1Zq6hs0sbGQ32Y1uzaA_7Px1gXkq"
flyctl secrets set NODE_ENV="production"
```

### 3.5 Desplegar
```bash
flyctl deploy
```

Esperar ~3-5 minutos...

✅ **Tu URL Fly.io:** `cashazo-admin.fly.dev`

---

## 🔗 PASO 4: Conectar Frontend ↔ Backend

### Opción A: Modificar admin-optimizado.html
En el HTML, cambiar:
```javascript
// ANTES:
const serverUrl = 'http://localhost:3000';

// DESPUÉS:
const serverUrl = 'https://cashazo-admin.fly.dev';
```

O si está dinámico, dejar que detecte automáticamente.

### Opción B: Variable de entorno en Vercel
1. En Vercel dashboard
2. Ir a Settings → Environment Variables
3. Agregar:
```
NEXT_PUBLIC_API_URL = https://cashazo-admin.fly.dev
```

---

## 🎉 RESULTADO FINAL

| Servicio | URL | Estado |
|----------|-----|--------|
| Frontend | `cashazo-admin-xxxxx.vercel.app` | 🟢 Activo |
| Backend API | `cashazo-admin.fly.dev` | 🟢 Activo |
| Base de datos | Supabase | 🟢 Conectada |

**Acceso desde CUALQUIER dispositivo:**
```
https://cashazo-admin-xxxxx.vercel.app
```

---

## 📊 Monitoreo

### Verificar status backend
```bash
flyctl status
flyctl logs
```

### Verificar consumo Vercel
Dashboard.vercel.com → Project → Analytics

### Verificar base de datos
Dashboard.supabase.com → tu_proyecto → Storage

---

## 🚨 Si algo falla

### Error: "Cannot connect to database"
- Verificar SUPABASE_URL y SUPABASE_KEY en Fly.io
- Ejecutar: `flyctl secrets list`

### Error: "Frontend cannot reach backend"
- Verificar que `cashazo-admin.fly.dev` responde: https://cashazo-admin.fly.dev/api/health
- En HTML, asegurarse que la URL sea correcta

### Error: "Out of memory on Fly.io"
- Aumentar shared-cpu-2x:
  ```bash
  flyctl scale vm shared-cpu-2x
  ```

---

## 💡 Tips

1. **Datos persisten:** Supabase guarda todo entre sesiones
2. **Múltiples usuarios:** Varios dispositivos ven cambios en vivo (cada 2 min)
3. **Sin límite ancho de banda:** Vercel + Fly.io = gratis para siempre
4. **Escalable:** Si crece, solo aumenta máquina en Fly.io ($5/mes)

---

## ✅ Checklist Final

- [ ] Crear cuenta Vercel
- [ ] Crear cuenta Fly.io
- [ ] Desplegar frontend en Vercel
- [ ] Desplegar backend en Fly.io
- [ ] Verificar `/api/health` en Fly.io
- [ ] Acceder desde https://cashazo-admin-xxxxx.vercel.app
- [ ] Probar desde múltiples dispositivos
- [ ] Verificar que guarda datos en Supabase

---

## 📞 Soporte

Si algo no funciona:
1. Verificar `flyctl logs`
2. Verificar `flyctl status`
3. Revisar que SUPABASE_URL y SUPABASE_KEY sean correctas
4. Comprobar que Dockerfile existe

¡Listo! 🚀
