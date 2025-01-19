#!/usr/bin/env bash
# -----------------------------------------------------------
# Script de despliegue LOCAL y subida a Docker Hub para la aplicación Avatares.
# Utiliza Docker Buildx para construir imágenes multiplataforma.
#
# Uso:
#   ./deploy_docker.sh dev
#
# -----------------------------------------------------------

# ==================== VARIABLES DE COLORES ==================== #
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'
# ============================================================ #

# ==================== VARIABLES ==================== #
ENVIRONMENT="$1"
DOCKER_USER="chelemovil87"
BACKEND_IMAGE="$DOCKER_USER/proyectodevops-backend"
FRONTEND_IMAGE="$DOCKER_USER/proyectodevops-frontend"
TAG="v2.0"
# Multiplataforma
PLATFORMS="linux/amd64,linux/arm64"
# ==================================================== #

if [ -z "$ENVIRONMENT" ]; then
  echo -e "${RED}Error:${RESET} No se ha especificado el entorno (dev o prod)."
  echo -e "Uso: ${BOLD}./deploy_docker.sh [dev|prod]${RESET}"
  exit 1
fi

echo -e "${YELLOW}========================================${RESET}"
echo -e "${YELLOW} Despliegue Docker en entorno: ${BOLD}$ENVIRONMENT${RESET}"
echo -e "${YELLOW}========================================${RESET}"

# 1. Configurar Docker Buildx
echo -e "${BLUE}[1/5]${RESET} ${BOLD}Configurando Docker Buildx...${RESET}"
docker buildx create --use --name avatares-builder > /dev/null 2>&1 || true
docker buildx inspect avatares-builder --bootstrap

# 2. Construir imágenes multiplataforma
echo -e "${BLUE}[2/5]${RESET} ${BOLD}Construyendo imágenes multiplataforma...${RESET}"

# Construir y subir la imagen del backend
docker buildx build --platform $PLATFORMS -t $BACKEND_IMAGE:$TAG --push -f api/Dockerfile.backend api

if [ $? -ne 0 ]; then
  echo -e "${RED}ERROR:${RESET} Falló la construcción o subida de la imagen del backend."
  exit 1
fi

# Construir y subir la imagen del frontend
docker buildx build --platform $PLATFORMS -t $FRONTEND_IMAGE:$TAG --push -f web/Dockerfile.frontend web

if [ $? -ne 0 ]; then
  echo -e "${RED}ERROR:${RESET} Falló la construcción o subida de la imagen del frontend."
  exit 1
fi

echo -e "${GREEN}Imágenes construidas y subidas con éxito a Docker Hub.${RESET}"

# 3. Arrancar servicios con docker-compose
echo -e "${BLUE}[3/5]${RESET} ${BOLD}Desplegando servicios...${RESET}"

docker-compose -f docker-compose.yml up --build -d

if [ $? -ne 0 ]; then
  echo -e "${RED}ERROR:${RESET} Falló el despliegue de los servicios."
  exit 1
fi

echo -e "${GREEN}Servicios desplegados con éxito.${RESET}"

# 4. Verificar servicios en ejecución
echo -e "${BLUE}[4/5]${RESET} ${BOLD}Verificando servicios en ejecución...${RESET}"
docker-compose ps

echo -e "${YELLOW}========================================${RESET}"
echo -e "${YELLOW} Despliegue completado con éxito en entorno: ${BOLD}$ENVIRONMENT${RESET}"
echo -e "${YELLOW} Backend: http://localhost:5001${RESET}"
echo -e "${YELLOW} Frontend: http://localhost:5173${RESET}"
echo -e "${YELLOW}========================================${RESET}"

# 5. Limpiar el entorno de buildx (opcional)
echo -e "${BLUE}[5/5]${RESET} ${BOLD}Limpiando entorno de Buildx...${RESET}"
docker buildx rm avatares-builder > /dev/null 2>&1 || true

echo -e "${GREEN}Script finalizado.${RESET}"
