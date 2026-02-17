#!/bin/bash

echo "=== FIX PATH ==="

NPM_GLOBAL=$(npm root -g 2>/dev/null | sed 's|/lib/node_modules||')

if [[ ":$PATH:" != *":$NPM_GLOBAL/bin:"* ]]; then
  echo "Corrigiendo PATH..."
  echo "export PATH=$NPM_GLOBAL/bin:\$PATH" >> ~/.bashrc
  source ~/.bashrc
fi

echo "PATH corregido"
