# Evidencia 3.2: dos estrategias de memoria

Ambas con T = 100 ns y FP_CORE_UTIL = 40 %, RTL anterior al comparador de saltos (corridas `final` y `final_mem_ff`), LibreLane 3.0.17, gf180mcuD, `gf180mcu_fd_sc_mcu7t5v0`.

- **Estrategia 1:** ROM combinacional generada por `pochoasm.py` desde `game.s` (114 palabras, `case` + registro de salida) + RAM de datos de 8 palabras en flip-flops (`pochoco_dram.v`). El juego usa 0 palabras de datos.
- **Estrategia 2:** memoria unificada en flip-flops (`pochoco_mem_ff.v`, `-DMEM_FF`): 114 + 8 = 122 palabras de 32 bits, cada una un registro con reset al valor del programa y lectura por multiplexor de 122 entradas. Instrucciones y datos comparten espacio y la memoria es escribible.

| Medida | Estrategia 1 (ROM + RAM) | Estrategia 2 (FF unificada) | Razon 2/1 |
|---|---|---|---|
| Celdas tras sintesis | 5.567 | 21.603 | 3,9x |
| Area de celdas tras sintesis | 162.735 µm² | 654.901 µm² | 4,0x |
| Flip-flops | 1.069 | 4.719 | 4,4x |
| Area de flip-flops | 70.251 µm² (43,2 %) | 350.780 µm² (53,6 %) | 5,0x |
| Die tras floorplan | 0,436 mm² | 1,695 mm² | 3,9x |
| Costo (US$23.000/mm²) | US$10.024 | US$38.985 | 3,9x |
| Utilizacion medida tras PnR | 51,4 % | 54,6 % | |
| Setup WNS en `max_ss_125C_4v50` | +34,87 ns | -740,81 ns | |
| Periodo minimo (T - WNS) | 65,1 ns | 840,8 ns | 12,9x |
| fmax | 15,4 MHz | 1,19 MHz | |
| Cierre completo | si (DRC, LVS, antenas = 0) | no, detenida en el paso 43 (1 antena, ruteo estancado) | |

Notas:
- La estrategia 2 se detuvo en el paso 43 (`stamidpnr`, antes del ruteo final): sus tiempos son una estimacion en ese punto; el cierre queda pendiente (idea: repetir con utilizacion de 30-35 %).
- Los 3.650 flip-flops de diferencia (4.719 - 1.069) son las 114 palabras de programa convertidas en registros (3.648 bits); el resto es redondeo.
- Cada bit de programa como flip-flop con reset cuesta ~75 µm² (`dffrnq/dffsnq`); como logica de la ROM cuesta una fraccion, porque 114 palabras constantes se reducen a pocas compuertas.
- La lectura por multiplexor de 122 entradas x 32 bits, mas el decodificador de escritura, alarga el camino critico a ~840 ns y exige 3,85 m de cable y 287.608 vias contra 0,40 m y 47.733 vias de la estrategia 1.
- Palabras realmente usadas por el juego: 114 de instrucciones, 0 de datos.
- Conclusion: para este juego la estrategia 1 es mejor en area, costo, frecuencia y cierre de ruteo; la 2 solo se justificaria si el programa tuviera que modificarse o cargarse en ejecucion (el valor de reset del programa igual queda fijo en el silicio).
