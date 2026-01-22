#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

srun --gres=gpu:1 --mem=64G -c 8 -t 02:00:00 --pty bash -lc "
  cd '${REPO}'
  ./repro/container_exec.sh \"micromamba run -n sam3d-objects python demo.py\"
"
