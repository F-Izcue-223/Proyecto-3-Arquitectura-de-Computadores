# Evidencia 3.5 (floorplan/placement) y 3.6 (signoff + layout anotado)

Corrida base: `final_opt` (T = 100 ns, FP_CORE_UTIL = 40 %, estrategia 1: ROM + RAM de 8 palabras).

## 3.5 Floorplan, PDN, placement
- Die: 655,6 x 673,5 µm = 0,4416 mm². Costo lineal a US$23.000/mm²: **US$10.156**.
- Barrido de utilización (T = 100 ns, corrida `final` base, sin el cambio de RTL):

| FP_CORE_UTIL | Die mm² | Costo US$ | Setup WNS ns | DRC / LVS | Antenas |
|---|---|---|---|---|---|
| 30 % | 0,576 | 13.245 | +41,74 | 0 / 0 | 1 violación |
| 40 % | 0,436 | 10.024 | +34,87 | 0 / 0 | 0 |
| 50 % | 0,3515 | 8.083 | +38,72 | 0 / 0 | 0 |
| 60 % | 0,295 | 6.784 | +36,82 | 0 / 0 | 0 |

- La utilización medida después de PnR (51 % con U = 40 %) es mayor que la pedida: el objetivo se fija antes de insertar buffers, árbol de reloj y celdas tap.
- Plots: `resultados_librelane/runs/<corrida>/final/render/asic_top.png` (una por valor de U) y `informe/figuras/layout_modulos.png` (posición de celdas por módulo, sacada del DEF).
- Pines: ver `informe/pines_justificacion.md`.

## 3.6 Signoff
- Magic DRC = 0, LVS = 0 errores, DRC de ruteo = 0, antenas = 0, setup WNS = +37,22 ns (max_ss_125C_4v50), hold WNS = +0,17 ns, TNS = 0.
- El DRC de KLayout no corre: el PDK gf180mcuD no trae runset para el flujo, por eso LibreLane avisa "klayout__drc_error__count not reported / KLayout.DRC may have been skipped". El DRC válido es el de Magic.
- Avisos que quedan (no son errores de signoff): violaciones de max slew y max cap en esquinas lentas, producto de los buffers `dlyb_1` que usa el resizer.

## Layout anotado
`informe/figuras/layout_anotado_klayout.png`: render de KLayout de `final_opt` con la caja envolvente de cada módulo:
- Banco de registros (1.845 celdas): x 23-635 µm, y 314-651 µm (franja superior, rodea a la ALU).
- ALU (580 celdas): x 207-488 µm, y 318-439 µm (centro-superior, pegada al banco).
- Contador de ciclos (114 celdas): x 394-463 µm, y 20-184 µm (parte baja del die).
Las cajas son envolventes, por eso la de la ALU cae dentro de la del banco de registros: las celdas de ambos módulos están mezcladas en esa zona.
