# AGENTS

Quick orientation and cluster-specific setup for this `sam-3d-objects` fork.

## Repo overview
- Model: SAM 3D Objects (single image -> 3D geometry/texture/layout).
- Primary docs: `README.md`, `doc/setup.md`, `SAM3D_SETUP_NOTES.md`.
- Cluster helpers live in `repro/` (scripts for reproducible runs on this cluster).

## Cluster requirements
- Linux platform `linux-64`.
- NVIDIA GPU with >= 32 GB VRAM (A6000 preferred).
- Build/install on a GPU node to avoid PyTorch3D CPU-only builds.

## Recommended Slurm allocation
```
salloc -p a6000 --gres=gpu:1 --cpus-per-task=8 --mem=32G --time=02:00:00
srun --pty bash
```

## Environment setup (mamba)
```
cd /path/to/sam-3d-objects

mamba env create -f environments/default.yml
mamba activate sam3d-objects

export PIP_EXTRA_INDEX_URL="https://pypi.ngc.nvidia.com https://download.pytorch.org/whl/cu121"
pip install -e '.[dev]'
pip install -e '.[p3d]'

export PIP_FIND_LINKS="https://nvidia-kaolin.s3.us-east-2.amazonaws.com/torch-2.5.1_cu121.html"
pip install -e '.[inference]'

./patching/hydra
```

## Hugging Face checkpoints
Access is required for `facebook/sam-3d-objects`.
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

## Sanity checks
```
nvidia-smi
mamba info | rg "platform|platforms"

python - <<'PY'
import torch
print("cuda:", torch.cuda.is_available())
if torch.cuda.is_available():
    print(torch.cuda.get_device_name(0))
PY
```

## Quick run
```
python demo.py
```
