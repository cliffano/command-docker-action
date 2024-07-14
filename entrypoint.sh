#!/bin/sh
set -o errexit
set -o nounset

COMMAND="${2}"

echo "Executing command: ${COMMAND}"
sh -c "${COMMAND}"
