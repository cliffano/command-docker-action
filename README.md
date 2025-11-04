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

Run commands across Docker containers with different images and shells:

    jobs:
      build:
        steps:
          - name: 'Execute cat /etc/*-release using default sh shell via default alpine Docker container'
            uses: cliffano/command-docker-action@main
            with:
              command: 'cat /etc/*-release'
          - name: 'Execute cat /etc/*-release using bash shell via Ubuntu 24.04 Docker container'
            uses: cliffano/command-docker-action@main
            with:
              command: 'cat /etc/*-release'
              image: ubuntu:24.04
              shell: bash
          - name: 'Execute cat /etc/*-release using bash shell via Rocky Linux 9.3 Docker container'
            uses: cliffano/command-docker-action@main
            with:
              command: 'cat /etc/*-release'
              image: rockylinux:9.3
              shell: bash

Run command using environment variables passed via env file:

    jobs:
      build:
        steps:
          - uses: iamsauravsharma/create-dotenv@v2.0.1
            with:
              file-path: '/tmp/.env'
            env:
              SOME_ENV_VAR: 'Some value'
          - name: 'Display environment variables'
            uses: cliffano/command-docker-action@main
            with:
              command: 'echo "SOME_ENV_VAR: $SOME_ENV_VAR"'
              env_file: '/tmp/.env'

Run command with extra PATH environment variable:

    jobs:
      build:
        steps:
          - name: 'Run custom command from a custom path specified in extra_path'
            uses: cliffano/command-docker-action@main
            with:
              command: 'mkdir -p /opt/workspace/bin/ && touch /opt/workspace/bin/some-exec && chmod +x /opt/workspace/bin/some-exec && which some-exec'
              extra_path: '/some/path:/opt/workspace/bin'

Configuration
-------------

| Input | Type | Description | Required | Default | Example |
|-------|------|-------------|----------|---------|---------|
| command | string | Shell command to be executed via a Docker container | Yes | - |  `cat /etc/*-release` |
| image | string | Docker image to be used for running the container | No | `alpine:3.22` | `ubuntu:24.04` |
| extra_path | string | Extra PATH environment variable to be added to original PATH during shell command execution | No | `` | `/some/path:/opt/workspace/bin` |
| shell | string | Shell to be used for running the command | No | `sh` | `sh`, `bash` |
| env_file | string | Path to env file containing environment variables  made available during shell command execution | No | `` | `/tmp/.env` |

FAQ
---

Q: Why does the command that should work on my container image result in a not found error or `No such file or directory`?

A: This is because GitHub Actions overwrites the default PATH. E.g. `/snap/bin:/home/runner/.local/bin:/opt/pipx_bin:/home/runner/.cargo/bin:/home/runner/.config/composer/vendor/bin:/usr/local/.ghcup/bin:/home/runner/.dotnet/tools:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin` as of January 2025.
   The solution to this problem is to use the `extra_path` input parameter to add the required path for your command to the PATH environment variable.