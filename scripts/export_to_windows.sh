#!/bin/bash
# Copia logs, reportes y metricas (sin archivos enormes) de las corridas de LibreLane
# a la carpeta de Windows, para poder revisarlos desde alli.
#   WIN=/mnt/c/Users/felip/Downloads/Proyecto_3_Arquitectura/pochoco_asic scripts/export_to_windows.sh
. "$(dirname "$0")/env.sh"
WIN=${WIN:-/mnt/c/Users/felip/Downloads/Proyecto_3_Arquitectura/pochoco_asic}
DEST="$WIN/resultados_librelane"
mkdir -p "$DEST"
cd "$ROOT/librelane"
find . -path '*/runs/*' -type f \( -name '*.log' -o -name '*.rpt' -o -name '*.json' -o -name '*.csv' \
  -o -name '*.v' -o -name '*.sdc' -o -name '*.png' -o -name '*.txt' -o -name '*.yaml' -o -name '*.lib' \) \
  -size -20M -print0 | while IFS= read -r -d '' f; do
    mkdir -p "$DEST/$(dirname "$f")"; cp -u "$f" "$DEST/$f"
done
[ -f resumen_corridas.csv ] && cp resumen_corridas.csv "$DEST/"
echo "Copiado a $DEST"
