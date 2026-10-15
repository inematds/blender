# CLAUDE.md — blender

Procedimentos para instalar e usar o Blender headless (servidor ARM64, VPS x86_64, Windows). Repo: `inematds/blender`, autor dos commits `inematds <inematds@gmail.com>`.

- Todo procedimento novo vira script em `scripts/` + linha no README; o resultado de cada máquina vai em `docs/registro-<maquina>.md`.
- Teste padrão: `scripts/testar.sh` (gera PNG em `saida/`, que não vai pro git).

## Self-learning

When I correct you, or you catch yourself making a mistake: before continuing, add the lesson as a one-line rule under ## Lessons, so it never happens again.

## Lessons

- download.blender.org responde 403 sem User-Agent de navegador: os scripts passam `-A`. (14/10/2026)
