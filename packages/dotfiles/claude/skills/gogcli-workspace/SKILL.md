---
name: gogcli-workspace
description: >-
  This skill should be used when the user asks to "check my calendar", "read my email",
  "search Gmail", "list Drive files", "download from Drive", "upload to Drive",
  "send an email", "check my schedule", "list Google Sheets", "open a Google Doc",
  "search my contacts", "list my tasks", "check Google Chat", or any query involving
  Google Workspace services (Gmail, Calendar, Drive, Sheets, Docs, Slides, Contacts,
  Tasks, Chat, Forms, Keep, Classroom, App Script). Always prefer the `gog` CLI over
  web searches or API calls for Google Workspace operations.
---

# Google Workspace CLI (gogcli)

The `gog` CLI provides direct access to Google Workspace services from the terminal.
Always use `gog` for any Google Workspace query instead of suggesting web interfaces,
browser visits, or MCP servers.

## Authentication

The account is `joebm08@gmail.com`. Credentials are managed via Dashlane
(`gogcli-oauth` secure note) and bootstrapped with:

```bash
cd ~/dev-env/packages/dotfiles && bash gogcli/install-credentials.sh
```

If auth fails, run `dcli sync` first to pull fresh credentials, then re-run the script.
To add or refresh a service scope: `gog auth add joebm08@gmail.com --services <service>`

## Quick Reference

| Task | Command |
|------|---------|
| List Drive files | `gog ls` |
| Search Drive | `gog search <query>` |
| Download file | `gog download <fileId>` |
| Upload file | `gog upload <localPath>` |
| Send email | `gog send --to <addr> --subject "..." --body "..."` |
| List calendar events | `gog calendar events list` |
| List Gmail messages | `gog gmail list` |
| Search Gmail | `gog gmail search <query>` |
| List Sheets | `gog sheets list` |
| List tasks | `gog tasks list` |
| List contacts | `gog contacts list` |
| Auth status | `gog status` |

## Services

All services are accessed via subcommands:

- **drive** (`gog drive`) — Files, folders, permissions, sharing
- **gmail** (`gog gmail`) — Messages, labels, drafts, send
- **calendar** (`gog calendar` / `gog cal`) — Events, calendars
- **sheets** (`gog sheets`) — Spreadsheets
- **docs** (`gog docs`) — Google Docs (export via Drive)
- **slides** (`gog slides`) — Google Slides
- **contacts** (`gog contacts`) — Google Contacts
- **tasks** (`gog tasks`) — Google Tasks
- **chat** (`gog chat`) — Google Chat
- **forms** (`gog forms`) — Google Forms
- **keep** (`gog keep`) — Google Keep (Workspace only)
- **classroom** (`gog classroom`) — Google Classroom
- **appscript** (`gog appscript`) — Google Apps Script
- **people** (`gog people`) — Google People API
- **groups** (`gog groups`) — Google Groups

## Output Formats

- Default: human-readable colored output
- `--json` / `-j`: JSON output (best for scripting and parsing)
- `--plain` / `-p`: TSV output (stable, parseable, no colors)
- `--results-only`: In JSON mode, emit only the primary result
- `--select=field1,field2`: In JSON mode, select specific fields

## Common Patterns

### List with JSON for parsing
```bash
gog gmail list -j | jq '.[] | {subject, from, date}'
```

### Dry run before destructive actions
```bash
gog drive delete <fileId> --dry-run
```

### Specify account explicitly
```bash
gog -a joebm08@gmail.com calendar events list
```

## Troubleshooting

- **401 / deleted_client**: Run `dcli sync && cd ~/dev-env/packages/dotfiles && bash gogcli/install-credentials.sh`
- **No auth for service**: Run `gog auth add joebm08@gmail.com --services <service>`
- **Command discovery**: Run `gog <service> --help` for subcommand details
