#!/bin/sh
set -o errexit
set -o nounset

COMMAND="${1}"

echo "PATH: ${PATH}"

echo "Current directory: $(pwd)"
ls -alrth

echo "Executing command: ${COMMAND}"
sh -c "${COMMAND}"
