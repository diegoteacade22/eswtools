#!/bin/bash
set -e

echo "=== ESWTOOLS UNIVERSAL INSTALLER ==="

OS="$(uname)"

if [[ "$OS" == "Darwin" ]]; then
  echo "Detectado macOS"

  if ! command -v brew &> /dev/null; then
    echo "Homebrew no instalado. Instalar primero desde https://brew.sh"
    exit 1
  fi

  if ! command -v docker &> /dev/null; then
    echo "Instalando Docker Desktop..."
    brew install --cask docker
    echo "Abrí Docker Desktop manualmente una vez para completar instalación."
  else
    echo "Docker ya instalado en Mac"
  fi

elif [[ "$OS" == "Linux" ]]; then
  echo "Detectado Linux"

  if ! command -v apt-get &> /dev/null; then
    echo "Sistema Linux no compatible (sin apt)"
    exit 1
  fi

  echo "Instalando Docker en Ubuntu..."

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

else
  echo "Sistema operativo no soportado"
  exit 1
fi

echo "=== INSTALL FINALIZADO ==="
