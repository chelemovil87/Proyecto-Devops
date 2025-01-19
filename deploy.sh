#!/usr/bin/env bash
# -----------------------------------------------------------
# Script de despliegue LOCAL y subida a Docker Hub para la aplicación Avatares.
# Utiliza Docker Compose para gestionar los servicios e incluye la subida de imágenes.
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
DOCKER_USER="chelemovil87" # Cambia esto por tu usuario de Docker Hub
BACKEND_IMAGE="$DOCKER_USER/proyectodevops-backend"
FRONTEND_IMAGE="$DOCKER_USER/proyectodevops-frontend"
TAG="v1.0"
# ==================================================== #

if [ -z "$ENVIRONMENT" ]; then
  echo -e "${RED}Error:${RESET} No se ha especificado el entorno (dev o prod)."
  echo -e "Uso: ${BOLD}./deploy_docker.sh [dev|prod]${RESET}"
  exit 1
fi

echo -e "${YELLOW}========================================${RESET}"
echo -e "${YELLOW} Despliegue Docker en entorno: ${BOLD}$ENVIRONMENT${RESET}"
echo -e "${YELLOW}========================================${RESET}"

# 1. Construir y etiquetar imágenes
echo -e "${BLUE}[1/4]${RESET} ${BOLD}Construyendo imágenes Docker...${RESET}"

docker-compose -f docker-compose.yml build

if [ $? -ne 0 ]; then
  echo -e "${RED}ERROR:${RESET} Falló la construcción de las imágenes."
  exit 1
fi

echo -e "${GREEN}Imágenes construidas con éxito.${RESET}"

# 2. Etiquetar imágenes para Docker Hub
echo -e "${BLUE}[2/4]${RESET} ${BOLD}Etiquetando imágenes...${RESET}"

docker tag proyectodevops-backend:latest $BACKEND_IMAGE:$TAG
docker tag proyectodevops-frontend:latest $FRONTEND_IMAGE:$TAG

echo -e "${GREEN}Imágenes etiquetadas con éxito.${RESET}"

# 3. Subir imágenes a Docker Hub
echo -e "${BLUE}[3/4]${RESET} ${BOLD}Subiendo imágenes a Docker Hub...${RESET}"

docker push $BACKEND_IMAGE:$TAG
docker push $FRONTEND_IMAGE:$TAG

if [ $? -ne 0 ]; then
  echo -e "${RED}ERROR:${RESET} Falló la subida de las imágenes a Docker Hub."
  exit 1
fi

echo -e "${GREEN}Imágenes subidas con éxito a Docker Hub.${RESET}"

# 4. Arrancar servicios con docker-compose
echo -e "${BLUE}[4/4]${RESET} ${BOLD}Desplegando servicios...${RESET}"

docker-compose -f docker-compose.yml up --build -d

if [ $? -ne 0 ]; then
  echo -e "${RED}ERROR:${RESET} Falló el despliegue de los servicios."
  exit 1
fi

echo -e "${GREEN}Servicios desplegados con éxito.${RESET}"

# 5. Verificar servicios en ejecución
echo -e "${BLUE}Verificando servicios en ejecución...${RESET}"
docker-compose ps

echo -e "${YELLOW}========================================${RESET}"
echo -e "${YELLOW} Despliegue completado con éxito en entorno: ${BOLD}$ENVIRONMENT${RESET}"
echo -e "${YELLOW} Backend: http://localhost:5001${RESET}"
echo -e "${YELLOW} Frontend: http://localhost:5173${RESET}"
echo -e "${YELLOW}========================================${RESET}"
