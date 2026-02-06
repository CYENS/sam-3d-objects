#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

"$(dirname "$0")/container_exec.sh" "
  # keep pip stable + avoid packaging 25 issues
  micromamba run -n sam3d-objects python -m pip install -U 'pip==24.3.1' 'setuptools' 'wheel' 'packaging<25'

  # build backend used by the repo
  micromamba run -n sam3d-objects python -m pip install -U hatchling hatch-requirements-txt editables

  # git needed for git+https deps
  micromamba install -y -n sam3d-objects -c conda-forge git

  # runtime libs for open3d
  micromamba install -y -n sam3d-objects -c conda-forge \
    xorg-libx11 xorg-libxext xorg-libxrender xorg-libxi xorg-libxfixes xorg-libxrandr \
    libgl libegl libglu mesalib libcxx libcxxabi

  # ensure open3d extension is executable (ldd warning you saw)
  ENV_PREFIX=\$(micromamba run -n sam3d-objects python -c 'import sys; print(sys.prefix)')
  chmod a+rx \"\$ENV_PREFIX/lib/python3.11/site-packages/open3d/cpu/\"pybind*.so || true

  # install project + inference extras (build gsplat against container nvcc)
  micromamba run -n sam3d-objects python -m pip uninstall -y gsplat || true
  micromamba run -n sam3d-objects python -m pip install -v --no-build-isolation -e '.[inference]'
"
