#!/bin/bash
set -e

REPO="https://raw.githubusercontent.com/TU_USUARIO/eswtools/main"
VERSION_URL="$REPO/VERSION"

echo "=== ESWTOOLS UNIVERSAL INSTALLER ==="

OS="$(uname)"
CURRENT_VERSION="unknown"

if curl -fsSL "$VERSION_URL" -o /tmp/eswtools_version 2>/dev/null; then
    CURRENT_VERSION=$(cat /tmp/eswtools_version)
fi

echo "Version remota: $CURRENT_VERSION"
echo "Sistema detectado: $OS"

if [[ "$OS" == "Darwin" ]]; then
    echo "Modo macOS"

    if ! command -v brew &> /dev/null; then
        echo "Homebrew no instalado."
        exit 1
    fi

    if ! command -v docker &> /dev/null; then
        echo "Instalando Docker Desktop..."
        brew install --cask docker
        echo "Abrí Docker Desktop manualmente."
    else
        echo "Docker OK"
    fi

    if ! command -v openclaw &> /dev/null; then
        echo "Instalando OpenClaw..."
        npm install -g openclaw
    else
        echo "OpenClaw OK"
    fi

elif [[ "$OS" == "Linux" ]]; then
    echo "Modo Linux"

    if ! command -v docker &> /dev/null; then
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
    else
        echo "Docker OK"
    fi

else
    echo "Sistema no soportado"
    exit 1
fi

echo "=== ESWTOOLS $CURRENT_VERSION INSTALADO ==="
