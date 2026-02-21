# Chrome MCP Workflow Reference

Used by the gdrive-notes skill to open Drive PDFs, extract the document ID and page count, then generate lecture notes. Prefer viewer text extraction first, and use image downloads as a fallback.

## Essential Tools

### Navigation
```
mcp__chrome-devtools__navigate_page(url: "https://...")
mcp__chrome-devtools__navigate_page(type: "back")
mcp__chrome-devtools__navigate_page(type: "reload")
```

### Page Interaction
```
mcp__chrome-devtools__take_snapshot()           # Get page structure
mcp__chrome-devtools__click(uid: "abc123")       # Click element
mcp__chrome-devtools__click(uid: "abc123", dblClick: true)  # Double-click
mcp__chrome-devtools__fill(uid: "abc123", value: "text")    # Fill input
mcp__chrome-devtools__hover(uid: "abc123")       # Hover for tooltips/menus
```

### Network Inspection
```
mcp__chrome-devtools__list_network_requests()
mcp__chrome-devtools__list_network_requests(resourceTypes: ["xhr", "fetch"])
mcp__chrome-devtools__get_network_request(reqid: 123)
```

### JavaScript Execution
```javascript
mcp__chrome-devtools__evaluate_script({
  function: `() => {
    // Your code here
    return someValue;
  }`
})

// With element arguments
mcp__chrome-devtools__evaluate_script({
  function: `(element) => {
    return element.innerText;
  }`,
  args: [{ uid: "abc123" }]
})
```

### Screenshots
```
mcp__chrome-devtools__take_screenshot()                    # Viewport
mcp__chrome-devtools__take_screenshot(fullPage: true)      # Full page
mcp__chrome-devtools__take_screenshot(uid: "abc123")       # Element only
mcp__chrome-devtools__take_screenshot(filePath: "/path/to/save.png")
```

## Google Drive Specific

### Finding PDFs in Drive Folder
After navigating to folder and taking snapshot:
- PDF entries appear as grid items or list items
- Look for elements with ".pdf" in their accessible name
- Use `dblClick: true` to open a file

### PDF Viewer Structure
When PDF is open in Drive viewer:
- Page images loaded via `drive.google.com/viewer/img` requests
- Document ID in URL parameter: `?id=<doc_id>&page=<num>`
- Page navigation often shows "X of Y" format
- Zoom controls may affect image quality

### Extracting Document ID
```javascript
mcp__chrome-devtools__evaluate_script({
  function: `() => {
    // From URL
    const url = window.location.href;
    const match = url.match(/\/d\/([a-zA-Z0-9_-]+)/);
    return match ? match[1] : null;
  }`
})
```

Or from network requests - look for `viewer/img` URLs.

### Detecting page count reliably

- The viewer toolbar usually exposes current page and total pages (for example `Page 1 / 20`).
- If snapshot parsing is noisy, use an `evaluate_script` helper to read visible text and parse `Page <n> of <total>`.

### Viewer-first extraction (recommended)

Use this when direct downloads are restricted or disabled.

```javascript
mcp__chrome-devtools__evaluate_script({
  function: `async () => {
    // Scroll the main viewer container so lazy-loaded pages render.
    const candidates = Array.from(document.querySelectorAll('*')).filter((el) => {
      const s = getComputedStyle(el);
      return (s.overflowY === 'auto' || s.overflowY === 'scroll') &&
             el.scrollHeight > el.clientHeight + 50;
    });
    const target = candidates.sort(
      (a, b) => (b.scrollHeight - b.clientHeight) - (a.scrollHeight - a.clientHeight)
    )[0];

    if (target) {
      for (let i = 0; i < 30; i++) {
        target.scrollTop = Math.min(target.scrollTop + target.clientHeight * 0.9, target.scrollHeight);
        await new Promise((r) => setTimeout(r, 180));
        if (target.scrollTop + target.clientHeight >= target.scrollHeight - 4) break;
      }
    }

    const text = document.body ? document.body.innerText : '';
    return {
      textLength: text.length,
      hasContent: text.length > 0,
      sample: text.slice(0, 2000)
    };
  }`
})
```

Then parse sections by `Page X of Y` markers and synthesize notes.

### Downloading Pages
```javascript
mcp__chrome-devtools__evaluate_script({
  function: `async () => {
    const docId = 'YOUR_DOC_ID';
    const pageCount = 10;  // Determined from viewer UI

    for (let page = 0; page < pageCount; page++) {
      const url = \`https://drive.google.com/viewer/img?id=\${docId}&auditContext=forDisplay&page=\${page}&skiphighlight=true&w=1600&webp=true\`;

      try {
        const response = await fetch(url, { credentials: 'include' });
        const blob = await response.blob();
        const a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = \`page-\${String(page).padStart(2, '0')}.webp\`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(a.href);

        // Small delay between downloads
        await new Promise(r => setTimeout(r, 200));
      } catch (e) {
        console.error(\`Failed to download page \${page}:\`, e);
      }
    }

    return { success: true, pagesDownloaded: pageCount };
  }`
})
```

If downloads are not visible in local `~/Downloads`, continue with viewer-first extraction and do not fail the run.

## Tips

1. **Always take snapshot first** - Understand page structure before interacting
2. **Wait for loads** - Use `mcp__chrome-devtools__wait_for(text: "...")` after navigation
3. **Check network** - Use network requests to understand API patterns
4. **Include credentials** - Drive requires cookies for authenticated requests
5. **Handle popups** - Drive may show dialogs; use `handle_dialog` if needed
6. **Permission edge case** - `uc?export=download` can fail with "owner hasn't given permission" even when viewer access works; in that case use viewer-first extraction.
