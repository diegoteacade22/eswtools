#!/bin/bash

echo "=== ESWTOOLS INSTALLER ==="

REPO_DIR="$HOME/eswtools"

if [ -d "$REPO_DIR" ]; then
  echo "Actualizando repositorio..."
  cd $REPO_DIR
  git pull
else
  echo "Clonando repositorio..."
  git clone https://github.com/diegoteacade22/eswtools.git $REPO_DIR
  cd $REPO_DIR
fi

chmod +x scripts/*.sh

echo "Instalando dependencias básicas..."
sudo apt-get update -y
sudo apt-get install -y curl git

echo "Ejecutando diagnóstico..."
bash scripts/doctor.sh

echo "Ejecutando reparación OpenClaw..."
bash scripts/fix-openclaw.sh

echo "=== ESWTOOLS INSTALADO ==="
