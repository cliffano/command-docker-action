<img align="right" src="https://raw.github.com/cliffano/command-docker-action/master/avatar.jpg" alt="Avatar"/>

[![Build Status](https://github.com/cliffano/command-docker-action/workflows/CI/badge.svg)](https://github.com/cliffano/command-docker-action/actions?query=workflow%3ACI)
<br/>

Command Docker GitHub Action
----------------------------

A simple GitHub Action for running a shell command in a loop against a list of items.

The items are comma and/or space-separated strings. Each item can be referenced in the command using `$ITEM`.

Usage
-----

Looping through a space-separated list of items:

    jobs:
      build:
        steps:
          - name: 'Execute uname -a via latest Ubuntu Docker container'
            uses: cliffano/command-docker-action@main
            with:
              command: 'uname -a'
              docker_image: 'ubuntu:latest'

Configuration
-------------

| Input | Type | Description | Required | Default | Example |
|-------|------|-------------|----------|---------|---------|
| command | string | Shell command to run in a loop, each run can access an item from the list via $ITEM | Yes | |  `uname -a` |
| docker_image | string | Comma and/or space-separated list of items, or custom delimiters | Yes | | `ubuntu:latest` |
