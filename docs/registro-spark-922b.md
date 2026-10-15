# Registro — spark-922b (Linux ARM64 + NVIDIA GB10)

Máquina: Ubuntu 24.04.3, aarch64, 20 núcleos, 119 GB de memória unificada, GPU NVIDIA GB10, CUDA 13.0.

## 14/10/2026 — instalação

- Build oficial ARM64: **não existe** (blender.org só tem `linux-x64` até a 5.2.2; Flathub só x86_64).
- Instalado pelo apt: `sudo scripts/instalar-linux-arm64.sh` → **Blender 4.0.2** (`4.0.2+dfsg-1ubuntu8`) em `/usr/bin/blender`.
- O sudo precisa de terminal próprio (RDP/SSH); o `!` do Claude Code não pede senha.

## 14/10/2026 — teste (`scripts/testar.sh`)

| Dispositivo | Resultado |
|---|---|
| **CPU** | OK — cubo 640×360, 32 amostras, **0,6 s** |
| **GPU (CUDA, GB10)** | Cycles **enxerga** a GB10, mas o render falha: o 4.0.2 não traz kernel para sm_121 e a compilação na hora com o CUDA 13 dá `config.h:114: division by zero in #if` |

Outro limite do pacote do apt: **sem OpenImageDenoise** (`Build without OpenImageDenoiser`); com denoise ligado o render aborta. O `cena_teste.py` desliga o denoise e, se a GPU falhar, refaz na CPU.

## Próximos passos possíveis (não feitos)

- GPU na GB10: compilar o Blender 5.x do código-fonte com CUDA 13 e `CYCLES_CUDA_BINARIES_ARCH=sm_121` (horas de build e ~30 GB; o disco `/` está em 99%).
- Testar o blender-mcp.
