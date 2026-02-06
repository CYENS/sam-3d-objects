# SAM 3D Objects - Cluster Setup Notes

This document captures the findings and a complete setup flow for `sam-3d-objects` on this Slurm cluster using mamba.

## Repository Location

- Repo path: `$REPO_ROOT`

## Prerequisites (from `doc/setup.md`)

- Linux 64-bit (mamba platform `linux-64`).
- NVIDIA GPU with at least 32 GB VRAM.
- Build on a GPU node to avoid PyTorch3D "Not compiled with GPU support" errors.

## Slurm Findings

Partitions observed:

- `defq` (nodes `gpu01-08`)
- `a6000` (node `gpu09`)

GPU resources for `a6000`:

- `gpu09` has `gres=gpu:4` and is in partition `a6000`.
- Use this partition to satisfy the >= 32 GB VRAM requirement (A6000 is typically 48 GB).

## Recommended Interactive Allocation

```
salloc -p a6000 --gres=gpu:1 --cpus-per-task=8 --mem=32G --time=02:00:00
srun --pty bash
```

## Environment Setup (mamba)

From `doc/setup.md`:

```
cd $REPO_ROOT

mamba env create -f environments/default.yml
mamba activate sam3d-objects

export PIP_EXTRA_INDEX_URL="https://pypi.ngc.nvidia.com https://download.pytorch.org/whl/cu121"
pip install -e '.[dev]'
pip install -e '.[p3d]'

export PIP_FIND_LINKS="https://nvidia-kaolin.s3.us-east-2.amazonaws.com/torch-2.5.1_cu121.html"
pip install -e '.[inference]'

./patching/hydra
```

## GPU and Platform Verification

```
nvidia-smi
mamba info | rg "platform|platforms"
```

Expected:

- GPU present and visible in `nvidia-smi`.
- `platform : linux-64` in `mamba info`.

## Hugging Face Checkpoints

Access required for `facebook/sam-3d-objects`.

```
pip install 'huggingface-hub[cli]<1.0'
hf auth login

TAG=hf
hf download \
  --repo-type model \
  --local-dir checkpoints/${TAG}-download \
  --max-workers 1 \
  facebook/sam-3d-objects
mv checkpoints/${TAG}-download/checkpoints checkpoints/${TAG}
rm -rf checkpoints/${TAG}-download
```

## Sanity Check (CUDA)

```
python - <<'PY'
import torch
print("cuda:", torch.cuda.is_available())
if torch.cuda.is_available():
    print(torch.cuda.get_device_name(0))
PY
```
