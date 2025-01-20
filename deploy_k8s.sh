#!/bin/bash

set -e  # Detiene el script si ocurre un error

echo "Desplegando la aplicación en Kubernetes..."

# Configura el archivo de kubeconfig
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Verifica conexión al clúster
if ! kubectl cluster-info; then
  echo "Error: No se puede conectar al clúster de Kubernetes."
  exit 1
fi

# Aplica el namespace desde la ubicación actual
echo "Aplicando namespace..."
kubectl apply -f namespace.yaml || {
  echo "Error al aplicar el namespace. Revisa el manifiesto namespace.yaml."
  exit 1
}

# Aplica el backend desde la carpeta api
echo "Aplicando el backend..."
kubectl apply -f api/backend-deployment.yaml || {
  echo "Error al aplicar el backend. Revisa el manifiesto api/backend-deployment.yaml."
  exit 1
}

# Aplica el frontend desde la carpeta web
echo "Aplicando el frontend..."
kubectl apply -f web/frontend-deployment.yaml || {
  echo "Error al aplicar el frontend. Revisa el manifiesto web/frontend-deployment.yaml."
  exit 1
}

# Verifica el estado de los pods en el namespace "production"
echo "Despliegue completado. Revisa el estado de los pods:"
kubectl get pods -n production || {
  echo "Error al obtener los pods en el namespace production."
  exit 1
}
