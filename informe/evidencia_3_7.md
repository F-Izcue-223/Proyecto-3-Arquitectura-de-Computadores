# Evidencia 3.7: simulacion post-sintesis (netlist real de GF180)

- Netlist: `resultados_librelane/runs/sim_corto/06-yosys-synthesis/asic_top.nl.v` (salida de Yosys de LibreLane 3.0.17, celdas `gf180mcu_fd_sc_mcu7t5v0`, 5.644 celdas, 164.585 µm²). Se genero con `scripts/run_sim_corto.sh` (solo sintesis, ROM con constantes cortas `sim_asic/gen_game`, el mismo RTL que `final_opt` incluyendo el comparador de saltos nuevo).
- Se usa la netlist de sintesis y no la de `final_opt` porque esa lleva las constantes de 10 MHz del juego real (30.000.000 ciclos de espera), que el testbench no puede esperar. Lo unico distinto entre ambas es la ROM de constantes.
- Modelos de celdas: modelos `functional` del repositorio del PDK (`google/globalfoundries-pdk-libs-gf180mcu_fd_sc_mcu7t5v0`, commit 43beb45e) para las celdas combinacionales (`sim_asic/postsynth/gf180/celdas_gf180_comb.v`). Los 3 flip-flops (`dffq_1`, `dffrnq_1`, `dffsnq_1`) usan primitivas UDP que Verilator no simula, asi que se escribieron con la misma funcion logica en `ff_gf180_modelos.v` (reset/set asincrono activo en 0).
- Comando: `make sim-post NETLIST=<ruta>/asic_top.nl.v` (el Makefile ya incluye los modelos en `CELLS`).
- Resultado, mismo testbench que el RTL (`sim_asic/game_tb.v`):
  - `JUEGO: OK - todas las reglas se cumplen`, 0 lineas `FALLO`.
  - Comparacion de trazas (LEDs y displays en cada cambio): **66 eventos en el RTL, 66 en la netlist, mismos cambios en los mismos ciclos** (`compare_traces.py`: "TRAZAS IGUALES").
- Trazas: `sim_asic/postsynth/traza_rtl_gf180.txt` y `traza_netlist_gf180.txt`.
- Limite: es simulacion funcional sin retardos (2 estados), no valida tiempos; eso lo cubre el STA de 3.4.
