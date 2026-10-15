#!/usr/bin/env bash
# Instala o build oficial do Blender (Linux x64) em ~/apps, sem sudo. Para VPS / PC x86_64.
# Uso: scripts/instalar-linux-x64.sh [versão]   ex.: 5.2.2  (sem versão = a mais nova)
set -euo pipefail

[ "$(uname -m)" = "x86_64" ] || { echo "Esta máquina é $(uname -m). Para ARM64 use scripts/instalar-linux-arm64.sh"; exit 1; }

UA="Mozilla/5.0 (X11; Linux x86_64)"
BASE="https://download.blender.org/release"
VER="${1:-}"
if [ -z "$VER" ]; then
  SERIE=$(curl -fsSL -A "$UA" "$BASE/" | grep -oE 'Blender[0-9]+\.[0-9]+/' | sort -uV | tail -1 | tr -d /)
  VER=$(curl -fsSL -A "$UA" "$BASE/$SERIE/" | grep -oE 'blender-[0-9.]+-linux-x64\.tar\.xz' | sort -uV | tail -1 | sed -E 's/blender-(.*)-linux-x64.tar.xz/\1/')
fi
SERIE="Blender$(echo "$VER" | cut -d. -f1,2)"
ARQ="blender-$VER-linux-x64.tar.xz"

# Bibliotecas de sistema que o build oficial pede numa VPS mínima (Debian/Ubuntu)
if command -v apt-get >/dev/null && [ "$(id -u)" = 0 ]; then
  apt-get update -qq
  apt-get install -y -qq libxi6 libxxf86vm1 libxfixes3 libxrender1 libgl1 libxkbcommon0 libsm6 libice6 xz-utils curl >/dev/null
fi

mkdir -p ~/apps && cd ~/apps
echo "Baixando $ARQ ..."
curl -fL -A "$UA" -o "$ARQ" "$BASE/$SERIE/$ARQ"
tar -xf "$ARQ" && rm "$ARQ"
ln -sfn "$HOME/apps/blender-$VER-linux-x64" "$HOME/apps/blender"
mkdir -p ~/.local/bin && ln -sfn "$HOME/apps/blender/blender" ~/.local/bin/blender
echo "Instalado: $(~/.local/bin/blender --version | head -1)"
echo "Comando: ~/.local/bin/blender  (garanta ~/.local/bin no PATH)"
