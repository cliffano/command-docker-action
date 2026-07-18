---
description: "Code conventions and standard practices for GitHub Action projects"
applyTo: "action.yml,.github/workflows/**/*.yml,.github/workflows/**/*.yaml,examples/**/*.sh"
---

# GitHub Action Code Guidelines

## Style & Formatting

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

## Action Definition

- Keep the `action.yml` metadata complete and accurate
- Define inputs and outputs explicitly
- Keep the `runs` section simple and composable
- Use `composite` actions for projects unless the template says
  otherwise
- Keep the inline Python in `action.yml` small and focused on transformation

### Inputs and Outputs

- Use concise, stable input names in `snake_case`
- Keep output names aligned with documented behavior
- Ensure every documented output is written to `GITHUB_OUTPUT`

### Inline Python in Composite Actions

- Keep inline scripts deterministic and side effect free
- Prefer clear variable names for transformed values
- Write outputs using append mode and explicit UTF-8 encoding
- Avoid external dependencies for simple transformations

## Workflow Files

- Use descriptive workflow names and job names
- Prefer `actions/checkout` at a clear version pin
- Keep test workflows self-contained and deterministic
- Use the repository-local action via `./` in local validation workflows
- Keep workflow steps minimal and explicit

### Workflow Conventions

- Keep triggers explicit (`push`, `pull_request`, `workflow_dispatch`)
- Use pinned major versions for third-party actions
- Keep CI jobs reproducible by using known runner images
- Prefer one responsibility per step so failures are easy to diagnose

## Shell Scripts

- Prefer POSIX shell syntax for example scripts
- Make scripts safe to run repeatedly
- Keep environment assumptions documented in the script or README

## File Organization

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

## Error Handling

- Fail fast in scripts and validation steps
- Make assertion and validation failures explicit in workflow logs
- Avoid swallowing errors in inline Python blocks

## Validation

- Treat `yamllint` and `actionlint` errors as build failures
- When changing workflow structure, update the local test workflow as well
- Keep README examples aligned with action inputs and outputs
