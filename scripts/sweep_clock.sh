#!/bin/bash
# Barrido de CLOCK_PERIOD (punto 3.4). Usa -c para sobreescribir solo esa variable.
#   scripts/sweep_clock.sh               -> 80, 70, 60, 50 ns (el punto de 100 ns es la corrida final)
#   scripts/sweep_clock.sh 100 50 25     -> los que indiques
set -e
. "$(dirname "$0")/env.sh"
cd "$ROOT"
PERIODS=${@:-"80 70 60 50"}
for T in $PERIODS; do
  $LIBRELANE --design-dir librelane --run-tag "clk_${T}ns" --overwrite \
    -c CLOCK_PERIOD=$T librelane/config.json || echo "T=$T ns: el flujo termino con error (se anota igual)"
done
python3 scripts/collect_metrics.py
