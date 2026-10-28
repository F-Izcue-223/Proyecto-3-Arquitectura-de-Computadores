#!/usr/bin/env python3
"""Compara la traza del RTL con la de la netlist (lineas que empiezan con TRACE).

Uso:  python3 compare_traces.py traza_rtl.txt traza_netlist.txt
Cada linea TRACE trae el ciclo en que cambiaron los LEDs o los displays. Si las dos
trazas son identicas, la netlist hace lo mismo que el RTL en los mismos ciclos.
"""
import sys

def leer(path):
    with open(path, encoding='utf-8', errors='replace') as f:
        return [l.strip() for l in f if l.startswith('TRACE')]

a, b = leer(sys.argv[1]), leer(sys.argv[2])
print(f'eventos RTL: {len(a)}   eventos netlist: {len(b)}')
for i, (x, y) in enumerate(zip(a, b)):
    if x != y:
        print(f'PRIMERA DIFERENCIA en el evento {i}:\n  RTL    {x}\n  NETLIST {y}')
        sys.exit(1)
if len(a) != len(b):
    print('Una traza es mas larga que la otra'); sys.exit(1)
print('TRAZAS IGUALES: mismos cambios en los mismos ciclos')
