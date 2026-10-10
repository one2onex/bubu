#!/usr/bin/env bash
# shellcheck disable=2046

set -e

if [ $# -ne 1 ]; then
	echo "Usage: $0 <preset>"
	cmake --list-presets
	exit 1
fi

if [[ "$(uname -s)" == "Darwin" ]]; then
    CPU_CORES=$(sysctl -n hw.ncpu)
else
    CPU_CORES=$(nproc)
fi

PRESET=$1

cmake --preset "$PRESET"
cmake --build --parallel "$CPU_CORES" --preset "$PRESET"