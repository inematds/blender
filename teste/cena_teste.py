"""Cena de teste headless: cubo + chão + luz + câmera, render Cycles em PNG.

Uso:
  blender -b -P teste/cena_teste.py -- --saida /tmp/teste.png [--cpu] [--amostras 32]

Mostra os dispositivos que o Cycles enxerga (OptiX/CUDA/CPU) e usa a GPU
se houver, a menos que --cpu seja passado. Funciona no Blender 4.x e 5.x.
"""
import argparse
import sys
import time

import bpy

argv = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
ap = argparse.ArgumentParser()
ap.add_argument("--saida", default="/tmp/blender-teste.png")
ap.add_argument("--cpu", action="store_true", help="força render na CPU")
ap.add_argument("--amostras", type=int, default=32)
ap.add_argument("--largura", type=int, default=640)
ap.add_argument("--altura", type=int, default=360)
args = ap.parse_args(argv)

print(f"[teste] Blender {bpy.app.version_string}")

# --- cena limpa ---
bpy.ops.wm.read_factory_settings(use_empty=True)
scene = bpy.context.scene

bpy.ops.mesh.primitive_plane_add(size=10, location=(0, 0, 0))
bpy.ops.mesh.primitive_cube_add(size=2, location=(0, 0, 1))
cubo = bpy.context.active_object
mat = bpy.data.materials.new("amarelo")
mat.use_nodes = True
mat.node_tree.nodes["Principled BSDF"].inputs["Base Color"].default_value = (0.98, 0.80, 0.08, 1)
cubo.data.materials.append(mat)
cubo.rotation_euler = (0, 0, 0.6)

bpy.ops.object.light_add(type="SUN", location=(4, -4, 8))
bpy.context.active_object.data.energy = 4

bpy.ops.object.camera_add(location=(6, -6, 4.5), rotation=(1.1, 0, 0.785))
scene.camera = bpy.context.active_object

# --- render ---
scene.render.engine = "CYCLES"
scene.cycles.samples = args.amostras
# O Blender do apt (Ubuntu ARM64) vem sem OpenImageDenoise: com denoise ligado o render aborta.
scene.cycles.use_denoising = False
scene.render.resolution_x = args.largura
scene.render.resolution_y = args.altura
scene.render.resolution_percentage = 100
scene.render.image_settings.file_format = "PNG"
scene.render.filepath = args.saida

# --- dispositivos ---
prefs = bpy.context.preferences.addons["cycles"].preferences
gpu_tipo = None
for tipo in ("OPTIX", "CUDA", "HIP", "METAL", "ONEAPI"):
    try:
        prefs.compute_device_type = tipo
    except TypeError:
        continue  # tipo não existe neste build
    prefs.get_devices()
    gpus = [d for d in prefs.devices if d.type == tipo]
    if gpus:
        gpu_tipo = tipo
        for d in prefs.devices:
            d.use = d.type == tipo
        break

print("[teste] dispositivos vistos pelo Cycles:")
for d in prefs.devices:
    print(f"    {d.type:7} {d.name}")

if gpu_tipo and not args.cpu:
    scene.cycles.device = "GPU"
    print(f"[teste] render na GPU ({gpu_tipo})")
else:
    prefs.compute_device_type = "NONE"
    scene.cycles.device = "CPU"
    print("[teste] render na CPU" + (" (forçado)" if args.cpu else " (nenhuma GPU disponível)"))

t0 = time.time()
try:
    bpy.ops.render.render(write_still=True)
except RuntimeError as erro:
    if scene.cycles.device != "GPU":
        raise
    # Ex.: GB10 (sm_121) no Blender 4.0 do apt: sem kernel CUDA pronto e a compilação na hora falha.
    print(f"[teste] GPU falhou ({erro}); refazendo na CPU")
    prefs.compute_device_type = "NONE"
    scene.cycles.device = "CPU"
    t0 = time.time()
    bpy.ops.render.render(write_still=True)
print(f"[teste] OK: {args.saida} em {time.time() - t0:.1f} s")
