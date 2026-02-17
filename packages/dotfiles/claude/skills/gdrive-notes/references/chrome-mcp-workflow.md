# Chrome MCP Workflow Reference

Used by the gdrive-notes skill to open Drive PDFs, extract the document ID and page count, and download each page as an image for vision-based extraction into markdown lecture notes.

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
- Page images loaded via `viewerng/img` requests
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

Or from network requests - look for `viewerng/img` URLs.

### Downloading Pages
```javascript
mcp__chrome-devtools__evaluate_script({
  function: `async () => {
    const docId = 'YOUR_DOC_ID';
    const pageCount = 10;  // Determined from viewer UI

    for (let page = 0; page < pageCount; page++) {
      const url = \`https://drive.google.com/viewer2/prod/img?id=\${docId}&page=\${page}&skiphighlight=true&w=1600\`;

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

## Tips

1. **Always take snapshot first** - Understand page structure before interacting
2. **Wait for loads** - Use `mcp__chrome-devtools__wait_for(text: "...")` after navigation
3. **Check network** - Use network requests to understand API patterns
4. **Include credentials** - Drive requires cookies for authenticated requests
5. **Handle popups** - Drive may show dialogs; use `handle_dialog` if needed
