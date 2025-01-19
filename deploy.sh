#!/usr/bin/env bash
# -----------------------------------------------------------
# Script de despliegue LOCAL en Docker para la aplicación Avatares.
# Utilizamdo Docker Compose para gestionar los servicios.
#
# Uso:
#   ./deploy.sh dev
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

ENVIRONMENT="$1"

if [ -z "$ENVIRONMENT" ]; then
  echo -e "${RED}Error:${RESET} No se ha especificado el entorno (dev o prod)."
  echo -e "Uso: ${BOLD}./deploy_docker.sh [dev|prod]${RESET}"
  exit 1
fi

echo -e "${YELLOW}========================================${RESET}"
echo -e "${YELLOW} Despliegue Docker en entorno: ${BOLD}$ENVIRONMENT${RESET}"
echo -e "${YELLOW}========================================${RESET}"

# 1. Construir y arrancar los servicios con docker-compose
echo -e "${BLUE}[1/2]${RESET} ${BOLD}Construyendo y desplegando servicios...${RESET}"

docker-compose -f docker-compose.yml up --build -d

if [ $? -ne 0 ]; then
  echo -e "${RED}ERROR:${RESET} Falló la construcción o despliegue de los servicios."
  exit 1
fi

echo -e "${GREEN}Servicios construidos y desplegados con éxito.${RESET}"

# 2. Verificar servicios en ejecución
echo -e "${BLUE}[2/2]${RESET} ${BOLD}Verificando servicios en ejecución...${RESET}"
docker-compose ps

echo -e "${YELLOW}========================================${RESET}"
echo -e "${YELLOW} Despliegue completado con éxito en entorno: ${BOLD}$ENVIRONMENT${RESET}"
echo -e "${YELLOW} Backend: http://localhost:5001${RESET}"
echo -e "${YELLOW} Frontend: http://localhost:5173${RESET}"
echo -e "${YELLOW}========================================${RESET}"
