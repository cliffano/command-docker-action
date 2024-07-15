#!/bin/bash
set -o errexit
set -o nounset

COMMAND="${1}"

echo "Executing command: ${COMMAND}"
bash -c "${COMMAND}"
