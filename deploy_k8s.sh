#!/bin/bash

echo "Desplegando la aplicación en Kubernetes..."

# Aplica el namespace desde la ubicación actual
kubectl apply -f namespace.yaml

# Aplica el backend desde la carpeta api
kubectl apply -f api/backend-deployment.yaml

# Aplica el frontend desde la carpeta web
kubectl apply -f web/frontend-deployment.yaml

# Elimina los servicios que no tienes actualmente
# kubectl apply -f api/backend-service.yaml
# kubectl apply -f web/frontend-service.yaml

echo "Despliegue completado. Revisa el estado de los pods:"
kubectl get pods -n production

