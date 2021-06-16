# Cluster Setup

We compiled a list of possible cluster setup

## MicroK8s

References: https://ubuntu.com/tutorials/install-a-local-kubernetes-with-microk8s#2-deploying-microk8s

Install it using snap:

```bash
sudo snap install microk8s --classic
sudo ufw allow in on cni0 && sudo ufw allow out on cni0
sudo ufw default allow routed
sudo usermod -aG microk8s `whoami`
newgrp microk8s
```

Install some add on

```bash
microk8s enable dns dashboard storage ingress
```