---
name: js-context
description: |
  Activate this skill whenever working with a Netflix Jetpack project.
  Keywords:
  - Javascript
  - Jetpack, appconfig.yaml
  - NodeQuark, Needlecast
  - Newt with app-type: jetpack
  - componentPath, component type
user-invocable: false
allowed_tools: mcp__NECP
---

# Jetpack Projects

## Netflix Engineering Context

Use the `get-netflix-engineering-context` tool to get Netflix-specific information about:
- Jetpack project configuration and deployment
- NodeQuark and Needlecast component patterns
- UI Paved Road (UIPR) best practices
- Spinnaker deployment pipelines

## Overview

A Jetpack project is a JavaScript monorepo that may contain one or more applications. Each application may contain one or more Jetpack components.

## Project Configuration

### appconfig.yaml

The config for a Jetpack project lives in `appconfig.yaml` at the repo root.

| Key | Description |
|-----|-------------|
| `apps` | Lists the applications in the project |

**Within each application entry:**

| Key | Description |
|-----|-------------|
| `stacks` | Environments the application is deployed to |
| `externalServices` | External services the application can call |
| `components` | Jetpack components in the application |

**Within each component entry:**

| Key | Description |
|-----|-------------|
| `type` | The component type (e.g., `needlecast`, `nodequark`) |
| `componentPath` | Relative path to the component's codebase from repo root |

### .newt.yml (Project Root)

The `.newt.yml` file at the repo root contains project-level information:

| Key | Description |
|-----|-------------|
| `spinnaker-app` | Project's Spinnaker app ID |
| `team-email` | Email address of the owning team |

**Spinnaker link format:** `https://go.netflix.com/spin/${spinnaker-app}`

### .newt.yml (Component Root)

Each Jetpack component's codebase root also has a `.newt.yml` file:

| Key | Description |
|-----|-------------|
| `spinnaker-app` | Component's Spinnaker app ID |

**Spinnaker link format:** `https://go.netflix.com/spin/${spinnaker-app}`

## Component Types

- **needlecast** — Client-side rendered components (browser)
- **nodequark** — Server-side rendered components (Node.js)

## Project Structure

```
jetpack-project/
├── appconfig.yaml          # Project configuration
├── .newt.yml               # Project-level Newt config
├── package.json            # Root package.json
├── components/
│   └── my-component/
│       ├── .newt.yml       # Component-level Newt config
│       ├── package.json
│       └── src/
└── ...
```
