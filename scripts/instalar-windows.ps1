# Instala o Blender no Windows pelo winget e roda um teste de versão.
# Uso (PowerShell): powershell -ExecutionPolicy Bypass -File scripts\instalar-windows.ps1
winget install --id BlenderFoundation.Blender -e --accept-source-agreements --accept-package-agreements

$exe = Get-ChildItem "C:\Program Files\Blender Foundation" -Recurse -Filter blender.exe -ErrorAction SilentlyContinue |
       Sort-Object FullName -Descending | Select-Object -First 1
if (-not $exe) { Write-Host "blender.exe nao encontrado"; exit 1 }
& $exe.FullName --version | Select-Object -First 1
Write-Host "Teste de render:"
Write-Host "  & `"$($exe.FullName)`" -b --factory-startup -P teste\cena_teste.py -- --saida $PWD\saida\teste.png"
