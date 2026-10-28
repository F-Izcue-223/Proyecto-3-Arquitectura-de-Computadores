# Evidencia 3.1: construcciones de FPGA y lo que dijo LibreLane

Corridas: `librelane/run0_fpga` (RTL original, tag `run0`) y `librelane/run0b_modelo_bram`
(igual + modelo de la BRAM, tag `run0b`). LibreLane 3.0.17, PDK gf180mcuD, celdas
`gf180mcu_fd_sc_mcu7t5v0`. Los logs completos estan en `resultados_librelane/`.
Rutas de log relativas a `resultados_librelane/<carpeta>/runs/<tag>/`.

| # | Construccion de FPGA | Donde esta en el RTL | Que dijo LibreLane (archivo:linea) | Reemplazo |
|---|---|---|---|---|
| 1 | BRAM `SB_RAM40_4K` (primitiva de la iCE40) como register file | `rtl/espino_core/espino_register_file.v:22` y `:33` | run0 `01-verilator-lint/verilator-lint.log:1` y `:13`: `%Error-MODMISSING ... Cannot find file containing module: 'SB_RAM40_4K'`. run0 `05-yosys-jsonheader/yosys-jsonheader.log:474`: `ERROR: Module \SB_RAM40_4K referenced in module \espino_regbank32 in cell \u_hi is not part of the design.` El flujo se detiene en el paso 5 (`error.log`, `warning.log`: "2 Lint errors found"). | Register file de flip-flops (`regs_q[1:15]`) en `rtl_asic/espino_core/espino_register_file.v` |
| 2 | Valor inicial en un registro (`reg [11:0] por_cnt = 12'b0`): reset de encendido que depende del valor que tiene la FPGA al cargar el bitstream | `rtl/pochoco_soc.v:39` | run0b `01-verilator-lint/verilator-lint.log:1`: `%Warning-PROCASSINIT ... Procedural assignment to declaration with initial value: 'por_cnt'`. Yosys: `06-yosys-synthesis/yosys-synthesis.log:327` `Set init value: \por_cnt = 12'000000000000` (solo informativo). | Reset externo `i_Rst_n` con sincronizador (asert. asincrono, liberacion sincrona) en `asic_top.v` |
| 3 | `initial` + `$readmemh(MemFile, mem)` que carga el programa en la RAM | `rtl/pochoco_ram.v:35-36` | **Ningun aviso.** Yosys lo leyo sin quejarse (`yosys-synthesis.log:2311`: `Removed top 23 address bits ... memory init port ... pochoco_ram.v:36`) y mapeo la memoria a flip-flops (`yosys-synthesis.log:2627`, `Mapping memory \u_pochoco.u_ram.mem`). | ROM combinacional generada por el assembler (estrategia 1) o flip-flops con valor de reset (estrategia 2) |
| 4 | Contenido inicial de la BRAM (`INIT_0(256'h0)`): el register file arrancaba en cero | `rtl/espino_core/espino_register_file.v:23,34` | run0b `yosys-synthesis.log:1285 en adelante`: `memory init port ... sb_ram40_4k_modelo.v:20` (informativo). Sin aviso de que el valor se pierde. | Los registros ya no dependen de arrancar en cero: el programa los escribe antes de leerlos |
| 5 | Reloj de 25 MHz y constantes de tiempo en ciclos (`WAIT_CYCLES` = 75 000 000) | `sw/game.s` | Ninguno. | Constantes para 10 MHz (T = 100 ns) |

## Por que importa la construccion 3 (sin mensaje)

Sin ningun aviso, el programa del juego "parecia" estar dentro de la RAM. En silicio no hay un
archivo que se cargue al encender: las celdas `dffq` que sintetiza Yosys no traen valor inicial,
asi que el chip arrancaria con basura y la CPU ejecutaria instrucciones al azar.

## Tamano de lo que produce el RTL de FPGA (corrida 0b, solo informativo)

`run0b/06-yosys-synthesis/reports/stat.rpt`: 68 512 celdas, 17 233 flip-flops, area de celdas
2 326 690 um2 (2,33 mm2), 47 % secuencial. No es un diseno valido (usa un modelo de la BRAM) pero
muestra por que hay que decidir la memoria: la RAM de 512 palabras y las BRAM modeladas se
convierten en decenas de miles de flip-flops.
