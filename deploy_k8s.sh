#!/bin/bash

echo "Desplegando la aplicación en Kubernetes..."

kubectl apply -f namespace.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml

echo "Despliegue completado. Revisa el estado de los pods:"
kubectl get pods -n production
