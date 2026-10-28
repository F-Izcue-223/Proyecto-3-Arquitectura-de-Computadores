#!/usr/bin/env python3
"""Junta en una tabla las metricas de todas las corridas de LibreLane.

Uso:   python3 scripts/collect_metrics.py [carpeta_de_runs] [--md]
Por defecto mira librelane/runs/*/final/metrics.json y escribe
librelane/resumen_corridas.csv (y lo muestra por pantalla).

Las columnas salen de metricas reales de LibreLane (timing__setup__ws, etc.).
WNS = peor holgura si es negativa (0 si no hay violacion); TNS = suma de holguras negativas.
El costo usa 23.000 USD por mm2 del area del DIE, lineal (enunciado, punto 3.5).
"""
import csv, glob, json, os, re, sys

USD_POR_MM2 = 23000.0
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
runs_dir = next((a for a in sys.argv[1:] if not a.startswith('--')),
                os.path.join(ROOT, 'librelane', 'runs'))


def peor(m, prefijo):
    """Menor valor entre todos los corners para una metrica (None si no existe)."""
    vals = [v for k, v in m.items() if k.startswith(prefijo + '__corner:') and isinstance(v, (int, float))]
    if not vals and isinstance(m.get(prefijo), (int, float)):
        vals = [m[prefijo]]
    return min(vals) if vals else None


def corners(m, prefijo):
    out = {}
    for k, v in m.items():
        if k.startswith(prefijo + '__corner:'):
            out[k.split('corner:')[1]] = v
    return out


def area_bbox(txt):
    try:
        x0, y0, x1, y1 = [float(t) for t in str(txt).split()]
        return (x1 - x0) * (y1 - y0)
    except Exception:
        return None


filas = []
def metricas_de(run_dir):
    """metrics.json de la carpeta final/, o, si el flujo se detuvo con error,
    las metricas del ultimo paso que alcanzo a guardarlas."""
    f = os.path.join(run_dir, 'final', 'metrics.json')
    if os.path.exists(f):
        return json.load(open(f)), 'completa'
    pasos = sorted(glob.glob(os.path.join(run_dir, '[0-9][0-9]-*', 'state_out.json')))
    for p in reversed(pasos):
        try:
            m = json.load(open(p)).get('metrics')
        except Exception:
            m = None
        if m:
            return m, 'detenida en ' + os.path.basename(os.path.dirname(p))
    return None, 'sin metricas'


for run_dir in sorted(d for d in glob.glob(os.path.join(runs_dir, '*')) if os.path.isdir(d)):
    run = os.path.basename(run_dir)
    m, estado = metricas_de(run_dir)
    if m is None:
        continue
    cfg = {}
    rpath = os.path.join(run_dir, 'resolved.json')
    if os.path.exists(rpath):
        cfg = json.load(open(rpath))
    die = area_bbox(m.get('design__die__bbox'))
    core = area_bbox(m.get('design__core__bbox'))
    fila = {
        'run': run,
        'estado': estado,
        'CLOCK_PERIOD_ns': cfg.get('CLOCK_PERIOD'),
        'FP_CORE_UTIL': cfg.get('FP_CORE_UTIL'),
        'setup_WNS_ns': peor(m, 'timing__setup__ws'),
        'setup_TNS_ns': peor(m, 'timing__setup__tns'),
        'hold_WNS_ns': peor(m, 'timing__hold__ws'),
        'hold_TNS_ns': peor(m, 'timing__hold__tns'),
        'setup_violaciones': m.get('timing__setup_vio__count'),
        'hold_violaciones': m.get('timing__hold_vio__count'),
        'celdas': m.get('design__instance__count'),
        'area_celdas_um2': m.get('design__instance__area'),
        'utilizacion_%': (m.get('design__instance__utilization') or 0) * 100 if m.get('design__instance__utilization') is not None else None,
        'area_core_um2': core,
        'area_die_um2': die,
        'area_die_mm2': die / 1e6 if die else None,
        'costo_USD': die / 1e6 * USD_POR_MM2 if die else None,
        'DRC_klayout': m.get('klayout__drc_error__count'),
        'DRC_magic': m.get('magic__drc_error__count'),
        'LVS_errores': m.get('design__lvs_error__count'),
        'antena_nets': m.get('antenna__violating__nets'),
        'antena_pines': m.get('antenna__violating__pins'),
        'potencia_W': m.get('power__total'),
    }
    filas.append(fila)
    por_corner = {'setup_ws': corners(m, 'timing__setup__ws'), 'hold_ws': corners(m, 'timing__hold__ws'),
                  'setup_tns': corners(m, 'timing__setup__tns'), 'hold_tns': corners(m, 'timing__hold__tns')}
    fila['_corners'] = por_corner

if not filas:
    print(f'No encontre corridas con metricas en {runs_dir}'); sys.exit(1)

cols = [c for c in filas[0] if not c.startswith('_')]
out_csv = os.path.join(ROOT, 'librelane', 'resumen_corridas.csv')
with open(out_csv, 'w', newline='', encoding='utf-8') as f:
    w = csv.DictWriter(f, fieldnames=cols, extrasaction='ignore')
    w.writeheader(); w.writerows(filas)


def fmt(v):
    if v is None: return '-'
    if isinstance(v, float): return f'{v:.4g}'
    return str(v)


for fila in filas:
    print(f"\n== {fila['run']} ==")
    for c in cols[1:]:
        print(f'  {c:20s} {fmt(fila[c])}')
    for nombre, d in fila['_corners'].items():
        if d:
            print(f'  {nombre}:')
            for k, v in sorted(d.items()):
                print(f'      {k:40s} {fmt(v)}')
print(f'\nTabla escrita en {out_csv}')
