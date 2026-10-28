#!/bin/bash
# Barrido de FP_CORE_UTIL (punto 3.5), con CLOCK_PERIOD = 100 ns.
#   scripts/sweep_util.sh                -> 30, 50, 60 % (el punto de 40 % es la corrida final)
set -e
. "$(dirname "$0")/env.sh"
cd "$ROOT"
UTILS=${@:-"30 50 60"}
for U in $UTILS; do
  $LIBRELANE --design-dir librelane --run-tag "util_${U}" --overwrite \
    -c FP_CORE_UTIL=$U librelane/config.json || echo "U=$U %: el flujo termino con error (se anota igual)"
done
python3 scripts/collect_metrics.py
