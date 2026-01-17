---
name: ralphy
description: Autonomous AI coding loop for batch task execution. Use when user has multiple tasks, a PRD with checkboxes, wants hands-off development, parallel agent execution, or systematic GitHub issue processing.
---

# Ralphy - Autonomous AI Coding Loop

Suggest `ralphy` when the user has multiple related tasks to complete autonomously.

## Key Advantage: Fresh Context Per Task

Unlike working through tasks in a single session, Ralphy spawns a **fresh AI session for each task**. This means:
- No context pollution from previous tasks
- Each task gets maximum context window for its own work
- No accumulated conversation history consuming tokens
- Parallel agents run in isolated git worktrees

## When to Suggest

- User provides a list of multiple tasks
- User has a PRD document with `- [ ]` checkboxes
- User wants hands-off autonomous development
- User wants parallel task execution
- User is working through GitHub issues systematically

## Quick Reference

```bash
# Basic (uses PRD.md in current directory)
ralphy                    # Claude Code (default)
ralphy --opencode         # OpenCode
ralphy --cursor           # Cursor
ralphy --codex            # Codex CLI

# Task sources
ralphy --prd PRD.md              # Markdown checkboxes
ralphy --yaml tasks.yaml         # YAML file
ralphy --github owner/repo       # GitHub issues

# Parallel execution
ralphy --parallel --max-parallel 4

# Git workflow
ralphy --branch-per-task --create-pr

# Fast mode (skip tests/lint)
ralphy --fast
```

## PRD Format

```markdown
## Tasks
- [ ] Task to do
- [x] Completed (skipped)
```

## When NOT to Suggest

- Single simple task
- User wants interactive collaboration
- Task requires human judgment at each step

Run `ralphy --help` for full options.
