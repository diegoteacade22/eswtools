#!/bin/bash
set -e

echo "=== ESWTOOLS UNIVERSAL INSTALLER ==="

OS="$(uname)"

if [[ "$OS" == "Darwin" ]]; then
  echo "macOS detectado"

  if ! command -v brew &> /dev/null; then
    echo "Homebrew no instalado. Instalalo primero desde https://brew.sh"
    exit 1
  fi

  if ! command -v docker &> /dev/null; then
    echo "Instalando Docker Desktop..."
    brew install --cask docker
    echo "Abrí Docker Desktop manualmente y esperá que diga 'Docker is running'"
  else
    echo "Docker ya instalado"
  fi

  if ! command -v openclaw &> /dev/null; then
    echo "Instalando OpenClaw vía npm..."
    npm install -g openclaw
  else
    echo "OpenClaw ya instalado"
  fi

elif [[ "$OS" == "Linux" ]]; then
  echo "Linux detectado — usar bootstrap Linux separado"
else
  echo "Sistema no soportado"
  exit 1
fi

echo "=== INSTALACIÓN COMPLETA ==="
