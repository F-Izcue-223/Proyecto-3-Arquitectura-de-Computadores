# Pochoco SoC en ASIC (Proyecto 3). Pide: python3, verilator >= 5 (viene con LibreLane).
#   make program      game.s -> sw/game.hex + ROM (rtl_asic/gen/game_rom.v) + init de la memoria unificada
#   make test         pruebas del assembler
#   make sim-isa      prueba de instrucciones sobre asic_top        (RTL)
#   make sim          partida completa con tiempos cortos           (RTL)
#   make sim-ff       lo mismo con la estrategia 2 (memoria de flip-flops)
#   make sim-post NETLIST=ruta/a/netlist.v [CELLS="modelos_de_celdas.v"]
#                     la misma partida sobre la netlist de sintesis; compara con el RTL
#   make final        corrida final de LibreLane (100 ns, 40 %)
#   make report       tabla con las metricas de todas las corridas
PYTHON    ?= python3
VERILATOR ?= verilator
BUILD     ?= build

GAME      = sw/game.s
ASM       = $(PYTHON) asm/pochoasm.py
RTL       = $(wildcard rtl_asic/*.v) $(wildcard rtl_asic/espino_core/*.v)
# Constantes cortas para simular (el juego real usa las de game.s)
SHORT     = -D WAIT_CYCLES=20000 -D TENTH_CYCLES=1000 -D DEBOUNCE_CYCLES=200 -D BLINK_CYCLES=2000
CELLS     ?= sim_asic/postsynth/gf180/celdas_gf180_comb.v sim_asic/postsynth/gf180/ff_gf180_modelos.v
VFLAGS    = --binary --timing -Wno-fatal -Wno-lint -Wno-style -I. \
            -DWAIT_CYCLES=20000 -DTENTH_CYCLES=1000 -DDEBOUNCE_CYCLES=200 -DBLINK_CYCLES=2000

.PHONY: program test sim-program sim-isa sim sim-ff sim-post final report clean

program: sw/game.hex rtl_asic/gen/game_rom.v rtl_asic/gen/game_mem_init.vh
sw/game.hex rtl_asic/gen/game_rom.v rtl_asic/gen/game_mem_init.vh: $(GAME) asm/pochoasm.py
	@mkdir -p rtl_asic/gen
	$(ASM) $(GAME) -o sw/game.hex -l sw/game.lst --rom-v rtl_asic/gen/game_rom.v --init-vh rtl_asic/gen/game_mem_init.vh --report

test:
	$(PYTHON) -m unittest discover -s asm -v

# ROM y memorias con tiempos cortos para las simulaciones
sim-program:
	@mkdir -p sim_asic/gen_game sim_asic/gen_isa $(BUILD)
	$(ASM) $(GAME) -o $(BUILD)/game_short.hex $(SHORT) --rom-v sim_asic/gen_game/game_rom.v --init-vh sim_asic/gen_game/game_mem_init.vh
	$(ASM) sim/isa_test.s -o $(BUILD)/isa.hex -D SCRATCH=0x344 --rom-v sim_asic/gen_isa/game_rom.v --init-vh sim_asic/gen_isa/game_mem_init.vh

$(BUILD):
	@mkdir -p $(BUILD)

sim-isa: sim-program | $(BUILD)
	$(VERILATOR) $(VFLAGS) -Isim_asic/gen_isa --top-module isa_tb -Mdir $(BUILD)/isa \
	  $(RTL) sim_asic/gen_isa/game_rom.v sim_asic/isa_tb.v
	$(BUILD)/isa/Visa_tb

sim: sim-program | $(BUILD)
	$(VERILATOR) $(VFLAGS) -Isim_asic/gen_game --top-module game_tb -Mdir $(BUILD)/game \
	  $(RTL) sim_asic/gen_game/game_rom.v sim_asic/game_tb.v
	$(BUILD)/game/Vgame_tb

sim-ff: sim-program | $(BUILD)
	$(VERILATOR) $(VFLAGS) -DMEM_FF -Isim_asic/gen_game --top-module game_tb -Mdir $(BUILD)/game_ff \
	  $(RTL) sim_asic/game_tb.v
	$(BUILD)/game_ff/Vgame_tb

# Simulacion funcional post-sintesis: mismo testbench, pero el DUT es la netlist.
# Con celdas del PDK hay que pasar sus modelos Verilog en CELLS.
sim-post: sim-program | $(BUILD)
	@test -n "$(NETLIST)" || (echo "Falta NETLIST=ruta/a/la/netlist.v"; exit 1)
	$(VERILATOR) $(VFLAGS) -DTRACE -Wno-fatal --top-module game_tb -Mdir $(BUILD)/post_rtl \
	  $(RTL) sim_asic/gen_game/game_rom.v sim_asic/game_tb.v -Isim_asic/gen_game
	$(BUILD)/post_rtl/Vgame_tb | tee $(BUILD)/rtl.log > /dev/null
	$(VERILATOR) $(VFLAGS) -DTRACE -Wno-fatal --top-module game_tb -Mdir $(BUILD)/post_net \
	  $(NETLIST) $(CELLS) sim_asic/game_tb.v
	$(BUILD)/post_net/Vgame_tb | tee $(BUILD)/net.log
	$(PYTHON) sim_asic/postsynth/compare_traces.py $(BUILD)/rtl.log $(BUILD)/net.log

final:
	scripts/run_final.sh

report:
	$(PYTHON) scripts/collect_metrics.py

clean:
	rm -rf $(BUILD)
