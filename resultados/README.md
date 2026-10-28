# resultados/

Evidencia curada de las corridas de LibreLane (las corridas completas pesan cientos de MB y no se suben).
Cada carpeta tiene `metrics.json`/`metrics.csv`, el render del layout, el reporte de sintesis (`sintesis/stat.rpt`)
y el STA post-PnR de los corners `max_ss_125C_4v50` y `nom_tt_025C_5v00` (`sta_postpnr/`).

| Carpeta | Que es |
|---|---|
| `final_opt/` | **Corrida final entregada**: T = 100 ns, U = 40 %, estrategia 1, con comparador de saltos dedicado. Incluye GDS, LEF, netlist, LVS, DRC de Magic y antenas. |
| `final/` | Misma corrida antes del cambio de RTL (referencia de 3.4). |
| `final_mem_ff/` | Estrategia 2 (memoria de flip-flops), detenida en el paso 43. |
| `clk_50ns` ... `clk_80ns` | Barrido de CLOCK_PERIOD (3.4). |
| `util_30`, `util_50`, `util_60` | Barrido de FP_CORE_UTIL (3.5). |
| `sim_corto/` | Netlist de sintesis con constantes cortas, usada en la simulacion post-sintesis (3.7). |
| `resumen_corridas.csv` | Tabla con las metricas de todas las corridas. |

Cada carpeta lleva en `sintesis/`, `sta_postpnr/`, `signoff/` los reportes crudos de LibreLane.
