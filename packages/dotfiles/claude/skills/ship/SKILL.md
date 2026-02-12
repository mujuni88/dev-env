---
name: ship
description: Commit all changes and push to remote
disable-model-invocation: true
allowed-tools: Bash
argument-hint: [commit message]
---

# Commit and Push

1. Run `git status` and `git diff` to review all changes
2. If there are no changes to commit, inform the user and stop
3. If $ARGUMENTS is provided, use it as the commit message
4. If no arguments, analyze the changes and generate a commit message following conventional commit format (feat, fix, chore, etc.)
5. Stage all changes with `git add -A`
6. Commit with the message
7. Push to remote
8. Report the result
