# GDrive Notes Skill

Extract PDF pages from Google Drive and convert them to Obsidian markdown notes.

## Commands

- `/gdrive-notes sync` - Check for new PDFs and process the next unprocessed one
- `/gdrive-notes process <pdf>` - Process specific PDF (e.g., "01-01.pdf")
- `/gdrive-notes status` - Show tracking status

## Configuration

- **Drive Folder**: https://drive.google.com/drive/folders/1i364Gle1X-JIyUzIlxj5d8lgP0m2H0Xh
- **Output Path**: `/Users/jbuza/Library/Mobile Documents/iCloud~md~obsidian/Documents/Buza/20 Projects/23 System Design/Masterclass/`
- **Tracking File**: `~/.claude/data/gdrive-notes-tracking.json`

## Workflow

### 1. PDF Discovery (sync command)

1. Navigate to Drive folder using Chrome MCP:
   ```
   mcp__chrome-devtools__navigate_page(url: <drive_folder_url>)
   ```

2. Take snapshot to list available PDFs:
   ```
   mcp__chrome-devtools__take_snapshot()
   ```

3. Parse PDF names from snapshot (look for elements with ".pdf")

4. Compare against tracking file to find unprocessed PDFs

5. Process the first unprocessed PDF

### 2. PDF Extraction

1. Click on the PDF in Drive to open the viewer:
   ```
   mcp__chrome-devtools__click(uid: <pdf_element_uid>)
   ```

2. Wait for viewer to load, then take snapshot to understand page count

3. Get the document ID from network requests:
   ```
   mcp__chrome-devtools__list_network_requests(resourceTypes: ["xhr", "fetch"])
   ```
   Look for requests to `viewerng/img` - the `id` parameter is the document ID

4. Determine page count from viewer UI (look for "X of Y" or similar)

5. Download all pages using JavaScript:
   ```javascript
   // For each page 0 to pageCount-1:
   const docId = '<document_id>';
   const pageNum = 0;
   const url = `https://drive.google.com/viewer2/prod/img?id=${docId}&page=${pageNum}&skiphighlight=true&w=1600`;

   // Fetch and download
   const response = await fetch(url, { credentials: 'include' });
   const blob = await response.blob();
   const a = document.createElement('a');
   a.href = URL.createObjectURL(blob);
   a.download = `page-${String(pageNum).padStart(2, '0')}.webp`;
   a.click();
   ```

6. Images will download to `~/Downloads/`

### 3. Content Processing

1. Read the downloaded webp images using the Read tool (Claude has vision capabilities)

2. Extract structured content:
   - **Topic title**: Main heading or first slide title
   - **Key concepts**: Core ideas with explanations
   - **Diagrams**: Convert to ASCII art
   - **Examples**: Real-world applications mentioned
   - **Summary points**: Key takeaways

### 4. Note Generation

Format the extracted content using the template in `references/note-format-template.md`

Save to the Masterclass output folder with naming convention:
- `00-topic-slug.md`, `01-topic-slug.md`, etc.
- Use `nextNoteIndex` from tracking state

### 5. Tracking Update

Update `~/.claude/data/gdrive-notes-tracking.json`:
- Add PDF to `processedPDFs` with generated note info
- Increment `nextNoteIndex`
- Clear `inProgress` if set

## Resume Support

If processing was interrupted (context window limit, etc.):

1. Check `inProgress` in tracking file
2. If set, continue from last step
3. Track progress: "downloading", "extracting", "generating", "complete"

## Error Handling

- **PDF not found**: Report and suggest using `/gdrive-notes sync`
- **Chrome not connected**: Ask user to ensure Chrome MCP is running
- **Download failed**: Retry with different parameters or report
- **Vision extraction unclear**: Ask user for clarification

## Example Session

```
User: /gdrive-notes sync

Claude: Checking for new PDFs...

Found 10 PDFs in Drive folder:
- 01-01.pdf (unprocessed)
- 01-02.pdf (unprocessed)
- ...

Processing 01-01.pdf...
- Opened PDF viewer
- Document ID: abc123
- Pages: 15

Downloading pages...
- Downloaded 15 pages to ~/Downloads/

Extracting content from images...
- Topic: "Bloom Filters"
- Key concepts identified: 5
- Diagrams found: 3

Generated note: Masterclass/00-bloom-filters.md

Updated tracking. Run `/gdrive-notes status` to see progress.
```
