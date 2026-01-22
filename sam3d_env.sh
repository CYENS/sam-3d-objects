# ---- SAM3D cluster env (caches + micromamba) ----
export LUSTRE="/lustreFS/veupnea/$USER"

# keep caches off $HOME (you only have 20GB quota there)
export XDG_CACHE_HOME="$LUSTRE/cache"
export HF_HOME="$LUSTRE/cache/huggingface"
export TORCH_HOME="$LUSTRE/cache/torch"
export PIP_CACHE_DIR="$LUSTRE/cache/pip"
export TMPDIR="$LUSTRE/tmp"

mkdir -p "$XDG_CACHE_HOME" "$HF_HOME" "$TORCH_HOME" "$PIP_CACHE_DIR" "$TMPDIR"

# micromamba
export PATH="$LUSTRE/bin:$PATH"
export MAMBA_ROOT_PREFIX="$LUSTRE/micromamba"

