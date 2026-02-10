---
name: js-client-context
description: |
  Activate this skill whenever working with Netflix UI code using Hawkins.
  Keywords:
  - Javascript
  - Hawkins, @hawkins/components, @hawkins/variables, @hawkins/assets
  - React, TypeScript, CSS variables
  - Jetpack component, Needlecast
  - appconfig.yaml, .newt.yml with app-type: needlecast or jetpack
  - llm-context, context.md
  - Design system, UI components
user-invocable: false
allowed_tools: mcp__NECP
---

# Hawkins Design System

## Netflix Engineering Context

Use the `get-netflix-engineering-context` tool to get Netflix-specific information about:
- Hawkins component usage and best practices
- React patterns for Netflix UI development
- Accessibility requirements for Netflix applications

## Overview

Hawkins is Netflix's internal design system. Hawkins package names use the `@hawkins` scope (e.g., `@hawkins/components`).

### When to Use Hawkins

When building UI inside a Jetpack component, first check if the component has Hawkins packages installed. If Hawkins is installed, you MUST use Hawkins to build your UI unless instructed otherwise.

Hawkins packages provide React components, CSS files, and other utilities.

### Learning Hawkins Packages

Before using a Hawkins package, you MUST learn how to use it first.

To find a Hawkins package's directory:
1. First, look inside `node_modules` at the root of the Jetpack component
2. If not found there, look inside `node_modules` at the repo root

### Package Guidelines

- View package exports by looking inside the `lib` folder (e.g., `node_modules/@hawkins/components/lib`)
- Find component props in TypeScript definition files (e.g., `node_modules/@hawkins/components/lib/button/button.interface.d.ts`)

**Core packages:**

| Package | Contents |
|---------|----------|
| `@hawkins/components` | Core React components |
| `@hawkins/variables` | CSS variables (see `lib/css` directory) |
| `@hawkins/assets` | Icons, pictograms, and emojis |

**Important:** NEVER use the Hawkins `Box` component. It is unnecessary and has poor performance.

### Using LLM Context Files

If a Hawkins package directory contains an `llm-context` folder, use it to learn about the package:

- If the folder contains only one file or an `index.context.md` file, read it for important package information, and for a list of available components
- Component-specific files are named `${COMPONENT_NAME}.context.md` (camelCase)
  - Example: `node_modules/@hawkins/components/llm-context/button.context.md`
- Before using any Hawkins component, you MUST read its context file if one exists

**Important:** `Grep` or `Glob` might return empty results due to `node_modules` being gitignored. Use `LS` and `Read` to explore instead.
