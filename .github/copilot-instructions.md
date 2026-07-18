---
description: "Standard GitHub Action project conventions and tooling using Actobat"
---

# GitHub Action Project Standards

This repository contains a GitHub Action project following a unified standard
for tooling, build automation, and coding conventions. All projects share the
same conventions to keep actions consistent and maintainable.

The key components of the standard include:

- Build automation (Actobat)
- Action definition and metadata (`action.yml`)
- Workflow validation (`yamllint` + `actionlint`)
- Testing (`gh act`)
- Tooling dependencies (`pip` + `requirements.txt`)

This document outlines the common conventions that apply across the
GitHub Action projects.

## GitHub Action Version & Dependencies

- **Python Version**: 3.12+
- **Dependency Manager**: pip-tools
- **Lock File**: `requirements.txt` (generated via `pip-compile`)
- **Dependency Specification**: `requirements.in`

### Adding Dependencies

```bash
# Add the dependency to requirements.in
make deps-upgrade                 # Regenerate locked dependencies
make deps                         # Install all deps
```

## Project Structure

```text
project/
├── action.yml              # GitHub Action definition
├── actobat.yml             # Actobat configuration
├── examples/               # Example scripts and workflows
├── tests/                  # Local workflow tests
├── .github/workflows/      # CI and release workflows
├── .gitignore              # Git ignore rules
├── .rtk.json               # RTK configuration
├── .yamllint               # YAML lint configuration
├── CHANGELOG.md            # Changelog file following Keep a Changelog format
├── LICENSE                 # License file
├── Makefile                # Build automation (Actobat)
├── README.md               # Project README
└── requirements*.txt       # Python tooling dependencies
```

## Build Automation (Actobat)

This GitHub Action project uses **Actobat** as a standard build automation tool that unifies the build pipeline across all GitHub Action projects.

### Common Commands

```bash
make ci                # Run lint and test
make lint              # Run yamllint and actionlint
make test              # Run local workflow tests using gh act
make test-examples     # Run example shell scripts

### Release Targets

```bash
make release-major     # Create major release using RTK
make release-minor     # Create minor release using RTK
make release-patch     # Create patch release using RTK
```

### Update Targets

```bash
make update-to-latest  # Update Makefile to the latest Actobat release
make update-to-main    # Update Makefile to the Actobat main branch
make update-to-version # Update Makefile to a specific Actobat version
make update-dotfiles   # Refresh project dotfiles from the generator
make update-partials   # Refresh README partial snippets from the generator
```

## Development Environment

This project is designed to be developed in a consistent environment via Docker image `cliffano/studio`.

You can run the container using: `docker run --rm --workdir /opt/workspace -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/opt/workspace -i -t cliffano/studio` and then run the build commands inside the container.

Alternatively you can run the Actobat Makefile targets via Docker container entrypoint, e.g. `docker run --rm --workdir /opt/workspace -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/opt/workspace -i -t cliffano/studio make ci`.

## Code Style, Testing, and Detailed Guidance

This file keeps the high-level project defaults. Detailed implementation rules
live in scoped instruction files so they are only loaded when relevant.

### Code Style and Linting

- YAML files are validated with `yamllint`
- Workflow files are validated with `actionlint`
- Detailed GitHub Action coding rules are in
  `.github/instructions/github-action-code.instructions.md`

### Testing

- Local workflow tests live in `tests/`
- Example scripts live in `examples/`
- Run tests with `make test` and `make test-examples`
- Detailed testing rules are in `.github/instructions/testing.instructions.md`

## Continuous Integration Pipeline

The Makefile (Actobat) orchestrates standard build targets, with `make ci` running the following steps in sequence:

- clean             # 1. Clean temp files
- lint              # 2. Static analysis (yamllint + actionlint)
- test              # 3. Local workflow tests (gh act)

All steps must pass before code is merged. Developers should run `make ci` locally before pushing to ensure the CI pipeline will pass.

After the code is merged, the CI pipeline will run as GitHub CI workflow.

## Git Workflow: Branches, Commits, and Pull Requests

**Note**: These instructions apply to **local machine development only**. When working with GitHub Actions or other CI/CD environments, the git configuration and pakkunbot identity setup is not available. These steps assume you are developing on your local machine where `~/.gitconfig-pakkunbot` exists.

### Creating and Working with Feature Branches

```bash
# Create a feature branch from main
git checkout -b feature/your-feature-name

# Make your code changes, run tests locally
make ci

# Stage ALL changes (critical: never forget this step)
git -c include.path=~/.gitconfig-pakkunbot add -A

# Commit with Pakkun Pakkun identity (pakkunbot) via gitconfig override
git -c include.path=~/.gitconfig-pakkunbot commit -m "Your clear commit message"

# Push to remote
git -c include.path=~/.gitconfig-pakkunbot push
```

### Why `git add -A`

The `-A` flag ensures **all modified and new files** are staged for commit. Without it, changes can be missed (as discovered during development), causing incomplete commits and failed CI runs. Always explicitly run `git add -A` before committing.

### Pakkunbot Identity

The `git -c include.path=~/.gitconfig-pakkunbot` flag uses a separate Git configuration file (`~/.gitconfig-pakkunbot`) containing the Pakkun Pakkun bot identity (email: blah+pakkun@cliffano.com). This avoids modifying the repository's git configuration and keeps commits attributed to the bot account rather than your personal account.

**Always include this flag for all git operations** (add, commit, push, pull):

```bash
git -c include.path=~/.gitconfig-pakkunbot add -A
git -c include.path=~/.gitconfig-pakkunbot commit -m "message"
git -c include.path=~/.gitconfig-pakkunbot push
```

### Pull Request Process

1. **Push your feature branch** to the remote using the pakkunbot identity (see above).
2. **Open a pull request** on GitHub targeting `main`.
3. **Ensure all CI checks pass** (lint, tests, coverage, etc.). If any check fails, fix the issue locally and re-run `make ci`, then stage/commit/push again.
4. **Request review** from project maintainers.
5. **Merge** once approved and all checks pass.

### Common Commit Message Patterns

Use clear, imperative commit messages:

- `Fix test patch paths by avoiding command/module name collisions`
- `Add unit tests for blur-plates module`
- `Update README and example script to use categorise-orientation`
- `Remove deprecated blur-plates module and related code`

## GitHub Workflows

This repository defines the following workflows under `.github/workflows/`:

- **CI** (`ci-workflow.yaml`): Trigger: `push`, `pull_request`, and manual `workflow_dispatch`. Purpose: Runs the main quality pipeline (`make deps ci`) and publishes generated docs to GitHub Pages.

- **Release Major** (`release-major-workflow.yaml`): Trigger: Manual `workflow_dispatch`. Purpose: Creates a major release via `cliffano/release-action` (`release_type: major`).

- **Release Minor** (`release-minor-workflow.yaml`): Trigger: Manual `workflow_dispatch`. Purpose: Creates a minor release via `cliffano/release-action` (`release_type: minor`).

- **Release Patch** (`release-patch-workflow.yaml`): Trigger: Manual `workflow_dispatch`. Purpose: Creates a patch release via `cliffano/release-action` (`release_type: patch`).
