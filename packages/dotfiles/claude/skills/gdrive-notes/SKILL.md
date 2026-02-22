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
- **Temp directory**: `/Users/jbuza/Code/system-design/tmp/` (for intermediate image files)

Output path for a note is: `{outputBase}/Week {NN}/week-{NN}-{topic-slug}.md`.

## Week routing from PDF name

PDF filenames indicate week and session: `WW-SS.pdf` (e.g. `03-01.pdf`, `04-02.pdf`).

- **WW** = week number (01–08) → route to folder `Week 01` … `Week 08`.
- **SS** = session (01 = first lecture, 02 = second). 01 → friday, 02 → saturday.

Parse the prefix before the first `-` to get the week number. Create or use the folder `Week {NN}` under the output base.

## MCP Server

**Always use `user-chrome-devtools`** for all Drive operations. It connects to the user's authenticated Chrome browser, which has Google session cookies. Do NOT use `cursor-ide-browser` — it opens an unauthenticated browser that shows "Sign in" instead of file contents.

## Workflow

### 1. PDF discovery (sync)

1. Navigate to the Drive folder: `navigate_page(url: config.driveFolder)`.
2. Take a snapshot and parse PDF names (rows containing `.pdf`).
3. If a "Try Drive" dialog appears, close it first (`click` the Close button).
4. Compare with `processedPDFs` in the tracking file to find unprocessed PDFs.
5. Process the next unprocessed PDF (or the first if none processed yet).

### 2. PDF extraction (image-based)

The slides are handwritten whiteboard notes. Viewer OCR text is garbled and unreliable. **Always download page images and read them visually.**

1. **Open the PDF**: Double-click the PDF row (`click(uid, dblClick: true)`).
2. **Wait for viewer**: `wait_for(text: "of")` to detect the page counter (e.g. "Page 1 / 20").
3. **Get page count**: From the snapshot, find the total pages number next to the `/` in the viewer toolbar.
4. **Scroll to load all pages**: Run the scroll script (see [references/chrome-mcp-workflow.md](references/chrome-mcp-workflow.md)) so all page images load via the viewer.
5. **Get the document ID**: Call `list_network_requests(resourceTypes: ["image"])` and find `viewer/img` URLs. Extract the `id` query parameter value. This is NOT a short alphanumeric ID — it is a long encoded string (starts with `ACFrOg...` and ends with `==`).
6. **Download all pages**: Run the download script (see [references/chrome-mcp-workflow.md](references/chrome-mcp-workflow.md)) using the doc ID and page count. Pages download to `~/Downloads/` as `.webp` files.
7. **Move and convert**: Move files from `~/Downloads/page-*.webp` to `tmp/{WW-SS}-pages/`, then convert WebP to PNG with `sips`:
   ```bash
   mkdir -p tmp/{WW-SS}-pages
   mv ~/Downloads/page-*.webp tmp/{WW-SS}-pages/
   cd tmp/{WW-SS}-pages
   for f in page-*.webp; do sips -s format png "$f" --out "${f%.webp}.png"; done
   ```
8. **Read all PNG images**: Use the Read tool on each `.png` file. Read in batches of 5 to stay within limits. This is the primary content source — the images contain whiteboard diagrams, code, and architecture drawings that cannot be captured by text extraction.

### 3. Content processing

1. Read all page images and extract:
   - **Topic title**: From the title slide (page 0) — used for H1 and filename slug.
   - **Architecture diagrams**: Faithfully convert every whiteboard diagram to ASCII art and/or Mermaid.
   - **Code/pseudocode**: Transcribe any code shown on the whiteboard.
   - **Key concepts**, **trade-off tables**, **brainstorm checklists**, **summary points**.
2. Build a **topic slug** from the title: lowercase, hyphens, no special chars (e.g. "Load Balancer Design" → `load-balancer-design`).

### 4. Note generation and placement

- **Path**: `{outputBase}/Week {NN}/week-{NN}-{topic-slug}.md`. Create `Week {NN}` if it does not exist.
- **Conflict**: If `week-{NN}-{topic-slug}.md` already exists (e.g. two lectures same week), append a short disambiguator: `week-{NN}-{topic-slug}-02.md` or use a more specific slug.
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

- **Body**: Use the structure in [references/note-format-template.md](references/note-format-template.md). Keep the H1 as the topic title. **Prioritize diagrams** — every whiteboard drawing should become an ASCII diagram, a Mermaid diagram, or both.

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
- **Chrome not connected**: Ask the user to ensure Chrome DevTools MCP is running and Chrome is open.
- **WebP not supported by Read tool**: Convert to PNG with `sips` first (see step 2.7).
- **Downloads not in ~/Downloads/**: Check the actual download location; Chrome may use a different path.
- **Vision extraction unclear**: Summarize what was detected and ask the user for the intended topic title if needed.

## Legacy migration

Existing flat lecture notes (e.g. `00-foundational-topics.md`) were migrated into `Week NN` with topic-based names. Map: [references/legacy-notes-migration-map.md](references/legacy-notes-migration-map.md). Do not overwrite migrated files when processing new PDFs.
