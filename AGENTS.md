# AGENTS.md

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
```

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

## Code Style and Linting

Applies to: `action.yml`, `.github/workflows/**/*.yml`, `.github/workflows/**/*.yaml`, `examples/**/*.sh`

### YAML Linting

All YAML and workflow files must pass lint checks:

```bash
make lint
```

Guidelines:

- Use two-space indentation in YAML files
- Keep mappings and sequences consistent and readable
- Quote strings when they contain special characters or shell fragments
- Prefer explicit keys over compact YAML that hides intent

### Workflow Static Analysis

Workflow files should produce zero `actionlint` error and warning:

```bash
make lint
```

Guidelines:

- Prefer explicit `shell` declarations for `run` steps
- Keep workflow expressions readable and simple
- Fix root causes before adding workarounds

### Action Definition

- Keep the `action.yml` metadata complete and accurate
- Define inputs and outputs explicitly
- Keep the `runs` section simple and composable
- Use `composite` actions for projects unless the template says
  otherwise
- Keep the inline Python in `action.yml` small and focused on transformation

#### Inputs and Outputs

- Use concise, stable input names in `snake_case`
- Keep output names aligned with documented behavior
- Ensure every documented output is written to `GITHUB_OUTPUT`

#### Inline Python in Composite Actions

- Keep inline scripts deterministic and side effect free
- Prefer clear variable names for transformed values
- Write outputs using append mode and explicit UTF-8 encoding
- Avoid external dependencies for simple transformations

### Workflow Files

- Use descriptive workflow names and job names
- Prefer `actions/checkout` at a clear version pin
- Keep test workflows self-contained and deterministic
- Use the repository-local action via `./` in local validation workflows
- Keep workflow steps minimal and explicit

#### Workflow Conventions

- Keep triggers explicit (`push`, `pull_request`, `workflow_dispatch`)
- Use pinned major versions for third-party actions
- Keep CI jobs reproducible by using known runner images
- Prefer one responsibility per step so failures are easy to diagnose

### Shell Scripts

- Prefer POSIX shell syntax for example scripts
- Make scripts safe to run repeatedly
- Keep environment assumptions documented in the script or README

### File Organization

Typical layout for generated action projects:

```text
project/
├── action.yml
├── .github/workflows/
├── tests/
└── examples/
```

Guidelines:

- Keep action contract in `action.yml`
- Keep CI and release logic in `.github/workflows/`
- Keep local workflow validation scenarios in `tests/`
- Keep user-facing usage examples in `examples/`

### Error Handling

- Fail fast in scripts and validation steps
- Make assertion and validation failures explicit in workflow logs
- Avoid swallowing errors in inline Python blocks

### Validation

- Treat `yamllint` and `actionlint` errors as build failures
- When changing workflow structure, update the local test workflow as well
- Keep README examples aligned with action inputs and outputs

## Testing

Applies to: `tests/**/*.yml`, `tests/**/*.yaml`

- Local workflow tests live in `tests/`
- Example scripts live in `examples/`
- Run tests with `make test` and `make test-examples`

### Test Structure

- Keep local workflow tests in `tests/`
- Use a single workflow file per scenario when possible
- Keep test workflows focused on observable action outputs

#### Test Files

```text
tests/
	action-workflow.yaml     # End-to-end local action validation
```

Guidelines:

- Keep one primary test workflow per action contract
- Add separate workflows only for materially different scenarios

### Workflow Test Style

- Use `gh act`-friendly workflows that run locally without external services
- Verify action outputs with explicit shell assertions
- Prefer stable input values and exact output checks
- Keep tests deterministic and free from network dependence

#### Workflow Pattern

Use a clear step sequence in local workflow tests:

1. Check out repository code
2. Run action via `uses: ./`
3. Capture outputs with a step `id`
4. Assert outputs explicitly in a shell step

#### Naming Conventions

- Use descriptive job names like `test`
- Use descriptive step names (`Test Action`, `Verify message outputs`)
- Use output step IDs that match the tested behavior (`message`, `transform`)

### Test Assertions

- Check output values directly in a shell step
- Verify both transformed data and any expected side effects
- Fail fast when an output is missing or malformed

#### Assertion Pattern

Prefer direct shell assertions for exact values:

```sh
test "${{ steps.message.outputs.original }}" = 'Hello World'
test "${{ steps.message.outputs.uppercase }}" = 'HELLO WORLD'
```

Guidelines:

- Assert all declared outputs, not only one happy-path value
- Use exact-match assertions for deterministic transformations
- Keep assertions in one dedicated verification step

### Running Tests

- Run the local workflow test suite with `make test`
- Update the local workflow test whenever the action contract changes

#### Local Execution

```bash
make test
```

This command runs `gh act` against the local workflow test definition.

### CI Integration

Tests are run as part of `make ci`:

```bash
make lint
make test
```

All tests must pass before merging.

### Common Pitfalls

1. Forgetting to assert new outputs after changing `action.yml`
2. Using non-deterministic input data in assertions
3. Hiding failures by combining too many operations in one step
4. Testing only transformed outputs without validating original output

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

The `git -c include.path=~/.gitconfig-pakkunbot` flag uses a separate Git configuration file (`~/.gitconfig-pakkunbot`) containing the Pakkun Pakkun bot identity (email: pakkunbot@users.noreply.github.com). This avoids modifying the repository's git configuration and keeps commits attributed to the bot account rather than your personal account.

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
