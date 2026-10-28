#!/bin/bash
# Solo sintesis (Yosys) con la ROM de constantes cortas (sim_asic/gen_game), para la simulacion
# post-sintesis 3.7: el testbench usa constantes cortas, asi que la netlist debe tenerlas.
# La netlist queda en librelane/runs/sim_corto/06-yosys-synthesis/asic_top.nl.v
set -e
. "$(dirname "$0")/env.sh"
cd "$ROOT"
$LIBRELANE --design-dir librelane --run-tag sim_corto --overwrite --to Yosys.Synthesis \
  librelane/config.json librelane/variants/sim_corto.json
echo "Listo: librelane/runs/sim_corto"
