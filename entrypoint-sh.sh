#!/bin/sh
set -o errexit
set -o nounset

COMMAND="${1}"
EXTRA_PATH="${2}"

export PATH="${EXTRA_PATH}:${PATH}"

echo "PATH: ${PATH}"

echo "Current directory: $(pwd)"
ls -alrth

echo "Executing command: ${COMMAND}"
sh -c "${COMMAND}"
