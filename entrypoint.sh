#!/usr/bin/env bash
set -o errexit
set -o nounset

COMMAND="${1}"

echo "Executing command: ${COMMAND}"
${!COMMAND}
