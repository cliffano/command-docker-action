#!/usr/bin/env bash
set -o errexit
set -o nounset

printf "\n\n========================================\n"
printf "Run workflow with action\n"
cd .. && gh act -P ubuntu-24.04=catthehacker/ubuntu:act-latest -W examples/command-docker-action-workflow.yaml