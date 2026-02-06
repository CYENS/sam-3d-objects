#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

# command to run inside container
CMD="${*:-bash}"

apptainer exec --nv --cleanenv \
  --bind "${BASE}:${BASE}" \
  --bind "${SCRATCH}:${SCRATCH}" \
  "${SIF}" bash -lc "
    set -euo pipefail

    export HOME="\${HOME}"

    export SCRATCH='${SCRATCH}'
    export XDG_CACHE_HOME='${XDG_CACHE_HOME}'
    export HF_HOME='${HF_HOME}'
    export TORCH_HOME='${TORCH_HOME}'
    export TMPDIR='${TMPDIR}'

    export MAMBA_ROOT_PREFIX='${MAMBA_ROOT_PREFIX}'
    export MAMBA_PKGS_DIRS='${MAMBA_PKGS_DIRS}'
    export CONDA_PKGS_DIRS='${CONDA_PKGS_DIRS}'

    export PATH='${SCRATCH}/bin':/usr/local/cuda/bin:\$PATH
    export CUDA_HOME=/usr/local/cuda
    export CUDACXX=/usr/local/cuda/bin/nvcc
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:\${LD_LIBRARY_PATH:-}

    # Make conda env libs visible at runtime (critical for open3d/kaolin/etc.)
    ENV_PREFIX=\$(micromamba run -n sam3d-objects python -c 'import sys; print(sys.prefix)')
    export LD_LIBRARY_PATH=\"\$ENV_PREFIX/lib:\$LD_LIBRARY_PATH\"

    export TORCH_CUDA_ARCH_LIST='${TORCH_CUDA_ARCH_LIST}'
    export SAM3D_HF_DIR='${SAM3D_HF_DIR}'

    cd '${REPO}'
    ${CMD}
  "
