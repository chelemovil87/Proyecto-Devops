#!/bin/bash

set -e  # Detener el script si ocurre un error

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

echo "Desplegando la aplicación en Kubernetes..."

if ! kubectl cluster-info; then
  echo "Error: No se puede conectar al clúster de Kubernetes."
  exit 1
fi

# Aplicar los manifiestos
kubectl apply -f namespace.yaml
kubectl apply -f papi/backend-deployment.yaml
kubectl apply -f web/frontend-deployment.yaml

echo "Despliegue completado. Estado de los pods:"
kubectl get pods -n production
