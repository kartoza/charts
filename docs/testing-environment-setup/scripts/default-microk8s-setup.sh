#!/usr/bin/env bash

sudo snap install microk8s --classic --channel=1.19/stable

sudo ufw allow in on cni0 && sudo ufw allow out on cni0
sudo ufw default allow routed

sudo usermod -aG microk8s `whoami`

newgrp microk8s
microk8s enable dns dashboard storage ingress