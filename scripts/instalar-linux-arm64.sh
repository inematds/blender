#!/usr/bin/env bash
# Instala o Blender em Linux ARM64 (ex.: DGX Spark / GB10, Ampere, Graviton).
# Não existe build oficial ARM64 no blender.org nem no Flathub (conferido em 14/10/2026),
# então o caminho é o pacote da distribuição (Ubuntu 24.04 = Blender 4.0.2). Precisa de sudo.
# Uso: sudo scripts/instalar-linux-arm64.sh
set -euo pipefail

[ "$(uname -m)" = "aarch64" ] || { echo "Esta máquina é $(uname -m). Para x86_64 use scripts/instalar-linux-x64.sh"; exit 1; }
[ "$(id -u)" = 0 ] || { echo "Rode com sudo."; exit 1; }

apt-get update -qq
apt-get install -y blender
blender --version | head -1
