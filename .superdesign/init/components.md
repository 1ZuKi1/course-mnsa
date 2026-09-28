# Components (vanilla HTML/CSS/JS, no framework)
Single-file app: `index.html` (CSS lines 25-1744, markup 1747-2149, JS 2150-3151). No component library; "components" are CSS classes + JS template strings.
Extracted sources for context: `src/styles.css` (all CSS), `src/markup.html` (static markup: nav, hero, modals, review form), `src/render.js` (course card + review card templates, verdict chips).

- `.btn`, `.btn-primary`, `.btn-sm`, `.btn-ghost`, `.btn-ghost-danger` — pill buttons (radius 999px)
- `.course-card` — course grid card: name + credits pill, meta line (teacher · English name · semester), rating (star + avg + count), category tag, "✓ Үнэлсэн" tag, chevron
- `.review-item` — review card: author name/date/term, verdict chips (`.verdict-good|mid|bad`), info-block (exam/homework key-value rows), `.tip` comment, edit/delete actions
- `.review-form` — 3 range sliders (内容/作业量/给分 0–10), semester select, comment textarea, anonymous checkbox, collapsible details panel with toggle switches (期中/期末/作业/考勤/小组作业/大作业) that reveal text inputs, grading ratio input, submit
- `.modal`, `.modal-overlay`, `.close-btn` — centered modals (course detail, login 2-step, add course)
- `.search-box`, `.tag`, `.badge`, `.role-badge`, `.toast`, `.empty-state`, `.spinner`, `.switch`

Full source: see `src/render.js` (templates) and `src/styles.css`.
