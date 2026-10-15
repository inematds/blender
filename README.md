# blender — instalar e usar o Blender (servidor, VPS, Windows)

Procedimentos testados para instalar o Blender e renderizar **sem tela** (headless), para depois usar com agente (Claude/Codex) por script Python (`bpy`).

## Onde roda e como instalar

| Máquina | Como instalar | Versão | GPU no render |
|---|---|---|---|
| Linux **ARM64** (DGX Spark / GB10, Graviton, Ampere) | `sudo scripts/instalar-linux-arm64.sh` (apt) | a da distro (Ubuntu 24.04 = 4.0.2) | ver `docs/registro-spark-922b.md` |
| Linux **x86_64** (VPS, PC) | `scripts/instalar-linux-x64.sh [versão]` (build oficial em `~/apps`, sem sudo) | a mais nova do blender.org | só se a VPS tiver NVIDIA (CUDA/OptiX) |
| **Windows** | `scripts\instalar-windows.ps1` (winget) | a mais nova | NVIDIA: CUDA/OptiX |

Em 14/10/2026 **não existe build oficial Linux ARM64** no blender.org (só `linux-x64`) nem no Flathub (só x86_64). Por isso o ARM64 usa o apt.

## Testar

```bash
scripts/testar.sh               # usa o 'blender' do PATH
scripts/testar.sh ~/apps/blender/blender --cpu   # força CPU
```
Gera `saida/teste-<data>.png` (cubo amarelo) e imprime os dispositivos que o Cycles enxerga e qual foi usado.

## Uso headless (o essencial)

```bash
blender -b cena.blend -o //render_#### -f 1      # renderiza o frame 1
blender -b cena.blend -a                         # renderiza a animação
blender -b -P script.py -- --meus-args           # roda script Python (bpy)
blender -b cena.blend -E CYCLES -a -- --cycles-device OPTIX   # força GPU NVIDIA
```
- `-b` = sem interface; não precisa de Xvfb para renderizar.
- Numa VPS sem GPU use o Cycles na CPU; o EEVEE precisa de OpenGL/GPU.
- Interface gráfica: abrir numa sessão com tela (RDP/VNC no Linux, normal no Windows).

## VPS — passo a passo

1. `git clone https://github.com/inematds/blender && cd blender`
2. `sudo apt-get install -y git curl xz-utils` (se faltar)
3. `sudo scripts/instalar-linux-x64.sh` (com sudo instala também as libs X/GL que a VPS mínima não tem) ou sem sudo, se as libs já existirem.
4. `export PATH="$HOME/.local/bin:$PATH" && scripts/testar.sh`
5. Registrar o resultado em `docs/registro-vps.md`.

## Windows — passo a passo

1. Baixar este repo (ZIP ou `git clone`).
2. PowerShell na pasta: `powershell -ExecutionPolicy Bypass -File scripts\instalar-windows.ps1`
3. Rodar o teste que o script imprime no fim.
4. Com NVIDIA: *Edit → Preferences → System → CUDA/OptiX*.

## Com agente

O agente escreve um `script.py` com `bpy` (montar cena, materiais, câmera, render) e roda `blender -b -P script.py`. Exemplo completo: `teste/cena_teste.py`. Também existe o **blender-mcp**, que controla o Blender aberto pelo Claude (não testado aqui ainda).

## Registros

- `docs/registro-spark-922b.md` — instalação e teste no servidor ARM64 + GB10.
