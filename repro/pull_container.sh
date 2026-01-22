#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"

apptainer pull "${SIF}" docker://nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

# record immutable fingerprint
sha256sum "${SIF}" | tee "${REPO}/repro/container.sha256"
apptainer inspect "${SIF}" > "${REPO}/repro/container.inspect.txt" || true
