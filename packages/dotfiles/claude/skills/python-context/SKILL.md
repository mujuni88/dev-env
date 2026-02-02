---
name: python-context
description: |
  Activate this skill whenever working with a Python Netflix project.
  Keywords:
  - Python, .py files
  - pyproject.toml, setup.py, setup.cfg
  - requirements.in, requirements.txt
  - tox, tox.ini, pytest, pytest-cov, pytest-mock, hypothesis
  - newt venv, newt tox, newt deps
  - uv, pydepot, PyPI
  - nflxconfig, nflxlog, nflxtrace, spectator-py
  - conftest.py, NXCONF.set_ci()
  - Newt with app-type: python
user-invocable: false
allowed_tools: mcp__NECP
---

# Python Development

## Netflix Engineering Context

Use the `get-netflix-engineering-context` tool to get Netflix-specific information about:
- Python project setup and paved path patterns
- Netflix Python libraries (nflxconfig, nflxlog, nflxtrace, spectator-py)
- Testing best practices and patterns
- Dependency management with newt and uv

## General Rules

These rules SHOULD ALWAYS BE FOLLOWED BY DEFAULT unless instructed otherwise by the user. If you notice a project is not following these rules, recommend them to follow these rules, but DO NOT AUTOMATICALLY CHANGE CODE to enforce them.

## Project Setup

- If no Python version is specified, use at least Python 3.10
- Write docstrings for modules, classes, and widely used functions
- Use the Google docstring format for all docstrings

## Dependency Management

- Define dependencies and their constraints in `requirements.in` files
- DO NOT use exact version pins in `requirements.in`
- Add and remove dependencies through `requirements.in`, not `requirements.txt`
- DO NOT publish packages to public PyPI—use the internal PyPI mirror (pydepot) through Jenkins

## Tooling

Use Netflix-specific `newt` commands instead of generic tools:

| Command | Purpose |
|---------|---------|
| `newt venv` | Create virtual environments and install dependencies |
| `newt tox` | Run tests (accepts standard tox CLI options) |
| `newt deps lock` | Generate `requirements.txt` lockfile from `requirements.in` |
| `newt deps lock --upgrade` | Regenerate lockfile with upgraded dependencies |

**DO NOT use:**
- `poetry`
- `anaconda`, `conda`, or `miniconda` (recommend switching to Miniforge or `conda-forge`)

If `newt` commands do not work, use `uv` as a fallback.

## Third-Party Code

Third-party code lives in `.tox`, `.venv`, or `site-packages` directories. ONLY read this code if you are unsure how to use it. NEVER read it for patterns to emulate.

## Testing

Use `pytest` for all tests. Run tests with `newt tox`, which uses tox under the hood (configured in `tox.ini`).

For finer-grained control, activate the virtualenv and run pytest directly:
```bash
pytest -k metadata  # run only tests with "metadata" in name
```

### Test Structure

- Place tests under `tests/` directory at project root
- Name files `test_<module_or_behavior>.py`
- Prefer names like `test_<function>_with_<scenario>_expects_<result>`
- Small/medium repos: keep tests flat at `tests/` root
- Large repos: mirror the source tree (e.g., `tests/pkg/subpkg/test_module.py`)

Example layout:
```
project/
├── src/
├── tests/
│   ├── conftest.py
│   ├── requirements.in
│   ├── requirements.txt
│   └── test_foo.py
└── tox.ini
```

### Test Rules

- Tests must be comprehensive—cover typical cases and edge cases
- Each test must verify a DISTINCT behavior
- Use Arrange-Act-Assert (AAA) pattern
- Use simple `assert` statements with introspected values
- Prefer `@pytest.mark.parametrize` for data-driven cases
- Favor behavior-focused assertions over implementation details

### conftest.py

Set the environment to CI at the start of the test session:

```python
# tests/conftest.py
from nflxconfig import NXCONF

NXCONF.set_ci()
```

Use `conftest.py` for:
- Centralized shared fixtures and factory helpers
- Session-level setup/teardown
- pytest configuration, marks, or plugin hooks

### Test Dependencies

Declare test-only dependencies in `tests/requirements.in`:
- pytest plugins, `pytest-cov`, `pytest-mock`, `freezegun`, `responses`, `hypothesis`, `runez`

### Coverage

Use `pytest-cov` via tox. Aim for 80%+ coverage but focus on meaningful tests—test critical business logic and edge cases, not just for percentage.

```bash
coverage report --show-missing  # view coverage results
```

### Anti-Patterns

1. DO NOT test implementation details instead of behavior
2. DO NOT create interdependent tests that must run in a specific order
3. DO NOT use multiple assertions for unrelated concerns in one test
4. DO NOT mock everything—it creates brittle tests tightly coupled to implementation
5. DO NOT test framework code or third-party libraries

## Dependency Injection vs Mocking

**Use Dependency Injection by default.** If you can inject a real/fake, do it.

Use mocks only when:
- Interaction is the behavior under test (retries/backoff, callbacks, logging/metrics)
- A fake is too costly to create

DO NOT mock:
- Pure functions or types you own that are cheap to run
- Integration/system tests—use real services (e.g., Testcontainers) when possible

### Mocking Best Practices

When mocking is necessary:
- Patch where used (in the module where the function is imported, not where defined)
- Use `autospec=True` to limit the mock's interface
- Assert your mock—use assertion methods on `Mock` to verify calls

```python
def test_something(mocker):
    mock_expensive_fn = mocker.patch("my_module.expensive", autospec=True)
    # ... test code ...
    mock_expensive_fn.assert_called()
```

## Testcontainers

Use Testcontainers for integration/system tests needing real services (databases, Redis, Elasticsearch).

- Add `testcontainers[...]` extras to `tests/requirements.in`
- Manage containers via session/module fixtures with proper teardown
- Prefer session-scoped fixtures to avoid per-test container churn

```python
@pytest.fixture(scope="session", autouse=True)
def setup_containers():
    pg = PostgresContainer(username="user", password="pass", dbname="db").with_bind_ports(5432, 5433)
    with pg:
        yield
```
