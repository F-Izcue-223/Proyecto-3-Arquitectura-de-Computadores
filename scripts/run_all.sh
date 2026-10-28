#!/bin/bash
# Todas las corridas que faltan, una tras otra (tarda un par de horas). Seguro de dejar corriendo:
# si una falla, sigue con la siguiente.
#   nohup scripts/run_all.sh > todo.log 2>&1 &     (y mirar el avance con: tail -f todo.log)
. "$(dirname "$0")/env.sh"
cd "$ROOT"
MEM=ff scripts/run_final.sh || echo "estrategia 2 termino con error"
scripts/sweep_clock.sh || true
scripts/sweep_util.sh || true
python3 scripts/collect_metrics.py || true
scripts/export_to_windows.sh
echo "TODO LISTO"
