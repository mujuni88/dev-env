# Note Format Template (Lecture Notes)

Use this template when generating Obsidian lecture notes from Drive PDFs. Output goes under `Week {NN}/week-{NN}-{topic-slug}.md`. Add this frontmatter at the top:

```yaml
---
track: masterclass
week: NN
type: lecture-notes
source_pdf: "WW-SS.pdf"
session_day: friday | saturday | unknown
---
```

## Template Structure

```markdown
# {Topic Title}

## Overview

{1-2 sentence introduction explaining what this topic covers and why it matters.}

## {Main Section 1}

### {Subsection}
{Explanation with key points}

- **{Key term}**: Definition or explanation
- **{Another term}**: Definition or explanation

### {Subsection with Diagram}
{Context for the diagram}

```
┌─────────────────────────────────────┐
│         ASCII Diagram               │
│                                     │
│   Component A ──── Component B      │
│       │                │            │
│       ▼                ▼            │
│   Component C ──── Component D      │
│                                     │
└─────────────────────────────────────┘
```

## {Main Section 2}

{Continue with logical flow of content}

## Real-World Examples

1. **{Example Name}**: {Brief description of how concept applies}
2. **{Example Name}**: {Brief description}

## Summary

- {Key takeaway 1}
- {Key takeaway 2}
- {Key takeaway 3}
- {Key takeaway 4}

---
*Source: System Design Pro by Arpit Bhayani*
```

## Formatting Guidelines

### Headings
- **H1**: Topic title only (one per note)
- **H2**: Major sections (Overview, main topics, Summary)
- **H3**: Subsections within major sections
- **H4**: Rarely needed, use sparingly

### Lists
- Use bullet points for concepts and definitions
- Use numbered lists for sequences, steps, or ranked items
- Bold the key term before the colon: `- **Term**: Definition`

### Code Blocks
- Use for ASCII diagrams
- Use for code examples or technical notation
- No syntax highlighting needed for diagrams (use plain ```)

### ASCII Diagrams
Convert visual diagrams to ASCII art:

**Box characters:**
- Corners: `┌ ┐ └ ┘`
- Lines: `─ │`
- Connections: `├ ┤ ┬ ┴ ┼`
- Arrows: `→ ← ↑ ↓ ▶ ◀ ▲ ▼`

**Flow diagram:**
```
Input → Process → Output
```

**Hierarchy:**
```
Parent
├── Child 1
│   ├── Grandchild A
│   └── Grandchild B
└── Child 2
```

**Comparison table:**
```
┌──────────┬───────────┬───────────┐
│ Aspect   │ Option A  │ Option B  │
├──────────┼───────────┼───────────┤
│ Speed    │ Fast      │ Slow      │
│ Memory   │ Low       │ High      │
└──────────┴───────────┴───────────┘
```

### Emphasis
- **Bold**: Key terms, important concepts
- *Italic*: Used sparingly for emphasis or foreign terms
- `Inline code`: Technical terms, file names, commands

### Links
- Internal Obsidian links: `[[Other Note]]`
- Use when referencing related concepts from this course

## Content Extraction Tips

When reading PDF slides:

1. **Identify the main topic** - Usually the first slide or repeated header
2. **Group related slides** - Combine slides covering the same concept
3. **Preserve hierarchy** - Slide progression often indicates importance
4. **Simplify verbose text** - Condense wordy explanations
5. **Enhance diagrams** - Convert to clean ASCII, add labels if needed
6. **Add context** - Connect concepts to real-world applications
7. **Create summary** - Synthesize key points, don't just list slide titles
