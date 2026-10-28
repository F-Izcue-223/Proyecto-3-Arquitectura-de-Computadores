#!/bin/bash
# Imprime las versiones de las herramientas que trae la imagen Docker de LibreLane.
#   scripts/versiones_herramientas.sh  -> escribe librelane/versiones_herramientas.txt
cd "$(dirname "$0")/.."
IMG=${IMG:-ghcr.io/librelane/librelane:3.0.17}
{
  echo "imagen: $IMG"
  docker run --rm --entrypoint bash "$IMG" -c 'for t in openroad yosys klayout magic netgen sta; do echo "== $t"; command -v $t || { echo "no encontrado"; continue; }; for o in -version --version -v; do timeout 20 $t $o </dev/null 2>&1 | head -2 && break; done; done'
} > librelane/versiones_herramientas.txt 2>&1
cat librelane/versiones_herramientas.txt
