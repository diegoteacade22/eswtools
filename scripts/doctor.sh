#!/bin/bash

echo "=== SYSTEM DOCTOR ==="

echo "Usuario: $(whoami)"
echo "PATH actual: $PATH"

echo "Node:"
which node || echo "No encontrado"

echo "NPM:"
which npm || echo "No encontrado"

echo "OpenClaw:"
which openclaw || echo "No encontrado"

echo "Docker:"
which docker || echo "No encontrado"

echo "=== FIN DOCTOR ==="
