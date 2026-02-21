---
name: gdrive-notes
description: Extracts lecture-note PDFs from Google Drive, downloads page images, and converts them to Obsidian markdown under Week NN with topic-based filenames. Use when the user runs /gdrive-notes sync, process, or status, or when processing Drive lecture PDFs for the System Design Masterclass.
---

# GDrive Lecture Notes Skill

Extract lecture-note PDFs from Google Drive and convert them to Obsidian markdown notes under the correct **Week NN** folder with **topic-based** filenames. Pre-reads and post-reads are already curated; this skill handles only lecture slides (released after each class, typically Friday and Saturday).

## Commands

- `/gdrive-notes sync` — List PDFs in Drive, find next unprocessed, process it.
- `/gdrive-notes process <pdf>` — Process a specific PDF (e.g. `04-01.pdf`).
- `/gdrive-notes status` — Show tracking status and processed PDFs.

## Configuration

- **Drive folder**: `https://drive.google.com/drive/folders/1i364Gle1X-JIyUzIlxj5d8lgP0m2H0Xh`
- **Output base**: `/Users/jbuza/Library/Mobile Documents/iCloud~md~obsidian/Documents/Buza/20 Projects/23 System Design/Masterclass/`
- **Tracking file**: `~/.claude/data/gdrive-notes-tracking.json` (symlinked from dotfiles)

Output path for a note is: `{outputBase}/Week {NN}/week-{NN}-{topic-slug}.md`.

## Week routing from PDF name

PDF filenames indicate week and session: `WW-SS.pdf` (e.g. `03-01.pdf`, `04-02.pdf`).

- **WW** = week number (01–08) → route to folder `Week 01` … `Week 08`.
- **SS** = session (01 = first lecture, 02 = second). Use for `session_day` when known (e.g. 01 → friday, 02 → saturday if you adopt that convention).

Parse the prefix before the first `-` to get the week number. Create or use the folder `Week {NN}` under the output base.

## Workflow

### 1. PDF discovery (sync)

1. Navigate to the Drive folder with Chrome MCP: `navigate_page(url: config.driveFolder)`.
2. Take a snapshot and parse PDF names (elements containing `.pdf`).
3. Compare with `processedPDFs` in the tracking file to find unprocessed PDFs.
4. Process the next unprocessed PDF (or the first if none processed yet).

### 2. PDF extraction (viewer-first, then images)

1. Open the PDF in the Drive viewer (click the PDF element; use snapshot to get `uid`).
2. Wait for the viewer to load; take a snapshot to find page count (e.g. “X of Y”).
3. Get the document ID from network requests: `list_network_requests(resourceTypes: ["xhr", "fetch", "image"])`, look for `viewer/img` and the `id` query parameter.
4. **Preferred path**: extract slide text directly from viewer after scrolling the slide container to load all pages (see [references/chrome-mcp-workflow.md](references/chrome-mcp-workflow.md)).
5. **Optional path**: download each page as an image via `evaluate_script` if needed for vision-heavy diagrams. Do not assume files always appear in `~/Downloads/` in MCP environments.

### 2.1 Server/tool preference

- Prefer `user-chrome-devtools` for Drive processing because it can keep the authenticated browser context and expose richer snapshots/network requests.
- `cursor-ide-browser` is acceptable for quick checks, but if file rows are missing in snapshots or download actions fail, switch to `user-chrome-devtools`.

### 3. Content processing

1. Use viewer text extraction first and extract:
   - **Topic title**: Main heading or first slide (used for H1 and filename slug).
   - **Key concepts**, **diagrams** (ASCII), **examples**, **summary points**.
2. If viewer text quality is poor for specific slides, supplement with image-based extraction.
3. Build a **topic slug** from the title: lowercase, hyphens, no special chars (e.g. “Load Balancer Design” → `load-balancer-design`).

### 4. Note generation and placement

- **Path**: `{outputBase}/Week {NN}/week-{NN}-{topic-slug}.md`. Create `Week {NN}` if it does not exist.
- **Conflict**: If `week-{NN}-{topic-slug}.md` already exists (e.g. two lectures same week), append a short disambiguator: `week-{NN}-{topic-slug}-02.md` or use a more specific slug (e.g. include session or a key word from the title).
- **Frontmatter** (add at top of the note):

  ```yaml
  ---
  track: masterclass
  week: NN
  type: lecture-notes
  source_pdf: "<filename>.pdf"
  session_day: friday | saturday | unknown
  ---
  ```

- **Body**: Use the structure in [references/note-format-template.md](references/note-format-template.md). Keep the H1 as the topic title so references by title are clear.

### 5. Tracking update

Update `~/.claude/data/gdrive-notes-tracking.json`:

- Add an entry under `processedPDFs` for the PDF with: `processedAt`, `noteFile` (basename only), `week`, `topic_title`, `session_day`, `pageCount`, `status: "complete"`.
- Set `inProgress` to `null` when done.
- Optionally maintain `state.nextNoteIndex` for backward compatibility; primary routing is by week + topic.

## Resume support

If processing was interrupted:

1. Read `inProgress` in the tracking file.
2. If set, resume from the step indicated (e.g. "downloading", "extracting", "generating").
3. On completion, set `inProgress` to `null`.

## Error handling

- **PDF not found**: Suggest running `/gdrive-notes sync` to refresh the list.
- **Chrome not connected**: Ask the user to ensure Chrome MCP is running and the folder is open.
- **Download failed or disabled**: Continue with viewer-first extraction flow; do not block note generation on binary download.
- **Direct file download says permission denied**: Open file in viewer via Chrome MCP and extract from viewer requests/text instead of `uc?export=download`.
- **Vision extraction unclear**: Summarize what was detected and ask the user for the intended topic title if needed.

## Legacy migration

Existing flat lecture notes (e.g. `00-foundational-topics.md`) were migrated into `Week NN` with topic-based names. Map: [references/legacy-notes-migration-map.md](references/legacy-notes-migration-map.md). Do not overwrite migrated files when processing new PDFs.
