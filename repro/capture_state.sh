#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

mkdir -p "${REPO}/repro/state"

# repo revision
git -C "${REPO}" rev-parse HEAD > "${REPO}/repro/state/git_commit.txt"
git -C "${REPO}" status --porcelain > "${REPO}/repro/state/git_dirty.txt" || true

# container fingerprint
sha256sum "${SIF}" > "${REPO}/repro/state/container.sha256"
apptainer inspect "${SIF}" > "${REPO}/repro/state/container.inspect.txt" || true

# environment package locks
./repro/container_exec.sh "
  ENV_PREFIX=\$(micromamba run -n sam3d-objects python -c 'import sys; print(sys.prefix)')
  echo \"ENV_PREFIX=\$ENV_PREFIX\" > repro/state/env_prefix.txt

  micromamba list -n sam3d-objects > repro/state/micromamba_list.txt
  micromamba list -n sam3d-objects --explicit > repro/state/micromamba_explicit.txt

  micromamba run -n sam3d-objects python -m pip freeze > repro/state/pip_freeze.txt

  nvidia-smi > repro/state/nvidia-smi.txt || true
  nvcc --version > repro/state/nvcc.txt || true
  ldd --version | head -n 1 > repro/state/glibc.txt || true
"
