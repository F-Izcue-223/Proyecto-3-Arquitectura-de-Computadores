#!/bin/bash
# Deja en resultados/ (carpeta del repo) solo la evidencia liviana de las corridas de LibreLane.
#   scripts/curar_resultados.sh   (desde ~/pochoco_asic en Ubuntu)
WIN=${WIN:-/mnt/c/Users/felip/Downloads/Proyecto_3_Arquitectura/pochoco_asic}
cd "$(dirname "$0")/.."
S=librelane/runs; O="$WIN/resultados"
mkdir -p "$O"
cp_if(){ [ -e "$1" ] && { mkdir -p "$(dirname "$2")"; cp "$1" "$2"; }; }
for r in final final_opt final_mem_ff clk_50ns clk_60ns clk_70ns clk_80ns util_30 util_50 util_60 sim_corto; do
  for f in metrics.json metrics.csv render/asic_top.png; do cp_if $S/$r/final/$f $O/$r/$f; done
  cp_if $S/$r/06-yosys-synthesis/reports/stat.rpt $O/$r/sintesis/stat.rpt
  for c in max_ss_125C_4v50 nom_tt_025C_5v00; do for t in max min; do cp_if $S/$r/55-openroad-stapostpnr/$c/$t.rpt $O/$r/sta_postpnr/$c/$t.rpt; done; done
done
for r in final final_opt; do
  cp_if $S/$r/70-netgen-lvs/reports/lvs.netgen.rpt $O/$r/signoff/lvs.netgen.rpt
  for f in $S/$r/64-magic-drc/reports/*; do cp_if $f $O/$r/signoff/$(basename $f); done
  cp_if $S/$r/46-openroad-checkantennas-1/reports/antenna_summary.rpt $O/$r/signoff/antenna_summary.rpt
  cp_if $S/$r/final/nl/asic_top.nl.v $O/$r/netlist/asic_top.nl.v
done
cp_if $S/final_opt/final/gds/asic_top.gds $O/final_opt/gds/asic_top.gds
cp_if $S/final_opt/final/lef/asic_top.lef $O/final_opt/lef/asic_top.lef
cp_if $S/sim_corto/06-yosys-synthesis/asic_top.nl.v $O/sim_corto/sintesis/asic_top.nl.v
cp_if librelane/resumen_corridas.csv $O/resumen_corridas.csv
echo "Curado en $O"
