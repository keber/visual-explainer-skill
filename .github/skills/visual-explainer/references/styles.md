# Visual Explainer — Style Templates

Este archivo contiene los templates de prompt para cada estilo visual soportado.
El agente lee este archivo al construir el prompt de generación de imágenes (Step 3 del SKILL.md).

Los estilos disponibles en el MVP son:
`whiteboard`, `infographic`, `presentation`, `diagram`, `mindmap`, `mindmap-structured`

---

## WHITEBOARD Style

Use this template structure to build the prompt. Replace bracketed sections with content-specific details.

```
Create a stunning hand-drawn whiteboard visual explanation. The image should look like an expert educator spent hours crafting an engaging whiteboard illustration — vibrant, energetic, and visually rich.

CANVAS: A large whiteboard with [slight off-white texture / clean white surface based on draw-level]. [If sketch: visible whiteboard frame edges, slight marker smudges, eraser marks. If polished: pristine surface with subtle shadow at edges.]

TITLE: "[Title text]" written in large, bold [hand-lettered / marker-style] text across the top [center/left]. Use [color] for the title with [decorative underline / banner / box around it]. [If sketch: slightly uneven lettering with personality. If polished: confident, clean hand-lettering.]

LAYOUT: [Describe the spatial arrangement — e.g., "Radial layout with the central concept in the middle and 5 sub-topics arranged around it like spokes of a wheel" or "Left-to-right flow with 4 stages connected by large curved arrows"]

SECTIONS:
[For each sub-topic, describe:]
- "[Section Title]" in [color] bold marker text [position]
- [Icon/illustration description — be VERY specific, e.g., "a hand-drawn brain with visible folds and small lightning bolts coming from it" not just "a brain icon"]
- Key points written in smaller [handwriting/print] text: "[exact text]"
- [Border style: colored rounded rectangle, cloud bubble, banner, torn paper effect, etc.]
- [Any annotations: stars, exclamation marks, arrows pointing to important parts]

CONNECTIONS:
[Describe every arrow, line, and visual connection between sections]
- [e.g., "A thick curved arrow in blue flows from Section 1 to Section 2 with the word 'triggers' written along it"]
- [e.g., "Dotted red lines connect the three related concepts with small heart icons at the endpoints"]

DECORATIVE ELEMENTS:
[Scatter appropriate decorations throughout — these bring the whiteboard to life]
- Small doodles: [stars, lightbulbs, question marks, exclamation points, checkmarks, sparkles, small rockets, gears, clouds]
- Color splashes: [small colored dots, underline accents, highlighted keywords]
- Margin notes: [small speech bubbles with "Wow!", "Key!", "Remember this!", "Important!", etc.]
- [If sketch: more scattered doodles, playful elements, slight imperfections that feel human]
- [If polished: fewer but more carefully placed decorations, consistent spacing]

COLORS: Use a vibrant palette — [specify 4-6 exact colors, e.g., "cherry red, ocean blue, emerald green, sunshine yellow, deep purple, and tangerine orange for markers on the white background"]. Each section should have its own dominant color.

TYPOGRAPHY: All text should appear [hand-written with markers / carefully hand-lettered]. Headers in thick marker strokes (like Expo dry-erase markers). Body text in thinner pen-style writing. [If sketch: casual, slightly messy handwriting. If normal: confident educator handwriting. If polished: beautiful hand-lettering with consistent sizing.]

OVERALL FEEL: Energetic, educational, like walking into a classroom where the best teacher just finished an amazing visual lecture. The board should feel FULL but not cluttered — every element has purpose and the eye naturally flows through the content.
```

---

## INFOGRAPHIC Style

```
Create a professional, publication-quality infographic. This should look like it was designed by a professional graphic designer for a premium educational publication — clean, structured, and visually sophisticated.

CANVAS: [Portrait/landscape] format with a [color] background. [If polished: subtle gradient or textured background. If sketch: slightly more organic/craft feel with paper texture.]

HEADER: "[Title]" in large, bold [sans-serif / modern] typography at the top. [Subtitle if applicable] in lighter weight below. Use [color scheme] for the header area with [a decorative banner, geometric shape, or colored background block].

COLOR PALETTE: Use a sophisticated, cohesive palette — [specify exact scheme, e.g., "slate blue (#4A6FA5), warm taupe (#B8A898), olive green (#6B7F3B), charcoal (#3D3D3D), and cream (#F5F0E8) — inspired by modern editorial design"]. Use color consistently to group related concepts.

LAYOUT: [Describe the grid/flow structure — e.g., "Two-column layout with numbered sections flowing top-to-bottom. Left column covers theory, right column covers application. A central dividing line with decorative elements separates them."]

NUMBERED SECTIONS:
[For each section, describe:]
- Section number in a [colored circle / hexagon / badge] with [icon inside or beside it]
- "[Section Title]" in bold [font style], [color]
- [Icon/illustration: use flat-design style icons, e.g., "a flat-design gear icon in slate blue with a small dollar sign overlay" — NOT hand-drawn]
- Content organized as: [bullet points / comparison table / flow arrows / stat callouts]
- [Specific data visualizations if applicable: bar charts, pie charts, simple graphs]
- [Visual container: rounded rectangle card with subtle shadow, colored sidebar, etc.]

ICONS AND ILLUSTRATIONS:
[Describe the visual style for all icons]
- Style: [flat design / line art / isometric / duotone] — consistent throughout
- [List specific icons for each concept with exact descriptions]
- Each icon should be [size] and use [color approach — monochrome with accent, full color, etc.]

FLOW AND CONNECTIONS:
- [Describe how sections connect visually — numbered progression, timeline, flowchart arrows]
- [Use consistent connector styles — thin lines, dotted paths, thick arrows with labels]

DATA CALLOUTS:
- [Any statistics, key numbers, or highlight boxes]
- [e.g., "A large '6' in a teal circle with 'Key Determinants' written below in small caps"]

FOOTER: [Attribution, source notes, or summary bar at the bottom]

TYPOGRAPHY:
- Headers: [Bold sans-serif, e.g., Montserrat or Roboto style]
- Body: [Clean sans-serif, good readability]
- Callouts: [Slightly larger, maybe italicized or in accent color]
- All text must be crisp and legible — this is a polished publication piece

OVERALL FEEL: Clean, authoritative, and visually balanced. Like a premium educational poster you'd see in a university or a well-designed report. Information hierarchy is immediately clear — the viewer knows exactly where to start and how to navigate the content. White space is used intentionally. Nothing feels cramped or cluttered.
```

---

## PRESENTATION Style

```
Create a single, visually striking presentation slide that explains [topic]. This should look like a keynote slide from a world-class conference talk — bold, minimal, and impactful.

CANVAS: Widescreen (16:9) format. [Dark background with light text / Light background with dark text / Gradient background]. [Specify exact colors.]

TITLE: "[Title]" in [large/extra-large] bold [modern sans-serif] text. Positioned [top-left / center-top]. [Color and styling details.]

VISUAL HIERARCHY: The slide should have ONE dominant visual element that immediately captures attention, supported by [2-4] secondary elements.

PRIMARY VISUAL:
[Describe the main illustration, diagram, or graphic — e.g., "A large circular diagram in the center showing the 4 stages of the process, with each quadrant in a different color and connected by curved arrows"]

SUPPORTING ELEMENTS:
[For each supporting element:]
- [Position on slide]
- [Visual description]
- [Text labels]

KEY POINTS:
[2-5 key takeaways displayed as clean bullet points or visual callouts]
- [Exact text and position for each]

DESIGN DETAILS:
- [Subtle grid lines, geometric decorations, or accent shapes in background]
- [Icon style and placement]
- [Color accent usage]

TYPOGRAPHY: [Conference-quality — bold headers, clean body text, consistent sizing. Specify font style.]

OVERALL FEEL: TED-talk quality. Bold, confident, focused. Every element earns its place. High contrast and strong visual hierarchy. The key message is understood within 3 seconds of looking at it.
```

---

## DIAGRAM Style

```
Create a clear, precise technical diagram explaining [topic]. This should look like a professionally created technical illustration — accurate, well-labeled, and easy to follow.

CANVAS: Clean [white / light gray] background. [Specify dimensions context.]

TITLE: "[Title]" in [position] using clean, professional [sans-serif] text in [color].

DIAGRAM TYPE: [Flowchart / Architecture diagram / Sequence diagram / Mind map / Process flow / Comparison matrix / Hierarchy tree / Network topology]

NODES/ELEMENTS:
[For each node:]
- Shape: [rectangle / rounded rectangle / circle / diamond / hexagon / cylinder / cloud]
- Color: [specific color]
- Label: "[exact text]"
- Position: [where in the diagram]
- [Any internal details or sub-elements]

CONNECTIONS:
[For each connection:]
- From [node] to [node]
- Line style: [solid / dashed / dotted / thick / thin]
- Arrow: [one-way / bidirectional / none]
- Label: "[text on the connection]"
- Color: [specific color]

LEGEND/KEY: [If applicable, describe a legend box]

ANNOTATIONS:
- [Numbered callouts, notes, or labels outside the main diagram]

GROUPING:
- [Visual containers/boundaries that group related nodes — dashed rectangles, shaded regions, swim lanes]

TYPOGRAPHY: Clean, technical, highly legible. All labels crisp. Use consistent font sizing — larger for main nodes, smaller for connection labels.

OVERALL FEEL: Engineering-quality documentation. Precise, unambiguous, and professionally typeset. Should look like it belongs in official technical documentation or an architecture review deck.
```

---

## MINDMAP Style

```
Create a vibrant, colorful mind map illustration. This should look like a beautifully hand-crafted mind map created by someone who loves visual thinking — organic, radial, bursting with color and personality.

CANVAS: [White / cream / light gray] background, landscape orientation. Clean but with subtle paper texture.

CENTER NODE: A large, eye-catching central element in the exact center of the image:
- Shape: [rounded rectangle / circle / cloud / organic blob] with a bold fill color (e.g., rich coral, deep teal, or vibrant purple)
- Text: "[Central Topic]" in large, bold white or dark text inside the shape
- [Optional: a small icon or illustration inside or beside the central node that represents the topic — e.g., a brain, a gear, a lightbulb]
- The center should feel like the "sun" of the map — everything radiates outward from it

MAIN BRANCHES: [4-8 depending on complexity] thick, organic, curved branches radiating outward from the center node like tree limbs. Each branch should:
- Be a DIFFERENT bold color (e.g., branch 1: cherry red, branch 2: ocean blue, branch 3: emerald green, branch 4: golden amber, branch 5: deep purple, branch 6: tangerine orange)
- Curve gracefully outward — NOT straight lines. Use smooth, flowing, slightly wavy curves
- Taper from thick (near center) to thinner as they extend outward
- End at a rounded rectangle or pill-shaped node containing the sub-topic title

BRANCH NODES (Level 1): At the end of each main branch:
- A rounded rectangle or pill shape filled with the SAME color as its branch (but slightly lighter tint)
- "[Sub-Topic Title]" in bold text inside
- [Small relevant icon next to or inside the node — be specific about each icon]

SUB-BRANCHES (Level 2): From each Level 1 node, extend 2-4 thinner branches outward:
- Same color family as the parent branch but thinner lines
- End at smaller nodes or simple text labels
- Text: "[detail point]" — keep these short (2-5 words each)
- [Optional: tiny icons, checkmarks, or bullet dots at each endpoint]

SUB-BRANCHES (Level 3, if complexity is detailed): From some Level 2 nodes, extend even thinner branches:
- Finest lines, same color family
- Simple text labels, no boxes needed
- These are leaf-level details

DECORATIVE ELEMENTS:
- Small icons scattered near relevant branches: [specify icons per topic — gears, stars, arrows, hearts, lightbulbs, clouds, locks, etc.]
- Colorful dots or circles at branch connection points
- Subtle shadow or glow behind the central node
- [Optional: small doodles or illustrative elements that make it feel alive]
- Curved connector lines (dotted, in gray) between related branches that aren't directly connected — with small labels explaining the cross-connection

COLORS: Use a vibrant, saturated palette — each main branch has its own distinct color. Colors should be bold and joyful: [specify 4-8 colors]. The overall impression should be a rainbow of organized knowledge.

TYPOGRAPHY:
- Central node: Large, bold [sans-serif or hand-lettered]
- Level 1 nodes: Medium bold text
- Level 2: Smaller regular text
- Level 3: Smallest text, still legible
- All text should be horizontal and easy to read (not rotated along branches)

OVERALL FEEL: Organic, radiant, visually stunning. Like a beautifully crafted mind map from a skilled visual thinker's notebook. The eye is drawn to the center and naturally follows branches outward. Balanced composition — branches fill the space evenly without crowding. Feels creative, energetic, and intellectually stimulating.
```

---

## MINDMAP-STRUCTURED Style

```
Create a clean, professional, data-oriented mind map in the style of XMind or MindMeister. This should look like a structured knowledge map from a business intelligence tool — organized, precise, and information-dense with minimal decorative elements.

CANVAS: Clean white or very light gray (#F8F9FA) background, landscape orientation. No texture — pure and minimal.

CENTER NODE: A prominent but understated central element in the center:
- Shape: Rounded rectangle with subtle shadow or thin border
- Fill: Muted professional color (e.g., dark slate blue #2C3E50, charcoal #34495E, or dark teal #1A5276)
- Text: "[Central Topic]" in clean, white, bold sans-serif text
- Subtle drop shadow or thin 1px border — no glow, no decoration
- [Optional: a small monochrome icon to the left of the text]

MAIN BRANCHES: [4-8 depending on complexity] — these are clean, straight or gently curved lines:
- Use a MUTED, PROFESSIONAL color palette — not vibrant. Colors like: steel blue (#5B7B9A), sage green (#6B8E6B), warm gray (#8E8E7A), muted coral (#C27B6B), slate purple (#7B6B8E), dusty teal (#5B8E8E)
- Lines should be clean and consistent width (2-3px) — NOT organic or hand-drawn
- Lines connect from center node edge to Level 1 nodes with clean right-angle or gentle curve routing
- Use a structured layout: top branches go up-right and up-left, bottom branches go down-right and down-left — creating a balanced tree structure

BRANCH NODES (Level 1): Connected to the center:
- Rounded rectangles with thin colored border matching the branch color, white or very light fill
- "[Sub-Topic Title]" in dark text, bold, clean sans-serif
- Consistent sizing across all Level 1 nodes
- [Optional: small monochrome or duotone icon (line-art style) to the left of text]

SUB-BRANCHES (Level 2): Extend from Level 1 nodes:
- Thinner lines (1-2px), same color as parent branch
- Connected to smaller nodes or inline text blocks
- Nodes: Smaller rounded rectangles or simple bordered pills
- Text: "[detail]" in regular weight, dark gray text
- Aligned neatly — sub-branches should be vertically stacked or fanned in an organized pattern, NOT randomly scattered

SUB-BRANCHES (Level 3, if complexity is detailed):
- Finest lines (1px), lighter shade of parent color
- Simple text labels with small bullet dots or dashes
- May use a simple table or list format within a container

DATA ELEMENTS (what makes this style distinct):
- [Where applicable, include small inline data representations:]
  - Small tag/badge elements: e.g., "[HIGH]" "[LOW]" priority badges in colored pills
  - Percentage indicators: small progress-bar style elements
  - Status markers: green checkmarks, yellow circles, red X marks
  - Count badges: small numbered circles showing "3 items", "5 types", etc.
  - Category labels: small muted pills like "[Core]" "[Advanced]" "[Optional]"
- These data elements should feel like metadata attached to nodes — compact and informative

CROSS-CONNECTIONS:
- Thin dashed gray lines connecting related nodes across different branches
- Small text labels on these connections explaining the relationship
- Arrows showing direction of influence or dependency

LAYOUT RULES:
- Maintain strict visual hierarchy through size and weight, not color intensity
- Equal spacing between sibling nodes
- Branches should not overlap or cross each other
- White space is used generously — the map should breathe
- Overall structure should feel like a well-organized org chart or knowledge taxonomy

COLORS: Muted, desaturated, professional palette. Think corporate presentation, not children's art. [Specify 4-6 muted colors.] Use color primarily for branch differentiation, not decoration. Gray (#666) for all body text. Darker shade for headers.

TYPOGRAPHY:
- All text in clean sans-serif (Helvetica/Arial/Roboto style)
- Center: 18-20pt bold, white
- Level 1: 14pt bold, dark charcoal
- Level 2: 11-12pt regular, dark gray
- Level 3: 10pt regular, medium gray
- NO hand-drawn, script, or decorative fonts anywhere
- All text horizontal, left-aligned within nodes

OVERALL FEEL: Professional, structured, corporate-ready. Like a screenshot from XMind Pro or MindMeister in "business" theme. Information-dense but well-organized. Could be dropped into a board presentation or strategy document without modification. Clean lines, muted colors, clear hierarchy. The focus is on the DATA and RELATIONSHIPS, not visual flair.
```
