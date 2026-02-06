#!/usr/bin/env bash
set -euo pipefail

# ---- site-specific paths ----
export BASE="${HOME}/data/${USER}"
export REPO="${BASE}/projects/sam-3d-objects"

export SCRATCH_ROOT="/path/to/scratch"
export SCRATCH="${SCRATCH_ROOT}/${USER}"
export SIF="${SCRATCH}/containers/cuda121-ubuntu22.sif"

# micromamba root + packages on Lustre (avoid /trinity/home caches)
export MAMBA_ROOT_PREFIX="${SCRATCH}/micromamba"
export MAMBA_PKGS_DIRS="${SCRATCH}/micromamba/pkgs"
export CONDA_PKGS_DIRS="${SCRATCH}/micromamba/pkgs"

# caches on Lustre
export XDG_CACHE_HOME="${SCRATCH}/cache"
export HF_HOME="${SCRATCH}/cache/huggingface"
export TORCH_HOME="${SCRATCH}/cache/torch"
export SAM3D_HF_DIR="${SCRATCH}/sam3d-hf"

# optional: keep pip temp on Lustre too
export TMPDIR="${SCRATCH}/tmp"

# CUDA build target (RTX A5000)
export TORCH_CUDA_ARCH_LIST="8.6+PTX"

mkdir -p \
  "${SCRATCH}/containers" \
  "${MAMBA_ROOT_PREFIX}" "${MAMBA_PKGS_DIRS}" \
  "${XDG_CACHE_HOME}" "${HF_HOME}" "${TORCH_HOME}" \
  "${SAM3D_HF_DIR}" "${TMPDIR}"
