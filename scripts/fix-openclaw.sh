#!/bin/bash

echo "=== ESW OPENCLAW FIXER ==="

# 1. Detectar usuario correcto
if [ "$EUID" -eq 0 ]; then
  echo "No ejecutar como root. Cambiando a ubuntu..."
  su - ubuntu -c "/opt/eswtools/fix-openclaw.sh"
  exit
fi

echo "Usuario actual: $(whoami)"

# 2. Verificar Node
if ! command -v node &> /dev/null; then
  echo "Node no encontrado. Instalando..."
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt install -y nodejs
else
  echo "Node OK"
fi

# 3. Verificar npm
if ! command -v npm &> /dev/null; then
  echo "npm no encontrado. Instalando..."
  sudo apt install -y npm
else
  echo "npm OK"
fi

# 4. Corregir PATH npm global
NPM_GLOBAL=$(npm root -g 2>/dev/null | sed 's|/lib/node_modules||')

if [[ ":$PATH:" != *":$NPM_GLOBAL/bin:"* ]]; then
  echo "Corrigiendo PATH..."
  echo "export PATH=$NPM_GLOBAL/bin:\$PATH" >> ~/.bashrc
  source ~/.bashrc
fi

# 5. Verificar openclaw
if ! command -v openclaw &> /dev/null; then
  echo "OpenClaw no encontrado. Instalando global..."
  npm install -g openclaw
else
  echo "OpenClaw OK"
fi

# 6. Verificar Docker
if command -v docker &> /dev/null; then
  echo "Docker detectado."
else
  echo "Docker no instalado (opcional)."
fi

echo "=== SISTEMA LISTO ==="
