# Configuración de VirusTotal para GitHub Actions

Este documento explica cómo configurar el análisis automático de VirusTotal para tus builds.

## 📋 Requisitos Previos

1. **Cuenta de VirusTotal**: Necesitas una cuenta en [VirusTotal](https://www.virustotal.com/)
2. **API Key de VirusTotal**: Obtén tu clave API desde tu perfil de VirusTotal

## 🔑 Paso 1: Obtener tu API Key de VirusTotal

1. Ve a [VirusTotal](https://www.virustotal.com/)
2. Inicia sesión o crea una cuenta gratuita
3. Ve a tu perfil (arriba a la derecha)
4. Busca la sección "API Key"
5. Copia tu clave API

## 🔐 Paso 2: Agregar la API Key a GitHub Secrets

1. Ve a tu repositorio en GitHub: `https://github.com/LeninAsto/FNF-PlusEngine`
2. Haz clic en **Settings** (Configuración)
3. En el menú lateral, haz clic en **Secrets and variables** → **Actions**
4. Haz clic en **New repository secret**
5. Nombre del secret: `VIRUSTOTAL_API_KEY`
6. Valor: Pega tu API Key de VirusTotal
7. Haz clic en **Add secret**

## ✅ Paso 3: Verificar la Configuración

Una vez que hayas agregado el secret:

1. Haz un commit y push de los archivos que acabo de crear
2. El workflow se ejecutará automáticamente cuando:
   - Publiques un release
   - Ejecutes manualmente el workflow desde la pestaña "Actions"
   - Hagas push a la rama main (si hay cambios en export/release/)

## 🎯 Cómo Funciona

### Workflow Creado

Se creó el archivo `.github/workflows/virustotal.yml` que:

1. **Descarga los builds** compilados de Windows y Android
2. **Escanea con VirusTotal** ambos archivos
3. **Genera reportes** automáticamente

### Badges en el README

Se agregaron al README.md:

```markdown
[![VirusTotal Scan](https://github.com/LeninAsto/FNF-PlusEngine/actions/workflows/virustotal.yml/badge.svg)](https://github.com/LeninAsto/FNF-PlusEngine/actions/workflows/virustotal.yml)
![Security](https://img.shields.io/badge/security-scanned-brightgreen?logo=virustotal)
```

- **Primera badge**: Muestra el estado del workflow de VirusTotal
- **Segunda badge**: Indica que el proyecto está escaneado

## 🚀 Ejecutar Manualmente el Scan

1. Ve a la pestaña **Actions** en GitHub
2. Selecciona el workflow **VirusTotal Scan**
3. Haz clic en **Run workflow**
4. Selecciona la rama `main`
5. Haz clic en **Run workflow**

## 📊 Ver Resultados

Los resultados del escaneo se mostrarán en:

1. **GitHub Actions**: En los logs del workflow
2. **VirusTotal**: En tu cuenta de VirusTotal (en el historial de archivos escaneados)

## 🔄 Limitaciones de la API Gratuita

La API gratuita de VirusTotal tiene estas limitaciones:

- **4 solicitudes por minuto**
- **500 solicitudes por día**
- **178,000 solicitudes por mes**

Para proyectos grandes, considera:
- Escanear solo en releases (no en cada push)
- Usar la API premium si necesitas más requests

## 🎨 Personalización de Badges

Puedes personalizar las badges con diferentes estilos:

```markdown
<!-- Estilo flat -->
![Security](https://img.shields.io/badge/security-scanned-brightgreen?style=flat&logo=virustotal)

<!-- Estilo flat-square -->
![Security](https://img.shields.io/badge/security-scanned-brightgreen?style=flat-square&logo=virustotal)

<!-- Estilo for-the-badge -->
![Security](https://img.shields.io/badge/security-scanned-brightgreen?style=for-the-badge&logo=virustotal)

<!-- Con más información -->
![Security](https://img.shields.io/badge/VirusTotal-0%20threats-success?logo=virustotal)
```

## 🛠️ Troubleshooting

### Error: "VIRUSTOTAL_API_KEY not found"
- Verifica que agregaste el secret correctamente
- El nombre debe ser exactamente: `VIRUSTOTAL_API_KEY`

### Error: "Rate limit exceeded"
- Esperaste poco tiempo entre scans
- La API gratuita tiene límite de 4 requests/minuto

### Error: "Artifact not found"
- Asegúrate de que el workflow `main.yml` se haya ejecutado primero
- Los artifacts deben existir para poder escanearlos

## 📝 Notas Adicionales

- Los scans de VirusTotal son públicos
- Los archivos escaneados quedan en el historial de VirusTotal
- Los resultados pueden tardar varios minutos en completarse
- Algunos antivirus pueden dar falsos positivos con builds de HaxeFlixel

## 🔗 Recursos Útiles

- [VirusTotal API Documentation](https://developers.virustotal.com/reference/overview)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [crazy-max/ghaction-virustotal](https://github.com/crazy-max/ghaction-virustotal)

---

✅ **Una vez configurado**, tus builds serán automáticamente escaneados y las badges mostrarán el estado de seguridad en el README.
