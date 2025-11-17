# PowerPoint Presentation Guide

## How to Use the Presentation Document

The `Project_Presentation.md` file contains 25 slides with all the content needed for your CS 4354 project presentation.

### Converting to PowerPoint:

**Option 1: Manual Creation**
1. Open PowerPoint
2. Create a new presentation with a professional template (SQL/database theme)
3. Copy each slide section from the markdown file
4. Create one slide per section (marked by "---")
5. Use SQL-themed colors (blues, grays, dark backgrounds with light text)

**Option 2: Using Pandoc (if installed)**
```bash
pandoc Project_Presentation.md -o Project_Presentation.pptx
```

**Option 3: Online Converters**
- Use markdown-to-pptx converters online
- Or copy content manually into PowerPoint

### Recommended PowerPoint Theme:
- **Color Scheme**: Dark blue background, light text (SQL-themed)
- **Font**: Consolas or Courier New for code, Arial/Calibri for text
- **Layout**: Title slide, content slides with bullet points, code slides with monospace font

### Slide Timing:
- **Total Time**: 6-8 minutes
- **Average per slide**: ~15-20 seconds
- **Focus more time on**: Requirements, ER Diagram, Normalization, Evidence Queries

### Key Slides to Emphasize:
1. Requirements (Slide 3)
2. ER Diagram (Slide 5)
3. Normalization Evidence (Slides 9-10)
4. Evidence Queries (Slides 14-16)
5. Conclusion (Slide 24)

### For Q&A Preparation:
- Review Slide 25 (Q&A Preparation Notes)
- Be ready to explain design decisions
- Know your schema inside and out
- Practice explaining normalization example

### Visual Elements to Add:
- ER Diagram (draw using PowerPoint shapes or import from diagramming tool)
- Schema diagram showing table relationships
- Screenshots of query results
- Code syntax highlighting for SQL queries

