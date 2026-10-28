#!/bin/bash
# Corrida 0 (punto 3.1): RTL ORIGINAL del Proyecto 2 en LibreLane, solo para
# recoger los avisos propios de la FPGA.
#   0  : RTL tal cual. Se espera que falle: SB_RAM40_4K (BRAM de la iCE40) no existe en ASIC.
#   0b : igual, pero con un modelo de comportamiento de esa BRAM para que el flujo
#        avance hasta la sintesis y muestre los demas avisos ($readmemh, initial, ...).
. "$(dirname "$0")/env.sh"
cd "$ROOT"
$LIBRELANE --design-dir librelane/run0_fpga --run-tag run0 --overwrite \
  -T Yosys.Synthesis librelane/run0_fpga/config.json || echo "run0 termino con error (esperado)"
$LIBRELANE --design-dir librelane/run0b_modelo_bram --run-tag run0b --overwrite \
  -T Yosys.Synthesis librelane/run0b_modelo_bram/config.json || echo "run0b termino con error"
echo "Para traerme los logs: scripts/export_to_windows.sh"
