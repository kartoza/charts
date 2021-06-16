#!/usr/bin/env bash
set -ux

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add longhorn https://charts.longhorn.io
helm repo add stable https://charts.helm.sh/stable
helm repo update


kubectl create namespace ingress-nginx
helm -n ingress-nginx install ingress-nginx ingress-nginx/ingress-nginx

kubectl create namespace longhorn-system
helm -n longhorn-system install longhorn longhorn/longhorn

kubectl apply -f docs/testing-environment-setup/configs/longhorn-storage-class.yaml

kubectl patch storageclass longhorn -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'

kubectl create namespace nfs-provisioner
helm -n nfs-provisioner install nfs-provisioner stable/nfs-server-provisioner -f docs/testing-environment-setup/configs/nfs-provisioner-values.yaml