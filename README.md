<img align="right" src="https://raw.github.com/cliffano/command-docker-action/master/avatar.jpg" alt="Avatar"/>

[![Build Status](https://github.com/cliffano/command-docker-action/workflows/CI/badge.svg)](https://github.com/cliffano/command-docker-action/actions?query=workflow%3ACI)
[![Security Status](https://snyk.io/test/github/cliffano/command-docker-action/badge.svg)](https://snyk.io/test/github/cliffano/command-docker-action)
<br/>

Command Docker GitHub Action
----------------------------

A simple GitHub Action for running a shell command via a Docker container.

The command will be executed on a directory containing the GitHub repository content.

Usage
-----

Looping through a space-separated list of items:

    jobs:
      build:
        steps:
          - name: 'Execute cat /etc/*-release using default sh shell via default alpine Docker container'
            uses: cliffano/command-docker-action@main
            with:
              command: 'cat /etc/*-release'
          - name: 'Execute cat /etc/*-release using bash shell via Ubuntu 22.04 Docker container'
            uses: cliffano/command-docker-action@main
            with:
              command: 'cat /etc/*-release'
              image: ubuntu:22.04
              shell: bash
          - name: 'Execute cat /etc/*-release using bash shell via Rocky Linux 9.3 Docker container'
            uses: cliffano/command-docker-action@main
            with:
              command: 'cat /etc/*-release'
              image: rockylinux:9.3
              shell: bash
          - name: 'Display environment variables'
            uses: cliffano/command-docker-action@main
            with:
              command: 'echo GITHUB_WORKSPACE: $GITHUB_WORKSPACE, GITHUB_RUN_ID: $GITHUB_RUN_ID'
              env_vars: 'GITHUB_WORKSPACE,GITHUB_RUN_ID'

Configuration
-------------

| Input | Type | Description | Required | Default | Example |
|-------|------|-------------|----------|---------|---------|
| command | string | Shell command to be executed via a Docker container | Yes | - |  `cat /etc/*-release` |
| image | string | Docker image to be used for running the container | No | `alpine:3.20` | `ubuntu:22.04` |
| shell | string | Shell to be used for running the command | No | `sh` | `sh`, `bash` |
| env_vars | string | Comma separated environment variable names to be passed to Docker container | No | `GITHUB_WORKSPACE,GITHUB_RUN_ID` | `` |
