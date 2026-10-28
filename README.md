# Pochoco SoC + juego de reflejos: de RTL a GDSII (Proyecto 3)

Arquitectura de Computadores 2026-2. Parte del repositorio del Proyecto 2 del grupo
(`rtl/`, `sw/game.s`, `asm/pochoasm.py`) y lo lleva a ASIC con **LibreLane** y el PDK **GF180MCU**.

Parámetros de la corrida final: `CLOCK_PERIOD = 100 ns`, `FP_CORE_UTIL = 40 %`.

## Carpetas

| Carpeta | Contenido |
|---|---|
| `rtl/` | RTL original del Proyecto 2 (para FPGA). No se tocó; sirve de evidencia en la *corrida 0*. |
| `rtl_asic/` | RTL para ASIC: `asic_top.v` y el SoC sin construcciones de FPGA. |
| `rtl_asic/gen/` | **Generado** por el assembler desde `sw/game.s` (ROM y init de memoria). No editar a mano. |
| `sw/game.s` | Programa del juego (constantes para T = 100 ns). |
| `asm/pochoasm.py` | Assembler propio, con `--rom-v`, `--init-vh` y `--report`. |
| `sim/`, `sim_asic/` | Pruebas del RTL de FPGA y del RTL de ASIC (testbenches). |
| `sim_asic/postsynth/` | Simulación post-síntesis: script de Yosys, netlist y trazas RTL vs netlist. |
| `librelane/` | Configuración de LibreLane (final, variante de memoria, corrida 0, orden de pines). |
| `scripts/` | Corrida final, barridos y recolección de métricas. |

## Versiones usadas

Obtenidas de la corrida final y de la imagen Docker (`scripts/versiones_herramientas.sh`, resultado en `versiones_herramientas.txt`).

| Elemento | Versión |
|---|---|
| LibreLane | `3.0.17` (`librelane --version`), imagen `ghcr.io/librelane/librelane:3.0.17` |
| PDK | `gf180mcuD`, revisión (ciel/volare) `54435919abffb937387ec956209f9cf5fd2dfbee`, la que fija LibreLane 3.0.17 en `pdk_hashes.yaml` |
| Biblioteca de celdas | `gf180mcu_fd_sc_mcu7t5v0` (7 tracks, 5 V; es la que LibreLane toma por defecto para gf180mcuD; confirmado en la corrida 0b) |
| Corners de STA | `nom/min/max` x `tt_025C_5v00`, `ss_125C_4v50`, `ff_n40C_5v50` (9 corners; `DEFAULT_CORNER = nom_tt_025C_5v00`) |
| OpenROAD | build `2026-02-17`, commit `dcf36133a369abc8f3c5e5738cd4d82e4903c0e0` (imagen de LibreLane 3.0.17) |
| OpenSTA | `2.7.0` |
| Yosys | `0.62` (git sha1 `7326bb7d6641500ecb285c291a54a662cb1e76cf`) |
| Magic | `8.3` revisión `623` |
| Netgen | `1.5.316` |
| KLayout | el de la imagen de LibreLane 3.0.17 (`klayout` de Nix; solo se usa en modo batch para el render, no imprime su versión; el DRC de KLayout se omite en gf180mcuD) |
| Verilator (simulaciones y lint) | `5.044` en la imagen de LibreLane (lint); `5.032` (apt de Ubuntu) para las simulaciones locales de `make sim*` |

## Instalar LibreLane

Sigue la guía oficial: <https://librelane.readthedocs.io/en/stable/getting_started/>. Resumen:

**Opción A: Docker (recomendada en Windows, con WSL2).**
1. Instala Docker Desktop con WSL2 y abre una terminal de WSL (Ubuntu).
2. `python3 -m pip install librelane`
   (si Ubuntu trae Python 3.14 y `pip` falla compilando, usa `uv venv --python 3.12 ~/ll` y `uv pip install librelane`)
3. Prueba: `python3 -m librelane --dockerized --smoke-test`
4. Instala el PDK de GF180 (LibreLane no lo baja solo para esta familia):
   `ciel enable --pdk-family gf180mcu --pdk-root ~/.ciel 54435919abffb937387ec956209f9cf5fd2dfbee`
5. Los scripts ya usan por defecto `python3 -m librelane --dockerized --pdk gf180mcuD --pdk-root $HOME/.ciel`
   (se puede cambiar con la variable `LIBRELANE`).

**Opción B: Nix (Linux / WSL2).** Instala Nix con flakes, activa la caché binaria de LibreLane
(ver la guía) y entra al entorno con `nix-shell` o `nix develop` desde el repositorio de LibreLane.
Dentro de ese entorno `python3 -m librelane` ya trae todas las herramientas.

El PDK se descarga solo en la primera corrida (`--volare-pdk/--ciel-pdk` por defecto).

## Regenerar el programa desde `game.s`

```
make program      # sw/game.hex + rtl_asic/gen/game_rom.v + rtl_asic/gen/game_mem_init.vh
make test         # pruebas del assembler
```

Si cambia `CLOCK_PERIOD`, recalcular las cuatro constantes del inicio de `sw/game.s`
(ciclos = segundos / T; ver el comentario del archivo) y correr `make program` otra vez.
Para T = 100 ns (10 MHz): `WAIT_CYCLES = 30 000 000`, `TENTH_CYCLES = 1 000 000`,
`DEBOUNCE_CYCLES = 200 000`, `BLINK_CYCLES = 2 500 000`.

## Corrida final

```
make final          # = scripts/run_final.sh  (estrategia 1: ROM + RAM de 8 palabras)
MEM=ff make final   # estrategia 2: memoria unificada de flip-flops
```

Comando equivalente (desde la raíz del repositorio):

```
python3 -m librelane --design-dir librelane --run-tag final --overwrite librelane/config.json
```

Resultados en `librelane/runs/final/` (`final/` tiene GDS, netlist, métricas). Para resumir
cualquier corrida: `make report` (escribe `librelane/resumen_corridas.csv`).

## Experimentos del informe

| Punto | Comando |
|---|---|
| 3.1 avisos de FPGA (RTL original) | `scripts/run_run0.sh` (corrida 0: RTL tal cual; corrida 0b: con un modelo de la BRAM para llegar hasta la síntesis) |
| Llevar logs a Windows | `scripts/export_to_windows.sh` |
| 3.2 comparar memorias | `scripts/run_final.sh` y `MEM=ff scripts/run_final.sh`, luego `make report` |
| 3.4 barrido de `CLOCK_PERIOD` | `scripts/sweep_clock.sh` (por defecto 80, 70, 60, 50 ns; el de 100 ns es la corrida final) |
| 3.5 barrido de `FP_CORE_UTIL` | `scripts/sweep_util.sh` (por defecto 30, 50, 60 %; el de 40 % es la corrida final) |
| 3.4 corrida con el cambio de RTL (comparador de saltos dedicado) | `RUN_TAG=final_opt scripts/run_final.sh` (no pisa `final`) |
| 3.7 simulación post-síntesis | ver abajo |

## Simulación

```
make sim-isa    # instrucciones sobre asic_top
make sim        # partida completa (tiempos cortos), estrategia 1
make sim-ff     # lo mismo, estrategia 2
```

Post-síntesis (3.7), con la netlist de Yosys de LibreLane y los modelos Verilog de las celdas del PDK.
El testbench usa constantes cortas, así que la netlist se sintetiza con la ROM de `sim_asic/gen_game`
(solo síntesis, ~3 min):

```
scripts/run_sim_corto.sh                     # deja librelane/runs/sim_corto/06-yosys-synthesis/asic_top.nl.v
make sim-post NETLIST=librelane/runs/sim_corto/06-yosys-synthesis/asic_top.nl.v
```

`CELLS` ya apunta a `sim_asic/postsynth/gf180/` (modelos `functional` de las celdas combinacionales del
repositorio del PDK y modelos propios para los 3 flip-flops, porque Verilator no simula sus primitivas UDP).
Imprime la partida y compara, evento por evento, el ciclo en que cambian LEDs y displays en el
RTL y en la netlist. Los tiempos se acortan igual en ambas corridas (3 s = 20 000 ciclos,
una décima = 1 000, antirrebote = 200, parpadeo = 2 000) y el botón incorrecto reinicia la ronda.

## Estado

Las secciones con datos de LibreLane (áreas, timing, DRC/LVS, costo) se completan con las
corridas reales (ver `informe/evidencia_*.md`); el RTL, el assembler y las simulaciones ya están verificados.
La estrategia 2 (memoria de flip-flops) quedó con la corrida parcial; su cierre de ruteo está pendiente.
