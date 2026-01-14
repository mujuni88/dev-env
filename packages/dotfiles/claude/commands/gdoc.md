---
description: Download Google Doc to ~/Downloads
allowed-tools: Bash, Write, Read, mcp__GenAI_MCP_Gateway_dropship__netflix_search_data
argument-hint: <google-doc-url> [--format docx|pdf|md|txt] [--output filename]
---

# Download Google Doc

⚠️ **Warning**: This uses Netflix Search indexed content, which is near real-time but may be seconds to ~2 minutes behind the live document. For the absolute latest version, download directly from Google Docs.

## Arguments
- $1: Google Doc URL (required)
- --format: Output format (docx, pdf, md, txt) - defaults to md
- --output: Custom output filename (optional, defaults to doc title)

## Instructions

1. Parse the Google Doc URL from $ARGUMENTS
2. Use netflix_search_data MCP tool to fetch the document content:
   - Call with urls parameter containing the Google Doc URL
3. Extract document title from response for default filename
4. Determine output format from --format flag (default: md)
5. Clean the content (remove comments and footnotes):
   - Remove inline footnote references [N] with surrounding whitespace
   - Remove footnote definition lines (lines starting with [N])
   - Remove reaction lines ("N total reaction", "reacted with")
6. Save to ~/Downloads/:
   - For md: save content directly
   - For txt: convert via pandoc -f markdown -t plain
   - For docx: convert via pandoc -f markdown -t docx
   - For pdf: convert via pandoc -f markdown -t pdf
7. Report the saved file path to user
