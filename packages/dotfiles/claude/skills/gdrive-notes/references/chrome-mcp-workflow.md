# Chrome MCP Workflow Reference

Used by the gdrive-notes skill to open Drive PDFs, download page images, and generate lecture notes. **Always use `user-chrome-devtools`** — it connects to the authenticated Chrome browser with Google session cookies.

## Essential Tools

### Navigation
```
navigate_page(url: "https://...")
navigate_page(type: "back")
navigate_page(type: "reload")
```

### Page Interaction
```
take_snapshot()                        # Get page structure (always do first)
click(uid: "abc123")                   # Click element
click(uid: "abc123", dblClick: true)   # Double-click to open file
wait_for(text: "of")                   # Wait for viewer to load
```

### Network Inspection
```
list_network_requests(resourceTypes: ["image"])
```

### JavaScript Execution
```javascript
evaluate_script({
  function: `() => { return document.title; }`
})
```

## Step-by-Step: Processing a PDF

### Step 1: Navigate and open

```
navigate_page(url: "https://drive.google.com/drive/folders/1i364Gle1X-JIyUzIlxj5d8lgP0m2H0Xh")
take_snapshot()
# Close any "Try Drive" dialog if present
click(uid: "<close-button-uid>")
# Double-click the PDF row to open viewer
click(uid: "<pdf-row-uid>", dblClick: true)
wait_for(text: "of")
take_snapshot()  # Confirm page count from toolbar (e.g. "/ 20")
```

### Step 2: Scroll to load all pages

Run this to force all lazy-loaded page images to render:

```javascript
evaluate_script({
  function: `async () => {
    const candidates = Array.from(document.querySelectorAll('*')).filter((el) => {
      const s = getComputedStyle(el);
      return (s.overflowY === 'auto' || s.overflowY === 'scroll') &&
             el.scrollHeight > el.clientHeight + 50;
    });
    const target = candidates.sort(
      (a, b) => (b.scrollHeight - b.clientHeight) - (a.scrollHeight - a.clientHeight)
    )[0];

    if (target) {
      for (let i = 0; i < 40; i++) {
        target.scrollTop = Math.min(target.scrollTop + target.clientHeight * 0.9, target.scrollHeight);
        await new Promise((r) => setTimeout(r, 250));
        if (target.scrollTop + target.clientHeight >= target.scrollHeight - 4) break;
      }
    }

    return { scrolled: !!target, scrollHeight: target ? target.scrollHeight : 0 };
  }`
})
```

### Step 3: Get the document ID

```
list_network_requests(resourceTypes: ["image"])
```

Look for URLs matching `drive.google.com/viewer/img?id=...`. The `id` parameter is the document ID. It is a **long encoded string** (e.g. `ACFrOgB_IL4_...ELA%3D%3D`), NOT a short alphanumeric file ID. URL-decode `%3D` → `=` when using it in the download script.

### Step 4: Download all pages as images

```javascript
evaluate_script({
  function: `async () => {
    const docId = 'THE_DOC_ID_HERE';
    const pageCount = 20;
    const results = [];

    for (let page = 0; page < pageCount; page++) {
      const url = \`https://drive.google.com/viewer/img?id=\${encodeURIComponent(docId)}&dsmi=dss&auditContext=forDisplay&page=\${page}&skiphighlight=true&w=1600&webp=true\`;

      try {
        const response = await fetch(url, { credentials: 'include' });
        const blob = await response.blob();
        const a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = \`page-\${page}.webp\`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(a.href);
        results.push({ page, status: 'ok', size: blob.size });
        await new Promise(r => setTimeout(r, 300));
      } catch (e) {
        results.push({ page, status: 'error', error: e.message });
      }
    }

    return { success: true, results };
  }`
})
```

Include `dsmi=dss` in the URL — this parameter is required for shared-folder viewer sessions.

### Step 5: Move and convert to PNG

The Read tool does not support WebP. Convert with `sips` (macOS built-in):

```bash
mkdir -p tmp/{WW-SS}-pages
mv ~/Downloads/page-*.webp tmp/{WW-SS}-pages/
cd tmp/{WW-SS}-pages
for f in page-*.webp; do sips -s format png "$f" --out "${f%.webp}.png"; done
```

### Step 6: Read PNG images

Use the Read tool on each `.png` file in batches of 5:

```
Read page-0.png, page-1.png, page-2.png, page-3.png, page-4.png
Read page-5.png, page-6.png, page-7.png, page-8.png, page-9.png
...
```

## Google Drive Quirks

- **Folder viewer opens an inline PDF viewer** (dialog overlay), not a separate page. The URL stays as the folder URL — you cannot extract the file ID from the URL bar.
- **Double-click** to open a file in the viewer. Single-click only selects it.
- **"Try Drive" popup** appears on shared folders for non-signed-in users. Close it before interacting with files.
- **`uc?export=download`** will fail with "owner hasn't given permission" on most shared files. Do not attempt direct file downloads.
- **Page images use a long session-based document ID** from `viewer/img` network requests, not the short file ID from the URL.

## Tips

1. **Always take snapshot first** — understand page structure before clicking
2. **Wait for viewer load** — use `wait_for(text: "of")` to detect the page counter
3. **Include credentials** — Drive requires cookies; the `{ credentials: 'include' }` in fetch is essential
4. **Handle popups** — close the "Try Drive" dialog before proceeding
5. **Verify downloads** — check `ls ~/Downloads/page-*.webp` after the download script runs
