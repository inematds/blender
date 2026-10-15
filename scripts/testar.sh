#!/usr/bin/env bash
# Teste headless: renderiza a cena de teste e mostra o dispositivo usado.
# Uso: scripts/testar.sh [caminho-do-blender] [--cpu]
set -euo pipefail
cd "$(dirname "$0")/.."

BLENDER="${1:-$(command -v blender || true)}"
shift || true
[ -x "$BLENDER" ] || { echo "Blender não encontrado. Passe o caminho: scripts/testar.sh /caminho/blender"; exit 1; }

mkdir -p saida
SAIDA="$PWD/saida/teste-$(date +%Y%m%d-%H%M%S).png"
"$BLENDER" -b --factory-startup -P teste/cena_teste.py -- --saida "$SAIDA" "$@" 2>&1 | grep -E "^\[teste\]|^    |Error|error" || true
[ -s "$SAIDA" ] && echo "PRONTO: $SAIDA" || { echo "FALHOU: PNG não gerado"; exit 1; }
