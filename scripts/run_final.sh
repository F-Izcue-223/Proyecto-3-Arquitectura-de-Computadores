#!/bin/bash
# Corrida final: CLOCK_PERIOD = 100 ns, FP_CORE_UTIL = 40 %, estrategia 1 (ROM).
#   scripts/run_final.sh            -> runs/final
#   MEM=ff scripts/run_final.sh     -> runs/final_mem_ff (estrategia 2)
set -e
. "$(dirname "$0")/env.sh"
cd "$ROOT"
if [ "$MEM" = "ff" ]; then TAG=final_mem_ff; EXTRA=librelane/variants/mem_ff.json; else TAG=final; EXTRA=; fi
TAG=${RUN_TAG:-$TAG}   # RUN_TAG=final_opt scripts/run_final.sh  (no pisa la corrida anterior)
$LIBRELANE --design-dir librelane --run-tag "$TAG" --overwrite \
  --save-views-to "$ROOT/librelane/views_$TAG" librelane/config.json $EXTRA
echo "Listo: librelane/runs/$TAG"
