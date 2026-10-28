#!/bin/bash
# Corta la corrida de la estrategia 2 (final_mem_ff) si sigue activa pasadas N horas.
# Solo toca el contenedor de esa corrida: las demas (barridos) no se ven afectadas.
#   nohup scripts/watchdog_mem_ff.sh 4 > watchdog.log 2>&1 &      (4 = horas de espera)
HORAS=${1:-4}
echo "$(date): esperando $HORAS h antes de revisar final_mem_ff"
sleep $((HORAS * 3600))
ID=$(docker ps --no-trunc --format '{{.ID}} {{.Command}}' | grep final_mem_ff | cut -d' ' -f1)
if [ -n "$ID" ]; then
  echo "$(date): final_mem_ff sigue corriendo; la detengo (contenedor $ID)"
  docker stop "$ID"
else
  echo "$(date): final_mem_ff ya habia terminado; no hago nada"
fi
