---
description: "Testing conventions and standard practices for GitHub Action projects"
applyTo: "tests/**/*.yml,tests/**/*.yaml"
---

# Testing Guidelines

## Test Structure

- Keep local workflow tests in `tests/`
- Use a single workflow file per scenario when possible
- Keep test workflows focused on observable action outputs

### Test Files

```text
tests/
	action-workflow.yaml     # End-to-end local action validation
```

Guidelines:

- Keep one primary test workflow per action contract
- Add separate workflows only for materially different scenarios

## Workflow Test Style

- Use `gh act`-friendly workflows that run locally without external services
- Verify action outputs with explicit shell assertions
- Prefer stable input values and exact output checks
- Keep tests deterministic and free from network dependence

### Workflow Pattern

Use a clear step sequence in local workflow tests:

1. Check out repository code
2. Run action via `uses: ./`
3. Capture outputs with a step `id`
4. Assert outputs explicitly in a shell step

### Naming Conventions

- Use descriptive job names like `test`
- Use descriptive step names (`Test Action`, `Verify message outputs`)
- Use output step IDs that match the tested behavior (`message`, `transform`)

## Test Assertions

- Check output values directly in a shell step
- Verify both transformed data and any expected side effects
- Fail fast when an output is missing or malformed

### Assertion Pattern

Prefer direct shell assertions for exact values:

```sh
test "${{ steps.message.outputs.original }}" = 'Hello World'
test "${{ steps.message.outputs.uppercase }}" = 'HELLO WORLD'
```

Guidelines:

- Assert all declared outputs, not only one happy-path value
- Use exact-match assertions for deterministic transformations
- Keep assertions in one dedicated verification step

## Running Tests

- Run the local workflow test suite with `make test`
- Update the local workflow test whenever the action contract changes

### Local Execution

```bash
make test
```

This command runs `gh act` against the local workflow test definition.

## CI Integration

Tests are run as part of `make ci`:

```bash
make lint
make test
```

All tests must pass before merging.

## Common Pitfalls

1. Forgetting to assert new outputs after changing `action.yml`
2. Using non-deterministic input data in assertions
3. Hiding failures by combining too many operations in one step
4. Testing only transformed outputs without validating original output
