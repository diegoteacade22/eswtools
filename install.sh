#!/bin/bash
set -e

echo "=== ESWTOOLS BOOTSTRAP START ==="

USER_NAME=$(logname 2>/dev/null || echo $SUDO_USER)
HOME_DIR=$(eval echo ~$USER_NAME)

echo "Usuario detectado: $USER_NAME"

install_docker() {
  if command -v docker &> /dev/null; then
    echo "Docker ya instalado"
  else
    echo "Instalando Docker..."
    apt-get update -y
    apt-get install -y ca-certificates curl gnupg lsb-release

    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" > \
    /etc/apt/sources.list.d/docker.list

    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    systemctl enable docker
    systemctl start docker
  fi
}

fix_docker_permissions() {
  if groups $USER_NAME | grep -q docker; then
    echo "Usuario ya en grupo docker"
  else
    echo "Agregando usuario a grupo docker"
    usermod -aG docker $USER_NAME
    echo "Re-login requerido para aplicar permisos"
  fi
}

deploy_openclaw() {
  if docker ps -a | grep -q openclaw; then
    echo "OpenClaw ya desplegado"
  else
    echo "Desplegando OpenClaw container..."
    mkdir -p $HOME_DIR/openclaw-data

    docker run -d \
      --name openclaw \
      -p 18789:18789 \
      --restart unless-stopped \
      -v $HOME_DIR/openclaw-data:/root/.openclaw \
      ghcr.io/openclaw/openclaw:latest
  fi
}

install_docker
fix_docker_permissions
deploy_openclaw

echo "=== BOOTSTRAP COMPLETADO ==="
