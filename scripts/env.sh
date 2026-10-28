# Comun a todos los scripts. Ajusta LIBRELANE si lo instalaste distinto.
#   Docker (por defecto): LibreLane en contenedor, con el PDK que instalo ciel en ~/.ciel
#   Nix:     entrar antes con `nix-shell` (o `nix develop`) y dejar el valor por defecto
LIBRELANE=${LIBRELANE:-"python3 -m librelane --docker-no-tty --dockerized --pdk gf180mcuD --pdk-root $HOME/.ciel"}
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
RUNS=${RUNS:-$ROOT/librelane/runs}
mkdir -p "$RUNS"
