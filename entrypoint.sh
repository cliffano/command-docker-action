#!/bin/sh
set -o errexit
set -o nounset

COMMAND="${1}"

echo "Executing command: ${COMMAND}"
sh -c "${COMMAND}"
